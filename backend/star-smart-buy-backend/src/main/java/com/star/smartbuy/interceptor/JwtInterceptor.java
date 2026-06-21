package com.star.smartbuy.interceptor;

import io.jsonwebtoken.Claims;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.annotation.Resource;

/**
 * JWT 拦截器
 */
@Component
public class JwtInterceptor implements HandlerInterceptor {

    /** JWT工具类 */
    @Resource
    private JwtUtil jwtUtil;

    /**
     * 判断是否为公开的商品评价查看请求
     * GET /review/{productId}（productId 为纯数字）允许未登录访问
     */
    private boolean isPublicReviewRequest(HttpServletRequest request) {
        if (!"GET".equalsIgnoreCase(request.getMethod())) {
            return false;
        }
        String uri = request.getRequestURI();
        // 匹配 /review/ 后跟纯数字（例如 /review/123），不匹配 /review/my
        return uri.matches(".*/review/\\d+$");
    }

    /** 请求预处理，校验JWT令牌 */
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 预检请求直接放行
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        String token = request.getHeader("Authorization");
        if (token == null || !token.startsWith("Bearer ")) {
            // 允许未登录查看商品评价：GET /review/{productId}（productId 为数字）
            if (isPublicReviewRequest(request)) {
                return true;
            }
            response.setStatus(401);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"message\":\"未登录\"}");
            return false;
        }

        try {
            token = token.substring(7);
            Claims claims = jwtUtil.parseToken(token);
            // 将用户信息存入请求属性，供 Controller 使用
            request.setAttribute("userId", jwtUtil.getUserId(claims));
            request.setAttribute("role", jwtUtil.getRole(claims));
            return true;
        } catch (Exception e) {
            response.setStatus(401);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"message\":\"Token无效或已过期\"}");
            return false;
        }
    }
}