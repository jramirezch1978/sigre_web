package pe.restaurant.rrhh.controller.integration;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import pe.restaurant.rrhh.testdata.RrhhTestDataExecutionListener;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;
import org.springframework.boot.test.mock.mockito.MockBean;
import pe.restaurant.common.security.JwtTokenProvider;
import static org.mockito.Mockito.when;
import pe.restaurant.rrhh.dto.request.TurnoRequest;
import pe.restaurant.rrhh.service.TurnoService;

import java.time.LocalTime;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Tests de integración para TurnoController.
 * Validan el flujo completo HTTP → Controller → Service → Repository → BD.
 * Usan BD real y contexto completo de Spring.
 */
@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = {TenantContextTestExecutionListener.class, RrhhTestDataExecutionListener.class},
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
@Tag("integration")
@DisplayName("TurnoController - Pruebas de Integración")
class TurnoControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @Autowired
    private TurnoService turnoService;

    private String authToken;

    @MockBean
    private JwtTokenProvider jwtTokenProvider;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        
        // Generate mock auth token
        authToken = "Bearer mock-token";
        
        // Mock JWT token validation
        when(jwtTokenProvider.validateToken("mock-token")).thenReturn(true);
        when(jwtTokenProvider.getEmpresaId("mock-token")).thenReturn(2L);
        when(jwtTokenProvider.getUserId("mock-token")).thenReturn(1L);
        when(jwtTokenProvider.getUsername("mock-token")).thenReturn("testuser");
        when(jwtTokenProvider.getClaim("mock-token", "authorities", String.class))
                .thenReturn("SCOPE_rrhh");
        // Stubs requeridos por JwtDefinitiveTokenResolver.extractClaims()
        when(jwtTokenProvider.getClaim("mock-token", "empresaId", Object.class)).thenReturn(2L);
        when(jwtTokenProvider.getClaim("mock-token", "sucursalId", Object.class)).thenReturn(1L);
        when(jwtTokenProvider.getClaim("mock-token", "userId", Object.class)).thenReturn(1L);
    }

    private String uniqueName(String base) {
        return base + " " + System.nanoTime();
    }

    // ==== Tests de listado ====
    @Test
    @DisplayName("GET /api/rrhh/turnos - sin filtros -> retorna página")
    void listarTurnos_sinDatos_retornaPagina() throws Exception {
        mockMvc.perform(get("/api/rrhh/turnos")
                .header("Authorization", authToken)
                .header("X-Empresa-Id", "2")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.page").exists());
    }

    @Test
    @DisplayName("GET /api/rrhh/turnos - con datos -> retorna página con turnos")
    void listarTurnos_conDatos_retornaPaginaConTurnos() throws Exception {
        // Arrange - Crear turno de prueba
        TurnoRequest request = TurnoRequest.builder()
                .nombre("Turno Integración")
                .horaEntrada(LocalTime.of(9, 0))
                .horaSalida(LocalTime.of(17, 0))
                .minutosTolerancia(15)
                .aplicaLunes(true)
                .aplicaMartes(true)
                .aplicaMiercoles(true)
                .aplicaJueves(true)
                .aplicaViernes(true)
                .aplicaSabado(false)
                .aplicaDomingo(false)
                .build();

turnoService.crear(request);
        // Act & Assert
        mockMvc.perform(get("/api/rrhh/turnos")
                .header("Authorization", authToken)
                .header("X-Empresa-Id", "2")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isNotEmpty());
    }

    @Test
    @DisplayName("GET /api/rrhh/turnos - con filtro por nombre -> retorna página filtrada")
    void listarTurnos_conFiltro_retornaPaginaFiltrada() throws Exception {
        // Arrange - Crear múltiples turnos
        String nombreFiltro = uniqueName("Turno Filtro");
        TurnoRequest request1 = TurnoRequest.builder()
                .nombre(nombreFiltro)
                .horaEntrada(LocalTime.of(8, 0))
                .horaSalida(LocalTime.of(16, 0))
                .aplicaLunes(true)
                .build();

        TurnoRequest request2 = TurnoRequest.builder()
                .nombre(uniqueName("Turno Otro"))
                .horaEntrada(LocalTime.of(20, 0))
                .horaSalida(LocalTime.of(4, 0))
                .aplicaLunes(true)
                .build();

        turnoService.crear(request1);
        turnoService.crear(request2);

        // Act & Assert
        String filtro = nombreFiltro.substring(0, nombreFiltro.length() - 3);
        mockMvc.perform(get("/api/rrhh/turnos")
                .header("Authorization", authToken)
                .header("X-Empresa-Id", "2")
                .param("nombre", filtro)
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isNotEmpty());
    }

    // ==== Tests de obtención por ID ====
    @Test
    @DisplayName("GET /api/rrhh/turnos/{id} - con ID existente -> retorna turno")
    void obtenerTurno_idExistente_retornaTurno() throws Exception {
        // Arrange
        TurnoRequest request = TurnoRequest.builder()
                .nombre("Turno Obtener")
                .horaEntrada(LocalTime.of(10, 0))
                .horaSalida(LocalTime.of(18, 0))
                .aplicaLunes(true)
                .build();

        var turnoCreado = turnoService.crear(request);

        // Act & Assert
        mockMvc.perform(get("/api/rrhh/turnos/{id}", turnoCreado.getId())
                .header("Authorization", authToken)
                .header("X-Empresa-Id", "2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(turnoCreado.getId()))
                .andExpect(jsonPath("$.data.nombre").value("Turno Obtener"))
                .andExpect(jsonPath("$.data.horaEntrada").value("10:00:00"))
                .andExpect(jsonPath("$.data.horaSalida").value("18:00:00"));
    }

    @Test
    @DisplayName("GET /api/rrhh/turnos/{id} - con ID inexistente -> retorna 404")
    void obtenerTurno_idInexistente_retorna404() throws Exception {
        mockMvc.perform(get("/api/rrhh/turnos/{id}", 99999)
                .header("Authorization", authToken)
                .header("X-Empresa-Id", "2"))
                .andExpect(status().isNotFound());
    }

    // ==== Tests de creación ====
    @Test
    @DisplayName("POST /api/rrhh/turnos - con datos válidos -> crea turno exitosamente")
    void crearTurno_datosValidos_creaExitosamente() throws Exception {
        // Arrange
        TurnoRequest request = TurnoRequest.builder()
                .nombre("Turno Nuevo")
                .horaEntrada(LocalTime.of(8, 30))
                .horaSalida(LocalTime.of(16, 30))
                .minutosTolerancia(5)
                .aplicaLunes(true)
                .aplicaMartes(true)
                .aplicaMiercoles(true)
                .aplicaJueves(true)
                .aplicaViernes(true)
                .aplicaSabado(false)
                .aplicaDomingo(false)
                .build();

        // Act & Assert
        mockMvc.perform(post("/api/rrhh/turnos")
                .header("Authorization", authToken)
                .header("X-Empresa-Id", "2")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("Turno Nuevo"))
                .andExpect(jsonPath("$.data.horaEntrada").value("08:30:00"))
                .andExpect(jsonPath("$.data.horaSalida").value("16:30:00"))
                .andExpect(jsonPath("$.data.minutosTolerancia").value(5))
                .andExpect(jsonPath("$.data.aplicaLunes").value(true))
                .andExpect(jsonPath("$.data.aplicaDomingo").value(false))
                .andExpect(jsonPath("$.data.createdBy").value(1))
                .andExpect(jsonPath("$.data.fecCreacion").exists());
    }

    @Test
    @DisplayName("POST /api/rrhh/turnos - con nombre duplicado -> retorna 409")
    void crearTurno_nombreDuplicado_retorna409() throws Exception {
        // Arrange - Crear primer turno
        TurnoRequest request1 = TurnoRequest.builder()
                .nombre("Turno Duplicado")
                .horaEntrada(LocalTime.of(8, 0))
                .horaSalida(LocalTime.of(16, 0))
                .aplicaLunes(true)
                .build();

        turnoService.crear(request1);

        // Intentar crear turno con mismo nombre
        TurnoRequest request2 = TurnoRequest.builder()
                .nombre("Turno Duplicado")
                .horaEntrada(LocalTime.of(9, 0))
                .horaSalida(LocalTime.of(17, 0))
                .aplicaLunes(true)
                .build();

        // Act & Assert
        mockMvc.perform(post("/api/rrhh/turnos")
                .header("Authorization", authToken)
                .header("X-Empresa-Id", "2")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request2)))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("RH-TU-002"));
    }

    @Test
    @DisplayName("POST /api/rrhh/turnos - sin días activos -> retorna 400")
    void crearTurno_sinDiasActivos_retorna400() throws Exception {
        // Arrange
        TurnoRequest request = TurnoRequest.builder()
                .nombre("Turno Sin Días")
                .aplicaLunes(false)
                .aplicaMartes(false)
                .aplicaMiercoles(false)
                .aplicaJueves(false)
                .aplicaViernes(false)
                .aplicaSabado(false)
                .aplicaDomingo(false)
                .build();

        // Act & Assert
        mockMvc.perform(post("/api/rrhh/turnos")
                .header("Authorization", authToken)
                .header("X-Empresa-Id", "2")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("RH-TU-003"));
    }

    // ==== Tests de actualización ====
    @Test
    @DisplayName("PUT /api/rrhh/turnos/{id} - con datos válidos -> actualiza exitosamente")
    void actualizarTurno_datosValidos_actualizaExitosamente() throws Exception {
        // Arrange - Crear turno
        TurnoRequest requestCrear = TurnoRequest.builder()
                .nombre("Turno Original")
                .horaEntrada(LocalTime.of(8, 0))
                .horaSalida(LocalTime.of(16, 0))
                .aplicaLunes(true)
                .build();

        var turnoCreado = turnoService.crear(requestCrear);

        TurnoRequest requestActualizar = TurnoRequest.builder()
                .nombre("Turno Actualizado")
                .horaEntrada(LocalTime.of(9, 0))
                .horaSalida(LocalTime.of(17, 0))
                .minutosTolerancia(20)
                .aplicaLunes(true)
                .aplicaMartes(true)
                .aplicaMiercoles(true)
                .aplicaJueves(true)
                .aplicaViernes(true)
                .aplicaSabado(true)
                .aplicaDomingo(false)
                .build();

        // Act & Assert
        mockMvc.perform(put("/api/rrhh/turnos/{id}", turnoCreado.getId())
                .header("Authorization", authToken)
                .header("X-Empresa-Id", "2")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(requestActualizar)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("Turno Actualizado"))
                .andExpect(jsonPath("$.data.horaEntrada").value("09:00:00"))
                .andExpect(jsonPath("$.data.minutosTolerancia").value(20))
                .andExpect(jsonPath("$.data.aplicaSabado").value(true));
    }

    // ==== Tests de eliminación ====
    @Test
    @DisplayName("PATCH /api/rrhh/turnos/{id}/desactivar - con ID válido -> desactiva exitosamente")
    void desactivarTurno_idValido_desactivaExitosamente() throws Exception {
        // Arrange
        TurnoRequest request = TurnoRequest.builder()
                .nombre("Turno Desactivar")
                .horaEntrada(LocalTime.of(8, 0))
                .horaSalida(LocalTime.of(16, 0))
                .aplicaLunes(true)
                .build();

        var turnoCreado = turnoService.crear(request);

        // Act & Assert
        mockMvc.perform(patch("/api/rrhh/turnos/{id}/desactivar", turnoCreado.getId())
                .header("Authorization", authToken)
                .header("X-Empresa-Id", "2"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/turnos/{id}/desactivar - con ID inexistente -> retorna 404")
    void desactivarTurno_idInexistente_retorna404() throws Exception {
        mockMvc.perform(patch("/api/rrhh/turnos/{id}/desactivar", 99999)
                .header("Authorization", authToken)
                .header("X-Empresa-Id", "2"))
                .andExpect(status().isNotFound());
    }
}
