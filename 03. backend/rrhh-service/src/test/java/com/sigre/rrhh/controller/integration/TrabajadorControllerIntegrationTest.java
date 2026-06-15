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
@DisplayName("Pruebas de Integración - TrabajadorController")
class TrabajadorControllerIntegrationTest {

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

    @Test
    @DisplayName("GET /api/rrhh/trabajadores - Debe listar trabajadores")
    void listarTrabajadores_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/rrhh/trabajadores")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/trabajadores/{id} - Debe obtener trabajador por ID")
    void obtenerTrabajador_DebeRetornarDatos() throws Exception {
        String codigo = "TIT-" + System.nanoTime();
        String requestJson = """
            {
                "codigoTrabajador": "%s",
                "nombres": "Juan",
                "apellidoPaterno": "Pérez",
                "numeroDocumento": "%d"
            }
            """.formatted(codigo, (int) (Math.random() * 100000000));

        String response = mockMvc.perform(post("/api/rrhh/trabajadores")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long trabajadorId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/rrhh/trabajadores/{id}", trabajadorId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(trabajadorId))
                .andExpect(jsonPath("$.data.nombres").value("Juan"))
                .andExpect(jsonPath("$.data.codigoTrabajador").value(codigo));
    }

    @Test
    @DisplayName("POST /api/rrhh/trabajadores - Debe crear trabajador")
    void crearTrabajador_DebeCrearYRetornar() throws Exception {
        String codigo = "TIT-" + System.nanoTime();
        String requestJson = """
            {
                "codigoTrabajador": "%s",
                "nombres": "María",
                "apellidoPaterno": "García",
                "numeroDocumento": "%d"
            }
            """.formatted(codigo, (int) (Math.random() * 100000000));

        mockMvc.perform(post("/api/rrhh/trabajadores")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.nombres").value("María"))
                .andExpect(jsonPath("$.data.codigoTrabajador").value(codigo));
    }

    @Test
    @DisplayName("PUT /api/rrhh/trabajadores/{id} - Debe actualizar trabajador existente")
    void actualizarTrabajador_DebeActualizarYRetornar() throws Exception {
        String codigo = "TIT-" + System.nanoTime();
        int numDoc = (int) (Math.random() * 100000000);
        String requestJson = """
            {
                "codigoTrabajador": "%s",
                "nombres": "Carlos",
                "apellidoPaterno": "López",
                "numeroDocumento": "%d"
            }
            """.formatted(codigo, numDoc);

        String response = mockMvc.perform(post("/api/rrhh/trabajadores")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long trabajadorId = objectMapper.readTree(response).get("data").get("id").asLong();

        String requestActualizado = """
            {
                "codigoTrabajador": "%s",
                "nombres": "Carlos Actualizado",
                "apellidoPaterno": "López",
                "numeroDocumento": "%d"
            }
            """.formatted(codigo, numDoc);

        mockMvc.perform(put("/api/rrhh/trabajadores/{id}", trabajadorId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(trabajadorId))
                .andExpect(jsonPath("$.data.nombres").value("Carlos Actualizado"));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/trabajadores/{id}/desactivar - Debe desactivar trabajador")
    void desactivarTrabajador_DebeDesactivarYRetornar() throws Exception {
        String codigo = "TIT-" + System.nanoTime();
        String requestJson = """
            {
                "codigoTrabajador": "%s",
                "nombres": "Ana",
                "apellidoPaterno": "Martínez",
                "numeroDocumento": "%d"
            }
            """.formatted(codigo, (int) (Math.random() * 100000000));

        String response = mockMvc.perform(post("/api/rrhh/trabajadores")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long trabajadorId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/rrhh/trabajadores/{id}/desactivar", trabajadorId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/trabajadores/{id} - Debe retornar 404 con ID inexistente")
    void obtenerTrabajador_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/rrhh/trabajadores/9999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/rrhh/trabajadores/{id} - Debe retornar 404 con ID inexistente")
    void actualizarTrabajador_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "codigoTrabajador": "NOEXISTE",
                "nombres": "Inexistente",
                "apellidoPaterno": "Test",
                "numeroDocumento": "99999999"
            }
            """;

        mockMvc.perform(put("/api/rrhh/trabajadores/9999")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/trabajadores/{id}/desactivar - Debe retornar 404 con ID inexistente")
    void desactivarTrabajador_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(patch("/api/rrhh/trabajadores/9999/desactivar")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }
}
