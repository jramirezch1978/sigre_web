package com.sigre.flota;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class FlotaApplication {
    public static void main(String[] args) {
        SpringApplication.run(FlotaApplication.class, args);
        System.out.println("SIGRE 2.0 - Flota Service - Puerto: 8087");
    }
}

