package pe.restaurant.rrhh.controller.integration;

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
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import org.springframework.boot.test.mock.mockito.MockBean;
import pe.restaurant.common.security.JwtTokenProvider;
import static org.mockito.Mockito.when;

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
@DisplayName("Pruebas de Integración - TipoPlanillaController")
class TipoPlanillaControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private String authToken;

    @MockBean
    private JwtTokenProvider jwtTokenProvider;

    @BeforeEach
    void setUp() {
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

    @Test
    @DisplayName("GET /api/rrhh/tipos-planilla -> retorna lista paginada")
    void listar_retornaLista() throws Exception {
        mockMvc.perform(get("/api/rrhh/tipos-planilla")
                        .header("Authorization", authToken)
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("POST -> GET -> PUT -> DELETE flujo completo CRUD")
    void flujoCRUD_completo() throws Exception {
        String crearJson = """
                {
                    "codigo": "X",
                    "nombre": "TipoPlanilla Test"
                }
                """;

        String response = mockMvc.perform(post("/api/rrhh/tipos-planilla")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(crearJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.codigo").value("X"))
                .andExpect(jsonPath("$.data.nombre").value("TipoPlanilla Test"))
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/rrhh/tipos-planilla/{id}", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(id))
                .andExpect(jsonPath("$.data.codigo").value("X"));

        String actualizarJson = """
                {
                    "nombre": "TipoPlanilla Test Actualizado"
                }
                """;

        mockMvc.perform(put("/api/rrhh/tipos-planilla/{id}", id)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(actualizarJson))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("TipoPlanilla Test Actualizado"));

        mockMvc.perform(patch("/api/rrhh/tipos-planilla/{id}/desactivar", id)
                        .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("POST /api/rrhh/tipos-planilla con código duplicado -> 409")
    void crear_codigoDuplicado_retorna409() throws Exception {
        String json = """
                {
                    "codigo": "DUP",
                    "nombre": "TipoPlanilla Duplicado"
                }
                """;

        mockMvc.perform(post("/api/rrhh/tipos-planilla")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isCreated());

        mockMvc.perform(post("/api/rrhh/tipos-planilla")
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("RH-TP-001"));
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-planilla/9999 -> 404")
    void obtenerPorId_idInexistente_retorna404() throws Exception {
        mockMvc.perform(get("/api/rrhh/tipos-planilla/{id}", 9999)
                        .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/rrhh/tipos-planilla/9999 -> 404")
    void actualizar_idInexistente_retorna404() throws Exception {
        String json = """
                {
                    "nombre": "Inexistente"
                }
                """;

        mockMvc.perform(put("/api/rrhh/tipos-planilla/{id}", 9999)
                        .header("Authorization", authToken)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("DELETE /api/rrhh/tipos-planilla/9999 -> 404")
    void eliminar_idInexistente_retorna404() throws Exception {
        mockMvc.perform(patch("/api/rrhh/tipos-planilla/{id}/desactivar", 9999)
                        .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }
}