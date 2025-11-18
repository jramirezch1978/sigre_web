package com.sigre.comercializacion;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class ComercializacionApplication {
    public static void main(String[] args) {
        SpringApplication.run(ComercializacionApplication.class, args);
        System.out.println("SIGRE 2.0 - Comercialización Service - Puerto: 8088");
    }
}

