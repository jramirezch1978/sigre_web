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
@DisplayName("Pruebas de Integración - CapacitacionController")
class CapacitacionControllerIntegrationTest {

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
    @DisplayName("GET /api/rrhh/capacitaciones - Debe listar capacitaciones")
    void listarCapacitaciones_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/rrhh/capacitaciones")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/capacitaciones/{id} - Debe obtener capacitación por ID")
    void obtenerCapacitacion_DebeRetornarDatos() throws Exception {
        String nombre = "Cap-IT-" + System.nanoTime();
        String requestJson = """
            {
                "nombre": "%s",
                "descripcion": "Capacitación de prueba",
                "horas": 8,
                "proveedor": "Proveedor IT"
            }
            """.formatted(nombre);

        String response = mockMvc.perform(post("/api/rrhh/capacitaciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long capacitacionId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/rrhh/capacitaciones/{id}", capacitacionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(capacitacionId))
                .andExpect(jsonPath("$.data.nombre").value(nombre))
                .andExpect(jsonPath("$.data.descripcion").value("Capacitación de prueba"));
    }

    @Test
    @DisplayName("POST /api/rrhh/capacitaciones - Debe crear capacitación")
    void crearCapacitacion_DebeCrearYRetornar() throws Exception {
        String nombre = "Cap-IT-" + System.nanoTime();
        String requestJson = """
            {
                "nombre": "%s",
                "descripcion": "Nueva capacitación",
                "fechaInicio": "2026-06-01",
                "fechaFin": "2026-06-05",
                "horas": 16,
                "proveedor": "Proveedor Externo",
                "costo": 2500.00
            }
            """.formatted(nombre);

        mockMvc.perform(post("/api/rrhh/capacitaciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.nombre").value(nombre))
                .andExpect(jsonPath("$.data.horas").value(16))
                .andExpect(jsonPath("$.data.proveedor").value("Proveedor Externo"));
    }

    @Test
    @DisplayName("PUT /api/rrhh/capacitaciones/{id} - Debe actualizar capacitación existente")
    void actualizarCapacitacion_DebeActualizarYRetornar() throws Exception {
        String nombre = "Cap-IT-" + System.nanoTime();
        String requestJson = """
            {
                "nombre": "%s",
                "descripcion": "Capacitación original",
                "horas": 8,
                "proveedor": "Proveedor A"
            }
            """.formatted(nombre);

        String response = mockMvc.perform(post("/api/rrhh/capacitaciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long capacitacionId = objectMapper.readTree(response).get("data").get("id").asLong();

        String requestActualizado = """
            {
                "nombre": "%s",
                "descripcion": "Capacitación actualizada",
                "horas": 16,
                "proveedor": "Proveedor B",
                "costo": 5000.00
            }
            """.formatted(nombre);

        mockMvc.perform(put("/api/rrhh/capacitaciones/{id}", capacitacionId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(capacitacionId))
                .andExpect(jsonPath("$.data.descripcion").value("Capacitación actualizada"))
                .andExpect(jsonPath("$.data.horas").value(16))
                .andExpect(jsonPath("$.data.proveedor").value("Proveedor B"));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/capacitaciones/{id}/desactivar - Debe desactivar capacitación")
    void desactivarCapacitacion_DebeDesactivarYRetornar() throws Exception {
        String nombre = "Cap-IT-" + System.nanoTime();
        String requestJson = """
            {
                "nombre": "%s",
                "descripcion": "Capacitación a desactivar",
                "horas": 4,
                "proveedor": "Proveedor C"
            }
            """.formatted(nombre);

        String response = mockMvc.perform(post("/api/rrhh/capacitaciones")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long capacitacionId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/rrhh/capacitaciones/{id}/desactivar", capacitacionId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/capacitaciones/{id} - Debe retornar 404 con ID inexistente")
    void obtenerCapacitacion_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/rrhh/capacitaciones/9999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/rrhh/capacitaciones/{id} - Debe retornar 404 con ID inexistente")
    void actualizarCapacitacion_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "nombre": "No existe",
                "descripcion": "Inexistente",
                "horas": 0
            }
            """;

        mockMvc.perform(put("/api/rrhh/capacitaciones/9999")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/capacitaciones/{id}/desactivar - Debe retornar 404 con ID inexistente")
    void desactivarCapacitacion_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(patch("/api/rrhh/capacitaciones/9999/desactivar")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }
}
