package pe.restaurant.rrhh.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import pe.restaurant.common.exception.GlobalExceptionHandler;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.SolicitarGoceRequest;
import pe.restaurant.rrhh.dto.request.VacacionCreateRequest;
import pe.restaurant.rrhh.dto.request.VacacionObservarRequest;
import pe.restaurant.rrhh.dto.request.VacacionProcesarRequest;
import pe.restaurant.rrhh.dto.request.VacacionUpdateRequest;
import pe.restaurant.rrhh.dto.response.SaldoVacacionDto;
import pe.restaurant.rrhh.service.VacacionService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - VacacionController")
class VacacionControllerTest {

    @Mock
    private VacacionService service;

    @InjectMocks
    private VacacionController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler())
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .setMessageConverters(new MappingJackson2HttpMessageConverter(objectMapper))
                .build();
    }

    @Test
    @DisplayName("GET /api/rrhh/vacaciones -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<?> page = new PageImpl<>(List.of(
                RrhhTestFixtures.vacacionResponse(1L)
        ));
        when(service.listar(any(), any(), any(), any())).thenReturn((org.springframework.data.domain.Page) page);

        mockMvc.perform(get("/api/rrhh/vacaciones")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/vacaciones/{id} -> retorna vacación")
    void obtenerPorId_idExistente_retornaVacacion() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(get("/api/rrhh/vacaciones/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/vacaciones -> crea período vacacional")
    void crear_datosValidos_creaExitosamente() throws Exception {
        VacacionCreateRequest request = RrhhTestFixtures.vacacionCreateRequest();
        when(service.crear(any())).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/vacaciones")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/vacaciones/{id} -> actualiza período")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        VacacionUpdateRequest request = RrhhTestFixtures.vacacionUpdateRequest();
        when(service.actualizar(eq(1L), any())).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(put("/api/rrhh/vacaciones/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("POST /api/rrhh/vacaciones/{id}/solicitar-goce -> solicita goce")
    void solicitarGoce_datosValidos_solicitaExitosamente() throws Exception {
        SolicitarGoceRequest request = RrhhTestFixtures.solicitarGoceRequest();
        when(service.solicitarGoce(eq(1L), any())).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/vacaciones/{id}/solicitar-goce", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).solicitarGoce(eq(1L), any());
    }

    @Test
    @DisplayName("POST /api/rrhh/vacaciones/{id}/aprobar -> aprueba goce")
    void aprobar_idExistente_apruebaExitosamente() throws Exception {
        when(service.aprobar(1L)).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/vacaciones/{id}/aprobar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).aprobar(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/vacaciones/{id}/rechazar -> rechaza goce")
    void rechazar_idExistente_rechazaExitosamente() throws Exception {
        when(service.rechazar(1L)).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/vacaciones/{id}/rechazar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).rechazar(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/vacaciones/{id}/reprogramar -> reprograma goce")
    void reprogramar_datosValidos_reprogramaExitosamente() throws Exception {
        SolicitarGoceRequest request = RrhhTestFixtures.solicitarGoceRequest();
        when(service.reprogramar(eq(1L), any())).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/vacaciones/{id}/reprogramar", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).reprogramar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/vacaciones/{id}/desactivar -> desactiva período")
    void desactivar_idExistente_desactivaExitosamente() throws Exception {
        when(service.desactivar(1L)).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(patch("/api/rrhh/vacaciones/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).desactivar(1L);
    }

    // ══════════════════════════════════════════════════════════════
    //  TRANSICIONES DE ESTADO — NUEVAS
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("POST /api/rrhh/vacaciones/{id}/observar -> observa vacación")
    void observar_datosValidos_observaExitosamente() throws Exception {
        VacacionObservarRequest request = new VacacionObservarRequest("Observación de prueba");
        when(service.observar(eq(1L), any())).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/vacaciones/{id}/observar", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).observar(eq(1L), any());
    }

    @Test
    @DisplayName("POST /api/rrhh/vacaciones/{id}/anular -> anula vacación")
    void anular_idExistente_anulaExitosamente() throws Exception {
        when(service.anular(1L)).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/vacaciones/{id}/anular", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).anular(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/vacaciones/{id}/cerrar -> cierra vacación")
    void cerrar_idExistente_cierraExitosamente() throws Exception {
        when(service.cerrar(1L)).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/vacaciones/{id}/cerrar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).cerrar(1L);
    }

    // ══════════════════════════════════════════════════════════════
    //  CONSULTAS Y PROCESOS BATCH
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("GET /api/rrhh/vacaciones/bandeja-aprobacion -> retorna lista paginada")
    void bandejaAprobacion_retornaListaPaginada() throws Exception {
        Page<?> page = new PageImpl<>(List.of(
                RrhhTestFixtures.vacacionResponse(1L)
        ));
        when(service.bandejaAprobacion(any(), any())).thenReturn((org.springframework.data.domain.Page) page);

        mockMvc.perform(get("/api/rrhh/vacaciones/bandeja-aprobacion")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).bandejaAprobacion(any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/vacaciones/saldos -> retorna saldos")
    void consultarSaldos_retornaListaSaldos() throws Exception {
        when(service.consultarSaldos(any())).thenReturn(List.of(
                new SaldoVacacionDto(1L, "Paterno Materno, Nombre 1", 2026, 30, 0, 30, 15)
        ));

        mockMvc.perform(get("/api/rrhh/vacaciones/saldos")
                        .param("periodoAnio", "2026"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data", hasSize(1)))
                .andExpect(jsonPath("$.data[0].trabajadorId").value(1));

        verify(service).consultarSaldos(any());
    }

    @Test
    @DisplayName("POST /api/rrhh/vacaciones/procesar -> procesa planificación")
    void procesar_datosValidos_procesaExitosamente() throws Exception {
        VacacionProcesarRequest request = new VacacionProcesarRequest(2026);
        when(service.procesar(any())).thenReturn(RrhhTestFixtures.vacacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/vacaciones/procesar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).procesar(any());
    }
}
