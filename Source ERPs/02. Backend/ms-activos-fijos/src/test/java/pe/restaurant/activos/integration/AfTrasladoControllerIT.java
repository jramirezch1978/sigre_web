package pe.restaurant.activos.integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.activos.support.ActivosIntegrationMockMvcTest;
import pe.restaurant.activos.support.ActivosItSeed;
import pe.restaurant.activos.support.ActivosMockMvcSupport;
import pe.restaurant.activos.testdata.ActivosTestDataFactory;

import javax.sql.DataSource;

import static org.junit.jupiter.api.Assumptions.assumeTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ActivosIntegrationMockMvcTest
@DisplayName("IT — AfTrasladoController + ActivosTestDataFactory")
class AfTrasladoControllerIT {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ActivosTestDataFactory factory;

    @Autowired
    private DataSource dataSource;

    private Long trasladoId;

    @BeforeEach
    void seed() {
        ActivosItSeed.standard(dataSource, factory);
        assumeTrue(factory.isActivosSchemaReady(),
                "Tenant sin esquema activos (DDL 08-activos + migraciones ms-activos-fijos)");
        trasladoId = factory.resolveTrasladoFactoryId();
    }

    @Test
    @DisplayName("GET /traslados/{id} — traslado del activo factory")
    void obtenerTraslado() throws Exception {
        mockMvc.perform(ActivosMockMvcSupport.withTenant(get("/api/activos/traslados/{id}", trasladoId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(trasladoId));
    }

    @Test
    @DisplayName("GET /traslados — listado")
    void listarTraslados() throws Exception {
        mockMvc.perform(ActivosMockMvcSupport.withTenant(get("/api/activos/traslados").param("size", "25")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }
}
