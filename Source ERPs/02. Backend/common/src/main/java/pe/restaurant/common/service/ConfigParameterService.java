package pe.restaurant.common.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.sql.Date;
import java.time.LocalDate;

/**
 * Lectura de parámetros de {@code config.configuracion} exclusivamente vía funciones PostgreSQL:
 * <ul>
 *   <li>{@code core.fn_get_parameter_txt/int/dec/date/bool} — por nombre de parámetro</li>
 *   <li>{@code rrhh._cfg_txt/_cfg_int/_cfg_dec} — por módulo + parámetro (solo lectura)</li>
 * </ul>
 */
@Service
public class ConfigParameterService {

    private final JdbcTemplate jdbcTemplate;

    public ConfigParameterService(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public String getText(String parameter, String defaultValue) {
        return jdbcTemplate.queryForObject(
                "SELECT core.fn_get_parameter_txt(?, ?)",
                String.class,
                parameter,
                defaultValue);
    }

    public Integer getInt(String parameter, Integer defaultValue) {
        return jdbcTemplate.queryForObject(
                "SELECT core.fn_get_parameter_int(?, ?)",
                Integer.class,
                parameter,
                defaultValue);
    }

    public BigDecimal getDec(String parameter, BigDecimal defaultValue) {
        return jdbcTemplate.queryForObject(
                "SELECT core.fn_get_parameter_dec(?, ?)",
                BigDecimal.class,
                parameter,
                defaultValue);
    }

    public LocalDate getDate(String parameter, LocalDate defaultValue) {
        Date sqlDefault = defaultValue == null ? null : Date.valueOf(defaultValue);
        Date result = jdbcTemplate.queryForObject(
                "SELECT core.fn_get_parameter_date(?, ?)",
                Date.class,
                parameter,
                sqlDefault);
        return result == null ? null : result.toLocalDate();
    }

    public Boolean getBool(String parameter, Boolean defaultValue) {
        return jdbcTemplate.queryForObject(
                "SELECT core.fn_get_parameter_bool(?, ?)",
                Boolean.class,
                parameter,
                defaultValue);
    }

    /** Flag almacenado como {@code valor_texto = '1'}. */
    public boolean isTextFlagOn(String parameter, String defaultWhenMissing) {
        return "1".equals(getText(parameter, defaultWhenMissing));
    }

    /** Lectura sin auto-creación: {@code rrhh._cfg_txt(modulo, parametro)}. */
    public String getRrhhText(String modulo, String parametro) {
        return jdbcTemplate.queryForObject(
                "SELECT rrhh._cfg_txt(?, ?)",
                String.class,
                modulo,
                parametro);
    }

    /** Lectura sin auto-creación: {@code rrhh._cfg_int(modulo, parametro, default)}. */
    public Integer getRrhhInt(String modulo, String parametro, Integer defaultValue) {
        return jdbcTemplate.queryForObject(
                "SELECT rrhh._cfg_int(?, ?, ?)",
                Integer.class,
                modulo,
                parametro,
                defaultValue);
    }

    /** Lectura sin auto-creación: {@code rrhh._cfg_dec(modulo, parametro, default)}. */
    public BigDecimal getRrhhDec(String modulo, String parametro, BigDecimal defaultValue) {
        return jdbcTemplate.queryForObject(
                "SELECT rrhh._cfg_dec(?, ?, ?)",
                BigDecimal.class,
                modulo,
                parametro,
                defaultValue);
    }
}
