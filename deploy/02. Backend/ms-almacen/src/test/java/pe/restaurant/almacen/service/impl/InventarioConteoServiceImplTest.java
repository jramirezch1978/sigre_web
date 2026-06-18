package pe.restaurant.almacen.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.junit.jupiter.MockitoSettings;
import org.mockito.quality.Strictness;
import pe.restaurant.almacen.dto.InventarioConteoRequest;
import pe.restaurant.almacen.entity.InventarioConteo;
import pe.restaurant.almacen.repository.AlmacenRepository;
import pe.restaurant.almacen.repository.InventarioConteoRepository;
import pe.restaurant.almacen.repository.LotePalletRepository;
import pe.restaurant.almacen.repository.UbicacionAlmacenRepository;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.jdbc.core.JdbcTemplate;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Toma de inventario: estados, comparación, cierre y anulación.
 */
@ExtendWith(MockitoExtension.class)
@MockitoSettings(strictness = Strictness.LENIENT)
class InventarioConteoServiceImplTest {

    @Mock
    private InventarioConteoRepository repository;
    @Mock
    private AlmacenRepository almacenRepository;
    @Mock
    private LotePalletRepository lotePalletRepository;
    @Mock
    private UbicacionAlmacenRepository ubicacionAlmacenRepository;
    @Mock
    private JdbcTemplate jdbcTemplate;

    @InjectMocks
    private InventarioConteoServiceImpl service;

    @BeforeEach
    void stubArticuloOk() {
        when(jdbcTemplate.queryForObject(
                contains("FROM core.articulo"),
                eq(Integer.class),
                anyLong())).thenReturn(1);
    }

    private InventarioConteoRequest requestBase() {
        InventarioConteoRequest r = new InventarioConteoRequest();
        r.setAlmacenId(1L);
        r.setArticuloId(10L);
        r.setFechaConteo(LocalDate.now());
        return r;
    }

