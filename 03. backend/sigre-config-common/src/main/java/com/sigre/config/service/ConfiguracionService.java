package com.sigre.config.service;

import com.sigre.config.entity.Configuracion;
import com.sigre.config.repository.ConfiguracionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Optional;

/**
 * Servicio para lectura y escritura de parámetros desde la tabla CONFIGURACION.
 *
 * Replica el patrón de PowerBuilder (n_cst_app_obj):
 *   getParametro: si existe → retorna valor; si no existe → inserta con default y retorna default.
 *   setParametro: si existe → actualiza; si no existe → inserta.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ConfiguracionService {

    private final ConfiguracionRepository configuracionRepository;

    // ========================= GET PARAMETRO =========================

    /**
     * Obtener parámetro entero (valor_int).
     * Si no existe, lo crea con el valor por defecto.
     */
    @Transactional
    public int getParametroInt(String parametro, int valorDefault) {
        Optional<Configuracion> configOpt = configuracionRepository.findById(parametro);

        if (configOpt.isPresent()) {
            Long valor = configOpt.get().getValorInt();
            int resultado = (valor != null) ? valor.intValue() : valorDefault;
            log.debug("📋 getParametroInt('{}') = {} (desde BD)", parametro, resultado);
            return resultado;
        }

        return insertarYRetornarInt(parametro, valorDefault);
    }

    /**
     * Obtener parámetro texto (valor_char).
     * Si no existe, lo crea con el valor por defecto.
     */
    @Transactional
    public String getParametroString(String parametro, String valorDefault) {
        Optional<Configuracion> configOpt = configuracionRepository.findById(parametro);

        if (configOpt.isPresent()) {
            String valor = configOpt.get().getValorChar();
            String resultado = (valor != null) ? valor.trim() : valorDefault;
            log.debug("📋 getParametroString('{}') = '{}' (desde BD)", parametro, resultado);
            return resultado;
        }

        return insertarYRetornarString(parametro, valorDefault);
    }

    /**
     * Obtener parámetro decimal (valor_dec).
     * Si no existe, lo crea con el valor por defecto.
     */
    @Transactional
    public BigDecimal getParametroDec(String parametro, BigDecimal valorDefault) {
        Optional<Configuracion> configOpt = configuracionRepository.findById(parametro);

        if (configOpt.isPresent()) {
            BigDecimal valor = configOpt.get().getValorDec();
            BigDecimal resultado = (valor != null) ? valor : valorDefault;
            log.debug("📋 getParametroDec('{}') = {} (desde BD)", parametro, resultado);
            return resultado;
        }

        return insertarYRetornarDec(parametro, valorDefault);
    }

    /**
     * Obtener parámetro booleano.
     * Convención PowerBuilder: "1"/"S"/"SI"/"TRUE" = true, cualquier otro valor = false.
     * Se almacena en valor_char como "1" o "0".
     */
    @Transactional
    public boolean getParametroBool(String parametro, boolean valorDefault) {
        Optional<Configuracion> configOpt = configuracionRepository.findById(parametro);

        if (configOpt.isPresent()) {
            String valor = configOpt.get().getValorChar();
            if (valor == null) {
                return valorDefault;
            }
            boolean resultado = esTrueString(valor.trim());
            log.debug("📋 getParametroBool('{}') = {} (desde BD, raw='{}')", parametro, resultado, valor.trim());
            return resultado;
        }

        String valorStr = valorDefault ? "1" : "0";
        log.info("📋 Parámetro '{}' no existe → creando con valor_char = '{}'", parametro, valorStr);
        Configuracion nuevo = Configuracion.builder()
                .parametro(parametro)
                .valorChar(valorStr)
                .fecRegistro(LocalDateTime.now())
                .build();
        configuracionRepository.save(nuevo);
        return valorDefault;
    }

    // ========================= SET PARAMETRO =========================

    /**
     * Establecer parámetro entero (valor_int).
     * Si existe → actualiza; si no existe → inserta.
     */
    @Transactional
    public void setParametroInt(String parametro, int valor) {
        Optional<Configuracion> configOpt = configuracionRepository.findById(parametro);

        if (configOpt.isPresent()) {
            Configuracion config = configOpt.get();
            config.setValorInt((long) valor);
            config.setFecRegistro(LocalDateTime.now());
            configuracionRepository.save(config);
            log.info("📋 setParametroInt('{}', {}) → actualizado", parametro, valor);
        } else {
            Configuracion nuevo = Configuracion.builder()
                    .parametro(parametro)
                    .valorInt((long) valor)
                    .fecRegistro(LocalDateTime.now())
                    .build();
            configuracionRepository.save(nuevo);
            log.info("📋 setParametroInt('{}', {}) → insertado", parametro, valor);
        }
    }

    /**
     * Establecer parámetro texto (valor_char).
     * Si existe → actualiza; si no existe → inserta.
     */
    @Transactional
    public void setParametroString(String parametro, String valor) {
        Optional<Configuracion> configOpt = configuracionRepository.findById(parametro);

        if (configOpt.isPresent()) {
            Configuracion config = configOpt.get();
            config.setValorChar(valor);
            config.setFecRegistro(LocalDateTime.now());
            configuracionRepository.save(config);
            log.info("📋 setParametroString('{}', '{}') → actualizado", parametro, valor);
        } else {
            Configuracion nuevo = Configuracion.builder()
                    .parametro(parametro)
                    .valorChar(valor)
                    .fecRegistro(LocalDateTime.now())
                    .build();
            configuracionRepository.save(nuevo);
            log.info("📋 setParametroString('{}', '{}') → insertado", parametro, valor);
        }
    }

    /**
     * Establecer parámetro decimal (valor_dec).
     * Si existe → actualiza; si no existe → inserta.
     */
    @Transactional
    public void setParametroDec(String parametro, BigDecimal valor) {
        Optional<Configuracion> configOpt = configuracionRepository.findById(parametro);

        if (configOpt.isPresent()) {
            Configuracion config = configOpt.get();
            config.setValorDec(valor);
            config.setFecRegistro(LocalDateTime.now());
            configuracionRepository.save(config);
            log.info("📋 setParametroDec('{}', {}) → actualizado", parametro, valor);
        } else {
            Configuracion nuevo = Configuracion.builder()
                    .parametro(parametro)
                    .valorDec(valor)
                    .fecRegistro(LocalDateTime.now())
                    .build();
            configuracionRepository.save(nuevo);
            log.info("📋 setParametroDec('{}', {}) → insertado", parametro, valor);
        }
    }

    /**
     * Establecer parámetro booleano (valor_char como "1" o "0").
     * Si existe → actualiza; si no existe → inserta.
     */
    @Transactional
    public void setParametroBool(String parametro, boolean valor) {
        String valorStr = valor ? "1" : "0";
        setParametroString(parametro, valorStr);
        log.info("📋 setParametroBool('{}', {}) → valor_char = '{}'", parametro, valor, valorStr);
    }

    // ========================= HELPERS PRIVADOS =========================

    private int insertarYRetornarInt(String parametro, int valorDefault) {
        log.info("📋 Parámetro '{}' no existe → creando con valor_int = {}", parametro, valorDefault);
        Configuracion nuevo = Configuracion.builder()
                .parametro(parametro)
                .valorInt((long) valorDefault)
                .fecRegistro(LocalDateTime.now())
                .build();
        configuracionRepository.save(nuevo);
        return valorDefault;
    }

    private String insertarYRetornarString(String parametro, String valorDefault) {
        log.info("📋 Parámetro '{}' no existe → creando con valor_char = '{}'", parametro, valorDefault);
        Configuracion nuevo = Configuracion.builder()
                .parametro(parametro)
                .valorChar(valorDefault)
                .fecRegistro(LocalDateTime.now())
                .build();
        configuracionRepository.save(nuevo);
        return valorDefault;
    }

    private BigDecimal insertarYRetornarDec(String parametro, BigDecimal valorDefault) {
        log.info("📋 Parámetro '{}' no existe → creando con valor_dec = {}", parametro, valorDefault);
        Configuracion nuevo = Configuracion.builder()
                .parametro(parametro)
                .valorDec(valorDefault)
                .fecRegistro(LocalDateTime.now())
                .build();
        configuracionRepository.save(nuevo);
        return valorDefault;
    }

    /**
     * Evalúa si un string representa true.
     * Compatible con la convención PowerBuilder: "1", "S", "SI", "TRUE", "Y", "YES".
     */
    private boolean esTrueString(String valor) {
        if (valor == null) return false;
        String v = valor.trim().toUpperCase();
        return "1".equals(v) || "S".equals(v) || "SI".equals(v)
                || "TRUE".equals(v) || "Y".equals(v) || "YES".equals(v);
    }
}
