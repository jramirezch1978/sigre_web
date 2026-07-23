package pe.com.hermes.appmobile.data.remote.dto;

import java.math.BigDecimal;
import java.util.List;

/** Espejo de com.sigre.almacen.dto.DashboardLogisticoResponse. */
public class DashboardLogisticoResponse {
    public String claseProductoTerminado;
    public String claseProductoTerminadoDesc;
    public long totalIngresosActivos;
    public long totalSalidasActivos;
    public BigDecimal valorInventarioTotal;
    public List<DiagnosticoAlmacenDto> valorizacionPorAlmacen;
    public List<ProductoTerminadoStockDto> productoTerminado;

    public static class DiagnosticoAlmacenDto {
        public long almacenId;
        public String almacenCodigo;
        public String almacenNombre;
        public long totalArticulos;
        public BigDecimal totalUnidades;
        public BigDecimal valorInventario;
    }

    public static class ProductoTerminadoStockDto {
        public long articuloId;
        public String codigo;
        public String nombre;
        public String denominacion;
        public String grupo;
        public String almacenCodigo;
        public String almacenNombre;
        public BigDecimal cantidad;
        public BigDecimal valor;
    }
}
