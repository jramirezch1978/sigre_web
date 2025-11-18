package com.sigre.contabilidad;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;

/**
 * Contabilidad Service - Hub Central del ERP
 * Puerto: 8082
 * 
 * Microservicio responsable de:
 * - Gestión de asientos contables
 * - Plan de cuentas
 * - Centros de costos
 * - Matrices contables (integración con otros módulos)
 * - Balance de comprobación
 * - Libros contables
 * - Cierre mensual/anual
 * 
 * IMPORTANTE: Este es el hub central que recibe pre-asientos de:
 * - Almacén (movimientos valorados)
 * - Finanzas (cuentas por pagar/cobrar)
 * - RRHH (planilla)
 * - Producción (costos)
 * - Ventas (facturación)
 */
@SpringBootApplication
@EnableDiscoveryClient
@EnableFeignClients
public class ContabilidadApplication {

    public static void main(String[] args) {
        SpringApplication.run(ContabilidadApplication.class, args);
        System.out.println("╔════════════════════════════════════════╗");
        System.out.println("║  SIGRE 2.0 - Contabilidad Service      ║");
        System.out.println("║  Hub Central Contable Iniciado         ║");
        System.out.println("║  Puerto: 8082                          ║");
        System.out.println("║  Swagger: /swagger-ui.html             ║");
        System.out.println("╚════════════════════════════════════════╝");
    }
}

