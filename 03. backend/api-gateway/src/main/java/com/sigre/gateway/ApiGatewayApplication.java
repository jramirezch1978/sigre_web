package com.sigre.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

/**
 * API Gateway - Puerta de Entrada Única
 * Puerto: 8080
 * 
 * Gateway de entrada único para todos los microservicios SIGRE 2.0
 * Responsable de:
 * - Enrutamiento de peticiones
 * - Validación de JWT
 * - Rate limiting
 * - CORS
 * - Logging de requests
 */
@SpringBootApplication
@EnableDiscoveryClient
public class ApiGatewayApplication {

    public static void main(String[] args) {
        SpringApplication.run(ApiGatewayApplication.class, args);
        System.out.println("╔════════════════════════════════════════╗");
        System.out.println("║  SIGRE 2.0 - API Gateway               ║");
        System.out.println("║  Puerta de Entrada Iniciada           ║");
        System.out.println("║  URL: http://localhost:8080            ║");
        System.out.println("╚════════════════════════════════════════╝");
    }
}

