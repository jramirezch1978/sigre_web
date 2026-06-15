package com.sigre.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LiquidacionRequest {

    @NotNull(message = "La solicitud de giro es obligatoria")
    private Long solicitudGiroId;

    @Size(max = 12, message = "El número de liquidación no puede exceder 12 caracteres")
    private String nroLiquidacion;

    private Long sucursalId;

    private Long docTipoId;

    private Long proveedorId;

    private LocalDate fechaLiquidacion;

    @Size(max = 1, message = "El tipo de liquidación no puede exceder 1 caracter")
    private String tipoLiquidacion;

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

    @Valid
    @NotNull(message = "Los detalles son obligatorios")
    @Size(min = 1, message = "Debe incluir al menos un detalle")
    private List<LiquidacionDetalleRequest> detalles;
}
