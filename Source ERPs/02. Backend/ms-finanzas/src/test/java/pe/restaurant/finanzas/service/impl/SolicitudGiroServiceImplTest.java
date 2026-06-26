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
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.finanzas.dto.request.SolicitudGiroRequest;
import pe.restaurant.finanzas.dto.response.SolicitudGiroDetalleResponse;
import pe.restaurant.finanzas.dto.response.SolicitudGiroResponse;
import pe.restaurant.finanzas.entity.SolicitudGiro;
import pe.restaurant.finanzas.constants.SolicitudGiroConstants;
import pe.restaurant.finanzas.mapper.SolicitudGiroMapper;
import pe.restaurant.finanzas.repository.LiquidacionRepository;
import pe.restaurant.finanzas.repository.SolicitudGiroRepository;
import pe.restaurant.finanzas.service.FinanzasErrorCodes;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.repository.CntasPagarRepository;
import pe.restaurant.finanzas.repository.LiquidacionDetRepository;
import pe.restaurant.common.service.NumeradorDocumentoService;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.finanzas.dto.request.AprobarSolicitudRequest;
import pe.restaurant.finanzas.dto.request.DevolucionTotalRequest;
import pe.restaurant.finanzas.dto.request.RechazarSolicitudRequest;
import pe.restaurant.finanzas.dto.request.RechazoDevolucionTotalRequest;
import pe.restaurant.finanzas.dto.response.EntidadContribuyenteResponse;
import pe.restaurant.finanzas.dto.response.SolicitudPendienteAprobacionResponse;
import pe.restaurant.finanzas.testutil.TestDataFactory;
import pe.restaurant.common.security.TenantContext;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Tests de SolicitudGiroServiceImpl")
class SolicitudGiroServiceImplTest {

    @Mock
    private SolicitudGiroRepository repository;

    @Mock
    private LiquidacionRepository liquidacionRepository;

    @Mock
    private LiquidacionDetRepository liquidacionDetRepository;

    @Mock
    private CntasPagarRepository cntasPagarRepository;

    @Mock
    private SolicitudGiroMapper mapper;

    @Mock
    private NumeradorDocumentoService numeradorDocumentoService;

    @Mock
    private CoreMaestrosClient coreMaestrosClient;

    @InjectMocks
    private SolicitudGiroServiceImpl service;

    private SolicitudGiro solicitud;
    private SolicitudGiroRequest request;

    @BeforeEach
    void setUp() {
        solicitud = new SolicitudGiro();
        solicitud.setId(1L);
        solicitud.setSolicitanteId(456L);
        solicitud.setNumero("SG-20260429-0001");
        solicitud.setFecha(LocalDate.of(2026, 4, 29));
        solicitud.setMonto(BigDecimal.valueOf(5000.00));
        solicitud.setMotivo("Adelanto para compra de materiales");
        solicitud.setFlagEstado("3");
        solicitud.setTipoSolicitud(SolicitudGiroConstants.TIPO_ORDEN_GIRO);
        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_PENDIENTE);

