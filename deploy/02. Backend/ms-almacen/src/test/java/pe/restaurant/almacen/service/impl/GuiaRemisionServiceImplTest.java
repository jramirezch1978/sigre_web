package pe.restaurant.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import pe.restaurant.almacen.dto.GuiaLineaRequest;
import pe.restaurant.almacen.dto.GuiaRequest;
import pe.restaurant.almacen.entity.Guia;
import pe.restaurant.almacen.entity.GuiaDet;
import pe.restaurant.almacen.repository.GuiaDetRepository;
import pe.restaurant.almacen.repository.GuiaRepository;
import pe.restaurant.almacen.repository.ValeMovRepository;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import org.springframework.jdbc.core.JdbcTemplate;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Guías de remisión: duplicados, edición por estado y anulación idempotente.
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class GuiaRemisionServiceImplTest {

    @Mock
    private GuiaRepository guiaRepository;
    @Mock
    private GuiaDetRepository guiaDetRepository;
    @Mock
    private ValeMovRepository valeMovRepository;
    @Mock
    private JdbcTemplate jdbcTemplate;

    @InjectMocks
    private GuiaRemisionServiceImpl service;

    @BeforeEach
    void stubJdbcCounts() {
        when(jdbcTemplate.queryForObject(contains("auth.sucursal"), eq(Integer.class), anyLong()))
                .thenReturn(1);
        when(jdbcTemplate.queryForObject(contains("entidad_contribuyente"), eq(Integer.class), anyLong()))
                .thenReturn(1);
        when(jdbcTemplate.queryForObject(contains("core.articulo"), eq(Integer.class), anyLong()))
                .thenReturn(1);
        when(jdbcTemplate.queryForObject(contains("unidad_medida"), eq(Integer.class), anyLong()))
                .thenReturn(1);
    }

    private GuiaRequest requestGuia(String serie, String numero) {
        GuiaRequest r = new GuiaRequest();
        r.setSucursalId(1L);
        r.setSerie(serie);
        r.setNumero(numero);
        r.setFechaEmision(LocalDate.now());
        r.setDestinatarioId(100L);
        GuiaLineaRequest linea = new GuiaLineaRequest();
        linea.setArticuloId(1L);
        linea.setUnidadMedidaId(1L);
        linea.setCantidad(BigDecimal.TEN);
        r.setLineas(List.of(linea));
        return r;
    }

    @Test
    void buscar_devuelvePaginaSinLineas() {
        Guia g = new Guia();
        g.setId(1L);
        g.setSerie("T001");
        g.setNumero("100");
        when(guiaRepository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(g)));

        var page = service.buscar(1L, "1", null, null, null, null, null, Pageable.unpaged());

        assertThat(page.getContent()).hasSize(1);
        assertThat(page.getContent().get(0).getLineas()).isEmpty();
    }

    @Test
    void obtener_conLineas() {
        Guia g = new Guia();
        g.setId(5L);
        g.setSerie("T001");
        g.setNumero("101");
        GuiaDet det = new GuiaDet();
        det.setId(10L);
        det.setArticuloId(1L);
        when(guiaRepository.findById(5L)).thenReturn(Optional.of(g));
        when(guiaDetRepository.findByGuiaIdOrderById(5L)).thenReturn(List.of(det));

        assertThat(service.obtener(5L).getLineas()).hasSize(1);
    }

    @Test
    void crear_rechazaDuplicadoSerieNumero() {
        GuiaRequest r = requestGuia("T001", "123");
        when(guiaRepository.existsBySucursalIdAndSerieAndNumero(1L, "T001", "123")).thenReturn(true);
        assertThatThrownBy(() -> service.crear(r))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");
        verify(guiaRepository, never()).save(any());
    }

    @Test
    void crear_ok() {
        GuiaRequest r = requestGuia("T001", "124");
        when(guiaRepository.existsBySucursalIdAndSerieAndNumero(1L, "T001", "124")).thenReturn(false);
        when(guiaRepository.save(any(Guia.class))).thenAnswer(inv -> {
            Guia g = inv.getArgument(0);
            g.setId(50L);
            return g;
        });
        when(guiaDetRepository.findByGuiaIdOrderById(50L)).thenReturn(Collections.emptyList());

        var out = service.crear(r);
        assertThat(out.getId()).isEqualTo(50L);
        verify(guiaDetRepository, times(1)).save(any());
    }

    @Test
    void actualizar_rechazaSiNoActiva() {
        Guia g = new Guia();
        g.setId(1L);
        g.setFlagEstado("0");
        when(guiaRepository.findById(1L)).thenReturn(Optional.of(g));
        assertThatThrownBy(() -> service.actualizar(1L, requestGuia("T001", "200")))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activa");
    }

    @Test
    void anular_rechazaSiYaAnulada() {
        Guia g = new Guia();
        g.setId(2L);
        g.setFlagEstado("0");
        when(guiaRepository.findById(2L)).thenReturn(Optional.of(g));
        assertThatThrownBy(() -> service.anular(2L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya está anulada");
        verify(guiaRepository, never()).save(any());
    }

    @Test
    void anular_activa_ok() {
        Guia g = new Guia();
        g.setId(3L);
        g.setFlagEstado("1");
        when(guiaRepository.findById(3L)).thenReturn(Optional.of(g));
        when(guiaRepository.save(any(Guia.class))).thenAnswer(i -> i.getArgument(0));
        when(guiaDetRepository.findByGuiaIdOrderById(3L)).thenReturn(Collections.emptyList());

        var out = service.anular(3L);
        assertThat(out.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void obtener_lanzaSiNoExiste() {
        when(guiaRepository.findById(999L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.obtener(999L)).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void ponerEnTransito_activa_ok() {
        Guia g = new Guia();
        g.setId(10L);
        g.setFlagEstado("1");
        when(guiaRepository.findById(10L)).thenReturn(Optional.of(g));
        when(guiaRepository.save(any(Guia.class))).thenAnswer(i -> i.getArgument(0));
        when(guiaDetRepository.findByGuiaIdOrderById(10L)).thenReturn(Collections.emptyList());

        var out = service.ponerEnTransito(10L);
        assertThat(out.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void ponerEnTransito_rechazaSiNoActiva() {
        Guia g = new Guia();
        g.setId(11L);
        g.setFlagEstado("0");
        when(guiaRepository.findById(11L)).thenReturn(Optional.of(g));
        assertThatThrownBy(() -> service.ponerEnTransito(11L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activas");
        verify(guiaRepository, never()).save(any());
    }

    @Test
    void marcarEntregada_activa_ok() {
        Guia g = new Guia();
        g.setId(12L);
        g.setFlagEstado("1");
        when(guiaRepository.findById(12L)).thenReturn(Optional.of(g));
        when(guiaRepository.save(any(Guia.class))).thenAnswer(i -> i.getArgument(0));
        when(guiaDetRepository.findByGuiaIdOrderById(12L)).thenReturn(Collections.emptyList());

        var out = service.marcarEntregada(12L);
        assertThat(out.getFlagEstado()).isEqualTo("2");
    }

    @Test
    void marcarEntregada_rechazaSiNoActiva() {
        Guia g = new Guia();
        g.setId(13L);
        g.setFlagEstado("0");
        when(guiaRepository.findById(13L)).thenReturn(Optional.of(g));
        assertThatThrownBy(() -> service.marcarEntregada(13L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("activas");
        verify(guiaRepository, never()).save(any());
    }

    @Test
    void crear_rechazaCantidadCero() {
        GuiaRequest r = requestGuia("T001", "125");
        r.getLineas().get(0).setCantidad(BigDecimal.ZERO);
        when(guiaRepository.existsBySucursalIdAndSerieAndNumero(1L, "T001", "125")).thenReturn(false);

        assertThatThrownBy(() -> service.crear(r))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-GUIA-002");
        verify(guiaRepository, never()).save(any());
    }

    @Test
    void crear_rechazaArticuloInexistente() {
        GuiaRequest r = requestGuia("T001", "130");
        when(guiaRepository.existsBySucursalIdAndSerieAndNumero(1L, "T001", "130")).thenReturn(false);
        when(jdbcTemplate.queryForObject(contains("core.articulo"), eq(Integer.class), eq(1L)))
                .thenReturn(0);

        assertThatThrownBy(() -> service.crear(r))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void crear_rechazaUnidadMedidaInexistente() {
        GuiaRequest r = requestGuia("T001", "129");
        when(guiaRepository.existsBySucursalIdAndSerieAndNumero(1L, "T001", "129")).thenReturn(false);
        when(jdbcTemplate.queryForObject(contains("unidad_medida"), eq(Integer.class), eq(1L)))
                .thenReturn(0);

        assertThatThrownBy(() -> service.crear(r))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void crear_rechazaMotivoTrasladoInexistente() {
        GuiaRequest r = requestGuia("T001", "127");
        r.setMotivoTrasladoId(99L);
        when(jdbcTemplate.queryForObject(contains("motivo_traslado"), eq(Integer.class), eq(99L)))
                .thenReturn(0);

        assertThatThrownBy(() -> service.crear(r))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void crear_rechazaValeMovInexistente() {
        GuiaRequest r = requestGuia("T001", "128");
        r.setValeMovId(500L);
        when(valeMovRepository.existsById(500L)).thenReturn(false);

        assertThatThrownBy(() -> service.crear(r))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void crear_rechazaSucursalInexistente() {
        GuiaRequest r = requestGuia("T001", "126");
        when(jdbcTemplate.queryForObject(contains("auth.sucursal"), eq(Integer.class), eq(1L)))
                .thenReturn(0);

        assertThatThrownBy(() -> service.crear(r))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void actualizar_ok() {
        Guia g = new Guia();
        g.setId(20L);
        g.setFlagEstado("1");
        GuiaRequest r = requestGuia("T002", "300");
        when(guiaRepository.findById(20L)).thenReturn(Optional.of(g));
        when(guiaRepository.existsBySucursalIdAndSerieIgnoreCaseAndNumeroIgnoreCaseAndIdNot(
                1L, "T002", "300", 20L)).thenReturn(false);
        when(guiaRepository.save(any(Guia.class))).thenAnswer(i -> i.getArgument(0));
        when(guiaDetRepository.findByGuiaIdOrderById(20L)).thenReturn(Collections.emptyList());

        var out = service.actualizar(20L, r);

        assertThat(out.getSerie()).isEqualTo("T002");
        verify(guiaDetRepository).deleteByGuiaId(20L);
        verify(guiaDetRepository).save(any());
    }

    @Test
    void crear_rechazaDestinatarioInexistente() {
        GuiaRequest r = requestGuia("T001", "131");
        when(jdbcTemplate.queryForObject(contains("entidad_contribuyente"), eq(Integer.class), eq(100L)))
                .thenReturn(0);

        assertThatThrownBy(() -> service.crear(r))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void actualizar_rechazaCantidadCero() {
        Guia g = new Guia();
        g.setId(22L);
        g.setFlagEstado("1");
        GuiaRequest r = requestGuia("T001", "301");
        r.getLineas().get(0).setCantidad(BigDecimal.ZERO);
        when(guiaRepository.findById(22L)).thenReturn(Optional.of(g));

        assertThatThrownBy(() -> service.actualizar(22L, r))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-GUIA-002");
    }

    @Test
    void actualizar_rechazaDuplicadoSerieNumero() {
        Guia g = new Guia();
        g.setId(21L);
        g.setFlagEstado("1");
        when(guiaRepository.findById(21L)).thenReturn(Optional.of(g));
        when(guiaRepository.existsBySucursalIdAndSerieIgnoreCaseAndNumeroIgnoreCaseAndIdNot(
                1L, "T001", "200", 21L)).thenReturn(true);

        assertThatThrownBy(() -> service.actualizar(21L, requestGuia("T001", "200")))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-GUIA-001");
    }
}
