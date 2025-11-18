package com.sigre.discovery;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.server.EnableEurekaServer;

/**
 * Service Discovery - Eureka Server
 * Puerto: 8761
 * 
 * Servidor de registro y descubrimiento de servicios para SIGRE 2.0
 * Todos los microservicios se registran aquí para poder descubrirse entre sí
 */
@SpringBootApplication
@EnableEurekaServer
public class ServiceDiscoveryApplication {

    public static void main(String[] args) {
        SpringApplication.run(ServiceDiscoveryApplication.class, args);
        System.out.println("╔════════════════════════════════════════╗");
        System.out.println("║  SIGRE 2.0 - Service Discovery         ║");
        System.out.println("║  Eureka Server Iniciado                ║");
        System.out.println("║  Dashboard: http://localhost:8761      ║");
        System.out.println("╚════════════════════════════════════════╝");
    }
}