        request = new SolicitudGiroRequest();
        request.setSolicitanteId(456L);
        request.setFecha(LocalDate.of(2026, 4, 29));
        request.setMonto(BigDecimal.valueOf(5000.00));
        request.setMotivo("Adelanto para compra de materiales");
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("Debe listar solicitudes paginadas")
    void listar_retornaPagina() {
        // Arrange
        Pageable pageable = PageRequest.of(0, 10);
        Page<SolicitudGiro> page = new PageImpl<>(List.of(solicitud), pageable, 1);
        
        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any(SolicitudGiro.class))).thenReturn(new SolicitudGiroResponse());

        // Act
        Page<SolicitudGiroResponse> result = service.listarSolicitudes(
            null, null, null, pageable);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        assertThat(result.getContent().size()).isEqualTo(1);
        
        verify(repository).findAll(any(Specification.class), eq(pageable));
        verify(mapper, atLeastOnce()).toResponse(any(SolicitudGiro.class));
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("Debe obtener solicitud por ID existente")
    void obtenerPorId_cuandoExiste_retornaSolicitud() {
        // Arrange
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));
        when(mapper.toDetalleResponse(solicitud)).thenReturn(new SolicitudGiroDetalleResponse());

        // Act
        SolicitudGiroDetalleResponse result = service.obtenerPorId(1L);

        // Assert
        assertThat(result).isNotNull();
        
        verify(repository).findById(1L);
        verify(mapper).toDetalleResponse(solicitud);
    }


    // ==== obtenerPorId — otros ====

    @Test
    @DisplayName("Debe lanzar ResourceNotFoundException cuando solicitud no existe")
    void obtenerPorId_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(repository.findById(999L)).thenReturn(Optional.empty());

        // Act & Then
        assertThatThrownBy(() -> service.obtenerPorId(999L)).isInstanceOf(ResourceNotFoundException.class);
        
        verify(repository).findById(999L);
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("Debe crear solicitud con éxito")
    void crear_conDatosValidos_creaSolicitud() {
        // Arrange
        request.setSucursalId(1L);
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt()))
            .thenReturn("SG-20260429-0001");
        EntidadContribuyenteResponse entidadResponse = new EntidadContribuyenteResponse();
        when(mapper.toEntity(request)).thenReturn(solicitud);
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);
        when(mapper.toDetalleResponse(solicitud)).thenReturn(new SolicitudGiroDetalleResponse());

        // Act
        SolicitudGiroDetalleResponse result = service.crearSolicitud(request);

        // Assert
        assertThat(result).isNotNull();
        
        verify(numeradorDocumentoService).siguienteNroDocumento(anyString(), anyLong(), anyInt());
        verify(repository).save(any(SolicitudGiro.class));
    }


    // ==== crear — otros ====

    @Test
    @DisplayName("Debe lanzar BusinessException cuando monto es cero")
    void crear_conDatosValidos_creaSolicitudMontoInvalido() {
        // Arrange
        request.setMonto(BigDecimal.ZERO);

        // Act & Then
        assertThatThrownBy(() -> service.crearSolicitud(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(FinanzasErrorCodes.SOLICITUD_MONTO_INVALIDO);
                    assertThat(ex.getMessage()).isEqualTo("El monto debe ser mayor a cero");
                });
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("Debe actualizar solicitud con éxito")
    void actualizar_conDatosValidos_actualizaSolicitud() {
        // Arrange
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);
        when(mapper.toDetalleResponse(solicitud)).thenReturn(new SolicitudGiroDetalleResponse());

        // Act
        SolicitudGiroDetalleResponse result = service.actualizarSolicitud(1L, request);

        // Assert
        assertThat(result).isNotNull();
        
        verify(repository).findById(1L);
        verify(repository).save(any(SolicitudGiro.class));
    }

    @Test
    @DisplayName("Debe lanzar BusinessException al actualizar solicitud en estado no editable")
    void actualizar_conDatosValidos_actualizaSolicitudEstadoNoEditable() {
        // Arrange
        solicitud.setFlagEstado("0");
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Then
        assertThatThrownBy(() -> service.actualizarSolicitud(1L, request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(FinanzasErrorCodes.SOLICITUD_NO_EDITABLE);
                    assertThat(ex.getMessage()).isEqualTo("No se puede modificar: solicitud no está pendiente de aprobación");
                });
    }


    // ==== anular — escenarios felices ====

    @Test
    @DisplayName("Debe anular solicitud con éxito")
    void anular_conEstadoValido_anulaSolicitud() {
        // Arrange
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);

        // Act
        Map<String, Object> result = service.anularSolicitud(1L);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.get("flagEstado")).isEqualTo("0");
        
        verify(repository).findById(1L);
        verify(repository).save(any(SolicitudGiro.class));
    }

    @Test
    @DisplayName("Debe lanzar BusinessException al anular solicitud en estado no anulable")
    void anular_conEstadoValido_anulaSolicitudEstadoNoAnulable() {
        // Arrange
        solicitud.setFlagEstado("1");
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Then
        assertThatThrownBy(() -> service.anularSolicitud(1L))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode()).isEqualTo(FinanzasErrorCodes.SOLICITUD_NO_ANULABLE);
                    assertThat(ex.getMessage()).isEqualTo("No se puede anular: solicitud ya aprobada");
                });
    }


    // ==== listarPendientesAprobacion — escenarios felices ====

    @Test
    @DisplayName("Debe listar solicitudes pendientes de aprobación")
    void listarPendientesAprobacion_retornaLista() {
        Pageable pageable = PageRequest.of(0, 10);
        Page<SolicitudGiro> page = new PageImpl<>(List.of(solicitud), pageable, 1);

        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(page);

        Page<SolicitudPendienteAprobacionResponse> result = service.listarPendientesAprobacion(pageable);

        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }


    // ==== aprobar — otros ====

    @Test
    @DisplayName("Debe aprobar solicitud con éxito")
    void aprobar_conEstadoPendiente_apruebaSolicitud() {
        AprobarSolicitudRequest aprobarRequest = new AprobarSolicitudRequest();
        aprobarRequest.setObservacion("Aprobado conforme");

        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_PENDIENTE);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);
        when(mapper.toDetalleResponse(solicitud)).thenReturn(new SolicitudGiroDetalleResponse());

        SolicitudGiroDetalleResponse result = service.aprobarSolicitud(1L, aprobarRequest);

        assertThat(result).isNotNull();
        assertThat(solicitud.getFlagEstado()).isEqualTo(SolicitudGiroConstants.FLAG_APROBADA);
    }

    @Test
    @DisplayName("Debe lanzar excepción al aprobar solicitud ya procesada")
    void aprobar_conEstadoPendiente_apruebaSolicitudEstadoNoPendiente() {
        AprobarSolicitudRequest aprobarRequest = new AprobarSolicitudRequest();

        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_APROBADA);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        assertThatThrownBy(() -> service.aprobarSolicitud(1L, aprobarRequest)).isInstanceOf(BusinessException.class);
    }


    // ==== rechazar — escenarios felices ====

    @Test
    @DisplayName("Debe rechazar solicitud con éxito")
    void rechazar_conEstadoValido_rechazaSolicitud() {
        RechazarSolicitudRequest rechazarRequest = new RechazarSolicitudRequest();
        rechazarRequest.setObservacion("Falta documentación");

        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_PENDIENTE);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);

        Map<String, Object> result = service.rechazarSolicitud(1L, rechazarRequest);

        assertThat(result).isNotNull();
        assertThat(solicitud.getFlagEstado()).isEqualTo(SolicitudGiroConstants.FLAG_ANULADA);
        assertThat(solicitud.getMotivoRechazo()).isEqualTo("Falta documentación");
    }


    // ==== registrarDevolucionTotal — escenarios felices ====

    @Test
    @DisplayName("Debe registrar devolución total de solicitud aprobada")
    void registrarDevolucionTotal_conDatosValidos_registraDevolucion() {
        DevolucionTotalRequest devolucionRequest = new DevolucionTotalRequest();
        devolucionRequest.setMotivoDevolucion("Producto defectuoso");

        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_APROBADA);
        solicitud.setMotivoDevolucion(null);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);
        when(mapper.toDetalleResponse(solicitud)).thenReturn(new SolicitudGiroDetalleResponse());

        SolicitudGiroDetalleResponse result = service.registrarDevolucionTotal(1L, devolucionRequest);

        assertThat(result).isNotNull();
        assertThat(solicitud.getMotivoDevolucion()).isEqualTo("Producto defectuoso");
    }


    // ==== aprobarDevolucionTotal — escenarios felices ====

    @Test
    @DisplayName("Debe aprobar devolución total")
    void aprobarDevolucionTotal_conEstadoValido_apruebaDevolucion() {
        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_APROBADA);
        solicitud.setMotivoDevolucion("Producto defectuoso");
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);
        when(mapper.toDetalleResponse(solicitud)).thenReturn(new SolicitudGiroDetalleResponse());

        SolicitudGiroDetalleResponse result = service.aprobarDevolucionTotal(1L);

        assertThat(result).isNotNull();
    }


    // ==== rechazarDevolucionTotal — escenarios felices ====

    @Test
    @DisplayName("Debe rechazar devolución total")
    void rechazarDevolucionTotal_conEstadoValido_rechazaDevolucion() {
        RechazoDevolucionTotalRequest rechazoRequest = new RechazoDevolucionTotalRequest();
        rechazoRequest.setMotivoRechazo("Devolución no procede");

        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_APROBADA);
        solicitud.setMotivoDevolucion("Producto defectuoso");
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);
        when(mapper.toDetalleResponse(solicitud)).thenReturn(new SolicitudGiroDetalleResponse());

        SolicitudGiroDetalleResponse result = service.rechazarDevolucionTotal(1L, rechazoRequest);

        assertThat(result).isNotNull();
    }


    // ==== listar — con filtros de fecha ====

    @Test
    @DisplayName("Debe listar solicitudes con filtro de fecha desde y fecha hasta")
    void listar_conFiltrosFechaDesdeYHasta_aplicaFiltros() {
        // Arrange
        Pageable pageable = PageRequest.of(0, 10);
        Page<SolicitudGiro> page = new PageImpl<>(List.of(solicitud), pageable, 1);
        LocalDate fechaDesde = LocalDate.of(2026, 1, 1);
        LocalDate fechaHasta = LocalDate.of(2026, 12, 31);

        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any(SolicitudGiro.class))).thenReturn(new SolicitudGiroResponse());

        // Act
        Page<SolicitudGiroResponse> result = service.listarSolicitudes(
            fechaDesde, fechaHasta, null, pageable);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }


    // ==== listar — filtro estado blank ====

    @Test
    @DisplayName("Debe ignorar filtro de estado cuando es blank")
    void listar_conEstadoBlank_noAplicaFiltroEstado() {
        // Arrange
        Pageable pageable = PageRequest.of(0, 10);
        Page<SolicitudGiro> page = new PageImpl<>(List.of(solicitud), pageable, 1);

        when(repository.findAll(any(Specification.class), eq(pageable))).thenReturn(page);
        when(mapper.toResponse(any(SolicitudGiro.class))).thenReturn(new SolicitudGiroResponse());

        // Act
        Page<SolicitudGiroResponse> result = service.listarSolicitudes(
            null, null, "", pageable);

        // Assert
        assertThat(result).isNotNull();
        assertThat(result.getTotalElements()).isEqualTo(1);
        verify(repository).findAll(any(Specification.class), eq(pageable));
    }


    // ==== crear — tipo solicitud default ====

    @Test
    @DisplayName("Debe asignar tipo de solicitud por defecto cuando viene null")
    void crear_conTipoSolicitudNull_asignaDefault() {
        // Arrange
        request.setSucursalId(1L);
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt()))
            .thenReturn("SG-20260429-0001");
        when(mapper.toEntity(request)).thenReturn(solicitud);
        solicitud.setTipoSolicitud(null);
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);
        when(mapper.toDetalleResponse(solicitud)).thenReturn(new SolicitudGiroDetalleResponse());

        // Act
        SolicitudGiroDetalleResponse result = service.crearSolicitud(request);

        // Assert
        assertThat(result).isNotNull();
        assertThat(solicitud.getTipoSolicitud()).isEqualTo(SolicitudGiroConstants.TIPO_ORDEN_GIRO);
        verify(repository).save(any(SolicitudGiro.class));
    }

    @Test
    @DisplayName("Debe asignar tipo de solicitud por defecto cuando viene blank")
    void crear_conTipoSolicitudBlank_asignaDefault() {
        // Arrange
        request.setSucursalId(1L);
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt()))
            .thenReturn("SG-20260429-0001");
        when(mapper.toEntity(request)).thenReturn(solicitud);
        solicitud.setTipoSolicitud("");
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);
        when(mapper.toDetalleResponse(solicitud)).thenReturn(new SolicitudGiroDetalleResponse());

        // Act
        SolicitudGiroDetalleResponse result = service.crearSolicitud(request);

        // Assert
        assertThat(result).isNotNull();
        assertThat(solicitud.getTipoSolicitud()).isEqualTo(SolicitudGiroConstants.TIPO_ORDEN_GIRO);
        verify(repository).save(any(SolicitudGiro.class));
    }


    // ==== crear — solicitanteId null → TenantContext ====

    @Test
    @DisplayName("Debe usar TenantContext cuando solicitanteId es null")
    void crear_conSolicitanteIdNull_usaTenantContext() {
        // Arrange
        request.setSolicitanteId(null);
        request.setSucursalId(1L);
        when(numeradorDocumentoService.siguienteNroDocumento(anyString(), anyLong(), anyInt()))
            .thenReturn("SG-20260429-0001");
        when(mapper.toEntity(request)).thenReturn(solicitud);
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);
        when(mapper.toDetalleResponse(solicitud)).thenReturn(new SolicitudGiroDetalleResponse());
        TenantContext.setUsuarioId(1L);

        // Act
        try {
            SolicitudGiroDetalleResponse result = service.crearSolicitud(request);

            // Assert
            assertThat(result).isNotNull();
            assertThat(solicitud.getCreatedBy()).isEqualTo(1L);
            verify(repository).save(any(SolicitudGiro.class));
        } finally {
            TenantContext.clear();
        }
    }


    // ==== crear — monto null ====

    @Test
    @DisplayName("Debe lanzar BusinessException cuando monto es null")
    void crear_conMontoNull_lanzaBusinessException() {
        // Arrange
        request.setMonto(null);

        // Act & Assert
        assertThatThrownBy(() -> service.crearSolicitud(request))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode())
                        .isEqualTo(FinanzasErrorCodes.SOLICITUD_MONTO_INVALIDO);
                    assertThat(ex.getMessage()).isEqualTo("El monto debe ser mayor a cero");
                });
    }


    // ==== actualizar — edge cases ====

    @Test
    @DisplayName("Debe lanzar ResourceNotFoundException al actualizar solicitud inexistente")
    void actualizar_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(repository.findById(999L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThatThrownBy(() -> service.actualizarSolicitud(999L, request))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }

    @Test
    @DisplayName("Debe actualizar tipo de solicitud cuando viene en el request")
    void actualizar_conTipoSolicitudEnRequest_actualizaTipo() {
        // Arrange
        solicitud.setTipoSolicitud(SolicitudGiroConstants.TIPO_ORDEN_GIRO);
        request.setTipoSolicitud(SolicitudGiroConstants.TIPO_FONDO_FIJO);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));
        when(repository.save(any(SolicitudGiro.class))).thenReturn(solicitud);
        when(mapper.toDetalleResponse(solicitud)).thenReturn(new SolicitudGiroDetalleResponse());

        // Act
        SolicitudGiroDetalleResponse result = service.actualizarSolicitud(1L, request);

        // Assert
        assertThat(result).isNotNull();
        assertThat(solicitud.getTipoSolicitud()).isEqualTo(SolicitudGiroConstants.TIPO_FONDO_FIJO);
        verify(repository).save(any(SolicitudGiro.class));
    }


    // ==== anular — ya anulada ====

    @Test
    @DisplayName("Debe lanzar BusinessException al anular solicitud ya anulada")
    void anular_conEstadoYaAnulada_lanzaBusinessException() {
        // Arrange
        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_ANULADA);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Assert
        assertThatThrownBy(() -> service.anularSolicitud(1L))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode())
                        .isEqualTo(FinanzasErrorCodes.SOLICITUD_NO_ANULABLE);
                    assertThat(ex.getMessage()).isEqualTo("Solicitud ya anulada");
                });
    }


    // ==== rechazar — estado no pendiente ====

    @Test
    @DisplayName("Debe lanzar excepción al rechazar solicitud no pendiente")
    void rechazar_conEstadoNoPendiente_lanzaBusinessException() {
        // Arrange
        RechazarSolicitudRequest rechazarRequest = new RechazarSolicitudRequest();
        rechazarRequest.setObservacion("Falta documentación");
        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_APROBADA);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Assert
        assertThatThrownBy(() -> service.rechazarSolicitud(1L, rechazarRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode())
                        .isEqualTo(FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO);
                });
    }


    // ==== registrarDevolucionTotal — edge cases ====

    @Test
    @DisplayName("Debe lanzar excepción al registrar devolución en solicitud no aprobada")
    void registrarDevolucionTotal_conEstadoNoAprobada_lanzaBusinessException() {
        // Arrange
        DevolucionTotalRequest devolucionRequest = new DevolucionTotalRequest();
        devolucionRequest.setMotivoDevolucion("Producto defectuoso");
        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_PENDIENTE);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Assert
        assertThatThrownBy(() -> service.registrarDevolucionTotal(1L, devolucionRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(((BusinessException) ex).getErrorCode())
                        .isEqualTo(FinanzasErrorCodes.SOLICITUD_ESTADO_INVALIDO);
                    assertThat(ex.getMessage())
                        .isEqualTo("Solo se puede registrar devolución total en solicitudes aprobadas");
                });
    }

    @Test
    @DisplayName("Debe lanzar excepción cuando ya existe devolución registrada")
    void registrarDevolucionTotal_conDevolucionYaRegistrada_lanzaBusinessException() {
        // Arrange
        DevolucionTotalRequest devolucionRequest = new DevolucionTotalRequest();
        devolucionRequest.setMotivoDevolucion("Nuevo motivo");
        solicitud.setFlagEstado(SolicitudGiroConstants.FLAG_APROBADA);
        solicitud.setMotivoDevolucion("Motivo anterior");
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Assert
        assertThatThrownBy(() -> service.registrarDevolucionTotal(1L, devolucionRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(ex.getMessage())
                        .isEqualTo("La solicitud ya tiene una devolución registrada");
                });
    }


    // ==== aprobarDevolucionTotal — edge cases ====

    @Test
    @DisplayName("Debe lanzar excepción al aprobar devolución sin motivo registrado (null)")
    void aprobarDevolucionTotal_sinMotivoDevolucion_lanzaBusinessException() {
        // Arrange
        solicitud.setMotivoDevolucion(null);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Assert
        assertThatThrownBy(() -> service.aprobarDevolucionTotal(1L))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(ex.getMessage())
                        .isEqualTo("No existe motivo de devolución registrado");
                });
    }

    @Test
    @DisplayName("Debe lanzar excepción al aprobar devolución con motivo blank")
    void aprobarDevolucionTotal_conMotivoDevolucionBlank_lanzaBusinessException() {
        // Arrange
        solicitud.setMotivoDevolucion("   ");
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Assert
        assertThatThrownBy(() -> service.aprobarDevolucionTotal(1L))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(ex.getMessage())
                        .isEqualTo("No existe motivo de devolución registrado");
                });
    }

    @Test
    @DisplayName("Debe lanzar excepción cuando la devolución ya fue procesada")
    void aprobarDevolucionTotal_conDevolucionYaProcesada_lanzaBusinessException() {
        // Arrange
        solicitud.setMotivoDevolucion("Producto defectuoso");
        solicitud.setFlagEstadoDevolucion(SolicitudGiroConstants.DEVOLUCION_APROBADA);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Assert
        assertThatThrownBy(() -> service.aprobarDevolucionTotal(1L))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(ex.getMessage())
                        .isEqualTo("La devolución ya fue procesada");
                });
    }


    // ==== rechazarDevolucionTotal — edge cases ====

    @Test
    @DisplayName("Debe lanzar excepción al rechazar devolución sin motivo (null)")
    void rechazarDevolucionTotal_sinMotivoDevolucion_lanzaBusinessException() {
        // Arrange
        RechazoDevolucionTotalRequest rechazoRequest = new RechazoDevolucionTotalRequest();
        rechazoRequest.setMotivoRechazo("No procede");
        solicitud.setMotivoDevolucion(null);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Assert
        assertThatThrownBy(() -> service.rechazarDevolucionTotal(1L, rechazoRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(ex.getMessage())
                        .isEqualTo("No existe motivo de devolución registrado");
                });
    }

    @Test
    @DisplayName("Debe lanzar excepción al rechazar devolución con motivo blank")
    void rechazarDevolucionTotal_conMotivoDevolucionBlank_lanzaBusinessException() {
        // Arrange
        RechazoDevolucionTotalRequest rechazoRequest = new RechazoDevolucionTotalRequest();
        rechazoRequest.setMotivoRechazo("No procede");
        solicitud.setMotivoDevolucion("");
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Assert
        assertThatThrownBy(() -> service.rechazarDevolucionTotal(1L, rechazoRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(ex.getMessage())
                        .isEqualTo("No existe motivo de devolución registrado");
                });
    }

    @Test
    @DisplayName("Debe lanzar excepción al rechazar devolución ya procesada")
    void rechazarDevolucionTotal_conDevolucionYaProcesada_lanzaBusinessException() {
        // Arrange
        RechazoDevolucionTotalRequest rechazoRequest = new RechazoDevolucionTotalRequest();
        rechazoRequest.setMotivoRechazo("No procede");
        solicitud.setMotivoDevolucion("Producto defectuoso");
        solicitud.setFlagEstadoDevolucion(SolicitudGiroConstants.DEVOLUCION_APROBADA);
        when(repository.findById(1L)).thenReturn(Optional.of(solicitud));

        // Act & Assert
        assertThatThrownBy(() -> service.rechazarDevolucionTotal(1L, rechazoRequest))
                .isInstanceOf(BusinessException.class)
                .satisfies(ex -> {
                    assertThat(ex.getMessage())
                        .isEqualTo("La devolución ya fue procesada");
                });
    }


    // ==== anular — solicitud no existe ====

    @Test
    @DisplayName("Debe lanzar ResourceNotFoundException al anular solicitud inexistente")
    void anular_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(repository.findById(999L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThatThrownBy(() -> service.anularSolicitud(999L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }


    // ==== aprobar — solicitud no existe ====

    @Test
    @DisplayName("Debe lanzar ResourceNotFoundException al aprobar solicitud inexistente")
    void aprobar_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        AprobarSolicitudRequest aprobarRequest = new AprobarSolicitudRequest();
        when(repository.findById(999L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThatThrownBy(() -> service.aprobarSolicitud(999L, aprobarRequest))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }


    // ==== rechazar — solicitud no existe ====

    @Test
    @DisplayName("Debe lanzar ResourceNotFoundException al rechazar solicitud inexistente")
    void rechazar_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        RechazarSolicitudRequest rechazarRequest = new RechazarSolicitudRequest();
        when(repository.findById(999L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThatThrownBy(() -> service.rechazarSolicitud(999L, rechazarRequest))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }


    // ==== registrarDevolucionTotal — solicitud no existe ====

    @Test
    @DisplayName("Debe lanzar ResourceNotFoundException al registrar devolución en solicitud inexistente")
    void registrarDevolucionTotal_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        DevolucionTotalRequest devolucionRequest = new DevolucionTotalRequest();
        when(repository.findById(999L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThatThrownBy(() -> service.registrarDevolucionTotal(999L, devolucionRequest))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }


    // ==== aprobarDevolucionTotal — solicitud no existe ====

    @Test
    @DisplayName("Debe lanzar ResourceNotFoundException al aprobar devolución inexistente")
    void aprobarDevolucionTotal_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        when(repository.findById(999L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThatThrownBy(() -> service.aprobarDevolucionTotal(999L))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }


    // ==== rechazarDevolucionTotal — solicitud no existe ====

    @Test
    @DisplayName("Debe lanzar ResourceNotFoundException al rechazar devolución inexistente")
    void rechazarDevolucionTotal_cuandoNoExiste_lanzaNotFoundException() {
        // Arrange
        RechazoDevolucionTotalRequest rechazoRequest = new RechazoDevolucionTotalRequest();
        when(repository.findById(999L)).thenReturn(Optional.empty());

        // Act & Assert
        assertThatThrownBy(() -> service.rechazarDevolucionTotal(999L, rechazoRequest))
                .isInstanceOf(ResourceNotFoundException.class);
        verify(repository).findById(999L);
    }
}
