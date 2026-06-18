package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DevolvibleLineaResponse {

    private Long articuloId;
    private BigDecimal cantOriginal;
    private BigDecimal cantYaDevuelta;
    private BigDecimal cantDevolvible;
    private BigDecimal costoUnitario;
}
