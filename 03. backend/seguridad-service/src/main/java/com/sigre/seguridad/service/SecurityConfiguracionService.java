package com.sigre.seguridad.service;

import lombok.RequiredArgsConstructor;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

/**
 * Lectura de parámetros desde {@code config.configuracion} (BD security).
 * Usa las funciones {@code config.fn_get_parametro_*} que crean el registro con default si no existe.
 */
@Service
@RequiredArgsConstructor
public class SecurityConfiguracionService {

    private final JdbcTemplate jdbcTemplate;

    @Transactional
    public String getParametroTexto(String modulo, String parametro, String valorDefault) {
        return jdbcTemplate.queryForObject(
                "SELECT config.fn_get_parametro_txt(?, ?, ?)",
                String.class,
                modulo,
                parametro,
                valorDefault);
    }

    @Transactional
    public int getParametroEntero(String modulo, String parametro, int valorDefault) {
        Integer valor = jdbcTemplate.queryForObject(
                "SELECT config.fn_get_parametro_int(?, ?, ?)",
                Integer.class,
                modulo,
                parametro,
                valorDefault);
        return valor != null ? valor : valorDefault;
    }

    @Transactional
    public BigDecimal getParametroDecimal(String modulo, String parametro, BigDecimal valorDefault) {
        BigDecimal valor = jdbcTemplate.queryForObject(
                "SELECT config.fn_get_parametro_dec(?, ?, ?)",
                BigDecimal.class,
                modulo,
                parametro,
                valorDefault);
        return valor != null ? valor : valorDefault;
    }

    @Transactional
    public boolean getParametroBooleano(String modulo, String parametro, boolean valorDefault) {
        Boolean valor = jdbcTemplate.queryForObject(
                "SELECT config.fn_get_parametro_bool(?, ?, ?)",
                Boolean.class,
                modulo,
                parametro,
                valorDefault);
        return valor != null ? valor : valorDefault;
    }
}
