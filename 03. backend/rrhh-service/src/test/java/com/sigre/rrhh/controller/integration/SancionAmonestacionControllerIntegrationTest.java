package com.sigre.rrhh.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.rrhh.testdata.RrhhTestDataExecutionListener;
import org.springframework.boot.test.mock.mockito.MockBean;
import com.sigre.common.security.JwtTokenProvider;
import static org.mockito.Mockito.when;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {TenantContextTestExecutionListener.class, RrhhTestDataExecutionListener.class},
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - SancionAmonestacionController")
class SancionAmonestacionControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

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

        authToken = "Bearer mock-token";
    }

    private Long crearTrabajadorHelper() throws Exception {
        String codigo = "TST-" + System.nanoTime();
        String requestJson = """
            {
                "codigoTrabajador": "%s",
                "nombres": "Test",
                "apellidoPaterno": "Sancion",
                "numeroDocumento": "%d"
            }
            """.formatted(codigo, (int) (Math.random() * 100000000));

        String response = mockMvc.perform(post("/api/rrhh/trabajadores")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private Long crearTipoSancionHelper() throws Exception {
        String codigo = "TS-" + System.nanoTime();
        String requestJson = """
            {
                "codigo": "%s",
                "nombre": "Tipo Test"
            }
            """.formatted(codigo);

        String response = mockMvc.perform(post("/api/rrhh/tipos-sancion")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    @Test
    @DisplayName("GET /api/rrhh/sanciones - Debe listar sanciones")
    void listarSanciones_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/rrhh/sanciones")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/sanciones/{id} - Debe obtener sanción por ID")
    void obtenerSancion_DebeRetornarDatos() throws Exception {
        Long trabajadorId = crearTrabajadorHelper();
        Long tipoSancionId = crearTipoSancionHelper();

        String requestJson = """
            {
                "trabajadorId": %d,
                "tipoSancionId": %d,
                "fecha": "2026-06-01",
                "motivo": "Retraso injustificado"
            }
            """.formatted(trabajadorId, tipoSancionId);

        String response = mockMvc.perform(post("/api/rrhh/sanciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long sancionId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/rrhh/sanciones/{id}", sancionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(sancionId))
                .andExpect(jsonPath("$.data.trabajadorId").value(trabajadorId))
                .andExpect(jsonPath("$.data.tipoSancionId").value(tipoSancionId))
                .andExpect(jsonPath("$.data.motivo").value("Retraso injustificado"));
    }

    @Test
    @DisplayName("POST /api/rrhh/sanciones - Debe crear sanción")
    void crearSancion_DebeCrearYRetornar() throws Exception {
        Long trabajadorId = crearTrabajadorHelper();
        Long tipoSancionId = crearTipoSancionHelper();

        String requestJson = """
            {
                "trabajadorId": %d,
                "tipoSancionId": %d,
                "fecha": "2026-06-01",
                "motivo": "Falta de respeto a compañeros"
            }
            """.formatted(trabajadorId, tipoSancionId);

        mockMvc.perform(post("/api/rrhh/sanciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.trabajadorId").value(trabajadorId))
                .andExpect(jsonPath("$.data.tipoSancionId").value(tipoSancionId))
                .andExpect(jsonPath("$.data.motivo").value("Falta de respeto a compañeros"));
    }

    @Test
    @DisplayName("PUT /api/rrhh/sanciones/{id} - Debe actualizar sanción existente")
    void actualizarSancion_DebeActualizarYRetornar() throws Exception {
        Long trabajadorId = crearTrabajadorHelper();
        Long tipoSancionId = crearTipoSancionHelper();

        String requestJson = """
            {
                "trabajadorId": %d,
                "tipoSancionId": %d,
                "fecha": "2026-06-01",
                "motivo": "Llegada tarde"
            }
            """.formatted(trabajadorId, tipoSancionId);

        String response = mockMvc.perform(post("/api/rrhh/sanciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long sancionId = objectMapper.readTree(response).get("data").get("id").asLong();

        String requestActualizado = """
            {
                "motivo": "Llegada tarde - actualizado"
            }
            """;

        mockMvc.perform(put("/api/rrhh/sanciones/{id}", sancionId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(sancionId))
                .andExpect(jsonPath("$.data.motivo").value("Llegada tarde - actualizado"));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/sanciones/{id}/desactivar - Debe desactivar sanción")
    void desactivarSancion_DebeDesactivarYRetornar() throws Exception {
        Long trabajadorId = crearTrabajadorHelper();
        Long tipoSancionId = crearTipoSancionHelper();

        String requestJson = """
            {
                "trabajadorId": %d,
                "tipoSancionId": %d,
                "fecha": "2026-06-01",
                "motivo": "Incumplimiento de normas"
            }
            """.formatted(trabajadorId, tipoSancionId);

        String response = mockMvc.perform(post("/api/rrhh/sanciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long sancionId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/rrhh/sanciones/{id}/desactivar", sancionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/sanciones/{id} - Debe retornar 404 con ID inexistente")
    void obtenerSancion_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/rrhh/sanciones/9999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/rrhh/sanciones/{id} - Debe retornar 404 con ID inexistente")
    void actualizarSancion_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "motivo": "No existe"
            }
            """;

        mockMvc.perform(put("/api/rrhh/sanciones/9999")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/sanciones/{id}/desactivar - Debe retornar 404 con ID inexistente")
    void desactivarSancion_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(patch("/api/rrhh/sanciones/9999/desactivar")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }
}
