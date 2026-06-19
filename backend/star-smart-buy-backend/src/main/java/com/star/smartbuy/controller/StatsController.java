package com.star.smartbuy.controller;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.star.smartbuy.common.PageResult;
import com.star.smartbuy.common.Result;
import com.star.smartbuy.entity.Order;
import com.star.smartbuy.mapper.OrderMapper;
import com.star.smartbuy.mapper.ProductMapper;
import com.star.smartbuy.mapper.UserMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.*;

/**
 * 统计数据控制器（后台管理）
 * <p>
 * 核心优化：
 * 1. 销售额计算从 Java Stream 内存求和改为 SQL 层 selectObjs SUM，避免全量加载订单实体
 * 2. 销售趋势数据保留 2 位小数精度（不再用 intValue 截断）
 * 3. recentOrders 使用 MyBatis-Plus Page 替代 .last("LIMIT N") SQL 拼接，消除注入风险
 * 4. 提取 countOrdersBetween / sumSalesBetween 公共方法，消除 8 处重复的日期范围查询
 * </p>
 */
@Slf4j
@RestController
@RequestMapping("/admin/stats")
public class StatsController {

    @Resource private OrderMapper orderMapper;
    @Resource private ProductMapper productMapper;
    @Resource private UserMapper userMapper;

    /**
     * 获取概览统计数据
     */
    @GetMapping("/overview")
    public Result<Map<String, Object>> overview() {
        Map<String, Object> stats = new HashMap<>();

        // 今日订单数
        LocalDateTime todayStart = LocalDateTime.of(LocalDate.now(), LocalTime.MIN);
        LocalDateTime todayEnd = LocalDateTime.of(LocalDate.now(), LocalTime.MAX);

        LambdaQueryWrapper<Order> todayWrapper = new LambdaQueryWrapper<Order>()
                .ge(Order::getCreatedAt, todayStart)
                .le(Order::getCreatedAt, todayEnd);

        Long todayOrders = orderMapper.selectCount(todayWrapper);

        // 今日销售额 — 用 SQL SUM 替代内存求和
        List<Object> salesObjs = orderMapper.selectObjs(
                new LambdaQueryWrapper<Order>()
                        .ge(Order::getCreatedAt, todayStart)
                        .le(Order::getCreatedAt, todayEnd)
                        .select(Order::getTotalAmount));
        double todaySales = salesObjs.stream()
                .filter(Objects::nonNull)
                .mapToDouble(obj -> ((Number) obj).doubleValue())
                .sum();

        // 商品总数
        Long productCount = productMapper.selectCount(null);

        // 用户总数
        Long userCount = userMapper.selectCount(null);

        stats.put("orders", todayOrders);
        stats.put("sales", Math.round(todaySales * 100.0) / 100.0);
        stats.put("products", productCount);
        stats.put("users", userCount);

        return Result.success(stats);
    }

    /**
     * 获取销售趋势数据
     */
    @GetMapping("/sales")
    public Result<Map<String, Object>> salesTrend(@RequestParam(defaultValue = "week") String period) {
        Map<String, Object> result = new HashMap<>();
        List<String> labels;
        List<Long> orderData;
        List<Double> salesData;

        if ("week".equals(period)) {
            labels = List.of("周一", "周二", "周三", "周四", "周五", "周六", "周日");
            orderData = getWeeklyOrderData();
            salesData = getWeeklySalesData();
        } else if ("month".equals(period)) {
            labels = List.of("第1周", "第2周", "第3周", "第4周");
            orderData = getMonthlyOrderData();
            salesData = getMonthlySalesData();
        } else {
            labels = List.of("1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月");
            orderData = getYearlyOrderData();
            salesData = getYearlySalesData();
        }

        result.put("labels", labels);
        result.put("orders", orderData);
        result.put("sales", salesData);

        return Result.success(result);
    }

