package com.star.smartbuy.aspect;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.star.smartbuy.annotation.OperLog;
import com.star.smartbuy.entity.Admin;
import com.star.smartbuy.entity.OperationLog;
import com.star.smartbuy.entity.User;
import com.star.smartbuy.mapper.AdminMapper;
import com.star.smartbuy.mapper.OperationLogMapper;
import com.star.smartbuy.mapper.UserMapper;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import lombok.extern.slf4j.Slf4j;

import java.lang.reflect.Method;
import java.time.LocalDateTime;

/**
 * 操作日志切面
 * <p>
 * 通过 AOP 自动拦截标注了 {@link com.star.smartbuy.annotation.OperLog} 注解的方法，
 * 记录操作人、请求路径、入参、出参、耗时、异常信息到 operation_log 表。
 * </p>
 *
 * @author StarSmart Buy Team
 * @since 1.0
 */
@Slf4j
@Aspect
@Component
public class LogAspect {

    /** 操作日志Mapper */
    @Resource
    private OperationLogMapper operationLogMapper;

    /** 管理员Mapper */
    @Resource
    private AdminMapper adminMapper;

    /** 用户Mapper */
    @Resource
    private UserMapper userMapper;

    /** JSON序列化工具 */
    private final ObjectMapper objectMapper = new ObjectMapper();

    /** 环绕通知，拦截标注了@OperLog注解的方法并记录操作日志 */
    @Around("@annotation(com.star.smartbuy.annotation.OperLog)")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        long startTime = System.currentTimeMillis();

        OperationLog Log = new OperationLog();
        Object result = null;
        Exception exception = null;

        try {
            // 获取请求信息
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
            if (attributes != null) {
                HttpServletRequest request = attributes.getRequest();
                fillRequestInfo(Log, request);
                fillOperatorInfo(Log, request);
            }

            // 获取注解信息
            MethodSignature signature = (MethodSignature) point.getSignature();
            Method method = signature.getMethod();
            OperLog operLog = method.getAnnotation(OperLog.class);
            Log.setModule(operLog.module());
            Log.setOperationType(operLog.type());
            Log.setDescription(operLog.description());

            // 获取方法信息
            Log.setMethod(point.getTarget().getClass().getName() + "." + method.getName());

            // 获取请求参数
            try {
                Object[] args = point.getArgs();
                String params = objectMapper.writeValueAsString(args);
                // 限制参数长度，防止过大的请求体
                if (params.length() > 2000) {
                    params = params.substring(0, 2000) + "...(truncated)";
                }
                Log.setRequestParams(params);
            } catch (Exception e) {
                Log.setRequestParams("参数序列化失败");
            }

            // 执行目标方法
            result = point.proceed();
            Log.setStatus(1);

        } catch (Exception e) {
            exception = e;
            Log.setStatus(0);
            String errorMsg = e.getMessage();
            if (errorMsg != null && errorMsg.length() > 2000) {
                errorMsg = errorMsg.substring(0, 2000) + "...(truncated)";
            }
            Log.setErrorMsg(errorMsg);
        }

        // 计算耗时
        Log.setCostTime(System.currentTimeMillis() - startTime);
        Log.setCreatedAt(LocalDateTime.now());

        // 获取返回结果
        try {
            if (result != null) {
                String resultStr = objectMapper.writeValueAsString(result);
                if (resultStr.length() > 2000) {
                    resultStr = resultStr.substring(0, 2000) + "...(truncated)";
                }
                Log.setResponseResult(resultStr);
            }
        } catch (Exception e) {
            Log.setResponseResult("结果序列化失败");
        }

        // 异步保存日志（不影响业务主流程）
        try {
            operationLogMapper.insert(Log);
        } catch (Exception e) {
            // 日志保存失败不影响业务
            log.error("操作日志保存失败: {}", e.getMessage(), e);
        }

        // 如果有异常，重新抛出
        if (exception != null) {
            throw exception;
        }

        return result;
    }

    /** 填充请求信息 */
    private void fillRequestInfo(OperationLog log, HttpServletRequest request) {
        log.setRequestUrl(request.getRequestURI());
        log.setRequestMethod(request.getMethod());
        log.setIp(getIpAddress(request));
        log.setUserAgent(request.getHeader("User-Agent"));
    }

    /** 填充操作人信息 */
    private void fillOperatorInfo(OperationLog log, HttpServletRequest request) {
        try {
            Object userIdAttr = request.getAttribute("userId");
            Object roleAttr = request.getAttribute("role");

            if (userIdAttr != null) {
                Long userId = Long.valueOf(userIdAttr.toString());
                log.setOperatorId(userId);

                String role = roleAttr != null ? roleAttr.toString() : "USER";
                log.setOperatorType(role);

                // 查询操作人名称
                String name = null;
                if ("ADMIN".equals(role)) {
                    Admin admin = adminMapper.selectById(userId);
                    if (admin != null) {
                        name = admin.getUsername();
                    }
                } else {
                    User user = userMapper.selectById(userId);
                    if (user != null) {
                        name = user.getNickname() != null ? user.getNickname() : user.getPhone();
                    }
                }
                log.setOperatorName(name != null ? name : "未知用户");
            } else {
                log.setOperatorName("匿名用户");
                log.setOperatorType("ANONYMOUS");
            }
        } catch (Exception e) {
            log.setOperatorName("未知用户");
            log.setOperatorType("UNKNOWN");
        }
    }

    /** 获取真实IP地址 */
    private String getIpAddress(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        // 多个代理时取第一个
        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }
        // IPv6回环地址转为IPv4格式
        if ("0:0:0:0:0:0:0:1".equals(ip) || "::1".equals(ip)) {
            ip = "127.0.0.1";
        }
        return ip;
    }
}
