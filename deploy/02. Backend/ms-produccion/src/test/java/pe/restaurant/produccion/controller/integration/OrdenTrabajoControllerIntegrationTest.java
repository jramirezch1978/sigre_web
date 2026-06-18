package pe.restaurant.produccion.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.produccion.client.CoreArticuloClient;
import pe.restaurant.produccion.client.CoreSucursalClient;
import pe.restaurant.produccion.client.CoreUnidadMedidaClient;
import pe.restaurant.produccion.client.dto.SucursalResponse;

import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest
@AutoConfigureMockMvc(addFilters = false)
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = TenantContextTestExecutionListener.class,
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integracion — OrdenTrabajoController")
class OrdenTrabajoControllerIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private ObjectMapper objectMapper;

    @MockBean private CoreSucursalClient coreSucursalClient;
    @MockBean private CoreArticuloClient coreArticuloClient;
    @MockBean private CoreUnidadMedidaClient coreUnidadMedidaClient;

    private final String authToken = "Bearer mock-token";

    @BeforeEach
    void setUp() {
        var sucursalResp = mock(ApiResponse.class);
        when(sucursalResp.isSuccess()).thenReturn(true);
        when(sucursalResp.getData()).thenReturn(new SucursalResponse(1L, "Sucursal Test", "1"));
        when(coreSucursalClient.obtenerPorId(anyLong())).thenReturn(sucursalResp);

        var articuloResp = mock(ApiResponse.class);
        when(articuloResp.isSuccess()).thenReturn(true);
        when(articuloResp.getData()).thenReturn(mock(Object.class));
        when(coreArticuloClient.obtenerPorId(anyLong())).thenReturn(articuloResp);
        when(coreUnidadMedidaClient.obtenerPorId(anyLong())).thenReturn(articuloResp);
    }

    @Test
    @DisplayName("GET /api/produccion/ordenes-trabajo -> retorna lista paginada")
    void listar_retornaPagina() throws Exception {
        mockMvc.perform(get("/api/produccion/ordenes-trabajo")
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/produccion/ordenes-trabajo/{id} con ID inexistente -> 404")
    void obtener_conIdInexistente_retornaNotFound() throws Exception {
        mockMvc.perform(get("/api/produccion/ordenes-trabajo/99999")
                .header("Authorization", authToken))
            .andExpect(status().isNotFound())
            .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/produccion/ordenes-trabajo -> crea y retorna 201")
    void crear_conDatosValidos_retornaCreated() throws Exception {
        String body = "{"
            + "\"sucursalId\": 1,"
            + "\"otTipoId\": 1,"
            + "\"otAdministracionId\": 1,"
            + "\"codigo\": \"OT-IT-" + System.nanoTime() % 100000 + "\","
            + "\"fechaInicio\": \"2026-06-01\","
            + "\"fechaFin\": \"2026-06-30\""
            + "}";

        mockMvc.perform(post("/api/produccion/ordenes-trabajo")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").exists());
    }
}
