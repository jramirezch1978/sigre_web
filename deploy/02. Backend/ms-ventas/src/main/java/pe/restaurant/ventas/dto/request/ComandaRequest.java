package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ComandaRequest {
    
    @NotNull(message = "La sucursal es obligatoria")
    private Long sucursalId;
    
    private Long puntoVentaId;
    
    private Long turnoId;
    
    private Long clienteId;
    
    private String mesa;
    
    private List<ComandaItemRequest> items;
}
