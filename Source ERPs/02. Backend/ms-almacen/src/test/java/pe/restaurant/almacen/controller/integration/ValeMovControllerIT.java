package pe.restaurant.almacen.controller.integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.almacen.support.AlmacenIntegrationMockMvcTest;
import pe.restaurant.almacen.support.AlmacenItSeed;
import pe.restaurant.almacen.support.AlmacenMockMvcSupport;
import pe.restaurant.almacen.testdata.AlmacenTestDataFactory;

import javax.sql.DataSource;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assumptions.assumeTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@AlmacenIntegrationMockMvcTest
@DisplayName("IT — ValeMovController + AlmacenTestDataFactory")
class ValeMovControllerIT {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private AlmacenTestDataFactory factory;

    @Autowired
    private DataSource dataSource;

    private Long valeId;

    @BeforeEach
    void seed() {
        AlmacenItSeed.standard(dataSource, factory);
        assumeTrue(factory.isAlmacenSchemaReady(), "Tenant sin esquema almacen (DDL 02-almacen)");
        valeId = factory.resolveValeMovId();
    }

    @Test
    @DisplayName("Factory — vale LM-TEST-0001 resuelto en BD")
    void valeFactory_resuelveIdEnBd() {
        assertThat(valeId).isPositive();
        assertThat(factory.countValeMovDetalles(AlmacenTestDataFactory.NRO_VALE)).isGreaterThanOrEqualTo(2);
    }

    @Test
    @DisplayName("GET /movimientos — listado")
    void listarMovimientos() throws Exception {
        mockMvc.perform(AlmacenMockMvcSupport.withTenant(get("/api/almacen/movimientos").param("size", "50")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /movimientos/{id} — 404")
    void obtenerVale_inexistente() throws Exception {
        mockMvc.perform(AlmacenMockMvcSupport.withTenant(get("/api/almacen/movimientos/{id}", 9_999_999_999L)))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }
}
