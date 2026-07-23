package com.sigre.almacen.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * Resumen logístico para Hermes / dashboards móviles:
 * valorización por almacén, conteo de vales activos (ingresos/salidas)
 * y stock de producto terminado (clase desde parámetro universal CLASE_PRODUCTO_TERMINADO).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DashboardLogisticoResponse {

    private String claseProductoTerminado;
    private String claseProductoTerminadoDesc;
    private long totalIngresosActivos;
    private long totalSalidasActivos;
    private BigDecimal valorInventarioTotal;

    @Builder.Default
    private List<DiagnosticoAlmacenResponse> valorizacionPorAlmacen = new ArrayList<>();

    @Builder.Default
    private List<ProductoTerminadoStockItem> productoTerminado = new ArrayList<>();

    /** Serie diaria (últimos N días) para gráfico lineal ingresos vs salidas. */
    @Builder.Default
    private List<MovimientoDiaItem> serieMovimientos = new ArrayList<>();

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MovimientoDiaItem {
        private LocalDate fecha;
        private long ingresos;
        private long salidas;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ProductoTerminadoStockItem {
        private Long articuloId;
        private String codigo;
        private String nombre;
        private String denominacion;
        private String grupo;
        private String almacenCodigo;
        private String almacenNombre;
        private BigDecimal cantidad;
        private BigDecimal valor;
    }
}
