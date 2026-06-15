package com.sigre.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

/**
 * DTO de entrada para operaciones de creación y actualización de áreas.
 */
@Data
public class AreaRequest {
    
    @NotBlank(message = "El nombre del área es obligatorio")
    @Size(max = 120, message = "El nombre no puede exceder 120 caracteres")
    private String nombre;
    
    private Long padreId;
    
    private Long responsableId;
}
