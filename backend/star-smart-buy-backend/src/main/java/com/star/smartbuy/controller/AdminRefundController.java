package com.star.smartbuy.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.star.smartbuy.annotation.OperLog;
import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.Refund;
import com.star.smartbuy.mapper.RefundMapper;
import com.star.smartbuy.service.RefundService;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.Map;

/**
 * 管理员 - 退款/售后控制器
 */
@RestController
@RequestMapping("/admin/refunds")
public class AdminRefundController {

    @Resource private RefundMapper refundMapper;
    @Resource private RefundService refundService;

    /** 退款列表（分页） */
    @GetMapping
    public Result<PageResult<Refund>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String orderNo) {

        Page<Refund> pageParam = new Page<>(page, size);
        LambdaQueryWrapper<Refund> wrapper = new LambdaQueryWrapper<>();

        if (status != null) {
            wrapper.eq(Refund::getStatus, status);
        }
        if (orderNo != null && !orderNo.isEmpty()) {
            wrapper.like(Refund::getOrderNo, orderNo);
        }

        wrapper.orderByDesc(Refund::getCreatedAt);
        return Result.success(PageResult.of(refundMapper.selectPage(pageParam, wrapper)));
    }

    /** 退款详情 */
    @GetMapping("/{id}")
    public Result<Refund> detail(@PathVariable Long id) {
        Refund refund = refundMapper.selectById(id);
        if (refund == null) {
            return Result.error("退款记录不存在");
        }
        return Result.success(refund);
    }

    /** 处理退款（走 Service 层，确保事务） */
    @PutMapping("/{id}/process")
    @OperLog(module = "REFUND", type = "UPDATE", description = "处理退款")
    public Result<Void> process(@PathVariable Long id, @RequestBody Map<String, Object> data) {
        String reason = data.get("reason") != null ? (String) data.get("reason") : null;
        refundService.processRefund(id, reason);
        return Result.success();
    }

    /** 拒绝退款 */
    @PutMapping("/{id}/reject")
    @OperLog(module = "REFUND", type = "UPDATE", description = "拒绝退款")
    public Result<Void> reject(@PathVariable Long id, @RequestBody Map<String, Object> data) {
        String reason = data.get("reason") != null ? (String) data.get("reason") : null;
        if (reason == null || reason.isEmpty()) {
            return Result.error("请填写拒绝原因");
        }
        refundService.rejectRefund(id, reason);
        return Result.success();
    }

    /** 退款统计 */
    @GetMapping("/stats")
    public Result<Map<String, Object>> stats() {
        return Result.success(refundService.getRefundStats());
    }
}
