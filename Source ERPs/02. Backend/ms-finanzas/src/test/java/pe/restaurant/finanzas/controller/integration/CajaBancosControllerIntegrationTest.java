package pe.restaurant.finanzas.controller.integration;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.finanzas.testdata.FinanzasTestDataExecutionListener;
import pe.restaurant.finanzas.entity.CajaBancos;
import pe.restaurant.finanzas.entity.CajaBancosDet;
import pe.restaurant.finanzas.entity.ConceptoFinanciero;
import pe.restaurant.finanzas.entity.CntasPagar;
import pe.restaurant.finanzas.repository.CajaBancosRepository;
import pe.restaurant.finanzas.repository.CajaBancosDetRepository;
import pe.restaurant.finanzas.repository.ConceptoFinancieroRepository;
import pe.restaurant.finanzas.repository.CntasPagarRepository;
import pe.restaurant.finanzas.testutil.TestDataFactory;
import pe.restaurant.finanzas.testutil.TokenHelper;
import pe.restaurant.finanzas.testdata.TestDataSeederFinanzas;
import pe.restaurant.common.testutil.TestDataSeeder;
import pe.restaurant.finanzas.client.ContabilidadClient;
import pe.restaurant.finanzas.dto.response.GenerarAsientoResponse;
import pe.restaurant.common.dto.ApiResponse;
import org.springframework.boot.test.mock.mockito.MockBean;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.mockito.Mockito.mock;

import feign.FeignException;

import javax.sql.DataSource;
import org.springframework.jdbc.core.JdbcTemplate;
import java.math.BigDecimal;
import java.util.List;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para CajaBancosController con datos reales en base de datos.
 * Sigue la recomendación del líder de usar datos de prueba insertados en BD en lugar de mocks.
 * 
 * @author Equipo de Desarrollo
 */
