package com.sigre.activofijo;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class ActivoFijoApplication {
    public static void main(String[] args) {
        SpringApplication.run(ActivoFijoApplication.class, args);
        System.out.println("SIGRE 2.0 - Activo Fijo Service - Puerto: 8096");
    }
}

