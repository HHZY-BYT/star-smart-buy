package com.star.smartbuy.annotation;

import java.lang.annotation.*;

/**
 * 操作日志注解
 * 标注在Controller方法上，自动记录操作日志
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface OperLog {

    /** 操作模块 */
    String module() default "OTHER";

    /** 操作类型 */
    String type() default "OTHER";

    /** 操作描述 (支持SpEL表达式: #id, #product.name 等) */
    String description() default "";
}
