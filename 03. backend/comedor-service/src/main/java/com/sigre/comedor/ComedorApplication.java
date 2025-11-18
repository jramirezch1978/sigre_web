package com.sigre.comedor;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class ComedorApplication {
    public static void main(String[] args) {
        SpringApplication.run(ComedorApplication.class, args);
        System.out.println("SIGRE 2.0 - Comedor Service - Puerto: 8092");
    }
}

