package pe.restaurant.ventas.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class FacturaSimplificadaRequest {
    
    @NotNull(message = "La sucursal es obligatoria")
    private Long sucursalId;
    
    private Long puntoVentaId;
    
    @NotNull(message = "El cliente es obligatorio")
    private Long clienteId;
    
    @NotNull(message = "El tipo de documento es obligatorio")
    private Long docTipoId;
    
    @NotBlank(message = "La serie es obligatoria")
    private String serie;
    
    @NotBlank(message = "El número es obligatorio")
    private String numero;
    
    @NotNull(message = "La fecha de emisión es obligatoria")
    private LocalDate fechaEmision;
    
    private Long monedaId;
    
    private List<FacturaSimplificadaItemRequest> items;
    
    private List<FacturaSimplificadaPagoRequest> pagos;
}
