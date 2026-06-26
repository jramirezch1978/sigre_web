package pe.restaurant.finanzas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CajaBancosDetalleRequest {

    @NotNull(message = "El número de item es obligatorio")
    private Integer item;

    @NotNull(message = "La entidad (contribuyente) del documento es obligatoria por línea")
    private Long entidadContribuyenteId;

    @NotNull(message = "El tipo de documento del detalle es obligatorio")
    private Long docTipoId;

    @NotBlank(message = "El número de documento del detalle es obligatorio")
    @Size(max = 12, message = "El número de documento admite hasta 12 caracteres")
    private String nroDoc;

    @NotNull(message = "El importe es obligatorio")
    @Positive(message = "El importe debe ser mayor a cero")
    private BigDecimal importe;

    private Long cntasPagarId;

    private Long cntasCobrarId;

    private Long solicitudGiroId;

    private Long liquidacionId;

    @NotNull(message = "El concepto financiero es obligatorio en cada detalle")
    private Long conceptoFinancieroId;

    private String flagCxp;

    private Long sucursalRefId;

    private Long monedaId;

    private Long centrosCostoId;

    private Long codigoFlujoCajaId;

    private Long bancoCntaProvId;

    // --- CAMPOS ADICIONALES (DDL COMPLETO) ---
    // Campos adicionales presentes en la base de datos que no se utilizan actualmente
    // pero se mantienen para compatibilidad y uso futuro
    private BigDecimal imptRetIgv;         // NUMERIC(18,4) - Importe de retención IGV
    private String flagRetIgv;            // CHAR(1) - Flag retención IGV ('1' si aplica, '0' si no)
    private String flagReferencia;        // CHAR(1) - Movimiento de referencia
    private String flagFlujoCaja;          // CHAR(1) - Incluir en flujo de caja ('1' operativo, '0' financiero)
    private Integer factor;                // SMALLINT - Factor para cálculos (1 positivo, -1 negativo)
    private String flagProvisionado;       // CHAR(1) - Estado de provisión
    private String flagAplicComp;          // CHAR(1) - Aplicación compensatoria
}
