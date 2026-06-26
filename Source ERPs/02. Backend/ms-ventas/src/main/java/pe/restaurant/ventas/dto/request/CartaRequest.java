package pe.restaurant.ventas.dto.request;

import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartaRequest {
    
    private Long sucursalId;
    
    @NotBlank(message = "El nombre de la carta es obligatorio")
    @Size(max = 150, message = "El nombre de la carta no puede exceder 150 caracteres")
    private String nombre;
    
    @Size(max = 1000, message = "La descripción no puede exceder 1000 caracteres")
    private String descripcion;
    
    @Valid
    private List<CartaDetRequest> detalles;
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CartaDetRequest {
        
        @NotNull(message = "El ID de artículo es obligatorio")
        private Long articuloId;
        
        private java.math.BigDecimal precio;
        
        private Integer orden;
    }
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class CartaDetUpdateRequest {
        // articuloId NO se permite cambiar según contrato
        
        private java.math.BigDecimal precio;
        
        private Integer orden;
    }
}
