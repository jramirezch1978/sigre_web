package com.sigre.seguridad.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DuplicateKeyException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.security.SecureRandom;
import java.time.OffsetDateTime;

/**
 * Gestión de licencias del ERP (auth.licencia). La demo usa edición Enterprise
 * (todos los módulos), 15 días de vigencia y 20 días para eliminar la BD.
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LicenciaService {

    public static final int DEMO_DIAS_VIGENCIA = 15;
    public static final int DEMO_DIAS_ELIMINACION_BD = 20;
    public static final String EDICION_DEMO = "ENTERPRISE";
    public static final int DEMO_MAX_USUARIOS = 5;

    private static final SecureRandom RANDOM = new SecureRandom();
    private static final char[] HEX = "0123456789ABCDEF".toCharArray();

    private final JdbcTemplate jdbcTemplate;

    /** Datos de la licencia recién creada (para correo/respuesta). */
    public record LicenciaDemo(String codigo, OffsetDateTime vencimiento, int diasVigencia) {}

    /** Código de 16 hex en grupos de 4: XXXX-XXXX-XXXX-XXXX (estilo Windows). */
    public String generarCodigo() {
        StringBuilder sb = new StringBuilder(19);
        for (int grupo = 0; grupo < 4; grupo++) {
            if (grupo > 0) {
                sb.append('-');
            }
            for (int i = 0; i < 4; i++) {
                sb.append(HEX[RANDOM.nextInt(16)]);
            }
        }
        return sb.toString();
    }

    /** Crea la licencia demo (Enterprise) para la empresa. Reintenta ante colisión de código. */
    @Transactional
    public LicenciaDemo crearLicenciaDemo(long empresaId) {
        OffsetDateTime inicio = OffsetDateTime.now();
        OffsetDateTime vencimiento = inicio.plusDays(DEMO_DIAS_VIGENCIA);
        OffsetDateTime eliminacionBd = inicio.plusDays(DEMO_DIAS_ELIMINACION_BD);

        for (int intento = 0; intento < 6; intento++) {
            String codigo = generarCodigo();
            try {
                jdbcTemplate.update("""
                        INSERT INTO auth.licencia (empresa_id, codigo_licencia, edicion_codigo, tipo,
                            max_usuarios, fecha_inicio, fecha_vencimiento, fecha_eliminacion_bd, estado, flag_estado)
                        VALUES (?, ?, ?, 'D', ?, ?, ?, ?, 'A', '1')
                        """,
                        empresaId, codigo, EDICION_DEMO, DEMO_MAX_USUARIOS,
                        inicio, vencimiento, eliminacionBd);
                log.info("Licencia demo {} creada para empresa {} (vence {})", codigo, empresaId, vencimiento);
                return new LicenciaDemo(codigo, vencimiento, DEMO_DIAS_VIGENCIA);
            } catch (DuplicateKeyException e) {
                log.warn("Colisión de código de licencia {}, reintentando…", codigo);
            }
        }
        throw new IllegalStateException("No se pudo generar un código de licencia único tras varios intentos.");
    }
}
