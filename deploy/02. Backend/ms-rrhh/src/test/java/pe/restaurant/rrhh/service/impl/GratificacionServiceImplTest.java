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
import pe.restaurant.rrhh.dto.request.GratificacionProcesarRequest;
import pe.restaurant.rrhh.dto.response.GratificacionResponse;
import pe.restaurant.rrhh.entity.Gratificacion;
import pe.restaurant.rrhh.entity.PeriodoGratificacion;
import pe.restaurant.rrhh.mapper.GratificacionMapper;
import pe.restaurant.rrhh.repository.GratificacionRepository;
import pe.restaurant.rrhh.repository.PeriodoGratificacionRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("GratificacionServiceImpl — Pruebas Unitarias")
class GratificacionServiceImplTest {

    @Mock private GratificacionRepository repository;
    @Mock private GratificacionMapper mapper;
    @Mock private PeriodoGratificacionRepository periodoRepository;
    @Mock private TrabajadorRepository trabajadorRepository;

    @InjectMocks
    private GratificacionServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
    }

    @Test
    @DisplayName("procesar() -> calcula y guarda gratificaciones para todos los activos")
    void procesar_calculaYGuardaGratificaciones() {
        GratificacionProcesarRequest request = new GratificacionProcesarRequest();
        request.setAnio(2026);
        request.setPeriodoGratificacionId(1L);

        when(periodoRepository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.periodoGratificacion(1L)));
        when(trabajadorRepository.findActivosIds()).thenReturn(List.of(1L, 2L));
        when(repository.findRemuneracionByTrabajadorId(1L)).thenReturn(new BigDecimal("3000.0000"));
        when(repository.findRemuneracionByTrabajadorId(2L)).thenReturn(new BigDecimal("2500.0000"));
        when(repository.findByTrabajadorIdAndAnioAndPeriodoGratificacionId(anyLong(), anyInt(), anyLong())).thenReturn(Optional.empty());
        when(repository.save(any(Gratificacion.class))).thenAnswer(invocation -> invocation.getArgument(0));

        Gratificacion g1 = RrhhTestFixtures.gratificacion(1L);
        Gratificacion g2 = RrhhTestFixtures.gratificacion(2L);
        when(repository.findAll(any(Specification.class))).thenReturn(List.of(g1, g2));
        when(mapper.toResponseList(anyList())).thenReturn(List.of(
                RrhhTestFixtures.gratificacionResponse(1L),
                RrhhTestFixtures.gratificacionResponse(2L)
        ));

        List<GratificacionResponse> result = service.procesar(request);

        assertThat(result).hasSize(2);
        verify(repository, times(2)).findByTrabajadorIdAndAnioAndPeriodoGratificacionId(anyLong(), eq(2026), eq(1L));
        verify(repository, times(2)).save(any(Gratificacion.class));
    }

    @Test
    @DisplayName("procesar() con periodo inexistente -> lanza BusinessException")
    void procesar_periodoInexistente_lanzaBusinessException() {
        GratificacionProcesarRequest request = new GratificacionProcesarRequest();
        request.setAnio(2026);
        request.setPeriodoGratificacionId(999L);

        when(periodoRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.procesar(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Período de gratificación no encontrado.");
    }

    @Test
    @DisplayName("procesar() sin trabajadores activos -> lanza BusinessException")
    void procesar_sinTrabajadoresActivos_lanzaBusinessException() {
        GratificacionProcesarRequest request = new GratificacionProcesarRequest();
        request.setAnio(2026);
        request.setPeriodoGratificacionId(1L);

        when(periodoRepository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.periodoGratificacion(1L)));
        when(trabajadorRepository.findActivosIds()).thenReturn(List.of());

        assertThatThrownBy(() -> service.procesar(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("No hay trabajadores activos");
    }

    @Test
    @DisplayName("procesar() salta trabajadores con remuneración cero o nula")
    void procesar_saltaTrabajadoresSinRemuneracion() {
        GratificacionProcesarRequest request = new GratificacionProcesarRequest();
        request.setAnio(2026);
        request.setPeriodoGratificacionId(1L);

        when(periodoRepository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.periodoGratificacion(1L)));
        when(trabajadorRepository.findActivosIds()).thenReturn(List.of(1L, 2L));
        when(repository.findRemuneracionByTrabajadorId(1L)).thenReturn(null);
        when(repository.findRemuneracionByTrabajadorId(2L)).thenReturn(BigDecimal.ZERO);

        when(repository.findAll(any(Specification.class))).thenReturn(List.of());
        when(mapper.toResponseList(anyList())).thenReturn(List.of());

        List<GratificacionResponse> result = service.procesar(request);

        assertThat(result).isEmpty();
        verify(repository, never()).save(any(Gratificacion.class));
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.gratificacion(1L))));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.gratificacionResponse(1L));

        Page<GratificacionResponse> result = service.listar(null, null, null, pageable);

        assertThat(result.getContent()).hasSize(1);
    }

    @Test
    @DisplayName("listar() con filtros -> aplica especificaciones")
    void listar_conFiltros_aplicaEspecificaciones() {
        Pageable pageable = Pageable.ofSize(10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of()));

        Page<GratificacionResponse> result = service.listar(1L, 2026, 1L, pageable);

        assertThat(result).isEmpty();
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna gratificación")
    void obtenerPorId_idExistente_retornaGratificacion() {
        when(repository.findById(1L)).thenReturn(Optional.of(RrhhTestFixtures.gratificacion(1L)));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.gratificacionResponse(1L));

        GratificacionResponse result = service.obtenerPorId(1L);

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
                .hasMessageContaining("Gratificación no encontrada.");
    }
}
