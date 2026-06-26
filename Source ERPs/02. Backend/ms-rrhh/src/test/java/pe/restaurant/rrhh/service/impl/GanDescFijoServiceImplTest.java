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
import org.springframework.data.domain.PageRequest;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.dto.request.GanDescFijoEstadoRequest;
import pe.restaurant.rrhh.dto.request.GanDescFijoRequest;
import pe.restaurant.rrhh.entity.GanDescFijo;
import pe.restaurant.rrhh.entity.Trabajador;
import pe.restaurant.rrhh.repository.ConceptoPlanillaRepository;
import pe.restaurant.rrhh.repository.GanDescFijoRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - GanDescFijoServiceImpl")
class GanDescFijoServiceImplTest {

    @Mock private GanDescFijoRepository repository;
    @Mock private TrabajadorRepository trabajadorRepo;
    @Mock private ConceptoPlanillaRepository conceptoPlanillaRepo;

    @InjectMocks
    private GanDescFijoServiceImpl service;

    private GanDescFijo entity;
    private GanDescFijoRequest request;
    private GanDescFijoEstadoRequest estadoRequest;
    private Trabajador trabajador;

    @BeforeEach
    void setUp() {
        entity = new GanDescFijo();
        entity.setId(1L);
        entity.setTrabajadorId(1L);
        entity.setConceptoId(1L);
        entity.setImpGanDesc(new BigDecimal("500.0000"));
        entity.setFlagEstado("1");
        entity.setCreatedBy(1L);

        request = GanDescFijoRequest.builder()
                .trabajadorId(1L)
                .conceptoId(1L)
                .impGanDesc(new BigDecimal("500.0000"))
                .flagEstado("1")
                .build();

        estadoRequest = GanDescFijoEstadoRequest.builder()
                .flagEstado("0")
                .build();

        trabajador = new Trabajador();
        trabajador.setId(1L);
        trabajador.setFlagEstado("1");
    }

    // ==== listar() ====

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Page<GanDescFijo> page = new PageImpl<>(List.of(entity));
        when(repository.findWithFilters(null, null, null, PageRequest.of(0, 10)))
                .thenReturn(page);

        Page<GanDescFijo> result = service.listar(null, null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findWithFilters(null, null, null, PageRequest.of(0, 10));
    }

    @Test
    @DisplayName("listar() con filtros -> retorna página filtrada")
    void listar_conFiltros_retornaPaginaFiltrada() {
        Page<GanDescFijo> page = new PageImpl<>(List.of(entity));
        when(repository.findWithFilters(1L, 1L, "1", PageRequest.of(0, 10)))
                .thenReturn(page);

        Page<GanDescFijo> result = service.listar(1L, 1L, "1", PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findWithFilters(1L, 1L, "1", PageRequest.of(0, 10));
    }

    // ==== obtenerPorId() ====

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna entidad")
    void obtenerPorId_conIdExistente_retornaEntity() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        GanDescFijo result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza BusinessException")
    void obtenerPorId_conIdInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(BusinessException.class);
        verify(repository).findById(999L);
    }

    // ==== crear() ====

    @Test
    @DisplayName("crear() con datos válidos -> retorna entidad creada")
    void crear_conDatosValidos_retornaEntity() {
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(conceptoPlanillaRepo.existsById(1L)).thenReturn(true);
        when(repository.existsByTrabajadorIdAndConceptoIdAndFlagEstado(1L, 1L, "1")).thenReturn(false);
        when(repository.save(any())).thenReturn(entity);

        GanDescFijo result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(trabajadorRepo).findById(1L);
        verify(conceptoPlanillaRepo).existsById(1L);
        verify(repository).existsByTrabajadorIdAndConceptoIdAndFlagEstado(1L, 1L, "1");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("crear() con trabajador inexistente -> lanza BusinessException")
    void crear_conTrabajadorInexistente_lanzaBusinessException() {
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class);
        verify(trabajadorRepo).findById(1L);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crear() con concepto inexistente -> lanza BusinessException")
    void crear_conConceptoInexistente_lanzaBusinessException() {
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(conceptoPlanillaRepo.existsById(1L)).thenReturn(false);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class);
        verify(conceptoPlanillaRepo).existsById(1L);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crear() con importe y porcentaje nulos -> lanza BusinessException")
    void crear_sinImporteNiPorcentaje_lanzaBusinessException() {
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(conceptoPlanillaRepo.existsById(1L)).thenReturn(true);
        request.setImpGanDesc(null);
        request.setPorcentaje(null);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Debe indicar un importe fijo o un porcentaje");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crear() con duplicado activo -> lanza BusinessException")
    void crear_conDuplicadoActivo_lanzaBusinessException() {
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(conceptoPlanillaRepo.existsById(1L)).thenReturn(true);
        when(repository.existsByTrabajadorIdAndConceptoIdAndFlagEstado(1L, 1L, "1")).thenReturn(true);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe una ganancia/descuento fijo activo");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crear() con trabajador inactivo -> lanza BusinessException")
    void crear_conTrabajadorInactivo_lanzaBusinessException() {
        trabajador.setFlagEstado("0");
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    // ==== actualizar() ====

    @Test
    @DisplayName("actualizar() con datos válidos -> retorna entidad actualizada")
    void actualizar_conDatosValidos_retornaEntity() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(trabajadorRepo.findById(1L)).thenReturn(Optional.of(trabajador));
        when(conceptoPlanillaRepo.existsById(1L)).thenReturn(true);
        when(repository.save(any())).thenReturn(entity);

        GanDescFijo result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).findById(1L);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza BusinessException")
    void actualizar_conIdInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, request))
                .isInstanceOf(BusinessException.class);
        verify(repository).findById(999L);
        verify(repository, never()).save(any());
    }

    // ==== cambiarEstado() ====

    @Test
    @DisplayName("cambiarEstado() con ID existente -> inactiva entidad")
    void cambiarEstado_conIdExistente_inactivaEntity() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any())).thenReturn(entity);

        GanDescFijo result = service.cambiarEstado(1L, estadoRequest);

        assertThat(result).isNotNull();
        assertThat(result.getFlagEstado()).isEqualTo("0");
        verify(repository).findById(1L);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("cambiarEstado() con ID inexistente -> lanza BusinessException")
    void cambiarEstado_conIdInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.cambiarEstado(999L, estadoRequest))
                .isInstanceOf(BusinessException.class);
        verify(repository).findById(999L);
        verify(repository, never()).save(any());
    }
}
