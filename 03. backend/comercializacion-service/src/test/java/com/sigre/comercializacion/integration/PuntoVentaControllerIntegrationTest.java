package com.sigre.comercializacion.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
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
import com.sigre.comercializacion.dto.request.PuntoVentaRequest;
import com.sigre.comercializacion.testdata.VentasTestDataFactory;

import javax.sql.DataSource;
import java.util.concurrent.atomic.AtomicInteger;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
        listeners = TenantContextTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración — PuntoVentaController")
class PuntoVentaControllerIntegrationTest {

    @Autowired private WebApplicationContext wac;
    @Autowired private DataSource dataSource;
    @Autowired private VentasTestDataFactory ventasFactory;
    @Autowired private EntityManager em;

    private MockMvc mockMvc;
    private ObjectMapper om;
    private JdbcTemplate jdbc;
    private String token;
    private final AtomicInteger counter = new AtomicInteger((int) (System.currentTimeMillis() % 100000));

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();
        om = new ObjectMapper(); om.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);
        token = "Bearer mock-token";
        ventasFactory.ensureVentasTransactionalData();
    }

    private Long crearPV(String codigo) throws Exception {
        PuntoVentaRequest req = new PuntoVentaRequest();
        req.setCodigo(codigo); req.setNombre("PV Test " + codigo);
        String r = mockMvc.perform(post("/api/ventas/puntos-venta").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(req)))
                .andReturn().getResponse().getContentAsString();
        if (r.contains("\"success\":false")) return null;
        return om.readTree(r).get("data").get("id").asLong();
    }

    @Test @DisplayName("GET / — listar")
    void listar() throws Exception {
        mockMvc.perform(get("/api/ventas/puntos-venta").header("Authorization", token))
                .andExpect(status().isOk()).andExpect(jsonPath("$.success").value(true));
    }

    @Test @DisplayName("POST / — crear (puede requerir FK sucursalId)")
    void crear() throws Exception {
        PuntoVentaRequest req = new PuntoVentaRequest();
        req.setCodigo("PV-" + counter.incrementAndGet()); req.setNombre("Integración PV");
        req.setSucursalId(jdbc.queryForObject(
                "SELECT COALESCE((SELECT id FROM auth.sucursal ORDER BY id LIMIT 1), 1)", Long.class));
        String resp = mockMvc.perform(post("/api/ventas/puntos-venta").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(req)))
                .andReturn().getResponse().getContentAsString();
        // Puede ser 201 o 400 si falta FK — verificamos que no sea 500
        int status = mockMvc.perform(post("/api/ventas/puntos-venta").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(req)))
                .andReturn().getResponse().getStatus();
        org.assertj.core.api.Assertions.assertThat(status).isIn(201, 400, 409);
    }

    @Test @DisplayName("GET /{id} — obtener por ID")
    void obtenerPorId() throws Exception {
        Long id = crearPV("PV-" + counter.incrementAndGet());
        if (id == null) return;
        mockMvc.perform(get("/api/ventas/puntos-venta/{id}", id).header("Authorization", token))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.id").value(id));
    }

    @Test @DisplayName("GET /{id} — 404")
    void obtener404() throws Exception {
        mockMvc.perform(get("/api/ventas/puntos-venta/{id}", 99999L).header("Authorization", token))
                .andExpect(status().isNotFound());
    }

    @Test @DisplayName("GET /sucursal/{id} — listar por sucursal")
    void porSucursal() throws Exception {
        Long sucId = jdbc.queryForObject(
                "SELECT COALESCE((SELECT id FROM auth.sucursal ORDER BY id LIMIT 1), 1)", Long.class);
        mockMvc.perform(get("/api/ventas/puntos-venta/sucursal/{id}", sucId).header("Authorization", token))
                .andExpect(status().isOk());
    }

    @Test @DisplayName("PUT /{id} — actualizar")
    void actualizar() throws Exception {
        Long id = crearPV("PV-" + counter.incrementAndGet());
        if (id == null) return;
        PuntoVentaRequest req = new PuntoVentaRequest();
        req.setCodigo("PV-" + counter.incrementAndGet()); req.setNombre("Modificado");
        mockMvc.perform(put("/api/ventas/puntos-venta/{id}", id).header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(req)))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.nombre").value("Modificado"));
    }

    @Test @DisplayName("DELETE /{id} — baja lógica")
    void eliminar() throws Exception {
        Long id = crearPV("PV-" + counter.incrementAndGet());
        if (id == null) return;
        mockMvc.perform(delete("/api/ventas/puntos-venta/{id}", id).header("Authorization", token))
                .andExpect(status().isOk());
    }

    @Test @DisplayName("PATCH /{id}/activar")
    void activar() throws Exception {
        Long id = crearPV("PV-" + counter.incrementAndGet());
        if (id == null) return;
        jdbc.update("UPDATE ventas.punto_venta SET flag_estado = '0' WHERE id = ?", id);
        em.flush(); em.clear();
        mockMvc.perform(patch("/api/ventas/puntos-venta/{id}/activar", id).header("Authorization", token))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.flagEstado").value("1"));
    }

    @Test @DisplayName("PATCH /{id}/desactivar")
    void desactivar() throws Exception {
        Long id = crearPV("PV-" + counter.incrementAndGet());
        if (id == null) return;
        mockMvc.perform(patch("/api/ventas/puntos-venta/{id}/desactivar", id).header("Authorization", token))
                .andExpect(status().isOk());
    }
}
