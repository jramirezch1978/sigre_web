package com.sigre.rrhh;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class RrhhApplication {
    public static void main(String[] args) {
        SpringApplication.run(RrhhApplication.class, args);
        System.out.println("╔════════════════════════════════════════╗");
        System.out.println("║  SIGRE 2.0 - RRHH Service              ║");
        System.out.println("║  Puerto: 8085                          ║");
        System.out.println("╚════════════════════════════════════════╝");
    }
}

