package com.sigre.common.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.math.BigDecimal;

/**
 * Acceso unificado a los parámetros del sistema en {@code config.configuracion} (esquema config
 * del tenant), vía las funciones PostgreSQL {@code config.fn_get_parametro_*} y
 * {@code config.fn_set_parametro_*}. Todos los servicios deben usar esta clase para leer/grabar
 * parámetros, en lugar de consultar la tabla directamente.
 *
 * <ul>
 *   <li>get*: lee el valor; si el parámetro no existe lo crea con el default y lo retorna.</li>
 *   <li>set*: upsert atómico (ON CONFLICT por modulo+parametro).</li>
 * </ul>
 *
 * Cada parámetro se identifica por (modulo, parametro). Las funciones corren dentro de la
 * transacción del invocador.
 */
@Service
public class ConfiguracionParametroService {

    private final JdbcTemplate jdbcTemplate;

    public ConfiguracionParametroService(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    // ── Lectura ────────────────────────────────────────────────────────────
    public String getTexto(String modulo, String parametro, String defecto) {
        return jdbcTemplate.queryForObject(
                "SELECT config.fn_get_parametro_txt(?, ?, ?::text)", String.class, modulo, parametro, defecto);
    }

    public Integer getEntero(String modulo, String parametro, Integer defecto) {
        return jdbcTemplate.queryForObject(
                "SELECT config.fn_get_parametro_int(?, ?, ?::integer)", Integer.class, modulo, parametro, defecto);
    }

    public BigDecimal getDecimal(String modulo, String parametro, BigDecimal defecto) {
        return jdbcTemplate.queryForObject(
                "SELECT config.fn_get_parametro_dec(?, ?, ?::numeric)", BigDecimal.class, modulo, parametro, defecto);
    }

    public Boolean getBooleano(String modulo, String parametro, Boolean defecto) {
        return jdbcTemplate.queryForObject(
                "SELECT config.fn_get_parametro_bool(?, ?, ?::boolean)", Boolean.class, modulo, parametro, defecto);
    }

    // ── Grabado (upsert) ─────────────────────────────────────────────────────
    public String setTexto(String modulo, String parametro, String valor) {
        return jdbcTemplate.queryForObject(
                "SELECT config.fn_set_parametro_txt(?, ?, ?::text)", String.class, modulo, parametro, valor);
    }

    public Integer setEntero(String modulo, String parametro, Integer valor) {
        return jdbcTemplate.queryForObject(
                "SELECT config.fn_set_parametro_int(?, ?, ?::integer)", Integer.class, modulo, parametro, valor);
    }

    public BigDecimal setDecimal(String modulo, String parametro, BigDecimal valor) {
        return jdbcTemplate.queryForObject(
                "SELECT config.fn_set_parametro_dec(?, ?, ?::numeric)", BigDecimal.class, modulo, parametro, valor);
    }

    public Boolean setBooleano(String modulo, String parametro, Boolean valor) {
        return jdbcTemplate.queryForObject(
                "SELECT config.fn_set_parametro_bool(?, ?, ?::boolean)", Boolean.class, modulo, parametro, valor);
    }
}
