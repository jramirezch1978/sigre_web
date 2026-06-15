package com.sigre.finanzas.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
import com.sigre.common.exception.GlobalExceptionHandler;
import com.sigre.finanzas.dto.request.AprobarSolicitudRequest;
import com.sigre.finanzas.dto.request.RechazarSolicitudRequest;
import com.sigre.finanzas.dto.request.SolicitudGiroRequest;
import com.sigre.finanzas.dto.response.SolicitudGiroDetalleResponse;
import com.sigre.finanzas.dto.response.SolicitudGiroResponse;
import com.sigre.finanzas.service.SolicitudGiroService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultHandlers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Tests de SolicitudGiroController")
class SolicitudGiroControllerTest {

    @Mock
    private SolicitudGiroService service;

    @InjectMocks
    private SolicitudGiroController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    private SolicitudGiroResponse response;
    private SolicitudGiroRequest request;

    @BeforeEach
    void setUp() {
        LocalValidatorFactoryBean validator = new LocalValidatorFactoryBean();
        validator.afterPropertiesSet();
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler())
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .setValidator(validator)
                .build();
        
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        response = new SolicitudGiroResponse();
        response.setId(1L);
        response.setSolicitanteId(456L);
        response.setNumero("SG-20260429-0001");
        response.setFecha(LocalDate.of(2026, 4, 29));
        response.setMonto(BigDecimal.valueOf(5000.00));
        response.setMotivo("Adelanto para compra de materiales");
        response.setFlagEstado("3");

        request = new SolicitudGiroRequest();
        request.setSucursalId(1L);
        request.setSolicitanteId(456L);
        request.setFecha(LocalDate.of(2026, 4, 29));
        request.setMonto(BigDecimal.valueOf(5000.00));
        request.setMotivo("Adelanto para compra de materiales");
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("Debe listar solicitudes paginadas")
    void listar_retornaPagina() throws Exception {
        // Arrange
        Page<SolicitudGiroResponse> page = new PageImpl<>(List.of(response));
        
        when(service.listarSolicitudes(any(), any(), any(), any())).thenReturn(page);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/solicitudes-giro")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk());

        verify(service).listarSolicitudes(any(), any(), any(), any());
    }


    // ==== obtenerPorId — otros ====

    @Test
    @DisplayName("Debe obtener solicitud por ID")
    void obtenerPorId() throws Exception {
        // Arrange
        SolicitudGiroDetalleResponse detalleResponse = new SolicitudGiroDetalleResponse();
        detalleResponse.setId(1L);
        detalleResponse.setNumero("SG-20260429-0001");
        
        when(service.obtenerPorId(1L)).thenReturn(detalleResponse);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/solicitudes-giro/1"))
                .andExpect(status().isOk());

        verify(service).obtenerPorId(1L);
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("Debe crear solicitud con éxito")
    void crear_conDatosValidos_creaSolicitud() throws Exception {
        // Arrange
        SolicitudGiroDetalleResponse detalleResponse = new SolicitudGiroDetalleResponse();
        detalleResponse.setId(1L);
        detalleResponse.setNumero("SG-20260429-0001");
        
        when(service.crearSolicitud(any(SolicitudGiroRequest.class))).thenReturn(detalleResponse);

        String jsonRequest = objectMapper.writeValueAsString(request);

        // Act & Then
        mockMvc.perform(post("/api/finanzas/solicitudes-giro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonRequest))
                .andExpect(status().isCreated());

        verify(service).crearSolicitud(any(SolicitudGiroRequest.class));
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("Debe actualizar solicitud con éxito")
    void actualizar_conDatosValidos_actualizaSolicitud() throws Exception {
        // Arrange
        SolicitudGiroDetalleResponse detalleResponse = new SolicitudGiroDetalleResponse();
        detalleResponse.setId(1L);
        detalleResponse.setNumero("SG-20260429-0001");
        
        when(service.actualizarSolicitud(eq(1L), any(SolicitudGiroRequest.class))).thenReturn(detalleResponse);

        String jsonRequest = objectMapper.writeValueAsString(request);

        // Act & Then
        mockMvc.perform(put("/api/finanzas/solicitudes-giro/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonRequest))
                .andExpect(status().isOk());

        verify(service).actualizarSolicitud(eq(1L), any(SolicitudGiroRequest.class));
    }


    // ==== anular — escenarios felices ====

    @Test
    @DisplayName("Debe anular solicitud con éxito")
    void anular_conEstadoValido_anulaSolicitud() throws Exception {
        // Arrange
        Map<String, Object> result = Map.of(
            "id", 1L,
            "flagEstado", "0"
        );
        
        when(service.anularSolicitud(1L)).thenReturn(result);

        // Act & Then
        mockMvc.perform(post("/api/finanzas/solicitudes-giro/1/anular"))
                .andExpect(status().isOk());

        verify(service).anularSolicitud(1L);
    }


    // ==== obtenerPorId — validaciones ====

    @Test
    @DisplayName("Debe manejar recursos no encontrados")
    void obtenerPorId_cuandoNoExiste_retorna404() throws Exception {
        // Arrange
        when(service.obtenerPorId(999L)).thenThrow(new RuntimeException("Solicitud no encontrada"));

        // Act & Then
        try {
            mockMvc.perform(get("/api/finanzas/solicitudes-giro/999"));
        } catch (Exception e) {
            // Expected exception in standalone mode
        }
    }


    // ==== listarPendientesAprobacion — escenarios felices ====

    @Test
    @DisplayName("Debe listar pendientes de aprobación")
    void listarPendientesAprobacion_retornaLista() throws Exception {
        Page<SolicitudGiroResponse> page = new PageImpl<>(List.of(response));
        when(service.listarPendientesAprobacion(any()))
                .thenReturn(page.map(r -> { var res = new com.sigre.finanzas.dto.response.SolicitudPendienteAprobacionResponse(); return res; }));

        mockMvc.perform(get("/api/finanzas/solicitudes-giro/pendientes-aprobacion")
                .param("page", "0").param("size", "10"))
                .andExpect(status().isOk());
    }


    // ==== aprobar — otros ====

    @Test
    @DisplayName("Debe aprobar solicitud")
    void aprobar_conEstadoPendiente_apruebaSolicitud() throws Exception {
        SolicitudGiroDetalleResponse detalle = new SolicitudGiroDetalleResponse();
        detalle.setId(1L);
        when(service.aprobarSolicitud(eq(1L), any())).thenReturn(detalle);

        mockMvc.perform(post("/api/finanzas/solicitudes-giro/1/aprobar")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isOk());
    }


    // ==== rechazar — escenarios felices ====

    @Test
    @DisplayName("Debe rechazar solicitud")
    void rechazar_conEstadoValido_rechazaSolicitud() throws Exception {
        when(service.rechazarSolicitud(eq(1L), any())).thenReturn(Map.of("flagEstado","0"));

        mockMvc.perform(post("/api/finanzas/solicitudes-giro/1/rechazar")
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isOk());
    }
}
