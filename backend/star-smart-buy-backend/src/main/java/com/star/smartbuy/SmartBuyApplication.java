package com.star.smartbuy;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 星智购应用启动类
 */
@SpringBootApplication
@MapperScan("com.star.smartbuy.mapper")
public class SmartBuyApplication {

    /** 应用入口方法 */
    public static void main(String[] args) {
        SpringApplication.run(SmartBuyApplication.class, args);
    }
}
