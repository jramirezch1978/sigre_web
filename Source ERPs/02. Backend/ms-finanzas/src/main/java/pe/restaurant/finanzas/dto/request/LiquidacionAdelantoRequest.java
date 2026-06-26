package pe.restaurant.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

/**
 * Request para crear una liquidación de adelanto distinguiendo el Tipo de Adelanto
 * (Proveedor / Colaborador) de la HU-FIN-ADL-003.
 *
 * <p>Es un request NUEVO (no reemplaza a {@link LiquidacionRequest}) porque agrega campos que
 * el alta tradicional no expone: {@code tipoAdelanto} con semántica P/C validada, el
 * beneficiario según el tipo y la opción de guardar como Borrador. El endpoint clásico
 * {@code POST /api/finanzas/liquidaciones} se mantiene intacto.
 *
 * <p>No requiere cambios en la base de datos: {@code tipoAdelanto} se persiste en la columna
 * existente {@code tipo_liquidacion}, el proveedor en {@code proveedor_id} y el estado Borrador
 * en {@code flag_estado}.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiquidacionAdelantoRequest {

    @NotNull(message = "La solicitud de giro es obligatoria")
    private Long solicitudGiroId;

    /** Tipo de Adelanto: P = Proveedor, C = Colaborador (HU-FIN-ADL-003). */
    @NotNull(message = "El tipo de adelanto es obligatorio")
    @Pattern(regexp = "(?i)[PC]", message = "El tipo de adelanto debe ser 'P' (Proveedor) o 'C' (Colaborador)")
    private String tipoAdelanto;

    /** Obligatorio cuando {@code tipoAdelanto = P}; ignorado cuando es C. */
    private Long proveedorId;

    /**
     * Informativo cuando {@code tipoAdelanto = C}. No se persiste (no existe columna): el
     * beneficiario colaborador se deriva del solicitante de la solicitud de giro vinculada.
     */
    private Long colaboradorId;

    @Size(max = 12, message = "El número de liquidación no puede exceder 12 caracteres")
    private String nroLiquidacion;

    private Long sucursalId;

    private Long docTipoId;

    private LocalDate fechaLiquidacion;

    private Long monedaId;

    @NotNull(message = "El concepto financiero es obligatorio")
    private Long conceptoFinancieroId;

    private Long cntblLibroId;

    @NotNull(message = "El importe neto es obligatorio")
    @Positive(message = "El importe neto debe ser mayor a cero")
    private BigDecimal importeNeto;

    @NotNull(message = "La tasa de cambio es obligatoria")
    @Positive(message = "La tasa de cambio debe ser mayor a cero")
    private BigDecimal tasaCambio;

    private Integer anio;

    private Integer mes;

    private Long usuarioId;

    @Size(max = 200, message = "La observación no puede exceder 200 caracteres")
    private String observacion;

    /**
     * true = guardar como Borrador (flag_estado=6); false = Enviada para Revisión / Pendiente
     * (flag_estado=1). Cubre el criterio "guardar en Borrador o Enviada para Revisión".
     */
    private boolean borrador = false;

    @Valid
    @NotNull(message = "Los detalles son obligatorios")
    @Size(min = 1, message = "Debe incluir al menos un detalle")
    private List<LiquidacionDetalleRequest> detalles;
}
