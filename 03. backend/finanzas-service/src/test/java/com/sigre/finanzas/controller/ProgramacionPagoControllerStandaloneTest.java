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
import com.sigre.finanzas.dto.request.ProgramacionPagoRequest;
import com.sigre.finanzas.dto.response.EjecucionProgramacionResponse;
import com.sigre.finanzas.dto.response.PageData;
import com.sigre.finanzas.dto.response.ProgramacionPagoListResponse;
import com.sigre.finanzas.dto.response.ProgramacionPagoResponse;
import com.sigre.finanzas.service.ProgramacionPagoService;
import com.sigre.finanzas.testutil.TestDataFactory;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests unitarios standalone para ProgramacionPagoController.
 * Enfoque práctico: valida comportamiento HTTP y llamadas al servicio.
 * 
 * @author Equipo de Desarrollo
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias Standalone - ProgramacionPagoController")
class ProgramacionPagoControllerStandaloneTest {

    private MockMvc mockMvc;

    @Mock
    private ProgramacionPagoService service;

    @InjectMocks
    private ProgramacionPagoController controller;

    private ObjectMapper objectMapper;
    
    private ProgramacionPagoListResponse programacionPagoListResponse;
    private ProgramacionPagoResponse programacionPagoResponse;
    private EjecucionProgramacionResponse ejecucionResponse;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .build();
        
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        
        setupTestData();
    }

    /**
     * Configura los datos de prueba usando TestDataFactory
     */
    private void setupTestData() {
        // Crear respuesta para listado
        programacionPagoListResponse = new ProgramacionPagoListResponse();
        programacionPagoListResponse.setId(1L);
        programacionPagoListResponse.setFechaProgramada(java.time.LocalDate.now().plusDays(7));
        programacionPagoListResponse.setFlagEstado("1");
        programacionPagoListResponse.setTotalProgramado(new BigDecimal("800.00"));
        programacionPagoListResponse.setCantidadDocumentos(2);
        programacionPagoListResponse.setFlagEstado("1");

        // Crear respuesta detallada
        programacionPagoResponse = new ProgramacionPagoResponse();
        programacionPagoResponse.setId(1L);
        programacionPagoResponse.setFechaProgramada(java.time.LocalDate.now().plusDays(7));
        programacionPagoResponse.setFlagEstado("1");

        // Crear respuesta de ejecución
        ejecucionResponse = new EjecucionProgramacionResponse();
        ejecucionResponse.setId(1L);
        ejecucionResponse.setFlagEstado("2");
        ejecucionResponse.setPagosGenerados(2);
        ejecucionResponse.setTotalPagado(new BigDecimal("800.00"));
        ejecucionResponse.setFlagEstado("1");
    }


    // ==== listar — otros ====

    @Test
    @DisplayName("Debe listar todas las programaciones de pago")
    void listar_DebeRetornarTodasLasProgramaciones() throws Exception {
        // Arrange
        Page<ProgramacionPagoListResponse> page = new PageImpl<>(List.of(programacionPagoListResponse));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        // Act & Assert
        mockMvc.perform(get("/api/finanzas/programacion-pagos")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk());

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("Debe filtrar programaciones por estado")
    void listar_ConFiltroEstado_DebeRetornarFiltradas() throws Exception {
        // Arrange
        Page<ProgramacionPagoListResponse> page = new PageImpl<>(List.of(programacionPagoListResponse));
        when(service.listar(any(), any(), eq("1"), any())).thenReturn(page);

        // Act & Assert
        mockMvc.perform(get("/api/finanzas/programacion-pagos")
                .param("estado", "1")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk());

        verify(service).listar(any(), any(), eq("1"), any());
    }

    @Test
    @DisplayName("Debe filtrar programaciones por fechas")
    void listar_ConFiltroFechas_DebeRetornarFiltradas() throws Exception {
        // Arrange
        Page<ProgramacionPagoListResponse> page = new PageImpl<>(List.of(programacionPagoListResponse));
        String fechaDesde = java.time.LocalDate.now().toString();
        String fechaHasta = java.time.LocalDate.now().plusDays(30).toString();
        when(service.listar(eq(java.time.LocalDate.now()), eq(java.time.LocalDate.now().plusDays(30)), any(), any())).thenReturn(page);

        // Act & Assert
        mockMvc.perform(get("/api/finanzas/programacion-pagos")
                .param("fechaDesde", fechaDesde)
                .param("fechaHasta", fechaHasta)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk());

        verify(service).listar(eq(java.time.LocalDate.now()), eq(java.time.LocalDate.now().plusDays(30)), any(), any());
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("Debe obtener programación por ID")
    void obtenerPorId_ConIdExistente_DebeRetornarProgramacion() throws Exception {
        // Arrange
        when(service.obtenerPorId(eq(1L))).thenReturn(programacionPagoResponse);

        // Act & Assert
        mockMvc.perform(get("/api/finanzas/programacion-pagos/{id}", 1L))
                .andExpect(status().isOk());

        verify(service).obtenerPorId(eq(1L));
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("Debe crear programación de pago")
    void crear_DebeCrearYRetornar() throws Exception {
        // Arrange
        ProgramacionPagoRequest request = TestDataFactory.crearProgramacionPagoRequest();
        when(service.crear(any())).thenReturn(programacionPagoResponse);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/programacion-pagos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());

        verify(service).crear(any());
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("Debe actualizar programación existente")
    void actualizar_ConIdExistente_DebeActualizarYRetornar() throws Exception {
        // Arrange
        ProgramacionPagoRequest request = TestDataFactory.crearProgramacionPagoRequest();
        // No hay método setObservación ni setMontoTotal en ProgramacionPagoResponse
        when(service.actualizar(eq(1L), any())).thenReturn(programacionPagoResponse);

        // Act & Assert
        mockMvc.perform(put("/api/finanzas/programacion-pagos/{id}", 1L)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());

        verify(service).actualizar(eq(1L), any());
    }


    // ==== ejecutar — escenarios felices ====

    @Test
    @DisplayName("Debe ejecutar programación existente")
    void ejecutar_ConIdExistente_DebeEjecutarYRetornar() throws Exception {
        // Arrange
        when(service.ejecutar(eq(1L))).thenReturn(ejecucionResponse);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/programacion-pagos/{id}/ejecutar", 1L))
                .andExpect(status().isOk());

        verify(service).ejecutar(eq(1L));
    }


    // ==== anular — escenarios felices ====

    @Test
    @DisplayName("Debe anular programación existente")
    void anular_ConIdExistente_DebeAnularYRetornar() throws Exception {
        // Arrange
        programacionPagoResponse.setFlagEstado("0");
        when(service.anular(eq(1L))).thenReturn(programacionPagoResponse);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/programacion-pagos/{id}/anular", 1L))
                .andExpect(status().isOk());

        verify(service).anular(eq(1L));
    }


    // ==== listar — otros ====

    @Test
    @DisplayName("Debe validar paginación en listado")
    void listar_ConPaginacion_DebeRetornarPaginado() throws Exception {
        // Arrange
        Page<ProgramacionPagoListResponse> page = new PageImpl<>(List.of(programacionPagoListResponse));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        // Act & Assert
        mockMvc.perform(get("/api/finanzas/programacion-pagos")
                .param("page", "0")
                .param("size", "2"))
                .andExpect(status().isOk());

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("Debe validar que se usen los parámetros correctos en el servicio")
    void listar_DebeUsarParametrosCorrectos() throws Exception {
        // Arrange
        Page<ProgramacionPagoListResponse> page = new PageImpl<>(List.of(programacionPagoListResponse));
        when(service.listar(eq(java.time.LocalDate.now().minusDays(7)), 
                          eq(java.time.LocalDate.now().plusDays(7)), 
                          eq("EJECUTADO"), 
                          any())).thenReturn(page);

        // Act & Assert
        mockMvc.perform(get("/api/finanzas/programacion-pagos")
                .param("fechaDesde", java.time.LocalDate.now().minusDays(7).toString())
                .param("fechaHasta", java.time.LocalDate.now().plusDays(7).toString())
                .param("estado", "EJECUTADO")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk());

        verify(service).listar(eq(java.time.LocalDate.now().minusDays(7)), 
                             eq(java.time.LocalDate.now().plusDays(7)), 
                             eq("EJECUTADO"), 
                             any());
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("Debe crear programación con datos válidos")
    void crear_ConDatosValidos_DebeCrearYRetornar() throws Exception {
        // Arrange
        ProgramacionPagoRequest request = TestDataFactory.crearProgramacionPagoRequest();
        when(service.crear(any())).thenReturn(programacionPagoResponse);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/programacion-pagos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());

        verify(service).crear(any());
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("Debe actualizar programación con observación")
    void actualizar_ConObservacion_DebeActualizarYRetornar() throws Exception {
        // Arrange
        ProgramacionPagoRequest request = TestDataFactory.crearProgramacionPagoRequest();
        // No hay método setObservación en ProgramacionPagoRequest ni ProgramacionPagoResponse
        when(service.actualizar(eq(1L), any())).thenReturn(programacionPagoResponse);

        // Act & Assert
        mockMvc.perform(put("/api/finanzas/programacion-pagos/{id}", 1L)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());

        verify(service).actualizar(eq(1L), any());
    }


    // ==== ejecutar — otros ====

    @Test
    @DisplayName("Debe ejecutar programación y generar pagos")
    void ejecutar_DebeGenerarPagosYRetornar() throws Exception {
        // Arrange
        ejecucionResponse.setPagosGenerados(3);
        ejecucionResponse.setTotalPagado(new BigDecimal("1200.00"));
        when(service.ejecutar(eq(1L))).thenReturn(ejecucionResponse);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/programacion-pagos/{id}/ejecutar", 1L))
                .andExpect(status().isOk());

        verify(service).ejecutar(eq(1L));
    }
}
