package pe.restaurant.rrhh.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Data;

import java.math.BigDecimal;

/**
 * DTO de entrada para operaciones de creación y actualización de cargos.
 * Contiene los datos necesarios para definir un cargo con su banda salarial.
 */
@Data
public class CargoRequest {
    
    @NotBlank(message = "El nombre del cargo es obligatorio")
    @Size(max = 120, message = "El nombre no puede exceder 120 caracteres")
    private String nombre;
    
    @Size(max = 30, message = "El nivel no puede exceder 30 caracteres")
    private String nivel;
    
    private BigDecimal sueldoMinimo;
    
    private BigDecimal sueldoMaximo;
}
