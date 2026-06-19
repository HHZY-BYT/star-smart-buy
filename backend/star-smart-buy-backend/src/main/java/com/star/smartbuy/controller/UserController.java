package com.star.smartbuy.controller;

import com.star.smartbuy.common.Result;
import com.star.smartbuy.dto.AdminLoginDTO;
import com.star.smartbuy.dto.UserLoginDTO;
import com.star.smartbuy.entity.Admin;
import com.star.smartbuy.entity.User;
import com.star.smartbuy.interceptor.JwtUtil;
import com.star.smartbuy.mapper.AdminMapper;
import com.star.smartbuy.mapper.UserMapper;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

/**
 * 用户控制器
 * <p>
 * 提供微信登录、手机号验证码登录、用户信息管理、账户注销等功能。
 * 验证码目前为模拟模式，生产环境需接入短信 SDK。
 * </p>
 *
 * @author StarSmart Buy Team
 * @since 1.0
 */
@RestController
@RequestMapping("/user")
public class UserController {

    @Resource private UserMapper userMapper;
    @Resource private JwtUtil jwtUtil;

    /** 内存存储验证码（生产环境应替换为 Redis） */
    private static final Map<String, String> verifyCodeMap = new ConcurrentHashMap<>();
    /** 模拟验证码 */
    private static final String MOCK_VERIFY_CODE = "123456";

    /**
     * 微信登录
     * <p>
     * 通过微信 openid 查找已有用户，不存在则自动注册。
     * 返回 JWT token 和用户信息。
     * </p>
     *
     * @param dto 包含 openid 和可选 phone 的登录请求
     * @return 包含 token、userId、nickname、avatar、phone 的 Map
     */
    @PostMapping("/login")
    public Result<Map<String, Object>> login(@RequestBody UserLoginDTO dto) {
        User user = userMapper.selectOne(
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<User>()
                        .eq(User::getOpenid, dto.getOpenid()));
        if (user == null) {
            user = new User();
            user.setOpenid(dto.getOpenid());
            user.setPhone(dto.getPhone());
            user.setNickname("用户" + System.currentTimeMillis() % 10000);
            user.setAvatar("/images/default-avatar.png");
            user.setCreatedAt(LocalDateTime.now());
            userMapper.insert(user);
        }

        String token = jwtUtil.generateToken(user.getId(), "user");

        Map<String, Object> data = new HashMap<>();
        data.put("token", token);
        data.put("userId", user.getId());
        data.put("nickname", user.getNickname());
        data.put("avatar", user.getAvatar());
        data.put("phone", user.getPhone());
        return Result.success(data);
    }

    /**
     * 发送验证码（模拟）
     * <p>
     * 校验手机号格式和是否已注册，返回固定验证码 {@value #MOCK_VERIFY_CODE}。
     * 生产环境需替换为真实短信发送 + Redis 存储。
     * </p>
     *
     * @param data 包含 phone 字段的请求体
     * @return 包含 verifyCode 和提示 message 的 Map
     */
    @PostMapping("/send-verify-code")
    public Result<Map<String, Object>> sendVerifyCode(@RequestBody Map<String, String> data) {
        String phone = data.get("phone");
        
        if (phone == null || phone.isEmpty()) {
            return Result.error("手机号不能为空");
        }

        if (!phone.matches("^1[3-9]\\d{9}$")) {
            return Result.error("手机号格式不正确");
        }

        User user = userMapper.selectOne(
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<User>()
                        .eq(User::getPhone, phone));
        
        if (user == null) {
            return Result.error("该手机号未注册，请使用微信登录");
        }

        String verifyCode = MOCK_VERIFY_CODE;
        verifyCodeMap.put(phone, verifyCode);

        Map<String, Object> result = new HashMap<>();
        result.put("verifyCode", verifyCode);
        result.put("message", "验证码已发送（模拟验证码：123456）");
        return Result.success(result);
    }

