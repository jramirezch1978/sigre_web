package pe.restaurant.core.controller;

import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.core.dto.*;
import pe.restaurant.core.mapper.RelacionComercialMapper;
import pe.restaurant.core.service.RelacionComercialService;

import java.util.List;

@RestController
@RequestMapping("/api/core/relaciones-comerciales")
@RequiredArgsConstructor
public class RelacionComercialController {
    private final RelacionComercialService service;
    private final RelacionComercialMapper mapper;

    @GetMapping
    public ApiResponse<PageData<RelacionComercialResponse>> list(
            @RequestParam(required = false) Boolean esProveedor,
            @RequestParam(required = false) Boolean esCliente,
            @RequestParam(required = false) String nroDocumento,
            @RequestParam(required = false) String razonSocial,
            @RequestParam(required = false) Boolean activo,
            Pageable pageable
    ) {
        var page = service.list(esProveedor, esCliente, nroDocumento, razonSocial, activo, pageable);
        return ApiResponse.ok(PageData.of(page, page.getContent().stream().map(mapper::toRelacionResponse).toList()));
    }

    @GetMapping("/{id}")
    public ApiResponse<RelacionComercialDetalleResponse> getById(@PathVariable Long id) {
        return ApiResponse.ok(service.getById(id));
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<RelacionComercialResponse> create(@Valid @RequestBody RelacionComercialRequest request) {
        return ApiResponse.ok(service.create(request), "Relacion comercial creada");
    }

    @PutMapping("/{id}")
    public ApiResponse<RelacionComercialResponse> update(@PathVariable Long id, @Valid @RequestBody RelacionComercialRequest request) {
        return ApiResponse.ok(service.update(id, request), "Relacion comercial actualizada");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<Boolean> delete(@PathVariable Long id) {
        service.delete(id);
        return ApiResponse.ok(true, "Registro eliminado");
    }

    @PatchMapping("/{id}/activar")
    public ApiResponse<RelacionComercialResponse> activate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toRelacionResponse(service.activate(id)), "Registro activado");
    }

    @PatchMapping("/{id}/desactivar")
    public ApiResponse<RelacionComercialResponse> deactivate(@PathVariable Long id) {
        return ApiResponse.ok(mapper.toRelacionResponse(service.deactivate(id)), "Registro desactivado");
    }

    @GetMapping("/{relacionId}/contactos")
    public ApiResponse<List<ContactoResponse>> listContactos(@PathVariable Long relacionId) {
        return ApiResponse.ok(service.listContactos(relacionId));
    }

    @PostMapping("/{relacionId}/contactos")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ContactoResponse> createContacto(@PathVariable Long relacionId, @Valid @RequestBody ContactoRequest request) {
        return ApiResponse.ok(service.createContacto(relacionId, request), "Contacto creado");
    }

    @PutMapping("/{relacionId}/contactos/{contactoId}")
    public ApiResponse<ContactoResponse> updateContacto(@PathVariable Long relacionId,
                                                        @PathVariable Long contactoId,
                                                        @Valid @RequestBody ContactoRequest request) {
        return ApiResponse.ok(service.updateContacto(relacionId, contactoId, request), "Contacto actualizado");
    }

    @GetMapping("/{relacionId}/cuentas-bancarias")
    public ApiResponse<List<CuentaBancariaResponse>> listCuentas(@PathVariable Long relacionId) {
        return ApiResponse.ok(service.listCuentas(relacionId));
    }

    @PostMapping("/{relacionId}/cuentas-bancarias")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<CuentaBancariaResponse> createCuenta(@PathVariable Long relacionId, @Valid @RequestBody CuentaBancariaRequest request) {
        return ApiResponse.ok(service.createCuenta(relacionId, request), "Cuenta bancaria creada");
    }

    @PutMapping("/{relacionId}/cuentas-bancarias/{cuentaId}")
    public ApiResponse<CuentaBancariaResponse> updateCuenta(@PathVariable Long relacionId,
                                                            @PathVariable Long cuentaId,
                                                            @Valid @RequestBody CuentaBancariaRequest request) {
        return ApiResponse.ok(service.updateCuenta(relacionId, cuentaId, request), "Cuenta bancaria actualizada");
    }

    @DeleteMapping("/{relacionId}/cuentas-bancarias/{cuentaId}")
    public ApiResponse<Boolean> deleteCuenta(@PathVariable Long relacionId, @PathVariable Long cuentaId) {
        service.deleteCuenta(relacionId, cuentaId);
        return ApiResponse.ok(true, "Cuenta bancaria eliminada");
    }

    @GetMapping("/{relacionId}/tiendas")
    public ApiResponse<List<EntidadTiendaResponse>> listTiendas(@PathVariable Long relacionId) {
        return ApiResponse.ok(service.listTiendas(relacionId));
    }

    @PostMapping("/{relacionId}/tiendas")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<EntidadTiendaResponse> createTienda(@PathVariable Long relacionId, @Valid @RequestBody EntidadTiendaRequest request) {
        return ApiResponse.ok(service.createTienda(relacionId, request), "Tienda creada");
    }

    @GetMapping("/{relacionId}/transportes")
    public ApiResponse<List<EntidadTransporteResponse>> listTransportes(@PathVariable Long relacionId) {
        return ApiResponse.ok(service.listTransportes(relacionId));
    }

    @PostMapping("/{relacionId}/transportes")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<EntidadTransporteResponse> createTransporte(@PathVariable Long relacionId, @Valid @RequestBody EntidadTransporteRequest request) {
        return ApiResponse.ok(service.createTransporte(relacionId, request), "Transporte creado");
    }

    @GetMapping("/{relacionId}/articulos")
    public ApiResponse<List<ArticuloProveedorResponse>> listArticulos(@PathVariable Long relacionId) {
        return ApiResponse.ok(service.listArticulos(relacionId));
    }

    @PostMapping("/{relacionId}/articulos")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<ArticuloProveedorResponse> createArticulo(
            @PathVariable Long relacionId,
            @Valid @RequestBody ArticuloProveedorRequest request) {
        return ApiResponse.ok(service.createArticulo(relacionId, request.getArticuloId()), "Artículo asociado al proveedor");
    }

    @GetMapping("/{relacionId}/telefonos")
    public ApiResponse<List<EntidadContribuyenteTelefonoResponse>> listTelefonos(@PathVariable Long relacionId) {
        return ApiResponse.ok(service.listTelefonos(relacionId));
    }

    @PostMapping("/{relacionId}/telefonos")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<EntidadContribuyenteTelefonoResponse> createTelefono(
            @PathVariable Long relacionId,
            @Valid @RequestBody EntidadContribuyenteTelefonoRequest request) {
        return ApiResponse.ok(service.createTelefono(relacionId, request), "Teléfono creado");
    }

    @GetMapping("/{relacionId}/representantes")
    public ApiResponse<List<EntidadContribuyenteRepresentanteResponse>> listRepresentantes(@PathVariable Long relacionId) {
        return ApiResponse.ok(service.listRepresentantes(relacionId));
    }

    @PostMapping("/{relacionId}/representantes")
    @ResponseStatus(HttpStatus.CREATED)
    public ApiResponse<EntidadContribuyenteRepresentanteResponse> createRepresentante(
            @PathVariable Long relacionId,
            @Valid @RequestBody EntidadContribuyenteRepresentanteRequest request) {
        return ApiResponse.ok(service.createRepresentante(relacionId, request), "Representante creado");
    }
}
