package pe.restaurant.finanzas.controller;

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
import org.springframework.data.domain.PageRequest;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import pe.restaurant.common.exception.GlobalExceptionHandler;
import pe.restaurant.finanzas.dto.request.CajaBancosRequest;
import pe.restaurant.finanzas.dto.response.CajaBancosDetalleResponse;
import pe.restaurant.finanzas.dto.response.CajaBancosResponse;
import pe.restaurant.finanzas.dto.response.EjecutarMovimientoResponse;
import pe.restaurant.finanzas.service.CajaBancosService;
import pe.restaurant.finanzas.testutil.TestDataFactory;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests unitarios simples para CajaBancosController usando MockMvc standalone.
 * Enfoque híbrido: usa mocks para service pero TestDataFactory para datos realistas.
 * 
 * @author Equipo de Desarrollo
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias Simples - CajaBancosController")
class CajaBancosControllerSimpleTest {

    private MockMvc mockMvc;

    @Mock
    private CajaBancosService service;

    @InjectMocks
    private CajaBancosController controller;

    private ObjectMapper objectMapper;
    
    private CajaBancosResponse cajaBancosResponse;
    private CajaBancosDetalleResponse cajaBancosDetalleResponse;
    private EjecutarMovimientoResponse ejecutarResponse;
    private Map<String, Object> anularResponse;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler())
                .setMessageConverters(new MappingJackson2HttpMessageConverter(objectMapper))
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .build();
        
        setupTestData();
    }

    /**
     * Configura los datos de prueba usando TestDataFactory
     */
    private void setupTestData() {
        // Crear respuesta para listado
        cajaBancosResponse = new CajaBancosResponse();
        cajaBancosResponse.setId(1L);
        cajaBancosResponse.setNroRegistro("CB-2026-000001");
        cajaBancosResponse.setFechaEmision(java.time.LocalDate.now());
        cajaBancosResponse.setFlagTipoTransaccion("C");
        cajaBancosResponse.setBancoCntaId(1L);
        cajaBancosResponse.setEntidadContribuyenteId(1L);
        cajaBancosResponse.setMonedaId(1L);
        cajaBancosResponse.setImpTotal(new BigDecimal("1000.00"));
        cajaBancosResponse.setFlagEstado("1");

        // Crear respuesta detallada
        cajaBancosDetalleResponse = new CajaBancosDetalleResponse();
        cajaBancosDetalleResponse.setId(1L);
        cajaBancosDetalleResponse.setNroRegistro("CB-2026-000001");
        cajaBancosDetalleResponse.setFechaEmision(java.time.LocalDate.now());
        cajaBancosDetalleResponse.setFlagTipoTransaccion("C");
        cajaBancosDetalleResponse.setImpTotal(new BigDecimal("1000.00"));
        cajaBancosDetalleResponse.setFlagEstado("1");

        // Crear respuesta de ejecución
        ejecutarResponse = new EjecutarMovimientoResponse();
        ejecutarResponse.setId(1L);
        ejecutarResponse.setFlagEstado("2");
        ejecutarResponse.setFechaEjecucion(java.time.LocalDate.now());

        // Crear respuesta de anulación
        anularResponse = Map.of(
            "id", 1L,
            "flagEstado", "0",
            "message", "Movimiento anulado exitosamente"
        );
    }


    // ==== listar — otros ====

    @Test
    @DisplayName("Debe listar todos los movimientos de caja y bancos")
    void listar_DebeRetornarTodosLosMovimientos() throws Exception {
        // Arrange
        Page<CajaBancosResponse> page = new PageImpl<>(List.of(cajaBancosResponse));
        when(service.listar(any(), any(), any(), any(), any(), any(), any())).thenReturn(page);

        // Act & Assert
        mockMvc.perform(get("/api/finanzas/caja-bancos")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content.length()").value(1))
                .andExpect(jsonPath("$.data.page.totalElements").value(1))
                .andExpect(jsonPath("$.data.content[0].flagTipoTransaccion").value("C"))
                .andExpect(jsonPath("$.data.content[0].impTotal").value(1000.00));

        verify(service).listar(any(), any(), any(), any(), any(), any(), any());
    }

    @Test
    @DisplayName("Debe filtrar movimientos por tipo de transacción")
    void listar_ConFiltroTipoTransaccion_DebeRetornarFiltrados() throws Exception {
        // Arrange
        Page<CajaBancosResponse> page = new PageImpl<>(List.of(cajaBancosResponse));
        when(service.listar(eq("C"), any(), any(), any(), any(), any(), any())).thenReturn(page);

        // Act & Assert
        mockMvc.perform(get("/api/finanzas/caja-bancos")
                .param("flagTipoTransaccion", "C")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content.length()").value(1))
                .andExpect(jsonPath("$.data.content[0].flagTipoTransaccion").value("C"));

        verify(service).listar(eq("C"), any(), any(), any(), any(), any(), any());
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("Debe obtener movimiento por ID")
    void obtenerPorId_ConIdExistente_DebeRetornarMovimiento() throws Exception {
        // Arrange
        when(service.obtenerPorId(eq(1L))).thenReturn(cajaBancosDetalleResponse);

        // Act & Assert
        mockMvc.perform(get("/api/finanzas/caja-bancos/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.flagTipoTransaccion").value("C"))
                .andExpect(jsonPath("$.data.impTotal").value(1000.00));

        verify(service).obtenerPorId(eq(1L));
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("Debe crear movimiento de cobro")
    void crear_Cobro_DebeCrearYRetornar() throws Exception {
        // Arrange
        CajaBancosRequest request = TestDataFactory.crearCajaBancosRequestCobro();
        when(service.crear(any())).thenReturn(cajaBancosDetalleResponse);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/caja-bancos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.flagTipoTransaccion").value("C"))
                .andExpect(jsonPath("$.data.impTotal").value(1000.00));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("Debe crear movimiento de pago")
    void crear_Pago_DebeCrearYRetornar() throws Exception {
        // Arrange
        CajaBancosRequest request = TestDataFactory.crearCajaBancosRequestPago();
        cajaBancosDetalleResponse.setFlagTipoTransaccion("P");
        cajaBancosDetalleResponse.setImpTotal(new BigDecimal("800.00"));
        when(service.crear(any())).thenReturn(cajaBancosDetalleResponse);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/caja-bancos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.flagTipoTransaccion").value("P"))
                .andExpect(jsonPath("$.data.impTotal").value(800.00));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("Debe crear movimiento de transferencia")
    void crear_Transferencia_DebeCrearYRetornar() throws Exception {
        // Arrange
        CajaBancosRequest request = TestDataFactory.crearCajaBancosRequestTransferencia();
        cajaBancosDetalleResponse.setFlagTipoTransaccion("T");
        cajaBancosDetalleResponse.setImpTotal(new BigDecimal("500.00"));
        when(service.crear(any())).thenReturn(cajaBancosDetalleResponse);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/caja-bancos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.flagTipoTransaccion").value("T"))
                .andExpect(jsonPath("$.data.impTotal").value(500.00));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("Debe crear movimiento de aplicación")
    void crear_Aplicacion_DebeCrearYRetornar() throws Exception {
        // Arrange
        CajaBancosRequest request = TestDataFactory.crearCajaBancosRequestAplicacion();
        cajaBancosDetalleResponse.setFlagTipoTransaccion("A");
        cajaBancosDetalleResponse.setImpTotal(new BigDecimal("1200.00"));
        when(service.crear(any())).thenReturn(cajaBancosDetalleResponse);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/caja-bancos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.flagTipoTransaccion").value("A"))
                .andExpect(jsonPath("$.data.impTotal").value(1200.00));

        verify(service).crear(any());
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("Debe actualizar movimiento existente")
    void actualizar_ConIdExistente_DebeActualizarYRetornar() throws Exception {
        // Arrange
        CajaBancosRequest request = TestDataFactory.crearCajaBancosRequestCobro();
        cajaBancosDetalleResponse.setImpTotal(new BigDecimal("1500.00"));
        when(service.actualizar(eq(1L), any())).thenReturn(cajaBancosDetalleResponse);

        // Act & Assert
        mockMvc.perform(put("/api/finanzas/caja-bancos/{id}", 1L)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.impTotal").value(1500.00));

        verify(service).actualizar(eq(1L), any());
    }


    // ==== ejecutar — escenarios felices ====

    @Test
    @DisplayName("Debe ejecutar movimiento existente")
    void ejecutar_ConIdExistente_DebeEjecutarYRetornar() throws Exception {
        // Arrange
        when(service.ejecutar(eq(1L))).thenReturn(ejecutarResponse);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/caja-bancos/{id}/ejecutar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.fechaEjecucion").exists());

        verify(service).ejecutar(eq(1L));
    }


    // ==== anular — escenarios felices ====

    @Test
    @DisplayName("Debe anular movimiento existente")
    void anular_ConIdExistente_DebeAnularYRetornar() throws Exception {
        // Arrange
        when(service.anular(eq(1L))).thenReturn(anularResponse);

        // Act & Assert
        mockMvc.perform(post("/api/finanzas/caja-bancos/{id}/anular", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.flagEstado").value("0"));

        verify(service).anular(eq(1L));
    }


    // ==== listar — otros ====

    @Test
    @DisplayName("Debe validar paginación en listado")
    void listar_ConPaginacion_DebeRetornarPaginado() throws Exception {
        // Arrange
        Page<CajaBancosResponse> page = new PageImpl<>(List.of(cajaBancosResponse), PageRequest.of(0, 2), 1);
        when(service.listar(any(), any(), any(), any(), any(), any(), any())).thenReturn(page);

        // Act & Assert
        mockMvc.perform(get("/api/finanzas/caja-bancos")
                .param("page", "0")
                .param("size", "2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content.length()").value(1))
                .andExpect(jsonPath("$.data.page.totalElements").value(1))
                .andExpect(jsonPath("$.data.page.totalPages").value(1))
                .andExpect(jsonPath("$.data.page.size").value(2))
                .andExpect(jsonPath("$.data.page.number").value(0));

        verify(service).listar(any(), any(), any(), any(), any(), any(), any());
    }

    @Test
    @DisplayName("Debe filtrar movimientos por entidad contribuyente")
    void listar_ConFiltroEntidadContribuyente_DebeRetornarFiltrados() throws Exception {
        // Arrange
        Page<CajaBancosResponse> page = new PageImpl<>(List.of(cajaBancosResponse));
        when(service.listar(any(), any(), any(), any(), any(), eq(1L), any())).thenReturn(page);

        // Act & Assert
        mockMvc.perform(get("/api/finanzas/caja-bancos")
                .param("entidadContribuyenteId", "1")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content.length()").value(1))
                .andExpect(jsonPath("$.data.content[0].entidadContribuyenteId").value(1));

        verify(service).listar(any(), any(), any(), any(), any(), eq(1L), any());
    }
}
