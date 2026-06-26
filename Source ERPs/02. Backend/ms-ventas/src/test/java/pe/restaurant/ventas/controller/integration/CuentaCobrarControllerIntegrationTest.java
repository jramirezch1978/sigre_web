package pe.restaurant.ventas.controller.integration;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import pe.restaurant.ventas.dto.request.CuentaCobrarAnularRequest;
import pe.restaurant.ventas.dto.request.CuentaCobrarMovimientoRequest;
import pe.restaurant.ventas.dto.request.CuentaCobrarRequest;
import pe.restaurant.ventas.entity.CuentaCobrarDet;
import pe.restaurant.ventas.testdata.VentasTestDataExecutionListener;

import javax.sql.DataSource;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Integration tests para CuentaCobrarController.
 * Cubre todos los endpoints con datos reales en BD para mejorar cobertura de branches.
 */
@Tag("integration")
@SpringBootTest
@AutoConfigureWebMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {
        TenantContextTestExecutionListener.class,
        VentasTestDataExecutionListener.class
    },
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@DisplayName("Pruebas de Integración — CuentaCobrarController")
class CuentaCobrarControllerIntegrationTest {

    @Autowired
    private WebApplicationContext webApplicationContext;

    @Autowired
    private DataSource dataSource;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private JdbcTemplate jdbc;

    private Long cuentaCobrarId;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.webAppContextSetup(webApplicationContext).build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        jdbc = new JdbcTemplate(dataSource);
        
