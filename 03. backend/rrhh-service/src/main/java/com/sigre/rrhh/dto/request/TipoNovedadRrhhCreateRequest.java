package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class TipoNovedadRrhhCreateRequest {

    @NotBlank(message = "El c\u00f3digo del tipo de novedad es obligatorio")
    @Size(max = 20, message = "El c\u00f3digo no puede exceder 20 caracteres")
    private String codigo;

    @NotBlank(message = "El nombre del tipo de novedad es obligatorio")
    @Size(max = 120, message = "El nombre no puede exceder 120 caracteres")
    private String nombre;
}
