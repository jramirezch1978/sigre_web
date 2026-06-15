package com.sigre.core.controller;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import com.sigre.core.dto.*;
import com.sigre.core.entity.RelacionComercial;
import com.sigre.core.mapper.RelacionComercialMapper;
import com.sigre.core.service.RelacionComercialService;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.isNull;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class RelacionComercialControllerTest {

    @Mock private RelacionComercialService service;
    @Mock private RelacionComercialMapper mapper;
    @InjectMocks private RelacionComercialController controller;

    // ── list ───────────────────────────────────────────────────────────────

    @Test void list_delegatesToService() {
        RelacionComercial entity = new RelacionComercial();
        entity.setId(1L);
        Page<RelacionComercial> page = new PageImpl<>(List.of(entity));
        when(service.list(isNull(), isNull(), isNull(), isNull(), isNull(), any(Pageable.class))).thenReturn(page);
        when(mapper.toRelacionResponse(entity)).thenReturn(new RelacionComercialResponse());
        var result = controller.list(null, null, null, null, null, Pageable.unpaged());
        assertThat(result.getData().getContent()).hasSize(1);
        verify(service).list(isNull(), isNull(), isNull(), isNull(), isNull(), any(Pageable.class));
    }

    @Test void list_withFilters() {
        Page<RelacionComercial> page = new PageImpl<>(List.of());
        when(service.list(eq(true), eq(false), eq("201"), eq("Emp"), eq(true), any(Pageable.class))).thenReturn(page);
        var result = controller.list(true, false, "201", "Emp", true, Pageable.unpaged());
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getContent()).isEmpty();
    }

    // ── getById ───────────────────────────────────────────────────────────

    @Test void getById_returnsDetail() {
        var detalle = new RelacionComercialDetalleResponse();
        detalle.setId(5L);
        when(service.getById(5L)).thenReturn(detalle);
        var result = controller.getById(5L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData().getId()).isEqualTo(5L);
    }

    // ── create ────────────────────────────────────────────────────────────

    @Test void create_returnsCreated() {
        var request = new RelacionComercialRequest("Prov", "Prov Comercial", 6L, "201", "Dir 123", null, null, true, false, null, "1");
        var response = new RelacionComercialResponse();
        response.setId(1L);
        response.setNombreComercial("Prov Comercial");
        response.setDireccion("Dir 123");
        when(service.create(request)).thenReturn(response);
        var result = controller.create(request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Relacion comercial creada");
        assertThat(result.getData().getNombreComercial()).isEqualTo("Prov Comercial");
        verify(service).create(request);
    }

    // ── update ────────────────────────────────────────────────────────────

    @Test void update_returnsUpdated() {
        var request = new RelacionComercialRequest("Prov Upd", "Prov Upd Comercial", 6L, "202", "Dir Upd", null, null, true, false, null, "1");
        var response = new RelacionComercialResponse();
        response.setId(1L);
        response.setNombreComercial("Prov Upd Comercial");
        response.setDireccion("Dir Upd");
        when(service.update(1L, request)).thenReturn(response);
        var result = controller.update(1L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Relacion comercial actualizada");
        assertThat(result.getData().getDireccion()).isEqualTo("Dir Upd");
    }

    // ── delete ────────────────────────────────────────────────────────────

    @Test void delete_delegatesAndReturnsTrue() {
        var result = controller.delete(1L);
        verify(service).delete(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).isTrue();
    }

    // ── activate / deactivate ─────────────────────────────────────────────

    @Test void activate_returnsActivated() {
        var entity = new RelacionComercial();
        entity.setId(1L);
        entity.setFlagEstado("1");
        var response = new RelacionComercialResponse();
        response.setId(1L);
        when(service.activate(1L)).thenReturn(entity);
        when(mapper.toRelacionResponse(entity)).thenReturn(response);
        var result = controller.activate(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Registro activado");
    }

    @Test void deactivate_returnsDeactivated() {
        var entity = new RelacionComercial();
        entity.setId(1L);
        var response = new RelacionComercialResponse();
        response.setId(1L);
        when(service.deactivate(1L)).thenReturn(entity);
        when(mapper.toRelacionResponse(entity)).thenReturn(response);
        var result = controller.deactivate(1L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Registro desactivado");
    }

    // ── contactos ─────────────────────────────────────────────────────────

    @Test void listContactos_returnsOk() {
        var contacto = new ContactoResponse(1L, "Juan", "Gerente", "999", "j@e.com");
        when(service.listContactos(10L)).thenReturn(List.of(contacto));
        var result = controller.listContactos(10L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
    }

    @Test void createContacto_returnsCreated() {
        var request = new ContactoRequest("Juan", "Gerente", "999", "j@e.com");
        var response = new ContactoResponse(1L, "Juan", "Gerente", "999", "j@e.com");
        when(service.createContacto(10L, request)).thenReturn(response);
        var result = controller.createContacto(10L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Contacto creado");
    }

    @Test void updateContacto_returnsOk() {
        var request = new ContactoRequest("Juan Perez", "Gerente de Compras", "999888777", "jperez@empresa.com");
        var response = new ContactoResponse(5L, "Juan Perez", "Gerente de Compras", "999888777", "jperez@empresa.com");
        when(service.updateContacto(10L, 5L, request)).thenReturn(response);
        var result = controller.updateContacto(10L, 5L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Contacto actualizado");
        assertThat(result.getData().getId()).isEqualTo(5L);
    }

    // ── cuentas bancarias ─────────────────────────────────────────────────

    @Test void listCuentas_returnsOk() {
        var cuenta = new CuentaBancariaResponse(1L, "002", "123", "CCI", 1L, null);
        when(service.listCuentas(10L)).thenReturn(List.of(cuenta));
        var result = controller.listCuentas(10L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
    }

    @Test void createCuenta_returnsCreated() {
        var request = new CuentaBancariaRequest("002", "123", "CCI", 1L, null);
        var response = new CuentaBancariaResponse(1L, "002", "123", "CCI", 1L, null);
        when(service.createCuenta(10L, request)).thenReturn(response);
        var result = controller.createCuenta(10L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Cuenta bancaria creada");
    }

    @Test void updateCuenta_returnsOk() {
        var request = new CuentaBancariaRequest("002", "1234567890", "00200212345678901234", 1L, "CORRIENTE");
        var response = new CuentaBancariaResponse(7L, "002", "1234567890", "00200212345678901234", 1L, "CORRIENTE");
        when(service.updateCuenta(10L, 7L, request)).thenReturn(response);
        var result = controller.updateCuenta(10L, 7L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Cuenta bancaria actualizada");
        assertThat(result.getData().getId()).isEqualTo(7L);
    }

    @Test void deleteCuenta_returnsOk() {
        var result = controller.deleteCuenta(10L, 7L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Cuenta bancaria eliminada");
        verify(service).deleteCuenta(10L, 7L);
    }

    // ── tiendas ───────────────────────────────────────────────────────────

    @Test void listTiendas_returnsOk() {
        var tienda = new EntidadTiendaResponse();
        tienda.setId(1L);
        when(service.listTiendas(10L)).thenReturn(List.of(tienda));
        var result = controller.listTiendas(10L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
    }

    @Test void createTienda_returnsCreated() {
        var request = new EntidadTiendaRequest("T01", "Tienda 1", "Dir 1");
        var response = new EntidadTiendaResponse();
        response.setId(1L);
        when(service.createTienda(10L, request)).thenReturn(response);
        var result = controller.createTienda(10L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Tienda creada");
    }

    // ── transportes ───────────────────────────────────────────────────────

    @Test void listTransportes_returnsOk() {
        var transp = new EntidadTransporteResponse();
        transp.setId(1L);
        when(service.listTransportes(10L)).thenReturn(List.of(transp));
        var result = controller.listTransportes(10L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
    }

    @Test void createTransporte_returnsCreated() {
        var request = new EntidadTransporteRequest("ABC-123", "LIC01", "MTC01", "Chofer 1");
        var response = new EntidadTransporteResponse();
        response.setId(1L);
        when(service.createTransporte(10L, request)).thenReturn(response);
        var result = controller.createTransporte(10L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Transporte creado");
    }

    // ── articulos ─────────────────────────────────────────────────────────

    @Test void listArticulos_returnsOk() {
        var art = new ArticuloProveedorResponse();
        art.setId(1L);
        when(service.listArticulos(10L)).thenReturn(List.of(art));
        var result = controller.listArticulos(10L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
    }

    @Test void createArticulo_returnsCreated() {
        var request = new ArticuloProveedorRequest(10L, 99L);
        var response = new ArticuloProveedorResponse();
        response.setId(1L);
        when(service.createArticulo(10L, 99L)).thenReturn(response);
        var result = controller.createArticulo(10L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Artículo asociado al proveedor");
    }

    // ── telefonos ─────────────────────────────────────────────────────────

    @Test void listTelefonos_returnsOk() {
        var tel = new EntidadContribuyenteTelefonoResponse();
        tel.setId(1L);
        when(service.listTelefonos(10L)).thenReturn(List.of(tel));
        var result = controller.listTelefonos(10L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
    }

    @Test void createTelefono_returnsCreated() {
        var request = new EntidadContribuyenteTelefonoRequest("Principal", "51", "1", "4567890", "0");
        var response = new EntidadContribuyenteTelefonoResponse();
        response.setId(1L);
        when(service.createTelefono(10L, request)).thenReturn(response);
        var result = controller.createTelefono(10L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Teléfono creado");
    }

    // ── representantes ────────────────────────────────────────────────────

    @Test void listRepresentantes_returnsOk() {
        var rep = new EntidadContribuyenteRepresentanteResponse();
        rep.setId(1L);
        when(service.listRepresentantes(10L)).thenReturn(List.of(rep));
        var result = controller.listRepresentantes(10L);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getData()).hasSize(1);
    }

    @Test void createRepresentante_returnsCreated() {
        var request = new EntidadContribuyenteRepresentanteRequest("Carlos", "Gerente", "999", "c@e.com");
        var response = new EntidadContribuyenteRepresentanteResponse();
        response.setId(1L);
        when(service.createRepresentante(10L, request)).thenReturn(response);
        var result = controller.createRepresentante(10L, request);
        assertThat(result.isSuccess()).isTrue();
        assertThat(result.getMessage()).isEqualTo("Representante creado");
    }
}
