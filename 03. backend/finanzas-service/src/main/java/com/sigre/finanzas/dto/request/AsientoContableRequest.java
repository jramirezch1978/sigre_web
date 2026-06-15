package com.sigre.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AsientoContableRequest {
    
    @NotNull(message = "El ID del libro es obligatorio")
    private Long libroId;
    
    @NotNull(message = "La fecha del asiento es obligatoria")
    private LocalDate fecha;
    
    @NotBlank(message = "El tipo de asiento es obligatorio")
    private String tipo;
    
    private BigDecimal tc;
    
    private String glosa;
    
    private Long monedaId;
    
    private String moduloOrigen;
    
    private Long documentoOrigenId;
    
    @NotNull(message = "Los detalles del asiento son obligatorios")
    @NotEmpty(message = "Debe incluir al menos un detalle")
    @Valid
    private List<AsientoContableDetalleRequest> detalles;
}
