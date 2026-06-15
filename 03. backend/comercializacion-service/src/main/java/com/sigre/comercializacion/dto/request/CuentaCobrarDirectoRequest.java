package com.sigre.comercializacion.dto.request;

import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * Registro de documento por cobrar directo (HU-FIN-OP-CC-003) — ingresos fuera de venta POS/OV.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CuentaCobrarDirectoRequest {

    @NotNull
    private Long sucursalId;

    @NotNull
    private Long clienteId;

    @NotNull
    private Long docTipoId;

    private String serie;
    private String numero;

    @NotNull
    private LocalDate fechaEmision;

    private LocalDate fechaVencimiento;

    private Long monedaId;

    /** Servicio facturable CxC opcional ({@code ventas.servicios_cxc}). */
    private Long servicioCxcId;

    /** Descripción del concepto / servicio prestado. */
    private String descripcion;

    @NotNull
    @DecimalMin(value = "0.0001")
    private BigDecimal monto;

    @NotNull(message = "El año del periodo contable es obligatorio")
    @Min(value = 1900, message = "El año debe ser válido")
    private Integer ano;

    @NotNull(message = "El mes del periodo contable es obligatorio")
    @Min(value = 1, message = "El mes debe estar entre 1 y 12")
    @Max(value = 12, message = "El mes debe estar entre 1 y 12")
    private Integer mes;

    @NotNull(message = "El libro contable (cntbl_libro_id) es obligatorio")
    @Positive(message = "El libro contable debe ser un id válido")
    private Long cntblLibroId;

    /** Concepto financiero para el cargo inicial; si no se envía se usa FI-108. */
    private Long conceptoFinancieroId;
}
