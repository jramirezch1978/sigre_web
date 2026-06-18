package pe.restaurant.compras.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.MethodOrderer;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Assumptions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.http.MediaType;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.common.testutil.TestDataFactory;
import pe.restaurant.compras.support.ComprasIntegrationTest;
import pe.restaurant.compras.testdata.ComprasTestDataFactory;

import javax.sql.DataSource;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.patch;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

/**
 * Tests de integracion REALES para ms-compras.
 * Ejecutan flujos completos contra una base PostgreSQL y validan persistencia JDBC.
 * Usan ComprasTestDataFactory (B) + TestDataFactory (A) para poblar datos prerequisito.
 *
 * Requiere conectividad a la BD externa. Ejecutar manualmente:
 * mvn test -pl ms-compras -Dcompras.it=true -Dsurefire.excludedGroups=
 */
@ComprasIntegrationTest
@AutoConfigureMockMvc(addFilters = false)
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
@DisplayName("Integracion - Flujos completos ms-compras con validacion JDBC")
class ComprasFlowIntegrationTest {

    @Autowired private MockMvc mockMvc;
    @Autowired private DataSource dataSource;
    @Autowired private ComprasTestDataFactory comprasFactory;
    @Autowired @Qualifier("securityJdbcTemplate") private JdbcTemplate securityJdbc;

    private ObjectMapper objectMapper;
    private JdbcTemplate jdbc;
    private static final String AUTH = "Bearer mock-token";