    /**
     * 手机号验证码登录
     * <p>
     * 仅限已注册用户。先校验手机号格式和验证码（支持模拟码 {@value #MOCK_VERIFY_CODE}），
     * 验证通过后返回 JWT token。
     * </p>
     *
     * @param data 包含 phone 和 verifyCode 的请求体
     * @return 包含 token、userId、nickname、avatar、phone 的 Map
     */
    @PostMapping("/login-by-phone")
    public Result<Map<String, Object>> loginByPhone(@RequestBody Map<String, String> data) {
        String phone = data.get("phone");
        String verifyCode = data.get("verifyCode");
        
        if (phone == null || phone.isEmpty()) {
            return Result.error("手机号不能为空");
        }

        if (verifyCode == null || verifyCode.isEmpty()) {
            return Result.error("验证码不能为空");
        }

        if (!phone.matches("^1[3-9]\\d{9}$")) {
            return Result.error("手机号格式不正确");
        }

        if (verifyCode.length() != 6) {
            return Result.error("验证码必须是6位");
        }

        User user = userMapper.selectOne(
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<User>()
                        .eq(User::getPhone, phone));
        
        if (user == null) {
            return Result.error("该手机号未注册，请使用微信登录");
        }

        String storedCode = verifyCodeMap.get(phone);
        if (storedCode == null || !storedCode.equals(verifyCode)) {
            if (!verifyCode.equals(MOCK_VERIFY_CODE)) {
                return Result.error("验证码错误");
            }
        }

        verifyCodeMap.remove(phone);

        String token = jwtUtil.generateToken(user.getId(), "user");

        Map<String, Object> result = new HashMap<>();
        result.put("token", token);
        result.put("userId", user.getId());
        result.put("nickname", user.getNickname());
        result.put("avatar", user.getAvatar());
        result.put("phone", user.getPhone());
        return Result.success(result);
    }

    /**
     * 获取当前登录用户信息
     *
     * @param userId 由 JWT 拦截器注入的用户 ID
     * @return 用户实体，不存在时返回错误
     */
    @GetMapping("/info")
    public Result<User> getUserInfo(@RequestAttribute("userId") Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }
        return Result.success(user);
    }

    /**
     * 更新用户信息
     * <p>
     * 支持部分更新，只修改传入的字段（nickname、avatar、phone）。
     * </p>
     *
     * @param userId 由 JWT 拦截器注入的用户 ID
     * @param data  可包含 nickname、avatar、phone 的请求体
     * @return 更新后的用户实体
     */
    @PostMapping("/update")
    public Result<User> updateUserInfo(@RequestAttribute("userId") Long userId, @RequestBody Map<String, Object> data) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }

        if (data.containsKey("nickname")) {
            user.setNickname((String) data.get("nickname"));
        }
        if (data.containsKey("avatar")) {
            user.setAvatar((String) data.get("avatar"));
        }
        if (data.containsKey("phone")) {
            user.setPhone((String) data.get("phone"));
        }
        user.setUpdatedAt(LocalDateTime.now());

        userMapper.updateById(user);
        return Result.success(user);
    }

    /**
     * 绑定/修改手机号
     *
     * @param userId 由 JWT 拦截器注入的用户 ID
     * @param data  包含 phone 字段的请求体
     * @return 更新后的用户实体
     */
    @PostMapping("/bind-phone")
    public Result<User> bindPhone(@RequestAttribute("userId") Long userId, @RequestBody Map<String, Object> data) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            return Result.error("用户不存在");
        }

        String phone = (String) data.get("phone");
        if (phone == null || phone.isEmpty()) {
            return Result.error("手机号不能为空");
        }

        user.setPhone(phone);
        user.setUpdatedAt(LocalDateTime.now());
        userMapper.updateById(user);
        return Result.success(user);
    }

    /**
     * 用户注销（物理删除账户）
     * <p>
     * 此操作不可恢复，会从数据库删除该用户的记录。
     * </p>
     *
     * @param userId 由 JWT 拦截器注入的用户 ID
     * @return 空数据表示成功
     */
    @DeleteMapping("/delete")
    public Result<Void> deleteAccount(@RequestAttribute("userId") Long userId) {
        userMapper.deleteById(userId);
        return Result.success();
    }
}