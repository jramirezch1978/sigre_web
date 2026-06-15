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
import com.sigre.rrhh.dto.request.CntaCrrteCreateRequest;
import com.sigre.rrhh.dto.request.CntaCrrteMovimientoRequest;
import com.sigre.rrhh.dto.request.CntaCrrteMovimientoUpdateRequest;
import com.sigre.rrhh.dto.request.CntaCrrteUpdateRequest;
import com.sigre.rrhh.dto.response.CntaCrrteDetResponse;
import com.sigre.rrhh.dto.response.CntaCrrteResponse;
import com.sigre.rrhh.entity.CntaCrrte;
import com.sigre.rrhh.entity.CntaCrrteDet;
import com.sigre.rrhh.mapper.CntaCrrteMapper;
import com.sigre.rrhh.repository.CntaCrrteDetRepository;
import com.sigre.rrhh.repository.CntaCrrteRepository;

import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CntaCrrteServiceImpl — Pruebas Unitarias")
class CntaCrrteServiceImplTest {

    @Mock
    private CntaCrrteRepository repository;

    @Mock
    private CntaCrrteDetRepository detRepository;

    @Mock
    private CntaCrrteMapper mapper;

    @InjectMocks
    private CntaCrrteServiceImpl service;

    @Captor
    private ArgumentCaptor<CntaCrrte> captor;

