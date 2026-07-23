package pe.com.hermes.appmobile.data.remote.dto;

import java.math.BigDecimal;
import java.util.List;

/** DTOs Compras / Core usados por Hermes. */
public final class ComprasDtos {
    private ComprasDtos() {}

    public static class SolicitudDetalleResponse {
        public long id;
        public Long sucursalId;
        public String numero;
        public String fecha;
        public Long solicitanteId;
        public String prioridad;
        public String flagEstado;
        public String justificacion;
        public List<SolicitudLineaResponse> lineas;
    }

    public static class SolicitudLineaResponse {
        public long id;
        public Long articuloId;
        public Long almacenId;
        public String articuloCodigo;
        public String articuloDescripcion;
        public BigDecimal cantidad;
        public String especificaciones;
    }

    public static class SolicitudRequest {
        public Long sucursalId;
        public String fecha;
        public Long solicitanteId;
        public String prioridad;
        public String justificacion;
        public List<SolicitudLineaRequest> lineas;
    }

    public static class SolicitudLineaRequest {
        public Long articuloId;
        public Long almacenId;
        public BigDecimal cantidad;
        public String especificaciones;
    }

    public static class MotivoBody {
        public String motivo;
        public static MotivoBody of(String m) {
            MotivoBody b = new MotivoBody();
            b.motivo = m;
            return b;
        }
    }

    public static class ObservacionBody {
        public String observacion;
        public static ObservacionBody of(String o) {
            ObservacionBody b = new ObservacionBody();
            b.observacion = o;
            return b;
        }
    }

    public static class ConvertirBody {
        public String destino;
        public List<Long> proveedorIds;
        public Long monedaId;
    }

    public static class ConvertirResponse {
        public Long solicitudId;
        public String destino;
        public List<Long> documentosGenerados;
    }

    public static class TipoEntidadDto {
        public long id;
        public String tipo;
        public String descripcion;
        public String flagEstado;
    }

    public static class TipoEntidadRequest {
        public String tipo;
        public String descripcion;
        public String flagEstado;
    }

    public static class ProveedorDto {
        public long id;
        public String razonSocial;
        public String nombreComercial;
        public Long tipoDocIdentidadId;
        public String nroDocumento;
        public String direccion;
        public String telefono;
        public String email;
        public Boolean esProveedor;
        public Boolean esCliente;
        public String flagEstado;
    }

    public static class ProveedorRequest {
        public String razonSocial;
        public String nombreComercial;
        public Long tipoDocIdentidadId;
        public String nroDocumento;
        public String direccion;
        public String telefono;
        public String email;
        public Boolean esProveedor;
        public Boolean esCliente;
        public Long tipoEntidadContribuyenteId;
        public String flagEstado;
    }

    public static class CatalogoCodigoNombre {
        public long id;
        public String codigo;
        public String nombre;
        public String flagEstado;
        // variantes de campo
        public String catArt;
        public String descCateg;
        public String codClase;
        public String descClase;
        public String codSubCat;
        public String descSubcateg;
        public Long articuloCategId;
        public String tipo;
        public String descripcion;
        public Long unidadMedidaId;
    }

    public static class CatalogoCodigoNombreRequest {
        public String codigo;
        public String nombre;
        public String flagEstado;
        public String catArt;
        public String descCateg;
        public String codClase;
        public String descClase;
        public String codSubCat;
        public String descSubcateg;
        public Long articuloCategId;
        public String tipo;
        public String descripcion;
        public Long unidadMedidaId;
        public Long articuloSubCategId;
        public Long articuloClaseId;
        public Long marcaId;
        public Long colorId;
    }
}
