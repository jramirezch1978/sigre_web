package pe.com.hermes.appmobile.data.remote.dto;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/** Requests de escritura Almacén / Core (paridad web). */
public final class AlmacenWriteDtos {
    private AlmacenWriteDtos() {}

    public static class AlmacenRequest {
        public Long sucursalId;
        public String codigo;
        public String nombre;
        public Long almacenTipoId;
        public String flagEstado;
    }

    public static class ArticuloMovTipoRequest {
        public String tipoMov;
        public String descTipoMov;
        public String flagEstado;
        public BigDecimal factorSldoTotal;
    }

    public static class AlmacenTipoRequest {
        public String codigo;
        public String nombre;
        public Long cntblLibroId;
        public String flagEstado;
    }

    public static class UbicacionRequest {
        public String codigo;
        public String nombre;
        public String pasillo;
        public String estante;
        public String nivel;
    }

    public static class MotivoTrasladoRequest {
        public String codigo;
        public String nombre;
        public String flagEstado;
    }

    public static class LotePalletRequest {
        public Long articuloId;
        public String nroLote;
        public String fechaProduccion;
        public String fechaVencimiento;
        public String observacion;
        public String flagEstado;
    }

    public static class ConversionUnidadRequest {
        public Long umOrigenId;
        public Long umDestinoId;
        public BigDecimal factorConversion;
    }

    public static class NumeradorDocumentoUpsertRequest {
        public String nombreTabla;
        public Long sucursalId;
        public Integer ano;
        public Long ultNro;
        public String flagEstado;
    }

    public static class ConfigEmpresaSaveRequest {
        public Long empresaId;
        public Map<String, Object> valores;
    }

    public static class AlmacenTipoMovAsignarRequest {
        public Long articuloMovTipoId;
    }

    public static class MovimientoCabeceraRequest {
        public Long sucursalId;
        public Long almacenId;
        public Long articuloMovTipoId;
        public String fechaMov;
        public String observaciones;
        public List<MovimientoLineaRequest> lineas;
    }

    public static class MovimientoLineaRequest {
        public Long id;
        public Long articuloId;
        public BigDecimal cantProcesada;
        public BigDecimal costoUnitario;
    }

    public static class OrdenTrasladoRequest {
        public Long almacenOrigenId;
        public Long almacenDestinoId;
        public String fecha;
        public String observacion;
        public List<OrdenTrasladoLineaRequest> lineas;
    }

    public static class OrdenTrasladoLineaRequest {
        public Long id;
        public Long articuloId;
        public BigDecimal cantidad;
    }

    public static class InventarioConteoRequest {
        public Long almacenId;
        public Long articuloId;
        public String fechaConteo;
        public Integer nroConteo;
        public BigDecimal saldoSistema;
        public BigDecimal cantidadConteo1;
        public BigDecimal cantidadConteo2;
        public BigDecimal costoUnitario;
    }
}