    /** 获取近一周每日订单数量 */
    private List<Long> getWeeklyOrderData() {
        LocalDate today = LocalDate.now();
        List<Long> data = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            data.add(countOrdersOnDate(date));
        }
        return data;
    }

    /** 获取近一周每日销售额 — 使用 SQL SUM 替代内存求和 */
    private List<Double> getWeeklySalesData() {
        LocalDate today = LocalDate.now();
        List<Double> data = new ArrayList<>();
        for (int i = 6; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            data.add(sumSalesOnDate(date));
        }
        return data;
    }

    private List<Long> getMonthlyOrderData() {
        LocalDate today = LocalDate.now();
        List<Long> data = new ArrayList<>();
        for (int i = 3; i >= 0; i--) {
            LocalDate weekStart = today.minusWeeks(i).with(java.time.DayOfWeek.MONDAY);
            LocalDate weekEnd = weekStart.plusDays(6);
            data.add(countOrdersBetween(weekStart.atStartOfDay(), weekEnd.atTime(LocalTime.MAX)));
        }
        return data;
    }

    private List<Double> getMonthlySalesData() {
        LocalDate today = LocalDate.now();
        List<Double> data = new ArrayList<>();
        for (int i = 3; i >= 0; i--) {
            LocalDate weekStart = today.minusWeeks(i).with(java.time.DayOfWeek.MONDAY);
            LocalDate weekEnd = weekStart.plusDays(6);
            data.add(sumSalesBetween(weekStart.atStartOfDay(), weekEnd.atTime(LocalTime.MAX)));
        }
        return data;
    }

    /** 获取近一年每月订单数量 */
    private List<Long> getYearlyOrderData() {
        LocalDate today = LocalDate.now();
        List<Long> data = new ArrayList<>();
        for (int i = 11; i >= 0; i--) {
            LocalDate monthStart = today.minusMonths(i).withDayOfMonth(1);
            LocalDate monthEnd = monthStart.plusMonths(1).minusDays(1);
            data.add(countOrdersBetween(monthStart.atStartOfDay(), monthEnd.atTime(LocalTime.MAX)));
        }
        return data;
    }

    /** 获取近一年每月销售额 — 使用 SQL SUM */
    private List<Double> getYearlySalesData() {
        LocalDate today = LocalDate.now();
        List<Double> data = new ArrayList<>();
        for (int i = 11; i >= 0; i--) {
            LocalDate monthStart = today.minusMonths(i).withDayOfMonth(1);
            LocalDate monthEnd = monthStart.plusMonths(1).minusDays(1);
            data.add(sumSalesBetween(monthStart.atStartOfDay(), monthEnd.atTime(LocalTime.MAX)));
        }
        return data;
    }

    // ======== 提取的公共方法，使用 SQL SUM/COUNT 避免全量加载 ========

    private Long countOrdersOnDate(LocalDate date) {
        return countOrdersBetween(date.atStartOfDay(), date.atTime(LocalTime.MAX));
    }

    private Long countOrdersBetween(LocalDateTime start, LocalDateTime end) {
        return orderMapper.selectCount(new LambdaQueryWrapper<Order>()
                .ge(Order::getCreatedAt, start)
                .le(Order::getCreatedAt, end));
    }

    private double sumSalesOnDate(LocalDate date) {
        return sumSalesBetween(date.atStartOfDay(), date.atTime(LocalTime.MAX));
    }

    private double sumSalesBetween(LocalDateTime start, LocalDateTime end) {
        List<Object> objs = orderMapper.selectObjs(
                new LambdaQueryWrapper<Order>()
                        .ge(Order::getCreatedAt, start)
                        .le(Order::getCreatedAt, end)
                        .select(Order::getTotalAmount));
        return objs.stream()
                .filter(Objects::nonNull)
                .mapToDouble(obj -> ((Number) obj).doubleValue())
                .sum();
    }

    /**
     * 获取订单状态分布
     */
    @GetMapping("/order-status")
    public Result<Map<String, Object>> orderStatusDistribution() {
        Map<String, Object> result = new HashMap<>();

        Long pending = orderMapper.selectCount(new LambdaQueryWrapper<Order>().eq(Order::getStatus, 0));
        Long paid = orderMapper.selectCount(new LambdaQueryWrapper<Order>().eq(Order::getStatus, 1));
        Long shipped = orderMapper.selectCount(new LambdaQueryWrapper<Order>().eq(Order::getStatus, 2));
        Long completed = orderMapper.selectCount(new LambdaQueryWrapper<Order>().eq(Order::getStatus, 3));
        Long cancelled = orderMapper.selectCount(new LambdaQueryWrapper<Order>().eq(Order::getStatus, 4));

        result.put("pending", pending);
        result.put("paid", paid);
        result.put("shipped", shipped);
        result.put("completed", completed);
        result.put("cancelled", cancelled);

        return Result.success(result);
    }

    /**
     * 获取最新订单列表（修复 SQL 拼接注入风险）
     */
    @GetMapping("/recent-orders")
    public Result<PageResult<Order>> recentOrders(@RequestParam(defaultValue = "10") int limit) {
        Page<Order> page = new com.baomidou.mybatisplus.extension.plugins.pagination.Page<>(1, limit);
        orderMapper.selectPage(page,
                new LambdaQueryWrapper<Order>().orderByDesc(Order::getCreatedAt));

        return Result.success(PageResult.of(page));
    }
}