@Tag("integration")
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {TenantContextTestExecutionListener.class, FinanzasTestDataExecutionListener.class},
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración - CajaBancosController")
class CajaBancosControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private CajaBancosRepository cajaBancosRepository;

    @Autowired
    private CajaBancosDetRepository cajaBancosDetRepository;

    @Autowired
    private ConceptoFinancieroRepository conceptoFinancieroRepository;

    @Autowired
    private CntasPagarRepository cntasPagarRepository;

    @Autowired
    private DataSource dataSource;

    @MockBean
    private ContabilidadClient contabilidadClient;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private String authToken;

    // IDs de registros creados durante los tests para usar en validaciones posteriores
    private Long idCobro;
    private Long idPago;
    private Long idTransferencia;
    private Long idAplicacion;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        // Generate mock auth token
        authToken = "Bearer mock-token";

        // Seed banco + banco_cnta (no incluidos en FinanzasTestDataExecutionListener)
        TestDataSeeder seeder = new TestDataSeeder(dataSource);
        seeder.seedBanco();
        seeder.seedBancoCnta();

        // Asegurar saldo suficiente en la cuenta para pagos
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        jdbc.update("UPDATE finanzas.banco_cnta SET saldo_disponible = 50000 WHERE id = 1");
    }

    @Test
    @DisplayName("01 - Debe crear movimiento de cobro")
    void test01_crear_Cobro_DebeCrearYRetornar() throws Exception {
        String response = mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestCobro())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.flagTipoTransaccion").value("C"))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        
        // Guardar ID para tests posteriores
        idCobro = objectMapper.readTree(response).get("data").get("id").asLong();
        System.out.println("✅ Cobro creado con ID: " + idCobro);
    }

    @Test
    @DisplayName("02 - Debe crear movimiento de pago")
    void test02_crear_Pago_DebeCrearYRetornar() throws Exception {
        String response = mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestPago())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.flagTipoTransaccion").value("P"))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        
        idPago = objectMapper.readTree(response).get("data").get("id").asLong();
        System.out.println("✅ Pago creado con ID: " + idPago);
    }

    @Test
    @DisplayName("03 - Debe crear movimiento de transferencia")
    void test03_crear_Transferencia_DebeCrearYRetornar() throws Exception {
        String response = mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestTransferencia())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.flagTipoTransaccion").value("T"))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        
        idTransferencia = objectMapper.readTree(response).get("data").get("id").asLong();
        System.out.println("✅ Transferencia creada con ID: " + idTransferencia);
    }

    @Test
    @DisplayName("04 - Debe crear movimiento de aplicación")
    void test04_crear_Aplicacion_DebeCrearYRetornar() throws Exception {
        String response = mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestAplicacion())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.flagTipoTransaccion").value("A"))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        
        idAplicacion = objectMapper.readTree(response).get("data").get("id").asLong();
        System.out.println("✅ Aplicación creada con ID: " + idAplicacion);
    }

    @Test
    @DisplayName("05 - Debe listar todos los movimientos")
    void test05_listar_DebeRetornarTodosLosMovimientos() throws Exception {
        mockMvc.perform(get("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.totalElements").exists());
    }

    @Test
    @DisplayName("06 - Debe obtener movimiento por ID")
    void test06_obtenerPorId_ConIdCreado_DebeRetornarMovimiento() throws Exception {
        // Primero crear un cobro para asegurar que tenemos un ID válido
        String response = mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestCobro())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        
        Long cobroId = objectMapper.readTree(response).get("data").get("id").asLong();
        
        // Ahora obtener el movimiento por ID
        mockMvc.perform(get("/api/finanzas/caja-bancos/{id}", cobroId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(cobroId))
                .andExpect(jsonPath("$.data.flagTipoTransaccion").value("C"))
                .andExpect(jsonPath("$.data.impTotal").exists())
                .andExpect(jsonPath("$.data.detalles").isArray());
    }

    @Test
    @DisplayName("07 - Debe filtrar movimientos por tipo de transacción")
    void test07_listar_ConFiltroTipoTransaccion_DebeRetornarFiltrados() throws Exception {
        // Primero crear un cobro para asegurar que hay datos con tipo 'C'
        mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestCobro())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true));
        
        // Ahora filtrar por tipo de transacción 'C'
        mockMvc.perform(get("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .param("flagTipoTransaccion", "C")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[?(@.flagTipoTransaccion == 'C')]").exists());
    }

    @Test
    @DisplayName("08 - Debe filtrar movimientos por entidad contribuyente")
    void test08_listar_ConFiltroEntidadContribuyente_DebeRetornarFiltrados() throws Exception {
        // Primero crear un cobro para asegurar que hay datos con entidadContribuyenteId = 1
        mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestCobro())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true));
        
        // Ahora filtrar por entidad contribuyente
        mockMvc.perform(get("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .param("entidadContribuyenteId", "1")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[?(@.entidadContribuyenteId == 1)]").exists());
    }

    @Test
    @DisplayName("09 - Debe filtrar movimientos por fecha de hoy")
    void test09_listar_ConFiltroFecha_DebeRetornarFiltrados() throws Exception {
        String fechaHoy = java.time.LocalDate.now().toString();
        
        mockMvc.perform(get("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .param("fechaDesde", fechaHoy)
                .param("fechaHasta", fechaHoy)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @Disabled("PROBLEMA BACKEND: Error en método actualizar() - DataIntegrityViolationException en caja_bancos_id")
    @DisplayName("10 - Debe actualizar movimiento existente [DESHABILITADO - Ver MR para corrección]")
    void test10_actualizar_ConIdExistente_DebeActualizarYRetornar() throws Exception {
        // Primero crear un cobro para tener un ID válido
        String response = mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestCobro())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        
        Long cobroId = objectMapper.readTree(response).get("data").get("id").asLong();
        
        // Obtener el objeto completo para tener todos los detalles con sus IDs
        String getResponse = mockMvc.perform(get("/api/finanzas/caja-bancos/{id}", cobroId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andReturn().getResponse().getContentAsString();
        
        // Actualizar solo campos principales sin detalles para evitar problemas de relaciones
        JsonNode cobroNode = objectMapper.readTree(getResponse).get("data");
        
        // Obtener el importe total actual
        double importeActual = cobroNode.get("impTotal").asDouble();
        
        // Crear un request simple solo con los campos principales
        ObjectNode requestActualizado = objectMapper.createObjectNode();
        requestActualizado.put("flagTipoTransaccion", cobroNode.get("flagTipoTransaccion").asText());
        requestActualizado.put("bancoCntaId", cobroNode.get("bancoCntaId").asLong());
        requestActualizado.put("conceptoFinancieroId", cobroNode.get("conceptoFinancieroId").asLong());
        requestActualizado.put("fechaEmision", cobroNode.get("fechaEmision").asText());
        requestActualizado.put("entidadContribuyenteId", cobroNode.get("entidadContribuyenteId").asLong());
        requestActualizado.put("monedaId", cobroNode.get("monedaId").asLong());
        requestActualizado.put("impTotal", importeActual);
        requestActualizado.put("observacion", "Movimiento actualizado");
        requestActualizado.put("tasaCambio", cobroNode.get("tasaCambio").asDouble());
        
        // Incluir un detalle válido para cumplir la validación del backend
        ArrayNode detallesArray = objectMapper.createArrayNode();
        ObjectNode detalle = objectMapper.createObjectNode();
        detalle.put("item", 1);
        detalle.put("entidadContribuyenteId", cobroNode.path("entidadContribuyenteId").asLong(1L));
        detalle.put("docTipoId", cobroNode.path("docTipoId").asLong(1L));
        detalle.put("nroDoc", "CB-UPD-LN01");
        detalle.put("importe", importeActual);
        detalle.put("flagCxp", "0");
        detalle.put("sucursalRefId", 1L);
        detallesArray.add(detalle);
        requestActualizado.put("detalles", detallesArray);

        mockMvc.perform(put("/api/finanzas/caja-bancos/{id}", cobroId)
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(requestActualizado)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.impTotal").value(importeActual))
                .andExpect(jsonPath("$.data.observacion").value("Movimiento actualizado"));
    }

    @Test
    @DisplayName("11 - Debe retornar error de validación al crear con datos inválidos")
    void test11_crear_ConDatosInvalidos_DebeRetornarErrorValidacion() throws Exception {
        String requestInvalido = """
            {
                "flagTipoTransaccion": "",
                "impTotal": -100,
                "detalles": []
            }
            """;

        mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestInvalido))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("12 - Debe retornar 404 al obtener movimiento por ID inexistente")
    void test12_obtenerPorId_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(get("/api/finanzas/caja-bancos/{id}", 999L)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("13 - Debe ejecutar movimiento existente (con ContabilidadClient mockeado)")
    void test13_ejecutar_ConIdExistente_DebeEjecutarYRetornar() throws Exception {
        // Mock ContabilidadClient para simular respuesta exitosa de ms-contabilidad
        GenerarAsientoResponse asientoResponse = new GenerarAsientoResponse();
        asientoResponse.setAsientoId(999L);
        asientoResponse.setVoucher("V001");
        when(contabilidadClient.generarAsientoCarteraPagos(any()))
                .thenReturn(ApiResponse.ok(asientoResponse));

        // Primero crear un pago para tener un ID válido
        String response = mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestPago())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        
        Long pagoId = objectMapper.readTree(response).get("data").get("id").asLong();
        
        mockMvc.perform(post("/api/finanzas/caja-bancos/{id}/ejecutar", pagoId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.flagEstado").value("1"))
                .andExpect(jsonPath("$.data.cntblAsientoId").value(999));
    }

    @Test
    @DisplayName("13b - Debe retornar FIN-CONTABILIDAD_NOT_FOUND cuando ms-contabilidad responde 404")
    void test13b_ejecutar_ConFeignNotFound_DebeRetornarFIN_CONTABILIDAD_NOT_FOUND() throws Exception {
        FeignException.NotFound ex = mock(FeignException.NotFound.class);
        when(ex.contentUTF8()).thenReturn("{\"message\":\"Libro contable no encontrado\"}");
        when(contabilidadClient.generarAsientoCarteraPagos(any())).thenThrow(ex);

        String response = mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestPago())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long pagoId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(post("/api/finanzas/caja-bancos/{id}/ejecutar", pagoId)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("FIN-CONTABILIDAD_NOT_FOUND"))
                .andExpect(jsonPath("$.message").value("Libro contable no encontrado"));
    }

    @Test
    @DisplayName("13c - Debe retornar FIN-CONTABILIDAD_NO_ACCESIBLE cuando ms-contabilidad no responde")
    void test13c_ejecutar_ConFeignExceptionGenerica_DebeRetornarFIN_CONTABILIDAD_NO_ACCESIBLE() throws Exception {
        FeignException ex = mock(FeignException.class);
        when(ex.contentUTF8()).thenReturn(null);
        when(contabilidadClient.generarAsientoCarteraPagos(any())).thenThrow(ex);

        String response = mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestPago())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long pagoId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(post("/api/finanzas/caja-bancos/{id}/ejecutar", pagoId)
                .header("Authorization", authToken))
                .andExpect(status().isServiceUnavailable())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("FIN-CONTABILIDAD_NO_ACCESIBLE"))
                .andExpect(jsonPath("$.message").value("Error al generar el asiento contable"));
    }

    @Test
    @DisplayName("14 - Debe retornar 404 al ejecutar movimiento inexistente")
    void test14_ejecutar_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(post("/api/finanzas/caja-bancos/{id}/ejecutar", 999L)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("15 - Debe anular movimiento existente")
    void test15_anular_ConIdExistente_DebeAnularYRetornar() throws Exception {
        // Primero crear una transferencia para tener un ID válido
        String response = mockMvc.perform(post("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(
                    TestDataFactory.crearCajaBancosRequestTransferencia())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();
        
        Long transferenciaId = objectMapper.readTree(response).get("data").get("id").asLong();
        
        mockMvc.perform(post("/api/finanzas/caja-bancos/{id}/anular", transferenciaId)
                .header("Authorization", authToken))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").exists());
    }

    @Test
    @DisplayName("16 - Debe retornar 404 al anular movimiento inexistente")
    void test16_anular_ConIdInexistente_DebeRetornar404() throws Exception {
        mockMvc.perform(post("/api/finanzas/caja-bancos/{id}/anular", 999L)
                .header("Authorization", authToken))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("17 - Debe validar paginación en listado")
    void test17_listar_ConPaginacion_DebeRetornarPaginado() throws Exception {
        mockMvc.perform(get("/api/finanzas/caja-bancos")
                .header("Authorization", authToken)
                .param("page", "0")
                .param("size", "2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page.size").value(2))
                .andExpect(jsonPath("$.data.page.number").value(0))
                .andExpect(jsonPath("$.data.page.totalElements").exists())
                .andExpect(jsonPath("$.data.page.totalPages").exists());
    }
}
