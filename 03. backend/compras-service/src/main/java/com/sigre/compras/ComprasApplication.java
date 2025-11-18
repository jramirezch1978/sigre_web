package com.sigre.compras;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class ComprasApplication {
    public static void main(String[] args) {
        SpringApplication.run(ComprasApplication.class, args);
        System.out.println("SIGRE 2.0 - Compras Service - Puerto: 8089");
    }
}

