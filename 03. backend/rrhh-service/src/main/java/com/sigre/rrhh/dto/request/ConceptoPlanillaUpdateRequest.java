package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * DTO para la actualización de un concepto de planilla.
 * El campo 'codigo' no se incluye ya que es inmutable tras la creación.
 * 
 * @author Equipo de Desarrollo RRHH
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ConceptoPlanillaUpdateRequest {

    @NotBlank(message = "El nombre es obligatorio")
    @Size(max = 150, message = "El nombre no puede exceder 150 caracteres")
    private String nombre;

    @NotBlank(message = "El tipo es obligatorio")
    @Pattern(regexp = "INGRESO|DESCUENTO|APORTE", message = "El tipo debe ser INGRESO, DESCUENTO o APORTE")
    private String tipo;

    @Size(max = 5000, message = "La fórmula no puede exceder 5000 caracteres")
    private String formula;

    @DecimalMin(value = "0.0", inclusive = false, message = "El valor fijo debe ser mayor a 0")
    private BigDecimal valorFijo;

    @NotNull(message = "El campo afectoQuinta es obligatorio")
    private Boolean afectoQuinta;

    @NotNull(message = "El campo afectoEssalud es obligatorio")
    private Boolean afectoEssalud;

    @NotNull(message = "El campo aplicaTodos es obligatorio")
    private Boolean aplicaTodos;
}
