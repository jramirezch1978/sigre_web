package pe.restaurant.produccion.service.impl;

import feign.FeignException;
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
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.produccion.ProduccionTestFixtures;
import pe.restaurant.produccion.client.AuthUsuarioClient;
import pe.restaurant.produccion.entity.OtAdminUder;
import pe.restaurant.produccion.entity.OtAdministracion;
import pe.restaurant.produccion.repository.OtAdminUderRepository;
import pe.restaurant.produccion.repository.OtAdministracionRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

import jakarta.persistence.criteria.*;
import org.mockito.ArgumentCaptor;

@ExtendWith(MockitoExtension.class)
@DisplayName("OtAdministracionServiceImpl — Pruebas Unitarias")
class OtAdministracionServiceImplTest {

    @Mock private OtAdministracionRepository administracionRepository;
    @Mock private OtAdminUderRepository uderRepository;
    @Mock private AuthUsuarioClient authUsuarioClient;
    @InjectMocks private OtAdministracionServiceImpl service;

    private OtAdministracion entity;

    @BeforeEach
    void setUp() {
        entity = ProduccionTestFixtures.otAdministracion(1L, "1");
        TenantContext.setEmpresaId(1L);
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    @Test
    void findById_cuandoExisteId_retornaEntidad() {
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));

        OtAdministracion result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    void findById_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(administracionRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void findAll_conFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(administracionRepository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(entity)));

        Page<OtAdministracion> result = service.findAll("COD", "Nombre", "D", "1", pageable);

