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
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.ventas.dto.request.CierreCajaCerrarRequest;
import pe.restaurant.ventas.dto.request.CierreCajaRequest;
import pe.restaurant.ventas.entity.CierreCaja;
import pe.restaurant.ventas.repository.CierreCajaRepository;
import pe.restaurant.ventas.testdata.VentasFase4TestDataFactory;

import java.math.BigDecimal;
import java.time.Instant;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("CierreCajaServiceImpl — Pruebas Unitarias")
class CierreCajaServiceImplTest {

    @Mock
    private CierreCajaRepository repository;

    @InjectMocks
    private CierreCajaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    // =========================================
    // findAll
    // =========================================

    @Test
    @DisplayName("findAll() con filtros -> delega al repositorio y retorna pagina")
    void findAll_conFiltros_retornaPagina() {
        Pageable pageable = PageRequest.of(0, 20);
        Page<CierreCaja> page = new PageImpl<>(List.of(entity(1L, 10L)));
        when(repository.findWithFilters(10L, true, pageable)).thenReturn(page);

        Page<CierreCaja> result = service.findAll(10L, true, pageable);

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findWithFilters(10L, true, pageable);
    }

    @Test
    @DisplayName("findAll() con filtros null -> delega al repositorio")
    void findAll_conFiltrosNull_retornaPagina() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<CierreCaja> page = new PageImpl<>(List.of());
        when(repository.findWithFilters(null, null, pageable)).thenReturn(page);

        Page<CierreCaja> result = service.findAll(null, null, pageable);

