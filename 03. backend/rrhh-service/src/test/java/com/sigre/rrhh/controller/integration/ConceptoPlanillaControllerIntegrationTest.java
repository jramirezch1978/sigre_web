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
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import com.sigre.common.security.JwtTokenProvider;
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.rrhh.repository.ConceptoPlanillaRepository;
import com.sigre.rrhh.testdata.RrhhTestDataExecutionListener;

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
    @DisplayName("POST /api/rrhh/conceptos-planilla -> crea concepto SIGRE y retorna 201")
    void crear_conceptoSigre_retornaCreated() throws Exception {
        String requestJson = bodySigre("IT-1013", "1013", "PRIMA DE FRIO", "10");

        mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.codigo").value("IT-1013"))
            .andExpect(jsonPath("$.data.grupoCalculo").value("10"));
    }

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
    @DisplayName("GET /api/rrhh/conceptos-planilla?grupoCalculo=10 -> filtra por grupo")
    void listar_conFiltroGrupoCalculo_retornaFiltrados() throws Exception {
        mockMvc.perform(get("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .param("grupoCalculo", "10")
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/conceptos-planilla/{id} -> retorna concepto existente")
    void obtener_conIdExistente_retornaOk() throws Exception {
        String createResp = mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(bodySigre("IT-GET-001", "GET-001", "GET Test", "10")))
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
    @DisplayName("PUT /api/rrhh/conceptos-planilla/{id} -> actualiza y retorna 200")
    void actualizar_conDatosValidos_retornaOk() throws Exception {
        String createResp = mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(bodySigre("IT-UPD-001", "UPD-001", "Update Test", "10")))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();
        Long id = objectMapper.readTree(createResp).get("data").get("id").asLong();

        String requestJson = """
            {
                "nombre": "PRIMA DE FRIO ACTUALIZADA",
                "descripcionBreve": "PRIMA",
                "factorPago": 1.5,
                "importeTopeMin": 0,
                "importeTopeMax": 0,
                "grupoCalculo": "10",
                "flagReplicacion": "1",
                "flagSubsidio": "0",
                "flagReporteQuinta": "0"
            }
            """;

        mockMvc.perform(put("/api/rrhh/conceptos-planilla/{id}", id)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.nombre").value("PRIMA DE FRIO ACTUALIZADA"));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/conceptos-planilla/{id}/desactivar -> desactiva y retorna ok")
    void desactivar_conIdValido_retornaOk() throws Exception {
        String createResp = mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(bodySigre("IT-DEL-001", "DEL-001", "Delete Test", "10")))
            .andExpect(status().isCreated())
            .andReturn().getResponse().getContentAsString();
        Long id = objectMapper.readTree(createResp).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/rrhh/conceptos-planilla/{id}/desactivar", id)
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("POST con código duplicado -> retorna 400")
    void crear_conCodigoDuplicado_retornaConflict() throws Exception {
        String requestJson = bodySigre("IT-DUP-001", "DUP-001", "Original", "10");

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

    private String bodySigre(String codigo, String numeroOrden, String nombre, String grupoCalculo) {
        return """
            {
                "codigo": "%s",
                "nombre": "%s",
                "descripcionBreve": "%s",
                "factorPago": 1,
                "importeTopeMin": 0,
                "importeTopeMax": 0,
                "grupoCalculo": "%s",
                "flagReplicacion": "1",
                "conceptoRtps": "0303",
                "flagSubsidio": "0",
                "flagReporteQuinta": "0",
                "numeroOrden": "%s"
            }
            """.formatted(codigo, nombre, nombre, grupoCalculo, numeroOrden);
    }
}
