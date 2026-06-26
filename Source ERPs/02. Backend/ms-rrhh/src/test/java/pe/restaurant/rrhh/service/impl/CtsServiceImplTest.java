package pe.restaurant.rrhh.service.impl;

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
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.CtsProcesarRequest;
import pe.restaurant.rrhh.dto.response.CtsResponse;
import pe.restaurant.rrhh.entity.Cts;
import pe.restaurant.rrhh.mapper.CtsMapper;
import pe.restaurant.rrhh.repository.CtsRepository;
import pe.restaurant.rrhh.repository.PeriodoCtsRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CtsServiceImpl — Pruebas Unitarias")
class CtsServiceImplTest {

    @Mock private CtsRepository repository;
    @Mock private CtsMapper mapper;
    @Mock private PeriodoCtsRepository periodoRepository;
    @Mock private TrabajadorRepository trabajadorRepository;

    @InjectMocks
    private CtsServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @Test
    @DisplayName("procesar() -> calcula y guarda CTS para todos los activos")
    void procesar_calculaYGuardaCTS() {
        CtsProcesarRequest request = new CtsProcesarRequest();
        request.setAnio(2026);
        request.setPeriodoCtsId(1L);

        when(periodoRepository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.periodoCts(1L)));
        when(trabajadorRepository.findActivosIds()).thenReturn(List.of(1L, 2L));
        when(repository.findRemuneracionByTrabajadorId(1L)).thenReturn(new BigDecimal("3000.0000"));
        when(repository.findRemuneracionByTrabajadorId(2L)).thenReturn(new BigDecimal("2500.0000"));
        when(repository.findByTrabajadorIdAndAnioAndPeriodoCtsId(anyLong(), anyInt(), anyLong())).thenReturn(Optional.empty());
        when(repository.save(any(Cts.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Cts c1 = RrhhTestFixtures.cts(1L);
        Cts c2 = RrhhTestFixtures.cts(2L);
        when(repository.findAll(any(Specification.class))).thenReturn(List.of(c1, c2));
        when(mapper.toResponseList(anyList())).thenReturn(List.of(
                RrhhTestFixtures.ctsResponse(1L),
                RrhhTestFixtures.ctsResponse(2L)
        ));

        List<CtsResponse> result = service.procesar(request);

        assertThat(result).hasSize(2);
        verify(repository, times(2)).findByTrabajadorIdAndAnioAndPeriodoCtsId(anyLong(), eq(2026), eq(1L));
        verify(repository, times(2)).save(any(Cts.class));
    }

    @Test
    @DisplayName("procesar() con periodo inexistente -> lanza BusinessException")
    void procesar_periodoInexistente_lanzaBusinessException() {
        CtsProcesarRequest request = new CtsProcesarRequest();
        request.setAnio(2026);
        request.setPeriodoCtsId(999L);

        when(periodoRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.procesar(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Período CTS no encontrado.");
    }

    @Test
    @DisplayName("procesar() sin trabajadores activos -> lanza BusinessException")
    void procesar_sinTrabajadoresActivos_lanzaBusinessException() {
        CtsProcesarRequest request = new CtsProcesarRequest();
        request.setAnio(2026);
        request.setPeriodoCtsId(1L);

        when(periodoRepository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.periodoCts(1L)));
        when(trabajadorRepository.findActivosIds()).thenReturn(List.of());

        assertThatThrownBy(() -> service.procesar(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No hay trabajadores activos.");
    }

    @Test
    @DisplayName("procesar() salta trabajadores con remuneración cero o nula")
    void procesar_saltaTrabajadoresSinRemuneracion() {
        CtsProcesarRequest request = new CtsProcesarRequest();
        request.setAnio(2026);
        request.setPeriodoCtsId(1L);

        when(periodoRepository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.periodoCts(1L)));
        when(trabajadorRepository.findActivosIds()).thenReturn(List.of(1L));
        when(repository.findRemuneracionByTrabajadorId(1L)).thenReturn(null);

        when(repository.findAll(any(Specification.class))).thenReturn(List.of());
        when(mapper.toResponseList(anyList())).thenReturn(List.of());

        List<CtsResponse> result = service.procesar(request);

        assertThat(result).isEmpty();
        verify(repository, never()).save(any(Cts.class));
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.cts(1L))));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.ctsResponse(1L));

        Page<CtsResponse> result = service.listar(null, null, null, pageable);

        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() con filtros -> aplica especificaciones")
    void listar_conFiltros_aplicaEspecificaciones() {
        Pageable pageable = Pageable.ofSize(10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of()));

        service.listar(1L, 2026, 1L, pageable);

        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna CTS")
    void obtenerPorId_idExistente_retornaCts() {
        when(repository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.cts(1L)));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.ctsResponse(1L));

        CtsResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza BusinessException")
    void obtenerPorId_idInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("CTS no encontrado.");
    }
}