    @Captor
    private ArgumentCaptor<CntaCrrteDet> detCaptor;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);
        lenient().when(mapper.toResponse(any())).thenAnswer(inv -> {
            CntaCrrte entity = inv.getArgument(0);
            CntaCrrteResponse r = new CntaCrrteResponse();
            r.setId(entity.getId());
            r.setTrabajadorId(entity.getTrabajadorId());
            r.setFechaApertura(entity.getFechaApertura());
            r.setSaldoInicial(entity.getSaldoInicial());
            r.setSaldoActual(entity.getSaldoActual());
            r.setFlagEstado(entity.getFlagEstado());
            return r;
        });
        lenient().when(mapper.toDetResponse(any())).thenAnswer(inv -> {
            CntaCrrteDet det = inv.getArgument(0);
            CntaCrrteDetResponse r = new CntaCrrteDetResponse();
            r.setId(det.getId());
            r.setCntaCrrteId(det.getCntaCrrteId());
            r.setMonto(det.getMonto());
            return r;
        });
    }

    @Test
    @DisplayName("listar() sin filtros -> retorna página")
    void listar_sinFiltros_retornaPagina() {
        when(repository.findAll(any(Specification.class), any(Pageable.class)))
                .thenReturn(new PageImpl<>(List.of(RrhhTestFixtures.cntaCrrte(1L))));

        Page<CntaCrrteResponse> result = service.listar(null, null, Pageable.ofSize(10));

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
    @DisplayName("obtenerPorId() con ID existente -> retorna cuenta")
    void obtenerPorId_idExistente_retornaCuenta() {
        CntaCrrte entity = RrhhTestFixtures.cntaCrrte(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        CntaCrrteResponse result = service.obtenerPorId(1L);

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
                .hasMessageContaining("Cuenta corriente no encontrada");
    }

    @Test
    @DisplayName("crear() con datos válidos -> guarda cuenta")
    void crear_datosValidos_guardaCuenta() {
        CntaCrrteCreateRequest request = RrhhTestFixtures.cntaCrrteCreateRequest();
        CntaCrrte entity = RrhhTestFixtures.cntaCrrte(1L);
        when(mapper.toEntity(request)).thenReturn(entity);
        when(repository.existsByTrabajadorIdAndFlagEstado(1L, "1")).thenReturn(false);
        when(repository.save(any())).thenReturn(entity);

        CntaCrrteResponse result = service.crear(request);

        assertThat(result).isNotNull();
        verify(mapper).toEntity(request);
        verify(repository).save(captor.capture());
        CntaCrrte saved = captor.getValue();
        assertThat(saved.getSaldoActual()).isEqualByComparingTo("1000.0000");
        assertThat(saved.getCreatedBy()).isEqualTo(1L);
        assertThat(saved.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("crear() con cuenta duplicada -> lanza BusinessException")
    void crear_cuentaDuplicada_lanzaBusinessException() {
        CntaCrrteCreateRequest request = RrhhTestFixtures.cntaCrrteCreateRequest();
        when(repository.existsByTrabajadorIdAndFlagEstado(1L, "1")).thenReturn(true);

        assertThatThrownBy(() -> service.crear(request))
                .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("actualizar() con ID existente -> actualiza")
    void actualizar_idExistente_actualiza() {
        CntaCrrte entity = RrhhTestFixtures.cntaCrrte(1L);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        CntaCrrteUpdateRequest request = RrhhTestFixtures.cntaCrrteUpdateRequest();
        service.actualizar(1L, request);

        verify(mapper).updateEntity(entity, request);
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("actualizar() con ID inexistente -> lanza BusinessException")
    void actualizar_idInexistente_lanzaBusinessException() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.actualizar(999L, RrhhTestFixtures.cntaCrrteUpdateRequest()))
                .isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("cambiarEstado() activo sin saldo -> pasa a inactivo")
    void cambiarEstado_activoSinSaldo_pasaAInactivo() {
        CntaCrrte entity = RrhhTestFixtures.cntaCrrte(1L, "1");
        entity.setSaldoActual(java.math.BigDecimal.ZERO);
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.cambiarEstado(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("0");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("cambiarEstado() activo con saldo -> lanza BusinessException")
    void cambiarEstado_activoConSaldo_lanzaBusinessException() {
        CntaCrrte entity = RrhhTestFixtures.cntaCrrte(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.cambiarEstado(1L))
                .isInstanceOf(BusinessException.class);
        verify(repository, never()).save(any());
    }

    @Test
    @DisplayName("cambiarEstado() inactivo -> pasa a activo")
    void cambiarEstado_inactivo_pasaAActivo() {
        CntaCrrte entity = RrhhTestFixtures.cntaCrrte(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(entity)).thenReturn(entity);

        service.cambiarEstado(1L);

        assertThat(entity.getFlagEstado()).isEqualTo("1");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("listarMovimientos() -> retorna lista de movimientos")
    void listarMovimientos_retornaLista() {
        when(detRepository.findByCntaCrrteIdOrderByFechaMovimientoDesc(1L))
                .thenReturn(List.of(RrhhTestFixtures.cntaCrrteDet(1L)));
        when(mapper.toDetResponseList(any())).thenReturn(List.of(
                RrhhTestFixtures.cntaCrrteDetResponse(1L)));

        List<CntaCrrteDetResponse> result = service.listarMovimientos(1L);

        assertThat(result).hasSize(1);
        verify(detRepository).findByCntaCrrteIdOrderByFechaMovimientoDesc(1L);
    }

    @Test
    @DisplayName("crearMovimiento() en cuenta activa -> registra y actualiza saldo")
    void crearMovimiento_cuentaActiva_registraYActualizaSaldo() {
        CntaCrrte cuenta = RrhhTestFixtures.cntaCrrte(1L, "1");
        when(repository.findById(1L)).thenReturn(Optional.of(cuenta));
        CntaCrrteMovimientoRequest request = RrhhTestFixtures.cntaCrrteMovimientoRequest();
        CntaCrrteDet det = RrhhTestFixtures.cntaCrrteDet(1L);
        when(mapper.toDetEntity(request)).thenReturn(det);
        when(detRepository.save(any())).thenReturn(det);

        service.crearMovimiento(1L, request);

        verify(detRepository).save(detCaptor.capture());
        CntaCrrteDet savedDet = detCaptor.getValue();
        assertThat(savedDet.getCntaCrrteId()).isEqualTo(1L);
        assertThat(savedDet.getCreatedBy()).isEqualTo(1L);
        assertThat(savedDet.getFecCreacion()).isNotNull();
    }

    @Test
    @DisplayName("crearMovimiento() en cuenta inactiva -> lanza BusinessException")
    void crearMovimiento_cuentaInactiva_lanzaBusinessException() {
        CntaCrrte cuenta = RrhhTestFixtures.cntaCrrte(1L, "0");
        when(repository.findById(1L)).thenReturn(Optional.of(cuenta));

        assertThatThrownBy(() -> service.crearMovimiento(1L, RrhhTestFixtures.cntaCrrteMovimientoRequest()))
                .isInstanceOf(BusinessException.class);
        verify(detRepository, never()).save(any());
    }

    @Test
    @DisplayName("actualizarMovimiento() -> actualiza y ajusta saldo")
    void actualizarMovimiento_actualizaYAjustaSaldo() {
        CntaCrrte cuenta = RrhhTestFixtures.cntaCrrte(1L, "1");
        cuenta.setSaldoActual(new java.math.BigDecimal("500.0000"));
        when(repository.findById(1L)).thenReturn(Optional.of(cuenta));
        CntaCrrteDet det = RrhhTestFixtures.cntaCrrteDet(1L);
        det.setMonto(new java.math.BigDecimal("200.0000"));
        when(detRepository.findById(2L)).thenReturn(Optional.of(det));
        CntaCrrteMovimientoUpdateRequest request = RrhhTestFixtures.cntaCrrteMovimientoUpdateRequest();
        when(detRepository.save(det)).thenReturn(det);

        service.actualizarMovimiento(1L, 2L, request);

        verify(detRepository).save(det);
    }

    @Test
    @DisplayName("eliminarMovimiento() -> elimina y ajusta saldo")
    void eliminarMovimiento_eliminaYAjustaSaldo() {
        CntaCrrte cuenta = RrhhTestFixtures.cntaCrrte(1L, "1");
        cuenta.setSaldoActual(new java.math.BigDecimal("500.0000"));
        when(repository.findById(1L)).thenReturn(Optional.of(cuenta));
        CntaCrrteDet det = RrhhTestFixtures.cntaCrrteDet(1L);
        det.setMonto(new java.math.BigDecimal("200.0000"));
        when(detRepository.findById(2L)).thenReturn(Optional.of(det));

        service.eliminarMovimiento(1L, 2L);

        verify(detRepository).delete(det);
    }
}
