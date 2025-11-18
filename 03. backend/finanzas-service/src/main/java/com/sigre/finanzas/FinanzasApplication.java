package com.sigre.finanzas;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;

/**
 * Finanzas Service - Cuentas por Pagar y Cobrar
 * Puerto: 8083
 * 
 * Responsable de:
 * - Cuentas por pagar (proveedores)
 * - Cuentas por cobrar (clientes)
 * - Tesorería
 * - Bancos
 * - Flujo de caja
 * - Detracciones
 * - Generación de asientos contables a Contabilidad
 */
@SpringBootApplication
@EnableDiscoveryClient
@EnableFeignClients
public class FinanzasApplication {

    public static void main(String[] args) {
        SpringApplication.run(FinanzasApplication.class, args);
        System.out.println("╔════════════════════════════════════════╗");
        System.out.println("║  SIGRE 2.0 - Finanzas Service          ║");
        System.out.println("║  Tesorería Iniciada                    ║");
        System.out.println("║  Puerto: 8083                          ║");
        System.out.println("╚════════════════════════════════════════╝");
    }
}

