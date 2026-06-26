package pe.restaurant.ventas.service.impl;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.service.NumeradorDocumentoService;
import pe.restaurant.ventas.dto.request.ProformaDetLineRequest;
import pe.restaurant.ventas.dto.request.ProformaRequest;
import pe.restaurant.ventas.entity.Proforma;
import pe.restaurant.ventas.repository.ProformaRepository;
import pe.restaurant.ventas.service.VentasNumeradorTablas;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("ProformaServiceImpl — Pruebas Unitarias")
class ProformaServiceImplTest {

    @Mock
    private ProformaRepository repository;

    @Mock
    private NumeradorDocumentoService numeradorDocumentoService;

    @InjectMocks
    private ProformaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // ── helpers ──────────────────────────────────────────────────────────────

    private ProformaRequest request(String numero, Long sucursalId, Long articuloId, boolean conDetalle) {
        ProformaRequest r = new ProformaRequest();
        r.setNumero(numero);
        r.setSucursalId(sucursalId);
        r.setClienteId(1L);
        r.setFecha(LocalDate.of(2026, 5, 23));
        r.setFechaValidez(LocalDate.of(2026, 6, 23));
        r.setMonedaId(1L);
        if (conDetalle) {
            ProformaDetLineRequest line = new ProformaDetLineRequest();
            line.setArticuloId(articuloId);
            line.setCantidad(new BigDecimal("2"));
            line.setPrecioUnitario(new BigDecimal("100.00"));
            line.setDescripcion("Artículo " + articuloId);
            r.setDetalles(List.of(line));
        } else {
            r.setDetalles(new ArrayList<>());
        }
        return r;
    }

    private Proforma stub(Long id, String flagEstado) {
        Proforma p = new Proforma();
        p.setId(id);
        p.setFlagEstado(flagEstado);
        p.setSucursalId(1L);
        p.setClienteId(1L);
        p.setNumero("PF-" + id);
        p.setFecha(LocalDate.of(2026, 5, 23));
        p.setMonedaId(1L);
        p.setDetalles(new ArrayList<>());
        return p;
    }

    // ── findById ────────────────────────────────────────────────────────────

    @Test
    @DisplayName("findById -> cuando existe, retorna la entidad")
    void findById_cuandoExiste_retornaEntidad() {
        Proforma p = stub(1L, "1");
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(p));

