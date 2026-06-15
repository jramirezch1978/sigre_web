package com.sigre.produccion.service.impl;

import feign.FeignException;
import jakarta.persistence.EntityManager;
import jakarta.persistence.Query;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.test.util.ReflectionTestUtils;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.produccion.ProduccionTestFixtures;
import com.sigre.produccion.client.AlmacenValeMovClient;
import com.sigre.produccion.client.CoreArticuloClient;
import com.sigre.produccion.client.CoreUnidadMedidaClient;
import com.sigre.produccion.client.dto.ArticuloResponse;
import com.sigre.produccion.entity.ParteProduccion;
import com.sigre.produccion.entity.ParteProduccionInsumo;
import com.sigre.produccion.entity.ParteProduccionProducido;
import com.sigre.produccion.repository.ParteProduccionInsumoRepository;
import com.sigre.produccion.repository.ParteProduccionProducidoRepository;
import com.sigre.produccion.repository.ParteProduccionRepository;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ParteProduccionServiceImpl — Pruebas Unitarias")
class ParteProduccionServiceImplTest {

    @Mock private ParteProduccionRepository repository;
    @Mock private ParteProduccionInsumoRepository insumoRepository;
    @Mock private ParteProduccionProducidoRepository producidoRepository;
    @Mock private CoreArticuloClient coreArticuloClient;
    @Mock private CoreUnidadMedidaClient coreUnidadMedidaClient;
    @Mock private AlmacenValeMovClient almacenValeMovClient;
    @Mock private EntityManager entityManager;
    @Mock private Query query;

    private ParteProduccionServiceImpl service;
    private ParteProduccion entity;

    @BeforeEach
    void setUp() {
        service = new ParteProduccionServiceImpl(repository, insumoRepository,
                producidoRepository, coreArticuloClient, coreUnidadMedidaClient, almacenValeMovClient);
        ReflectionTestUtils.setField(service, "entityManager", entityManager);
        entity = ProduccionTestFixtures.parteProduccion(1L, "1");

        TenantContext.setEmpresaId(1L);
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);

        var artResp = mock(ApiResponse.class);
        lenient().when(artResp.isSuccess()).thenReturn(true);
        lenient().when(artResp.getData()).thenReturn(new ArticuloResponse(1L, "ART", "Test", "1"));
        lenient().when(coreArticuloClient.obtenerPorId(anyLong())).thenReturn(artResp);
        lenient().when(coreUnidadMedidaClient.obtenerPorId(anyLong())).thenReturn(artResp);

