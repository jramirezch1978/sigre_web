package com.sigre.produccion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class OtAdministracionRequest {

    @NotBlank(message = "El código es requerido")
    @Size(max = 20, message = "El código no debe exceder 20 caracteres")
    private String codigo;

    @NotBlank(message = "El nombre es requerido")
    @Size(max = 150, message = "El nombre no debe exceder 150 caracteres")
    private String nombre;

    @Size(max = 1, message = "flagTipoCosto debe ser un caracter (0, D, I o F)")
    private String flagTipoCosto;
}
