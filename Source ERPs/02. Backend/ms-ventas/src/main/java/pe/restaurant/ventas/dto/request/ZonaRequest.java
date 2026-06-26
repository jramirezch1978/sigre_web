package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ZonaRequest {
    
    @NotNull(message = "El ID de sucursal es obligatorio")
    private Long sucursalId;
    
    @NotBlank(message = "El nombre de la zona es obligatorio")
    @Size(max = 120, message = "El nombre de la zona no puede exceder 120 caracteres")
    private String nombre;
    
    private Integer capacidad;
}