    private Long articuloId;
    private Long proveedorId;
    private Long sucursalId;
    private Long servicioId;
    private boolean articuloMovProyTableExists;
    private boolean numOrdSrvTableExists;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);

        TestDataFactory.using(dataSource)
                .seedDocTipo()
                .seedArticulo()
                .seedEntidadContribuyente()
                .seedComprador()
                .seedAprobadorConfigurado()
                .seedServicio();

        comprasFactory.ensureComprasTransactionalData();

        articuloId = comprasFactory.resolveArticuloId();
        proveedorId = comprasFactory.resolveProveedorId();
        sucursalId = comprasFactory.resolveSucursalId();
        servicioId = comprasFactory.resolveServicioId();
        articuloMovProyTableExists = comprasFactory.hasArticuloMovProyTable();
        numOrdSrvTableExists = comprasFactory.hasNumOrdenServicioTable();
    }

    @Test
    @Order(1)
    @DisplayName("SOL-01: Crear solicitud de compra")
    void solicitud_crear() throws Exception {
        String body = """
            {
                "fecha": "%s",
                "prioridad": "ALTA",
                "justificacion": "Stock bajo de insumos",
                "lineas": [
                    { "articuloId": %d, "cantidad": 50.00, "especificaciones": "Marca preferida" }
                ]
            }
            """.formatted(LocalDate.now(), articuloId);

        String response = mockMvc.perform(post("/api/compras/solicitudes-compra")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long solId = objectMapper.readTree(response).get("data").get("id").asLong();

        Integer solCount = jdbc.queryForObject(
            "SELECT COUNT(*) FROM compras.solicitud_compra WHERE id = ?", Integer.class, solId);
        assertThat(solCount).isEqualTo(1);

        Integer detCount = jdbc.queryForObject(
            "SELECT COUNT(*) FROM compras.solicitud_compra_det WHERE solicitud_id = ?", Integer.class, solId);
        assertThat(detCount).isGreaterThan(0);
    }

    @Test
    @Order(2)
    @DisplayName("SOL-02: Crear y enviar solicitud")
    void solicitud_crearYEnviar() throws Exception {
        Long solId = crearSolicitud();

        mockMvc.perform(post("/api/compras/solicitudes-compra/{id}/enviar", solId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @Order(3)
    @DisplayName("SOL-03: Flujo completo solicitud -> aprobar")
    void solicitud_flujoHastaAprobar() throws Exception {
        Long solId = crearSolicitud();
        enviarSolicitud(solId);

        mockMvc.perform(post("/api/compras/solicitudes-compra/{id}/aprobar", solId)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"observacion\": \"Aprobado OK\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @Order(4)
    @DisplayName("SOL-04: Rechazar solicitud enviada")
    void solicitud_rechazar() throws Exception {
        Long solId = crearSolicitud();
        enviarSolicitud(solId);

        mockMvc.perform(post("/api/compras/solicitudes-compra/{id}/rechazar", solId)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"motivo\": \"Presupuesto insuficiente\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @Order(5)
    @DisplayName("SOL-05: Enviar solicitud con lineas")
    void solicitud_enviarConLineas() throws Exception {
        String body = """
            {
                "fecha": "%s",
                "prioridad": "MEDIA",
                "justificacion": "Test con lineas",
                "lineas": [
                    { "articuloId": %d, "cantidad": 10.00 }
                ]
            }
            """.formatted(LocalDate.now(), articuloId);

        String response = mockMvc.perform(post("/api/compras/solicitudes-compra")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long solId = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(post("/api/compras/solicitudes-compra/{id}/enviar", solId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());

        Integer detCount = jdbc.queryForObject(
            "SELECT COUNT(*) FROM compras.solicitud_compra_det WHERE solicitud_id = ?", Integer.class, solId);
        assertThat(detCount).isGreaterThan(0);
    }

    @Test
    @Order(6)
    @DisplayName("SOL-06: Convertir solicitud aprobada a OC")
    void solicitud_convertirAOC() throws Exception {
        Long solId = crearSolicitud();
        enviarSolicitud(solId);
        aprobarSolicitud(solId);

        String body = """
            {
                "destino": "ORDEN_COMPRA",
                "proveedorIds": [1],
                "monedaId": 1
            }
            """;

        mockMvc.perform(post("/api/compras/solicitudes-compra/{id}/convertir", solId)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        Integer ocCount = jdbc.queryForObject(
            "SELECT COUNT(*) FROM compras.orden_compra", Integer.class);
        assertThat(ocCount).isGreaterThan(0);
    }

    @Test
    @Order(7)
    @DisplayName("SOL-07: Anular solicitud")
    void solicitud_anular() throws Exception {
        Long solId = crearSolicitud();

        mockMvc.perform(post("/api/compras/solicitudes-compra/{id}/anular", solId)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"motivo\": \"Ya no se requiere\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @Order(10)
    @DisplayName("OC-01: Crear orden de compra directa")
    void oc_crear() throws Exception {
        requiereArticuloMovProy();
        String body = buildOcRequest();

        String response = mockMvc.perform(post("/api/compras/ordenes-compra")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andExpect(jsonPath("$.data.nroOrdenCompra").exists())
                .andReturn().getResponse().getContentAsString();

        Long ocId = objectMapper.readTree(response).get("data").get("id").asLong();

        Integer ocCount = jdbc.queryForObject(
            "SELECT COUNT(*) FROM compras.orden_compra WHERE id = ?", Integer.class, ocId);
        assertThat(ocCount).isEqualTo(1);

        Integer detCount = jdbc.queryForObject(
            "SELECT COUNT(*) FROM compras.orden_compra_det WHERE orden_compra_id = ?", Integer.class, ocId);
        assertThat(detCount).isGreaterThan(0);
    }

    @Test
    @Order(11)
    @DisplayName("OC-02: Flujo OC crear pendiente -> aprobar -> cerrar")
    void oc_flujoCompleto() throws Exception {
        requiereArticuloMovProy();
        Long ocId = crearOrdenCompra();
        aprobarOc(ocId);

        mockMvc.perform(post("/api/compras/ordenes-compra/{id}/cerrar", ocId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @Order(16)
    @DisplayName("OC-07: Anular OC activa")
    void oc_anular() throws Exception {
        requiereArticuloMovProy();
        Long ocId = crearOrdenCompra();

        mockMvc.perform(post("/api/compras/ordenes-compra/{id}/anular", ocId)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"motivo\": \"Error en datos\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @Order(17)
    @DisplayName("OC-08: Actualizar OC en borrador")
    void oc_actualizar() throws Exception {
        requiereArticuloMovProy();
        Long ocId = crearOrdenCompra();
        String body = buildOcRequest();

        mockMvc.perform(put("/api/compras/ordenes-compra/{id}", ocId)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(ocId));
    }

    @Test
    @Order(18)
    @DisplayName("OC-09: Listar OCs")
    void oc_listar() throws Exception {
        requiereArticuloMovProy();
        crearOrdenCompra();

        mockMvc.perform(get("/api/compras/ordenes-compra")
                .header("Authorization", AUTH)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @Order(19)
    @DisplayName("OC-10: Obtener detalle OC")
    void oc_obtenerDetalle() throws Exception {
        requiereArticuloMovProy();
        Long ocId = crearOrdenCompra();

        mockMvc.perform(get("/api/compras/ordenes-compra/{id}", ocId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(ocId))
                .andExpect(jsonPath("$.data.lineas").isArray());
    }

    @Test
    @Order(30)
    @DisplayName("OS-01: Crear orden de servicio")
    void os_crear() throws Exception {
        requiereNumeradorOrdenServicio();
        String body = buildOsRequest();

        String response = mockMvc.perform(post("/api/compras/ordenes-servicio")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long osId = objectMapper.readTree(response).get("data").get("id").asLong();

        Integer osCount = jdbc.queryForObject(
            "SELECT COUNT(*) FROM compras.orden_servicio WHERE id = ?", Integer.class, osId);
        assertThat(osCount).isEqualTo(1);
    }

    @Test
    @Order(31)
    @DisplayName("OS-02: Flujo OS crear -> enviar aprobacion -> aprobar")
    void os_flujoCrearYAprobar() throws Exception {
        requiereNumeradorOrdenServicio();
        Long osId = crearOrdenServicio();

        mockMvc.perform(post("/api/compras/ordenes-servicio/{id}/enviar-aprobacion", osId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        mockMvc.perform(post("/api/compras/ordenes-servicio/{id}/aprobar", osId)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"comentario\":\"OK\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @Order(34)
    @DisplayName("OS-05: Anular OS")
    void os_anular() throws Exception {
        requiereNumeradorOrdenServicio();
        Long osId = crearOrdenServicio();

        mockMvc.perform(post("/api/compras/ordenes-servicio/{id}/anular", osId)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"motivo\":\"Error en servicio\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @Order(40)
    @DisplayName("COT-01: Crear cotizacion")
    void cotizacion_crear() throws Exception {
        String body = """
            {
                "proveedorId": %d,
                "fecha": "%s",
                "monedaId": 1,
                "lineas": [
                    { "articuloId": %d, "cantidad": 50.00, "precioUnitario": 12.50, "descuento": 0.00, "plazoEntregaDias": 3 }
                ]
            }
            """.formatted(proveedorId, LocalDate.now(), articuloId);

        mockMvc.perform(post("/api/compras/cotizaciones")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists());
    }

    @Test
    @Order(41)
    @DisplayName("COT-02: Convertir cotizacion a OC")
    void cotizacion_convertirAOc() throws Exception {
        requiereArticuloMovProy();
        Long cotId = crearCotizacion();

        String body = """
            {
                "fechaEmision": "%s",
                "fechaEntrega": "%s",
                "formaPagoId": 1,
                "observaciones": "Convertida desde IT"
            }
            """.formatted(LocalDate.now(), LocalDate.now().plusDays(7));

        mockMvc.perform(post("/api/compras/cotizaciones/{id}/convertir-oc", cotId)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists());
    }

    @Test
    @Order(42)
    @DisplayName("PRG-01: Flujo programacion crear -> obtener -> actualizar -> confirmar")
    void programacion_flujoCompleto() throws Exception {
        String createBody = """
            {
                "anio": %d,
                "mes": 6,
                "lineas": [
                    { "articuloId": %d, "cantidad": 25.00, "precioEstimado": 11.50 }
                ]
            }
            """.formatted(LocalDate.now().getYear(), articuloId);

        String response = mockMvc.perform(post("/api/compras/programaciones")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(createBody))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(get("/api/compras/programaciones/{id}", id)
                .header("Authorization", AUTH))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.id").value(id));

        String updateBody = """
            {
                "anio": %d,
                "mes": 7,
                "lineas": [
                    { "articuloId": %d, "cantidad": 40.00, "precioEstimado": 13.25 }
                ]
            }
            """.formatted(LocalDate.now().getYear(), articuloId);

        mockMvc.perform(put("/api/compras/programaciones/{id}", id)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(updateBody))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.id").value(id));

        mockMvc.perform(post("/api/compras/programaciones/{id}/confirmar", id)
                .header("Authorization", AUTH))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.flagEstado").value("2"));
    }

    @Test
    @Order(43)
    @DisplayName("PRG-02: Anular programacion activa")
    void programacion_anular() throws Exception {
        Long id = crearProgramacion();

        mockMvc.perform(post("/api/compras/programaciones/{id}/anular", id)
                .header("Authorization", AUTH))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.flagEstado").value("0"));
    }

    @Test
    @Order(44)
    @DisplayName("CTM-01: Flujo contrato crear -> suspender -> reabrir -> cerrar")
    void contratoMarco_flujoPrincipal() throws Exception {
        String body = """
            {
                "proveedorId": %d,
                "fechaInicio": "%s",
                "fechaFin": "%s",
                "condiciones": "Contrato marco IT"
            }
            """.formatted(proveedorId, LocalDate.now(), LocalDate.now().plusDays(15));

        String response = mockMvc.perform(post("/api/compras/contratos-marco")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(post("/api/compras/contratos-marco/{id}/suspender", id)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"motivo\":\"Pausa temporal\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.flagEstado").value("0"));

        mockMvc.perform(post("/api/compras/contratos-marco/{id}/reabrir", id)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"motivo\":\"Se reactiva\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.flagEstado").value("1"));

        mockMvc.perform(post("/api/compras/contratos-marco/{id}/cerrar", id)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"motivo\":\"Fin de vigencia\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.flagEstado").value("2"));
    }

    @Test
    @Order(45)
    @DisplayName("CTM-02: Anular contrato y consultar OCs generadas")
    void contratoMarco_anularYOcGeneradas() throws Exception {
        Long id = crearContratoMarco();

        mockMvc.perform(post("/api/compras/contratos-marco/{id}/anular", id)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"motivo\":\"Prueba de anulacion\"}"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.flagEstado").value("0"));

        mockMvc.perform(get("/api/compras/contratos-marco/{id}/oc-generadas", id)
                .header("Authorization", AUTH))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @Order(46)
    @DisplayName("CS-01: Flujo conformidad crear -> aprobar -> pdf")
    void conformidadServicio_flujoPrincipal() throws Exception {
        Long osId = crearOrdenServicioConActa();

        String body = """
            {
                "ordenServicioId": %d,
                "fecha": "%s",
                "observacion": "Conformidad IT",
                "lineas": [
                    { "secuencia": 1, "descripcion": "Servicio validado", "cantidad": 1.00, "precioUnitario": 1500.00 }
                ]
            }
            """.formatted(osId, LocalDate.now());

        String response = mockMvc.perform(post("/api/compras/actas-conformidad")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").exists())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(post("/api/compras/actas-conformidad/{id}/aprobar", id)
                .header("Authorization", AUTH))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.aprobado").value(true));

        mockMvc.perform(get("/api/compras/actas-conformidad/{id}/pdf", id)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
    }

    @Test
    @Order(47)
    @DisplayName("CS-02: Pendientes de conformidad y anulacion")
    void conformidadServicio_pendientesYAnular() throws Exception {
        Long osPendienteId = crearOrdenServicioConActa();

        mockMvc.perform(get("/api/compras/actas-conformidad/pendientes")
                .header("Authorization", AUTH)
                .param("proveedorId", String.valueOf(proveedorId)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        String body = """
            {
                "ordenServicioId": %d,
                "fecha": "%s",
                "observacion": "Conformidad a anular",
                "lineas": [
                    { "secuencia": 1, "descripcion": "Linea para anular", "cantidad": 1.00, "precioUnitario": 100.00 }
                ]
            }
            """.formatted(osPendienteId, LocalDate.now());

        String response = mockMvc.perform(post("/api/compras/actas-conformidad")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        Long id = objectMapper.readTree(response).get("data").get("id").asLong();

        mockMvc.perform(post("/api/compras/actas-conformidad/{id}/anular", id)
                .header("Authorization", AUTH))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.flagEstado").value("0"));
    }

    @Test
    @Order(48)
    @DisplayName("MST-01: CRUD maestros de tipos, servicios y precios pactados")
    void maestros_catalogos_crud() throws Exception {
        String tipoCodigo = uniqueCode("TIP");
        String tipoBody = """
            { "tipo": "%s", "descripcion": "Tipo IT %s" }
            """.formatted(tipoCodigo, tipoCodigo);

        String tipoResponse = mockMvc.perform(post("/api/compras/maestros/tipos-entidad-contribuyente")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(tipoBody))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        Long tipoId = objectMapper.readTree(tipoResponse).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/compras/maestros/tipos-entidad-contribuyente/{id}/desactivar", tipoId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
        mockMvc.perform(patch("/api/compras/maestros/tipos-entidad-contribuyente/{id}/activar", tipoId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
        mockMvc.perform(delete("/api/compras/maestros/tipos-entidad-contribuyente/{id}", tipoId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());

        String servicioCodigo = uniqueCode("SV");
        String servicioBody = """
            {
                "servicio": "%s",
                "flagEstado": "1",
                "descripcion": "Servicio IT %s",
                "tarifaEstd": 99.90,
                "unidadMedidaId": 76
            }
            """.formatted(servicioCodigo, servicioCodigo);

        String servicioResponse = mockMvc.perform(post("/api/compras/maestros/servicios-catalogo")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(servicioBody))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        Long servicioNuevoId = objectMapper.readTree(servicioResponse).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/compras/maestros/servicios-catalogo/{id}/desactivar", servicioNuevoId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
        mockMvc.perform(patch("/api/compras/maestros/servicios-catalogo/{id}/activar", servicioNuevoId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
        mockMvc.perform(delete("/api/compras/maestros/servicios-catalogo/{id}", servicioNuevoId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());

        String precioBody = """
            {
                "articuloId": %d,
                "proveedorId": %d,
                "precio": 14.75,
                "monedaId": 1,
                "fechaDesde": "%s",
                "fechaHasta": "%s"
            }
            """.formatted(articuloId, proveedorId, LocalDate.now(), LocalDate.now().plusDays(30));

        String precioResponse = mockMvc.perform(post("/api/compras/maestros/articulo-precios-pactados")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(precioBody))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        Long precioId = objectMapper.readTree(precioResponse).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/compras/maestros/articulo-precios-pactados/{id}/desactivar", precioId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
        mockMvc.perform(patch("/api/compras/maestros/articulo-precios-pactados/{id}/activar", precioId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
        mockMvc.perform(delete("/api/compras/maestros/articulo-precios-pactados/{id}", precioId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
    }

    @Test
    @Order(49)
    @DisplayName("MST-02: CRUD maestros de comprador, aprobador y estructura")
    void maestros_operativos_crud() throws Exception {
        Long usuarioLibre = resolveUnusedActiveUserId();
        Long categoriaId = resolveArticuloCategoriaId();
        Long articuloHijoId = comprasFactory.resolveSecondArticuloId(articuloId);

        String compradorBody = """
            { "usuarioId": %d, "nombre": "Comprador IT", "flagEstado": "1" }
            """.formatted(usuarioLibre);

        String compradorResponse = mockMvc.perform(post("/api/compras/maestros/compradores")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(compradorBody))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        Long compradorId = objectMapper.readTree(compradorResponse).get("data").get("id").asLong();

        mockMvc.perform(post("/api/compras/maestros/compradores/{id}/categorias", compradorId)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"articuloCategId\": %d}".formatted(categoriaId)))
                .andExpect(status().isCreated());
        mockMvc.perform(patch("/api/compras/maestros/compradores/{id}/desactivar", compradorId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
        mockMvc.perform(patch("/api/compras/maestros/compradores/{id}/activar", compradorId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());

        String aprobadorBody = """
            { "docTipoId": %d, "nivel": 9, "aprobadorId": %d, "montoMinimo": 0, "montoMaximo": 999999.99 }
            """.formatted(comprasFactory.resolveDocTipoId("OS"), usuarioLibre);

        String aprobadorResponse = mockMvc.perform(post("/api/compras/maestros/aprobadores")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(aprobadorBody))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();
        Long aprobadorCfgId = objectMapper.readTree(aprobadorResponse).get("data").get("id").asLong();

        mockMvc.perform(patch("/api/compras/maestros/aprobadores/{id}/desactivar", aprobadorCfgId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
        mockMvc.perform(patch("/api/compras/maestros/aprobadores/{id}/activar", aprobadorCfgId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());

        String estructuraBody = """
            { "articuloPadreId": %d, "articuloHijoId": %d, "cantidad": 2.50 }
            """.formatted(articuloId, articuloHijoId);

        mockMvc.perform(post("/api/compras/maestros/articulo-estructuras")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(estructuraBody))
                .andExpect(status().isCreated());

        mockMvc.perform(delete("/api/compras/maestros/articulo-estructuras/{padre}/{hijo}", articuloId, articuloHijoId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());

        mockMvc.perform(delete("/api/compras/maestros/aprobadores/{id}", aprobadorCfgId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
        mockMvc.perform(delete("/api/compras/maestros/compradores/{id}", compradorId)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
    }

    private Long crearSolicitud() throws Exception {
        String body = """
            {
                "fecha": "%s",
                "prioridad": "ALTA",
                "justificacion": "Test de flujo",
                "lineas": [
                    { "articuloId": %d, "cantidad": 50.00 }
                ]
            }
            """.formatted(LocalDate.now(), articuloId);

        String response = mockMvc.perform(post("/api/compras/solicitudes-compra")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private void enviarSolicitud(Long id) throws Exception {
        mockMvc.perform(post("/api/compras/solicitudes-compra/{id}/enviar", id)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
    }

    private void aprobarSolicitud(Long id) throws Exception {
        mockMvc.perform(post("/api/compras/solicitudes-compra/{id}/aprobar", id)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
                .andExpect(status().isOk());
    }

    private Long crearOrdenCompra() throws Exception {
        requiereArticuloMovProy();
        String response = mockMvc.perform(post("/api/compras/ordenes-compra")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(buildOcRequest()))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private void enviarOcAprobacion(Long id) throws Exception {
        mockMvc.perform(post("/api/compras/ordenes-compra/{id}/enviar-aprobacion", id)
                .header("Authorization", AUTH))
                .andExpect(status().isOk());
    }

    private void aprobarOc(Long id) throws Exception {
        mockMvc.perform(post("/api/compras/ordenes-compra/{id}/aprobar", id)
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{\"comentario\":\"OK\"}"))
                .andExpect(status().isOk());
    }

    private Long crearOrdenServicio() throws Exception {
        requiereNumeradorOrdenServicio();
        String response = mockMvc.perform(post("/api/compras/ordenes-servicio")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(buildOsRequest()))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private Long crearOrdenServicioConActa() throws Exception {
        requiereNumeradorOrdenServicio();
        String response = mockMvc.perform(post("/api/compras/ordenes-servicio")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(buildOsRequest(true)))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private Long crearProgramacion() throws Exception {
        String body = """
            {
                "anio": %d,
                "mes": 8,
                "lineas": [
                    { "articuloId": %d, "cantidad": 15.00, "precioEstimado": 9.50 }
                ]
            }
            """.formatted(LocalDate.now().getYear(), articuloId);

        String response = mockMvc.perform(post("/api/compras/programaciones")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private Long crearContratoMarco() throws Exception {
        String body = """
            {
                "proveedorId": %d,
                "fechaInicio": "%s",
                "fechaFin": "%s",
                "condiciones": "Contrato IT reusable"
            }
            """.formatted(proveedorId, LocalDate.now(), LocalDate.now().plusDays(10));

        String response = mockMvc.perform(post("/api/compras/contratos-marco")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private Long crearCotizacion() throws Exception {
        String body = """
            {
                "proveedorId": %d,
                "fecha": "%s",
                "monedaId": 1,
                "lineas": [
                    { "articuloId": %d, "cantidad": 50.00, "precioUnitario": 12.50, "descuento": 0.00, "plazoEntregaDias": 3 }
                ]
            }
            """.formatted(proveedorId, LocalDate.now(), articuloId);

        String response = mockMvc.perform(post("/api/compras/cotizaciones")
                .header("Authorization", AUTH)
                .contentType(MediaType.APPLICATION_JSON)
                .content(body))
                .andExpect(status().isCreated())
                .andReturn().getResponse().getContentAsString();

        return objectMapper.readTree(response).get("data").get("id").asLong();
    }

    private void requiereNumeradorOrdenServicio() {
        Assumptions.assumeTrue(
                numOrdSrvTableExists,
                "El tenant de pruebas no expone compras.num_ord_srv; se omiten los flujos de OS dependientes del numerador");
    }

    private void requiereArticuloMovProy() {
        Assumptions.assumeTrue(
                articuloMovProyTableExists,
                "El tenant de pruebas no expone compras.articulo_mov_proy; se omiten los flujos de OC dependientes del movimiento proyectado");
    }

    private String buildOcRequest() {
        return """
            {
                "sucursalId": %d,
                "proveedorId": %d,
                "fechaEmision": "%s",
                "fechaEntrega": "%s",
                "monedaId": 1,
                "formaPagoId": 1,
                "lugarEntrega": "Almacen central",
                "tipoCambio": 1.00,
                "flagImportacion": false,
                "lineas": [
                    {
                        "articuloId": %d,
                        "cantProyectada": 50.0000,
                        "valorUnitario": 12.50,
                        "tipoImpuestoId": 1,
                        "descuentoPorcentaje": 0.00,
                        "fechaEntrega": "%s"
                    }
                ]
            }
            """.formatted(
                sucursalId,
                proveedorId,
                LocalDate.now(),
                LocalDate.now().plusDays(14),
                articuloId,
                LocalDate.now().plusDays(14)
            );
    }

    private String buildOsRequest() {
        return buildOsRequest(false);
    }

    private String buildOsRequest(boolean solicitaActa) {
        return """
            {
                "sucursalId": %d,
                "codOrigen": "OS",
                "proveedorId": %d,
                "monedaId": 1,
                "formaPagoId": 1,
                "fecRegistro": "%s",
                "flagSolicitaActa": %s,
                "lineas": [
                    { "servicioId": %d, "descripcion": "Servicio de prueba integracion", "importe": 1500.00, "fecProyect": "%s" }
                ]
            }
            """.formatted(
                sucursalId,
                proveedorId,
                LocalDate.now(),
                solicitaActa,
                servicioId,
                LocalDate.now().plusDays(30)
            );
    }

    private Long resolveUnusedActiveUserId() {
        List<Long> activeUsers = securityJdbc.queryForList(
                "SELECT id FROM auth.usuario WHERE flag_estado = '1' ORDER BY id",
                Long.class);

        for (Long userId : activeUsers) {
            Integer count = jdbc.queryForObject(
                    "SELECT COUNT(*) FROM compras.comprador WHERE usuario_id = ?",
                    Integer.class, userId);
            if (count != null && count == 0) {
                return userId;
            }
        }
        throw new IllegalStateException("No se encontro un usuario activo libre para pruebas de comprador");
    }

    private Long resolveArticuloCategoriaId() {
        return jdbc.queryForObject(
                "SELECT id FROM core.articulo_categ ORDER BY id LIMIT 1",
                Long.class);
    }

    private String uniqueCode(String prefix) {
        String suffix = Long.toString(System.nanoTime());
        int maxSuffix = Math.max(1, 6 - prefix.length());
        return (prefix + suffix.substring(Math.max(0, suffix.length() - maxSuffix))).toUpperCase();
    }
}
