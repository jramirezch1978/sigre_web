package com.sigre.seguridad;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

/**
 * Seguridad Service - Autenticación y Autorización
 * Puerto: 8081
 * 
 * Microservicio responsable de:
 * - Login/Logout
 * - Gestión de usuarios
 * - Roles y permisos
 * - Generación y validación de JWT
 * - Manejo de sesiones
 */
@SpringBootApplication
@EnableDiscoveryClient
public class SeguridadApplication {

    public static void main(String[] args) {
        SpringApplication.run(SeguridadApplication.class, args);
        System.out.println("╔════════════════════════════════════════╗");
        System.out.println("║  SIGRE 2.0 - Seguridad Service         ║");
        System.out.println("║  Autenticación Iniciada                ║");
        System.out.println("║  Puerto: 8081                          ║");
        System.out.println("║  Swagger: /swagger-ui.html             ║");
        System.out.println("╚════════════════════════════════════════╝");
    }
}

