package com.sigre.finanzas.service;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import feign.FeignException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.ResourceNotFoundException;
import com.sigre.common.security.TenantContext;
import com.sigre.common.service.NumeradorDocumentoService;
import com.sigre.finanzas.client.ContabilidadClient;
import com.sigre.finanzas.client.CoreMaestrosClient;
import com.sigre.finanzas.dto.request.CajaBancosDetalleRequest;
import com.sigre.finanzas.dto.request.CajaBancosRequest;
import com.sigre.finanzas.dto.response.CajaBancosDetalleResponse;
import com.sigre.finanzas.dto.response.CajaBancosResponse;
import com.sigre.finanzas.dto.response.EjecutarMovimientoResponse;
import com.sigre.common.dto.ApiResponse;
import com.sigre.finanzas.dto.response.GenerarAsientoResponse;
import com.sigre.finanzas.entity.BancoCnta;
import com.sigre.finanzas.entity.CajaBancos;
import com.sigre.finanzas.entity.CajaBancosDet;
import com.sigre.finanzas.mapper.CajaBancosDetMapper;
import com.sigre.finanzas.mapper.CajaBancosMapper;
import com.sigre.finanzas.repository.BancoCntaRepository;
import com.sigre.finanzas.repository.CajaBancosDetRepository;
import com.sigre.finanzas.repository.CajaBancosRepository;
import com.sigre.finanzas.service.support.CntasPagarCabeceraValidator;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.*;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - CajaBancosService")
class CajaBancosServiceTest {

    @Mock private CajaBancosRepository repository;
    @Mock private CajaBancosDetRepository detRepository;
    @Mock private BancoCntaRepository bancoCntaRepository;
    @Mock private CajaBancosMapper mapper;
    @Mock private CajaBancosDetMapper detMapper;
    @Mock private NumeradorDocumentoService numeradorDocumentoService;
    @Mock private ContabilidadClient contabilidadClient;
    @Mock private CoreMaestrosClient coreMaestrosClient;
    @Mock private CntasPagarCabeceraValidator cabeceraValidator;

    @InjectMocks
    private CajaBancosService service;

    private CajaBancos entity;
    private CajaBancosResponse response;
    private CajaBancosDetalleResponse detalleResponse;
    private BancoCnta bancoCnta;

    @BeforeEach
    void setUp() {
        TenantContext.setSucursalId(1L);
        TenantContext.setUsuarioId(1L);
        TenantContext.setEmpresaId(2L);

        entity = new CajaBancos();
        entity.setId(1L);
        entity.setSucursalId(1L);
        entity.setNroRegistro("CB-2026-00001");
        entity.setFlagTipoTransaccion("C");
        entity.setBancoCntaId(1L);
        entity.setMonedaId(1L);
        entity.setImpTotal(new BigDecimal("1000.00"));
        entity.setImpAsignado(new BigDecimal("1000.00"));
        entity.setAno(2026);
        entity.setMes(6);
        entity.setCntblLibroId(1L);
        entity.setConceptoFinancieroId(1L);
        entity.setFechaEmision(LocalDate.of(2026, 6, 1));
        entity.setFlagEstado("1");

        response = new CajaBancosResponse();
        response.setId(1L);
        response.setNroRegistro("CB-2026-00001");
        response.setFlagTipoTransaccion("C");
        response.setImpTotal(new BigDecimal("1000.00"));

        detalleResponse = new CajaBancosDetalleResponse();
        detalleResponse.setId(1L);
        detalleResponse.setNroRegistro("CB-2026-00001");
        detalleResponse.setFlagTipoTransaccion("C");

        bancoCnta = new BancoCnta();
        bancoCnta.setId(1L);
        bancoCnta.setFlagEstado("1");
        bancoCnta.setCodigo("001-123456");
        bancoCnta.setSaldoDisponible(new BigDecimal("50000.00"));
        bancoCnta.setPlanContableDetId(2L);

        // Incluir al menos un detalle para que ejecutar() pueda generar asiento contable
        CajaBancosDet detalle = new CajaBancosDet();
        detalle.setId(1L);
        detalle.setItem(1);
        detalle.setEntidadContribuyenteId(1L);
        detalle.setDocTipoId(1L);
        detalle.setNroDoc("F001-000001");
        detalle.setImporte(new BigDecimal("1000.00"));
        entity.addDetalle(detalle);

        lenient().doNothing().when(cabeceraValidator).validar(any(), any(), any());
    }


    // ==== listar — otros ====

    @Test
    @DisplayName("listar - Debe retornar página de movimientos")
    void listar_DebeRetornarPagina() {
        Page<CajaBancos> page = new PageImpl<>(List.of(entity));
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<CajaBancosResponse> result = service.listar(null, null, null, null, null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }


    // ==== obtenerPorId — otros ====

    @Test
    @DisplayName("obtenerPorId - Debe retornar detalle de movimiento")
    void obtenerPorId_DebeRetornarDetalle() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(mapper.toDetalleResponse(entity)).thenReturn(detalleResponse);

        CajaBancosDetalleResponse result = service.obtenerPorId(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
    }

    @Test
    @DisplayName("obtenerPorId - Debe lanzar excepción si no existe")
    void obtenerPorId_NoExiste_DebeLanzarExcepcion() {
        when(repository.findById(999L)).thenReturn(Optional.empty());
        assertThatThrownBy(() -> service.obtenerPorId(999L)).isInstanceOf(ResourceNotFoundException.class);
    }


    // ==== anular — otros ====

    @Test
    @DisplayName("anular - Debe anular movimiento activo")
    void anular_DebeAnularMovimiento() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(repository.save(any())).thenReturn(entity);

        Map<String, Object> result = service.anular(1L);

        assertThat(result).isNotNull();
        assertThat(result.get("flagEstado")).isEqualTo("0");
        verify(repository).save(entity);
    }

