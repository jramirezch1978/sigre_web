package com.sigre.asistencia;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

@SpringBootApplication
@EnableDiscoveryClient
public class AsistenciaApplication {
    public static void main(String[] args) {
        SpringApplication.run(AsistenciaApplication.class, args);
        System.out.println("SIGRE 2.0 - Asistencia Service - Puerto: 8091");
    }
}

