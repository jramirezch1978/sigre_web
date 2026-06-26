package pe.restaurant.ventas.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureWebMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.common.testutil.TestDataSeeder;
import pe.restaurant.ventas.testdata.VentasTestDataExecutionListener;

import javax.sql.DataSource;
import org.springframework.jdbc.core.JdbcTemplate;
import java.math.BigDecimal;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para CierreCajaController con datos reales en base de datos.
 * Sigue la recomendación del líder de usar datos de prueba insertados en BD en lugar de mocks.
 * 
 * @author Equipo de Desarrollo
 */
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {
        TenantContextTestExecutionListener.class, 
        VentasTestDataExecutionListener.class
    },
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - CierreCajaController")
class CierreCajaControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private JdbcTemplate jdbc;
    private String authToken;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);

        // Generate mock auth token
        authToken = "Bearer mock-token";

        // Los seeds se ejecutan una sola vez en VentasTestDataExecutionListener
        // No es necesario ejecutarlos aquí en cada @BeforeEach
    }

    @Test
    @DisplayName("POST /api/cierres-caja - Crear CierreCaja exitosamente")
    void crearCierreCaja_Exito() throws Exception {
        // Arrange
        ObjectNode request = objectMapper.createObjectNode();
        request.put("turnoId", 1L);
        request.put("fondoInicial", new BigDecimal("1000.00"));
        request.put("observaciones", "Cierre de prueba integración");

        // Act & Assert
        mockMvc.perform(post("/api/ventas/cierre-caja")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.turnoId").value(1))
                .andExpect(jsonPath("$.data.fondoInicial").value(1000.00))
                .andExpect(jsonPath("$.data.fechaCierre").doesNotExist())
                .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }

    @Test
    @DisplayName("POST /api/cierres-caja - Turno duplicado lanza excepción")
    void crearCierreCaja_TurnoDuplicado() throws Exception {
        // 1. Crear primer CierreCaja
        ObjectNode request1 = objectMapper.createObjectNode();
        request1.put("turnoId", 2L);
        request1.put("fondoInicial", new BigDecimal("500.00"));

        mockMvc.perform(post("/api/ventas/cierre-caja")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(request1)))
                .andExpect(status().isCreated());

        // 2. Intentar crear segundo CierreCaja con mismo turno
        ObjectNode request2 = objectMapper.createObjectNode();
        request2.put("turnoId", 2L);
        request2.put("fondoInicial", new BigDecimal("600.00"));

        mockMvc.perform(post("/api/ventas/cierre-caja")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(request2)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("GET /api/cierres-caja/{id} - Obtener CierreCaja por ID")
    void obtenerCierreCajaPorId_Exito() throws Exception {
        // 1. Crear CierreCaja
        ObjectNode createRequest = objectMapper.createObjectNode();
        createRequest.put("turnoId", 3L);
        createRequest.put("fondoInicial", new BigDecimal("800.00"));

        String createResponse = mockMvc.perform(post("/api/ventas/cierre-caja")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(createRequest)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long cierreId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        // 2. Obtener el CierreCaja creado
        mockMvc.perform(get("/api/ventas/cierre-caja/{id}", cierreId)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(cierreId))
                .andExpect(jsonPath("$.data.turnoId").value(3))
                .andExpect(jsonPath("$.data.fondoInicial").value(800.00));
    }

    @Test
    @DisplayName("GET /api/cierres-caja/{id} - ID inexistente retorna 404")
    void obtenerCierreCajaPorId_NoExiste() throws Exception {
        mockMvc.perform(get("/api/ventas/cierre-caja/{id}", 99999L)
                        .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("GET /api/ventas/cierre-caja - Listar CierreCaja con filtros")
    void listarCierreCaja_ConFiltros() throws Exception {
        mockMvc.perform(get("/api/ventas/cierre-caja")
                        .param("turnoId", "1")
                        .param("abierto", "true")
                        .param("page", "0")
                        .param("size", "10")
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").exists())
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("PATCH /api/ventas/cierre-caja/{id}/cerrar - Cerrar CierreCaja exitosamente")
    void cerrarCierreCaja_Exito() throws Exception {
        // 1. Crear CierreCaja
        ObjectNode createRequest = objectMapper.createObjectNode();
        createRequest.put("turnoId", 4L);
        createRequest.put("fondoInicial", new BigDecimal("1200.00"));
        createRequest.put("observaciones", "Cierre para prueba");

        String createResponse = mockMvc.perform(post("/api/ventas/cierre-caja")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(createRequest)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long cierreId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        // 2. Cerrar el CierreCaja
        ObjectNode cerrarRequest = objectMapper.createObjectNode();
        cerrarRequest.put("fondoFinal", new BigDecimal("1500.00"));
        cerrarRequest.put("observaciones", "Cierre completado exitosamente");

        mockMvc.perform(patch("/api/ventas/cierre-caja/{id}/cerrar", cierreId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(cerrarRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(cierreId))
                .andExpect(jsonPath("$.data.fechaCierre").exists())
                .andExpect(jsonPath("$.data.fondoFinal").value(1500.00))
                .andExpect(jsonPath("$.data.diferencia").value(300.00));
    }

    @Test
    @DisplayName("PUT /api/cierres-caja/{id}/cerrar - Cierre ya cerrado lanza excepción")
    void cerrarCierreCaja_YaCerrado() throws Exception {
        // 1. Crear y cerrar CierreCaja
        ObjectNode createRequest = objectMapper.createObjectNode();
        createRequest.put("turnoId", 5L);
        createRequest.put("fondoInicial", new BigDecimal("2000.00"));

        String createResponse = mockMvc.perform(post("/api/ventas/cierre-caja")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(createRequest)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long cierreId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        ObjectNode cerrarRequest = objectMapper.createObjectNode();
        cerrarRequest.put("fondoFinal", new BigDecimal("2500.00"));

        mockMvc.perform(patch("/api/ventas/cierre-caja/{id}/cerrar", cierreId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(cerrarRequest)))
                .andExpect(status().isOk());

        // 2. Intentar cerrar nuevamente
        mockMvc.perform(patch("/api/ventas/cierre-caja/{id}/cerrar", cierreId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(cerrarRequest)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PATCH /api/ventas/cierre-caja/{id}/cerrar - Cálculo automático de diferencia")
    void cerrarCierreCaja_CalculoAutomaticoDiferencia() throws Exception {
        // 1. Crear CierreCaja con fondo inicial conocido
        ObjectNode createRequest = objectMapper.createObjectNode();
        createRequest.put("turnoId", 6L);
        createRequest.put("fondoInicial", new BigDecimal("1000.00"));

        String createResponse = mockMvc.perform(post("/api/ventas/cierre-caja")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(createRequest)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long cierreId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        // 2. Cerrar sin especificar diferencia (debe calcular automáticamente)
        ObjectNode cerrarRequest = objectMapper.createObjectNode();
        cerrarRequest.put("fondoFinal", new BigDecimal("1350.50"));
        // No incluir campo diferencia

        mockMvc.perform(patch("/api/ventas/cierre-caja/{id}/cerrar", cierreId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(cerrarRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.fondoFinal").value(1350.50))
                .andExpect(jsonPath("$.data.diferencia").value(350.50));
    }

    /**
     * Método helper para ejecutar operaciones que pueden fallar si los datos ya existen.
     */
    private void tryRun(Runnable operation) {
        try {
            operation.run();
        } catch (Exception e) {
            // Ignorar errores de datos duplicados o ya existentes
            System.out.println("Ignorando error en seeder: " + e.getMessage());
        }
    }
}
