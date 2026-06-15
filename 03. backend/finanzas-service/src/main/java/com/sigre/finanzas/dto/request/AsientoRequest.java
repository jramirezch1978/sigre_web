package com.sigre.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoRequest {

    @NotNull(message = "El libro es requerido")
    private Long libroId;

    @NotNull(message = "La fecha del asiento es requerida")
    private LocalDate fecha;

    @NotBlank(message = "El tipo de asiento es requerido")
    private String tipo;

    @Valid
    @NotNull(message = "Los detalles del asiento son requeridos")
    private List<AsientoDetalleRequest> detalles;
}
