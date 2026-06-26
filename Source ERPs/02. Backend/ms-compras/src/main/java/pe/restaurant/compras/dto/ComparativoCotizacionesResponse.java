package pe.restaurant.compras.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ComparativoCotizacionesResponse {
    private List<ArticuloComparativo> articulos;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ArticuloComparativo {
        private Long articuloId;
        private String articuloCodigo;
        private String articuloNombre;
        private List<OfertaProveedor> ofertas;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OfertaProveedor {
        private Long cotizacionId;
        private Long proveedorId;
        private String proveedorRazonSocial;
        private BigDecimal precioUnitario;
        private BigDecimal descuento;
        private Integer plazoEntregaDias;
        private BigDecimal cantidad;
    }
}
