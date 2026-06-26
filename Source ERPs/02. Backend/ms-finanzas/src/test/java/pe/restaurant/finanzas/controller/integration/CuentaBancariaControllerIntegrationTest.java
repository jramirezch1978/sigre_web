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
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import org.mockito.Mockito;
import org.springframework.boot.test.mock.mockito.MockBean;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.finanzas.testdata.FinanzasTestDataExecutionListener;
import pe.restaurant.common.testutil.TestDataSeeder;
import pe.restaurant.finanzas.client.CoreMaestrosClient;
import pe.restaurant.finanzas.dto.response.MonedaResponse;
import pe.restaurant.finanzas.dto.response.PlanContableDetResponse;

import javax.sql.DataSource;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;

import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.ResultActions;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;

import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.mockito.ArgumentMatchers.anyLong;

/**
 * Tests de integración para CuentaBancariaController con datos reales en base de datos.
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
@DisplayName("Pruebas de Integración - CuentaBancariaController")
class CuentaBancariaControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

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

        authToken = "Bearer mock-token";

        // Mock CoreMaestrosClient - validaciones de servicio externo
        PlanContableDetResponse planContableDet = new PlanContableDetResponse(2L, "42120101", "TEST", "D", "D", "1");
        Mockito.when(coreMaestrosClient.obtenerPlanContableDetPorId(anyLong()))
            .thenReturn(ApiResponse.ok(planContableDet));
        MonedaResponse moneda = new MonedaResponse(1L, "PEN", "SOLES", "S/", "1");
        Mockito.when(coreMaestrosClient.obtenerMonedaPorId(anyLong()))
            .thenReturn(ApiResponse.ok(moneda));

        // Maestros comunes necesarios para CuentaBancaria
        TestDataSeeder testDataSeeder = new TestDataSeeder(dataSource);
        testDataSeeder.seedMoneda();
        testDataSeeder.seedPlanContable();
        testDataSeeder.seedBanco();
        testDataSeeder.seedBancoCnta();
    }

    private ResultActions performWithTenant(RequestBuilder requestBuilder) throws Exception {
        if (requestBuilder instanceof MockHttpServletRequestBuilder) {
            ((MockHttpServletRequestBuilder) requestBuilder)
                .header("X-Empresa-Id", "2")
                .header("X-Sucursal-Id", "1");
        }
        return mockMvc.perform(requestBuilder);
    }

    @Test
    @DisplayName("GET /api/finanzas/cuentas-bancarias - Debe listar cuentas bancarias")
    void listar_CuentasBancarias_DebeRetornarLista() throws Exception {
        performWithTenant(get("/api/finanzas/cuentas-bancarias")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").exists());
    }

    @Test
    @DisplayName("GET /api/finanzas/cuentas-bancarias/{id} - Debe obtener cuenta bancaria por ID")
    void obtener_CuentaBancaria_DebeRetornarDatos() throws Exception {
        // Asumimos que TestDataSeeder.seedBancoCnta() insertó una cuenta con ID=1
        performWithTenant(get("/api/finanzas/cuentas-bancarias/1")
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").exists());
    }

    @Test
    @DisplayName("POST /api/finanzas/cuentas-bancarias - Debe crear cuenta bancaria")
    void crear_CuentaBancaria_DebeCrearYRetornar() throws Exception {
        String requestJson = """
            {
                "codigo": "CTA-999",
                "bancoId": 1,
                "planContableDetId": 2,
                "saldoContable": 1000.00,
                "nroCuenta": "191-1234567890-0-00",
                "tipoCtaBco": "A",
                "monedaId": 1,
                "descripcion": "Cuenta de prueba"
            }
            """;

        performWithTenant(post("/api/finanzas/cuentas-bancarias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.codigo").value("CTA-999"));
    }

    @Test
    @DisplayName("PUT /api/finanzas/cuentas-bancarias/{id} - Debe actualizar cuenta bancaria existente")
    void actualizar_CuentaBancaria_DebeActualizarYRetornar() throws Exception {
        // Primero crear una cuenta bancaria para tener un ID válido
        String requestJson = """
            {
                "codigo": "CTA-998",
                "bancoId": 1,
                "planContableDetId": 2,
                "saldoContable": 1000.00,
                "nroCuenta": "191-1111111111-0-00",
                "tipoCtaBco": "A",
                "monedaId": 1,
                "descripcion": "Cuenta original"
            }
            """;

        String response = performWithTenant(post("/api/finanzas/cuentas-bancarias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long cuentaId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Actualizar la cuenta bancaria
        String requestActualizado = """
            {
                "codigo": "CTA-998",
                "bancoId": 1,
                "planContableDetId": 2,
                "saldoContable": 1000.00,
                "nroCuenta": "191-1111111111-0-00",
                "tipoCtaBco": "C",
                "monedaId": 1,
                "descripcion": "Cuenta actualizada"
            }
            """;

        performWithTenant(put("/api/finanzas/cuentas-bancarias/{id}", cuentaId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestActualizado))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(cuentaId))
                .andExpect(jsonPath("$.data.descripcion").value("Cuenta actualizada"));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/cuentas-bancarias/{id} - Debe eliminar cuenta bancaria")
    void eliminar_CuentaBancaria_DebeEliminarYRetornar() throws Exception {
        // Primero crear una cuenta bancaria para tener un ID válido
        String requestJson = """
            {
                "codigo": "CTA-997",
                "bancoId": 1,
                "planContableDetId": 2,
                "saldoContable": 1000.00,
                "nroCuenta": "191-2222222222-0-00",
                "tipoCtaBco": "A",
                "monedaId": 1,
                "descripcion": "Cuenta a eliminar"
            }
            """;

        String response = performWithTenant(post("/api/finanzas/cuentas-bancarias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long cuentaId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Eliminar la cuenta bancaria
        performWithTenant(delete("/api/finanzas/cuentas-bancarias/{id}", cuentaId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/cuentas-bancarias/{id}/activar - Debe activar cuenta bancaria")
    void activar_CuentaBancaria_DebeActivarYRetornar() throws Exception {
        // Primero crear una cuenta bancaria para tener un ID válido
        String requestJson = """
            {
                "codigo": "CTA-996",
                "bancoId": 1,
                "planContableDetId": 2,
                "saldoContable": 1000.00,
                "nroCuenta": "191-3333333333-0-00",
                "tipoCtaBco": "A",
                "monedaId": 1,
                "descripcion": "Cuenta a activar"
            }
            """;

        String response = performWithTenant(post("/api/finanzas/cuentas-bancarias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long cuentaId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Activar la cuenta bancaria
        performWithTenant(patch("/api/finanzas/cuentas-bancarias/{id}/activar", cuentaId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(cuentaId));
    }

    @Test
    @DisplayName("PATCH /api/finanzas/cuentas-bancarias/{id}/desactivar - Debe desactivar cuenta bancaria")
    void desactivar_CuentaBancaria_DebeDesactivarYRetornar() throws Exception {
        // Primero crear una cuenta bancaria para tener un ID válido
        String requestJson = """
            {
                "codigo": "CTA-995",
                "bancoId": 1,
                "planContableDetId": 2,
                "saldoContable": 1000.00,
                "nroCuenta": "191-4444444444-0-00",
                "tipoCtaBco": "A",
                "monedaId": 1,
                "descripcion": "Cuenta a desactivar"
            }
            """;

        String response = performWithTenant(post("/api/finanzas/cuentas-bancarias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long cuentaId = objectMapper.readTree(response).get("data").get("id").asLong();

        // Desactivar la cuenta bancaria
        performWithTenant(patch("/api/finanzas/cuentas-bancarias/{id}/desactivar", cuentaId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(cuentaId));
    }

    @Test
    @DisplayName("GET /api/finanzas/cuentas-bancarias/{id}/saldo - Debe obtener saldo de cuenta bancaria")
    void obtenerSaldo_CuentaBancaria_DebeRetornarSaldo() throws Exception {
        String createRequest = """
            {
                "codigo": "CTA-SALDO",
                "bancoId": 1,
                "planContableDetId": 2,
                "saldoContable": 5000.00,
                "nroCuenta": "191-9999999999-0-00",
                "tipoCtaBco": "A",
                "monedaId": 1,
                "descripcion": "Cuenta para saldo"
            }
            """;
        String createResponse = performWithTenant(post("/api/finanzas/cuentas-bancarias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createRequest))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        Long cuentaId = objectMapper.readTree(createResponse).get("data").get("id").asLong();

        performWithTenant(get("/api/finanzas/cuentas-bancarias/{id}/saldo", cuentaId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").exists());
    }

    @Test
    @DisplayName("GET /api/finanzas/cuentas-bancarias/{id} - Debe retornar 404 con ID inexistente")
    void obtener_CuentaBancaria_ConIdInexistente_DebeRetornar404() throws Exception {
        performWithTenant(get("/api/finanzas/cuentas-bancarias/9999")
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("PUT /api/finanzas/cuentas-bancarias/{id} - Debe retornar 404 con ID inexistente")
    void actualizar_CuentaBancaria_ConIdInexistente_DebeRetornar404() throws Exception {
        String requestJson = """
            {
                "codigo": "CTA-994",
                "bancoId": 1,
                "planContableDetId": 2,
                "saldoContable": 1000.00,
                "nroCuenta": "191-5555555555-0-00",
                "tipoCtaBco": "A",
                "monedaId": 1,
                "descripcion": "Cuenta inexistente"
            }
            """;

        performWithTenant(put("/api/finanzas/cuentas-bancarias/{id}", 9999)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestJson))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("DELETE /api/finanzas/cuentas-bancarias/{id} - Debe retornar 404 con ID inexistente")
    void eliminar_CuentaBancaria_ConIdInexistente_DebeRetornar404() throws Exception {
        performWithTenant(delete("/api/finanzas/cuentas-bancarias/{id}", 9999)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /api/finanzas/cuentas-bancarias - Debe retornar error de validación con datos inválidos")
    void crear_CuentaBancaria_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "codigo": "",
                "bancoId": null,
                "planContableDetId": null,
                "saldoContable": null
            }
            """;

        performWithTenant(post("/api/finanzas/cuentas-bancarias")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }
}
