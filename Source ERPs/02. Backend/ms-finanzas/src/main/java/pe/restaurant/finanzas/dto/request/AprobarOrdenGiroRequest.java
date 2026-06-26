package pe.restaurant.finanzas.dto.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Request de aprobación de Orden de Giro (HU-FIN-ADL-002).
 *
 * <p>La observación es <b>OPCIONAL</b>: la HU pide "registrar" observaciones al aprobar, no
 * obligarlas. Se crea aparte de {@code AprobarSolicitudRequest} (que arrastra el flag
 * {@code crearOrdenGiro}) para no cambiar el contrato del endpoint existente
 * {@code /solicitudes-giro/{id}/aprobar}.</p>
 *
 * <p><b>Nota:</b> hoy la observación de aprobación <b>no se persiste</b> por falta de columna en
 * {@code solicitud_giro}; se devuelve como eco y se registra en el log. Persistirla requiere
 * ampliar la BD (ver brechas ADL-002).</p>
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class AprobarOrdenGiroRequest {

    /** Observación de aprobación (opcional; no se persiste por falta de columna). */
    private String observacion;
}
