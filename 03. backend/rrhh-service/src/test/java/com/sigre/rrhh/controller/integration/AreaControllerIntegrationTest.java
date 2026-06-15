package com.sigre.rrhh.controller.integration;

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
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.AreaRequest;
import com.sigre.rrhh.repository.AreaRepository;
import com.sigre.rrhh.testdata.RrhhTestDataExecutionListener;
import org.springframework.boot.test.mock.mockito.MockBean;
import com.sigre.common.security.JwtTokenProvider;
import static org.mockito.Mockito.when;

import javax.sql.DataSource;

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para AreaController con datos reales en base de datos.
 * Sigue la recomendación del líder de usar datos de prueba insertados en BD en lugar de mocks.
 *
 * @author Equipo de Desarrollo
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
@DisplayName("Pruebas de Integración - AreaController")
class AreaControllerIntegrationTest {

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

    @Test
    @DisplayName("GET /api/rrhh/areas - Debe listar áreas")
    void listarAreas_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/rrhh/areas")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/areas/{id} - Debe obtener área por ID")
    void obtenerArea_DebeRetornarDatos() throws Exception {
        // Primero crear un área para tener un ID válido
        String requestJson = """
            {
                "nombre": "Área de Prueba",
                "padreId": null,
                "responsableId": null
            }
            """;

        String response = mockMvc.perform(post("/api/rrhh/areas")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long areaId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Ahora obtener el área por ID
        mockMvc.perform(get("/api/rrhh/areas/{id}", areaId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(areaId))
                .andExpect(jsonPath("$.data.nombre").value("Área de Prueba"));
    }

    @Test
    @DisplayName("POST /api/rrhh/areas - Debe crear área")
    void crearArea_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "nombre": "Área de Prueba",
                "padreId": null,
                "responsableId": null
            }
            """;

        mockMvc.perform(post("/api/rrhh/areas")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.nombre").value("Área de Prueba"));
    }

    @Test
    @DisplayName("PUT /api/rrhh/areas/{id} - Debe actualizar área existente")
    void actualizarArea_DebeActualizarYRetornar() throws Exception {
        // Primero crear un área para tener un ID válido
        String requestJson = """
            {
                "nombre": "Área Original",
                "padreId": null,
                "responsableId": null
            }
            """;

        String response = mockMvc.perform(post("/api/rrhh/areas")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long areaId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Actualizar el área
        String requestActualizado = """
            {
                "nombre": "Área Actualizada",
                "padreId": null,
                "responsableId": null
            }
            """;

        mockMvc.perform(put("/api/rrhh/areas/{id}", areaId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(areaId))
                .andExpect(jsonPath("$.data.nombre").value("Área Actualizada"));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/areas/{id}/desactivar - Debe desactivar área")
    void desactivarArea_DebeDesactivarYRetornar() throws Exception {
        // Primero crear un área para tener un ID válido
        String requestJson = """
            {
                "nombre": "Área a Eliminar",
                "padreId": null,
                "responsableId": null
            }
            """;

        String response = mockMvc.perform(post("/api/rrhh/areas")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long areaId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Desactivar el área
        mockMvc.perform(patch("/api/rrhh/areas/{id}/desactivar", areaId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/areas/arbol - Debe obtener árbol jerárquico")
    void obtenerArbolJerarquico_DebeRetornarEstructura() throws Exception {
        String padreJson = """
            {
                "nombre": "Área Padre",
                "padreId": null,
                "responsableId": null
            }
            """;

        String response = mockMvc.perform(post("/api/rrhh/areas")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(padreJson))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long padreId = objectMapper.readTree(response).get("data").get("id").asLong();

        String hijoJson = """
            {
                "nombre": "Área Hijo",
                "padreId": %d,
                "responsableId": null
            }
            """.formatted(padreId);

        mockMvc.perform(post("/api/rrhh/areas")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(hijoJson))
                .andExpect(status().isCreated());

        mockMvc.perform(get("/api/rrhh/areas/arbol")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[*].id").exists())
                .andExpect(jsonPath("$.data[*].nombre").exists())
                .andExpect(jsonPath("$.data[*].hijos").exists());
    }

    @Test
    @DisplayName("GET /api/rrhh/areas/{id} - Debe retornar 404 con ID inexistente")
    void obtenerArea_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/rrhh/areas/9999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/rrhh/areas/{id} - Debe retornar 404 con ID inexistente")
    void actualizarArea_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "nombre": "Área Inexistente",
                "padreId": null,
                "responsableId": null
            }
            """;

        mockMvc.perform(put("/api/rrhh/areas/9999")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/areas/{id}/desactivar - Debe retornar 404 con ID inexistente")
    void desactivarArea_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(patch("/api/rrhh/areas/9999/desactivar")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/rrhh/areas - Debe retornar error de validación con datos inválidos")
    void crearArea_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "nombre": "",
                "padreId": null,
                "responsableId": null
            }
            """;

        mockMvc.perform(post("/api/rrhh/areas")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/rrhh/areas - Debe retornar error con nombre duplicado")
    void crearArea_ConNombreDuplicado_DebeRetornarError() throws Exception {
        // Primero crear un área
        String requestJson = """
            {
                "nombre": "Área de Prueba Duplicada",
                "padreId": null,
                "responsableId": null
            }
            """;

        mockMvc.perform(post("/api/rrhh/areas")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true));

        // Intentar crear otra área con el mismo nombre
        mockMvc.perform(post("/api/rrhh/areas")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.message").value(containsString("Ya existe un área con ese nombre")));
    }
}
