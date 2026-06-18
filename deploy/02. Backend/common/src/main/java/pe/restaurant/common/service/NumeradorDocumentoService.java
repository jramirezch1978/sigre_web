package pe.restaurant.common.service;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.support.TransactionTemplate;
import javax.sql.DataSource;
import java.util.Map;

/**
 * Genera números de documento legibles vía funciones PostgreSQL.
 * Debe ejecutarse dentro de una transacción activa ({@code @Transactional}).
 *
 * <ul>
 *   <li>{@link #siguienteNroDocumento} → {@code core.fn_get_document_number} (12 chars: XXYYYY000001)</li>
 *   <li>{@link #siguienteNroDocumentoSunat} → {@code core.fn_get_number_sunat_documents} (15 chars: XXXX-XXXXXXXXXX)</li>
 * </ul>
 */
@Service
public class NumeradorDocumentoService {

    private final JdbcTemplate jdbcTemplate;
    private final TransactionTemplate requiresNewTx;

    public NumeradorDocumentoService(DataSource dataSource, PlatformTransactionManager txManager) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
        this.requiresNewTx = new TransactionTemplate(txManager);
        this.requiresNewTx.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRES_NEW);
    }

    /**
     * Número interno por tabla: XXYYYY000001 (12 chars).
     *
     * @param nombreTabla nombre calificado (ej. {@code compras.orden_compra})
     * @param sucursalId  auth.sucursal.id
     * @param ano         año calendario del documento
     * @return VARCHAR(12)
     */
    public String siguienteNroDocumento(String nombreTabla, Long sucursalId, int ano) {
        String nt = nombreTabla == null ? "" : nombreTabla.trim();
        return jdbcTemplate.queryForObject(
                "SELECT core.fn_get_document_number(?, ?, ?)",
                String.class,
                nt,
                sucursalId,
                ano
        );
    }

    /**
     * Consume el número en una transacción independiente ({@code REQUIRES_NEW}),
     * de modo que el contador en {@code core.numerador_documento} NO se revierte
     * si la transacción padre falla (rollback).
     *
     * @param nombreTabla nombre calificado (ej. {@code compras.orden_compra})
     * @param sucursalId  auth.sucursal.id
     * @param ano         año calendario del documento
     * @return VARCHAR(12)
     */
    public String siguienteNroDocumentoIndependiente(String nombreTabla, Long sucursalId, int ano) {
        return requiresNewTx.execute(status ->
                siguienteNroDocumento(nombreTabla, sucursalId, ano));
    }

    /**
     * Número fiscal SUNAT por serie: XXXX-XXXXXXXXXX (15 chars).
     * Aplica para facturas, boletas, notas de venta/crédito/débito, guías de remisión,
     * comprobantes de retención IGV, liquidaciones de compra.
     * Fuente: {@code core.doc_tipo_num_serie} (PK: sucursal + doc_tipo + serie).
     *
     * @param docTipoId   core.doc_tipo.id
     * @param serie       serie SUNAT (ej. "F001", "B001", "R001")
     * @param sucursalId  auth.sucursal.id
     * @return objeto con serie (4), numero (10) y nroDocumento (15)
     */
    public DocumentoSerieNumero siguienteNroDocumentoSunat(Long docTipoId, String serie,
                                                           Long sucursalId) {
        String s = serie != null ? serie.trim() : "";
        Map<String, Object> row = jdbcTemplate.queryForMap(
                "SELECT serie, numero, nro_documento FROM core.fn_get_number_sunat_documents(?, ?, ?)",
                docTipoId,
                s,
                sucursalId
        );
        return new DocumentoSerieNumero(
                ((String) row.get("serie")).trim(),
                ((String) row.get("numero")).trim(),
                ((String) row.get("nro_documento")).trim()
        );
    }

    /**
     * Resultado de la numeración fiscal SUNAT (serie + número + documento compuesto).
     */
    public record DocumentoSerieNumero(String serie, String numero, String nroDocumento) {
    }
}
