package com.sigre.produccion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class LaborRequest {

    @NotBlank(message = "El código es requerido")
    @Size(max = 20, message = "El código no debe exceder 20 caracteres")
    private String codigo;

    @NotBlank(message = "El nombre es requerido")
    @Size(max = 150, message = "El nombre no debe exceder 150 caracteres")
    private String nombre;
}
