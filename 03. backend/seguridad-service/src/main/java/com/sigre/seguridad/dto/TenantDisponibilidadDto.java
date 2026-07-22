package com.sigre.seguridad.dto;

/**
 * Resultado de un ping JDBC a la BD de un tenant (monitoreo worker/seguridad).
 */
public record TenantDisponibilidadDto(
        long empresaId,
        String razonSocial,
        String dbName,
        String dbHost,
        int dbPort,
        boolean disponible
) {}
