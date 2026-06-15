package com.sigre.produccion.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CaractDetRequest {

    @NotBlank(message = "La característica es requerida")
    @Size(max = 120, message = "La característica no debe exceder 120 caracteres")
    private String caracteristica;

    @NotBlank(message = "El valor es requerido")
    @Size(max = 220, message = "El valor no debe exceder 220 caracteres")
    private String valor;

    private Long unidadMedidaId;
}
