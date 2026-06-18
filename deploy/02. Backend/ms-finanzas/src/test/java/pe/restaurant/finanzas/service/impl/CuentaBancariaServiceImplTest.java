package pe.restaurant.finanzas.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
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
import org.springframework.jdbc.core.JdbcTemplate;
import feign.FeignException;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.finanzas.FinanzasTestFixtures;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.response.MonedaResponse;
import pe.restaurant.finanzas.dto.response.PlanContableDetResponse;
import pe.restaurant.finanzas.entity.Banco;
import pe.restaurant.finanzas.entity.BancoCnta;
import pe.restaurant.finanzas.repository.BancoCntaRepository;
import pe.restaurant.finanzas.repository.BancoRepository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - CuentaBancariaServiceImpl")
class CuentaBancariaServiceImplTest {

    @Mock private BancoCntaRepository repository;
    @Mock private BancoRepository bancoRepository;
    @Mock private JdbcTemplate jdbcTemplate;
    @Mock private CoreMaestrosClient coreMaestrosClient;

    @InjectMocks
    private CuentaBancariaServiceImpl service;

    private BancoCnta cuenta;
    private BancoCnta cuentaConFks;

    @BeforeEach
    void setUp() {
        TenantContext.setUsuarioId(1L);

        cuenta = new BancoCnta();
        cuenta.setId(1L);
        cuenta.setFlagEstado("1");
        cuenta.setSaldoDisponible(new BigDecimal("10000.00"));

        cuentaConFks = new BancoCnta();
        cuentaConFks.setId(1L);
        cuentaConFks.setCodigo("CTB-001");
        cuentaConFks.setPlanContableDetId(100L);
        cuentaConFks.setBancoId(10L);
        cuentaConFks.setMonedaId(1L);
        cuentaConFks.setFlagEstado("1");
        cuentaConFks.setSaldoContable(new BigDecimal("10000.00"));
    }


    // ==== findAll ====

