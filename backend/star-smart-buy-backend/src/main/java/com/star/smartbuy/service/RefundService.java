package com.star.smartbuy.service;

import java.util.Map;

/**
 * 退款服务接口
 */
public interface RefundService {

    /** 处理退款（同意） — 整合退款状态更新 + 订单状态更新 + 库存恢复 */
    void processRefund(Long refundId, String reason);

    /** 拒绝退款 */
    void rejectRefund(Long refundId, String reason);

    /** 退款统计 */
    Map<String, Object> getRefundStats();
}
