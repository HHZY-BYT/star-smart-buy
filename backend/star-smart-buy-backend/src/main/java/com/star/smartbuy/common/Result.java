package com.star.smartbuy.common;

import lombok.Data;

/**
 * 统一响应结果
 */
@Data
public class Result<T> {

    /** 状态码 */
    private int code;
    /** 提示信息 */
    private String message;
    /** 响应数据 */
    private T data;

    /** 私有构造方法 */
    private Result() {}

    /** 成功响应（带数据） */
    public static <T> Result<T> success(T data) {
        Result<T> result = new Result<>();
        result.setCode(200);
        result.setMessage("success");
        result.setData(data);
        return result;
    }

    /** 成功响应（无数据） */
    public static <T> Result<T> success() {
        return success(null);
    }

    /** 错误响应（默认500状态码） */
    public static <T> Result<T> error(String message) {
        Result<T> result = new Result<>();
        result.setCode(500);
        result.setMessage(message);
        return result;
    }

    /** 错误响应（自定义状态码） */
    public static <T> Result<T> error(int code, String message) {
        Result<T> result = new Result<>();
        result.setCode(code);
        result.setMessage(message);
        return result;
    }
}