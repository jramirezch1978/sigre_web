package com.sigre.presupuesto;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class PresupuestoApplication {
    public static void main(String[] args) {
        SpringApplication.run(PresupuestoApplication.class, args);
        System.out.println("SIGRE 2.0 - Presupuesto Service - Puerto: 8099");
    }
}

