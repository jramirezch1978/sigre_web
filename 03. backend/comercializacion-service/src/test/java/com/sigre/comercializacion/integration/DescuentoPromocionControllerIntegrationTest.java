package com.sigre.comercializacion.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
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
import jakarta.persistence.EntityManager;
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.comercializacion.dto.request.DescuentoPromocionRequest;
import com.sigre.comercializacion.testdata.VentasTestDataFactory;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para DescuentoPromocionController con datos reales en BD.
 * CRUD simple + activar/desactivar, sin FK externas, sin Feign clients.
 */
@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
        listeners = TenantContextTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración — DescuentoPromocionController")
class DescuentoPromocionControllerIntegrationTest {

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
    }

    // ─────────────────────────────────────────────
    // GET / — Listar
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("GET / — debe listar promociones con paginación")
    void listar_DebeRetornarPagina() throws Exception {
        mockMvc.perform(get("/api/ventas/descuentos-promocion")
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").isNumber());
    }

    @Test
    @DisplayName("GET /?nombre= — debe filtrar por nombre")
    void listar_FiltrarPorNombre_DebeRetornarFiltrado() throws Exception {
        mockMvc.perform(get("/api/ventas/descuentos-promocion")
                        .header("Authorization", authToken)
                        .param("nombre", "PROMO-FACTORY"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.content[0].nombre").value("PROMO-FACTORY-001"));
    }

    // ─────────────────────────────────────────────
    // GET /{id} — Obtener por ID
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("GET /{id} — debe obtener promoción por ID")
    void obtenerPorId_DebeRetornarPromocion() throws Exception {
        Long id = jdbc.queryForObject(
                "SELECT id FROM ventas.descuento_promocion WHERE nombre = 'PROMO-FACTORY-001' LIMIT 1",
                Long.class);
        assertThat(id).isNotNull();

        mockMvc.perform(get("/api/ventas/descuentos-promocion/{id}", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(id))
                .andExpect(jsonPath("$.data.nombre").value("PROMO-FACTORY-001"))
                .andExpect(jsonPath("$.data.tipo").value("PCT"));
    }

    @Test
    @DisplayName("GET /{id} — 404 si no existe")
    void obtenerPorId_Inexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/ventas/descuentos-promocion/{id}", 99999999L)
                        .header("Authorization", authToken))
                .andExpect(status().isNotFound());
    }

    // ─────────────────────────────────────────────
    // POST / — Crear
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("POST / — debe crear promoción")
    void crear_DebeCrearPromocion() throws Exception {
        DescuentoPromocionRequest request = DescuentoPromocionRequest.builder()
                .nombre("TEST-INTEGRACION-PROMO")
                .tipo("PCT")
                .valor(new BigDecimal("15.0000"))
                .fechaInicio(LocalDate.now())
                .fechaFin(LocalDate.now().plusMonths(3))
                .montoMinimo(new BigDecimal("50.0000"))
                .build();

        String response = mockMvc.perform(post("/api/ventas/descuentos-promocion")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("TEST-INTEGRACION-PROMO"))
                .andExpect(jsonPath("$.data.tipo").value("PCT"))
                .andExpect(jsonPath("$.data.valor").value(15.00))
                .andReturn().getResponse().getContentAsString();

        // Verificar en BD
        Long id = objectMapper.readTree(response).get("data").get("id").asLong();
        Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM ventas.descuento_promocion WHERE id = ? AND nombre = 'TEST-INTEGRACION-PROMO'",
                Integer.class, id);
        assertThat(count).isEqualTo(1);
    }

    // ─────────────────────────────────────────────
    // PUT /{id} — Actualizar
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("PUT /{id} — debe actualizar promoción existente")
    void actualizar_DebeModificarPromocion() throws Exception {
        Long id = jdbc.queryForObject(
                "SELECT id FROM ventas.descuento_promocion WHERE nombre = 'PROMO-FACTORY-001' LIMIT 1",
                Long.class);

        DescuentoPromocionRequest request = DescuentoPromocionRequest.builder()
                .nombre("PROMO-FACTORY-001-MODIFICADO")
                .tipo("MONTO_FIJO")
                .valor(new BigDecimal("25.0000"))
                .fechaInicio(LocalDate.now())
                .fechaFin(LocalDate.now().plusMonths(6))
                .build();

        mockMvc.perform(put("/api/ventas/descuentos-promocion/{id}", id)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.nombre").value("PROMO-FACTORY-001-MODIFICADO"))
                .andExpect(jsonPath("$.data.tipo").value("MONTO_FIJO"));
    }

    @Test
    @DisplayName("PUT /{id} — 404 si no existe")
    void actualizar_Inexistente_DebeRetornar404() throws Exception {
        DescuentoPromocionRequest request = DescuentoPromocionRequest.builder()
                .nombre("X").tipo("PCT").valor(BigDecimal.ONE)
                .fechaInicio(LocalDate.now()).fechaFin(LocalDate.now().plusDays(1))
                .build();

        mockMvc.perform(put("/api/ventas/descuentos-promocion/{id}", 99999999L)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isNotFound());
    }

    // ─────────────────────────────────────────────
    // DELETE /{id} — Baja lógica
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("DELETE /{id} — debe hacer baja lógica")
    void eliminar_DebeHacerBajaLogica() throws Exception {
        Long id = jdbc.queryForObject(
                "SELECT id FROM ventas.descuento_promocion WHERE nombre = 'PROMO-FACTORY-001' LIMIT 1",
                Long.class);

        mockMvc.perform(delete("/api/ventas/descuentos-promocion/{id}", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        // Forzar flush de JPA a BD antes de consultar con JDBC
        entityManager.flush();

        String estado = jdbc.queryForObject(
                "SELECT flag_estado FROM ventas.descuento_promocion WHERE id = ?",
                String.class, id);
        assertThat(estado).isEqualTo("0");
    }

    // ─────────────────────────────────────────────
    // PATCH /{id}/activar y /desactivar
    // ─────────────────────────────────────────────

    @Test
    @DisplayName("PATCH /{id}/activar — debe activar promoción")
    void activar_DebeActivar() throws Exception {
        Long id = jdbc.queryForObject(
                "SELECT id FROM ventas.descuento_promocion WHERE nombre = 'PROMO-FACTORY-001' LIMIT 1",
                Long.class);

        // Desactivar primero vía JDBC directo
        jdbc.update("UPDATE ventas.descuento_promocion SET flag_estado = '0' WHERE id = ?", id);
        entityManager.flush();
        entityManager.clear(); // desvincular de la caché de JPA

        mockMvc.perform(patch("/api/ventas/descuentos-promocion/{id}/activar", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }

    @Test
    @DisplayName("PATCH /{id}/desactivar — debe desactivar promoción")
    void desactivar_DebeDesactivar() throws Exception {
        Long id = jdbc.queryForObject(
                "SELECT id FROM ventas.descuento_promocion WHERE nombre = 'PROMO-FACTORY-001' LIMIT 1",
                Long.class);

        mockMvc.perform(patch("/api/ventas/descuentos-promocion/{id}/desactivar", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        // Forzar flush antes de verificar con JDBC
        entityManager.flush();

        String estado = jdbc.queryForObject(
                "SELECT flag_estado FROM ventas.descuento_promocion WHERE id = ?",
                String.class, id);
        assertThat(estado).isEqualTo("0");
    }
}