    @Test
    @DisplayName("anular - Debe lanzar excepción si ya está anulado")
    void anular_YaAnulado_DebeLanzarExcepcion() {
        entity.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.anular(1L)).isInstanceOf(BusinessException.class);
    }


    // ==== ejecutar — otros ====

    @Test
    @DisplayName("ejecutar - Debe ejecutar cobro")
    void ejecutar_Cobro_DebeEjecutar() {
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        GenerarAsientoResponse mockAsiento = new GenerarAsientoResponse();
        mockAsiento.setAsientoId(100L);
        when(contabilidadClient.generarAsientoCarteraCobros(any())).thenReturn(ApiResponse.ok(mockAsiento));

        EjecutarMovimientoResponse result = service.ejecutar(1L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(1L);
        verify(bancoCntaRepository).save(any());
    }

    @Test
    @DisplayName("ejecutar - Debe lanzar excepción si ya fue ejecutado")
    void ejecutar_YaEjecutado_DebeLanzarExcepcion() {
        entity.setFechaEjecucion(LocalDate.now());
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.ejecutar(1L)).isInstanceOf(BusinessException.class);
    }

    @Test
    @DisplayName("ejecutar - Debe ejecutar pago")
    void ejecutar_Pago_DebeEjecutar() {
        entity.setFlagTipoTransaccion("P");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        GenerarAsientoResponse mockAsiento = new GenerarAsientoResponse();
        mockAsiento.setAsientoId(100L);
        when(contabilidadClient.generarAsientoCarteraPagos(any())).thenReturn(ApiResponse.ok(mockAsiento));

        EjecutarMovimientoResponse result = service.ejecutar(1L);

        assertThat(result).isNotNull();
        verify(bancoCntaRepository).save(any());
    }


    // ==== anular — otros ====

    @Test
    @DisplayName("anular - Debe lanzar excepción si movimiento ejecutado")
    void anular_Ejecutado_DebeLanzarExcepcion() {
        entity.setFechaEjecucion(LocalDate.now());
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.anular(1L)).isInstanceOf(BusinessException.class);
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("actualizar - Debe actualizar movimiento activo")
    void actualizar_DebeActualizarMovimiento() {
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("C");
        request.setBancoCntaId(1L);
        request.setImpTotal(new BigDecimal("2000.00"));
        CajaBancosDetalleRequest detalle = new CajaBancosDetalleRequest();
        detalle.setImporte(new BigDecimal("2000.00"));
        request.setDetalles(List.of(detalle));

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));
        doNothing().when(mapper).updateEntity(any(), any());
        when(repository.save(any())).thenReturn(entity);
        when(detMapper.toEntity(any(CajaBancosDetalleRequest.class))).thenReturn(new com.sigre.finanzas.entity.CajaBancosDet());
        when(mapper.toDetalleResponse(any())).thenReturn(detalleResponse);

        CajaBancosDetalleResponse result = service.actualizar(1L, request);

        assertThat(result).isNotNull();
        verify(repository).save(any());
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("crear - Debe crear movimiento de cobro")
    void crear_Cobro_DebeCrearMovimiento() {
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("C");
        request.setBancoCntaId(1L);
        request.setImpTotal(new BigDecimal("1000.00"));
        CajaBancosDetalleRequest detalle = new CajaBancosDetalleRequest();
        detalle.setImporte(new BigDecimal("1000.00"));
        request.setDetalles(List.of(detalle));

        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt())).thenReturn("CB-2026-00001");
        when(mapper.toEntity(any())).thenReturn(entity);
        when(repository.saveAndFlush(any())).thenReturn(entity);
        when(detMapper.toEntity(any(CajaBancosDetalleRequest.class))).thenReturn(new com.sigre.finanzas.entity.CajaBancosDet());
        when(mapper.toDetalleResponse(any())).thenReturn(detalleResponse);

        CajaBancosDetalleResponse result = service.crear(request);

        assertThat(result).isNotNull();
        verify(repository).saveAndFlush(any());
    }


    // ==== crear — otros ====

    @Test
    @DisplayName("crear - Debe lanzar excepción si tipo de transacción inválido")
    void crear_TipoInvalido_DebeLanzarExcepcion() {
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("X");
        request.setBancoCntaId(1L);

        assertThatThrownBy(() -> service.crear(request)).isInstanceOf(BusinessException.class);
    }


    // ==== ejecutar — edge cases ====

    @Test
    @DisplayName("ejecutar - Debe lanzar excepción si tipo inválido")
    void ejecutar_TipoInvalido_DebeLanzarExcepcion() {
        entity.setFlagTipoTransaccion("Z");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.ejecutar(1L)).isInstanceOf(BusinessException.class);
    }


    // ==== ejecutar — otros ====

    @Test
    @DisplayName("ejecutar - Debe lanzar excepción si movimiento anulado")
    void ejecutar_Anulado_DebeLanzarExcepcion() {
        entity.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(entity));

        assertThatThrownBy(() -> service.ejecutar(1L)).isInstanceOf(BusinessException.class);
    }


    // ==== listar — otros ====

    @Test
    @DisplayName("listar - Debe retornar página con filtro por tipo")
    void listar_ConFiltroTipo_DebeRetornarPagina() {
        Page<CajaBancos> page = new PageImpl<>(List.of(entity));
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<CajaBancosResponse> result = service.listar("C", null, null, null, null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    @Test
    @DisplayName("listar - Debe retornar página con filtro por estado EJECUTADO")
    void listar_ConFiltroEstadoEjecutado_DebeRetornarPagina() {
        Page<CajaBancos> page = new PageImpl<>(List.of(entity));
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<CajaBancosResponse> result = service.listar(null, null, null, null, "EJECUTADO", null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }


    // ==== ejecutar — otros ====

    @Test
    @DisplayName("ejecutar - Debe ejecutar transferencia")
    void ejecutar_Transferencia_DebeEjecutar() {
        entity.setFlagTipoTransaccion("T");
        entity.setBancoCntaRefId(2L);
        BancoCnta cuentaDestino = new BancoCnta();
        cuentaDestino.setId(2L);
        cuentaDestino.setFlagEstado("1");
        cuentaDestino.setCodigo("002-789012");
        cuentaDestino.setSaldoDisponible(new BigDecimal("30000.00"));
        cuentaDestino.setPlanContableDetId(3L);

        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));
        when(bancoCntaRepository.findById(2L)).thenReturn(Optional.of(cuentaDestino));

        GenerarAsientoResponse mockAsiento = new GenerarAsientoResponse();
        mockAsiento.setAsientoId(100L);
        when(contabilidadClient.generarAsientoTransferencias(any())).thenReturn(ApiResponse.ok(mockAsiento));

        EjecutarMovimientoResponse result = service.ejecutar(1L);

        assertThat(result).isNotNull();
        verify(bancoCntaRepository, atLeastOnce()).save(any());
    }


    // ==== listar — otros ====

    @Test
    @DisplayName("listar - Debe retornar página con filtro por entidad")
    void listar_ConFiltroEntidad_DebeRetornarPagina() {
        Page<CajaBancos> page = new PageImpl<>(List.of(entity));
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        Page<CajaBancosResponse> result = service.listar(null, null, null, null, null, 1L, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    // ==== listar — filtro bancoCntaId ====

    @Test
    @DisplayName("listar() con filtro por bancoCntaId -> retorna página filtrada")
    void listar_conFiltroBancoCntaId_retornaPagina() {
        // Arrange
        Page<CajaBancos> page = new PageImpl<>(List.of(entity));
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);

        // Act
        Page<CajaBancosResponse> result = service.listar(null, 1L, null, null, null, null, PageRequest.of(0, 10));

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
    }

    // ==== listar — enriquecimiento de datos maestros ====

    @Test
    @DisplayName("listar() enriquece response con datos de cuenta bancaria")
    void listar_conBancoCntaId_enriqueceCodigoCuenta() {
        // Arrange
        response.setBancoCntaId(1L);
        Page<CajaBancos> page = new PageImpl<>(List.of(entity));
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        // Act
        Page<CajaBancosResponse> result = service.listar(null, null, null, null, null, null, PageRequest.of(0, 10));

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getContent().get(0).getBancoCntaCodigo()).isEqualTo("001-123456");
        verify(bancoCntaRepository).findById(1L);
    }

    // ==== crear — validaciones transferencia ====

    @Test
    @DisplayName("crear() con transferencia sin cuenta destino -> lanza BusinessException")
    void crear_transferencia_sinCuentaDestino_lanzaBusinessException() {
        // Arrange
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("T");
        request.setBancoCntaId(1L);
        request.setBancoCntaRefId(null);
        request.setImpTotal(new BigDecimal("500.00"));
        CajaBancosDetalleRequest detalle = new CajaBancosDetalleRequest();
        detalle.setImporte(new BigDecimal("500.00"));
        request.setDetalles(List.of(detalle));

        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        // Act & Assert
        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("cuenta bancaria destino es obligatoria");
    }

    @Test
    @DisplayName("crear() con transferencia misma cuenta origen y destino -> lanza BusinessException")
    void crear_transferencia_mismaCuentaOrigenDestino_lanzaBusinessException() {
        // Arrange
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("T");
        request.setBancoCntaId(1L);
        request.setBancoCntaRefId(1L);
        request.setImpTotal(new BigDecimal("500.00"));
        CajaBancosDetalleRequest detalle = new CajaBancosDetalleRequest();
        detalle.setImporte(new BigDecimal("500.00"));
        request.setDetalles(List.of(detalle));

        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        // Act & Assert
        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("cuenta origen y destino no pueden ser la misma");
    }

    // ==== crear — validaciones aplicación ====

    @Test
    @DisplayName("crear() con aplicación sin detalles -> lanza BusinessException")
    void crear_aplicacion_sinDetalles_lanzaBusinessException() {
        // Arrange
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("A");
        request.setBancoCntaId(1L);
        request.setImpTotal(new BigDecimal("1000.00"));

        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        // Act & Assert
        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Los detalles son obligatorios para aplicación de documentos");
    }

    // ==== crear — validaciones cuadre ====

    @Test
    @DisplayName("crear() con detalles que no cuadran con total -> lanza BusinessException")
    void crear_detallesNoCuadranConTotal_lanzaBusinessException() {
        // Arrange
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("C");
        request.setBancoCntaId(1L);
        request.setImpTotal(new BigDecimal("1000.00"));
        CajaBancosDetalleRequest detalle = new CajaBancosDetalleRequest();
        detalle.setImporte(new BigDecimal("700.00"));
        request.setDetalles(List.of(detalle));

        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        // Act & Assert
        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("no coincide con el importe total");
    }

    // ==== crear — validaciones cuenta bancaria inactiva ====

    @Test
    @DisplayName("crear() con cuenta bancaria inactiva -> lanza BusinessException")
    void crear_cuentaBancariaInactiva_lanzaBusinessException() {
        // Arrange
        BancoCnta cuentaInactiva = new BancoCnta();
        cuentaInactiva.setId(1L);
        cuentaInactiva.setFlagEstado("0");
        cuentaInactiva.setCodigo("001-INACTIVA");

        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("C");
        request.setBancoCntaId(1L);
        request.setImpTotal(new BigDecimal("1000.00"));
        CajaBancosDetalleRequest detalle = new CajaBancosDetalleRequest();
        detalle.setImporte(new BigDecimal("1000.00"));
        request.setDetalles(List.of(detalle));

        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(cuentaInactiva));

        // Act & Assert
        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("cuenta bancaria no está activa");
    }

    @Test
    @DisplayName("crear() con transferencia a cuenta destino inactiva -> lanza BusinessException")
    void crear_cuentaBancariaDestinoInactiva_lanzaBusinessException() {
        // Arrange
        BancoCnta cuentaDestinoInactiva = new BancoCnta();
        cuentaDestinoInactiva.setId(2L);
        cuentaDestinoInactiva.setFlagEstado("0");
        cuentaDestinoInactiva.setCodigo("002-INACTIVA");

        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("T");
        request.setBancoCntaId(1L);
        request.setBancoCntaRefId(2L);
        request.setImpTotal(new BigDecimal("500.00"));
        CajaBancosDetalleRequest detalle = new CajaBancosDetalleRequest();
        detalle.setImporte(new BigDecimal("500.00"));
        request.setDetalles(List.of(detalle));

        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));
        when(bancoCntaRepository.findById(2L)).thenReturn(Optional.of(cuentaDestinoInactiva));

        // Act & Assert
        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("cuenta bancaria destino no está activa");
    }

    // ==== actualizar — validaciones estado ====

    @Test
    @DisplayName("actualizar() con movimiento ejecutado -> lanza BusinessException")
    void actualizar_ejecutado_lanzaBusinessException() {
        // Arrange
        CajaBancos entityEjecutado = new CajaBancos();
        entityEjecutado.setId(10L);
        entityEjecutado.setFechaEjecucion(LocalDate.now());
        entityEjecutado.setFlagEstado("1");

        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("C");
        request.setBancoCntaId(1L);
        request.setImpTotal(new BigDecimal("1000.00"));
        CajaBancosDetalleRequest detalle = new CajaBancosDetalleRequest();
        detalle.setImporte(new BigDecimal("1000.00"));
        request.setDetalles(List.of(detalle));

        when(repository.findById(10L)).thenReturn(Optional.of(entityEjecutado));

        // Act & Assert
        assertThatThrownBy(() -> service.actualizar(10L, request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("No se puede editar un movimiento ejecutado");
    }

    @Test
    @DisplayName("actualizar() con movimiento anulado -> lanza BusinessException")
    void actualizar_anulado_lanzaBusinessException() {
        // Arrange
        CajaBancos entityAnulado = new CajaBancos();
        entityAnulado.setId(11L);
        entityAnulado.setFlagEstado("0");

        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("C");
        request.setBancoCntaId(1L);
        request.setImpTotal(new BigDecimal("1000.00"));
        CajaBancosDetalleRequest detalle = new CajaBancosDetalleRequest();
        detalle.setImporte(new BigDecimal("1000.00"));
        request.setDetalles(List.of(detalle));

        when(repository.findById(11L)).thenReturn(Optional.of(entityAnulado));

        // Act & Assert
        assertThatThrownBy(() -> service.actualizar(11L, request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("No se puede editar un movimiento anulado");
    }

    // ==== actualizar — validaciones transferencia ====

    @Test
    @DisplayName("actualizar() con transferencia sin cuenta destino -> lanza BusinessException")
    void actualizar_transferencia_sinCuentaDestino_lanzaBusinessException() {
        // Arrange
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("T");
        request.setBancoCntaId(1L);
        request.setBancoCntaRefId(null);
        request.setImpTotal(new BigDecimal("500.00"));
        CajaBancosDetalleRequest detalle = new CajaBancosDetalleRequest();
        detalle.setImporte(new BigDecimal("500.00"));
        request.setDetalles(List.of(detalle));

        // Act & Assert
        assertThatThrownBy(() -> service.actualizar(1L, request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("cuenta bancaria destino es obligatoria");
    }

    @Test
    @DisplayName("actualizar() con transferencia misma cuenta origen y destino -> lanza BusinessException")
    void actualizar_transferencia_mismaCuentaOrigenDestino_lanzaBusinessException() {
        // Arrange
        when(repository.findById(1L)).thenReturn(Optional.of(entity));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("T");
        request.setBancoCntaId(1L);
        request.setBancoCntaRefId(1L);
        request.setImpTotal(new BigDecimal("500.00"));
        CajaBancosDetalleRequest detalle = new CajaBancosDetalleRequest();
        detalle.setImporte(new BigDecimal("500.00"));
        request.setDetalles(List.of(detalle));

        // Act & Assert
        assertThatThrownBy(() -> service.actualizar(1L, request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("cuenta origen y destino no pueden ser la misma");
    }

    // ==== ejecutar — aplicación de documentos ====

    @Test
    @DisplayName("ejecutar() con tipo A -> ejecuta aplicación de documentos")
    void ejecutar_aplicacion_debeEjecutar() {
        // Arrange
        CajaBancos entityA = new CajaBancos();
        entityA.setId(20L);
        entityA.setSucursalId(1L);
        entityA.setNroRegistro("CB-2026-00020");
        entityA.setFlagTipoTransaccion("A");
        entityA.setBancoCntaId(1L);
        entityA.setMonedaId(1L);
        entityA.setImpTotal(new BigDecimal("1000.00"));
        entityA.setFlagEstado("1");
        entityA.setTasaCambio(BigDecimal.ONE);

        CajaBancosDet detalleA = new CajaBancosDet();
        detalleA.setId(20L);
        detalleA.setItem(1);
        detalleA.setEntidadContribuyenteId(1L);
        detalleA.setDocTipoId(1L);
        detalleA.setNroDoc("APL-001");
        detalleA.setImporte(new BigDecimal("1000.00"));
        detalleA.setCntasPagarId(1L);
        entityA.addDetalle(detalleA);

        when(repository.findById(20L)).thenReturn(Optional.of(entityA));

        GenerarAsientoResponse mockAsiento = new GenerarAsientoResponse();
        mockAsiento.setAsientoId(200L);
        when(contabilidadClient.generarAsientoAplicacionDocumentos(any())).thenReturn(ApiResponse.ok(mockAsiento));

        // Act
        EjecutarMovimientoResponse result = service.ejecutar(20L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(20L);
        assertThat(result.getFechaEjecucion()).isNotNull();
        verify(contabilidadClient).generarAsientoAplicacionDocumentos(any());
        verify(repository).save(any());
    }

    // ==== ejecutar — validaciones de saldo insuficiente ====

    @Test
    @DisplayName("ejecutar() con pago y saldo insuficiente -> lanza BusinessException")
    void ejecutar_pago_saldoInsuficiente_lanzaBusinessException() {
        // Arrange
        BancoCnta cuentaSaldoBajo = new BancoCnta();
        cuentaSaldoBajo.setId(1L);
        cuentaSaldoBajo.setFlagEstado("1");
        cuentaSaldoBajo.setCodigo("001-BAJOSALDO");
        cuentaSaldoBajo.setSaldoDisponible(new BigDecimal("100.00"));
        cuentaSaldoBajo.setPlanContableDetId(2L);

        CajaBancos entityP = new CajaBancos();
        entityP.setId(30L);
        entityP.setSucursalId(1L);
        entityP.setNroRegistro("CB-2026-00030");
        entityP.setFlagTipoTransaccion("P");
        entityP.setBancoCntaId(1L);
        entityP.setMonedaId(1L);
        entityP.setImpTotal(new BigDecimal("5000.00"));
        entityP.setFlagEstado("1");
        entityP.setTasaCambio(BigDecimal.ONE);

        CajaBancosDet detalleP = new CajaBancosDet();
        detalleP.setId(30L);
        detalleP.setItem(1);
        detalleP.setEntidadContribuyenteId(1L);
        detalleP.setDocTipoId(2L);
        detalleP.setNroDoc("PAG-001");
        detalleP.setImporte(new BigDecimal("5000.00"));
        entityP.addDetalle(detalleP);

        when(repository.findById(30L)).thenReturn(Optional.of(entityP));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(cuentaSaldoBajo));

        // Act & Assert
        assertThatThrownBy(() -> service.ejecutar(30L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Saldo insuficiente");
    }

    @Test
    @DisplayName("ejecutar() con transferencia y saldo insuficiente en origen -> lanza BusinessException")
    void ejecutar_transferencia_saldoInsuficiente_lanzaBusinessException() {
        // Arrange
        BancoCnta cuentaOrigenSaldoBajo = new BancoCnta();
        cuentaOrigenSaldoBajo.setId(1L);
        cuentaOrigenSaldoBajo.setFlagEstado("1");
        cuentaOrigenSaldoBajo.setCodigo("001-BAJOSALDO");
        cuentaOrigenSaldoBajo.setSaldoDisponible(new BigDecimal("50.00"));
        cuentaOrigenSaldoBajo.setPlanContableDetId(2L);

        BancoCnta cuentaDestino = new BancoCnta();
        cuentaDestino.setId(2L);
        cuentaDestino.setFlagEstado("1");
        cuentaDestino.setCodigo("002-DESTINO");
        cuentaDestino.setSaldoDisponible(new BigDecimal("10000.00"));
        cuentaDestino.setPlanContableDetId(3L);

        CajaBancos entityT = new CajaBancos();
        entityT.setId(31L);
        entityT.setSucursalId(1L);
        entityT.setNroRegistro("CB-2026-00031");
        entityT.setFlagTipoTransaccion("T");
        entityT.setBancoCntaId(1L);
        entityT.setBancoCntaRefId(2L);
        entityT.setMonedaId(1L);
        entityT.setImpTotal(new BigDecimal("5000.00"));
        entityT.setFlagEstado("1");
        entityT.setTasaCambio(BigDecimal.ONE);

        CajaBancosDet detalleT = new CajaBancosDet();
        detalleT.setId(31L);
        detalleT.setItem(1);
        detalleT.setEntidadContribuyenteId(1L);
        detalleT.setDocTipoId(3L);
        detalleT.setNroDoc("TRF-001");
        detalleT.setImporte(new BigDecimal("5000.00"));
        entityT.addDetalle(detalleT);

        when(repository.findById(31L)).thenReturn(Optional.of(entityT));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(cuentaOrigenSaldoBajo));
        when(bancoCntaRepository.findById(2L)).thenReturn(Optional.of(cuentaDestino));

        // Act & Assert
        assertThatThrownBy(() -> service.ejecutar(31L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Saldo insuficiente");
    }

    // ==== ejecutar — FeignException.Conflict ====

    @Test
    @DisplayName("ejecutar() con cobro y FeignException.Conflict -> lanza BusinessException FIN-ASIENTO_DUPLICADO")
    void ejecutar_cobro_conflictFeignException_lanzaBusinessException() {
        CajaBancos entityC = new CajaBancos();
        entityC.setId(40L);
        entityC.setSucursalId(1L);
        entityC.setNroRegistro("CB-2026-00040");
        entityC.setFlagTipoTransaccion("C");
        entityC.setBancoCntaId(1L);
        entityC.setBancoCntaRefId(null);
        entityC.setMonedaId(1L);
        entityC.setImpTotal(new BigDecimal("1000.00"));
        entityC.setFlagEstado("1");
        entityC.setTasaCambio(BigDecimal.ONE);
        CajaBancosDet det = new CajaBancosDet();
        det.setId(40L);
        det.setItem(1);
        det.setEntidadContribuyenteId(1L);
        det.setDocTipoId(1L);
        det.setNroDoc("F001-000001");
        det.setImporte(new BigDecimal("1000.00"));
        entityC.addDetalle(det);

        when(repository.findById(40L)).thenReturn(Optional.of(entityC));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        FeignException.Conflict ex = mock(FeignException.Conflict.class);
        when(ex.contentUTF8()).thenReturn("{\"message\":\"Asiento duplicado\"}");
        lenient().when(ex.status()).thenReturn(409);
        when(contabilidadClient.generarAsientoCarteraCobros(any())).thenThrow(ex);

        assertThatThrownBy(() -> service.ejecutar(40L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Asiento duplicado");
    }

    // ==== ejecutar — FeignException.UnprocessableEntity ====

    @Test
    @DisplayName("ejecutar() con pago y FeignException.UnprocessableEntity -> lanza BusinessException FIN-ASIENTO_NO_BALANCEADO")
    void ejecutar_pago_unprocessableFeignException_lanzaBusinessException() {
        CajaBancos entityP = new CajaBancos();
        entityP.setId(41L);
        entityP.setSucursalId(1L);
        entityP.setNroRegistro("CB-2026-00041");
        entityP.setFlagTipoTransaccion("P");
        entityP.setBancoCntaId(1L);
        entityP.setMonedaId(1L);
        entityP.setImpTotal(new BigDecimal("1000.00"));
        entityP.setFlagEstado("1");
        entityP.setTasaCambio(BigDecimal.ONE);
        CajaBancosDet det = new CajaBancosDet();
        det.setId(41L);
        det.setItem(1);
        det.setEntidadContribuyenteId(1L);
        det.setDocTipoId(1L);
        det.setNroDoc("P001-000001");
        det.setImporte(new BigDecimal("1000.00"));
        entityP.addDetalle(det);

        when(repository.findById(41L)).thenReturn(Optional.of(entityP));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        FeignException.UnprocessableEntity ex = mock(FeignException.UnprocessableEntity.class);
        when(ex.contentUTF8()).thenReturn("{\"message\":\"Asiento no balanceado\"}");
        lenient().when(ex.status()).thenReturn(422);
        when(contabilidadClient.generarAsientoCarteraPagos(any())).thenThrow(ex);

        assertThatThrownBy(() -> service.ejecutar(41L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Asiento no balanceado");
    }

    // ==== ejecutar — FeignException.NotFound ====

    @Test
    @DisplayName("ejecutar() con transferencia y FeignException.NotFound -> lanza BusinessException FIN-ERROR_CONTABILIDAD")
    void ejecutar_transferencia_notFoundFeignException_lanzaBusinessException() {
        BancoCnta cuentaDestino = new BancoCnta();
        cuentaDestino.setId(2L);
        cuentaDestino.setFlagEstado("1");
        cuentaDestino.setCodigo("002-DESTINO");
        cuentaDestino.setSaldoDisponible(new BigDecimal("50000.00"));
        cuentaDestino.setPlanContableDetId(3L);

        CajaBancos entityT = new CajaBancos();
        entityT.setId(42L);
        entityT.setSucursalId(1L);
        entityT.setNroRegistro("CB-2026-00042");
        entityT.setFlagTipoTransaccion("T");
        entityT.setBancoCntaId(1L);
        entityT.setBancoCntaRefId(2L);
        entityT.setMonedaId(1L);
        entityT.setImpTotal(new BigDecimal("1000.00"));
        entityT.setFlagEstado("1");
        entityT.setTasaCambio(BigDecimal.ONE);
        CajaBancosDet det = new CajaBancosDet();
        det.setId(42L);
        det.setItem(1);
        det.setEntidadContribuyenteId(1L);
        det.setDocTipoId(1L);
        det.setNroDoc("TRF-001");
        det.setImporte(new BigDecimal("1000.00"));
        det.setBancoCntaProvId(2L);
        entityT.addDetalle(det);

        when(repository.findById(42L)).thenReturn(Optional.of(entityT));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));
        when(bancoCntaRepository.findById(2L)).thenReturn(Optional.of(cuentaDestino));

        FeignException.NotFound ex = mock(FeignException.NotFound.class);
        when(ex.contentUTF8()).thenReturn("{\"message\":\"Recurso no encontrado\"}");
        when(contabilidadClient.generarAsientoTransferencias(any())).thenThrow(ex);

        assertThatThrownBy(() -> service.ejecutar(42L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Recurso no encontrado");
    }

    // ==== ejecutar — FeignException.BadRequest ====

    @Test
    @DisplayName("ejecutar() con aplicacion y FeignException.BadRequest -> lanza BusinessException FIN-ERROR_CONTABILIDAD")
    void ejecutar_aplicacion_badRequestFeignException_lanzaBusinessException() {
        CajaBancos entityA = new CajaBancos();
        entityA.setId(43L);
        entityA.setSucursalId(1L);
        entityA.setNroRegistro("CB-2026-00043");
        entityA.setFlagTipoTransaccion("A");
        entityA.setBancoCntaId(1L);
        entityA.setMonedaId(1L);
        entityA.setImpTotal(new BigDecimal("1000.00"));
        entityA.setFlagEstado("1");
        entityA.setTasaCambio(BigDecimal.ONE);
        CajaBancosDet det = new CajaBancosDet();
        det.setId(43L);
        det.setItem(1);
        det.setEntidadContribuyenteId(1L);
        det.setDocTipoId(1L);
        det.setNroDoc("APL-001");
        det.setImporte(new BigDecimal("1000.00"));
        det.setCntasPagarId(1L);
        entityA.addDetalle(det);

        when(repository.findById(43L)).thenReturn(Optional.of(entityA));

        FeignException.BadRequest ex = mock(FeignException.BadRequest.class);
        when(ex.contentUTF8()).thenReturn("{\"message\":\"Solicitud inválida\"}");
        when(contabilidadClient.generarAsientoAplicacionDocumentos(any())).thenThrow(ex);

        assertThatThrownBy(() -> service.ejecutar(43L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Solicitud inválida");
    }

    // ==== ejecutar — FeignException generica ====

    @Test
    @DisplayName("ejecutar() con cobro y FeignException generica -> lanza BusinessException FIN-ERROR_CONTABILIDAD")
    void ejecutar_cobro_genericFeignException_lanzaBusinessException() {
        CajaBancos entityC = new CajaBancos();
        entityC.setId(44L);
        entityC.setSucursalId(1L);
        entityC.setNroRegistro("CB-2026-00044");
        entityC.setFlagTipoTransaccion("C");
        entityC.setBancoCntaId(1L);
        entityC.setMonedaId(1L);
        entityC.setImpTotal(new BigDecimal("1000.00"));
        entityC.setFlagEstado("1");
        entityC.setTasaCambio(BigDecimal.ONE);
        CajaBancosDet det = new CajaBancosDet();
        det.setId(44L);
        det.setItem(1);
        det.setEntidadContribuyenteId(1L);
        det.setDocTipoId(1L);
        det.setNroDoc("F001-000001");
        det.setImporte(new BigDecimal("1000.00"));
        entityC.addDetalle(det);

        when(repository.findById(44L)).thenReturn(Optional.of(entityC));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        FeignException ex = mock(FeignException.class);
        when(ex.contentUTF8()).thenReturn("{\"message\":\"Error de red\"}");
        lenient().when(ex.status()).thenReturn(500);
        when(contabilidadClient.generarAsientoCarteraCobros(any())).thenThrow(ex);

        assertThatThrownBy(() -> service.ejecutar(44L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Error de red");
    }

    // ==== ejecutar — compensacion por error en save ====

    @Test
    @DisplayName("ejecutar() con cobro y error en save despues de asiento -> compensa anulando asiento")
    void ejecutar_cobro_errorSave_compensaAnulando() {
        CajaBancos entityC = new CajaBancos();
        entityC.setId(45L);
        entityC.setSucursalId(1L);
        entityC.setNroRegistro("CB-2026-00045");
        entityC.setFlagTipoTransaccion("C");
        entityC.setBancoCntaId(1L);
        entityC.setMonedaId(1L);
        entityC.setImpTotal(new BigDecimal("1000.00"));
        entityC.setFlagEstado("1");
        entityC.setTasaCambio(BigDecimal.ONE);
        CajaBancosDet det = new CajaBancosDet();
        det.setId(45L);
        det.setItem(1);
        det.setEntidadContribuyenteId(1L);
        det.setDocTipoId(1L);
        det.setNroDoc("F001-000001");
        det.setImporte(new BigDecimal("1000.00"));
        entityC.addDetalle(det);

        GenerarAsientoResponse mockAsiento = new GenerarAsientoResponse();
        mockAsiento.setAsientoId(500L);

        when(repository.findById(45L)).thenReturn(Optional.of(entityC));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));
        when(contabilidadClient.generarAsientoCarteraCobros(any())).thenReturn(ApiResponse.ok(mockAsiento));
        when(repository.save(any())).thenThrow(new RuntimeException("Error al guardar"));

        RuntimeException ex = null;
        try {
            service.ejecutar(45L);
        } catch (RuntimeException e) {
            ex = e;
        }

        assertThat(ex).isNotNull();
        assertThat(ex.getMessage()).contains("Error al guardar");
        verify(contabilidadClient).anularAsiento(500L);
    }

    // ==== enriquecerConDatosMaestros — null moneda y entidad ====

    @Test
    @DisplayName("listar() con enriquecimiento y moneda/entidad nulos -> no lanza excepcion")
    void listar_conEnriquecimientoDatosNulos_noLanzaExcepcion() {
        response.setBancoCntaId(1L);
        response.setMonedaId(1L);
        response.setEntidadContribuyenteId(1L);
        Page<CajaBancos> page = new PageImpl<>(List.of(entity));
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));
        when(coreMaestrosClient.obtenerMonedaPorId(1L)).thenReturn(ApiResponse.ok(null));
        when(coreMaestrosClient.obtenerEntidadPorId(1L)).thenReturn(ApiResponse.ok(null));

        Page<CajaBancosResponse> result = service.listar(null, null, null, null, null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
    }

    // ==== construirReferenciaAplicacion — cntasCobrarId ====

    @Test
    @DisplayName("ejecutar() con aplicacion y cntasCobrarId -> ejecuta correctamente")
    void ejecutar_aplicacion_cntasCobrarId_ejecutaCorrectamente() {
        CajaBancos entityA = new CajaBancos();
        entityA.setId(46L);
        entityA.setSucursalId(1L);
        entityA.setNroRegistro("CB-2026-00046");
        entityA.setFlagTipoTransaccion("A");
        entityA.setBancoCntaId(1L);
        entityA.setMonedaId(1L);
        entityA.setImpTotal(new BigDecimal("1000.00"));
        entityA.setFlagEstado("1");
        entityA.setTasaCambio(BigDecimal.ONE);
        CajaBancosDet det = new CajaBancosDet();
        det.setId(46L);
        det.setItem(1);
        det.setEntidadContribuyenteId(1L);
        det.setDocTipoId(1L);
        det.setNroDoc("CXC-001");
        det.setImporte(new BigDecimal("1000.00"));
        det.setCntasCobrarId(1L);
        entityA.addDetalle(det);

        GenerarAsientoResponse mockAsiento = new GenerarAsientoResponse();
        mockAsiento.setAsientoId(600L);

        when(repository.findById(46L)).thenReturn(Optional.of(entityA));
        when(contabilidadClient.generarAsientoAplicacionDocumentos(any())).thenReturn(ApiResponse.ok(mockAsiento));

        EjecutarMovimientoResponse result = service.ejecutar(46L);

        assertThat(result).isNotNull();
        assertThat(result.getId()).isEqualTo(46L);
        verify(contabilidadClient).generarAsientoAplicacionDocumentos(any());
    }

    @Test
    @DisplayName("ejecutar() con aplicacion sin cntasPagarId ni cntasCobrarId -> lanza BusinessException")
    void ejecutar_aplicacion_sinCxNiCxC_lanzaBusinessException() {
        CajaBancos entityA = new CajaBancos();
        entityA.setId(47L);
        entityA.setSucursalId(1L);
        entityA.setNroRegistro("CB-2026-00047");
        entityA.setFlagTipoTransaccion("A");
        entityA.setBancoCntaId(1L);
        entityA.setMonedaId(1L);
        entityA.setImpTotal(new BigDecimal("1000.00"));
        entityA.setFlagEstado("1");
        entityA.setTasaCambio(BigDecimal.ONE);
        CajaBancosDet det = new CajaBancosDet();
        det.setId(47L);
        det.setItem(1);
        det.setEntidadContribuyenteId(1L);
        det.setDocTipoId(1L);
        det.setNroDoc("NO-REF");
        det.setImporte(new BigDecimal("1000.00"));
        entityA.addDetalle(det);

        when(repository.findById(47L)).thenReturn(Optional.of(entityA));

        assertThatThrownBy(() -> service.ejecutar(47L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("debe tener cuenta por pagar o cuenta por cobrar");
    }

    // ==== validarPeriodo — tipo transaccion invalido ====

    @Test
    @DisplayName("ejecutar() con tipo de transaccion invalido -> lanza BusinessException")
    void ejecutar_tipoTransaccionInvalido_lanzaBusinessException() {
        CajaBancos entityX = new CajaBancos();
        entityX.setId(48L);
        entityX.setSucursalId(1L);
        entityX.setNroRegistro("CB-2026-00048");
        entityX.setFlagTipoTransaccion("X");
        entityX.setBancoCntaId(1L);
        entityX.setMonedaId(1L);
        entityX.setImpTotal(new BigDecimal("1000.00"));
        entityX.setFlagEstado("1");

        when(repository.findById(48L)).thenReturn(Optional.of(entityX));

        assertThatThrownBy(() -> service.ejecutar(48L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Tipo de transacción no válido");
    }

    // ==== requerirPlanContableDetId — null ====

    @Test
    @DisplayName("ejecutar() con transferencia y planContableDetId null -> lanza BusinessException")
    void ejecutar_transferencia_sinPlanContableDetId_lanzaBusinessException() {
        BancoCnta cuentaSinPlan = new BancoCnta();
        cuentaSinPlan.setId(2L);
        cuentaSinPlan.setFlagEstado("1");
        cuentaSinPlan.setCodigo("002-SINPLAN");
        cuentaSinPlan.setSaldoDisponible(new BigDecimal("50000.00"));

        CajaBancos entityT = new CajaBancos();
        entityT.setId(49L);
        entityT.setSucursalId(1L);
        entityT.setNroRegistro("CB-2026-00049");
        entityT.setFlagTipoTransaccion("T");
        entityT.setBancoCntaId(1L);
        entityT.setBancoCntaRefId(2L);
        entityT.setMonedaId(1L);
        entityT.setImpTotal(new BigDecimal("1000.00"));
        entityT.setFlagEstado("1");
        entityT.setTasaCambio(BigDecimal.ONE);
        CajaBancosDet det = new CajaBancosDet();
        det.setId(49L);
        det.setItem(1);
        det.setImporte(new BigDecimal("1000.00"));
        det.setBancoCntaProvId(2L);
        entityT.addDetalle(det);

        when(repository.findById(49L)).thenReturn(Optional.of(entityT));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));
        when(bancoCntaRepository.findById(2L)).thenReturn(Optional.of(cuentaSinPlan));

        assertThatThrownBy(() -> service.ejecutar(49L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("no tiene cuenta contable");
    }

    // ==== extraerMensajeDeError — response body vacio ====

    @Test
    @DisplayName("ejecutar() con FeignException y response body vacio -> lanza BusinessException con mensaje generico")
    void ejecutar_pago_feignExceptionResponseVacio_lanzaBusinessException() {
        CajaBancos entityP = new CajaBancos();
        entityP.setId(50L);
        entityP.setSucursalId(1L);
        entityP.setNroRegistro("CB-2026-00050");
        entityP.setFlagTipoTransaccion("P");
        entityP.setBancoCntaId(1L);
        entityP.setMonedaId(1L);
        entityP.setImpTotal(new BigDecimal("1000.00"));
        entityP.setFlagEstado("1");
        entityP.setTasaCambio(BigDecimal.ONE);
        CajaBancosDet det = new CajaBancosDet();
        det.setId(50L);
        det.setItem(1);
        det.setEntidadContribuyenteId(1L);
        det.setDocTipoId(1L);
        det.setNroDoc("P001-000001");
        det.setImporte(new BigDecimal("1000.00"));
        entityP.addDetalle(det);

        when(repository.findById(50L)).thenReturn(Optional.of(entityP));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        FeignException.BadRequest ex = mock(FeignException.BadRequest.class);
        when(ex.contentUTF8()).thenReturn("");
        lenient().when(ex.status()).thenReturn(400);
        when(contabilidadClient.generarAsientoCarteraPagos(any())).thenThrow(ex);

        assertThatThrownBy(() -> service.ejecutar(50L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Error al generar el asiento");
    }

    @Test
    @DisplayName("ejecutar() con FeignException sin campo message en JSON -> lanza BusinessException con mensaje generico")
    void ejecutar_pago_feignExceptionSinCampoMessage_lanzaBusinessException() {
        CajaBancos entityP = new CajaBancos();
        entityP.setId(51L);
        entityP.setSucursalId(1L);
        entityP.setNroRegistro("CB-2026-00051");
        entityP.setFlagTipoTransaccion("P");
        entityP.setBancoCntaId(1L);
        entityP.setMonedaId(1L);
        entityP.setImpTotal(new BigDecimal("1000.00"));
        entityP.setFlagEstado("1");
        entityP.setTasaCambio(BigDecimal.ONE);
        CajaBancosDet det = new CajaBancosDet();
        det.setId(51L);
        det.setItem(1);
        det.setEntidadContribuyenteId(1L);
        det.setDocTipoId(1L);
        det.setNroDoc("P001-000001");
        det.setImporte(new BigDecimal("1000.00"));
        entityP.addDetalle(det);

        when(repository.findById(51L)).thenReturn(Optional.of(entityP));
        when(bancoCntaRepository.findById(1L)).thenReturn(Optional.of(bancoCnta));

        FeignException.BadRequest ex = mock(FeignException.BadRequest.class);
        when(ex.contentUTF8()).thenReturn("{\"error\":\"Invalid\"}");
        lenient().when(ex.status()).thenReturn(400);
        when(contabilidadClient.generarAsientoCarteraPagos(any())).thenThrow(ex);

        assertThatThrownBy(() -> service.ejecutar(51L))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Error al generar el asiento");
    }

    // ==== enriquecerConDatosMaestros — response null ====

    @Test
    @DisplayName("listar() con bancoCntaId que falla al buscar -> no lanza excepcion")
    void listar_conErrorAlBuscarBancoCnta_noLanzaExcepcion() {
        response.setBancoCntaId(1L);
        Page<CajaBancos> page = new PageImpl<>(List.of(entity));
        when(repository.findAll(any(org.springframework.data.jpa.domain.Specification.class), any(PageRequest.class))).thenReturn(page);
        when(mapper.toResponse(any())).thenReturn(response);
        when(bancoCntaRepository.findById(1L)).thenThrow(new RuntimeException("DB error"));

        Page<CajaBancosResponse> result = service.listar(null, null, null, null, null, null, PageRequest.of(0, 10));

        assertThat(result).isNotNull();
    }

    // ==== ejecutar — default switch en crearAsientoContable ====

    @Test
    @DisplayName("crear() con transferencia y tipo invalido en generar asiento -> lanza BusinessException")
    void crear_transferencia_conTipoGenerarAsientoInvalido_lanzaBusinessException() {
        CajaBancosRequest request = new CajaBancosRequest();
        request.setFlagTipoTransaccion("X");
        request.setBancoCntaId(1L);
        request.setImpTotal(new BigDecimal("1000.00"));
        CajaBancosDetalleRequest det = new CajaBancosDetalleRequest();
        det.setImporte(new BigDecimal("1000.00"));
        request.setDetalles(List.of(det));

        assertThatThrownBy(() -> service.crear(request))
            .isInstanceOf(BusinessException.class)
            .hasMessageContaining("Tipo de transacción no válido");
    }
}
