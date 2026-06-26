package pe.restaurant.finanzas.controller.integration;

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
import java.math.BigDecimal;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.response.PaisResponse;
import pe.restaurant.finanzas.dto.response.SucursalResponse;
import pe.restaurant.finanzas.dto.response.TiposImpuestoResponse;

import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Pruebas de integración para CalculoImpuestosController.
 * Endpoint stateless que calcula impuestos sin persistir nada.
 * El país se resuelve desde la sucursal del token JWT vía Feign client (mockeado).
 *
 * @author Equipo de Desarrollo
 */
@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {TenantContextTestExecutionListener.class},
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - CalculoImpuestosController")
class CalculoImpuestosControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @MockBean
    private CoreMaestrosClient coreMaestrosClient;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private String authToken;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        // Mock auth token (sigue el patrón de los otros tests de integración)
        authToken = "Bearer mock-token";

        // Mock Feign: sucursal → paisId → pais con codigo "PE"
        SucursalResponse sucursal = new SucursalResponse();
        sucursal.setId(1L);
        sucursal.setPaisId(1L);
        when(coreMaestrosClient.obtenerSucursalPorId(anyLong()))
            .thenReturn(ApiResponse.ok(sucursal));

        PaisResponse pais = new PaisResponse();
        pais.setId(1L);
        pais.setCodigo("PE");
        pais.setNombre("Perú");
        when(coreMaestrosClient.obtenerPaisPorId(anyLong()))
            .thenReturn(ApiResponse.ok(pais));

        // Mock Feign: tipo impuesto 1 = IGV 18%
        TiposImpuestoResponse igv = new TiposImpuestoResponse();
        igv.setId(1L);
        igv.setDescImpuesto("IGV");
        igv.setTasaImpuesto(new BigDecimal("18.00"));
        igv.setFlagIgv("1");
        igv.setTipoCalculo(1);
        when(coreMaestrosClient.obtenerImpuestoPorId(1L))
            .thenReturn(ApiResponse.ok(igv));
    }

    @Test
    @DisplayName("POST /api/finanzas/calcular-impuestos - Debe calcular IGV correctamente para item gravado con valor incluye impuestos")
    void calcularImpuestos_conItemGravado_retorna200YCalculosCorrectos() throws Exception {
        String requestJson = """
            {
                "items": [
                    {
                        "item": 1,
                        "valorUnitario": 118.00,
                        "cantidad": 2,
                        "valorConIgv": true,
                        "impuestos": [
                            {
                                "tipoImpuestoId": 1,
                                "tipoCalculo": 1
                            }
                        ]
                    }
                ]
            }
            """;

        mockMvc.perform(post("/api/finanzas/calcular-impuestos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.pais").value("PE"))
            .andExpect(jsonPath("$.data.items[0].baseImponible").value(200.00))
            .andExpect(jsonPath("$.data.items[0].montoTotal").value(236.00))
            .andExpect(jsonPath("$.data.items[0].impuestos[0].importe").value(36.00))
            .andExpect(jsonPath("$.data.consolidado.subtotal").value(200.00))
            .andExpect(jsonPath("$.data.consolidado.totalIgv").value(36.00));
    }

    @Test
    @DisplayName("POST /api/finanzas/calcular-impuestos - Debe retornar item como inafecto cuando no tiene impuestos")
    void calcularImpuestos_conItemInafecto_retornaSinImpuestos() throws Exception {
        String requestJson = """
            {
                "items": [
                    {
                        "item": 1,
                        "valorUnitario": 100.00,
                        "cantidad": 1,
                        "valorConIgv": false,
                        "impuestos": []
                    }
                ]
            }
            """;

        mockMvc.perform(post("/api/finanzas/calcular-impuestos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.items[0].esInafecto").value(true))
            .andExpect(jsonPath("$.data.items[0].impuestos").isEmpty());
    }

    @Test
    @DisplayName("POST /api/finanzas/calcular-impuestos - Debe calcular con 2 items, ambos gravados")
    void calcularImpuestos_conMultiplesItems_retornaConsolidadoCorrecto() throws Exception {
        String requestJson = """
            {
                "items": [
                    {
                        "item": 1,
                        "valorUnitario": 59.00,
                        "cantidad": 2,
                        "valorConIgv": true,
                        "impuestos": [
                            {
                                "tipoImpuestoId": 1,
                                "tipoCalculo": 1
                            }
                        ]
                    },
                    {
                        "item": 2,
                        "valorUnitario": 40.00,
                        "cantidad": 3,
                        "valorConIgv": false,
                        "impuestos": [
                            {
                                "tipoImpuestoId": 1,
                                "tipoCalculo": 1
                            }
                        ]
                    }
                ]
            }
            """;

        // Item 1: 59 * 2 = 118 total con IGV incluido → base = 118/1.18 = 100, IGV = 18
        // Item 2: 40 * 3 = 120 base sin IGV → IGV = 120 * 0.18 = 21.60
        // Consolidado: subtotal = 100 + 120 = 220, totalIgv = 18 + 21.60 = 39.60

        mockMvc.perform(post("/api/finanzas/calcular-impuestos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.pais").value("PE"))
            // Item 1
            .andExpect(jsonPath("$.data.items[0].item").value(1))
            .andExpect(jsonPath("$.data.items[0].baseImponible").value(100.00))
            .andExpect(jsonPath("$.data.items[0].montoTotal").value(118.00))
            .andExpect(jsonPath("$.data.items[0].impuestos[0].importe").value(18.00))
            // Item 2
            .andExpect(jsonPath("$.data.items[1].item").value(2))
            .andExpect(jsonPath("$.data.items[1].baseImponible").value(120.00))
            .andExpect(jsonPath("$.data.items[1].montoTotal").value(141.60))
            .andExpect(jsonPath("$.data.items[1].impuestos[0].importe").value(21.60))
            // Consolidado
            .andExpect(jsonPath("$.data.consolidado.subtotal").value(220.00))
            .andExpect(jsonPath("$.data.consolidado.totalIgv").value(39.60))
            .andExpect(jsonPath("$.data.consolidado.totalConImpuestos").value(259.60));
    }

    @Test
    @DisplayName("POST /api/finanzas/calcular-impuestos - Debe retornar 400 cuando items es null")
    void calcularImpuestos_sinItems_retorna400() throws Exception {
        String requestJson = """
            {
                "descuentoGlobal": 0,
                "items": null
            }
            """;

        mockMvc.perform(post("/api/finanzas/calcular-impuestos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
            .andExpect(status().isBadRequest())
            .andExpect(jsonPath("$.success").value(false));
    }
}
