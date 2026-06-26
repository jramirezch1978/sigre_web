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
import org.springframework.boot.test.mock.mockito.MockBean;
import pe.restaurant.common.security.JwtTokenProvider;
import static org.mockito.Mockito.when;

import javax.sql.DataSource;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = pe.restaurant.common.testutil.TenantContextTestExecutionListener.class,
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integraci\u00f3n - TipoNovedadRrhhController")
class TipoNovedadRrhhControllerIntegrationTest {

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

        authToken = "Bearer mock-token";
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-novedad - Debe listar tipos de novedad")
    void listarTiposNovedad_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray())
            .andExpect(jsonPath("$.data.page.totalElements").exists());
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-novedad/{id} - Debe obtener por ID")
    void obtenerTipoNovedad_DebeRetornarDatos() throws Exception {
        String requestJson = """
            {
                "codigo": "T-OBT",
                "nombre": "Obtener Test"
            }
            """;

        String response = mockMvc.perform(post("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").exists())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/rrhh/tipos-novedad/{id}", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").value(id))
            .andExpect(jsonPath("$.data.codigo").value("T-OBT"))
            .andExpect(jsonPath("$.data.nombre").value("Obtener Test"));
    }

    @Test
    @DisplayName("POST /api/rrhh/tipos-novedad - Debe crear tipo de novedad")
    void crearTipoNovedad_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "codigo": "T-CRE",
                "nombre": "Crear Test"
            }
            """;

        mockMvc.perform(post("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").exists())
            .andExpect(jsonPath("$.data.codigo").value("T-CRE"))
            .andExpect(jsonPath("$.data.nombre").value("Crear Test"))
            .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }

    @Test
    @DisplayName("PUT /api/rrhh/tipos-novedad/{id} - Debe actualizar existente")
    void actualizarTipoNovedad_DebeActualizarYRetornar() throws Exception {
        String requestJson = """
            {
                "codigo": "T-ACT",
                "nombre": "Actualizar Test"
            }
            """;

        String response = mockMvc.perform(post("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").exists())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        String requestActualizado = """
            {
                "nombre": "Actualizar Test Modificado",
                "flagEstado": "1"
            }
            """;

        mockMvc.perform(put("/api/rrhh/tipos-novedad/{id}", id)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").value(id))
            .andExpect(jsonPath("$.data.nombre").value("Actualizar Test Modificado"))
            .andExpect(jsonPath("$.data.codigo").value("T-ACT"))
            .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/tipos-novedad/{id}/desactivar - Debe desactivar (baja lógica)")
    void desactivarTipoNovedad_DebeDesactivarYRetornar() throws Exception {
        String requestJson = """
            {
                "codigo": "T-ELI",
                "nombre": "Eliminar Test"
            }
            """;

        String response = mockMvc.perform(post("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").exists())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/rrhh/tipos-novedad/{id}/desactivar", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-novedad/{id} - Debe retornar 404 con ID inexistente")
    void obtenerTipoNovedad_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/rrhh/tipos-novedad/9999")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/rrhh/tipos-novedad/{id} - Debe retornar 404 con ID inexistente")
    void actualizarTipoNovedad_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "nombre": "Permiso",
                "flagEstado": "1"
            }
            """;

        mockMvc.perform(put("/api/rrhh/tipos-novedad/9999")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/tipos-novedad/{id}/desactivar - Debe retornar 404 con ID inexistente")
    void desactivarTipoNovedad_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(patch("/api/rrhh/tipos-novedad/9999/desactivar")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/rrhh/tipos-novedad - Debe retornar error de validaci\u00f3n con datos inv\u00e1lidos")
    void crearTipoNovedad_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "codigo": "",
                "nombre": ""
            }
            """;

        mockMvc.perform(post("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/rrhh/tipos-novedad - Debe retornar error con c\u00f3digo duplicado")
    void crearTipoNovedad_ConCodigoDuplicado_DebeRetornarError() throws Exception {
        String requestJson = """
            {
                "codigo": "DUP",
                "nombre": "Duplicado"
            }
            """;

        mockMvc.perform(post("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true));

        mockMvc.perform(post("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.success").value(false))
            .andExpect(jsonPath("$.errorCode").value("RH-TN-002"));
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-novedad?codigo=PER - Debe filtrar por c\u00f3digo")
    void listarTiposNovedad_ConFiltroCodigo_DebeRetornarFiltrados() throws Exception {
        String requestJson = """
            {
                "codigo": "T-FIL",
                "nombre": "Filtro Test"
            }
            """;

        mockMvc.perform(post("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated());

        mockMvc.perform(get("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .param("codigo", "T-FIL")
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-novedad?flagEstado=1 - Debe filtrar por estado")
    void listarTiposNovedad_ConFiltroEstado_DebeRetornarFiltrados() throws Exception {
        mockMvc.perform(get("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .param("flagEstado", "1")
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }
}
