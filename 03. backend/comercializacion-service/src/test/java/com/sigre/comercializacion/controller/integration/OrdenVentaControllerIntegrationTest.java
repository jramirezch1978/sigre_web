package com.sigre.comercializacion.controller.integration;

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
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.common.testutil.TestDataSeeder;
import com.sigre.comercializacion.testdata.VentasTestDataExecutionListener;

import javax.sql.DataSource;
import org.springframework.jdbc.core.JdbcTemplate;
import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para OrdenVentaController con datos reales en base de datos.
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
@DisplayName("Pruebas de Integración - OrdenVentaController")
class OrdenVentaControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private JdbcTemplate jdbc;
    private String authToken;

    private Long sucursalId;
    private Long clienteId;
    private Long vendedorId;
    private Long articuloId;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);

        // Generate mock auth token
        authToken = "Bearer mock-token";

        // Obtener IDs de datos creados por VentasTestDataExecutionListener
        sucursalId = jdbc.queryForObject("SELECT id FROM auth.sucursal WHERE flag_estado = '1' LIMIT 1", Long.class);
        clienteId = jdbc.queryForObject("SELECT id FROM core.entidad_contribuyente WHERE flag_estado = '1' LIMIT 1", Long.class);
        vendedorId = jdbc.queryForObject("SELECT id FROM ventas.vendedor WHERE flag_estado = '1' LIMIT 1", Long.class);
        articuloId = jdbc.queryForObject("SELECT id FROM core.articulo WHERE flag_estado = '1' LIMIT 1", Long.class);
    }

    @Test
    @DisplayName("POST /api/ordenes-venta - Crear OrdenVenta exitosamente")
    void crearOrdenVenta_Exito() throws Exception {
        // Arrange
        ObjectNode request = objectMapper.createObjectNode();
        request.put("sucursalId", sucursalId);
        request.put("clienteId", clienteId);
        request.put("vendedorId", vendedorId);
        request.put("fechaEmision", LocalDate.now().toString());
        request.put("observaciones", "Orden de venta de prueba");

        // Agregar detalles
        ObjectNode detalle = objectMapper.createObjectNode();
        detalle.put("articuloId", articuloId);
        detalle.put("lineaNro", 1);
        detalle.put("cantProyectada", new BigDecimal("2"));
        detalle.put("valorUnitario", new BigDecimal("75.25"));
        detalle.put("tiposImpuestoId", 1L); // Tipo de impuesto por defecto
        request.putArray("detalles").add(detalle);

        // Act & Assert
        mockMvc.perform(post("/api/ventas/ordenes-venta")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.sucursalId").value(sucursalId))
                .andExpect(jsonPath("$.data.clienteId").value(clienteId))
                .andExpect(jsonPath("$.data.vendedorId").value(vendedorId))
                .andExpect(jsonPath("$.data.montoTotal").value(150.50))
                .andExpect(jsonPath("$.data.detalles").isArray())
                .andExpect(jsonPath("$.data.detalles[0].articuloId").value(articuloId))
                .andDo(result -> {
                    System.out.println("=== RESPONSE COMPLETO ===");
                    System.out.println(result.getResponse().getContentAsString());
                    System.out.println("========================");
                })
                .andExpect(jsonPath("$.data.detalles[0].cantProyectada").value(2));
    }

    @Test
    @DisplayName("GET /api/ordenes-venta/{id} - Obtener OrdenVenta por ID")
    void obtenerOrdenVentaPorId_Exito() throws Exception {
        // 1. Primero crear una OrdenVenta
        ObjectNode createRequest = objectMapper.createObjectNode();
        createRequest.put("sucursalId", sucursalId);
        createRequest.put("clienteId", clienteId);
        createRequest.put("vendedorId", vendedorId);
        createRequest.put("fechaEmision", LocalDate.now().toString());
        createRequest.put("observaciones", "Orden de prueba para obtener");

        ObjectNode detalle = objectMapper.createObjectNode();
        detalle.put("articuloId", articuloId);
        detalle.put("lineaNro", 1);
        detalle.put("cantProyectada", new BigDecimal("1"));
        detalle.put("valorUnitario", new BigDecimal("100.00"));
        detalle.put("tiposImpuestoId", 1L);
        createRequest.putArray("detalles").add(detalle);

        String createResponse = mockMvc.perform(post("/api/ventas/ordenes-venta")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(createRequest)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long ordenId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        // 2. Obtener la OrdenVenta creada
        mockMvc.perform(get("/api/ventas/ordenes-venta/{id}", ordenId)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(ordenId))
                .andExpect(jsonPath("$.data.sucursalId").value(sucursalId))
                .andExpect(jsonPath("$.data.clienteId").value(clienteId))
                .andExpect(jsonPath("$.data.montoTotal").value(100.00));
    }

    @Test
    @DisplayName("GET /api/ordenes-venta/{id} - ID inexistente retorna 404")
    void obtenerOrdenVentaPorId_NoExiste() throws Exception {
        mockMvc.perform(get("/api/ventas/ordenes-venta/{id}", 99999L)
                        .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("GET /api/ordenes-venta - Listar OrdenVenta con filtros")
    void listarOrdenVenta_ConFiltros() throws Exception {
        mockMvc.perform(get("/api/ventas/ordenes-venta")
                        .param("sucursalId", sucursalId.toString())
                        .param("clienteId", clienteId.toString())
                        .param("page", "0")
                        .param("size", "10")
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").exists())
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("PUT /api/ventas/ordenes-venta/{id} - Actualizar OrdenVenta")
    void actualizarOrdenVenta_Exito() throws Exception {
        // 1. Crear OrdenVenta inicial
        ObjectNode createRequest = objectMapper.createObjectNode();
        createRequest.put("sucursalId", sucursalId);
        createRequest.put("clienteId", clienteId);
        createRequest.put("vendedorId", vendedorId);
        createRequest.put("fechaEmision", LocalDate.now().toString());
        createRequest.put("observaciones", "Orden inicial para actualizar");

        ObjectNode detalle = objectMapper.createObjectNode();
        detalle.put("articuloId", articuloId);
        detalle.put("lineaNro", 1);
        detalle.put("cantProyectada", new BigDecimal("1"));
        detalle.put("valorUnitario", new BigDecimal("50.00"));
        detalle.put("tiposImpuestoId", 1L);
        createRequest.putArray("detalles").add(detalle);

        String createResponse = mockMvc.perform(post("/api/ventas/ordenes-venta")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(createRequest)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long ordenId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        // 2. Actualizar la OrdenVenta
        ObjectNode updateRequest = objectMapper.createObjectNode();
        updateRequest.put("sucursalId", sucursalId);
        updateRequest.put("clienteId", clienteId);
        updateRequest.put("vendedorId", vendedorId);
        updateRequest.put("fechaEmision", LocalDate.now().toString());
        updateRequest.put("observaciones", "Orden actualizada");

        ObjectNode updateDetalle = objectMapper.createObjectNode();
        updateDetalle.put("articuloId", articuloId);
        updateDetalle.put("lineaNro", 1);
        updateDetalle.put("cantProyectada", new BigDecimal("1"));
        updateDetalle.put("valorUnitario", new BigDecimal("75.00"));
        updateDetalle.put("tiposImpuestoId", 1L);
        updateRequest.putArray("detalles").add(updateDetalle);

        mockMvc.perform(put("/api/ventas/ordenes-venta/{id}", ordenId)
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(updateRequest)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(ordenId))
                .andExpect(jsonPath("$.data.montoTotal").value(75.00));
    }

    @Test
    @DisplayName("PATCH /api/ventas/ordenes-venta/{id}/confirmar - Confirmar OrdenVenta")
    void confirmarOrdenVenta_Exito() throws Exception {
        // 1. Crear OrdenVenta
        ObjectNode createRequest = objectMapper.createObjectNode();
        createRequest.put("sucursalId", sucursalId);
        createRequest.put("clienteId", clienteId);
        createRequest.put("vendedorId", vendedorId);
        createRequest.put("fechaEmision", LocalDate.now().toString());
        createRequest.put("observaciones", "Orden para confirmar");

        ObjectNode detalle = objectMapper.createObjectNode();
        detalle.put("articuloId", articuloId);
        detalle.put("lineaNro", 1);
        detalle.put("cantProyectada", new BigDecimal("1"));
        detalle.put("valorUnitario", new BigDecimal("25.00"));
        detalle.put("tiposImpuestoId", 1L);
        createRequest.putArray("detalles").add(detalle);

        String createResponse = mockMvc.perform(post("/api/ventas/ordenes-venta")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(createRequest)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long ordenId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        // 2. Confirmar la OrdenVenta
        mockMvc.perform(patch("/api/ventas/ordenes-venta/{id}/confirmar", ordenId)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("PATCH /api/ventas/ordenes-venta/{id}/anular - Anular OrdenVenta")
    void anularOrdenVenta_Exito() throws Exception {
        // 1. Crear OrdenVenta
        ObjectNode createRequest = objectMapper.createObjectNode();
        createRequest.put("sucursalId", sucursalId);
        createRequest.put("clienteId", clienteId);
        createRequest.put("vendedorId", vendedorId);
        createRequest.put("fechaEmision", LocalDate.now().toString());
        createRequest.put("observaciones", "Orden para anular");

        ObjectNode detalle = objectMapper.createObjectNode();
        detalle.put("articuloId", articuloId);
        detalle.put("lineaNro", 1);
        detalle.put("cantProyectada", new BigDecimal("1"));
        detalle.put("valorUnitario", new BigDecimal("30.00"));
        detalle.put("tiposImpuestoId", 1L);
        createRequest.putArray("detalles").add(detalle);

        String createResponse = mockMvc.perform(post("/api/ventas/ordenes-venta")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(createRequest)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long ordenId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        // 2. Anular la OrdenVenta
        mockMvc.perform(patch("/api/ventas/ordenes-venta/{id}/anular", ordenId)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("POST /api/ventas/ordenes-venta - Test mínimo para diagnóstico")
    void crearOrdenVenta_Minimo_Exito() throws Exception {
        // Arrange - request con solo campos obligatorios
        ObjectNode request = objectMapper.createObjectNode();
        request.put("sucursalId", sucursalId);
        request.put("fechaEmision", LocalDate.now().toString());
        
        // Detalles mínimos
        ObjectNode detalle = objectMapper.createObjectNode();
        detalle.put("articuloId", articuloId);
        detalle.put("cantProyectada", new BigDecimal("1"));
        detalle.put("valorUnitario", new BigDecimal("100"));
        request.putArray("detalles").add(detalle);

        // Act & Assert
        mockMvc.perform(post("/api/ventas/ordenes-venta")
                        .contentType(MediaType.APPLICATION_JSON)
                        .header("Authorization", authToken)
                        .content(objectMapper.writeValueAsString(request)))
                .andDo(result -> {
                    System.out.println("Response status: " + result.getResponse().getStatus());
                    System.out.println("Response content: " + result.getResponse().getContentAsString());
                });
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
