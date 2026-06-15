package com.sigre.comercializacion.integration;

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
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.comercializacion.client.ContabilidadGenerarAsientoClient;
import com.sigre.comercializacion.client.dto.GenerarAsientoResponse;
import com.sigre.comercializacion.dto.request.CuentaCobrarRequest;
import com.sigre.comercializacion.testdata.VentasTestDataFactory;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
        listeners = TenantContextTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración — CuentaCobrarController")
class CuentaCobrarControllerIntegrationTest {

    @Autowired private WebApplicationContext wac;
    @Autowired private VentasTestDataFactory ventasFactory;

    @MockBean private ContabilidadGenerarAsientoClient contabilidadClient;

    private MockMvc mockMvc;
    private ObjectMapper om;
    private String token;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();
        om = new ObjectMapper(); om.registerModule(new JavaTimeModule());
        token = "Bearer mock-token";
        ventasFactory.ensureVentasTransactionalData();

        // Mock Feign client: toda creación de CxC intenta generar asiento contable
        GenerarAsientoResponse mockResp = new GenerarAsientoResponse();
        mockResp.setAsientoId(999L);
        when(contabilidadClient.generarRegistroCntasCobrar(any()))
                .thenReturn(ApiResponse.<GenerarAsientoResponse>builder()
                        .success(true).message("OK").data(mockResp).build());
    }

    private CuentaCobrarRequest baseRequest() {
        return CuentaCobrarRequest.builder()
                .sucursalId(1L).clienteId(2L).docTipoId(1L)
                .serie("T001").numero("00000001")
                .fechaEmision(LocalDate.now()).fechaVencimiento(LocalDate.now().plusDays(30))
                .monedaId(1L).total(new BigDecimal("500.00")).saldo(new BigDecimal("500.00"))
                .ano(2026).mes(5).cntblLibroId(4L)
                .build();
    }

    @Test @DisplayName("GET / — listar")
    void listar() throws Exception {
        mockMvc.perform(get("/api/ventas/cuentas-cobrar").header("Authorization", token)
                .param("page","0").param("size","5").param("sort","fechaEmision,desc"))
                .andExpect(status().isOk()).andExpect(jsonPath("$.success").value(true));
    }

    @Test @DisplayName("POST / — crear (con @MockBean ContabilidadClient)")
    void crear() throws Exception {
        mockMvc.perform(post("/api/ventas/cuentas-cobrar").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.serie").value("T001"));
    }

    @Test @DisplayName("GET /{id} — obtener")
    void obtenerPorId() throws Exception {
        String r = mockMvc.perform(post("/api/ventas/cuentas-cobrar").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString();
        Long id = om.readTree(r).get("data").get("id").asLong();

        mockMvc.perform(get("/api/ventas/cuentas-cobrar/{id}", id).header("Authorization", token))
                .andExpect(status().isOk()).andExpect(jsonPath("$.data.id").value(id));
    }

    @Test @DisplayName("PUT /{id} — actualizar")
    void actualizar() throws Exception {
        String r = mockMvc.perform(post("/api/ventas/cuentas-cobrar").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString();
        Long id = om.readTree(r).get("data").get("id").asLong();

        CuentaCobrarRequest upd = baseRequest();
        upd.setSerie("T002"); upd.setTotal(new BigDecimal("600.00")); upd.setSaldo(new BigDecimal("600.00"));

        mockMvc.perform(put("/api/ventas/cuentas-cobrar/{id}", id).header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(upd)))
                .andExpect(status().isOk());
    }

    @Test @DisplayName("DELETE /{id} — baja lógica")
    void eliminar() throws Exception {
        String r = mockMvc.perform(post("/api/ventas/cuentas-cobrar").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString();
        Long id = om.readTree(r).get("data").get("id").asLong();

        mockMvc.perform(delete("/api/ventas/cuentas-cobrar/{id}", id).header("Authorization", token))
                .andExpect(status().isOk());
    }

    @Test @DisplayName("PATCH /{id}/activar")
    void activar() throws Exception {
        String r = mockMvc.perform(post("/api/ventas/cuentas-cobrar").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString();
        Long id = om.readTree(r).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/ventas/cuentas-cobrar/{id}/activar", id).header("Authorization", token))
                .andExpect(status().isOk());
    }

    @Test @DisplayName("PATCH /{id}/desactivar")
    void desactivar() throws Exception {
        String r = mockMvc.perform(post("/api/ventas/cuentas-cobrar").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString();
        Long id = om.readTree(r).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/ventas/cuentas-cobrar/{id}/desactivar", id).header("Authorization", token))
                .andExpect(status().isOk());
    }

    @Test @DisplayName("POST /{id}/anular")
    void anular() throws Exception {
        String r = mockMvc.perform(post("/api/ventas/cuentas-cobrar").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(baseRequest())))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString();
        Long id = om.readTree(r).get("data").get("id").asLong();

        mockMvc.perform(post("/api/ventas/cuentas-cobrar/{id}/anular", id).header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content("{}"))
                .andExpect(status().isOk());
    }
}
