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

import static org.junit.jupiter.api.Assumptions.assumeTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@AlmacenIntegrationMockMvcTest
@DisplayName("IT — OrdenTrasladoController + AlmacenTestDataFactory")
class OrdenTrasladoControllerIT {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private AlmacenTestDataFactory factory;

    @Autowired
    private DataSource dataSource;

    private Long ordenId;

    @BeforeEach
    void seed() {
        AlmacenItSeed.standard(dataSource, factory);
        assumeTrue(factory.isAlmacenSchemaReady(), "Tenant sin esquema almacen (DDL 02-almacen)");
        ordenId = factory.resolveOrdenTrasladoId();
    }

    @Test
    void obtenerOrdenFactory() throws Exception {
        mockMvc.perform(AlmacenMockMvcSupport.withTenant(get("/api/almacen/ordenes-traslado/{id}", ordenId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(ordenId));
    }

    @Test
    void buscarOrdenes() throws Exception {
        mockMvc.perform(AlmacenMockMvcSupport.withTenant(get("/api/almacen/ordenes-traslado").param("size", "25")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }
}
