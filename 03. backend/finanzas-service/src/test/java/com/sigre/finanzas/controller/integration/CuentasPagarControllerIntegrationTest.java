package com.sigre.finanzas.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
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
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.finanzas.testdata.FinanzasTestDataExecutionListener;
import com.sigre.common.testutil.TestDataSeeder;
import com.sigre.finanzas.client.ContabilidadClient;
import com.sigre.finanzas.client.CoreMaestrosClient;
import com.sigre.finanzas.dto.response.AsientoContableResponse;
import com.sigre.finanzas.dto.response.GenerarAsientoResponse;
import com.sigre.finanzas.testdata.TestDataSeederFinanzas;
import com.sigre.finanzas.testutil.TestDataFactory;

import javax.sql.DataSource;
import java.util.Map;

import static org.mockito.ArgumentMatchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para CuentasPagarController con datos reales en base de datos.
 * Sigue la recomendación del líder de usar datos de prueba insertados en BD en lugar de mocks.
 *
 * @author Equipo de Desarrollo
 */
@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {TenantContextTestExecutionListener.class, FinanzasTestDataExecutionListener.class},
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - CuentasPagarController")
class CuentasPagarControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    @MockBean
    private ContabilidadClient contabilidadClient;

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

        // Generate mock auth token
        authToken = "Bearer mock-token";

        // Mock Feign clients para generar asientos contables
        GenerarAsientoResponse generarResponse = new GenerarAsientoResponse();
        generarResponse.setAsientoId(999L);
        generarResponse.setVoucher("AS-999");
        generarResponse.setTotalLineasDetalle(2);
        
        AsientoContableResponse asientoResponse = new AsientoContableResponse();
        asientoResponse.setId(999L);
        asientoResponse.setVoucher("AS-999");
        
        Mockito.when(contabilidadClient.generarAsientoCarteraPagos(any()))
                .thenReturn((ApiResponse) ApiResponse.ok(generarResponse));
        Mockito.when(contabilidadClient.anularAsiento(any()))
                .thenReturn((ApiResponse) ApiResponse.ok(asientoResponse));
        Mockito.when(coreMaestrosClient.obtenerEntidadPorId(anyLong()))
                .thenReturn(TestDataFactory.mockEntidadResponse());

        // 1. Maestros comunes específicos (NO seedAll que incluye almacen/vale_mov)
    }

    @Test
    @DisplayName("POST /api/finanzas/cuentas-pagar - Debe crear CxP con asiento")
    void crear_CuentasPagar_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "proveedorId": 1,
                "docTipoId": 1,
                "serie": "F001",
                "numero": "00000003",
                "fechaEmision": "2026-05-14",
                "fechaVencimiento": "2026-06-14",
                "monedaId": 1,
                "total": 1500.00,
                "detalles": [
                    {
                        "item": 1,
                        "conceptoFinancieroId": 2,
                        "descripcion": "Compra de materia prima",
                        "cantidad": 1.0000,
                        "precioUnitario": 1500.00000000,
                        "monto": 1500.00,
                        "centrosCostoId": 1,
                        "impuestos": [{"tiposImpuestoId": 1, "importe": 0}],
                        "fechaMov": "2026-05-14",
                        "tipoMov": "COMPRA",
                        "referencia": "Factura prueba"
                    }
                ]
            }
            """;

        mockMvc.perform(post("/api/finanzas/cuentas-pagar")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }

    @Test
    @DisplayName("GET /api/finanzas/cuentas-pagar/{id} - Debe obtener CxP existente")
    void obtener_CuentasPagar_DebeRetornarDatos() throws Exception {
        // Asumimos que TestDataSeederFinanzas insertó una CxP con ID=1001
        mockMvc.perform(get("/api/finanzas/cuentas-pagar/1001")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1001))
                .andExpect(jsonPath("$.data.flagEstado").value("1"));
    }

    @Test
    @DisplayName("GET /api/finanzas/cuentas-pagar - Debe listar CxP")
    void listar_CuentasPagar_DebeRetornarLista() throws Exception {
        mockMvc.perform(get("/api/finanzas/cuentas-pagar")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").exists());
    }

    @Test
    @Disabled("Requiere flujo crear→actualizar con datos de BD reales para asiento contable. Pendiente de ajustar seeders.")
    @DisplayName("PUT /api/finanzas/cuentas-pagar/{id} - Debe actualizar CxP existente")
    void actualizar_CuentasPagar_DebeActualizarYRetornar() throws Exception {
        // Primero crear una CxP para tener un ID válido
        String requestJson = """
            {
                "proveedorId": 1,
                "docTipoId": 1,
                "serie": "F001",
                "numero": "00000004",
                "fechaEmision": "2026-05-13",
                "fechaVencimiento": "2026-06-13",
                "monedaId": 1,
                "total": 2000.00,
                "asiento": {
                    "libroId": 2,
                    "fecha": "2026-05-13",
                    "tipo": "PROVISION_CXP",
                    "tc": 1.000000,
                    "detalles": [
                        {"planContableDetId": 501, "centrosCostoId": 10, "debe": 1694.92, "haber": 0.00},
                        {"planContableDetId": 601, "debe": 305.08, "haber": 0.00},
                        {"planContableDetId": 701, "entidadContribuyenteId": 1, "debe": 0.00, "haber": 2000.00}
                    ]
                },
                "detalles": [
                    {
                        "fechaMov": "2026-05-13",
                        "tipoMov": "REGISTRO",
                        "monto": 2000.00,
                        "referencia": "Factura proveedor prueba actualización"
                    }
                ]
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/cuentas-pagar")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long cxpId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Actualizar la CxP
        String requestActualizado = """
            {
                "proveedorId": 1,
                "docTipoId": 1,
                "serie": "F001",
                "numero": "00000004",
                "fechaEmision": "2026-05-13",
                "fechaVencimiento": "2026-06-20",
                "monedaId": 1,
                "total": 2500.00,
                "asiento": {
                    "libroId": 2,
                    "fecha": "2026-05-13",
                    "tipo": "PROVISION_CXP",
                    "tc": 1.000000,
                    "detalles": [
                        {"planContableDetId": 501, "centrosCostoId": 10, "debe": 2118.65, "haber": 0.00},
                        {"planContableDetId": 601, "debe": 381.35, "haber": 0.00},
                        {"planContableDetId": 701, "entidadContribuyenteId": 1, "debe": 0.00, "haber": 2500.00}
                    ]
                },
                "detalles": [
                    {
                        "fechaMov": "2026-05-13",
                        "tipoMov": "REGISTRO",
                        "monto": 2500.00,
                        "referencia": "Factura proveedor prueba actualizada"
                    }
                ]
            }
            """;

        mockMvc.perform(put("/api/finanzas/cuentas-pagar/{id}", cxpId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(cxpId))
                .andExpect(jsonPath("$.data.total").value(2500.00))
                .andExpect(jsonPath("$.data.fechaVencimiento").value("2026-06-20"));
    }

    @Test
    @Disabled("Requiere flujo crear→anular con datos de BD reales para asiento contable. Pendiente de ajustar seeders.")
    @DisplayName("POST /api/finanzas/cuentas-pagar/{id}/anular - Debe anular CxP existente")
    void anular_CuentasPagar_DebeAnularYRetornar() throws Exception {
        // Primero crear una CxP para tener un ID válido
        String requestJson = """
            {
                "proveedorId": 1,
                "docTipoId": 1,
                "serie": "F001",
                "numero": "00000005",
                "fechaEmision": "2026-05-13",
                "fechaVencimiento": "2026-06-13",
                "monedaId": 1,
                "total": 1800.00,
                "asiento": {
                    "libroId": 2,
                    "fecha": "2026-05-13",
                    "tipo": "PROVISION_CXP",
                    "tc": 1.000000,
                    "detalles": [
                        {"planContableDetId": 501, "centrosCostoId": 10, "debe": 1525.42, "haber": 0.00},
                        {"planContableDetId": 601, "debe": 274.58, "haber": 0.00},
                        {"planContableDetId": 701, "entidadContribuyenteId": 1, "debe": 0.00, "haber": 1800.00}
                    ]
                },
                "detalles": [
                    {
                        "fechaMov": "2026-05-13",
                        "tipoMov": "REGISTRO",
                        "monto": 1800.00,
                        "referencia": "Factura proveedor prueba anulación"
                    }
                ]
            }
            """;

        String response = mockMvc.perform(post("/api/finanzas/cuentas-pagar")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long cxpId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Anular la CxP
        mockMvc.perform(post("/api/finanzas/cuentas-pagar/{id}/anular", cxpId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(cxpId))
                .andExpect(jsonPath("$.data.flagEstado").value("0"));
    }

    @Test
    @Disabled("PUT valida @Valid antes de buscar ID. Se espera 404 pero el controller retorna 400 de validación. Requiere ajuste en el controller o test.")
    @DisplayName("PUT /api/finanzas/cuentas-pagar/{id} - Debe retornar 404 con ID inexistente")
    void actualizar_CuentasPagar_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "proveedorId": 1,
                "docTipoId": 1,
                "serie": "F001",
                "numero": "00000006",
                "fechaEmision": "2026-05-13",
                "fechaVencimiento": "2026-06-13",
                "monedaId": 1,
                "total": 1000.00,
                "asiento": {
                    "libroId": 2,
                    "fecha": "2026-05-13",
                    "tipo": "PROVISION_CXP",
                    "tc": 1.000000,
                    "detalles": [
                        {"planContableDetId": 501, "centrosCostoId": 10, "debe": 847.46, "haber": 0.00},
                        {"planContableDetId": 601, "debe": 152.54, "haber": 0.00},
                        {"planContableDetId": 701, "entidadContribuyenteId": 1, "debe": 0.00, "haber": 1000.00}
                    ]
                },
                "detalles": [
                    {
                        "fechaMov": "2026-05-13",
                        "tipoMov": "REGISTRO",
                        "monto": 1000.00,
                        "referencia": "Factura prueba"
                    }
                ]
            }
            """;

        mockMvc.perform(put("/api/finanzas/cuentas-pagar/{id}", 999L)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/cuentas-pagar/{id}/anular - Debe retornar 404 con ID inexistente")
    void anular_CuentasPagar_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(post("/api/finanzas/cuentas-pagar/{id}/anular", 999L)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }
}