        Proforma result = service.findById(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNumero()).isEqualTo("PF-1");
    }

    @Test
    @DisplayName("findById -> cuando no existe, lanza ResourceNotFoundException")
    void findById_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findByIdWithDetalles(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(999L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("999");
    }

    // ── findAll ─────────────────────────────────────────────────────────────

    @Test
    @DisplayName("findAll -> con filtros, retorna página")
    void findAll_conFiltros_retornaPagina() {
        Page<Proforma> page = new PageImpl<>(List.of());
        when(repository.findWithFilters(any(), any(), any(), any())).thenReturn(page);

        Page<Proforma> result = service.findAll(1L, 2L, "PF", Pageable.unpaged());

        assertThat(result).isEqualTo(page);
    }

    // ── create ──────────────────────────────────────────────────────────────

    @Test
    @DisplayName("create -> con número explícito, usa el número proporcionado")
    void create_conNumeroExplicito_usaNumero() {
        var req = request("PF-001", 1L, 100L, true);
        when(repository.existsByNumero("PF-001")).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Proforma p = service.create(req);

        assertThat(p.getNumero()).isEqualTo("PF-001");
    }

    @Test
    @DisplayName("create -> con número duplicado, lanza BusinessException")
    void create_conNumeroDuplicado_lanzaBusinessException() {
        var req = request("PF-DUP", 1L, 100L, true);
        when(repository.existsByNumero("PF-DUP")).thenReturn(true);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("duplicado");
    }

    @Test
    @DisplayName("create -> sin número y con sucursal, genera número automáticamente")
    void create_sinNumeroConSucursal_generaNumero() {
        var req = request(null, 1L, 100L, true);
        when(numeradorDocumentoService.siguienteNroDocumento(
                eq(VentasNumeradorTablas.PROFORMA), eq(1L), anyInt()))
                .thenReturn("012026000001");
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Proforma p = service.create(req);

        assertThat(p.getNumero()).isEqualTo("012026000001");
    }

    @Test
    @DisplayName("create -> sin número y sin sucursal, lanza BusinessException")
    void create_sinNumeroSinSucursal_lanzaBusinessException() {
        var req = request(null, null, 100L, true);

        assertThatThrownBy(() -> service.create(req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("sucursalId");
    }

    @Test
    @DisplayName("create -> con detalles vacíos, subtotal/igv/total en cero")
    void create_conDetallesVacios_ceros() {
        var req = request("PF-CEROS", 1L, null, false);
        when(repository.existsByNumero("PF-CEROS")).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Proforma p = service.create(req);

        assertThat(p.getSubtotal()).isEqualByComparingTo("0.0000");
        assertThat(p.getIgv()).isEqualByComparingTo("0.0000");
        assertThat(p.getTotal()).isEqualByComparingTo("0.0000");
    }

    @Test
    @DisplayName("create -> con descuento en línea, calcula subtotal/igv/total correctamente")
    void create_conDescuentoEnLinea_calculaCorrectamente() {
        var req = request("PF-DSCTO", 1L, null, false);
        req.setNumero("PF-DSCTO");
        ProformaDetLineRequest line = new ProformaDetLineRequest();
        line.setArticuloId(200L);
        line.setCantidad(new BigDecimal("2"));
        line.setPrecioUnitario(new BigDecimal("100.00"));
        line.setDescuento(new BigDecimal("10.00"));
        line.setDescripcion("Artículo con descuento");
        req.setDetalles(List.of(line));
        when(repository.existsByNumero("PF-DSCTO")).thenReturn(false);
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Proforma p = service.create(req);

        assertThat(p.getSubtotal()).isEqualByComparingTo("190.0000");
        assertThat(p.getIgv()).isEqualByComparingTo("34.2000");
        assertThat(p.getTotal()).isEqualByComparingTo("224.2000");
    }

    // ── update ──────────────────────────────────────────────────────────────

    @Test
    @DisplayName("update -> con datos válidos, retorna entidad actualizada")
    void update_conDatosValidos_retornaActualizado() {
        Proforma p = stub(1L, "1");
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(p));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));
        var req = request("PF-UPD", 1L, 200L, true);

        Proforma out = service.update(1L, req);

        assertThat(out).isNotNull();
        assertThat(out.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("update -> cuando id no existe, lanza ResourceNotFoundException")
    void update_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findByIdWithDetalles(999L)).thenReturn(Optional.empty());
        var req = request("PF-UPD", 1L, 200L, true);

        assertThatThrownBy(() -> service.update(999L, req))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("update -> cuando está inactivo, lanza BusinessException")
    void update_cuandoInactivo_lanzaBusinessException() {
        Proforma p = stub(1L, "0");
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(p));
        var req = request("PF-UPD", 1L, 200L, true);

        assertThatThrownBy(() -> service.update(1L, req))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("inactivo");
    }

    // ── anular ──────────────────────────────────────────────────────────────

    @Test
    @DisplayName("anular -> cuando está activo, cambia flagEstado a 0")
    void anular_cuandoActivo_cambiaFlagEstado() {
        Proforma p = stub(1L, "1");
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(p));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Proforma out = service.anular(1L);

        assertThat(out.getFlagEstado()).isEqualTo("0");
    }

    @Test
    @DisplayName("anular -> cuando está inactivo, lanza BusinessException")
    void anular_cuandoInactivo_lanzaBusinessException() {
        Proforma p = stub(1L, "0");
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(p));

        assertThatThrownBy(() -> service.anular(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("inactivo");
    }

    // ── marcarVencida ───────────────────────────────────────────────────────

    @Test
    @DisplayName("marcarVencida -> cuando está activo, guarda y retorna")
    void marcarVencida_cuandoActivo_guarda() {
        Proforma p = stub(1L, "1");
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(p));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Proforma out = service.marcarVencida(1L);

        assertThat(out).isNotNull();
        assertThat(out.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("marcarVencida -> cuando está inactivo, lanza BusinessException")
    void marcarVencida_cuandoInactivo_lanzaBusinessException() {
        Proforma p = stub(1L, "0");
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(p));

        assertThatThrownBy(() -> service.marcarVencida(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("inactivo");
    }

    // ── marcarConvertida ────────────────────────────────────────────────────

    @Test
    @DisplayName("marcarConvertida -> cuando está activo, guarda y retorna")
    void marcarConvertida_cuandoActivo_guarda() {
        Proforma p = stub(1L, "1");
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(p));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        Proforma out = service.marcarConvertida(1L);

        assertThat(out).isNotNull();
        assertThat(out.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("marcarConvertida -> cuando está inactivo, lanza BusinessException")
    void marcarConvertida_cuandoInactivo_lanzaBusinessException() {
        Proforma p = stub(1L, "0");
        when(repository.findByIdWithDetalles(1L)).thenReturn(Optional.of(p));

        assertThatThrownBy(() -> service.marcarConvertida(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("inactivo");
    }
}
