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
@DisplayName("IT — AfCalculoCntblController + ActivosTestDataFactory")
class AfCalculoCntblControllerIT {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ActivosTestDataFactory factory;

    @Autowired
    private DataSource dataSource;

    private Long maestroId;
    private Long calculoId;

    @BeforeEach
    void seed() {
        ActivosItSeed.standard(dataSource, factory);
        assumeTrue(factory.isActivosSchemaReady(),
                "Tenant sin esquema activos (DDL 08-activos + migraciones ms-activos-fijos)");
        maestroId = factory.resolveMaestroId();
        calculoId = factory.resolveCalculoDepreciacionContableId();
    }

    @Test
    @DisplayName("GET /depreciacion/{id} — cálculo factory")
    void obtenerCalculo() throws Exception {
        mockMvc.perform(ActivosMockMvcSupport.withTenant(get("/api/activos/depreciacion/{id}", calculoId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(calculoId));
    }

    @Test
    @DisplayName("GET /depreciacion/maestro/{id} — historial del activo factory")
    void historialPorMaestro() throws Exception {
        mockMvc.perform(ActivosMockMvcSupport.withTenant(get("/api/activos/depreciacion/maestro/{id}", maestroId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].id").exists());
    }
}