        // Obtener ID de cuenta por cobrar existente
        cuentaCobrarId = jdbc.queryForObject(
            "SELECT id FROM ventas.cuenta_cobrar WHERE flag_estado = '1' LIMIT 1", 
            Long.class
        );
    }

    // ==== GET /api/ventas/cuentas-cobrar ====

    @Test
    @DisplayName("GET /api/ventas/cuentas-cobrar sin filtros -> retorna página")
    void findAll_sinFiltros_retornaPagina() throws Exception {
        mockMvc.perform(get("/api/ventas/cuentas-cobrar")
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/ventas/cuentas-cobrar con filtros -> retorna página filtrada")
    void findAll_conFiltros_retornaPaginaFiltrada() throws Exception {
        mockMvc.perform(get("/api/ventas/cuentas-cobrar")
                .param("page", "0")
                .param("size", "10")
                .param("sucursalId", "1")
                .param("flagEstado", "1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/ventas/cuentas-cobrar con sort desc -> retorna ordenado descendente")
    void findAll_conSortDesc_retornaOrdenado() throws Exception {
        mockMvc.perform(get("/api/ventas/cuentas-cobrar")
                .param("page", "0")
                .param("size", "10")
                .param("sort", "fechaEmision,desc"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/ventas/cuentas-cobrar con sort asc -> retorna ordenado ascendente")
    void findAll_conSortAsc_retornaOrdenado() throws Exception {
        mockMvc.perform(get("/api/ventas/cuentas-cobrar")
                .param("page", "0")
                .param("size", "10")
                .param("sort", "fechaEmision,asc"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/ventas/cuentas-cobrar con fechas -> retorna filtrado por rango")
    void findAll_conFechas_retornaFiltrado() throws Exception {
        mockMvc.perform(get("/api/ventas/cuentas-cobrar")
                .param("page", "0")
                .param("size", "10")
                .param("fechaVencimientoDesde", "01/01/2024")
                .param("fechaVencimientoHasta", "31/12/2024"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== GET /api/ventas/cuentas-cobrar/{id} ====

    @Test
    @DisplayName("GET /api/ventas/cuentas-cobrar/{id} con ID existente -> retorna detalle")
    void findById_cuandoExiste_retornaDetalle() throws Exception {
        mockMvc.perform(get("/api/ventas/cuentas-cobrar/{id}", cuentaCobrarId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.id").value(cuentaCobrarId));
    }

    // ==== POST /api/ventas/cuentas-cobrar ====

    @Test
    @DisplayName("POST /api/ventas/cuentas-cobrar con datos válidos -> crea cuenta")
    void create_conDatosValidos_creaCuenta() throws Exception {
        CuentaCobrarRequest request = CuentaCobrarRequest.builder()
                .sucursalId(1L)
                .clienteId(1L)
                .docTipoId(1L)
                .serie("F001")
                .numero("00000001")
                .fechaEmision(LocalDate.now())
                .fechaVencimiento(LocalDate.now().plusDays(30))
                .monedaId(1L)
                .total(new BigDecimal("1000.00"))
                .saldo(new BigDecimal("1000.00"))
                .ano(2026).mes(5).cntblLibroId(4L)
                .build();

        mockMvc.perform(post("/api/ventas/cuentas-cobrar")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data.total").value(1000.00));
    }

    @Test
    @DisplayName("POST /api/ventas/cuentas-cobrar con movimientos -> crea cuenta con movimientos")
    void create_conMovimientos_creaCuentaConMovimientos() throws Exception {
        CuentaCobrarMovimientoRequest movimiento = CuentaCobrarMovimientoRequest.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.CARGO)
                .monto(new BigDecimal("1000.00"))
                .referencia("Cargo inicial")
                .conceptoFinancieroId(1L)
                .build();

        CuentaCobrarRequest request = CuentaCobrarRequest.builder()
                .sucursalId(1L)
                .clienteId(1L)
                .docTipoId(1L)
                .serie("F002")
                .numero("00000002")
                .fechaEmision(LocalDate.now())
                .fechaVencimiento(LocalDate.now().plusDays(30))
                .monedaId(1L)
                .total(new BigDecimal("1000.00"))
                .saldo(new BigDecimal("1000.00"))
                .ano(2026).mes(5).cntblLibroId(4L)
                .movimientos(Collections.singletonList(movimiento))
                .build();

        mockMvc.perform(post("/api/ventas/cuentas-cobrar")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("POST /api/ventas/cuentas-cobrar sin movimientos -> crea cuenta sin movimientos")
    void create_sinMovimientos_creaCuentaSinMovimientos() throws Exception {
        CuentaCobrarRequest request = CuentaCobrarRequest.builder()
                .sucursalId(1L)
                .clienteId(1L)
                .docTipoId(1L)
                .serie("F003")
                .numero("00000003")
                .fechaEmision(LocalDate.now())
                .fechaVencimiento(LocalDate.now().plusDays(30))
                .monedaId(1L)
                .total(new BigDecimal("500.00"))
                .saldo(new BigDecimal("500.00"))
                .ano(2026).mes(5).cntblLibroId(4L)
                .movimientos(null)
                .build();

        mockMvc.perform(post("/api/ventas/cuentas-cobrar")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== PUT /api/ventas/cuentas-cobrar/{id} ====

    @Test
    @DisplayName("PUT /api/ventas/cuentas-cobrar/{id} con datos válidos -> actualiza cuenta")
    void update_conDatosValidos_actualizaCuenta() throws Exception {
        CuentaCobrarRequest request = CuentaCobrarRequest.builder()
                .sucursalId(1L)
                .clienteId(1L)
                .docTipoId(1L)
                .serie("F001")
                .numero("00000999")
                .fechaEmision(LocalDate.now())
                .fechaVencimiento(LocalDate.now().plusDays(60))
                .monedaId(1L)
                .total(new BigDecimal("2000.00"))
                .saldo(new BigDecimal("2000.00"))
                .ano(2026).mes(5).cntblLibroId(4L)
                .build();

        mockMvc.perform(put("/api/ventas/cuentas-cobrar/{id}", cuentaCobrarId)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== PATCH /api/ventas/cuentas-cobrar/{id}/activar ====

    @Test
    @DisplayName("PATCH /api/ventas/cuentas-cobrar/{id}/activar -> activa cuenta")
    void activar_cuandoExiste_activaCuenta() throws Exception {
        mockMvc.perform(patch("/api/ventas/cuentas-cobrar/{id}/activar", cuentaCobrarId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== PATCH /api/ventas/cuentas-cobrar/{id}/desactivar ====

    @Test
    @DisplayName("PATCH /api/ventas/cuentas-cobrar/{id}/desactivar -> desactiva cuenta")
    void desactivar_cuandoExiste_desactivaCuenta() throws Exception {
        mockMvc.perform(patch("/api/ventas/cuentas-cobrar/{id}/desactivar", cuentaCobrarId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== DELETE /api/ventas/cuentas-cobrar/{id} ====

    @Test
    @DisplayName("DELETE /api/ventas/cuentas-cobrar/{id} -> elimina cuenta")
    void delete_cuandoExiste_eliminaCuenta() throws Exception {
        mockMvc.perform(delete("/api/ventas/cuentas-cobrar/{id}", cuentaCobrarId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== POST /api/ventas/cuentas-cobrar/{id}/movimientos ====

    @Test
    @DisplayName("POST /api/ventas/cuentas-cobrar/{id}/movimientos -> registra movimiento")
    void registrarMovimiento_conDatosValidos_registraMovimiento() throws Exception {
        CuentaCobrarMovimientoRequest request = CuentaCobrarMovimientoRequest.builder()
                .fechaMov(LocalDate.now())
                .tipoMov(CuentaCobrarDet.TipoMovimiento.ABONO)
                .monto(new BigDecimal("500.00"))
                .referencia("Abono parcial")
                .conceptoFinancieroId(1L)
                .build();

        mockMvc.perform(post("/api/ventas/cuentas-cobrar/{id}/movimientos", cuentaCobrarId)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== POST /api/ventas/cuentas-cobrar/{id}/anular ====

    @Test
    @DisplayName("POST /api/ventas/cuentas-cobrar/{id}/anular con motivo -> anula cuenta")
    void anular_conMotivo_anulaCuenta() throws Exception {
        CuentaCobrarAnularRequest request = CuentaCobrarAnularRequest.builder()
                .motivo("Anulación por error en facturación")
                .build();

        mockMvc.perform(post("/api/ventas/cuentas-cobrar/{id}/anular", cuentaCobrarId)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("POST /api/ventas/cuentas-cobrar/{id}/anular sin motivo -> anula cuenta")
    void anular_sinMotivo_anulaCuenta() throws Exception {
        mockMvc.perform(post("/api/ventas/cuentas-cobrar/{id}/anular", cuentaCobrarId)
                .contentType(MediaType.APPLICATION_JSON)
                .content("{}"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true));
    }

    // ==== GET /api/ventas/cuentas-cobrar/{id}/movimientos ====

    @Test
    @DisplayName("GET /api/ventas/cuentas-cobrar/{id}/movimientos -> retorna lista de movimientos")
    void findMovimientos_cuandoExiste_retornaMovimientos() throws Exception {
        mockMvc.perform(get("/api/ventas/cuentas-cobrar/{id}/movimientos", cuentaCobrarId))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.success").value(true))
            .andExpect(jsonPath("$.data").isArray());
    }
}
