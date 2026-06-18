package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DatosServicioResponse {

    private Long servicioId;
    private String servicioCodigo;
    private String descripcion;
    private BigDecimal precioPactado;
    private Long tipoImpuestoDefaultId;
    private BigDecimal tasaIgv;
}
