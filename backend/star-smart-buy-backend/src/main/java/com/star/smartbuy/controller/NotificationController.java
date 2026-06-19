package com.star.smartbuy.controller;

import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.Notification;
import com.star.smartbuy.mapper.NotificationMapper;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.Map;

/**
 * 通知控制器
 */
@RestController
@RequestMapping("/admin/notifications")
public class NotificationController {

    @Resource
    private NotificationMapper notificationMapper;

    /**
     * 获取未读通知数量
     */
    @GetMapping("/unread-count")
    public Result<Map<String, Object>> getUnreadCount(@RequestParam Long receiverId) {
        Long count = notificationMapper.countUnread(receiverId);
        return Result.success(Map.of("count", count));
    }

    /**
     * 获取通知列表（分页）
     */
    @GetMapping
    public Result<PageResult<Notification>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam Long receiverId) {

        Page<Notification> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Notification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Notification::getReceiverId, receiverId);
        wrapper.orderByDesc(Notification::getCreatedAt);

        return Result.success(PageResult.of(notificationMapper.selectPage(pageParam, wrapper)));
    }

    /**
     * 标记为已读
     */
    @PutMapping("/{id}/read")
    public Result<Void> markAsRead(@PathVariable Long id) {
        Notification notification = notificationMapper.selectById(id);
        if (notification != null) {
            notification.setReadStatus(1);
            notificationMapper.updateById(notification);
        }
        return Result.success();
    }

    /**
     * 全部标记为已读
     */
    @PutMapping("/read-all")
    public Result<Void> markAllAsRead(@RequestParam Long receiverId) {
        LambdaQueryWrapper<Notification> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(Notification::getReceiverId, receiverId);
        wrapper.eq(Notification::getReadStatus, 0);

        Notification notification = new Notification();
        notification.setReadStatus(1);
        notificationMapper.update(notification, wrapper);
        return Result.success();
    }

    /**
     * 删除通知
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        notificationMapper.deleteById(id);
        return Result.success();
    }
}
