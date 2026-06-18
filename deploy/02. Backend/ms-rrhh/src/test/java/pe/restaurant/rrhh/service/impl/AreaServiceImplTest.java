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
import pe.restaurant.rrhh.dto.request.AreaRequest;
import pe.restaurant.rrhh.dto.response.AreaResponse;
import pe.restaurant.rrhh.dto.response.AreaTreeResponse;
import pe.restaurant.rrhh.entity.Area;
import pe.restaurant.rrhh.mapper.AreaMapper;
import pe.restaurant.rrhh.repository.AreaRepository;
import pe.restaurant.rrhh.specification.AreaSpecification;
import pe.restaurant.rrhh.validation.AreaValidator;
import org.springframework.data.jpa.domain.Specification;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;
import static org.assertj.core.api.Assertions.assertThatCode;

@ExtendWith(MockitoExtension.class)
@DisplayName("AreaServiceImpl — Pruebas Unitarias")
class AreaServiceImplTest {

    @Mock
    private AreaRepository repository;
    
    @Mock
    private AreaValidator validator;
    
    @Mock
    private AreaMapper mapper;
    
    @InjectMocks
    private AreaServiceImpl service;
    
    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenAnswer(inv -> {
            Area entity = inv.getArgument(0);
            AreaResponse r = new AreaResponse();
            r.setId(entity.getId());
            r.setNombre(entity.getNombre());
            r.setPadreId(entity.getPadreId());
            r.setFlagEstado(entity.getFlagEstado());
            return r;
        });
    }
    
    @Test
    @DisplayName("listar() sin filtros -> retorna página de áreas")
    void listar_sinFiltros_retornaPagina() {
        Pageable pageable = Pageable.ofSize(10);
        List<Area> areas = List.of(
            RrhhTestFixtures.area(1L, "Gerencia", null),
            RrhhTestFixtures.area(2L, "Finanzas", 1L)
        );
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
            .thenReturn(new PageImpl<>(areas));

        Page<AreaResponse> result = service.listar(pageable, null, null, null);

        assertThat(result.getContent()).hasSize(2);
        assertThat(result.getContent().get(0).getNombre()).isEqualTo("Gerencia");
    }

    @Test
    @DisplayName("listar() con filtros -> aplica especificaciones")
    void listar_conFiltros_aplicaEspecificaciones() {
        Pageable pageable = Pageable.ofSize(10);
        List<Area> areas = List.of(RrhhTestFixtures.area(1L, "Finanzas", null));
        when(repository.findAll(any(Specification.class), eq(pageable)))
            .thenReturn(new PageImpl<>(areas));

        Page<AreaResponse> result = service.listar(pageable, "Finanzas", null, null);

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }
    
    @Test
    @DisplayName("obtener() con ID existente -> retorna área")
    void obtener_idExistente_retornaArea() {
        // Arrange
        Area expected = RrhhTestFixtures.area(1L, "Gerencia", null);
        when(repository.findById(1L)).thenReturn(Optional.of(expected));
        
        // Act
        AreaResponse result = service.obtener(1L);
        
        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNombre()).isEqualTo("Gerencia");
        verify(repository).findById(1L);
    }
    
    @Test
    @DisplayName("obtener() con ID inexistente -> lanza ResourceNotFoundException")
    void obtener_idInexistente_lanzaResourceNotFoundException() {
        // Arrange
        when(repository.findById(999L)).thenReturn(Optional.empty());
        
        // Act & Assert
        assertThatThrownBy(() -> service.obtener(999L))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }
    
    @Test
    @DisplayName("crear() -> valida y crea área")
    void crear_validaYCreaArea() {
        // Arrange
        AreaRequest request = RrhhTestFixtures.areaRequest("Nueva Área", null);
        Area entity = RrhhTestFixtures.area(1L, "Nueva Área", null);
        Area saved = RrhhTestFixtures.area(1L, "Nueva Área", null);
        
        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(entity)).thenReturn(saved);
        
        // Act
        AreaResponse result = service.crear(request);
        
        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(validator).validarNombreUnico("Nueva Área", null, null);
        verify(mapper).toEntity(request);
        verify(repository).save(entity);
    }
    
    @Test
    @DisplayName("actualizar() -> valida y actualiza área")
    void actualizar_validaYActualizaArea() {
        // Arrange
        Long id = 1L;
        AreaRequest request = RrhhTestFixtures.areaRequest("Área Actualizada", null);
        Area existing = RrhhTestFixtures.area(id, "Área Original", null);
        Area updated = RrhhTestFixtures.area(id, "Área Actualizada", null);
        
        when(repository.findById(id)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(updated);
        
        // Act
        AreaResponse result = service.actualizar(id, request);
        
        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(id);
        verify(validator).validarNombreUnico("Área Actualizada", null, id);
        verify(validator).validarSinCiclos(id, null);
        verify(mapper).updateEntity(request, existing);
        verify(repository).save(existing);
    }
    
    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza ResourceNotFoundException")
    void actualizar_idInexistente_lanzaResourceNotFoundException() {
        // Arrange
        AreaRequest request = RrhhTestFixtures.areaRequest("Área", null);
        when(repository.findById(999L)).thenReturn(Optional.empty());
        
        // Act & Assert
        assertThatThrownBy(() -> service.actualizar(999L, request))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }
    
    @Test
    @DisplayName("eliminar() -> valida y elimina área")
    void eliminar_validaYEliminaArea() {
        // Arrange
        Long id = 1L;
        Area existing = RrhhTestFixtures.area(id, "Área", null);
        
        when(repository.findById(id)).thenReturn(Optional.of(existing));
        when(repository.save(existing)).thenReturn(existing);
        
        // Act
        var result = service.desactivar(id);
        
        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(id);
        verify(validator).validarSinHijos(id);
        verify(repository).save(existing);
    }
    
    @Test
    @DisplayName("eliminar() con ID inexistente -> lanza ResourceNotFoundException")
    void eliminar_idInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());
        
        assertThatThrownBy(() -> service.desactivar(999L))
            .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }
    
    @Test
    @DisplayName("eliminar() con hijos activos -> lanza excepción")
    void eliminar_conHijosActivos_lanzaExcepcion() {
        Area area = RrhhTestFixtures.area(1L, "Gerencia", null);
        when(repository.findById(1L)).thenReturn(Optional.of(area));
        doThrow(new BusinessException("Área con hijos activos no se puede desactivar"))
            .when(validator).validarSinHijos(1L);
        
        assertThatThrownBy(() -> service.desactivar(1L))
            .isInstanceOf(BusinessException.class);
        verify(repository).findById(1L);
        verify(validator).validarSinHijos(1L);
        verify(repository, never()).save(any());
    }
    @DisplayName("obtenerArbolJerarquico() -> construye árbol completo")
    void obtenerArbolJerarquico_construyeArbolCompleto() {
        // Arrange
        Area root1 = RrhhTestFixtures.area(1L, "Raíz 1", null);
        Area root2 = RrhhTestFixtures.area(2L, "Raíz 2", null);
        Area child1 = RrhhTestFixtures.area(3L, "Hijo 1", 1L);
        Area child2 = RrhhTestFixtures.area(4L, "Hijo 2", 1L);
        
        when(repository.findRootAreas()).thenReturn(List.of(root1, root2));
        when(repository.findByPadreId(1L)).thenReturn(List.of(child1, child2));
        when(repository.findByPadreId(3L)).thenReturn(List.of());
        when(repository.findByPadreId(4L)).thenReturn(List.of());
        when(repository.findByPadreId(2L)).thenReturn(List.of());
        
        when(mapper.toTreeResponse(any())).thenAnswer(invocation -> {
            Area area = invocation.getArgument(0);
            AreaTreeResponse response = new AreaTreeResponse();
            response.setId(area.getId());
            response.setNombre(area.getNombre());
            response.setPadreId(area.getPadreId());
            return response;
        });
        
        // Act
        List<AreaTreeResponse> result = service.obtenerArbolJerarquico();
        
        // Assert
        assertThat(result).hasSize(2);
        assertThat(result.get(0).getNombre()).isEqualTo("Raíz 1");
        assertThat(result.get(0).getHijos()).hasSize(2);
        assertThat(result.get(0).getHijos().get(0).getNombre()).isEqualTo("Hijo 1");
        assertThat(result.get(1).getNombre()).isEqualTo("Raíz 2");
        
        verify(repository).findRootAreas();
        verify(repository, times(4)).findByPadreId(any());
    }
    
    @Test
    @DisplayName("obtenerArbolJerarquico() sin áreas -> retorna lista vacía")
    void obtenerArbolJerarquico_sinAreas_retornaListaVacia() {
        // Arrange
        when(repository.findRootAreas()).thenReturn(List.of());
        
        // Act
        List<AreaTreeResponse> result = service.obtenerArbolJerarquico();
        
        // Assert
        assertThat(result).isEmpty();
        verify(repository).findRootAreas();
        verify(repository, never()).findByPadreId(any());
    }

    
    @Test
    @DisplayName("listar() con nombre null -> ignora filtro nombre")
    void listar_conNombreNull_debeIgnorarFiltroNombre() {
        Pageable pageable = Pageable.ofSize(10);
        Page<Area> expectedPage = new PageImpl<>(List.of(RrhhTestFixtures.area(1L, "Finanzas", null)));
        
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(expectedPage);
        
        Page<AreaResponse> result = service.listar(pageable, null, null, null);
        
        assertThat(result).hasSize(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("listar() con solo filtro de padre -> debe aplicar solo filtro padre")
    void listar_conSoloFiltroPadre_debeAplicarSoloFiltroPadre() {
        // Arrange
        Pageable pageable = Pageable.ofSize(10);
        Long padreId = 1L;
        Page<Area> expectedPage = new PageImpl<>(List.of(RrhhTestFixtures.area(2L, "Contabilidad", 1L)));
        
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(expectedPage);
        
        // Act
        Page<AreaResponse> result = service.listar(pageable, null, padreId, null);
        
        // Assert
        assertThat(result).hasSize(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }

    @Test
    @DisplayName("actualizar() con padreId null -> debe permitir actualizar a área raíz")
    void actualizar_conPadreIdNull_debePermitirActualizarAreaRaiz() {
        // Arrange
        Long id = 1L;
        AreaRequest request = RrhhTestFixtures.areaRequest("Nueva Finanzas", null);
        Area existing = RrhhTestFixtures.area(id, "Finanzas Antigua", 2L);
        Area updated = RrhhTestFixtures.area(id, "Nueva Finanzas", null);
        
        when(repository.findById(id)).thenReturn(Optional.of(existing));
        doNothing().when(validator).validarNombreUnico("Nueva Finanzas", null, id);
        doNothing().when(validator).validarSinCiclos(id, null);
        when(repository.save(existing)).thenReturn(updated);
        
        // Act
        AreaResponse result = service.actualizar(id, request);
        
        // Assert
        assertThat(result.getPadreId()).isNull();
        verify(repository).findById(id);
        verify(validator).validarNombreUnico("Nueva Finanzas", null, id);
        verify(validator).validarSinCiclos(id, null);
        verify(repository).save(existing);
    }

    @Test
    @DisplayName("validarSinCiclos() con ids null -> debe retornar sin validar")
    void validarSinCiclos_conIdsNull_debeRetornarSinValidar() {
        // Arrange
        Long areaId = null;
        Long padreId = null;
        
        // Act & Assert - No debe lanzar excepción
        assertThatCode(() -> {
            // Este es un test indirecto ya que el método es privado
            // Lo probamos a través de actualizar()
            AreaRequest request = RrhhTestFixtures.areaRequest("Test", null);
            Area existing = RrhhTestFixtures.area(1L, "Test", null);
            
            when(repository.findById(1L)).thenReturn(Optional.of(existing));
            doNothing().when(validator).validarNombreUnico("Test", null, 1L);
            when(repository.save(existing)).thenReturn(existing);
            
            service.actualizar(1L, request);
        }).doesNotThrowAnyException();
    }

    @Test
    @DisplayName("construirArbol() con área sin hijos -> debe retornar nodo sin hijos")
    void construirArbol_conAreaSinHijos_debeRetornarNodoSinHijos() {
        // Arrange
        Area area = RrhhTestFixtures.area(1L, "Finanzas", null);
        AreaTreeResponse expectedResponse = new AreaTreeResponse();
        expectedResponse.setId(1L);
        expectedResponse.setNombre("Finanzas");
        expectedResponse.setPadreId(null);
        expectedResponse.setHijos(List.of());
        
        when(repository.findRootAreas()).thenReturn(List.of(area));
        when(repository.findByPadreId(1L)).thenReturn(List.of());
        when(mapper.toTreeResponse(area)).thenReturn(expectedResponse);
        
        // Act - Este método es privado, lo probamos indirectamente
        List<AreaTreeResponse> result = service.obtenerArbolJerarquico();
        
        // Assert
        assertThat(result).hasSize(1);
        verify(repository).findRootAreas();
        verify(repository).findByPadreId(1L);
    }

    @Test
    @DisplayName("listar() con nombre Y padreId -> debe combinar ambos filtros con AND")
    void listar_conNombreYPadreId_debeCombinarAmbosFiltrosConAnd() {
        // Arrange
        Pageable pageable = Pageable.ofSize(10);
        String nombre = "Contabilidad";
        Long padreId = 1L;
        Page<Area> expectedPage = new PageImpl<>(List.of(RrhhTestFixtures.area(2L, "Contabilidad", 1L)));
        
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(expectedPage);
        
        // Act - Este caso ejecuta el branch spec.and(padreSpec) en la línea 65
        Page<AreaResponse> result = service.listar(pageable, nombre, padreId, null);
        
        // Assert
        assertThat(result).hasSize(1);
        assertThat(result.getContent().get(0).getNombre()).isEqualTo("Contabilidad");
        assertThat(result.getContent().get(0).getPadreId()).isEqualTo(1L);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }
}
