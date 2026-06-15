package com.sigre.finanzas.service;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

/**
 * Catálogo de centros de costo activos para selección en el front
 * (CxP, Notas, OC). La tabla maestra vive en el esquema contabilidad,
 * por eso se lee vía JdbcTemplate cross-schema.
 */
@Service
@RequiredArgsConstructor
public class CentroCostoCatalogoService {

    private final JdbcTemplate jdbcTemplate;

    public List<Map<String, Object>> listarActivos() {
        return jdbcTemplate.queryForList("""
                SELECT cc.id           AS id,
                       cc.desc_cencos  AS nombre
                FROM   contabilidad.centros_costo cc
                WHERE  cc.flag_estado = '1'
                ORDER BY cc.desc_cencos
                """);
    }
}
