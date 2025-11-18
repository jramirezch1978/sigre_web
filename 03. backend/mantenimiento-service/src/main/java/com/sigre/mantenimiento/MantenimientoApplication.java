package com.sigre.mantenimiento;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class MantenimientoApplication {
    public static void main(String[] args) {
        SpringApplication.run(MantenimientoApplication.class, args);
        System.out.println("SIGRE 2.0 - Mantenimiento Service - Puerto: 8093");
    }
}

