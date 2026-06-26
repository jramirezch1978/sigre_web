package pe.restaurant.ventas.integration;

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
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.ventas.dto.request.ReservacionRequest;
import pe.restaurant.ventas.testdata.VentasTestDataFactory;

import javax.sql.DataSource;
import java.time.LocalDate;
import java.time.LocalTime;

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
@DisplayName("Pruebas de Integración — ReservacionController")
class ReservacionControllerIntegrationTest {

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

    private ReservacionRequest baseRequest() {
        return ReservacionRequest.builder()
                .fecha(LocalDate.now().plusDays(1))
                .hora(LocalTime.of(20, 0))
                .comensales(4)
                .observaciones("test-integracion")
                .build();
    }

    // ── POST / — Crear ──

    @Test
    @DisplayName("POST / — debe crear reservación")
    void crear_DebeCrearReservacion() throws Exception {
        ReservacionRequest request = baseRequest();

        mockMvc.perform(post("/api/ventas/reservaciones")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.fecha").exists());
    }

    // ── GET / — Listar ──

    @Test
    @DisplayName("GET / — debe listar reservaciones")
    void listar_DebeRetornarPagina() throws Exception {
        mockMvc.perform(get("/api/ventas/reservaciones")
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.page.totalElements").isNumber());
    }

    // ── GET /{id} ──

    @Test
    @DisplayName("GET /{id} — debe obtener reservación creada")
    void obtenerPorId_DebeRetornarReservacion() throws Exception {
        String created = mockMvc.perform(post("/api/ventas/reservaciones")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        mockMvc.perform(get("/api/ventas/reservaciones/{id}", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.id").value(id));
    }

    @Test
    @DisplayName("GET /{id} — 404 si no existe")
    void obtenerPorId_Inexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/ventas/reservaciones/{id}", 99999999L)
                        .header("Authorization", authToken))
                .andExpect(status().isNotFound());
    }

    // ── PUT /{id} — Actualizar (solo CONFIRMADA) ──

    @Test
    @DisplayName("PUT /{id} — debe actualizar reservación")
    void actualizar_DebeModificar() throws Exception {
        String created = mockMvc.perform(post("/api/ventas/reservaciones")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        ReservacionRequest update = baseRequest();
        update.setComensales(6);
        update.setObservaciones("actualizado-test");

        mockMvc.perform(put("/api/ventas/reservaciones/{id}", id)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(update)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.observaciones").value("actualizado-test"));
    }

    // ── POST /{id}/confirmar ──

    @Test
    @DisplayName("POST /{id}/confirmar — debe confirmar reservación")
    void confirmar_DebeConfirmar() throws Exception {
        String created = mockMvc.perform(post("/api/ventas/reservaciones")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        mockMvc.perform(post("/api/ventas/reservaciones/{id}/confirmar", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.estado").value("CONFIRMADA"));
    }

    // ── POST /{id}/cancelar ──

    @Test
    @DisplayName("POST /{id}/cancelar — debe cancelar reservación")
    void cancelar_DebeCancelar() throws Exception {
        String created = mockMvc.perform(post("/api/ventas/reservaciones")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        mockMvc.perform(post("/api/ventas/reservaciones/{id}/cancelar", id)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.estado").value("CANCELADA"));
    }

    // ── PATCH activar/desactivar ──

    @Test
    @DisplayName("PATCH /{id}/desactivar — debe desactivar")
    void desactivar_DebeDesactivar() throws Exception {
        String created = mockMvc.perform(post("/api/ventas/reservaciones")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/ventas/reservaciones/{id}/desactivar", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk());

        entityManager.flush();
        String estado = jdbc.queryForObject(
                "SELECT flag_estado FROM ventas.reservacion WHERE id = ?", String.class, id);
        org.assertj.core.api.Assertions.assertThat(estado).isEqualTo("0");
    }

    @Test
    @DisplayName("PATCH /{id}/activar — debe activar")
    void activar_DebeActivar() throws Exception {
        String created = mockMvc.perform(post("/api/ventas/reservaciones")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(created).get("data").get("id").asLong();

        jdbc.update("UPDATE ventas.reservacion SET flag_estado = '0' WHERE id = ?", id);
        entityManager.flush();
        entityManager.clear();

        mockMvc.perform(patch("/api/ventas/reservaciones/{id}/activar", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }
}
