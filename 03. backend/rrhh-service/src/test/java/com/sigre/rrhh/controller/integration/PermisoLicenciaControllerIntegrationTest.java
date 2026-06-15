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
import com.sigre.rrhh.testdata.RrhhTestDataExecutionListener;
import com.sigre.rrhh.testdata.RrhhTestDataFactory;
import org.springframework.boot.test.mock.mockito.MockBean;
import com.sigre.common.security.JwtTokenProvider;
import static org.mockito.Mockito.when;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {TenantContextTestExecutionListener.class, RrhhTestDataExecutionListener.class},
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - PermisoLicenciaController")
class PermisoLicenciaControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private RrhhTestDataFactory rrhhFactory;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private String authToken;
    private Long trabajadorId;
    private Long tipoSuspensionId;

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

        // Los datos maestros ya fueron cargados por RrhhTestDataExecutionListener
        // Solo cargar datos específicos del test
        rrhhFactory.ensureAreaTestData();
        rrhhFactory.ensureCargoTestData();
        rrhhFactory.ensureConceptoPlanillaTestData();

        trabajadorId = crearTrabajador();
        tipoSuspensionId = crearTipoSuspension();
    }

    private Long crearTrabajador() throws Exception {
        long ts = System.currentTimeMillis();
        String json = """
            {
                "codigoTrabajador": "PL-IT-%d",
                "nombres": "Juan",
                "apellidoPaterno": "Pérez",
                "numeroDocumento": "%d",
                "fechaIngreso": "2024-03-15"
            }
            """.formatted(ts, 30000000 + (int)(Math.random() * 90000000));

        String response = mockMvc.perform(post("/api/rrhh/trabajadores")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private Long crearTipoSuspension() throws Exception {
        int suffix = (int)(Math.random() * 9000) + 1000;
        String json = """
            {
                "codigo": "ST%d",
                "nombre": "Suspensión Test",
                "flagCitt": "0"
            }
            """.formatted(suffix);

        String response = mockMvc.perform(post("/api/rrhh/tipos-suspension-laboral")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private String permisoJson(String fechaInicio, String fechaFin, Integer dias, String sustento) {
        String fin = fechaFin != null ? "\"" + fechaFin + "\"" : "null";
        String sus = sustento != null ? "\"" + sustento + "\"" : "null";
        return """
            {
                "trabajadorId": %d,
                "tipoSuspensionLaboralId": %d,
                "fechaInicio": "%s",
                "fechaFin": %s,
                "dias": %d,
                "sustento": %s
            }
            """.formatted(trabajadorId, tipoSuspensionId, fechaInicio, fin, dias != null ? dias : 0, sus);
    }

    @Test
    @DisplayName("GET /api/rrhh/permisos-licencias - Debe listar permisos")
    void listarPermisos_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/rrhh/permisos-licencias")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/permisos-licencias/{id} - Debe obtener por ID")
    void obtenerPermiso_DebeRetornarDatos() throws Exception {
        String response = mockMvc.perform(post("/api/rrhh/permisos-licencias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(permisoJson("2026-06-01", "2026-06-03", 3, "Permiso de prueba")))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/rrhh/permisos-licencias/{id}", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").value(id))
            .andExpect(jsonPath("$.data.tipoSuspensionLaboralId").value(tipoSuspensionId));
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias - Debe crear permiso")
    void crearPermiso_DebeCrearYRetornar() throws Exception {
        mockMvc.perform(post("/api/rrhh/permisos-licencias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(permisoJson("2026-06-01", "2026-06-05", 5, "Crear test")))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").exists())
            .andExpect(jsonPath("$.data.trabajadorId").value(trabajadorId))
            .andExpect(jsonPath("$.data.tipoSuspensionLaboralId").value(tipoSuspensionId))
            .andExpect(jsonPath("$.data.fechaInicio").value("2026-06-01"))
            .andExpect(jsonPath("$.data.dias").value(5))
            .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }

    @Test
    @DisplayName("PUT /api/rrhh/permisos-licencias/{id} - Debe actualizar existente")
    void actualizarPermiso_DebeActualizarYRetornar() throws Exception {
        String response = mockMvc.perform(post("/api/rrhh/permisos-licencias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(permisoJson("2026-06-01", "2026-06-03", 3, null)))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        String requestActualizado = """
            {
                "fechaFin": "2026-06-10",
                "dias": 10,
                "flagEstado": "1"
            }
            """;

        mockMvc.perform(put("/api/rrhh/permisos-licencias/{id}", id)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").value(id))
            .andExpect(jsonPath("$.data.dias").value(10));
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias/{id}/aprobar - Debe aprobar permiso")
    void aprobarPermiso_DebeAprobarYRetornar() throws Exception {
        String response = mockMvc.perform(post("/api/rrhh/permisos-licencias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(permisoJson("2026-06-01", "2026-06-02", null, null)))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(post("/api/rrhh/permisos-licencias/{id}/aprobar", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.flagEstado").value("2"));
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias/{id}/rechazar - Debe rechazar permiso")
    void rechazarPermiso_DebeRechazarYRetornar() throws Exception {
        String response = mockMvc.perform(post("/api/rrhh/permisos-licencias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(permisoJson("2026-06-01", "2026-06-02", null, null)))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(post("/api/rrhh/permisos-licencias/{id}/rechazar", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.flagEstado").value("0"));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/permisos-licencias/{id}/desactivar - Debe desactivar (baja lógica)")
    void eliminarPermiso_DebeDesactivarYRetornar() throws Exception {
        String response = mockMvc.perform(post("/api/rrhh/permisos-licencias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(permisoJson("2026-06-01", null, null, null)))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/rrhh/permisos-licencias/{id}/desactivar", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/permisos-licencias/{id} - Debe retornar 404 con ID inexistente")
    void obtenerPermiso_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/rrhh/permisos-licencias/9999")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/rrhh/permisos-licencias/{id} - Debe retornar 404 con ID inexistente")
    void actualizarPermiso_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "fechaFin": "2026-06-10",
                "flagEstado": "1"
            }
            """;

        mockMvc.perform(put("/api/rrhh/permisos-licencias/9999")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/permisos-licencias/{id}/desactivar - Debe retornar 404 con ID inexistente")
    void eliminarPermiso_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(patch("/api/rrhh/permisos-licencias/9999/desactivar")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias - Debe retornar error de validación con datos inválidos")
    void crearPermiso_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "trabajadorId": null,
                "tipoSuspensionLaboralId": null,
                "fechaInicio": null
            }
            """;

        mockMvc.perform(post("/api/rrhh/permisos-licencias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.success").value(false));
    }
}
