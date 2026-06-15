package com.sigre.finanzas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LetraCanjeRequest {
    
    @NotNull(message = "El ID del proveedor es obligatorio")
    private Long proveedorId;
    
    @NotNull(message = "La fecha de canje es obligatoria")
    private LocalDate fechaCanje;
    
    @NotBlank(message = "La referencia es obligatoria")
    @Size(max = 120, message = "La referencia no puede exceder 120 caracteres")
    private String referencia;
    
    @NotNull(message = "Los orígenes son obligatorios")
    @NotEmpty(message = "Debe incluir al menos un documento origen")
    @Valid
    private List<OrigenCanjeRequest> origenes;
    
    @NotNull(message = "Los destinos son obligatorios")
    @NotEmpty(message = "Debe incluir al menos un documento destino")
    @Valid
    private List<DestinoCanjeRequest> destinos;
}
