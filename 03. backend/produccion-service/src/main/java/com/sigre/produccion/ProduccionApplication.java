package com.sigre.produccion;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class ProduccionApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProduccionApplication.class, args);
        System.out.println("SIGRE 2.0 - Producción Service - Puerto: 8086");
    }
}

