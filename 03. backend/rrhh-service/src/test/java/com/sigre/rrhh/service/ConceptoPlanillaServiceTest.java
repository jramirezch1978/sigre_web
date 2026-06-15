package com.sigre.rrhh.service;

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
import org.springframework.data.jpa.domain.Specification;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.dto.request.ConceptoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.ConceptoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.ConceptoPlanillaResponse;
import com.sigre.rrhh.entity.ConceptoPlanilla;
import com.sigre.rrhh.mapper.ConceptoPlanillaMapper;
import com.sigre.rrhh.repository.ConceptoPlanillaRepository;
import com.sigre.rrhh.service.impl.ConceptoPlanillaServiceImpl;
import com.sigre.rrhh.validation.ConceptoPlanillaValidator;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.*;
import static com.sigre.rrhh.constants.ConceptoPlanillaConstants.*;

/**
 * Tests unitarios para ConceptoPlanillaService.
 * Valida la lógica de negocio sin levantar el contexto de Spring.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - ConceptoPlanillaService")
class ConceptoPlanillaServiceTest {

    @Mock
    private ConceptoPlanillaRepository repository;

    @Mock
    private ConceptoPlanillaMapper mapper;

    @Mock
    private ConceptoPlanillaValidator validator;

    @InjectMocks
    private ConceptoPlanillaServiceImpl service;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        TenantContext.setSucursalId(1L);
        TenantContext.setEmpresaId(1L);
    }

    // ==== listar ====

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        ConceptoPlanilla entity = crearEntityMinimo();
        Page<ConceptoPlanilla> page = new PageImpl<>(List.of(entity));
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<ConceptoPlanillaResponse> result = service.listar(null, null, null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con filtro código -> retorna página filtrada")
    void listar_conFiltroCodigo_retornaPaginaFiltrada() {
        ConceptoPlanilla entity = crearEntityMinimo();
        Page<ConceptoPlanilla> page = new PageImpl<>(List.of(entity));
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<ConceptoPlanillaResponse> result = service.listar("ING", null, null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar() con filtro tipo -> retorna página filtrada")
    void listar_conFiltroTipo_retornaPaginaFiltrada() {
        ConceptoPlanilla entity = crearEntityMinimo();
        Page<ConceptoPlanilla> page = new PageImpl<>(List.of(entity));
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<ConceptoPlanillaResponse> result = service.listar(null, null, TIPO_INGRESO, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar() con filtro nombre -> retorna página filtrada")
    void listar_conFiltroNombre_retornaPaginaFiltrada() {
        ConceptoPlanilla entity = crearEntityMinimo();
        Page<ConceptoPlanilla> page = new PageImpl<>(List.of(entity));
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<ConceptoPlanillaResponse> result = service.listar(null, "Sueldo", null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar() con filtro flagEstado -> retorna página filtrada")
    void listar_conFiltroFlagEstado_retornaPaginaFiltrada() {
        ConceptoPlanilla entity = crearEntityMinimo();
        Page<ConceptoPlanilla> page = new PageImpl<>(List.of(entity));
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<ConceptoPlanillaResponse> result = service.listar(null, null, null, "1", PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    // ==== obtenerPorId ====

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna DTO")
    void obtenerPorId_conIdExistente_retornaDto() {
        ConceptoPlanilla entity = crearEntityMinimo();
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();
        response.setId(1L);
        response.setCodigo("ING-001");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(mapper.toResponse(entity)).thenReturn(response);

        ConceptoPlanillaResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(repository).findById(1L);
    }

    @Test
    @DisplayName("obtenerPorId() con ID inexistente -> lanza ResourceNotFoundException")
    void obtenerPorId_conIdInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.obtenerPorId(999L))
            .isInstanceOf(ResourceNotFoundException.class)
            .hasMessageContaining("999");
    }

    // ==== crear ====

    @Test
    @DisplayName("crear() con datos válidos -> crea y retorna DTO")
    void crear_conDatosValidos_creaYRetornaDto() {
        ConceptoPlanillaCreateRequest request = crearRequestMinimo();
        ConceptoPlanilla entity = crearEntityMinimo();
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();

        doNothing().when(validator).validarCodigoUnico(anyString());
        doNothing().when(validator).validarTipo(anyString());
        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        ConceptoPlanillaResponse result = service.crear(request);

        assertThat(result).isNotNull();
        verify(validator).validarCodigoUnico(request.getCodigo());
        verify(validator).validarTipo(request.getTipo());
        verify(repository).save(any());
    }

    @Test
    @DisplayName("crear() con código duplicado -> lanza BusinessException")
    void crear_conCodigoDuplicado_lanzaBusinessException() {
        ConceptoPlanillaCreateRequest request = crearRequestMinimo();

        doThrow(new BusinessException(MSG_CODIGO_DUPLICADO, ERROR_CODIGO_DUPLICADO))
            .when(validator).validarCodigoUnico(anyString());

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Ya existe");
    }

    @Test
    @DisplayName("crear() con tipo inválido -> lanza BusinessException")
    void crear_conTipoInvalido_lanzaBusinessException() {
        ConceptoPlanillaCreateRequest request = crearRequestMinimo();
        request.setTipo("INVALIDO");

        doNothing().when(validator).validarCodigoUnico(anyString());
        doThrow(new BusinessException(MSG_TIPO_INVALIDO, ERROR_TIPO_INVALIDO))
            .when(validator).validarTipo(anyString());

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("tipo debe ser");
    }

    // ==== actualizar ====

    @Test
    @DisplayName("actualizar() con datos válidos -> actualiza y retorna DTO")
    void actualizar_conDatosValidos_actualizaYRetornaDto() {
        ConceptoPlanilla entity = crearEntityMinimo();
        ConceptoPlanillaUpdateRequest request = crearUpdateRequestMinimo();
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        doNothing().when(validator).validarTipo(anyString());
        doNothing().when(mapper).updateEntity(any(), any());
        when(repository.save(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        ConceptoPlanillaResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(repository).save(any());
        verify(mapper).updateEntity(entity, request);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza ResourceNotFoundException")
    void actualizar_conIdInexistente_lanzaResourceNotFoundException() {
        ConceptoPlanillaUpdateRequest request = crearUpdateRequestMinimo();

        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("actualizar() con tipo inválido -> lanza BusinessException")
    void actualizar_conTipoInvalido_lanzaBusinessException() {
        ConceptoPlanilla entity = crearEntityMinimo();
        ConceptoPlanillaUpdateRequest request = crearUpdateRequestMinimo();
        request.setTipo("INVALIDO");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        doThrow(new BusinessException(MSG_TIPO_INVALIDO, ERROR_TIPO_INVALIDO))
            .when(validator).validarTipo(anyString());

        assertThatThrownBy(() -> service.actualizar(1L, request))
            .isInstanceOf(BusinessException.class);
    }

    // ==== eliminar ====

    @Test
    @DisplayName("eliminar() con ID válido -> elimina concepto")
    void eliminar_conIdValido_eliminaConcepto() {
        ConceptoPlanilla entity = crearEntityMinimo();

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        doNothing().when(validator).validarNoEnUso(1L);

        service.desactivar(1L);

        verify(repository).save(entity);
        verify(validator).validarNoEnUso(1L);
    }

    @Test
    @DisplayName("eliminar() con ID inexistente -> lanza ResourceNotFoundException")
    void eliminar_conIdInexistente_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desactivar(999L))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    @DisplayName("eliminar() con concepto en uso -> lanza BusinessException")
    void eliminar_conConceptoEnUso_lanzaBusinessException() {
        ConceptoPlanilla entity = crearEntityMinimo();

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        doThrow(new BusinessException(MSG_EN_USO, ERROR_EN_USO))
            .when(validator).validarNoEnUso(1L);

        assertThatThrownBy(() -> service.desactivar(1L))
            .isInstanceOf(BusinessException.class)
            .hasMessage(MSG_EN_USO);
    }

    // ==== listarActivos() ====

    @Test
    @DisplayName("listarActivos() -> retorna solo activos")
    void listarActivos_retornaActivos() {
        ConceptoPlanilla entity = crearEntityMinimo();
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();
        response.setId(1L);
        when(repository.findByFlagEstadoOrderByNombreAsc("1")).thenReturn(List.of(entity));
        when(mapper.toResponseList(anyList())).thenReturn(List.of(response));

        List<ConceptoPlanillaResponse> result = service.listarActivos();

        assertThat(result).hasSize(1);
        assertThat(result.get(0).getId()).isEqualTo(1L);
        verify(repository).findByFlagEstadoOrderByNombreAsc("1");
    }

    @Test
    @DisplayName("listarActivos() cuando no hay activos -> retorna lista vacía")
    void listarActivos_sinActivos_retornaListaVacia() {
        when(repository.findByFlagEstadoOrderByNombreAsc("1")).thenReturn(List.of());
        when(mapper.toResponseList(anyList())).thenReturn(List.of());

        List<ConceptoPlanillaResponse> result = service.listarActivos();

        assertThat(result).isEmpty();
        verify(repository).findByFlagEstadoOrderByNombreAsc("1");
    }

    // ==== Helpers ====

    private ConceptoPlanilla crearEntityMinimo() {
        ConceptoPlanilla entity = new ConceptoPlanilla();
        entity.setId(1L);
        entity.setCodigo("ING-001");
        entity.setNombre("Sueldo Básico");
        entity.setTipo(TIPO_INGRESO);
        entity.setAfectoQuinta(true);
        entity.setAfectoEssalud(true);
        entity.setAplicaTodos(true);
        return entity;
    }

    private ConceptoPlanillaCreateRequest crearRequestMinimo() {
        ConceptoPlanillaCreateRequest request = new ConceptoPlanillaCreateRequest();
        request.setCodigo("ING-001");
        request.setNombre("Sueldo Básico");
        request.setTipo(TIPO_INGRESO);
        request.setAfectoQuinta(true);
        request.setAfectoEssalud(true);
        request.setAplicaTodos(true);
        return request;
    }

    private ConceptoPlanillaUpdateRequest crearUpdateRequestMinimo() {
        ConceptoPlanillaUpdateRequest request = new ConceptoPlanillaUpdateRequest();
        request.setNombre("Sueldo Básico Mensual");
        request.setTipo(TIPO_INGRESO);
        request.setAfectoQuinta(true);
        request.setAfectoEssalud(true);
        request.setAplicaTodos(true);
        return request;
    }
}
