package pe.restaurant.ventas.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureWebMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.ventas.testdata.VentasTestDataExecutionListener;

import javax.sql.DataSource;
import java.time.LocalDateTime;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Integration tests para PedidoMesaController.
 * Cubre todos los endpoints con datos reales en BD para mejorar cobertura de branches.
 */
@Tag("integration")
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
@DisplayName("Pruebas de Integración — PedidoMesaController")
class PedidoMesaControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private JdbcTemplate jdbc;

    private Long pedidoMesaId;
    private Long mesaId;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);
        
        // Obtener IDs de datos existentes
        pedidoMesaId = jdbc.queryForObject(
            "SELECT id FROM ventas.pedido_mesa WHERE flag_estado = '1' LIMIT 1", 
            Long.class
        );
        mesaId = jdbc.queryForObject(
            "SELECT id FROM ventas.mesa WHERE flag_estado = '1' LIMIT 1", 
            Long.class
        );
    }

    // ==== GET /api/ventas/pedidos-mesa ====

    @Test
    @DisplayName("GET /api/ventas/pedidos-mesa sin filtros -> retorna página")
    void findAll_sinFiltros_retornaPagina() throws Exception {
        mockMvc.perform(get("/api/ventas/pedidos-mesa")
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/ventas/pedidos-mesa con filtro sucursalId -> retorna página filtrada")
    void findAll_conFiltroSucursal_retornaPaginaFiltrada() throws Exception {
        mockMvc.perform(get("/api/ventas/pedidos-mesa")
                .param("page", "0")
                .param("size", "10")
                .param("sucursalId", "1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/ventas/pedidos-mesa con filtro mesaId -> retorna página filtrada")
    void findAll_conFiltroMesa_retornaPaginaFiltrada() throws Exception {
        mockMvc.perform(get("/api/ventas/pedidos-mesa")
                .param("page", "0")
                .param("size", "10")
                .param("mesaId", mesaId.toString()))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/ventas/pedidos-mesa con filtro meseroId -> retorna página filtrada")
    void findAll_conFiltroMesero_retornaPaginaFiltrada() throws Exception {
        mockMvc.perform(get("/api/ventas/pedidos-mesa")
                .param("page", "0")
                .param("size", "10")
                .param("meseroId", "1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/ventas/pedidos-mesa con filtro turnoId -> retorna página filtrada")
    void findAll_conFiltroTurno_retornaPaginaFiltrada() throws Exception {
        mockMvc.perform(get("/api/ventas/pedidos-mesa")
                .param("page", "0")
                .param("size", "10")
                .param("turnoId", "1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/ventas/pedidos-mesa con filtro flagEstado -> retorna página filtrada")
    void findAll_conFiltroEstado_retornaPaginaFiltrada() throws Exception {
        mockMvc.perform(get("/api/ventas/pedidos-mesa")
                .param("page", "0")
                .param("size", "10")
                .param("flagEstado", "1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/ventas/pedidos-mesa con todos los filtros -> retorna página filtrada")
    void findAll_conTodosFiltros_retornaPaginaFiltrada() throws Exception {
        mockMvc.perform(get("/api/ventas/pedidos-mesa")
                .param("page", "0")
                .param("size", "10")
                .param("sucursalId", "1")
                .param("mesaId", mesaId.toString())
                .param("meseroId", "1")
                .param("turnoId", "1")
                .param("flagEstado", "1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== GET /api/ventas/pedidos-mesa/{id} ====

    @Test
    @DisplayName("GET /api/ventas/pedidos-mesa/{id} con ID existente -> retorna detalle")
    void findById_cuandoExiste_retornaDetalle() throws Exception {
        mockMvc.perform(get("/api/ventas/pedidos-mesa/{id}", pedidoMesaId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").value(pedidoMesaId));
    }

    // ==== POST /api/ventas/pedidos-mesa ====

    @Test
    @DisplayName("POST /api/ventas/pedidos-mesa con datos válidos -> crea pedido")
    void create_conDatosValidos_creaPedido() throws Exception {
        ObjectNode request = objectMapper.createObjectNode();
        request.put("sucursalId", 1L);
        request.put("tipo", "LOCAL");
        request.put("mesaId", mesaId);
        request.put("meseroId", 1L);
        request.put("turnoId", 1L);
        request.put("numero", "PM-001");
        request.put("comensales", 4);
        request.put("apertura", LocalDateTime.now().toString());
        request.put("observaciones", "Pedido de prueba");

        mockMvc.perform(post("/api/ventas/pedidos-mesa")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== PUT /api/ventas/pedidos-mesa/{id} ====

    @Test
    @DisplayName("PUT /api/ventas/pedidos-mesa/{id} con datos válidos -> actualiza pedido")
    void update_conDatosValidos_actualizaPedido() throws Exception {
        ObjectNode request = objectMapper.createObjectNode();
        request.put("sucursalId", 1L);
        request.put("tipo", "LOCAL");
        request.put("mesaId", mesaId);
        request.put("meseroId", 1L);
        request.put("turnoId", 1L);
        request.put("numero", "PM-002");
        request.put("comensales", 6);
        request.put("apertura", LocalDateTime.now().toString());
        request.put("observaciones", "Pedido actualizado");

        mockMvc.perform(put("/api/ventas/pedidos-mesa/{id}", pedidoMesaId)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== POST /api/ventas/pedidos-mesa/{id}/cerrar ====

    @Test
    @DisplayName("POST /api/ventas/pedidos-mesa/{id}/cerrar -> cierra pedido")
    void cerrar_cuandoExiste_cierraPedido() throws Exception {
        mockMvc.perform(post("/api/ventas/pedidos-mesa/{id}/cerrar", pedidoMesaId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.message").value("Pedido cerrado"));
    }

    // ==== POST /api/ventas/pedidos-mesa/{id}/anular ====

    @Test
    @DisplayName("POST /api/ventas/pedidos-mesa/{id}/anular -> anula pedido")
    void anular_cuandoExiste_anulaPedido() throws Exception {
        mockMvc.perform(post("/api/ventas/pedidos-mesa/{id}/anular", pedidoMesaId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.message").value("Pedido anulado"));
    }

    // ==== PATCH /api/ventas/pedidos-mesa/{id}/activar ====

    @Test
    @DisplayName("PATCH /api/ventas/pedidos-mesa/{id}/activar -> activa pedido")
    void activate_cuandoExiste_activaPedido() throws Exception {
        mockMvc.perform(patch("/api/ventas/pedidos-mesa/{id}/activar", pedidoMesaId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.message").value("Pedido activado"));
    }

    // ==== PATCH /api/ventas/pedidos-mesa/{id}/desactivar ====

    @Test
    @DisplayName("PATCH /api/ventas/pedidos-mesa/{id}/desactivar -> desactiva pedido")
    void deactivate_cuandoExiste_desactivaPedido() throws Exception {
        mockMvc.perform(patch("/api/ventas/pedidos-mesa/{id}/desactivar", pedidoMesaId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.message").value("Pedido desactivado"));
    }

    // ==== DELETE /api/ventas/pedidos-mesa/{id} ====

    @Test
    @DisplayName("DELETE /api/ventas/pedidos-mesa/{id} -> elimina pedido")
    void delete_cuandoExiste_eliminaPedido() throws Exception {
        mockMvc.perform(delete("/api/ventas/pedidos-mesa/{id}", pedidoMesaId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.message").value("Pedido eliminado lógicamente"));
    }
}
