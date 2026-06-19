package com.star.smartbuy.controller;

import com.star.smartbuy.annotation.OperLog;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.dto.AdminLoginDTO;
import com.star.smartbuy.entity.Admin;
import com.star.smartbuy.interceptor.JwtUtil;
import com.star.smartbuy.mapper.AdminMapper;
import jakarta.validation.Valid;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 管理员控制器（后台管理）
 */
@RestController
@RequestMapping("/admin")
public class AdminController {

    @Resource private AdminMapper adminMapper;
    @Resource private JwtUtil jwtUtil;
    @Resource private PasswordEncoder passwordEncoder;

    /** 管理员登录 */
    @PostMapping("/login")
    @OperLog(module = "SETTING", type = "LOGIN", description = "管理员登录")
    public Result<Map<String, Object>> login(@Valid @RequestBody AdminLoginDTO dto) {
        Admin admin = adminMapper.selectOne(
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Admin>()
                        .eq(Admin::getUsername, dto.getUsername()));
        if (admin == null || !passwordEncoder.matches(dto.getPassword(), admin.getPassword())) {
            return Result.error(401, "用户名或密码错误");
        }

        String token = jwtUtil.generateToken(admin.getId(), "admin");
        Map<String, Object> data = new HashMap<>();
        data.put("token", token);
        data.put("adminId", admin.getId());
        data.put("username", admin.getUsername());
        return Result.success(data);
    }

    /** 修改密码 */
    @PutMapping("/password")
    @OperLog(module = "SETTING", type = "UPDATE", description = "修改密码")
    public Result<Void> updatePassword(@RequestAttribute("userId") Long adminId,
                                       @RequestBody Map<String, String> data) {
        String oldPassword = data.get("oldPassword");
        String newPassword = data.get("newPassword");

        if (oldPassword == null || oldPassword.isEmpty()) {
            return Result.error("请输入当前密码");
        }
        if (newPassword == null || newPassword.isEmpty()) {
            return Result.error("请输入新密码");
        }
        if (newPassword.length() < 6) {
            return Result.error("新密码长度不能少于6位");
        }

        Admin admin = adminMapper.selectById(adminId);
        if (admin == null) {
            return Result.error("管理员不存在");
        }
        if (!passwordEncoder.matches(oldPassword, admin.getPassword())) {
            return Result.error("当前密码错误");
        }

        admin.setPassword(passwordEncoder.encode(newPassword));
        adminMapper.updateById(admin);
        return Result.success();
    }
}