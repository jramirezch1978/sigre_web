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
@DisplayName("IT — AfMaestroController + ActivosTestDataFactory")
class AfMaestroControllerIT {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private ActivosTestDataFactory factory;

    @Autowired
    private DataSource dataSource;

    private Long maestroId;

    @BeforeEach
    void seed() {
        ActivosItSeed.standard(dataSource, factory);
        assumeTrue(factory.isActivosSchemaReady(),
                "Tenant sin esquema activos (DDL 08-activos + migraciones ms-activos-fijos)");
        maestroId = factory.resolveMaestroId();
    }

    @Test
    @DisplayName("GET /maestro/{id} — activo factory")
    void obtenerMaestroFactory() throws Exception {
        mockMvc.perform(ActivosMockMvcSupport.withTenant(get("/api/activos/maestro/{id}", maestroId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(maestroId))
                .andExpect(jsonPath("$.data.codigo").value(ActivosTestDataFactory.CODIGO_MAESTRO));
    }

    @Test
    @DisplayName("GET /maestro — listado paginado")
    void listarMaestros() throws Exception {
        mockMvc.perform(ActivosMockMvcSupport.withTenant(get("/api/activos/maestro").param("size", "20")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /maestro/{id} — 404 recurso inexistente")
    void obtenerMaestro_inexistente() throws Exception {
        mockMvc.perform(ActivosMockMvcSupport.withTenant(get("/api/activos/maestro/{id}", 9_999_999_999L)))
                .andExpect(status().isNotFound())
                .andExpect(jsonPath("$.success").value(false));
    }

    @Test
    @DisplayName("POST /maestro — creación válida (rollback IT)")
    void crearMaestro() throws Exception {
        var body = ActivosTestFixtures.maestroRequestValido(
                ActivosTestFixtures.codigoMaestroItUnico(),
                factory.resolveSubClaseId(),
                factory.resolveUbicacionId(),
                null);
        mockMvc.perform(ActivosMockMvcSupport.withTenant(post("/api/activos/maestro")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(body))))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.codigo").value(body.getCodigo()));
    }

    @Test
    @DisplayName("POST /maestro — 400 validación")
    void crearMaestro_validacion() throws Exception {
        var body = ActivosTestFixtures.maestroRequestInvalidoSinCodigo(factory.resolveSubClaseId());
        mockMvc.perform(ActivosMockMvcSupport.withTenant(post("/api/activos/maestro")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(body))))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }
}
