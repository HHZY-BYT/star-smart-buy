package com.star.smartbuy.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 用户登录请求
 */
@Data
public class UserLoginDTO {

    /** 微信授权码 */
    @NotBlank(message = "openid不能为空")
    private String openid;

    /** 手机号 */
    private String phone;
}