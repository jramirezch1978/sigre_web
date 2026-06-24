package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConceptoPlanillaUpdateRequest {

    @NotBlank(message = "El nombre es obligatorio")
    @Size(max = 150, message = "El nombre no puede exceder 150 caracteres")
    private String nombre;

    @Size(max = 150, message = "La descripción breve no puede exceder 150 caracteres")
    private String descripcionBreve;

    @NotNull(message = "El factor de pago es obligatorio")
    @DecimalMin(value = "0.0", inclusive = true, message = "El factor de pago debe ser mayor o igual a 0")
    private BigDecimal factorPago;

    @NotNull(message = "El importe tope mínimo es obligatorio")
    @DecimalMin(value = "0.0", inclusive = true, message = "El importe tope mínimo debe ser mayor o igual a 0")
    private BigDecimal importeTopeMin;

    @NotNull(message = "El importe tope máximo es obligatorio")
    @DecimalMin(value = "0.0", inclusive = true, message = "El importe tope máximo debe ser mayor o igual a 0")
    private BigDecimal importeTopeMax;

    @DecimalMin(value = "0.0", inclusive = true, message = "El número de horas debe ser mayor o igual a 0")
    private BigDecimal numeroHoras;

    @NotBlank(message = "El grupo de cálculo es obligatorio")
    @Size(max = 10, message = "El grupo de cálculo no puede exceder 10 caracteres")
    private String grupoCalculo;

    @NotBlank(message = "El flag de replicación es obligatorio")
    @Pattern(regexp = "[01]", message = "El flag de replicación debe ser 0 o 1")
    private String flagReplicacion;

    @Size(max = 10, message = "El concepto RTPS no puede exceder 10 caracteres")
    private String conceptoRtps;

    @NotBlank(message = "El flag de subsidio es obligatorio")
    @Pattern(regexp = "[01]", message = "El flag de subsidio debe ser 0 o 1")
    private String flagSubsidio;

    @NotBlank(message = "El flag de reporte quinta es obligatorio")
    @Pattern(regexp = "[01]", message = "El flag de reporte quinta debe ser 0 o 1")
    private String flagReporteQuinta;

    @Size(max = 20, message = "El número de orden no puede exceder 20 caracteres")
    private String numeroOrden;
}