        assertThat(result.getContent()).isEmpty();
        verify(repository).findWithFilters(null, null, pageable);
    }

    // =========================================
    // findById
    // =========================================

    @Test
    @DisplayName("findById() con ID existente -> retorna entidad")
    void findById_cuandoExiste_retornaEntidad() {
        CierreCaja c = entity(1L, 10L);
        when(repository.findById(1L)).thenReturn(Optional.of(c));

        CierreCaja result = service.findById(1L);

        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getTurnoId()).isEqualTo(10L);
    }

    @Test
    @DisplayName("findById() con ID inexistente -> lanza ResourceNotFoundException")
    void findById_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // =========================================
    // create
    // =========================================

    @Test
    @DisplayName("create() con datos válidos -> persiste con nvl, diferencia=0, fechaCierre=null")
    void create_conDatosValidos_retornaCreado() {
        CierreCajaRequest request = CierreCajaRequest.builder()
                .turnoId(10L)
                .ventasEfectivo(new BigDecimal("10"))
                .ventasTarjeta(new BigDecimal("20"))
                .ventasDigital(new BigDecimal("30"))
                .ventasTotal(new BigDecimal("60"))
                .propinasTotal(new BigDecimal("5"))
                .fondoInicial(new BigDecimal("100"))
                .observaciones("test")
                .build();
        when(repository.countAbiertoByTurno(10L)).thenReturn(0L);
        when(repository.save(any())).thenAnswer(inv -> {
            CierreCaja c = inv.getArgument(0);
            c.setId(55L);
            return c;
        });

        CierreCaja result = service.create(request);

        assertThat(result.getId()).isEqualTo(55L);
        assertThat(result.getTurnoId()).isEqualTo(10L);
        assertThat(result.getVentasEfectivo()).isEqualByComparingTo("10.0000");
        assertThat(result.getVentasTarjeta()).isEqualByComparingTo("20.0000");
        assertThat(result.getVentasDigital()).isEqualByComparingTo("30.0000");
        assertThat(result.getVentasTotal()).isEqualByComparingTo("60.0000");
        assertThat(result.getPropinasTotal()).isEqualByComparingTo("5.0000");
        assertThat(result.getFondoInicial()).isEqualByComparingTo("100.0000");
        assertThat(result.getFondoFinal()).isNull();
        assertThat(result.getDiferencia()).isEqualByComparingTo("0.0000");
        assertThat(result.getFechaCierre()).isNull();
        assertThat(result.getObservaciones()).isEqualTo("test");
        verify(repository).countAbiertoByTurno(10L);
    }

    @Test
    @DisplayName("create() con campos BigDecimal null -> nvl normaliza a 0.0000")
    void create_cuandoCamposNull_normalizaACero() {
        CierreCajaRequest request = CierreCajaRequest.builder()
                .turnoId(10L)
                .ventasEfectivo(null)
                .ventasTarjeta(null)
                .ventasDigital(null)
                .ventasTotal(null)
                .propinasTotal(null)
                .fondoInicial(null)
                .observaciones(null)
                .build();
        when(repository.countAbiertoByTurno(10L)).thenReturn(0L);
        when(repository.save(any())).thenAnswer(inv -> {
            CierreCaja c = inv.getArgument(0);
            c.setId(56L);
            return c;
        });

        CierreCaja result = service.create(request);

        assertThat(result.getVentasEfectivo()).isEqualByComparingTo("0.0000");
        assertThat(result.getVentasTarjeta()).isEqualByComparingTo("0.0000");
        assertThat(result.getVentasDigital()).isEqualByComparingTo("0.0000");
        assertThat(result.getVentasTotal()).isEqualByComparingTo("0.0000");
        assertThat(result.getPropinasTotal()).isEqualByComparingTo("0.0000");
        assertThat(result.getFondoInicial()).isEqualByComparingTo("0.0000");
        assertThat(result.getObservaciones()).isNull();
    }

    @Test
    @DisplayName("create() con turno ya abierto -> lanza BusinessException")
    void create_cuandoTurnoAbierto_lanzaBusinessException() {
        when(repository.countAbiertoByTurno(5L)).thenReturn(1L);

        assertThatThrownBy(() -> service.create(VentasFase4TestDataFactory.cierreAbiertoRequest(5L)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");

        verify(repository).countAbiertoByTurno(5L);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("create() con turnoId null -> salta validación de turno abierto")
    void create_conTurnoNull_continuaSinValidar() {
        CierreCajaRequest request = CierreCajaRequest.builder()
                .turnoId(null)
                .ventasTotal(new BigDecimal("50"))
                .fondoInicial(new BigDecimal("200"))
                .build();
        when(repository.save(any())).thenAnswer(inv -> {
            CierreCaja c = inv.getArgument(0);
            c.setId(57L);
            return c;
        });

        CierreCaja result = service.create(request);

        assertThat(result.getId()).isEqualTo(57L);
        assertThat(result.getTurnoId()).isNull();
        verify(repository, never()).countAbiertoByTurno(any());
    }

    // =========================================
    // cerrar
    // =========================================

    @Test
    @DisplayName("cerrar() sin diferencia explicita -> calcula fondoFin - esperado")
    void cerrar_conDatosValidos_retornaCerrado() {
        CierreCaja c = entity(1L, 9L);
        c.setFondoInicial(new BigDecimal("100.0000"));
        c.setVentasTotal(new BigDecimal("50.0000"));
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CierreCajaCerrarRequest request = CierreCajaCerrarRequest.builder()
                .fondoFinal(new BigDecimal("160"))
                .diferencia(null)
                .build();

        CierreCaja result = service.cerrar(1L, request);

        assertThat(result.getFondoFinal()).isEqualByComparingTo("160.0000");
        assertThat(result.getDiferencia()).isEqualByComparingTo("10.0000");
        assertThat(result.getFechaCierre()).isNotNull();
    }

    @Test
    @DisplayName("cerrar() con diferencia explicita -> usa el valor enviado")
    void cerrar_conDiferenciaExplicita_usaDiferencia() {
        CierreCaja c = entity(1L, 9L);
        c.setFondoInicial(new BigDecimal("100.0000"));
        c.setVentasTotal(new BigDecimal("50.0000"));
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CierreCajaCerrarRequest request = CierreCajaCerrarRequest.builder()
                .fondoFinal(new BigDecimal("160"))
                .diferencia(new BigDecimal("8.0000"))
                .build();

        CierreCaja result = service.cerrar(1L, request);

        assertThat(result.getDiferencia()).isEqualByComparingTo("8.0000");
    }

    @Test
    @DisplayName("cerrar() con observaciones nuevas -> actualiza el campo")
    void cerrar_conObservaciones_guardaObservaciones() {
        CierreCaja c = entity(1L, 9L);
        c.setObservaciones("original");
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CierreCajaCerrarRequest request = CierreCajaCerrarRequest.builder()
                .fondoFinal(new BigDecimal("150"))
                .diferencia(new BigDecimal("0.0000"))
                .observaciones("nueva observacion")
                .build();

        CierreCaja result = service.cerrar(1L, request);

        assertThat(result.getObservaciones()).isEqualTo("nueva observacion");
    }

    @Test
    @DisplayName("cerrar() sin observaciones en request -> mantiene el valor anterior")
    void cerrar_sinObservaciones_mantieneAnterior() {
        CierreCaja c = entity(1L, 9L);
        c.setObservaciones("anterior");
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CierreCajaCerrarRequest request = CierreCajaCerrarRequest.builder()
                .fondoFinal(new BigDecimal("150"))
                .diferencia(new BigDecimal("0.0000"))
                .observaciones(null)
                .build();

        CierreCaja result = service.cerrar(1L, request);

        assertThat(result.getObservaciones()).isEqualTo("anterior");
    }

    @Test
    @DisplayName("cerrar() con fondoInicial y ventasTotal null -> nvl calcula esperado como 0")
    void cerrar_conFondoInicialYVentasNull_calculaEsperadoCero() {
        CierreCaja c = entity(1L, 9L);
        c.setFondoInicial(null);
        c.setVentasTotal(null);
        when(repository.findById(1L)).thenReturn(Optional.of(c));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        CierreCajaCerrarRequest request = CierreCajaCerrarRequest.builder()
                .fondoFinal(new BigDecimal("50"))
                .diferencia(null)
                .build();

        CierreCaja result = service.cerrar(1L, request);

        assertThat(result.getDiferencia()).isEqualByComparingTo("50.0000");
    }

    @Test
    @DisplayName("cerrar() con cierre ya finalizado -> lanza BusinessException")
    void cerrar_cuandoYaFinalizado_lanzaBusinessException() {
        CierreCaja c = entity(2L, 1L);
        c.setFechaCierre(Instant.now());
        when(repository.findById(2L)).thenReturn(Optional.of(c));

        assertThatThrownBy(() -> service.cerrar(2L, VentasFase4TestDataFactory.cierreCerrarRequest(BigDecimal.TEN)))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("finalizado");
    }

    @Test
    @DisplayName("cerrar() con ID inexistente -> lanza ResourceNotFoundException")
    void cerrar_cuandoNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.cerrar(99L, VentasFase4TestDataFactory.cierreCerrarRequest(BigDecimal.TEN)))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("99");
    }

    // =========================================
    // helpers
    // =========================================

    private static CierreCaja entity(Long id, Long turnoId) {
        CierreCaja c = new CierreCaja();
        c.setId(id);
        c.setTurnoId(turnoId);
        c.setFondoInicial(BigDecimal.ZERO);
        c.setVentasTotal(BigDecimal.ZERO);
        c.setDiferencia(BigDecimal.ZERO);
        return c;
    }
}
