package pe.restaurant.finanzas.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * Respuesta de la generación de una Orden de Giro (HU-FIN-ADL-001).
 *
 * <p>Envuelve la solicitud realmente persistida ({@link SolicitudGiroDetalleResponse})
 * y agrega el <b>contexto de la HU que NO se persiste</b> (referencia al documento base,
 * tipo de beneficiario, cuenta bancaria validada y usuario responsable real). Estos campos
 * se devuelven como eco para que el front pueda imprimir/mostrar la orden sin requerir
 * cambios de BD. {@code advertencia} deja explícito qué quedó fuera por falta de columnas.</p>
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class OrdenGiroGeneradaResponse {

    /** Datos efectivamente persistidos en {@code solicitud_giro}. */
    private SolicitudGiroDetalleResponse ordenGiro;

    /** Usuario logueado que generó la orden (Usuario Responsable). */
    private Long usuarioResponsableId;

    /** P = Proveedor, C = Colaborador. */
    private String tipoBeneficiario;

    /** Documento base según beneficiario (no persistido). */
    private Long ordenCompraId;
    private Long solicitudAdelantoRrhhId;
    private String numeroDocumentoBase;

    /** Cuenta bancaria validada (no persistida). */
    private Long cuentaBancariaId;

    /** Saldo disponible del documento base contra el que se validó el monto (eco). */
    private BigDecimal montoDisponible;

    private String advertencia;
}