    @Test
    void crear_persisteActivo() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(repository.save(any(InventarioConteo.class))).thenAnswer(i -> {
            InventarioConteo e = i.getArgument(0);
            e.setId(5L);
            return e;
        });
        InventarioConteoRequest r = requestBase();
        assertThat(service.crear(r).getFlagEstado()).isEqualTo("1");
    }

    @Test
    void actualizar_rechazaSiCerrado() {
        InventarioConteo e = new InventarioConteo();
        e.setId(1L);
        e.setFlagEstado("2");
        e.setAlmacenId(1L);
        e.setArticuloId(10L);
        e.setFechaConteo(LocalDate.now());
        when(repository.findById(1L)).thenReturn(Optional.of(e));
        assertThatThrownBy(() -> service.actualizar(1L, requestBase()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("modificar");
        verify(repository, never()).save(any());
    }

    @Test
    void comparar_calculaDiferencia() {
        InventarioConteo e = new InventarioConteo();
        e.setId(3L);
        e.setFlagEstado("1");
        e.setSaldoSistema(new BigDecimal("100"));
        e.setCantidadConteo1(new BigDecimal("97"));
        when(repository.findById(3L)).thenReturn(Optional.of(e));
        when(repository.save(any(InventarioConteo.class))).thenAnswer(i -> i.getArgument(0));

        var out = service.comparar(3L);
        assertThat(out.getFlagEstado()).isEqualTo("1");
        assertThat(out.getDiferencia()).isEqualByComparingTo(new BigDecimal("-3"));
    }

    @Test
    void comparar_sinSaldo_lanza() {
        InventarioConteo e = new InventarioConteo();
        e.setId(3L);
        e.setFlagEstado("1");
        e.setCantidadConteo1(BigDecimal.ONE);
        when(repository.findById(3L)).thenReturn(Optional.of(e));
        assertThatThrownBy(() -> service.comparar(3L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("saldo");
    }

    @Test
    void cerrar_ok() {
        InventarioConteo e = new InventarioConteo();
        e.setId(4L);
        e.setFlagEstado("1");
        when(repository.findById(4L)).thenReturn(Optional.of(e));
        when(repository.save(any(InventarioConteo.class))).thenAnswer(i -> i.getArgument(0));
        assertThat(service.cerrar(4L).getFlagEstado()).isEqualTo("2");
    }

    @Test
    void anular_desdeActivo_ok() {
        InventarioConteo e = new InventarioConteo();
        e.setId(6L);
        e.setFlagEstado("1");
        when(repository.findById(6L)).thenReturn(Optional.of(e));
        when(repository.save(any(InventarioConteo.class))).thenAnswer(i -> i.getArgument(0));
        assertThat(service.anular(6L).getFlagEstado()).isEqualTo("0");
    }

    @Test
    void obtener_lanzaSiNoExiste() {
        when(repository.findById(99L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.obtener(99L)).isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void obtener_ok() {
        InventarioConteo e = new InventarioConteo();
        e.setId(8L);
        e.setAlmacenId(1L);
        e.setArticuloId(10L);
        e.setFlagEstado("1");
        when(repository.findById(8L)).thenReturn(Optional.of(e));

        assertThat(service.obtener(8L).getId()).isEqualTo(8L);
    }

    @Test
    void actualizar_ok() {
        InventarioConteo e = new InventarioConteo();
        e.setId(9L);
        e.setFlagEstado("1");
        when(repository.findById(9L)).thenReturn(Optional.of(e));
        when(almacenRepository.existsById(1L)).thenReturn(true);
        when(repository.save(any(InventarioConteo.class))).thenAnswer(i -> i.getArgument(0));

        InventarioConteoRequest r = requestBase();
        r.setCantidadConteo1(new BigDecimal("50"));
        assertThat(service.actualizar(9L, r).getCantidadConteo1()).isEqualByComparingTo("50");
    }

    @Test
    void crear_ubicacionDeOtroAlmacen_falla() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        pe.restaurant.almacen.entity.UbicacionAlmacen u = new pe.restaurant.almacen.entity.UbicacionAlmacen();
        u.setId(3L);
        u.setAlmacenId(99L);
        InventarioConteoRequest r = requestBase();
        r.setUbicacionId(3L);
        when(ubicacionAlmacenRepository.findById(3L)).thenReturn(Optional.of(u));

        assertThatThrownBy(() -> service.crear(r))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-INV-001");
    }

    @Test
    void comparar_sinCantidadConteo_falla() {
        InventarioConteo e = new InventarioConteo();
        e.setId(14L);
        e.setFlagEstado("1");
        e.setSaldoSistema(new BigDecimal("10"));
        when(repository.findById(14L)).thenReturn(Optional.of(e));

        assertThatThrownBy(() -> service.comparar(14L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-INV-008");
    }

    @Test
    void comparar_usaCantidadConteo2() {
        InventarioConteo e = new InventarioConteo();
        e.setId(10L);
        e.setFlagEstado("1");
        e.setSaldoSistema(new BigDecimal("100"));
        e.setCantidadConteo2(new BigDecimal("110"));
        when(repository.findById(10L)).thenReturn(Optional.of(e));
        when(repository.save(any(InventarioConteo.class))).thenAnswer(i -> i.getArgument(0));

        assertThat(service.comparar(10L).getDiferencia()).isEqualByComparingTo("10");
    }

    @Test
    void anular_yaCerrado_falla() {
        InventarioConteo e = new InventarioConteo();
        e.setId(12L);
        e.setFlagEstado("2");
        when(repository.findById(12L)).thenReturn(Optional.of(e));

        assertThatThrownBy(() -> service.anular(12L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-INV-010");
    }

    @Test
    void comparar_noActivo_falla() {
        InventarioConteo e = new InventarioConteo();
        e.setId(13L);
        e.setFlagEstado("0");
        when(repository.findById(13L)).thenReturn(Optional.of(e));

        assertThatThrownBy(() -> service.comparar(13L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-INV-006");
    }

    @Test
    void crear_loteInexistente_falla() {
        when(almacenRepository.existsById(1L)).thenReturn(true);
        InventarioConteoRequest r = requestBase();
        r.setLotePalletId(99L);
        when(lotePalletRepository.existsById(99L)).thenReturn(false);

        assertThatThrownBy(() -> service.crear(r))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void cerrar_noActivo_falla() {
        InventarioConteo e = new InventarioConteo();
        e.setId(11L);
        e.setFlagEstado("0");
        when(repository.findById(11L)).thenReturn(Optional.of(e));

        assertThatThrownBy(() -> service.cerrar(11L))
                .isInstanceOf(BusinessException.class)
                .hasFieldOrPropertyWithValue("errorCode", "ALM-INV-009");
    }

    @Test
    void buscar_conRangoFechas_delegaEnRepositorio() {
        LocalDate desde = LocalDate.of(2026, 1, 1);
        LocalDate hasta = LocalDate.of(2026, 6, 30);
        InventarioConteo e = new InventarioConteo();
        e.setId(20L);
        e.setAlmacenId(5L);
        e.setArticuloId(100L);
        e.setFechaConteo(LocalDate.of(2026, 3, 15));
        e.setFlagEstado("1");
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(e)));

        var page = service.buscar(5L, null, null, desde, hasta, Pageable.unpaged());

        assertThat(page.getContent()).hasSize(1);
        assertThat(page.getContent().get(0).getId()).isEqualTo(20L);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }
}
