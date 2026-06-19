package com.star.smartbuy.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.OperationLog;
import com.star.smartbuy.mapper.OperationLogMapper;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.util.HashMap;
import java.util.Map;

/**
 * 操作日志管理控制器（后台管理）
 */
@RestController
@RequestMapping("/admin/logs")
public class AdminLogController {

    @Resource
    private OperationLogMapper operationLogMapper;

    /**
     * 日志列表（分页 + 筛选）
     */
    @GetMapping
    public Result<PageResult<OperationLog>> list(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "20") int size,
            @RequestParam(required = false) String module,
            @RequestParam(required = false) String operationType,
            @RequestParam(required = false) String operatorName,
            @RequestParam(required = false) Integer status,
            @RequestParam(required = false) String startDate,
            @RequestParam(required = false) String endDate) {

        LambdaQueryWrapper<OperationLog> wrapper = new LambdaQueryWrapper<>();

        if (module != null && !module.isEmpty()) {
            wrapper.eq(OperationLog::getModule, module);
        }
        if (operationType != null && !operationType.isEmpty()) {
            wrapper.eq(OperationLog::getOperationType, operationType);
        }
        if (operatorName != null && !operatorName.isEmpty()) {
            wrapper.like(OperationLog::getOperatorName, operatorName);
        }
        if (status != null) {
            wrapper.eq(OperationLog::getStatus, status);
        }
        if (startDate != null && !startDate.isEmpty()) {
            wrapper.ge(OperationLog::getCreatedAt, startDate + " 00:00:00");
        }
        if (endDate != null && !endDate.isEmpty()) {
            wrapper.le(OperationLog::getCreatedAt, endDate + " 23:59:59");
        }

        wrapper.orderByDesc(OperationLog::getCreatedAt);

        return Result.success(PageResult.of(operationLogMapper.selectPage(new Page<>(page, size), wrapper)));
    }

    /**
     * 日志详情
     */
    @GetMapping("/{id}")
    public Result<OperationLog> detail(@PathVariable Long id) {
        OperationLog operationLog = operationLogMapper.selectById(id);
        return Result.success(operationLog);
    }

    /**
     * 删除日志
     */
    @DeleteMapping("/{id}")
    public Result<Void> delete(@PathVariable Long id) {
        operationLogMapper.deleteById(id);
        return Result.success();
    }

    /**
     * 批量删除日志
     */
    @DeleteMapping("/batch")
    public Result<Void> batchDelete(@RequestBody Long[] ids) {
        for (Long id : ids) {
            operationLogMapper.deleteById(id);
        }
        return Result.success();
    }

    /**
     * 清空日志（保留最近N天）
     */
    @DeleteMapping("/clean")
    public Result<Map<String, Object>> clean(@RequestParam(defaultValue = "30") int keepDays) {
        LambdaQueryWrapper<OperationLog> wrapper = new LambdaQueryWrapper<>();
        // 计算截止日期
        java.time.LocalDateTime cutoff = java.time.LocalDateTime.now().minusDays(keepDays);
        wrapper.lt(OperationLog::getCreatedAt, cutoff);
        int deleted = operationLogMapper.delete(wrapper);

        Map<String, Object> result = new HashMap<>();
        result.put("deleted", deleted);
        return Result.success(result);
    }

    /**
     * 日志统计
     */
    @GetMapping("/stats")
    public Result<Map<String, Object>> stats() {
        Map<String, Object> stats = new HashMap<>();

        // 总数
        stats.put("total", operationLogMapper.selectCount(null));

        // 今日操作数
        LambdaQueryWrapper<OperationLog> todayWrapper = new LambdaQueryWrapper<>();
        todayWrapper.ge(OperationLog::getCreatedAt, java.time.LocalDate.now().atStartOfDay());
        stats.put("today", operationLogMapper.selectCount(todayWrapper));

        // 今日失败数
        LambdaQueryWrapper<OperationLog> todayFailWrapper = new LambdaQueryWrapper<>();
        todayFailWrapper.ge(OperationLog::getCreatedAt, java.time.LocalDate.now().atStartOfDay());
        todayFailWrapper.eq(OperationLog::getStatus, 0);
        stats.put("todayFail", operationLogMapper.selectCount(todayFailWrapper));

        return Result.success(stats);
    }
}
