package com.sigre.comercializacion.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.persistence.EntityManager;
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
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.comercializacion.dto.request.PropinaRequest;
import com.sigre.comercializacion.testdata.VentasTestDataFactory;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
        listeners = TenantContextTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración — PropinaController")
class PropinaControllerIntegrationTest {

    @Autowired private WebApplicationContext webApplicationContext;
    @Autowired private DataSource dataSource;
    @Autowired private VentasTestDataFactory ventasFactory;
    @Autowired private EntityManager entityManager;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private JdbcTemplate jdbc;
    private String authToken;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);
        authToken = "Bearer mock-token";
        ventasFactory.ensureVentasTransactionalData();

        // La factory puede no crear facturas si las tablas externas están vacías.
        // Insertamos una factura mínima para que los tests de propina tengan FK.
        ensureMinimalFactura();
    }

    private void ensureMinimalFactura() {
        Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM ventas.fs_factura_simpl WHERE flag_estado = '1'",
                Integer.class);
        if (count != null && count > 0) return;

        // Intentar con IDs que la factory ya sembró (ensureEntidadContribuyente)
        Long sucursalId = jdbc.queryForObject(
                "SELECT COALESCE((SELECT id FROM auth.sucursal ORDER BY id LIMIT 1), 1)", Long.class);
        Long clienteId = jdbc.queryForObject(
                "SELECT COALESCE((SELECT id FROM core.entidad_contribuyente WHERE id = 2), 1)", Long.class);

        try {
            jdbc.update("""
                INSERT INTO ventas.fs_factura_simpl (
                    sucursal_id, cliente_id, doc_tipo_id, serie, numero, fecha_emision,
                    moneda_id, subtotal, impuesto, total, flag_estado, created_by, fec_creacion
                ) VALUES (?, ?, 1, 'T001', '00000001', CURRENT_DATE, 1, 100.00, 18.00, 118.00, '1', 1, NOW())
                """, sucursalId, clienteId);
        } catch (Exception e) {
            // Si falla, el test usará lo que pueda encontrar
        }
    }

    private Long getFacturaSimplId() {
        return jdbc.queryForObject(
                "SELECT id FROM ventas.fs_factura_simpl WHERE flag_estado = '1' ORDER BY id LIMIT 1",
                Long.class);
    }

    // ── GET / — Listar ──

    @Test
    @DisplayName("GET / — debe listar propinas con paginación")
    void listar_DebeRetornarPagina() throws Exception {
        mockMvc.perform(get("/api/ventas/propinas")
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").isNumber());
    }

    // ── POST / — Crear ──

    @Test
    @DisplayName("POST / — debe crear propina vinculada a factura")
    void crear_DebeCrearPropina() throws Exception {
        Long fsId = getFacturaSimplId();
        PropinaRequest request = PropinaRequest.builder()
                .fsFacturaSimplId(fsId)
                .monto(new BigDecimal("15.5000"))
                .fecha(LocalDate.now())
                .build();

        mockMvc.perform(post("/api/ventas/propinas")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.monto").value(15.50));
    }

    // ── GET /{id} ──

    @Test
    @DisplayName("GET /{id} — debe obtener propina creada")
    void obtenerPorId_DebeRetornarPropina() throws Exception {
        Long fsId = getFacturaSimplId();

        // Crear primero
        PropinaRequest req = PropinaRequest.builder()
                .fsFacturaSimplId(fsId)
                .monto(new BigDecimal("20.0000")).fecha(LocalDate.now()).build();

        String created = mockMvc.perform(post("/api/ventas/propinas")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        mockMvc.perform(get("/api/ventas/propinas/{id}", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.id").value(id))
                .andExpect(jsonPath("$.data.monto").value(20.00));
    }

    @Test
    @DisplayName("GET /{id} — 404 si no existe")
    void obtenerPorId_Inexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/ventas/propinas/{id}", 99999999L)
                        .header("Authorization", authToken))
                .andExpect(status().isNotFound());
    }

    // ── PUT /{id} — Actualizar ──

    @Test
    @DisplayName("PUT /{id} — debe actualizar propina")
    void actualizar_DebeModificarPropina() throws Exception {
        Long fsId = getFacturaSimplId();

        PropinaRequest createReq = PropinaRequest.builder()
                .fsFacturaSimplId(fsId)
                .monto(new BigDecimal("10.0000")).fecha(LocalDate.now()).build();

        String created = mockMvc.perform(post("/api/ventas/propinas")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(createReq)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        PropinaRequest updateReq = PropinaRequest.builder()
                .fsFacturaSimplId(fsId)
                .monto(new BigDecimal("25.0000")).fecha(LocalDate.now()).build();

        mockMvc.perform(put("/api/ventas/propinas/{id}", id)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(updateReq)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.monto").value(25.00));
    }

    @Test
    @DisplayName("PUT /{id} — 404 si no existe")
    void actualizar_Inexistente_DebeRetornar404() throws Exception {
        PropinaRequest req = PropinaRequest.builder()
                .fsFacturaSimplId(1L)
                .monto(BigDecimal.TEN).fecha(LocalDate.now()).build();

        mockMvc.perform(put("/api/ventas/propinas/{id}", 99999999L)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isNotFound());
    }

    // ── PATCH activar/desactivar ──

    @Test
    @DisplayName("PATCH /{id}/desactivar — debe desactivar propina")
    void desactivar_DebeDesactivar() throws Exception {
        Long fsId = getFacturaSimplId();

        PropinaRequest req = PropinaRequest.builder()
                .fsFacturaSimplId(fsId)
                .monto(new BigDecimal("5.0000")).fecha(LocalDate.now()).build();

        String created = mockMvc.perform(post("/api/ventas/propinas")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/ventas/propinas/{id}/desactivar", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        entityManager.flush();
        String estado = jdbc.queryForObject(
                "SELECT flag_estado FROM ventas.propina WHERE id = ?", String.class, id);
        assertThat(estado).isEqualTo("0");
    }

    @Test
    @DisplayName("PATCH /{id}/activar — debe activar propina")
    void activar_DebeActivar() throws Exception {
        Long fsId = getFacturaSimplId();

        PropinaRequest req = PropinaRequest.builder()
                .fsFacturaSimplId(fsId)
                .monto(new BigDecimal("5.0000")).fecha(LocalDate.now()).build();

        String created = mockMvc.perform(post("/api/ventas/propinas")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        // Desactivar vía JDBC
        jdbc.update("UPDATE ventas.propina SET flag_estado = '0' WHERE id = ?", id);
        entityManager.flush();
        entityManager.clear();

        mockMvc.perform(patch("/api/ventas/propinas/{id}/activar", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }
}