        assertThat(result).hasSize(1);
    }

    @Test
    void findAll_sinFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(administracionRepository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        Page<OtAdministracion> result = service.findAll(null, null, null, null, pageable);

        assertThat(result).isEmpty();
    }

    @Test
    void create_cuandoCodigoUnico_guardaYRetorna() {
        when(administracionRepository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(administracionRepository.save(any(OtAdministracion.class))).thenReturn(entity);

        OtAdministracion result = service.create(entity);

        assertThat(result).isNotNull();
        verify(administracionRepository).save(entity);
    }

    @Test
    void create_cuandoCodigoDuplicado_lanzaBusinessException() {
        when(administracionRepository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(true);

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe");
    }

    @Test
    void create_sinFlagEstado_asignaActivo() {
        entity.setFlagEstado(null);
        when(administracionRepository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(administracionRepository.save(any(OtAdministracion.class))).thenAnswer(i -> i.getArgument(0));

        OtAdministracion result = service.create(entity);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void normalizar_conCodigoNull_noFalla() {
        entity.setCodigo(null);
        when(administracionRepository.existsByCodigoIgnoreCase(isNull())).thenReturn(false);
        when(administracionRepository.save(any(OtAdministracion.class))).thenReturn(entity);

        service.create(entity);

        verify(administracionRepository).save(any());
    }

    @Test
    void normalizar_conNombreNull_noFalla() {
        entity.setNombre(null);
        when(administracionRepository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(administracionRepository.save(any(OtAdministracion.class))).thenReturn(entity);

        service.create(entity);

        verify(administracionRepository).save(any());
    }

    @Test
    void normalizar_conFlagTipoCostoNull_asignaCero() {
        entity.setFlagTipoCosto(null);
        when(administracionRepository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(administracionRepository.save(any(OtAdministracion.class))).thenAnswer(i -> i.getArgument(0));

        OtAdministracion result = service.create(entity);

        assertThat(result.getFlagTipoCosto()).isEqualTo("0");
    }

    @Test
    void normalizar_conFlagTipoCostoDirecto_asignaD() {
        entity.setFlagTipoCosto("DIRECTO");
        when(administracionRepository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(administracionRepository.save(any(OtAdministracion.class))).thenAnswer(i -> i.getArgument(0));

        OtAdministracion result = service.create(entity);

        assertThat(result.getFlagTipoCosto()).isEqualTo("D");
    }

    @Test
    void normalizar_conFlagTipoCostoIndirecto_asignaI() {
        entity.setFlagTipoCosto("INDIRECTO");
        when(administracionRepository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(administracionRepository.save(any(OtAdministracion.class))).thenAnswer(i -> i.getArgument(0));

        OtAdministracion result = service.create(entity);

        assertThat(result.getFlagTipoCosto()).isEqualTo("I");
    }

    @Test
    void normalizar_conFlagTipoCostoFijo_asignaF() {
        entity.setFlagTipoCosto("FIJO");
        when(administracionRepository.existsByCodigoIgnoreCase(entity.getCodigo())).thenReturn(false);
        when(administracionRepository.save(any(OtAdministracion.class))).thenAnswer(i -> i.getArgument(0));

        OtAdministracion result = service.create(entity);

        assertThat(result.getFlagTipoCosto()).isEqualTo("F");
    }

    @Test
    void normalizar_conFlagTipoCostoInvalido_lanzaBusinessException() {
        entity.setFlagTipoCosto("INVALIDO");

        assertThatThrownBy(() -> service.create(entity))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("flagTipoCosto");
    }

    @Test
    void update_conDatosValidos_actualizaYRetorna() {
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(administracionRepository.existsByCodigoIgnoreCaseAndIdNot(entity.getCodigo(), 1L)).thenReturn(false);
        when(administracionRepository.save(any(OtAdministracion.class))).thenReturn(entity);

        entity.setNombre("Actualizado");
        OtAdministracion result = service.update(1L, entity);

        assertThat(result.getNombre()).isEqualTo("Actualizado");
    }

    @Test
    void activate_cambiaFlagEstado() {
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(administracionRepository.save(any(OtAdministracion.class))).thenReturn(entity);

        OtAdministracion result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void deactivate_cambiaFlagEstado() {
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(administracionRepository.save(any(OtAdministracion.class))).thenReturn(entity);

        OtAdministracion result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void delete_sinOTAsociadas_desactiva() {
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(administracionRepository.existsOrdenTrabajoByOtAdministracionId(1L)).thenReturn(false);
        when(administracionRepository.save(any(OtAdministracion.class))).thenReturn(entity);

        service.delete(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void delete_cuandoTieneOTAsociadas_lanzaBusinessException() {
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(administracionRepository.existsOrdenTrabajoByOtAdministracionId(1L)).thenReturn(true);

        assertThatThrownBy(() -> service.delete(1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ordenes de trabajo");
        verify(administracionRepository, never()).save(any());
    }

    @Test
    void findUsuarios_cuandoAdminExiste_retornaLista() {
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(uderRepository.findByOtAdministracionIdOrderByIdAsc(1L)).thenReturn(List.of());

        var result = service.findUsuarios(1L);

        assertThat(result).isEmpty();
    }

    @Test
    void findUsuarios_cuandoAdminInexistente_lanzaResourceNotFoundException() {
        when(administracionRepository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findUsuarios(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void asignarUsuario_conDatosValidos_guardaYRetorna() {
        var userResp = mock(ApiResponse.class);
        lenient().when(userResp.isSuccess()).thenReturn(true);
        lenient().when(userResp.getData()).thenReturn(new pe.restaurant.produccion.client.dto.UsuarioResponse());
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(authUsuarioClient.obtenerPorId(10L)).thenReturn(userResp);
        when(uderRepository.existsByOtAdministracionIdAndUsuarioId(1L, 10L)).thenReturn(false);
        when(uderRepository.save(any(OtAdminUder.class))).thenAnswer(i -> i.getArgument(0));

        OtAdminUder result = service.asignarUsuario(1L, 10L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
        verify(uderRepository).save(any(OtAdminUder.class));
    }

    @Test
    void asignarUsuario_cuandoUsuarioYaAsignado_lanzaBusinessException() {
        var userResp = mock(ApiResponse.class);
        lenient().when(userResp.isSuccess()).thenReturn(true);
        lenient().when(userResp.getData()).thenReturn(new pe.restaurant.produccion.client.dto.UsuarioResponse());
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(authUsuarioClient.obtenerPorId(10L)).thenReturn(userResp);
        when(uderRepository.existsByOtAdministracionIdAndUsuarioId(1L, 10L)).thenReturn(true);

        assertThatThrownBy(() -> service.asignarUsuario(1L, 10L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("ya esta asignado");
        verify(uderRepository, never()).save(any());
    }

    @Test
    void asignarUsuario_cuandoUsuarioInexistente_lanzaBusinessException() {
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        var failResp = mock(ApiResponse.class);
        lenient().when(failResp.isSuccess()).thenReturn(false);
        when(authUsuarioClient.obtenerPorId(999L)).thenReturn(failResp);

        assertThatThrownBy(() -> service.asignarUsuario(1L, 999L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("usuario");
    }

    @Test
    void asignarUsuario_cuandoFeignFalla_lanzaBusinessException() {
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(authUsuarioClient.obtenerPorId(1L)).thenThrow(mock(FeignException.class));

        assertThatThrownBy(() -> service.asignarUsuario(1L, 1L))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("usuario");
    }

    @Test
    void desasignarUsuario_conDatosValidos_elimina() {
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        var uder = new OtAdminUder();
        when(uderRepository.findByOtAdministracionIdAndUsuarioId(1L, 10L)).thenReturn(Optional.of(uder));

        service.desasignarUsuario(1L, 10L);

        verify(uderRepository).delete(uder);
    }

    @Test
    void desasignarUsuario_cuandoNoExisteAsignacion_lanzaResourceNotFoundException() {
        when(administracionRepository.findById(1L)).thenReturn(Optional.of(entity));
        when(uderRepository.findByOtAdministracionIdAndUsuarioId(1L, 999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.desasignarUsuario(1L, 999L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(uderRepository, never()).delete(any());
    }

    // ─── Tests de Specification (ejecutan toPredicate) ───

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conTodosLosFiltros_ejecutaToPredicate() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(administracionRepository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll("COD", "Nombre", "D", "1", pageable);

        ArgumentCaptor<Specification<OtAdministracion>> cap = ArgumentCaptor.forClass(Specification.class);
        verify(administracionRepository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Path path = mock(Path.class);
        Expression upper = mock(Expression.class);
        Predicate predicate = mock(Predicate.class);
        when(root.get(anyString())).thenReturn(path);
        when(cb.upper(any(Expression.class))).thenReturn(upper);
        when(cb.like(any(Expression.class), anyString())).thenReturn(predicate);
        lenient().when(cb.equal(any(Expression.class), any())).thenReturn(predicate);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conFiltrosNull_ejecutaToPredicate() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(administracionRepository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll(null, null, null, null, pageable);

        ArgumentCaptor<Specification<OtAdministracion>> cap = ArgumentCaptor.forClass(Specification.class);
        verify(administracionRepository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Predicate predicate = mock(Predicate.class);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }

    @Test
    @SuppressWarnings({"rawtypes", "unchecked"})
    void spec_conFiltrosBlank_ejecutaToPredicate() {
        var pageable = PageRequest.of(0, 10);
        lenient().when(administracionRepository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        service.findAll("", "", "", "", pageable);

        ArgumentCaptor<Specification<OtAdministracion>> cap = ArgumentCaptor.forClass(Specification.class);
        verify(administracionRepository).findAll(cap.capture(), eq(pageable));

        Root root = mock(Root.class);
        CriteriaQuery query = mock(CriteriaQuery.class);
        CriteriaBuilder cb = mock(CriteriaBuilder.class);
        Predicate predicate = mock(Predicate.class);
        when(cb.and(any(Predicate[].class))).thenReturn(predicate);

        Predicate result = cap.getValue().toPredicate(root, query, cb);

        assertThat(result).isNotNull();
    }
}
