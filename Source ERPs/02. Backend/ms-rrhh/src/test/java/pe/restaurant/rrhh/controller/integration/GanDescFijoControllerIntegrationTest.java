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
import pe.restaurant.rrhh.testdata.RrhhTestDataFactory;
import org.springframework.boot.test.mock.mockito.MockBean;
import pe.restaurant.common.security.JwtTokenProvider;
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
@DisplayName("Pruebas de Integración - GanDescFijoController")
class GanDescFijoControllerIntegrationTest {

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

        // Los datos maestros ya fueron cargados por RrhhTestDataExecutionListener
        // Solo cargar datos específicos del test
        rrhhFactory.ensureAreaTestData();
        rrhhFactory.ensureCargoTestData();
        rrhhFactory.ensureConceptoPlanillaTestData();
    }

    private Long crearTrabajador() throws Exception {
        long ts = System.currentTimeMillis();
        String json = """
            {
                "codigoTrabajador": "GF-IT-%d",
                "nombres": "Juan",
                "apellidoPaterno": "Pérez",
                "apellidoMaterno": "García",
                "numeroDocumento": "%d",
                "fechaIngreso": "2024-03-15"
            }
            """.formatted(ts, 10000000 + (int)(Math.random() * 90000000));

        String response = mockMvc.perform(post("/api/rrhh/trabajadores")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private Long crearConcepto() throws Exception {
        String json = """
            {
                "codigo": "GF-CPT-%d",
                "nombre": "Bonificación Test",
                "tipo": "INGRESO",
                "valorFijo": 500.00,
                "afectoQuinta": true,
                "afectoEssalud": true,
                "aplicaTodos": true
            }
            """.formatted(System.currentTimeMillis());

        String response = mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(json))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    // ==== CREATE ====

    @Test
    @DisplayName("POST /api/rrhh/ganancias-descuentos-fijos -> crea y retorna 201")
    void crear_conDatosValidos_retornaCreated() throws Exception {
        Long trabajadorId = crearTrabajador();
        Long conceptoId = crearConcepto();

        String requestJson = """
            {
                "trabajadorId": %d,
                "conceptoId": %d,
                "impGanDesc": 500.0000,
                "flagEstado": "1"
            }
            """.formatted(trabajadorId, conceptoId);

        mockMvc.perform(post("/api/rrhh/ganancias-descuentos-fijos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").exists())
            .andExpect(jsonPath("$.data.trabajadorId").value(trabajadorId))
            .andExpect(jsonPath("$.data.impGanDesc").value(500.0000));
    }

    @Test
    @DisplayName("POST -> con importe y porcentaje nulos retorna 422")
    void crear_sinImporteNiPorcentaje_retornaError() throws Exception {
        Long trabajadorId = crearTrabajador();
        Long conceptoId = crearConcepto();

        String requestJson = """
            {
                "trabajadorId": %d,
                "conceptoId": %d,
                "impGanDesc": null,
                "porcentaje": null
            }
            """.formatted(trabajadorId, conceptoId);

        mockMvc.perform(post("/api/rrhh/ganancias-descuentos-fijos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isUnprocessableEntity())
            .andExpect(jsonPath("$.success").value(false))
            .andExpect(jsonPath("$.errorCode").value("RH-GF-003"));
    }

    @Test
    @DisplayName("POST -> con trabajador inexistente retorna 422")
    void crear_conTrabajadorInexistente_retornaError() throws Exception {
        Long conceptoId = crearConcepto();

        String requestJson = """
            {
                "trabajadorId": 99999,
                "conceptoId": %d,
                "impGanDesc": 500.0000
            }
            """.formatted(conceptoId);

        mockMvc.perform(post("/api/rrhh/ganancias-descuentos-fijos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isUnprocessableEntity())
            .andExpect(jsonPath("$.success").value(false));
    }

    // ==== READ - LIST ====

    @Test
    @DisplayName("GET /api/rrhh/ganancias-descuentos-fijos -> lista paginada")
    void listar_sinFiltros_retornaPagina() throws Exception {
        mockMvc.perform(get("/api/rrhh/ganancias-descuentos-fijos")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray())
            .andExpect(jsonPath("$.data.page").exists());
    }

    // ==== READ - BY ID ====

    @Test
    @DisplayName("GET /api/rrhh/ganancias-descuentos-fijos/{id} -> retorna registro")
    void obtener_conIdExistente_retornaOk() throws Exception {
        Long trabajadorId = crearTrabajador();
        Long conceptoId = crearConcepto();

        String createJson = """
            {"trabajadorId":%d,"conceptoId":%d,"impGanDesc":500.0000,"flagEstado":"1"}
            """.formatted(trabajadorId, conceptoId);

        String createResp = mockMvc.perform(post("/api/rrhh/ganancias-descuentos-fijos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createJson))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(createResp).get("data").get("id").asLong();

        mockMvc.perform(get("/api/rrhh/ganancias-descuentos-fijos/{id}", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").value(id));
    }

    @Test
    @DisplayName("GET con ID inexistente -> retorna 404")
    void obtener_conIdInexistente_retornaNotFound() throws Exception {
        mockMvc.perform(get("/api/rrhh/ganancias-descuentos-fijos/99999")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    // ==== UPDATE ====

    @Test
    @DisplayName("PUT /api/rrhh/ganancias-descuentos-fijos/{id} -> actualiza y retorna")
    void actualizar_conDatosValidos_retornaOk() throws Exception {
        Long trabajadorId = crearTrabajador();
        Long conceptoId = crearConcepto();

        String createJson = """
            {"trabajadorId":%d,"conceptoId":%d,"impGanDesc":500.0000,"flagEstado":"1"}
            """.formatted(trabajadorId, conceptoId);

        String createResp = mockMvc.perform(post("/api/rrhh/ganancias-descuentos-fijos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createJson))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(createResp).get("data").get("id").asLong();

        String updateJson = """
            {"trabajadorId":%d,"conceptoId":%d,"impGanDesc":600.0000,"flagEstado":"1"}
            """.formatted(trabajadorId, conceptoId);

        mockMvc.perform(put("/api/rrhh/ganancias-descuentos-fijos/{id}", id)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(updateJson))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.impGanDesc").value(600.0000));
    }

    // ==== PATCH ESTADO ====

    @Test
    @DisplayName("PATCH /api/rrhh/ganancias-descuentos-fijos/{id}/estado -> inactiva registro")
    void cambiarEstado_conDatosValidos_retornaOk() throws Exception {
        Long trabajadorId = crearTrabajador();
        Long conceptoId = crearConcepto();

        String createJson = """
            {"trabajadorId":%d,"conceptoId":%d,"impGanDesc":500.0000,"flagEstado":"1"}
            """.formatted(trabajadorId, conceptoId);

        String createResp = mockMvc.perform(post("/api/rrhh/ganancias-descuentos-fijos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createJson))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(createResp).get("data").get("id").asLong();

        String patchJson = """
            {"flagEstado": "0"}
            """;

        mockMvc.perform(patch("/api/rrhh/ganancias-descuentos-fijos/{id}/estado", id)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(patchJson))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.flagEstado").value("0"));
    }

    // ==== VALIDATIONS ====

    @Test
    @DisplayName("POST -> con datos inválidos retorna 400")
    void crear_conDatosInvalidos_retornaBadRequest() throws Exception {
        String requestJson = """
            {
                "trabajadorId": null,
                "conceptoId": null,
                "impGanDesc": 500.0000
            }
            """;

        mockMvc.perform(post("/api/rrhh/ganancias-descuentos-fijos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.success").value(false));
    }
}
