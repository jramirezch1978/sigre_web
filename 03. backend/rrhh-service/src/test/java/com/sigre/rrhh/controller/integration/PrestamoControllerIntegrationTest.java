package com.sigre.rrhh.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import org.springframework.boot.test.mock.mockito.MockBean;
import com.sigre.common.security.JwtTokenProvider;
import static org.mockito.Mockito.when;

import javax.sql.DataSource;
import org.springframework.jdbc.core.JdbcTemplate;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = TenantContextTestExecutionListener.class,
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - PrestamoController")
class PrestamoControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private String authToken;
    private Long trabajadorId;

    @MockBean
    private JwtTokenProvider jwtTokenProvider;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        trabajadorId = ensureTrabajador();

        when(jwtTokenProvider.validateToken("mock-token")).thenReturn(true);
        when(jwtTokenProvider.getEmpresaId("mock-token")).thenReturn(2L);
        when(jwtTokenProvider.getUserId("mock-token")).thenReturn(1L);
        when(jwtTokenProvider.getUsername("mock-token")).thenReturn("testuser");
        when(jwtTokenProvider.getClaim("mock-token", "authorities", String.class)).thenReturn("SCOPE_rrhh");
        when(jwtTokenProvider.getClaim("mock-token", "empresaId", Object.class)).thenReturn(2L);
        when(jwtTokenProvider.getClaim("mock-token", "sucursalId", Object.class)).thenReturn(1L);
        when(jwtTokenProvider.getClaim("mock-token", "userId", Object.class)).thenReturn(1L);

        authToken = "Bearer mock-token";
    }

    @Test
    @DisplayName("GET /api/rrhh/prestamos -> retorna lista")
    void listar_retornaLista() throws Exception {
        mockMvc.perform(get("/api/rrhh/prestamos")
                        .header("Authorization", authToken)
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("POST -> GET -> PUT -> PATCH estado flujo completo CRUD")
    void flujoCRUD_completo() throws Exception {
        String crearJson = """
                {
                    "trabajadorId": %d,
                    "montoTotal": 5000.0000,
                    "cuotas": 10
                }
                """.formatted(trabajadorId);

        String response = mockMvc.perform(post("/api/rrhh/prestamos")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(crearJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.montoTotal").value(5000.0))
                .andExpect(jsonPath("$.data.cuotas").value(10))
                .andExpect(jsonPath("$.data.cuotaMensual").value(500.0))
                .andExpect(jsonPath("$.data.saldo").value(5000.0))
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/rrhh/prestamos/{id}", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(id));

        String actualizarJson = """
                {
                    "montoTotal": 6000.0000,
                    "cuotas": 12
                }
                """;

        mockMvc.perform(put("/api/rrhh/prestamos/{id}", id)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(actualizarJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.montoTotal").value(6000.0));

        mockMvc.perform(patch("/api/rrhh/prestamos/{id}/estado", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("POST /api/rrhh/prestamos con cuotas inválidas -> 400")
    void crear_cuotasInvalidas_retorna400() throws Exception {
        String json = """
                {
                    "trabajadorId": 1,
                    "montoTotal": 1000.0000,
                    "cuotas": 0
                }
                """;

        mockMvc.perform(post("/api/rrhh/prestamos")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("GET /api/rrhh/prestamos/9999 -> 404")
    void obtenerPorId_idInexistente_retorna404() throws Exception {
        mockMvc.perform(get("/api/rrhh/prestamos/{id}", 9999)
                        .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    private Long ensureTrabajador() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        Integer count = jdbc.queryForObject(
                "SELECT COUNT(*) FROM core.entidad_contribuyente WHERE id = 1", Integer.class);
        if (count == null || count == 0) {
            jdbc.update("""
                INSERT INTO core.entidad_contribuyente
                (id, tipo_persona, tipo_documento, nro_documento, razon_social,
                 es_proveedor, es_cliente, es_empleado, flag_estado, created_by, fec_creacion)
                VALUES (1, 'JURIDICA', 'RUC', '20123456789', 'TRABAJADOR DEMO S.A.C.',
                        TRUE, FALSE, FALSE, '1', 1, NOW())
                """);
        }
        String codigo = "TST-PRESTAMO-" + (System.currentTimeMillis() % 100000);
        jdbc.update("""
            INSERT INTO rrhh.trabajador (codigo_trabajador, nombres, entidad_contribuyente_id, created_by, fec_creacion)
            VALUES (?, 'Trabajador Prestamo', 1, 1, NOW())
            """, codigo);
        return jdbc.queryForObject("SELECT id FROM rrhh.trabajador WHERE codigo_trabajador = ?", Long.class, codigo);
    }
}
