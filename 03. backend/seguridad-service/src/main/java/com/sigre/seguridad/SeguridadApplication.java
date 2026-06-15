package com.sigre.seguridad;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration;
import org.springframework.scheduling.annotation.EnableAsync;

@EnableAsync
@SpringBootApplication(
        scanBasePackages = {"com.sigre.seguridad", "com.sigre.common"},
        exclude = {RedisAutoConfiguration.class}
)
public class SeguridadApplication {

    public static void main(String[] args) {
        SpringApplication.run(SeguridadApplication.class, args);
    }
}