        lenient().when(entityManager.createNativeQuery(anyString())).thenReturn(query);
        lenient().when(query.setParameter(anyString(), any())).thenReturn(query);
        lenient().when(query.getSingleResult()).thenReturn(1);
    }

    @AfterEach
    void tearDown() {
        TenantContext.clear();
    }

    private ParteProduccionInsumo insumoValido() {
        var i = new ParteProduccionInsumo();
        i.setArticuloId(1L);
        i.setCantidadConsumida(BigDecimal.TEN);
        return i;
    }

    private ParteProduccionProducido producidoValido() {
        var p = new ParteProduccionProducido();
        p.setArticuloId(1L);
        p.setCantidadProducida(BigDecimal.TEN);
        return p;
    }

    // ==================== findById ====================

    @Test
    void findById_cuandoExisteId_retornaEntidad() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        assertThat(service.findById(1L)).isNotNull();
    }

    @Test
    void findById_cuandoIdNoExiste_lanzaResourceNotFoundException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.findById(999L)).isInstanceOf(ResourceNotFoundException.class);
    }

    // ==================== findAll ====================

    @Test
    void findAll_conFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(new PageImpl<>(List.of(entity)));

        Page<ParteProduccion> result = service.findAll(1L, LocalDate.now(), LocalDate.now(), "1", pageable);

        assertThat(result).hasSize(1);
    }

    @Test
    void findAll_sinFiltros_retornaPage() {
        var pageable = PageRequest.of(0, 10);
        when(repository.findAll(any(Specification.class), eq(pageable)))
                .thenReturn(Page.empty());

        Page<ParteProduccion> result = service.findAll(null, null, null, null, pageable);

        assertThat(result).isEmpty();
    }

    // ==================== create ====================

    @Test
    void create_conInsumos_guardaYRetorna() {
        when(repository.save(any(ParteProduccion.class))).thenAnswer(i -> i.getArgument(0));

        ParteProduccion result = service.create(entity, List.of(insumoValido()), List.of());

        assertThat(result).isNotNull();
        assertThat(result.getCreatedBy()).isEqualTo(1L);
        verify(repository).save(any(ParteProduccion.class));
        verify(insumoRepository).save(any(ParteProduccionInsumo.class));
    }

    @Test
    void create_conProducidos_guardaYRetorna() {
        when(repository.save(any(ParteProduccion.class))).thenAnswer(i -> i.getArgument(0));

        ParteProduccion result = service.create(entity, List.of(), List.of(producidoValido()));

        assertThat(result).isNotNull();
        verify(producidoRepository).save(any(ParteProduccionProducido.class));
    }

    @Test
    void create_sinFlagEstado_asignaActivo() {
        entity.setFlagEstado(null);
        when(repository.save(any(ParteProduccion.class))).thenAnswer(i -> i.getArgument(0));

        ParteProduccion result = service.create(entity, List.of(insumoValido()), List.of());

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void create_cuandoDatosObligatoriosFaltan_lanzaBusinessException() {
        entity.setOrdenTrabajoId(null);

        assertThatThrownBy(() -> service.create(entity, List.of(insumoValido()), List.of()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("obligatorios");
    }

    @Test
    void create_cuandoFechaNull_lanzaBusinessException() {
        entity.setFecha(null);

        assertThatThrownBy(() -> service.create(entity, List.of(insumoValido()), List.of()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("obligatorios");
    }

    @Test
    void create_cuandoOTInactiva_lanzaBusinessException() {
        reset(query);
        when(query.setParameter(anyString(), any())).thenReturn(query);
        when(query.getSingleResult()).thenReturn(0);

        assertThatThrownBy(() -> service.create(entity, List.of(insumoValido()), List.of()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("orden de trabajo");
    }

    @Test
    void create_sinInsumosNiProducidos_lanzaBusinessException() {
        assertThatThrownBy(() -> service.create(entity, List.of(), List.of()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("al menos un insumo");
    }

    @Test
    void create_sinInsumosNiProducidosNull_lanzaBusinessException() {
        assertThatThrownBy(() -> service.create(entity, null, null))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("al menos un insumo");
    }

    @Test
    void create_conCantidadInsumoCero_lanzaBusinessException() {
        var insumo = insumoValido();
        insumo.setCantidadConsumida(BigDecimal.ZERO);

        assertThatThrownBy(() -> service.create(entity, List.of(insumo), List.of()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("cantidad");
    }

    @Test
    void create_conArticuloFeignFalla_lanzaBusinessException() {
        when(coreArticuloClient.obtenerPorId(anyLong())).thenThrow(mock(FeignException.class));

        assertThatThrownBy(() -> service.create(entity, List.of(insumoValido()), List.of()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("artículo");
    }

    // ==================== update ====================

    @Test
    void update_conDatosValidos_actualizaYRetorna() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ParteProduccion.class))).thenAnswer(i -> i.getArgument(0));

        ParteProduccion input = ProduccionTestFixtures.parteProduccion(1L, "1");
        input.setFecha(LocalDate.of(2025, 5, 1));
        ParteProduccion result = service.update(1L, input, List.of(insumoValido()), List.of());

        assertThat(result).isNotNull();
        verify(insumoRepository).deleteByParteProduccionId(1L);
        verify(insumoRepository).save(any(ParteProduccionInsumo.class));
    }

    @Test
    void update_cuandoParteInactivo_lanzaBusinessException() {
        ParteProduccion inactive = ProduccionTestFixtures.parteProduccion(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(inactive));

        assertThatThrownBy(() -> service.update(1L, entity, List.of(insumoValido()), List.of()))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("inactivo");
    }

    // ==================== activate / deactivate / delete ====================

    @Test
    void activate_cuandoInactiva_cambiaFlagEstado() {
        ParteProduccion inactive = ProduccionTestFixtures.parteProduccion(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(inactive));
        when(repository.save(any(ParteProduccion.class))).thenAnswer(i -> i.getArgument(0));

        ParteProduccion result = service.activate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("1");
    }

    @Test
    void deactivate_cambiaFlagEstado() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ParteProduccion.class))).thenAnswer(i -> i.getArgument(0));

        ParteProduccion result = service.deactivate(1L);

        assertThat(result.getFlagEstado()).isEqualTo("0");
    }

    @Test
    void delete_desactivaLogico() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any(ParteProduccion.class))).thenAnswer(i -> i.getArgument(0));

        service.delete(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    // ==================== findInsumos / findProducidos ====================

    @Test
    void findInsumos_retornaLista() {
        when(insumoRepository.findByParteProduccionIdOrderByIdAsc(1L)).thenReturn(List.of(insumoValido()));

        var result = service.findInsumos(1L);

        assertThat(result).hasSize(1);
    }

    @Test
    void findProducidos_retornaLista() {
        when(producidoRepository.findByParteProduccionIdOrderByIdAsc(1L)).thenReturn(List.of(producidoValido()));

        var result = service.findProducidos(1L);

        assertThat(result).hasSize(1);
    }

    // ==================== validarUnidadMedida y validarValeMov ====================

    @Test
    void create_conInsumoConUnidadMedidaYVale_validaAmbos() {
        var umResp = mock(com.sigre.common.dto.ApiResponse.class);
        lenient().when(umResp.isSuccess()).thenReturn(true);
        lenient().when(umResp.getData()).thenReturn(mock(com.sigre.produccion.client.dto.UnidadMedidaResponse.class));
        lenient().when(coreUnidadMedidaClient.obtenerPorId(anyLong())).thenReturn(umResp);

        var valeResp = mock(com.sigre.common.dto.ApiResponse.class);
        lenient().when(valeResp.isSuccess()).thenReturn(true);
        lenient().when(valeResp.getData()).thenReturn(new Object());
        lenient().when(almacenValeMovClient.obtenerPorId(anyLong())).thenReturn(valeResp);

        when(repository.save(any(ParteProduccion.class))).thenAnswer(i -> i.getArgument(0));

        var insumo = insumoValido();
        insumo.setUnidadMedidaId(1L);
        insumo.setValeMovId(1L);

        service.create(entity, List.of(insumo), List.of());

        verify(coreUnidadMedidaClient, atLeastOnce()).obtenerPorId(anyLong());
        verify(almacenValeMovClient, atLeastOnce()).obtenerPorId(anyLong());
    }

    @Test
    void create_conProducidoConUnidadMedida_validaUM() {
        var umResp = mock(com.sigre.common.dto.ApiResponse.class);
        lenient().when(umResp.isSuccess()).thenReturn(true);
        lenient().when(umResp.getData()).thenReturn(mock(com.sigre.produccion.client.dto.UnidadMedidaResponse.class));
        lenient().when(coreUnidadMedidaClient.obtenerPorId(anyLong())).thenReturn(umResp);

        when(repository.save(any(ParteProduccion.class))).thenAnswer(i -> i.getArgument(0));

        var producido = producidoValido();
        producido.setUnidadMedidaId(1L);

        service.create(entity, List.of(), List.of(producido));

        verify(coreUnidadMedidaClient, atLeastOnce()).obtenerPorId(anyLong());
    }

    @Test
    void create_conCantidadNull_noValida() {
        when(repository.save(any(ParteProduccion.class))).thenAnswer(i -> i.getArgument(0));

        var insumo = insumoValido();
        insumo.setCantidadConsumida(null);

        service.create(entity, List.of(insumo), List.of());

        verify(repository).save(any(ParteProduccion.class));
    }
}
