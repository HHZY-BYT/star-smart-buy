package com.star.smartbuy.controller;

import com.star.smartbuy.annotation.OperLog;
import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.User;
import com.star.smartbuy.mapper.UserMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.HashMap;
import java.util.Map;

/**
 * 管理员 - 用户管理控制器
 */
@RestController
@RequestMapping("/admin/users")
public class AdminUserController {

    @Resource
    private UserMapper userMapper;

    /**
     * 用户列表（分页）
     */
    @GetMapping
    public Result<PageResult<User>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status) {

        Page<User> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<User> wrapper = new LambdaQueryWrapper<>();

        if (keyword != null && !keyword.isEmpty()) {
            wrapper.like(User::getNickname, keyword)
                   .or()
                   .like(User::getPhone, keyword);
        }
        if (status != null) {
            wrapper.eq(User::getStatus, status);
        }

        wrapper.orderByDesc(User::getCreatedAt);
        return Result.success(PageResult.of(userMapper.selectPage(pageParam, wrapper)));
    }

    /**
     * 用户详情
     */
    @GetMapping("/{id}")
    public Result<User> detail(@PathVariable Long id) {
        User user = userMapper.selectById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }
        return Result.success(user);
    }

    /**
     * 禁用/启用用户
     */
    @PutMapping("/{id}/status")
    @OperLog(module = "USER", type = "UPDATE", description = "修改用户状态")
    public Result<Void> updateStatus(@PathVariable Long id, @RequestParam Integer status) {
        User user = userMapper.selectById(id);
        if (user == null) {
            return Result.error("用户不存在");
        }
        user.setStatus(status);
        userMapper.updateById(user);
        return Result.success();
    }

    /**
     * 删除用户
     */
    @DeleteMapping("/{id}")
    @OperLog(module = "USER", type = "DELETE", description = "删除用户")
    public Result<Void> delete(@PathVariable Long id) {
        userMapper.deleteById(id);
        return Result.success();
    }

    /**
     * 用户统计
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> stats() {
        Long total = userMapper.selectCount(null);
        Long activeCount = userMapper.selectCount(
            new LambdaQueryWrapper<User>().eq(User::getStatus, 1)
        );
        
        LocalDateTime todayStart = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        LocalDateTime todayEnd = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);
        Long newToday = userMapper.selectCount(
            new LambdaQueryWrapper<User>().ge(User::getCreatedAt, todayStart)
                                         .le(User::getCreatedAt, todayEnd)
        );

        Long hasPhone = userMapper.selectCount(
            new LambdaQueryWrapper<User>().isNotNull(User::getPhone)
                                         .ne(User::getPhone, "")
        );

        Map<String, Object> stats = new HashMap<>();
        stats.put("total", total);
        stats.put("active", activeCount);
        stats.put("newToday", newToday);
        stats.put("hasPhone", hasPhone);

        return Result.success(stats);
    }
}
