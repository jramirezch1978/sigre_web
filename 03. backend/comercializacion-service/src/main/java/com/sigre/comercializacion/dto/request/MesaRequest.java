package com.sigre.comercializacion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MesaRequest {
    
    @NotNull(message = "El ID de zona es obligatorio")
    private Long zonaId;
    
    @NotBlank(message = "El número de mesa es obligatorio")
    @Size(max = 20, message = "El número de mesa no puede exceder 20 caracteres")
    private String numero;
    
    private Integer capacidad;
}
