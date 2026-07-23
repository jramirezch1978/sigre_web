package pe.com.hermes.appmobile.data.remote.dto;

import java.math.BigDecimal;
import java.util.List;

/** DTOs de listado/detalle Almacén (espejo parcial del backend). */
public final class AlmacenListDtos {
    private AlmacenListDtos() {}

    public static class OrdenTrasladoListItemResponse {
        public long id;
        public Long almacenOrigenId;
        public Long almacenDestinoId;
        public String numero;
        public String fecha;
        public String flagEstado;
        public String observacion;
    }

    public static class StockListItemResponse {
        public long id;
        public Long almacenId;
        public Long articuloId;
        public BigDecimal cantidadDisponible;
        public BigDecimal cantidadReservada;
        public BigDecimal cantidadTotal;
        public BigDecimal costoPromedio;
    }

    public static class KardexListItemResponse {
        public long id;
        public Long almacenId;
        public Long articuloId;
        public String articuloCodigo;
        public String articuloNombre;
        public String fecha;
        public String tipo;
        public BigDecimal cantidad;
        public BigDecimal costoUnitario;
        public BigDecimal saldoCantidad;
    }

    public static class InventarioConteoListItemResponse {
        public long id;
        public Long almacenId;
        public Long articuloId;
        public String fechaConteo;
        public Integer nroConteo;
        public BigDecimal saldoSistema;
        public BigDecimal cantidadConteo1;
        public BigDecimal diferencia;
        public String flagEstado;
    }

    public static class AlmacenMaestroResponse {
        public long id;
        public String codigo;
        public String nombre;
        public String almacenTipoCodigo;
        public String almacenTipoNombre;
        public String sucursalNombre;
        public String flagEstado;
    }

    public static class TipoMovimientoListItemResponse {
        public long id;
        public String tipoMov;
        public String descTipoMov;
        public String flagEstado;
    }

    public static class MotivoTrasladoListItemResponse {
        public long id;
        public String codigo;
        public String nombre;
        public String descripcion;
        public String flagEstado;
    }

    public static class LotePalletListItemResponse {
        public long id;
        public String codigo;
        public String nroLote;
        public Long articuloId;
        public Long almacenId;
        public String flagEstado;
    }

    public static class GuiaRemisionListItemResponse {
        public long id;
        public String numero;
        public String fecha;
        public String flagEstado;
        public Long almacenId;
    }

    public static class SolicitudSalidaListItemResponse {
        public long id;
        public String numero;
        public String fecha;
        public String flagEstado;
        public Long almacenId;
    }

    public static class ValorizacionListItemResponse {
        public Long almacenId;
        public Long articuloId;
        public String articuloCodigo;
        public String articuloNombre;
        public BigDecimal cantidadDisponible;
        public BigDecimal costoPromedio;
        public BigDecimal valorTotal;
    }

    public static class StockAFechaListItemResponse {
        public Long articuloId;
        public String articuloCodigo;
        public String articuloNombre;
        public Long almacenId;
        public BigDecimal cantidad;
        public BigDecimal costoPromedio;
    }

    public static class MovimientoDetalleResponse {
        public long id;
        public Long sucursalId;
        public String sucursalNombre;
        public Long almacenId;
        public String almacenNombre;
        public Long articuloMovTipoId;
        public String articuloMovTipoDescripcion;
        public String nroVale;
        public String fechaMov;
        public String observaciones;
        public String flagEstado;
        public List<MovimientoLineaResponse> lineas;
    }

    public static class MovimientoLineaResponse {
        public long id;
        public Long articuloId;
        public String articuloCodigo;
        public String articuloNombre;
        public BigDecimal cantidad;
        public BigDecimal costoUnitario;
    }

    public static class CatalogoIdNombreResponse {
        public long id;
        public String codigo;
        public String nombre;
        public String descripcion;
        public String flagEstado;
    }

    public static class AlmacenTipoResponse {
        public long id;
        public String codigo;
        public String nombre;
        public String libroNombre;
        public String flagEstado;
    }

    public static class UbicacionAlmacenResponse {
        public long id;
        public Long almacenId;
        public String almacenCodigo;
        public String almacenNombre;
        public String codigo;
        public String nombre;
        public String pasillo;
        public String estante;
        public String nivel;
    }

    public static class AlmacenTipoMovResponse {
        public long id;
        public Long almacenId;
        public String almacenCodigo;
        public String almacenNombre;
        public Long articuloMovTipoId;
        public String tipoMov;
        public String descTipoMov;
        public String flagEstado;
    }

    public static class ConversionUnidadResponse {
        public long id;
        public String umOrigenCodigo;
        public String umOrigenNombre;
        public String umDestinoCodigo;
        public String umDestinoNombre;
        public BigDecimal factorConversion;
        public String flagEstado;
    }

    public static class NumeradorDocumentoResponse {
        public String nombreTabla;
        public Long sucursalId;
        public String sucursalCodigo;
        public String sucursalNombre;
        public Integer ano;
        public Long ultNro;
        public String flagEstado;
    }

    public static class ConfigClaveResponse {
        public String clave;
        public String modulo;
        public String nivel;
        public String descripcion;
        public String tipoDato;
        public String flagEstado;
    }

    public static class OrdenTrasladoDetalleResponse {
        public long id;
        public Long almacenOrigenId;
        public Long almacenDestinoId;
        public String numero;
        public String fecha;
        public String flagEstado;
        public String observacion;
        public List<OrdenTrasladoLineaResponse> lineas;
    }

    public static class OrdenTrasladoLineaResponse {
        public long id;
        public Long articuloId;
        public String articuloCodigo;
        public String articuloNombre;
        public BigDecimal cantidad;
    }

    public static class InventarioConteoDetalleResponse {
        public long id;
        public Long almacenId;
        public Long articuloId;
        public String fechaConteo;
        public Integer nroConteo;
        public BigDecimal saldoSistema;
        public BigDecimal cantidadConteo1;
        public BigDecimal cantidadConteo2;
        public BigDecimal diferencia;
        public String flagEstado;
    }

    public static class IdRequest {
        public Long id;
        public String observacion;
        public String motivo;

        public static IdRequest confirmar(long id) {
            IdRequest r = new IdRequest();
            r.id = id;
            return r;
        }

        public static IdRequest anular(long id, String motivo) {
            IdRequest r = new IdRequest();
            r.id = id;
            r.motivo = motivo;
            return r;
        }
    }
}
