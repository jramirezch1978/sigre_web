package pe.restaurant.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * Diagnóstico/resumen por almacén: cantidad de artículos con stock, unidades
 * totales y valorización del inventario. Derivado de {@code almacen.articulo_almacen}.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DiagnosticoAlmacenResponse {

    private Long almacenId;
    private String almacenCodigo;
    private String almacenNombre;
    private Long totalArticulos;
    private BigDecimal totalUnidades;
    private BigDecimal valorInventario;
}
