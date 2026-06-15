package com.sigre.auth;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration;
import org.springframework.scheduling.annotation.EnableAsync;

@EnableAsync
@SpringBootApplication(
        scanBasePackages = {"com.sigre.auth", "com.sigre.common"},
        exclude = {RedisAutoConfiguration.class}
)
public class AuthSecurityApplication {

    public static void main(String[] args) {
        SpringApplication.run(AuthSecurityApplication.class, args);
    }
}
