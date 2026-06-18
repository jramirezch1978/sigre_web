package pe.restaurant.rrhh.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
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
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.rrhh.constants.AdminAfpConstants;
import pe.restaurant.rrhh.dto.request.AdminAfpRequest;
import pe.restaurant.rrhh.dto.response.AdminAfpResponse;
import pe.restaurant.rrhh.entity.AdminAfp;
import pe.restaurant.rrhh.mapper.AdminAfpMapper;
import pe.restaurant.rrhh.repository.AdminAfpRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.lenient;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/**
 * Tests unitarios para AdminAfpServiceImpl.
 * 
 * <p>Cubre todas las operaciones CRUD con validaciones de negocio
 * según las reglas establecidas en la HU_ADMIN_AFP.md.</p>
 * 
 * @author Sistema de RRHH
 * @version 1.0
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - AdminAfpServiceImpl")
class AdminAfpServiceImplTest {

    @Mock private AdminAfpRepository repository;
    @Mock private TrabajadorRepository trabajadorRepository;
    @Mock private AdminAfpMapper mapper;

    @InjectMocks
    private AdminAfpServiceImpl service;

    private AdminAfp afp;
    private AdminAfpResponse response;
    private AdminAfpRequest request;
    private AdminAfpRequest requestInvalido;

    @BeforeEach
    void setUp() {
        // Datos de prueba
        afp = new AdminAfp();
        afp.setId(1L);
        afp.setNombre("AFP Integra");
        afp.setComisionPorcentaje(new BigDecimal("1.5500"));
        afp.setPrimaSeguro(new BigDecimal("1.3600"));
        afp.setAporteObligatorio(new BigDecimal("10.0000"));

        response = new AdminAfpResponse();
        response.setId(1L);
        response.setNombre("AFP Integra");
        response.setComisionPorcentaje(new BigDecimal("1.5500"));
        response.setPrimaSeguro(new BigDecimal("1.3600"));
        response.setAporteObligatorio(new BigDecimal("10.0000"));

        request = new AdminAfpRequest();
        request.setNombre("AFP Integra");
        request.setComisionPorcentaje(new BigDecimal("1.5500"));
        request.setPrimaSeguro(new BigDecimal("1.3600"));
        request.setAporteObligatorio(new BigDecimal("10.0000"));

        requestInvalido = new AdminAfpRequest();
        requestInvalido.setNombre("");
        requestInvalido.setComisionPorcentaje(new BigDecimal("-1.00"));
    }

    // ==== listar() ====

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        Page<AdminAfp> page = new PageImpl<>(List.of(afp));
        lenient().when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<AdminAfpResponse> result = service.listar(null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        assertThat(result.getContent().get(0).getNombre()).isEqualTo("AFP Integra");
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con filtro nombre -> retorna página filtrada")
    void listar_conFiltroNombre_retornaPaginaFiltrada() {
        Page<AdminAfp> page = new PageImpl<>(List.of(afp));
        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<AdminAfpResponse> result = service.listar("Integra", null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    // ==== obtenerPorId() ====

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna AFP")
    void obtenerPorId_conIdExistente_retornaAfp() {
        when(repository.findById(1L)).thenReturn(Optional.of(afp));
        when(mapper.toResponse(afp)).thenReturn(response);

        AdminAfpResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        assertThat(result.getNombre()).isEqualTo("AFP Integra");
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza NotFoundException")
    void obtenerPorId_conIdInexistente_lanzaNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }

    // ==== crear() ====

    @Test
    @DisplayName("crear() con datos válidos -> retorna AFP creada")
    void crear_conDatosValidos_retornaAfpCreada() {
        when(repository.existsByNombreIgnoreCase("AFP Integra")).thenReturn(false);
        when(mapper.toEntity(request)).thenReturn(afp);
        when(repository.save(any())).thenReturn(afp);
        when(mapper.toResponse(afp)).thenReturn(response);

        AdminAfpResponse result = service.crear(request);

        assertThat(result).isNotNull();
        assertThat(result.getNombre()).isEqualTo("AFP Integra");
        verify(repository).existsByNombreIgnoreCase("AFP Integra");
        verify(repository).save(any());
    }

    @Test
    @DisplayName("crear() con nombre duplicado -> lanza BusinessException")
    void crear_conNombreDuplicado_lanzaBusinessException() {
        when(repository.existsByNombreIgnoreCase("AFP Integra")).thenReturn(true);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining(AdminAfpConstants.MSG_NOMBRE_DUPLICADO)
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(AdminAfpConstants.ERROR_NOMBRE_DUPLICADO);
                });
        verify(repository).existsByNombreIgnoreCase("AFP Integra");
        verify(repository, never()).save(any());
    }

    @Test
    @Disabled("Validacion movida a validator - pendiente de implementar en service")
    @DisplayName("crear() con nombre vacío -> lanza BusinessException")
    void crear_conNombreVacio_lanzaBusinessException() {
        assertThatThrownBy(() -> service.crear(requestInvalido))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining(AdminAfpConstants.MSG_NOMBRE_OBLIGATORIO)
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(AdminAfpConstants.ERROR_NOMBRE_OBLIGATORIO);
                });
        verify(repository, never()).existsByNombreIgnoreCase(any());
        verify(repository, never()).save(any());
    }

    @Test
    @Disabled("Validacion movida a validator - pendiente de implementar en service")
    @DisplayName("crear() con porcentaje negativo -> lanza BusinessException")
    void crear_conPorcentajeNegativo_lanzaBusinessException() {
        AdminAfpRequest requestNegativo = new AdminAfpRequest();
        requestNegativo.setNombre("AFP Test");
        requestNegativo.setComisionPorcentaje(new BigDecimal("-1.00"));

        assertThatThrownBy(() -> service.crear(requestNegativo))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining(AdminAfpConstants.MSG_PORCENTAJE_NEGATIVO)
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(AdminAfpConstants.ERROR_PORCENTAJE_NEGATIVO);
                });
        verify(repository, never()).save(any());
    }

    // ==== actualizar() ====

    @Test
    @DisplayName("actualizar() con datos válidos -> retorna AFP actualizada")
    void actualizar_conDatosValidos_retornaAfpActualizada() {
        when(repository.findById(1L)).thenReturn(Optional.of(afp));
        when(repository.existsByNombreIgnoreCaseAndIdNot("AFP Integra", 1L)).thenReturn(false);
        when(repository.save(any())).thenReturn(afp);
        when(mapper.toResponse(afp)).thenReturn(response);

        AdminAfpResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        assertThat(result.getNombre()).isEqualTo("AFP Integra");
        verify(repository).findById(1L);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza NotFoundException")
    void actualizar_conIdInexistente_lanzaNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, request))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizar() con nombre duplicado -> lanza BusinessException")
    void actualizar_conNombreDuplicado_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(afp));
        when(repository.existsByNombreIgnoreCaseAndIdNot("AFP Prima", 1L)).thenReturn(true);

        AdminAfpRequest requestDuplicado = new AdminAfpRequest();
        requestDuplicado.setNombre("AFP Prima");

        assertThatThrownBy(() -> service.actualizar(1L, requestDuplicado))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining(AdminAfpConstants.MSG_NOMBRE_DUPLICADO)
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(AdminAfpConstants.ERROR_NOMBRE_DUPLICADO);
                });
        verify(repository, never()).save(any());
    }

    // ==== eliminar() ====

    @Test
    @DisplayName("eliminar() sin asignados -> elimina exitosamente")
    void eliminar_sinAsignados_eliminaExitosamente() {
        when(repository.findById(1L)).thenReturn(Optional.of(afp));
        when(trabajadorRepository.existsTrabajadoresByAdminAfpId(1L)).thenReturn(false);

        service.desactivar(1L);

        verify(repository).findById(1L);
        verify(trabajadorRepository).existsTrabajadoresByAdminAfpId(1L);
        verify(repository).save(any());
    }

    @Test
    @DisplayName("eliminar() con asignados -> lanza BusinessException")
    void eliminar_conAsignados_lanzaBusinessException() {
        when(repository.findById(1L)).thenReturn(Optional.of(afp));
        when(trabajadorRepository.existsTrabajadoresByAdminAfpId(1L)).thenReturn(true);

        assertThatThrownBy(() -> service.desactivar(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("colaboradores asignados")
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode()).isEqualTo("RH-AF-004");
                });
        verify(repository).findById(1L);
        verify(trabajadorRepository).existsTrabajadoresByAdminAfpId(1L);
    }

    // ==== listarActivos() ====

    @Test
    @DisplayName("listarActivos() -> retorna solo activos")
    void listarActivos_retornaActivos() {
        when(repository.findByFlagEstadoOrderByNombreAsc("1")).thenReturn(List.of(afp));
        when(mapper.toResponseList(anyList())).thenReturn(List.of(response));

        List<AdminAfpResponse> result = service.listarActivos();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        verify(repository).findByFlagEstadoOrderByNombreAsc("1");
    }

    @Test
    @DisplayName("listarActivos() cuando no hay activos -> retorna lista vacía")
    void listarActivos_sinActivos_retornaListaVacia() {
        when(repository.findByFlagEstadoOrderByNombreAsc("1")).thenReturn(List.of());
        when(mapper.toResponseList(anyList())).thenReturn(List.of());

        List<AdminAfpResponse> result = service.listarActivos();

        assertThat(result).isEmpty();
        verify(repository).findByFlagEstadoOrderByNombreAsc("1");
    }
}
