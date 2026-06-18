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
import pe.restaurant.rrhh.repository.ConceptoPlanillaRepository;
import pe.restaurant.rrhh.testdata.RrhhTestDataExecutionListener;
import org.springframework.boot.test.mock.mockito.MockBean;
import pe.restaurant.common.security.JwtTokenProvider;
import static org.mockito.Mockito.when;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static pe.restaurant.rrhh.constants.ConceptoPlanillaConstants.*;

/**
 * Tests de integración para ConceptoPlanillaController.
 * Sigue el estándar de TEST_STANDARDS.md con datos reales en BD.
 * 
 * @author Equipo de Desarrollo RRHH
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
@DisplayName("Pruebas de Integración - ConceptoPlanillaController")
class ConceptoPlanillaControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private ConceptoPlanillaRepository repository;

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
    }

    // ==== CREATE ====

    @Test
    @DisplayName("POST /api/rrhh/conceptos-planilla -> crea INGRESO y retorna 201")
    void crear_conceptoIngreso_retornaCreated() throws Exception {
        String requestJson = """
            {
                "codigo": "ING-IT-001",
                "nombre": "Sueldo Básico Test",
                "tipo": "INGRESO",
                "valorFijo": 3000.00,
                "afectoQuinta": true,
                "afectoEssalud": true,
                "aplicaTodos": true
            }
            """;

        mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.codigo").value("ING-IT-001"))
            .andExpect(jsonPath("$.data.tipo").value("INGRESO"));
    }

    @Test
    @DisplayName("POST /api/rrhh/conceptos-planilla -> crea DESCUENTO con fórmula y retorna 201")
    void crear_conceptoDescuentoConFormula_retornaCreated() throws Exception {
        String requestJson = """
            {
                "codigo": "DESC-IT-001",
                "nombre": "AFP Test",
                "tipo": "DESCUENTO",
                "formula": "SUELDO_BASICO * 0.13",
                "afectoQuinta": false,
                "afectoEssalud": false,
                "aplicaTodos": true
            }
            """;

        mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.codigo").value("DESC-IT-001"))
            .andExpect(jsonPath("$.data.tipo").value("DESCUENTO"))
            .andExpect(jsonPath("$.data.formula").value("SUELDO_BASICO * 0.13"));
    }

    @Test
    @DisplayName("POST /api/rrhh/conceptos-planilla -> crea APORTE y retorna 201")
    void crear_conceptoAporte_retornaCreated() throws Exception {
        String requestJson = """
            {
                "codigo": "APO-IT-001",
                "nombre": "EsSalud Test",
                "tipo": "APORTE",
                "formula": "SUELDO_BASICO * 0.09",
                "afectoQuinta": false,
                "afectoEssalud": false,
                "aplicaTodos": true
            }
            """;

        mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.codigo").value("APO-IT-001"))
            .andExpect(jsonPath("$.data.tipo").value("APORTE"));
    }

    // ==== READ - LIST ====

    @Test
    @DisplayName("GET /api/rrhh/conceptos-planilla -> lista con paginación")
    void listar_conPaginacion_retornaPagina() throws Exception {
        mockMvc.perform(get("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/conceptos-planilla?codigo=X -> filtra por código")
    void listar_conFiltroCodigo_retornaFiltrados() throws Exception {
        mockMvc.perform(get("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .param("codigo", "ING-TEST")
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/conceptos-planilla?tipo=INGRESO -> filtra por tipo")
    void listar_conFiltroTipo_retornaFiltrados() throws Exception {
        mockMvc.perform(get("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .param("tipo", "INGRESO")
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== READ - BY ID ====

    @Test
    @DisplayName("GET /api/rrhh/conceptos-planilla/{id} -> retorna concepto existente")
    void obtener_conIdExistente_retornaOk() throws Exception {
        String createJson = """
            {"codigo":"ING-GET-001","nombre":"GET Test","tipo":"INGRESO","valorFijo":1000,"afectoQuinta":true,"afectoEssalud":true,"aplicaTodos":true}
            """;
        String createResp = mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createJson))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();
        Long id = objectMapper.readTree(createResp).get("data").get("id").asLong();

        mockMvc.perform(get("/api/rrhh/conceptos-planilla/{id}", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").value(id));
    }

    @Test
    @DisplayName("GET /api/rrhh/conceptos-planilla/{id} con ID inexistente -> retorna 404")
    void obtener_conIdInexistente_retornaNotFound() throws Exception {
        mockMvc.perform(get("/api/rrhh/conceptos-planilla/99999")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    // ==== UPDATE ====

    @Test
    @DisplayName("PUT /api/rrhh/conceptos-planilla/{id} -> actualiza y retorna 201")
    void actualizar_conDatosValidos_retornaCreated() throws Exception {
        String createJson = """
            {"codigo":"ING-UPD-001","nombre":"Update Test","tipo":"INGRESO","valorFijo":1000,"afectoQuinta":true,"afectoEssalud":true,"aplicaTodos":true}
            """;
        String createResp = mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createJson))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();
        Long id = objectMapper.readTree(createResp).get("data").get("id").asLong();

        String requestJson = """
            {
                "nombre": "Sueldo Básico Actualizado",
                "tipo": "INGRESO",
                "valorFijo": 3500.00,
                "afectoQuinta": true,
                "afectoEssalud": true,
                "aplicaTodos": true
            }
            """;

        mockMvc.perform(put("/api/rrhh/conceptos-planilla/{id}", id)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.nombre").value("Sueldo Básico Actualizado"));
    }

    @Test
    @DisplayName("PUT /api/rrhh/conceptos-planilla/{id} con ID inexistente -> retorna 404")
    void actualizar_conIdInexistente_retornaNotFound() throws Exception {
        String requestJson = """
            {
                "nombre": "Test",
                "tipo": "INGRESO",
                "valorFijo": 1000.00,
                "afectoQuinta": true,
                "afectoEssalud": true,
                "aplicaTodos": true
            }
            """;

        mockMvc.perform(put("/api/rrhh/conceptos-planilla/99999")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    // ==== PATCH DESACTIVAR ====

    @Test
    @DisplayName("PATCH /api/rrhh/conceptos-planilla/{id}/desactivar -> desactiva y retorna ok")
    void desactivar_conIdValido_retornaOk() throws Exception {
        String createJson = """
            {"codigo":"ING-DEL-001","nombre":"Delete Test","tipo":"INGRESO","valorFijo":1000,"afectoQuinta":true,"afectoEssalud":true,"aplicaTodos":true}
            """;
        String createResp = mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createJson))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();
        Long id = objectMapper.readTree(createResp).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/rrhh/conceptos-planilla/{id}/desactivar", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/conceptos-planilla/{id}/desactivar con ID inexistente -> retorna 404")
    void desactivar_conIdInexistente_retornaNotFound() throws Exception {
        mockMvc.perform(patch("/api/rrhh/conceptos-planilla/99999/desactivar")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    // ==== VALIDATIONS ====

    @Test
    @DisplayName("POST con código duplicado -> retorna 409")
    void crear_conCodigoDuplicado_retornaConflict() throws Exception {
        String requestJson = """
            {
                "codigo": "ING-DUP-001",
                "nombre": "Original",
                "tipo": "INGRESO",
                "valorFijo": 1000.00,
                "afectoQuinta": true,
                "afectoEssalud": true,
                "aplicaTodos": true
            }
            """;

        mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated());

        mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.success").value(false));
    }
}
