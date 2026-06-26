package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ServiciosCxCRequest {
    
    @NotBlank(message = "El código de servicio es obligatorio")
    @Size(max = 3, message = "El código de servicio no puede exceder 3 caracteres")
    private String codServicio;
    
    @NotBlank(message = "La descripción del servicio es obligatoria")
    @Size(max = 200, message = "La descripción no puede exceder 200 caracteres")
    private String descServicio;
    
    private BigDecimal tarifa;
    
    @Size(max = 1, message = "El flag de afecto IGV no puede exceder 1 caracter")
    private String flagAfectoIgv = "1";
    
    @Size(max = 3, message = "El código de moneda no puede exceder 3 caracteres")
    private String codMoneda;
}
