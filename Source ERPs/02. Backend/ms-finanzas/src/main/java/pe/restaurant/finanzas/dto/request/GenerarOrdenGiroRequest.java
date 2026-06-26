package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Request dedicado a la <b>Generación de Órdenes de Giro</b> (HU-FIN-ADL-001).
 *
 * <p>A diferencia de {@code SolicitudGiroRequest} (genérico, soporta O/F), este request
 * <b>fija el tipo en "O" (Orden de Giro)</b> en el servicio, por lo que no admite
 * Fondo Fijo. Corrige el bug del front que permitía seleccionar "F" en esta pantalla.</p>
 *
 * <p><b>Importante (sin BD):</b> los campos {@code ordenCompraId},
 * {@code solicitudAdelantoRrhhId}, {@code numeroDocumentoBase}, {@code montoDisponible},
 * {@code cuentaBancariaId} y {@code tipoBeneficiario} se usan SOLO para validación y/o
 * eco en la respuesta; <b>no se persisten</b> porque la tabla {@code solicitud_giro} no
 * tiene esas columnas (ver brechas ADL-001). Persistirlos requiere ampliar la BD.</p>
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class GenerarOrdenGiroRequest {

    @NotNull(message = "La sucursal es obligatoria")
    private Long sucursalId;

    @NotNull(message = "El beneficiario es obligatorio")
    private Long solicitanteId;

    @NotNull(message = "La fecha de emisión es obligatoria")
    private LocalDate fecha;

    @NotNull(message = "El monto del giro es obligatorio")
    @Positive(message = "El monto del giro debe ser mayor a cero")
    private BigDecimal monto;

    /** Glosa contable (se persiste en la columna {@code motivo} existente). */
    private String glosaContable;

    private Long centrosCostoId;

    /** P = Proveedor (vía Orden de Compra), C = Colaborador (vía Solicitud de Adelanto RR.HH.). */
    @Pattern(regexp = "P|C", message = "tipoBeneficiario debe ser P (Proveedor) o C (Colaborador)")
    private String tipoBeneficiario;

    /** Referencia a la Orden de Compra origen (obligatoria si beneficiario = Proveedor). No se persiste. */
    private Long ordenCompraId;

    /** Referencia a la Solicitud de Adelanto de RR.HH. (obligatoria si beneficiario = Colaborador). No se persiste. */
    private Long solicitudAdelantoRrhhId;

    /** N° del documento base (OC o Solicitud de Adelanto) para eco/impresión. No se persiste. */
    private String numeroDocumentoBase;

    /** Saldo disponible del documento base; si se envía, se valida que el monto del giro no lo supere. */
    private BigDecimal montoDisponible;

    /** Cuenta bancaria a validar (activa y de la sucursal/razón social). No se persiste. */
    private Long cuentaBancariaId;
}
