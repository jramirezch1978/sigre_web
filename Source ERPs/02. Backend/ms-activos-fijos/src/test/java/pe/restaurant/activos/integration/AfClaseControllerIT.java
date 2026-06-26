package pe.restaurant.activos.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.activos.support.ActivosIntegrationMockMvcTest;
import pe.restaurant.activos.support.ActivosItSeed;
import pe.restaurant.activos.support.ActivosMockMvcSupport;
import pe.restaurant.activos.support.ActivosTestFixtures;
import pe.restaurant.activos.testdata.ActivosTestDataFactory;

import javax.sql.DataSource;

import static org.junit.jupiter.api.Assumptions.assumeTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@ActivosIntegrationMockMvcTest
@DisplayName("IT — AfClaseController + ActivosTestDataFactory")
class AfClaseControllerIT {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private ActivosTestDataFactory factory;

    @Autowired
    private DataSource dataSource;

    private Long claseId;

    @BeforeEach
    void seed() {
        ActivosItSeed.standard(dataSource, factory);
        assumeTrue(factory.isActivosSchemaReady(),
                "Tenant sin esquema activos (DDL 08-activos + migraciones ms-activos-fijos)");
        claseId = factory.resolveClaseId();
    }

    @Test
    @DisplayName("GET /clases/{id} — clase factory")
    void obtenerClaseFactory() throws Exception {
        mockMvc.perform(ActivosMockMvcSupport.withTenant(get("/api/activos/clases/{id}", claseId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.codigo").value(ActivosTestDataFactory.CODIGO_CLASE));
    }

    @Test
    @DisplayName("GET /clases — listado")
    void listarClases() throws Exception {
        mockMvc.perform(ActivosMockMvcSupport.withTenant(get("/api/activos/clases").param("size", "30")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("POST /clases — creación válida")
    void crearClase() throws Exception {
        var body = ActivosTestFixtures.claseRequestNueva(ActivosTestFixtures.codigoClaseItUnico());
        mockMvc.perform(ActivosMockMvcSupport.withTenant(post("/api/activos/clases")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(body))))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.codigo").value(body.getCodigo()));
    }
}
