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
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.CargoRequest;
import pe.restaurant.rrhh.dto.response.CargoResponse;
import pe.restaurant.rrhh.entity.Cargo;
import pe.restaurant.rrhh.mapper.CargoMapper;
import pe.restaurant.rrhh.repository.CargoRepository;
import pe.restaurant.rrhh.validation.CargoValidator;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

/**
 * Tests unitarios para CargoServiceImpl.
 * Valida la lógica de negocio CRUD con mocks.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("CargoServiceImpl — Pruebas Unitarias")
class CargoServiceImplTest {

    @Mock
    private CargoRepository repository;
    
    @Mock
    private CargoValidator validator;
    
    @Mock
    private CargoMapper mapper;
    
    @InjectMocks
    private CargoServiceImpl service;
    
    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenAnswer(inv -> {
            Cargo entity = inv.getArgument(0);
            CargoResponse r = new CargoResponse();
            r.setId(entity.getId());
            r.setNombre(entity.getNombre());
            r.setNivel(entity.getNivel());
            return r;
        });
    }
    
    // ══════════════════════════════════════════════════════════════
    // listar()
    // ══════════════════════════════════════════════════════════════
    
    @Test
    @DisplayName("listar() sin filtros -> retorna página de cargos")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        List<Cargo> cargos = List.of(
            RrhhTestFixtures.cargo(1L, "Chef Ejecutivo"),
            RrhhTestFixtures.cargo(2L, "Sous Chef")
        );
        Page<Cargo> expectedPage = new PageImpl<>(cargos);
        
        when(repository.findAll(any(Pageable.class))).thenReturn(expectedPage);
        
        Page<CargoResponse> result = service.listar(pageable, null, null);
        
        assertThat(result.getContent()).hasSize(2);
        assertThat(result.getContent().get(0).getNombre()).isEqualTo("Chef Ejecutivo");
        verify(repository).findAll(pageable);
    }
    
    @Test
    @DisplayName("listar() con filtro nombre -> aplica especificación")
    void listar_conFiltroNombre_aplicaEspecificacion() {
        Pageable pageable = Pageable.ofSize(10);
        List<Cargo> cargos = List.of(RrhhTestFixtures.cargo(1L, "Chef Ejecutivo"));
        Page<Cargo> expectedPage = new PageImpl<>(cargos);
        
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
            .thenReturn(expectedPage);
        
        Page<CargoResponse> result = service.listar(pageable, "Chef", null);
        
        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable));
    }
    
    @Test
    @DisplayName("listar() con filtro nivel -> aplica especificación")
    void listar_conFiltroNivel_aplicaEspecificacion() {
        Pageable pageable = Pageable.ofSize(10);
        List<Cargo> cargos = List.of(RrhhTestFixtures.cargo(1L, "Chef Ejecutivo"));
        Page<Cargo> expectedPage = new PageImpl<>(cargos);
        
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
            .thenReturn(expectedPage);
        
        Page<CargoResponse> result = service.listar(pageable, null, "TÁCTICO");
        
        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable));
    }
    
    @Test
    @DisplayName("listar() con ambos filtros -> aplica especificaciones combinadas")
    void listar_conAmbosFiltros_aplicaEspecificacionesCombinadas() {
        Pageable pageable = Pageable.ofSize(10);
        List<Cargo> cargos = List.of(RrhhTestFixtures.cargo(1L, "Chef Ejecutivo"));
        Page<Cargo> expectedPage = new PageImpl<>(cargos);
        
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable)))
            .thenReturn(expectedPage);
        
        Page<CargoResponse> result = service.listar(pageable, "Chef", "TÁCTICO");
        
        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(org.springframework.data.jpa.domain.Specification.class), eq(pageable));
    }
    
    // ══════════════════════════════════════════════════════════════
    // obtener()
    // ══════════════════════════════════════════════════════════════
    
    @Test
    @DisplayName("obtener() con ID existente -> retorna cargo")
    void obtener_idExistente_retornaCargo() {
        Cargo expected = RrhhTestFixtures.cargo(1L, "Chef Ejecutivo");
        when(repository.findById(1L)).thenReturn(Optional.of(expected));
        
        CargoResponse result = service.obtener(1L);
        
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNombre()).isEqualTo("Chef Ejecutivo");
        verify(repository).findById(1L);
    }
    
    @Test
    @DisplayName("obtener() con ID inexistente -> lanza ResourceNotFoundException")
    void obtener_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());
        
        assertThatThrownBy(() -> service.obtener(999L))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }
    
    // ══════════════════════════════════════════════════════════════
    // crear()
    // ══════════════════════════════════════════════════════════════
    
    @Test
    @DisplayName("crear() -> valida, crea y retorna cargo")
    void crear_validaYCreaCargo() {
        CargoRequest request = RrhhTestFixtures.cargoRequest("Chef Ejecutivo");
        Cargo entity = RrhhTestFixtures.cargo(null, "Chef Ejecutivo");
        Cargo saved = RrhhTestFixtures.cargo(1L, "Chef Ejecutivo");
        
        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(entity)).thenReturn(saved);
        
        CargoResponse result = service.crear(request);
        
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(validator).validarNombreUnico("Chef Ejecutivo", null);
        verify(validator).validarBandaSalarial(request);
        verify(mapper).toEntity(request);
        verify(repository).save(entity);
    }
    
    // ══════════════════════════════════════════════════════════════
    // actualizar()
    // ══════════════════════════════════════════════════════════════
    
    @Test
    @DisplayName("actualizar() -> valida, actualiza y retorna cargo")
    void actualizar_validaYActualizaCargo() {
        CargoRequest request = RrhhTestFixtures.cargoRequest("Chef Ejecutivo Senior");
        Cargo existing = RrhhTestFixtures.cargo(1L, "Chef Ejecutivo");
        Cargo updated = RrhhTestFixtures.cargo(1L, "Chef Ejecutivo Senior");
        
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(updated);
        
        CargoResponse result = service.actualizar(1L, request);
        
        assertThat(result).isNotNull();
        verify(validator).validarNombreUnico("Chef Ejecutivo Senior", 1L);
        verify(validator).validarBandaSalarial(request);
        verify(mapper).updateEntity(request, existing);
        verify(repository).save(existing);
    }
    
    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza ResourceNotFoundException")
    void actualizar_idInexistente_lanzaResourceNotFoundException() {
        CargoRequest request = RrhhTestFixtures.cargoRequest("Chef Ejecutivo");
        when(repository.findById(999L)).thenReturn(Optional.empty());
        
        assertThatThrownBy(() -> service.actualizar(999L, request))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
        verify(validator, never()).validarNombreUnico(any(), any());
        verify(repository, never()).save(any());
    }
    
    // ══════════════════════════════════════════════════════════════
    // eliminar()
    // ══════════════════════════════════════════════════════════════
    
    @Test
    @DisplayName("eliminar() -> valida y elimina cargo")
    void eliminar_validaYEliminaCargo() {
        Cargo existing = RrhhTestFixtures.cargo(1L, "Chef Ejecutivo");
        when(repository.findById(1L)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);
        
        var result = service.desactivar(1L);
        
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(validator).validarSinTrabajadoresAsignados(1L);
        verify(repository).save(existing);
    }
    
    @Test
    @DisplayName("desactivar() con ID inexistente -> lanza ResourceNotFoundException")
    void desactivar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());
        
        assertThatThrownBy(() -> service.desactivar(999L))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
        verify(repository, never()).save(any(Cargo.class));
    }

    // ══════════════════════════════════════════════════════════════
    // activar()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("activar() con ID existente -> cambia flagEstado a 1")
    void activar_idExistente_cambiaEstado() {
        Cargo entity = RrhhTestFixtures.cargo(1L, "Chef Ejecutivo");
        entity.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any())).thenAnswer(inv -> inv.getArgument(0));

        var result = service.activar(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).save(argThat(e -> "1".equals(e.getFlagEstado())));
    }

    // ══════════════════════════════════════════════════════════════
    // listarActivos()
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("listarActivos() -> retorna solo activos")
    void listarActivos_retornaActivos() {
        Cargo entity = RrhhTestFixtures.cargo(1L, "Chef Ejecutivo");
        CargoResponse response = RrhhTestFixtures.cargoResponse(1L, "Chef Ejecutivo");
        when(repository.findByFlagEstadoOrderByNombreAsc("1")).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        List<CargoResponse> result = service.listarActivos();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        verify(repository).findByFlagEstadoOrderByNombreAsc("1");
    }
}
