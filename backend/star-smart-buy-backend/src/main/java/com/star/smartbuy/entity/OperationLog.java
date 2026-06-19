package com.star.smartbuy.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 操作日志实体
 */
@Data
@TableName("operation_log")
public class OperationLog {

    /** 主键ID */
    @TableId(type = IdType.AUTO)
    private Long id;

    /** 操作人ID */
    private Long operatorId;

    /** 操作人名称 */
    private String operatorName;

    /** 操作人类型: ADMIN-管理员, USER-用户 */
    private String operatorType;

    /** 操作类型: CREATE/UPDATE/DELETE/LOGIN/EXPORT/IMPORT/OTHER */
    private String operationType;

    /** 操作模块: PRODUCT/ORDER/USER/CATEGORY/BANNER/NOTICE/REVIEW/REFUND/SETTING/AI/OTHER */
    private String module;

    /** 操作描述 */
    private String description;

    /** 请求方法(类名.方法名) */
    private String method;

    /** 请求URL */
    private String requestUrl;

    /** HTTP请求方法 */
    private String requestMethod;

    /** 请求参数 */
    private String requestParams;

    /** 返回结果 */
    private String responseResult;

    /** IP地址 */
    private String ip;

    /** 操作地点 */
    private String location;

    /** 操作状态: 1-成功, 0-失败 */
    private Integer status;

    /** 错误信息 */
    private String errorMsg;

    /** 耗时(毫秒) */
    private Long costTime;

    /** 浏览器UA */
    private String userAgent;

    /** 创建时间 */
    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
