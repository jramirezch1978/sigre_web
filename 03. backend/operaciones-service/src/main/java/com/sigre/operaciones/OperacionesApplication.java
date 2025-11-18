package com.sigre.operaciones;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class OperacionesApplication {
    public static void main(String[] args) {
        SpringApplication.run(OperacionesApplication.class, args);
        System.out.println("SIGRE 2.0 - Operaciones Service - Puerto: 8094");
    }
}

