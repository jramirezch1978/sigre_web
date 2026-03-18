package com.sigre.config;

import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.AutoConfigurationPackage;
import org.springframework.context.annotation.ComponentScan;

/**
 * Auto-configuración de Spring Boot para sigre-config-common.
 * Usa @AutoConfigurationPackage para SUMAR los paquetes de esta librería
 * al escaneo existente del microservicio, sin sobreescribir sus propios
 * repositorios ni entidades.
 */
@AutoConfiguration
@AutoConfigurationPackage(basePackages = "com.sigre.config")
@ComponentScan(basePackages = "com.sigre.config")
public class SigreConfigAutoConfiguration {
}
