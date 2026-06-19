package com.star.smartbuy.common;

import lombok.Getter;

/**
 * 业务异常
 * <p>
 * 用于表示可预期的业务错误（如"商品不存在"、"库存不足"），
 * 由 GlobalExceptionHandler 统一捕获并返回 400 + 业务错误码。
 * </p>
 */
@Getter
public class BusinessException extends RuntimeException {

    /** 业务错误码（默认 500） */
    private final int code;

    /** 创建默认错误码(500)的业务异常 */
    public BusinessException(String message) {
        super(message);
        this.code = 500;
    }

    /** 创建自定义错误码的业务异常 */
    public BusinessException(int code, String message) {
        super(message);
        this.code = code;
    }
}
