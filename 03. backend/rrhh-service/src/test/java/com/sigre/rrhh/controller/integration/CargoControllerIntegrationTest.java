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

import static org.hamcrest.Matchers.containsString;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para CargoController con datos reales en base de datos.
 * Sigue el estándar de generacion-test.md con @Tag("integration").
 */
@Tag("integration")
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = TenantContextTestExecutionListener.class,
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - CargoController")
class CargoControllerIntegrationTest {

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
    @DisplayName("GET /api/rrhh/cargos - Debe listar cargos")
    void listarCargos_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/cargos/{id} - Debe obtener cargo por ID")
    void obtenerCargo_DebeRetornarDatos() throws Exception {
        String requestJson = """
            {
                "nombre": "Cargo de Prueba",
                "nivel": "OPERATIVO",
                "sueldoMinimo": 2500.0000,
                "sueldoMaximo": 4000.0000
            }
            """;

        String response = mockMvc.perform(post("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long cargoId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/rrhh/cargos/{id}", cargoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(cargoId))
                .andExpect(jsonPath("$.data.nombre").value("Cargo de Prueba"));
    }

    @Test
    @DisplayName("POST /api/rrhh/cargos - Debe crear cargo")
    void crearCargo_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "nombre": "Chef Ejecutivo IT Test",
                "nivel": "TÁCTICO",
                "sueldoMinimo": 3500.0000,
                "sueldoMaximo": 6000.0000
            }
            """;

        mockMvc.perform(post("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.nombre").value("Chef Ejecutivo IT Test"))
                .andExpect(jsonPath("$.data.nivel").value("TÁCTICO"));
    }

    @Test
    @DisplayName("PUT /api/rrhh/cargos/{id} - Debe actualizar cargo existente")
    void actualizarCargo_DebeActualizarYRetornar() throws Exception {
        String requestJson = """
            {
                "nombre": "Cargo Original",
                "nivel": "OPERATIVO",
                "sueldoMinimo": 2000.0000,
                "sueldoMaximo": 3000.0000
            }
            """;

        String response = mockMvc.perform(post("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long cargoId = objectMapper.readTree(response).get("data").get("id").asLong();

        String requestActualizado = """
            {
                "nombre": "Cargo Actualizado",
                "nivel": "TÁCTICO",
                "sueldoMinimo": 3000.0000,
                "sueldoMaximo": 5000.0000
            }
            """;

        mockMvc.perform(put("/api/rrhh/cargos/{id}", cargoId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(cargoId))
                .andExpect(jsonPath("$.data.nombre").value("Cargo Actualizado"))
                .andExpect(jsonPath("$.data.nivel").value("TÁCTICO"));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/cargos/{id}/desactivar - Debe desactivar cargo")
    void desactivarCargo_DebeDesactivarYRetornar() throws Exception {
        String requestJson = """
            {
                "nombre": "Cargo a Eliminar",
                "nivel": "OPERATIVO",
                "sueldoMinimo": 2000.0000,
                "sueldoMaximo": 3000.0000
            }
            """;

        String response = mockMvc.perform(post("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long cargoId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/rrhh/cargos/{id}/desactivar", cargoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/cargos/{id} - Debe retornar 404 con ID inexistente")
    void obtenerCargo_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/rrhh/cargos/9999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/rrhh/cargos/{id} - Debe retornar 404 con ID inexistente")
    void actualizarCargo_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "nombre": "Cargo Inexistente",
                "nivel": "OPERATIVO",
                "sueldoMinimo": 2000.0000,
                "sueldoMaximo": 3000.0000
            }
            """;

        mockMvc.perform(put("/api/rrhh/cargos/9999")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/cargos/{id}/desactivar - Debe retornar 404 con ID inexistente")
    void desactivarCargo_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(patch("/api/rrhh/cargos/9999/desactivar")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/rrhh/cargos - Debe retornar error de validación con datos inválidos")
    void crearCargo_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "nombre": "",
                "nivel": "OPERATIVO",
                "sueldoMinimo": 2000.0000,
                "sueldoMaximo": 3000.0000
            }
            """;

        mockMvc.perform(post("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/rrhh/cargos - Debe retornar error con nombre duplicado")
    void crearCargo_ConNombreDuplicado_DebeRetornarError() throws Exception {
        String requestJson = """
            {
                "nombre": "Cargo Duplicado",
                "nivel": "OPERATIVO",
                "sueldoMinimo": 2000.0000,
                "sueldoMaximo": 3000.0000
            }
            """;

        mockMvc.perform(post("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true));

        mockMvc.perform(post("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.message").value(containsString("Ya existe un cargo con ese nombre")));
    }

    @Test
    @DisplayName("POST /api/rrhh/cargos - Debe retornar error con banda salarial incoherente")
    void crearCargo_ConBandaSalarialIncoherente_DebeRetornarError() throws Exception {
        String requestJson = """
            {
                "nombre": "Cargo Banda Incoherente",
                "nivel": "OPERATIVO",
                "sueldoMinimo": 5000.0000,
                "sueldoMaximo": 3000.0000
            }
            """;

        mockMvc.perform(post("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.message").value(containsString("El sueldo mínimo no puede ser mayor al sueldo máximo")));
    }

    @Test
    @DisplayName("GET /api/rrhh/cargos?nombre=Chef - Debe filtrar por nombre")
    void listarCargos_ConFiltroNombre_DebeRetornarFiltrados() throws Exception {
        String requestJson = """
            {
                "nombre": "Chef de Prueba",
                "nivel": "TÁCTICO",
                "sueldoMinimo": 3000.0000,
                "sueldoMaximo": 5000.0000
            }
            """;

        mockMvc.perform(post("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated());

        mockMvc.perform(get("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .param("nombre", "Chef")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/cargos?nivel=TÁCTICO - Debe filtrar por nivel")
    void listarCargos_ConFiltroNivel_DebeRetornarFiltrados() throws Exception {
        mockMvc.perform(get("/api/rrhh/cargos")
                .header("Authorization", authToken)
                .param("nivel", "TÁCTICO")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }
}
