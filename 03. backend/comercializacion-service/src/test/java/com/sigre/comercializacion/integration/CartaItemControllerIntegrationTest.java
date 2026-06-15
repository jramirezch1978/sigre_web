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
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import com.sigre.common.testutil.TenantContextTestExecutionListener;
import com.sigre.comercializacion.dto.request.CartaRequest;
import com.sigre.comercializacion.testdata.VentasTestDataFactory;

import java.math.BigDecimal;

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
@DisplayName("Pruebas de Integración — CartaItemController")
class CartaItemControllerIntegrationTest {

    @Autowired private WebApplicationContext wac;
    @Autowired private VentasTestDataFactory ventasFactory;

    private MockMvc mockMvc;
    private ObjectMapper om;
    private String token;
    private Long cartaId;

    @BeforeEach
    void setUp() throws Exception {
        mockMvc = MockMvcBuilders.webAppContextSetup(wac).build();
        om = new ObjectMapper(); om.registerModule(new JavaTimeModule());
        token = "Bearer mock-token";
        ventasFactory.ensureVentasTransactionalData();

        // Crear carta base para todos los tests
        CartaRequest req = new CartaRequest();
        req.setNombre("CARTA-ITEMS-TEST"); req.setDescripcion("test items");
        String resp = mockMvc.perform(post("/api/ventas/cartas").header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(req)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        cartaId = om.readTree(resp).get("data").get("id").asLong();
    }

    private CartaRequest.CartaDetRequest itemReq() {
        CartaRequest.CartaDetRequest r = new CartaRequest.CartaDetRequest();
        r.setArticuloId(1L); r.setPrecio(new BigDecimal("25.00")); r.setOrden(1);
        return r;
    }

    @Test @DisplayName("GET /cartas/{cartaId}/items — listar ítems")
    void listar() throws Exception {
        mockMvc.perform(get("/api/ventas/cartas/{cartaId}/items", cartaId).header("Authorization", token))
                .andExpect(status().isOk()).andExpect(jsonPath("$.success").value(true));
    }

    @Test @DisplayName("POST /cartas/{cartaId}/items — agregar ítem")
    void agregar() throws Exception {
        mockMvc.perform(post("/api/ventas/cartas/{cartaId}/items", cartaId).header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(itemReq())))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.data.precio").value(25.00));
    }

    @Test @DisplayName("PUT /cartas/{cartaId}/items/{itemId} — actualizar")
    void actualizar() throws Exception {
        // Agregar ítem primero
        String created = mockMvc.perform(post("/api/ventas/cartas/{cartaId}/items", cartaId)
                .header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(itemReq())))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString();
        Long itemId = om.readTree(created).get("data").get("id").asLong();

        CartaRequest.CartaDetUpdateRequest upd = new CartaRequest.CartaDetUpdateRequest();
        upd.setPrecio(new BigDecimal("30.00")); upd.setOrden(2);

        mockMvc.perform(put("/api/ventas/cartas/{cartaId}/items/{itemId}", cartaId, itemId)
                .header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(upd)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.precio").value(30.00));
    }

    @Test @DisplayName("DELETE /cartas/{cartaId}/items/{itemId} — eliminar")
    void eliminar() throws Exception {
        String created = mockMvc.perform(post("/api/ventas/cartas/{cartaId}/items", cartaId)
                .header("Authorization", token)
                .contentType(MediaType.APPLICATION_JSON).content(om.writeValueAsString(itemReq())))
                .andExpect(status().isCreated()).andReturn().getResponse().getContentAsString();
        Long itemId = om.readTree(created).get("data").get("id").asLong();

        mockMvc.perform(delete("/api/ventas/cartas/{cartaId}/items/{itemId}", cartaId, itemId)
                .header("Authorization", token))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }
}
