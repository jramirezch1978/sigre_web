package pe.restaurant.almacen.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.almacen.support.AlmacenIntegrationMockMvcTest;
import pe.restaurant.almacen.support.AlmacenItSeed;
import pe.restaurant.almacen.support.AlmacenMockMvcSupport;
import pe.restaurant.almacen.support.AlmacenTestFixtures;
import pe.restaurant.almacen.testdata.AlmacenTestDataFactory;

import javax.sql.DataSource;

import static org.junit.jupiter.api.Assumptions.assumeTrue;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@AlmacenIntegrationMockMvcTest
@DisplayName("IT — AlmacenController + AlmacenTestDataFactory")
class AlmacenControllerIT {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private AlmacenTestDataFactory factory;

    @Autowired
    private DataSource dataSource;

    private Long almacenId;

    @BeforeEach
    void seed() {
        AlmacenItSeed.standard(dataSource, factory);
        assumeTrue(factory.isAlmacenSchemaReady(), "Tenant sin esquema almacen (DDL 02-almacen)");
        almacenId = factory.resolveAlmacenId();
    }

    @Test
    void obtenerAlmacenFactory() throws Exception {
        mockMvc.perform(AlmacenMockMvcSupport.withTenant(get("/api/almacen/almacenes/{id}", almacenId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.codigo").value(AlmacenTestDataFactory.CODIGO_ALMACEN_1));
    }

    @Test
    void listarAlmacenes() throws Exception {
        mockMvc.perform(AlmacenMockMvcSupport.withTenant(get("/api/almacen/almacenes").param("size", "30")))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    void crearAlmacen() throws Exception {
        var body = AlmacenTestFixtures.almacenRequestNuevo(
                AlmacenTestFixtures.codigoAlmacenItUnico(),
                factory.resolveSucursalId(),
                factory.resolveAlmacenTipoId());
        mockMvc.perform(AlmacenMockMvcSupport.withTenant(post("/api/almacen/almacenes")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(body))))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.codigo").value(body.getCodigo()));
    }

    @Test
    void crearAlmacen_validacion() throws Exception {
        var body = AlmacenTestFixtures.almacenRequestInvalido();
        mockMvc.perform(AlmacenMockMvcSupport.withTenant(post("/api/almacen/almacenes")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(body))))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false));
    }
}
