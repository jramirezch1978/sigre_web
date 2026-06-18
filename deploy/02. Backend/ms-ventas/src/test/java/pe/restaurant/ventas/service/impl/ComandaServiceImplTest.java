package pe.restaurant.ventas.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.http.HttpStatus;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.ComandaCabeceraRequest;
import pe.restaurant.ventas.dto.request.ComandaEstadoRequest;
import pe.restaurant.ventas.dto.request.ComandaItemRequest;
import pe.restaurant.ventas.dto.request.ComandaItemsAppendRequest;
import pe.restaurant.ventas.entity.Comanda;
import pe.restaurant.ventas.entity.ComandaDet;
import pe.restaurant.ventas.repository.ArticuloRepository;
import pe.restaurant.ventas.repository.ComandaRepository;
import pe.restaurant.ventas.repository.VentasFkValidator;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("ComandaServiceImpl — Pruebas Unitarias")
class ComandaServiceImplTest {

    @Mock
    private ComandaRepository comandaRepository;
    @Mock
    private ArticuloRepository articuloRepository;
    @Mock
    private VentasFkValidator fkValidator;
    @InjectMocks
    private ComandaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(10L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ==== findAll ====

    @Test
    @DisplayName("findAll() con sucursalId -> filtra por sucursal del request")
    void findAll_conSucursal_usaSucursalDelRequest() {
        when(comandaRepository.findAll(any(Specification.class), eq(Pageable.unpaged())))
                .thenReturn(new PageImpl<>(List.of()));

        Pageable pageable = Pageable.unpaged();
        var result = service.findAll(7L, null, null, null, null, null, pageable);

        assertThat(result.getContent()).isEmpty();
        @SuppressWarnings("unchecked")
        ArgumentCaptor<Specification<Comanda>> cap = ArgumentCaptor.forClass(Specification.class);
        verify(comandaRepository).findAll(cap.capture(), eq(pageable));
        assertThat(cap.getValue()).isNotNull();
    }

    @Test
    @DisplayName("findAll() con sucursalId nulo -> usa sucursal del TenantContext")
    void findAll_sinSucursal_usaTenant() {
        TenantContext.setSucursalId(99L);
        when(comandaRepository.findAll(any(Specification.class), eq(Pageable.unpaged())))
                .thenReturn(new PageImpl<>(List.of()));

        service.findAll(null, null, null, null, null, null, Pageable.unpaged());

        verify(comandaRepository).findAll(any(Specification.class), eq(Pageable.unpaged()));
    }

    // ==== getById ====

    @Test
    @DisplayName("getById() con ID existente -> retorna comanda")
    void getById_cuandoExiste_retornaComanda() {
        Comanda c = comanda(1L, "1");
        when(comandaRepository.findByIdWithDetalles(1L)).thenReturn(Optional.of(c));

        var result = service.getById(1L);

        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("getById() con ID inexistente -> lanza ResourceNotFoundException")
    void getById_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(comandaRepository.findByIdWithDetalles(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.getById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== create ====

    @Test
    @DisplayName("create() con datos válidos -> persiste y retorna comanda")
    void create_conDatosValidos_retornaCreado() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(true);
        when(comandaRepository.save(any())).thenAnswer(inv -> {
            Comanda c = inv.getArgument(0);
            c.setId(5L);
            return c;
        });

        var resp = service.create(cabeceraRequest());

        assertThat(resp.getId()).isEqualTo(5L);
        assertThat(resp.getTotal()).isEqualByComparingTo("20.0000");
    }

    @Test
    @DisplayName("create() sin usuario en contexto -> lanza BusinessException")
    void create_sinUsuario_lanzaBusinessException() {
        TenantContext.clear();

        assertThatThrownBy(() -> service.create(cabeceraRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Usuario no resoluble");
    }

    @Test
    @DisplayName("create() con sucursal inactiva -> lanza BusinessException")
    void create_cuandoSucursalInactiva_lanzaBusinessException() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(cabeceraRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Sucursal no válida");
    }

    @Test
    @DisplayName("create() con punto de venta inválido -> lanza BusinessException")
    void create_cuandoPuntoVentaInvalido_lanzaBusinessException() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        var req = cabeceraRequestConFk(200L, null);
        when(fkValidator.existsPuntoVentaActivo(200L, 10L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Punto de venta no válido");
    }

    @Test
    @DisplayName("create() con cliente inválido -> lanza BusinessException")
    void create_cuandoClienteInvalido_lanzaBusinessException() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        var req = cabeceraRequestConFk(null, 300L);
        when(fkValidator.existsEntidadContribuyenteActiva(300L)).thenReturn(false);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Cliente no válido");
    }

    @Test
    @DisplayName("create() con artículo inactivo -> lanza BusinessException")
    void create_cuandoArticuloInactivo_lanzaBusinessException() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(false);

        assertThatThrownBy(() -> service.create(cabeceraRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Artículo no válido");
    }

    // ==== update ====

    @Test
    @DisplayName("update() con datos válidos -> actualiza y retorna")
    void update_conDatosValidos_retornaActualizado() {
        Comanda c = comanda(2L, "1");
        when(comandaRepository.findByIdWithDetalles(2L)).thenReturn(Optional.of(c));
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(true);
        when(comandaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.update(2L, cabeceraRequest());

        assertThat(result.getMesa()).isEqualTo("M-01");
    }

    @Test
    @DisplayName("update() con ID inexistente -> lanza ResourceNotFoundException")
    void update_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(comandaRepository.findByIdWithDetalles(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(99L, cabeceraRequest()))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("update() con comanda inactiva -> lanza BusinessException")
    void update_cuandoComandaInactiva_lanzaBusinessException() {
        Comanda c = comanda(8L, "0");
        when(comandaRepository.findByIdWithDetalles(8L)).thenReturn(Optional.of(c));

        assertThatThrownBy(() -> service.update(8L, cabeceraRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("comanda está inactiva");
    }

    @Test
    @DisplayName("update() con sucursal conflictiva -> lanza BusinessException")
    void update_cuandoSucursalNoCoincide_lanzaBusinessException() {
        Comanda c = comanda(2L, "1");
        c.setSucursalId(5L);
        when(comandaRepository.findByIdWithDetalles(2L)).thenReturn(Optional.of(c));
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);

        assertThatThrownBy(() -> service.update(2L, cabeceraRequest()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("no pertenece a la sucursal");
    }

    // ==== patchEstado ====

    @Test
    @DisplayName("patchEstado() con transición válida -> cambia estado")
    void patchEstado_transicionValida_cambiaEstado() {
        Comanda c = comanda(3L, "1");
        when(comandaRepository.findByIdWithDetalles(3L)).thenReturn(Optional.of(c));
        when(comandaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        ComandaEstadoRequest req = new ComandaEstadoRequest();
        req.setFlagEstado("3");

        var result = service.patchEstado(3L, req);

        assertThat(result.getFlagEstado()).isEqualTo("3");
    }

    @Test
    @DisplayName("patchEstado() con transición inválida -> lanza BusinessException")
    void patchEstado_transicionInvalida_lanzaBusinessException() {
        Comanda c = comanda(4L, "0");
        when(comandaRepository.findByIdWithDetalles(4L)).thenReturn(Optional.of(c));
        ComandaEstadoRequest req = new ComandaEstadoRequest();
        req.setFlagEstado("1");

        assertThatThrownBy(() -> service.patchEstado(4L, req))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("status", HttpStatus.CONFLICT);
    }

    @Test
    @DisplayName("patchEstado() con flagEstado inválido -> lanza BusinessException")
    void patchEstado_flagInvalido_lanzaBusinessException() {
        Comanda c = comanda(5L, "1");
        when(comandaRepository.findByIdWithDetalles(5L)).thenReturn(Optional.of(c));
        ComandaEstadoRequest req = new ComandaEstadoRequest();
        req.setFlagEstado("9");

        assertThatThrownBy(() -> service.patchEstado(5L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("flagEstado no válido");
    }

    @Test
    @DisplayName("patchEstado() con ID inexistente -> lanza ResourceNotFoundException")
    void patchEstado_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(comandaRepository.findByIdWithDetalles(99L)).thenReturn(Optional.empty());
        ComandaEstadoRequest req = new ComandaEstadoRequest();
        req.setFlagEstado("2");

        assertThatThrownBy(() -> service.patchEstado(99L, req))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // ==== addItems ====

    @Test
    @DisplayName("addItems() con items válidos -> agrega y recalcula total")
    void addItems_conItemsValidos_recalculaTotal() {
        Comanda c = comanda(6L, "1");
        when(comandaRepository.findByIdWithDetalles(6L)).thenReturn(Optional.of(c));
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(true);
        when(comandaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        ComandaItemsAppendRequest req = new ComandaItemsAppendRequest();
        req.setItems(cabeceraRequest().getItems());

        var result = service.addItems(6L, req);

        assertThat(result.getTotal()).isEqualByComparingTo("40.0000");
    }

    @Test
    @DisplayName("addItems() con ID inexistente -> lanza ResourceNotFoundException")
    void addItems_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(comandaRepository.findByIdWithDetalles(99L)).thenReturn(Optional.empty());
        ComandaItemsAppendRequest req = new ComandaItemsAppendRequest();
        req.setItems(cabeceraRequest().getItems());

        assertThatThrownBy(() -> service.addItems(99L, req))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("addItems() con comanda inactiva -> lanza BusinessException")
    void addItems_cuandoComandaInactiva_lanzaBusinessException() {
        Comanda c = comanda(6L, "0");
        when(comandaRepository.findByIdWithDetalles(6L)).thenReturn(Optional.of(c));
        ComandaItemsAppendRequest req = new ComandaItemsAppendRequest();
        req.setItems(cabeceraRequest().getItems());

        assertThatThrownBy(() -> service.addItems(6L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("comanda está inactiva");
    }

    @Test
    @DisplayName("addItems() con artículo inactivo -> lanza BusinessException")
    void addItems_cuandoArticuloInactivo_lanzaBusinessException() {
        Comanda c = comanda(6L, "1");
        when(comandaRepository.findByIdWithDetalles(6L)).thenReturn(Optional.of(c));
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(false);
        ComandaItemsAppendRequest req = new ComandaItemsAppendRequest();
        req.setItems(cabeceraRequest().getItems());

        assertThatThrownBy(() -> service.addItems(6L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Artículo no válido");
    }

    // ==== anular ====

    @Test
    @DisplayName("anular() con comanda activa -> cambia flagEstado a 0")
    void anular_conComandaActiva_cambiaFlagEstado() {
        Comanda c = comanda(7L, "1");
        when(comandaRepository.findByIdWithDetalles(7L)).thenReturn(Optional.of(c));
        when(comandaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.anular(7L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    // ==== activate / deactivate ====

    @Test
    @DisplayName("activate() con ID existente -> cambia flagEstado a 1")
    void activate_cuandoExiste_cambiaFlagEstado() {
        Comanda c = comanda(9L, "0");
        when(comandaRepository.findByIdWithDetalles(9L)).thenReturn(Optional.of(c));
        when(comandaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.activate(9L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("activate() con ID inexistente -> lanza ResourceNotFoundException")
    void activate_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(comandaRepository.findByIdWithDetalles(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.activate(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    @Test
    @DisplayName("deactivate() con ID existente -> cambia flagEstado a 0")
    void deactivate_cuandoExiste_cambiaFlagEstado() {
        Comanda c = comanda(10L, "1");
        when(comandaRepository.findByIdWithDetalles(10L)).thenReturn(Optional.of(c));
        when(comandaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.deactivate(10L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    // ==== delete ====

    @Test
    @DisplayName("delete() con ID existente -> desactiva via deactivate")
    void delete_cuandoExiste_desactiva() {
        Comanda c = comanda(11L, "1");
        when(comandaRepository.findByIdWithDetalles(11L)).thenReturn(Optional.of(c));
        when(comandaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        service.delete(11L);

        verify(comandaRepository).save(any());
    }

    @Test
    @DisplayName("patchEstado() mismo estado -> permite transición por identidad")
    void patchEstado_mismoEstado_permiteTransicion() {
        Comanda c = comanda(12L, "1");
        when(comandaRepository.findByIdWithDetalles(12L)).thenReturn(Optional.of(c));
        when(comandaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        ComandaEstadoRequest req = new ComandaEstadoRequest();
        req.setFlagEstado("1");

        var result = service.patchEstado(12L, req);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    @DisplayName("patchEstado() de 1 a 2 -> transición válida")
    void patchEstado_de1a2_transicionValida() {
        Comanda c = comanda(13L, "1");
        when(comandaRepository.findByIdWithDetalles(13L)).thenReturn(Optional.of(c));
        when(comandaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        ComandaEstadoRequest req = new ComandaEstadoRequest();
        req.setFlagEstado("2");

        var result = service.patchEstado(13L, req);

        assertThat(result.getFlagEstado()).isEqualTo("2");
    }

    @Test
    @DisplayName("patchEstado() de 1 a 0 -> transición válida")
    void patchEstado_de1a0_transicionValida() {
        Comanda c = comanda(14L, "1");
        when(comandaRepository.findByIdWithDetalles(14L)).thenReturn(Optional.of(c));
        when(comandaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        ComandaEstadoRequest req = new ComandaEstadoRequest();
        req.setFlagEstado("0");

        var result = service.patchEstado(14L, req);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("create() con fechaHora -> usa la fecha proporcionada")
    void create_conFechaHora_usaFechaProporcionada() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(true);
        when(comandaRepository.save(any())).thenAnswer(inv -> {
            Comanda c = inv.getArgument(0);
            c.setId(15L);
            return c;
        });
        var req = cabeceraRequest();
        req.setFechaHora(java.time.Instant.parse("2026-01-01T00:00:00Z"));

        var resp = service.create(req);

        assertThat(resp.getId()).isEqualTo(15L);
    }

    @Test
    @DisplayName("create() sin sucursal en request -> usa contexto")
    void create_sinSucursal_usaContexto() {
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(true);
        when(comandaRepository.save(any())).thenAnswer(inv -> {
            Comanda c = inv.getArgument(0);
            c.setId(16L);
            return c;
        });
        var req = cabeceraRequest();
        req.setSucursalId(null);
        req.setClienteId(null);
        req.setPuntoVentaId(null);

        var resp = service.create(req);

        assertThat(resp.getId()).isEqualTo(16L);
    }

    @Test
    @DisplayName("create() con sucursal conflictiva en request -> lanza BusinessException")
    void create_cuandoSucursalNoCoincideConToken_lanzaBusinessException() {
        var req = cabeceraRequest();
        req.setSucursalId(99L);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursalId no coincide con el token");
    }

    @Test
    @DisplayName("update() con fechaHora -> actualiza la fecha")
    void update_conFechaHora_actualizaFecha() {
        Comanda c = comanda(17L, "1");
        when(comandaRepository.findByIdWithDetalles(17L)).thenReturn(Optional.of(c));
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(true);
        when(comandaRepository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        var req = cabeceraRequest();
        req.setFechaHora(java.time.Instant.parse("2026-06-01T12:00:00Z"));

        var result = service.update(17L, req);

        assertThat(result.getId()).isEqualTo(17L);
    }

    @Test
    @DisplayName("validateCabeceraFk() con puntoVentaId nulo y clienteId nulo -> salta validaciones")
    void create_conPuntoVentaNuloYClienteNulo_saltaValidaciones() {
        when(fkValidator.existsSucursalActiva(10L)).thenReturn(true);
        when(articuloRepository.existsByIdAndFlagEstado(100L, "1")).thenReturn(true);
        when(comandaRepository.save(any())).thenAnswer(inv -> {
            Comanda c = inv.getArgument(0);
            c.setId(18L);
            return c;
        });
        var req = cabeceraRequest();
        req.setClienteId(null);
        req.setPuntoVentaId(null);

        var resp = service.create(req);

        assertThat(resp.getId()).isEqualTo(18L);
    }

    // ==== helpers ====

    private static ComandaCabeceraRequest cabeceraRequest() {
        ComandaCabeceraRequest req = new ComandaCabeceraRequest();
        req.setSucursalId(10L);
        req.setMesa("M-01");
        ComandaItemRequest item = new ComandaItemRequest();
        item.setArticuloId(100L);
        item.setCantidad(new BigDecimal("2"));
        item.setPrecioUnitario(new BigDecimal("10"));
        req.setItems(List.of(item));
        return req;
    }

    private static ComandaCabeceraRequest cabeceraRequestConFk(Long puntoVentaId, Long clienteId) {
        ComandaCabeceraRequest req = cabeceraRequest();
        req.setPuntoVentaId(puntoVentaId);
        req.setClienteId(clienteId);
        return req;
    }

    private static Comanda comanda(Long id, String flag) {
        Comanda c = new Comanda();
        c.setId(id);
        c.setSucursalId(10L);
        c.setMesa("M-01");
        c.setFlagEstado(flag);
        c.setTotal(new BigDecimal("20.0000"));
        ComandaDet det = new ComandaDet();
        det.setArticuloId(100L);
        det.setCantidad(new BigDecimal("2"));
        det.setPrecioUnitario(new BigDecimal("10"));
        det.setSubtotal(new BigDecimal("20.0000"));
        det.setFlagEstado("1");
        c.setDetalles(new ArrayList<>(List.of(det)));
        return c;
    }
}
