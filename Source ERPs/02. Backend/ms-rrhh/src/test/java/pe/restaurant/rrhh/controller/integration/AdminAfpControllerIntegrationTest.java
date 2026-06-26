package pe.restaurant.rrhh.controller.integration;

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
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.rrhh.testdata.RrhhTestDataExecutionListener;
import org.springframework.boot.test.mock.mockito.MockBean;
import pe.restaurant.common.security.JwtTokenProvider;
import static org.mockito.Mockito.when;

import javax.sql.DataSource;

import org.springframework.jdbc.core.JdbcTemplate;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para AdminAfpController con datos reales en base de datos.
 * 
 * <p>Sigue el estándar de testing del proyecto usando datos insertados en BD
 * en lugar de mocks para probar el flujo completo HTTP → Controller → Service → Repository → BD.</p>
 * 
 * @author Sistema de RRHH
 * @version 1.0
 */
@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {TenantContextTestExecutionListener.class, RrhhTestDataExecutionListener.class},
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - AdminAfpController")
class AdminAfpControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private String authToken;

    @MockBean
    private JwtTokenProvider jwtTokenProvider;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        when(jwtTokenProvider.validateToken("mock-token")).thenReturn(true);
        when(jwtTokenProvider.getEmpresaId("mock-token")).thenReturn(2L);
        when(jwtTokenProvider.getUserId("mock-token")).thenReturn(1L);
        when(jwtTokenProvider.getUsername("mock-token")).thenReturn("testuser");
        when(jwtTokenProvider.getClaim("mock-token", "authorities", String.class)).thenReturn("SCOPE_rrhh");
        when(jwtTokenProvider.getClaim("mock-token", "empresaId", Object.class)).thenReturn(2L);
        when(jwtTokenProvider.getClaim("mock-token", "sucursalId", Object.class)).thenReturn(1L);
        when(jwtTokenProvider.getClaim("mock-token", "userId", Object.class)).thenReturn(1L);

        // Generate mock auth token
        authToken = "Bearer mock-token";
    }

    // ==== GET /api/rrhh/admin-afp ====

    @Test
    @DisplayName("GET /api/rrhh/admin-afp - Debe listar AFP")
    void listar_Afps_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/rrhh/admin-afp")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/admin-afp?nombre=... - Debe filtrar por nombre")
    void listar_AfpsConFiltro_DebeRetornarFiltradas() throws Exception {
        String requestJson = """
            {
                "nombre": "AFP Test Filtro Integra",
                "comisionPorcentaje": 1.5500,
                "primaSeguro": 1.3600,
                "aporteObligatorio": 10.0000
            }
            """;

        mockMvc.perform(post("/api/rrhh/admin-afp")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated());

        mockMvc.perform(get("/api/rrhh/admin-afp")
                .header("Authorization", authToken)
                .param("nombre", "AFP Test Filtro Integra")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[0].nombre").value("AFP Test Filtro Integra"));
    }

    // ==== GET /api/rrhh/admin-afp/{id} ====

    @Test
    @DisplayName("GET /api/rrhh/admin-afp/{id} - Debe obtener AFP por ID")
    void obtener_Afp_DebeRetornarDatos() throws Exception {
        // Asumimos que TestDataSeederRrhh.insertó AFP con nombre "AFP Integra"
        mockMvc.perform(get("/api/rrhh/admin-afp/1")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.nombre").exists())
                .andExpect(jsonPath("$.data.comisionPorcentaje").exists());
    }

    @Test
    @DisplayName("GET /api/rrhh/admin-afp/{id} con ID inexistente - Debe retornar 404")
    void obtener_AfpNoExistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/rrhh/admin-afp/999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("RESOURCE_NOT_FOUND"));
    }

    // ==== POST /api/rrhh/admin-afp ====

    @Test
    @DisplayName("POST /api/rrhh/admin-afp - Debe crear AFP")
    void crear_Afp_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "nombre": "AFP Test Nueva",
                "comisionPorcentaje": 1.4500,
                "primaSeguro": 1.3600,
                "aporteObligatorio": 10.0000
            }
            """;

        mockMvc.perform(post("/api/rrhh/admin-afp")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("AFP Test Nueva"))
                .andExpect(jsonPath("$.data.comisionPorcentaje").value(1.4500))
                ;
    }

    @Test
    @DisplayName("POST /api/rrhh/admin-afp con nombre duplicado - Debe retornar 409")
    void crear_AfpNombreDuplicado_DebeRetornar409() throws Exception {
        String requestJson = """
            {
                "nombre": "AFP Test Duplicado",
                "comisionPorcentaje": 1.5500,
                "primaSeguro": 1.3600,
                "aporteObligatorio": 10.0000
            }
            """;

        mockMvc.perform(post("/api/rrhh/admin-afp")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true));

        mockMvc.perform(post("/api/rrhh/admin-afp")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isConflict())
            .andExpect(jsonPath("$.success").value(false))
            .andExpect(jsonPath("$.message").value("Ya existe una AFP con ese nombre."));
    }

    @Test
    @DisplayName("POST /api/rrhh/admin-afp con nombre vacío - Debe retornar 400")
    void crear_AfpNombreVacio_DebeRetornar400() throws Exception {
        String requestJson = """
            {
                "nombre": "",
                "comisionPorcentaje": 1.5500,
                "primaSeguro": 1.3600,
                "aporteObligatorio": 10.0000
            }
            """;

        mockMvc.perform(post("/api/rrhh/admin-afp")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/rrhh/admin-afp/{id} con ID inexistente - Debe retornar 404")
    void actualizar_AfpNoExistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "nombre": "AFP Test",
                "comisionPorcentaje": 1.5500,
                "primaSeguro": 1.3600,
                "aporteObligatorio": 10.0000
            }
            """;

        mockMvc.perform(put("/api/rrhh/admin-afp/999")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("RESOURCE_NOT_FOUND"));
    }

    @Test
    @DisplayName("PUT /api/rrhh/admin-afp/{id} con nombre duplicado - Debe retornar 409")
    void actualizar_AfpNombreDuplicado_DebeRetornar409() throws Exception {
        String afpUno = """
            {
                "nombre": "AFP Test Update Alpha",
                "comisionPorcentaje": 1.5500,
                "primaSeguro": 1.3600,
                "aporteObligatorio": 10.0000
            }
            """;

        String responseUno = mockMvc.perform(post("/api/rrhh/admin-afp")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(afpUno))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long idUno = objectMapper.readTree(responseUno).get("data").get("id").asLong();

        String afpDos = """
            {
                "nombre": "AFP Test Update Beta",
                "comisionPorcentaje": 1.6000,
                "primaSeguro": 1.3700,
                "aporteObligatorio": 10.5000
            }
            """;

        String responseDos = mockMvc.perform(post("/api/rrhh/admin-afp")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(afpDos))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long idDos = objectMapper.readTree(responseDos).get("data").get("id").asLong();

        String renameToDuplicate = """
            {
                "nombre": "AFP Test Update Beta",
                "comisionPorcentaje": 1.6500,
                "primaSeguro": 1.3800,
                "aporteObligatorio": 10.8000
            }
            """;

        mockMvc.perform(put("/api/rrhh/admin-afp/{id}", idUno)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(renameToDuplicate))
            .andExpect(status().isConflict())
            .andExpect(jsonPath("$.success").value(false));
    }

    // ==== PATCH /api/rrhh/admin-afp/{id}/desactivar ====

    @Test
    @DisplayName("PATCH /api/rrhh/admin-afp/{id}/desactivar - Debe desactivar AFP sin asignados")
    void desactivar_AfpSinAsignados_DebeDesactivar() throws Exception {
        mockMvc.perform(patch("/api/rrhh/admin-afp/2/desactivar")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/admin-afp/{id}/desactivar con ID inexistente - Debe retornar 404")
    void desactivar_AfpNoExistente_DebeRetornar404() throws Exception {
        mockMvc.perform(patch("/api/rrhh/admin-afp/999/desactivar")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/admin-afp/{id}/desactivar con asignados - Debe retornar 400")
    void desactivar_AfpConAsignados_DebeRetornar400() throws Exception {
        String requestJson = """
            {
                "nombre": "AFP Test Con Asignados",
                "comisionPorcentaje": 1.5500,
                "primaSeguro": 1.3600,
                "aporteObligatorio": 10.0000
            }
            """;

        String response = mockMvc.perform(post("/api/rrhh/admin-afp")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long afpId = objectMapper.readTree(response).get("data").get("id").asLong();

        String ts = String.valueOf(System.currentTimeMillis());
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        // Asegurar que entidad_contribuyente_id=1 exista (requerido por FK_TRABAJADOR_01)
        Integer count = jdbc.queryForObject(
            "SELECT COUNT(*) FROM core.entidad_contribuyente WHERE id = 1", Integer.class);
        if (count == null || count == 0) {
            jdbc.update("""
                INSERT INTO core.entidad_contribuyente
                (id, tipo_persona, tipo_documento, nro_documento, razon_social,
                 es_proveedor, es_cliente, es_empleado, flag_estado, created_by, fec_creacion)
                VALUES (1, 'JURIDICA', 'RUC', '20123456789', 'PROVEEDOR DEMO S.A.C.',
                        TRUE, FALSE, FALSE, '1', 1, NOW())
                """);
        }
        jdbc.update("""
            INSERT INTO rrhh.trabajador (codigo_trabajador, nombres, entidad_contribuyente_id, admin_afp_id, created_by, fec_creacion)
            VALUES (?, ?, 1, ?, 1, NOW())
            """, "TST-" + ts, "Trabajador Test " + ts, afpId);

        mockMvc.perform(patch("/api/rrhh/admin-afp/{id}/desactivar", afpId)
                .header("Authorization", authToken))
            .andExpect(status().isConflict())
            .andExpect(jsonPath("$.success").value(false));
    }
}
