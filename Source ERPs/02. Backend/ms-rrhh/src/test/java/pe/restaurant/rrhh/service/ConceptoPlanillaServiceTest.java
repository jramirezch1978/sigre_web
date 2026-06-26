package pe.restaurant.rrhh.service;

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
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.rrhh.dto.request.ConceptoPlanillaCreateRequest;
import pe.restaurant.rrhh.dto.request.ConceptoPlanillaUpdateRequest;
import pe.restaurant.rrhh.dto.response.ConceptoPlanillaResponse;
import pe.restaurant.rrhh.entity.ConceptoPlanilla;
import pe.restaurant.rrhh.entity.GrupoConceptosPlanilla;
import pe.restaurant.rrhh.mapper.ConceptoPlanillaMapper;
import pe.restaurant.rrhh.repository.ConceptoPlanillaRepository;
import pe.restaurant.rrhh.repository.GrupoConceptosPlanillaRepository;
import pe.restaurant.rrhh.service.impl.ConceptoPlanillaServiceImpl;
import pe.restaurant.rrhh.validation.ConceptoPlanillaValidator;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.*;
import static pe.restaurant.rrhh.constants.ConceptoPlanillaConstants.*;

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
    private GrupoConceptosPlanillaRepository grupoConceptosPlanillaRepository;

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
    @DisplayName("listar() con filtro grupoCalculo -> retorna página filtrada")
    void listar_conFiltroGrupoCalculo_retornaPaginaFiltrada() {
        ConceptoPlanilla entity = crearEntityMinimo();
        Page<ConceptoPlanilla> page = new PageImpl<>(List.of(entity));
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();

        when(repository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<ConceptoPlanillaResponse> result = service.listar(null, null, "10", null, PageRequest.of(0, 10));

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
        doNothing().when(validator).validarGrupoCalculo(anyString());
        when(grupoConceptosPlanillaRepository.findByCodigo("10")).thenReturn(Optional.of(crearGrupo("10")));
        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(any())).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        ConceptoPlanillaResponse result = service.crear(request);

        assertThat(result).isNotNull();
        verify(validator).validarCodigoUnico(request.getCodigo());
        verify(validator).validarGrupoCalculo(request.getGrupoCalculo());
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
    @DisplayName("crear() con grupo de cálculo inválido -> lanza BusinessException")
    void crear_conGrupoCalculoInvalido_lanzaBusinessException() {
        ConceptoPlanillaCreateRequest request = crearRequestMinimo();
        request.setGrupoCalculo("");

        doNothing().when(validator).validarCodigoUnico(anyString());
        doThrow(new BusinessException(MSG_GRUPO_CALCULO_INVALIDO, ERROR_GRUPO_CALCULO_INVALIDO))
            .when(validator).validarGrupoCalculo(anyString());

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("grupo de cálculo");
    }

    // ==== actualizar ====

    @Test
    @DisplayName("actualizar() con datos válidos -> actualiza y retorna DTO")
    void actualizar_conDatosValidos_actualizaYRetornaDto() {
        ConceptoPlanilla entity = crearEntityMinimo();
        ConceptoPlanillaUpdateRequest request = crearUpdateRequestMinimo();
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        doNothing().when(validator).validarGrupoCalculo(anyString());
        when(grupoConceptosPlanillaRepository.findByCodigo("10")).thenReturn(Optional.of(crearGrupo("10")));
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
    @DisplayName("actualizar() con grupo de cálculo inválido -> lanza BusinessException")
    void actualizar_conGrupoCalculoInvalido_lanzaBusinessException() {
        ConceptoPlanilla entity = crearEntityMinimo();
        ConceptoPlanillaUpdateRequest request = crearUpdateRequestMinimo();
        request.setGrupoCalculo("");

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        doThrow(new BusinessException(MSG_GRUPO_CALCULO_INVALIDO, ERROR_GRUPO_CALCULO_INVALIDO))
            .when(validator).validarGrupoCalculo(anyString());

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
        entity.setCodigo("1013");
        entity.setNombre("PRIMA DE FRIO");
        entity.setGrupoConceptosPlanilla(crearGrupo("10"));
        entity.setFactorPago(new BigDecimal("1"));
        entity.setImporteTopeMin(BigDecimal.ZERO);
        entity.setImporteTopeMax(BigDecimal.ZERO);
        entity.setFlagReplicacion("1");
        entity.setFlagSubsidio("0");
        entity.setFlagReporteQuinta("0");
        return entity;
    }

    private ConceptoPlanillaCreateRequest crearRequestMinimo() {
        ConceptoPlanillaCreateRequest request = new ConceptoPlanillaCreateRequest();
        request.setCodigo("1013");
        request.setNombre("PRIMA DE FRIO");
        request.setGrupoCalculo("10");
        request.setFactorPago(new BigDecimal("1"));
        request.setImporteTopeMin(BigDecimal.ZERO);
        request.setImporteTopeMax(BigDecimal.ZERO);
        request.setFlagReplicacion("1");
        request.setFlagSubsidio("0");
        request.setFlagReporteQuinta("0");
        return request;
    }

    private ConceptoPlanillaUpdateRequest crearUpdateRequestMinimo() {
        ConceptoPlanillaUpdateRequest request = new ConceptoPlanillaUpdateRequest();
        request.setNombre("PRIMA DE FRIO ACTUALIZADA");
        request.setGrupoCalculo("10");
        request.setFactorPago(new BigDecimal("1"));
        request.setImporteTopeMin(BigDecimal.ZERO);
        request.setImporteTopeMax(BigDecimal.ZERO);
        request.setFlagReplicacion("1");
        request.setFlagSubsidio("0");
        request.setFlagReporteQuinta("0");
        return request;
    }

    private GrupoConceptosPlanilla crearGrupo(String codigo) {
        GrupoConceptosPlanilla grupo = new GrupoConceptosPlanilla();
        grupo.setId(1L);
        grupo.setCodigo(codigo);
        grupo.setNombre("Grupo " + codigo);
        return grupo;
    }
}
