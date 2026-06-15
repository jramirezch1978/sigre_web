package com.sigre.rrhh.service.impl;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.TenantContext;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.PrestamoCreateRequest;
import com.sigre.rrhh.dto.request.PrestamoUpdateRequest;
import com.sigre.rrhh.dto.response.PrestamoResponse;
import com.sigre.rrhh.entity.Prestamo;
import com.sigre.rrhh.mapper.PrestamoMapper;
import com.sigre.rrhh.repository.PrestamoRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("PrestamoServiceImpl — Pruebas Unitarias")
class PrestamoServiceImplTest {

    @Mock
    private PrestamoRepository repository;

    @Mock
    private PrestamoMapper mapper;

    @InjectMocks
    private PrestamoServiceImpl service;

    @Captor
    private ArgumentCaptor<Prestamo> captor;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenAnswer(inv -> {
            Prestamo entity = inv.getArgument(0);
            PrestamoResponse r = new PrestamoResponse();
            r.setId(entity.getId());
            r.setTrabajadorId(entity.getTrabajadorId());
            r.setMontoTotal(entity.getMontoTotal());
            r.setCuotas(entity.getCuotas());
            r.setCuotaMensual(entity.getCuotaMensual());
            r.setSaldo(entity.getSaldo());
            r.setFlagEstado(entity.getFlagEstado());
            return r;
        });
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.prestamo(1L))));

        Page<PrestamoResponse> result = service.listar(null, null, Pageable.ofSize(10));

        assertThat(result.getContent()).hasSize(1);
        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("listar() con filtro trabajador -> aplica especificación")
    void listar_conFiltroTrabajador_aplicaEspecificacion() {
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of()));

        service.listar(1L, "1", Pageable.ofSize(10));

        verify(repository).findAll(any(Specification.class), any(Pageable.class));
    }

    @Test
    @DisplayName("obtenerPorId() con ID existente -> retorna préstamo")
    void obtenerPorId_idExistente_retornaPrestamo() {
        Prestamo entity = RrhhTestFixtures.prestamo(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        PrestamoResponse result = service.obtenerPorId(1L);

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
                .hasMessageContaining("Préstamo no encontrado");
    }

    @Test
    @DisplayName("crear() con datos válidos -> calcula cuota y saldo, guarda")
    void crear_datosValidos_calculaCuotaYGuarda() {
        PrestamoCreateRequest request = RrhhTestFixtures.prestamoCreateRequest();
        Prestamo entity = RrhhTestFixtures.prestamo(1L);
        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.save(any())).thenReturn(entity);

        PrestamoResponse result = service.crear(request);

        assertThat(result).isNotNull();
        verify(mapper).toEntity(request);
        verify(repository).save(captor.capture());
        Prestamo saved = captor.getValue();
        assertThat(saved.getCuotaMensual()).isEqualByComparingTo(new BigDecimal("500.0000"));
        assertThat(saved.getSaldo()).isEqualByComparingTo(new BigDecimal("6000.0000"));
    }

    @Test
    @DisplayName("crear() con cuotas <= 0 -> lanza BusinessException")
    void crear_cuotasInvalidas_lanzaBusinessException() {
        PrestamoCreateRequest request = new PrestamoCreateRequest();
        request.setTrabajadorId(1L);
        request.setMontoTotal(new BigDecimal("1000"));
        request.setCuotas(0);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("mayores a cero");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("crear() con monto <= 0 -> lanza BusinessException")
    void crear_montoInvalido_lanzaBusinessException() {
        PrestamoCreateRequest request = new PrestamoCreateRequest();
        request.setTrabajadorId(1L);
        request.setMontoTotal(BigDecimal.ZERO);
        request.setCuotas(5);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("mayores a cero");
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizar() con ID existente y activo -> actualiza")
    void actualizar_idExistenteYActivo_actualiza() {
        Prestamo entity = RrhhTestFixtures.prestamo(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        PrestamoUpdateRequest request = RrhhTestFixtures.prestamoUpdateRequest();
        service.actualizar(1L, request);

        verify(mapper).updateEntity(entity, request);
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("actualizar() con préstamo cancelado -> lanza BusinessException")
    void actualizar_prestamoCancelado_lanzaBusinessException() {
        Prestamo entity = RrhhTestFixtures.prestamo(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.actualizar(1L, RrhhTestFixtures.prestamoUpdateRequest()))
                .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza BusinessException")
    void actualizar_idInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, RrhhTestFixtures.prestamoUpdateRequest()))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("cambiarEstado() activo -> pasa a inactivo")
    void cambiarEstado_activo_pasaAInactivo() {
        Prestamo entity = RrhhTestFixtures.prestamo(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.cambiarEstado(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("cambiarEstado() inactivo -> pasa a activo")
    void cambiarEstado_inactivo_pasaAActivo() {
        Prestamo entity = RrhhTestFixtures.prestamo(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.cambiarEstado(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("1");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("cambiarEstado() con ID inexistente -> lanza BusinessException")
    void cambiarEstado_idInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.cambiarEstado(999L))
                .isInstanceOf(BusinessException.class);
    }
}
