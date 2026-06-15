package com.sigre.produccion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ControlCalidadRequest {

    private Long ordenTrabajoId;
    private Long inspectorId;

    @NotNull(message = "La fecha es requerida")
    private LocalDate fecha;

    @NotBlank(message = "El resultado es requerido")
    @Size(max = 20, message = "El resultado no debe exceder 20 caracteres")
    private String resultado;

    private String observaciones;
}
