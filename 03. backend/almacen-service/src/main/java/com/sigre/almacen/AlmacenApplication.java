package com.sigre.almacen;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;

/**
 * Almacén Service - Inventarios y Movimientos
 * Puerto: 8084
 */
@SpringBootApplication
@EnableDiscoveryClient
public class AlmacenApplication {

    public static void main(String[] args) {
        SpringApplication.run(AlmacenApplication.class, args);
        System.out.println("╔════════════════════════════════════════╗");
        System.out.println("║  SIGRE 2.0 - Almacén Service           ║");
        System.out.println("║  Inventarios Iniciados                 ║");
        System.out.println("║  Puerto: 8084                          ║");
        System.out.println("╚════════════════════════════════════════╝");
    }
}

