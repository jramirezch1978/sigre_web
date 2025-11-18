package com.sigre.auditoria;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class AuditoriaApplication {
    public static void main(String[] args) {
        SpringApplication.run(AuditoriaApplication.class, args);
        System.out.println("SIGRE 2.0 - Auditoría Service - Puerto: 8097");
    }
}

