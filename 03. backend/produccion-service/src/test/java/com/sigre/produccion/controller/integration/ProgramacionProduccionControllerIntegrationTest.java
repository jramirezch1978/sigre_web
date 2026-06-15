package com.sigre.produccion.controller.integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.produccion.client.CoreSucursalClient;
import com.sigre.produccion.client.dto.SucursalResponse;

import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
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
@DisplayName("Pruebas de Integracion — ProgramacionProduccionController")
class ProgramacionProduccionControllerIntegrationTest {

    @Autowired private MockMvc mockMvc;

    @MockBean private CoreSucursalClient coreSucursalClient;

    private final String authToken = "Bearer mock-token";

    @BeforeEach
    void setUp() {
        var okResp = mock(ApiResponse.class);
        when(okResp.isSuccess()).thenReturn(true);
        when(okResp.getData()).thenReturn(new SucursalResponse(1L, "Sucursal Test", "1"));
        when(coreSucursalClient.obtenerPorId(anyLong())).thenReturn(okResp);
    }

    @Test
    @DisplayName("GET /api/produccion/programaciones -> retorna lista paginada")
    void listar_retornaPagina() throws Exception {
        mockMvc.perform(get("/api/produccion/programaciones")
                .header("Authorization", authToken))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }
}
