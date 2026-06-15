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
import com.sigre.rrhh.testdata.RrhhTestDataFactory;
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
@DisplayName("Pruebas de Integración - NovedadRrhhController")
class NovedadRrhhControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private RrhhTestDataFactory rrhhFactory;

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

        rrhhFactory.ensureAreaTestData();
        rrhhFactory.ensureCargoTestData();
    }

    private Long crearTipoNovedadRrhh() throws Exception {
        long ts = System.currentTimeMillis();
        String requestJson = """
            {"codigo": "TN-%d", "nombre": "Tipo Novedad Test"}
            """.formatted(ts);
        String response = mockMvc.perform(post("/api/rrhh/tipos-novedad")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();
        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private Long crearTrabajador() throws Exception {
        long ts = System.currentTimeMillis();
        String json = """
            {
                "codigoTrabajador": "NRH-IT-%d",
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

    @Test
    @DisplayName("GET /api/rrhh/novedades - Debe listar novedades")
    void listarNovedades_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/rrhh/novedades")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("POST /api/rrhh/novedades - Debe crear novedad")
    void crearNovedad_DebeCrearYRetornar() throws Exception {
        Long trabajadorId = crearTrabajador();
        Long tipoNovedadId = crearTipoNovedadRrhh();

        String requestJson = """
            {
                "trabajadorId": %d,
                "tipoNovedadRrhhId": %d,
                "citt": "CITT-%d",
                "fechaIni": "2026-06-01",
                "fechaFin": "2026-06-15",
                "diasReales": 14
            }
            """.formatted(trabajadorId, tipoNovedadId, System.currentTimeMillis());

        mockMvc.perform(post("/api/rrhh/novedades")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").exists())
            .andExpect(jsonPath("$.data.trabajadorId").value(trabajadorId))
            .andExpect(jsonPath("$.data.tipoNovedadRrhhId").value(tipoNovedadId))
            .andExpect(jsonPath("$.data.fechaIni").value("2026-06-01"))
            .andExpect(jsonPath("$.data.fechaFin").value("2026-06-15"))
            .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }

    @Test
    @DisplayName("GET /api/rrhh/novedades/{id} - Debe obtener novedad por ID")
    void obtenerNovedad_DebeRetornarDatos() throws Exception {
        Long trabajadorId = crearTrabajador();
        Long tipoNovedadId = crearTipoNovedadRrhh();
        long ts = System.currentTimeMillis();

        String requestJson = """
            {
                "trabajadorId": %d,
                "tipoNovedadRrhhId": %d,
                "citt": "CITT-%d",
                "fechaIni": "2026-06-01",
                "fechaFin": "2026-06-15",
                "diasReales": 14
            }
            """.formatted(trabajadorId, tipoNovedadId, ts);

        String response = mockMvc.perform(post("/api/rrhh/novedades")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long novedadId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/rrhh/novedades/{id}", novedadId)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").value(novedadId))
            .andExpect(jsonPath("$.data.trabajadorId").value(trabajadorId))
            .andExpect(jsonPath("$.data.citt").value("CITT-" + ts))
            .andExpect(jsonPath("$.data.fechaIni").value("2026-06-01"))
            .andExpect(jsonPath("$.data.fechaFin").value("2026-06-15"));
    }

    @Test
    @DisplayName("PUT /api/rrhh/novedades/{id} - Debe actualizar novedad existente")
    void actualizarNovedad_DebeActualizarYRetornar() throws Exception {
        Long trabajadorId = crearTrabajador();
        Long tipoNovedadId = crearTipoNovedadRrhh();
        long ts = System.currentTimeMillis();

        String createJson = """
            {
                "trabajadorId": %d,
                "tipoNovedadRrhhId": %d,
                "citt": "CITT-%d",
                "fechaIni": "2026-06-01",
                "fechaFin": "2026-06-15",
                "diasReales": 14
            }
            """.formatted(trabajadorId, tipoNovedadId, ts);

        String response = mockMvc.perform(post("/api/rrhh/novedades")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createJson))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long novedadId = objectMapper.readTree(response).get("data").get("id").asLong();

        String updateJson = """
            {
                "citt": "CITT-%d-UPD",
                "diasReales": 10,
                "flagEstado": "1"
            }
            """.formatted(ts);

        mockMvc.perform(put("/api/rrhh/novedades/{id}", novedadId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").value(novedadId))
            .andExpect(jsonPath("$.data.diasReales").value(10));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/novedades/{id}/desactivar - Debe desactivar novedad")
    void desactivarNovedad_DebeDesactivarYRetornar() throws Exception {
        Long trabajadorId = crearTrabajador();
        Long tipoNovedadId = crearTipoNovedadRrhh();

        String createJson = """
            {
                "trabajadorId": %d,
                "tipoNovedadRrhhId": %d,
                "citt": "CITT-%d",
                "fechaIni": "2026-06-01",
                "fechaFin": "2026-06-15",
                "diasReales": 14
            }
            """.formatted(trabajadorId, tipoNovedadId, System.currentTimeMillis());

        String response = mockMvc.perform(post("/api/rrhh/novedades")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createJson))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long novedadId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/rrhh/novedades/{id}/desactivar", novedadId)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/novedades/{id} - Debe retornar 404 con ID inexistente")
    void obtenerNovedad_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/rrhh/novedades/9999")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/rrhh/novedades/{id} - Debe retornar 404 con ID inexistente")
    void actualizarNovedad_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "citt": "NOEXISTE",
                "diasReales": 5,
                "flagEstado": "1"
            }
            """;

        mockMvc.perform(put("/api/rrhh/novedades/9999")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/novedades/{id}/desactivar - Debe retornar 404 con ID inexistente")
    void desactivarNovedad_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(patch("/api/rrhh/novedades/9999/desactivar")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }
}
