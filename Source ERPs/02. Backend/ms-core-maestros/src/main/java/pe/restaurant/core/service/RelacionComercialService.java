package pe.restaurant.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.entity.RelacionComercial;

public interface RelacionComercialService {
    Page<RelacionComercial> list(Boolean esProveedor, Boolean esCliente, String nroDocumento, String razonSocial, Boolean activo, Pageable pageable);

    RelacionComercialDetalleResponse getById(Long id);

    RelacionComercialResponse create(RelacionComercialRequest request);

    RelacionComercialResponse update(Long id, RelacionComercialRequest request);

    void delete(Long id);

    RelacionComercial activate(Long id);

    RelacionComercial deactivate(Long id);

    java.util.List<ContactoResponse> listContactos(Long relacionId);

    ContactoResponse createContacto(Long relacionId, ContactoRequest request);

    ContactoResponse updateContacto(Long relacionId, Long contactoId, ContactoRequest request);

    java.util.List<CuentaBancariaResponse> listCuentas(Long relacionId);

    CuentaBancariaResponse createCuenta(Long relacionId, CuentaBancariaRequest request);

    CuentaBancariaResponse updateCuenta(Long relacionId, Long cuentaId, CuentaBancariaRequest request);

    void deleteCuenta(Long relacionId, Long cuentaId);

    java.util.List<EntidadTiendaResponse> listTiendas(Long relacionId);

    EntidadTiendaResponse createTienda(Long relacionId, EntidadTiendaRequest request);

    java.util.List<EntidadTransporteResponse> listTransportes(Long relacionId);

    EntidadTransporteResponse createTransporte(Long relacionId, EntidadTransporteRequest request);

    java.util.List<pe.restaurant.core.dto.ArticuloProveedorResponse> listArticulos(Long relacionId);

    pe.restaurant.core.dto.ArticuloProveedorResponse createArticulo(Long relacionId, Long articuloId);

    java.util.List<pe.restaurant.core.dto.EntidadContribuyenteTelefonoResponse> listTelefonos(Long relacionId);

    pe.restaurant.core.dto.EntidadContribuyenteTelefonoResponse createTelefono(Long relacionId, pe.restaurant.core.dto.EntidadContribuyenteTelefonoRequest request);

    java.util.List<pe.restaurant.core.dto.EntidadContribuyenteRepresentanteResponse> listRepresentantes(Long relacionId);

    pe.restaurant.core.dto.EntidadContribuyenteRepresentanteResponse createRepresentante(Long relacionId, pe.restaurant.core.dto.EntidadContribuyenteRepresentanteRequest request);
}
