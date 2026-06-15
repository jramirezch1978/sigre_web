package com.sigre.common.service;

import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.support.TransactionSynchronizationManager;
import com.sigre.common.exception.BusinessException;

import javax.sql.DataSource;

/**
 * Servicio reutilizable para obtener correlativos tenant con bloqueo a nivel
 * de fila sobre {@code core.num_tablas}. Requiere una transacción activa para
 * garantizar atomicidad entre la lectura del último número y su actualización.
 */
@Service
public class CorrelativoService {

    private static final String DEFAULT_COD_ORIGEN = "XX";

    private final JdbcTemplate jdbcTemplate;

    public CorrelativoService(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public long obtenerSiguienteNumero(String nombreTabla) {
        return obtenerSiguienteNumero(nombreTabla, DEFAULT_COD_ORIGEN);
    }

    public long obtenerSiguienteNumero(String nombreTabla, String codOrigen) {
        validarTransaccionActiva();

        String tablaNormalizada = normalizarNombreTabla(nombreTabla);
        String origenNormalizado = normalizarCodOrigen(codOrigen);

        jdbcTemplate.update(
                """
                INSERT INTO core.num_tablas (nombre_tabla, cod_origen, ultimo_numero)
                VALUES (?, ?, 0)
                ON CONFLICT (nombre_tabla, cod_origen) DO NOTHING
                """,
                tablaNormalizada,
                origenNormalizado
        );

        Long ultimoNumero = jdbcTemplate.queryForObject(
                """
                SELECT ultimo_numero
                FROM core.num_tablas
                WHERE nombre_tabla = ?
                  AND cod_origen = ?
                FOR UPDATE
                """,
                Long.class,
                tablaNormalizada,
                origenNormalizado
        );

        if (ultimoNumero == null) {
            throw new BusinessException(
                    "No se pudo obtener el correlativo para " + tablaNormalizada + "/" + origenNormalizado,
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "CORRELATIVO_NO_DISPONIBLE"
            );
        }

        long siguienteNumero = ultimoNumero + 1;

        int actualizados = jdbcTemplate.update(
                """
                UPDATE core.num_tablas
                SET ultimo_numero = ?
                WHERE nombre_tabla = ?
                  AND cod_origen = ?
                """,
                siguienteNumero,
                tablaNormalizada,
                origenNormalizado
        );

        if (actualizados != 1) {
            throw new BusinessException(
                    "No se pudo actualizar el correlativo para " + tablaNormalizada + "/" + origenNormalizado,
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "CORRELATIVO_UPDATE_ERROR"
            );
        }

        return siguienteNumero;
    }

    private static void validarTransaccionActiva() {
        if (!TransactionSynchronizationManager.isActualTransactionActive()) {
            throw new BusinessException(
                    "Obtener correlativos requiere una transacción activa",
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "TRANSACCION_REQUERIDA"
            );
        }
        if (TransactionSynchronizationManager.isCurrentTransactionReadOnly()) {
            throw new BusinessException(
                    "No se puede obtener correlativos dentro de una transacción de solo lectura",
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "TRANSACCION_SOLO_LECTURA"
            );
        }
    }

    private static String normalizarNombreTabla(String nombreTabla) {
        if (nombreTabla == null || nombreTabla.isBlank()) {
            throw new BusinessException(
                    "El nombre de la tabla del correlativo es obligatorio",
                    HttpStatus.BAD_REQUEST,
                    "CORRELATIVO_TABLA_REQUERIDA"
            );
        }
        return nombreTabla.trim().toLowerCase();
    }

    private static String normalizarCodOrigen(String codOrigen) {
        if (codOrigen == null || codOrigen.isBlank()) {
            return DEFAULT_COD_ORIGEN;
        }
        return codOrigen.trim().toUpperCase();
    }
}