    @Test
    @DisplayName("findAll - Debe retornar página")
    void findAll_DebeRetornarPagina() {
        Page<BancoCnta> page = new PageImpl<>(List.of(cuenta));
        when(repository.findAll(any(PageRequest.class))).thenReturn(page);

        Page<BancoCnta> result = service.findAll(PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }


    // ==== findById ====

    @Test
    @DisplayName("findById - Debe retornar cuenta")
    void findById_DebeRetornarCuenta() {
        when(repository.findById(1L)).thenReturn(Optional.of(cuenta));

        BancoCnta result = service.findById(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("findById - Debe lanzar excepción si no existe")
    void findById_NoExiste_DebeLanzarExcepcion() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.findById(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== getSaldoActual ====

    @Test
    @DisplayName("getSaldoActual - Debe retornar saldo")
    void getSaldoActual_DebeRetornarSaldo() {
        when(repository.findSaldoContableById(1L)).thenReturn(new BigDecimal("10000.00"));

        BigDecimal saldo = service.getSaldoActual(1L);

        assertThat(saldo).isNotNull();
        assertThat(saldo).isEqualTo(new BigDecimal("10000.00"));
    }

    @Test
    @DisplayName("getSaldoActual - Cuando saldo es null debe lanzar excepción")
    void getSaldoActual_CuandoSaldoNull_DebeLanzarExcepcion() {
        when(repository.findSaldoContableById(999L)).thenReturn(null);

        assertThatThrownBy(() -> service.getSaldoActual(999L))
                .isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== create ====

    @Test
    @DisplayName("create - Con datos válidos debe crear cuenta bancaria")
    void create_ConDatosValidos_DebeCrearCuenta() {
        lenient().when(coreMaestrosClient.obtenerPlanContableDetPorId(100L))
                .thenReturn(FinanzasTestFixtures.mockPlanContableDetResponse());
        lenient().when(coreMaestrosClient.obtenerMonedaPorId(1L))
                .thenReturn(FinanzasTestFixtures.mockMonedaResponse());
        lenient().when(bancoRepository.findById(10L))
                .thenReturn(Optional.of(new Banco()));
        when(repository.existsByCodigoIgnoreCase("CTB-001")).thenReturn(false);
        when(repository.save(any())).thenReturn(cuentaConFks);

        BancoCnta result = service.create(cuentaConFks);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }

    @Test
    @DisplayName("create - Cuando planContableDetId es null debe lanzar BusinessException")
    void create_CuandoPlanContableDetNull_DebeLanzarExcepcion() {
        cuentaConFks.setPlanContableDetId(null);

        assertThatThrownBy(() -> service.create(cuentaConFks))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("plan contable");
    }

    @Test
    @DisplayName("create - Cuando planContableDet no existe debe lanzar BusinessException")
    void create_CuandoPlanContableDetNoExiste_DebeLanzarExcepcion() {
        when(coreMaestrosClient.obtenerPlanContableDetPorId(999L))
                .thenThrow(mock(FeignException.NotFound.class));
        cuentaConFks.setPlanContableDetId(999L);

        assertThatThrownBy(() -> service.create(cuentaConFks))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("plan contable");
    }

    @Test
    @DisplayName("create - Cuando banco no existe debe lanzar ResourceNotFoundException")
    void create_CuandoBancoNoExiste_DebeLanzarExcepcion() {
        lenient().when(coreMaestrosClient.obtenerPlanContableDetPorId(100L))
                .thenReturn(FinanzasTestFixtures.mockPlanContableDetResponse());
        when(bancoRepository.findById(999L)).thenReturn(Optional.empty());
        cuentaConFks.setBancoId(999L);

        assertThatThrownBy(() -> service.create(cuentaConFks))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Banco");
    }

    @Test
    @DisplayName("create - Cuando código ya existe debe lanzar BusinessException")
    void create_CuandoCodigoDuplicado_DebeLanzarExcepcion() {
        lenient().when(coreMaestrosClient.obtenerPlanContableDetPorId(100L))
                .thenReturn(FinanzasTestFixtures.mockPlanContableDetResponse());
        lenient().when(bancoRepository.findById(10L))
                .thenReturn(Optional.of(new Banco()));
        lenient().when(coreMaestrosClient.obtenerMonedaPorId(1L))
                .thenReturn(FinanzasTestFixtures.mockMonedaResponse());
        when(repository.existsByCodigoIgnoreCase("CTB-001")).thenReturn(true);

        assertThatThrownBy(() -> service.create(cuentaConFks))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Ya existe una cuenta bancaria con código");
    }

    @Test
    @DisplayName("create - Cuando planContableDet response es null debe lanzar BusinessException")
    void create_CuandoPlanContableDetResponseNull_DebeLanzarExcepcion() {
        assertThatThrownBy(() -> service.create(cuentaConFks))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("detalle de plan contable");
    }

    @Test
    @DisplayName("create - Cuando planContableDet data es null debe lanzar BusinessException")
    void create_CuandoPlanContableDetDataNull_DebeLanzarExcepcion() {
        @SuppressWarnings("unchecked")
        ApiResponse<PlanContableDetResponse> resp = mock(ApiResponse.class);
        lenient().when(resp.getData()).thenReturn(null);
        lenient().when(coreMaestrosClient.obtenerPlanContableDetPorId(100L)).thenReturn(resp);

        assertThatThrownBy(() -> service.create(cuentaConFks))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("detalle de plan contable");
    }

    @Test
    @DisplayName("create - Cuando planContableDet está inactivo debe lanzar BusinessException")
    void create_CuandoPlanContableDetInactivo_DebeLanzarExcepcion() {
        @SuppressWarnings("unchecked")
        ApiResponse<PlanContableDetResponse> resp = mock(ApiResponse.class);
        lenient().when(resp.getData()).thenReturn(new PlanContableDetResponse(2L, "42120101", "TEST", "D", "D", "0"));
        lenient().when(coreMaestrosClient.obtenerPlanContableDetPorId(100L)).thenReturn(resp);

        assertThatThrownBy(() -> service.create(cuentaConFks))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("detalle de plan contable");
    }

    @Test
    @DisplayName("create - Cuando planContableDet falla con FeignException genérico debe lanzar BusinessException")
    void create_CuandoPlanContableDetFeignError_DebeLanzarExcepcion() {
        lenient().when(coreMaestrosClient.obtenerPlanContableDetPorId(100L))
                .thenThrow(mock(FeignException.class));

        assertThatThrownBy(() -> service.create(cuentaConFks))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Error al validar el detalle del plan contable");
    }

    @Test
    @DisplayName("create - Cuando moneda está inactiva debe lanzar BusinessException")
    void create_CuandoMonedaInactiva_DebeLanzarExcepcion() {
        lenient().when(coreMaestrosClient.obtenerPlanContableDetPorId(100L))
                .thenReturn(FinanzasTestFixtures.mockPlanContableDetResponse());
        lenient().when(bancoRepository.findById(10L))
                .thenReturn(Optional.of(new Banco()));
        @SuppressWarnings("unchecked")
        ApiResponse<MonedaResponse> resp = mock(ApiResponse.class);
        lenient().when(resp.getData()).thenReturn(new MonedaResponse(1L, "PEN", "SOLES", "S/", "0"));
        lenient().when(coreMaestrosClient.obtenerMonedaPorId(1L)).thenReturn(resp);

        assertThatThrownBy(() -> service.create(cuentaConFks))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("inactiva");
    }

    @Test
    @DisplayName("create - Cuando moneda falla con Feign NotFound debe lanzar BusinessException")
    void create_CuandoMonedaFeignNotFound_DebeLanzarExcepcion() {
        lenient().when(coreMaestrosClient.obtenerPlanContableDetPorId(100L))
                .thenReturn(FinanzasTestFixtures.mockPlanContableDetResponse());
        lenient().when(bancoRepository.findById(10L))
                .thenReturn(Optional.of(new Banco()));
        lenient().when(coreMaestrosClient.obtenerMonedaPorId(1L))
                .thenThrow(mock(FeignException.NotFound.class));

        assertThatThrownBy(() -> service.create(cuentaConFks))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("moneda");
    }

    @Test
    @DisplayName("create - Cuando moneda falla con FeignException genérico debe lanzar BusinessException")
    void create_CuandoMonedaFeignError_DebeLanzarExcepcion() {
        lenient().when(coreMaestrosClient.obtenerPlanContableDetPorId(100L))
                .thenReturn(FinanzasTestFixtures.mockPlanContableDetResponse());
        lenient().when(bancoRepository.findById(10L))
                .thenReturn(Optional.of(new Banco()));
        lenient().when(coreMaestrosClient.obtenerMonedaPorId(1L))
                .thenThrow(mock(FeignException.class));

        assertThatThrownBy(() -> service.create(cuentaConFks))
                .isInstanceOf(BusinessException.class)
                .hasMessageContaining("Error al validar la moneda");
    }


    // ==== update ====

    @Test
    @DisplayName("update - Con datos válidos debe actualizar cuenta")
    void update_ConDatosValidos_DebeActualizarCuenta() {
        lenient().when(coreMaestrosClient.obtenerPlanContableDetPorId(100L))
                .thenReturn(FinanzasTestFixtures.mockPlanContableDetResponse());
        lenient().when(coreMaestrosClient.obtenerMonedaPorId(1L))
                .thenReturn(FinanzasTestFixtures.mockMonedaResponse());
        lenient().when(bancoRepository.findById(10L))
                .thenReturn(Optional.of(new Banco()));
        when(repository.findById(1L)).thenReturn(Optional.of(cuentaConFks));
        when(repository.existsByCodigoIgnoreCaseAndIdNot("CTB-001", 1L)).thenReturn(false);
        when(repository.save(any())).thenReturn(cuentaConFks);

        BancoCnta result = service.update(1L, cuentaConFks);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }

    @Test
    @DisplayName("update - Cuando no existe debe lanzar ResourceNotFoundException")
    void update_CuandoNoExiste_DebeLanzarExcepcion() {
        when(repository.findById(999L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> service.update(999L, cuenta))
                .isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== delete ====

    @Test
    @DisplayName("delete - Debe eliminar cuenta cuando existe")
    void delete_CuandoExiste_DebeEliminar() {
        when(repository.findById(1L)).thenReturn(Optional.of(cuenta));

        service.delete(1L);

        verify(repository).delete(cuenta);
    }


    // ==== activate ====

    @Test
    @DisplayName("activate - Debe activar cuenta inactiva")
    void activate_DebeActivarCuenta() {
        cuenta.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(repository.save(any())).thenReturn(cuenta);

        BancoCnta result = service.activate(1L);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }


    // ==== deactivate ====

    @Test
    @DisplayName("deactivate - Debe desactivar cuenta activa")
    void deactivate_DebeDesactivarCuenta() {
        when(repository.findById(1L)).thenReturn(Optional.of(cuenta));
        when(repository.save(any())).thenReturn(cuenta);

        BancoCnta result = service.deactivate(1L);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }
}
