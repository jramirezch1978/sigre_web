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
import pe.restaurant.rrhh.dto.request.PeriodoCtsCreateRequest;
import pe.restaurant.rrhh.dto.request.PeriodoCtsUpdateRequest;
import pe.restaurant.rrhh.dto.response.PeriodoCtsResponse;
import pe.restaurant.rrhh.service.PeriodoCtsService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - PeriodoCtsController")
class PeriodoCtsControllerTest {

    @Mock
    private PeriodoCtsService service;

    @InjectMocks
    private PeriodoCtsController controller;

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
    @DisplayName("GET /api/rrhh/periodos-cts -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<PeriodoCtsResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.periodoCtsResponse(1L, "PC", "Período CTS")
        ));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/periodos-cts")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content", hasSize(1)))
                .andExpect(jsonPath("$.data.content[0].codigo").value("PC"));

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/periodos-cts con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() throws Exception {
        Page<PeriodoCtsResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.periodoCtsResponse(1L, "PC", "Período CTS")
        ));
        when(service.listar(eq("PC"), eq("Período CTS"), eq("1"), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/periodos-cts")
                        .param("codigo", "PC")
                        .param("nombre", "Período CTS")
                        .param("flagEstado", "1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).listar(eq("PC"), eq("Período CTS"), eq("1"), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/periodos-cts/{id} -> retorna entidad")
    void obtenerPorId_idExistente_retornaEntidad() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(
                RrhhTestFixtures.periodoCtsResponse(1L, "PC", "Período CTS")
        );

        mockMvc.perform(get("/api/rrhh/periodos-cts/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").value("PC"))
                .andExpect(jsonPath("$.data.nombre").value("Período CTS"));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/periodos-cts -> crea exitosamente")
    void crear_datosValidos_creaExitosamente() throws Exception {
        PeriodoCtsCreateRequest request = RrhhTestFixtures.periodoCtsCreateRequest("PC", "Período CTS");
        when(service.crear(any())).thenReturn(
                RrhhTestFixtures.periodoCtsResponse(1L, "PC", "Período CTS")
        );

        mockMvc.perform(post("/api/rrhh/periodos-cts")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").value("PC"));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/periodos-cts/{id} -> actualiza exitosamente")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        PeriodoCtsUpdateRequest request = RrhhTestFixtures.periodoCtsUpdateRequest("Período Actualizado");
        when(service.actualizar(eq(1L), any())).thenReturn(
                RrhhTestFixtures.periodoCtsResponse(1L, "PC", "Período Actualizado")
        );

        mockMvc.perform(put("/api/rrhh/periodos-cts/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("Período Actualizado"));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/periodos-cts/{id}/desactivar -> desactiva lógicamente")
    void desactivar_idExistente_desactiva() throws Exception {
        when(service.desactivar(1L)).thenReturn(RrhhTestFixtures.periodoCtsResponse(1L, "PC", "Período CTS"));

        mockMvc.perform(patch("/api/rrhh/periodos-cts/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).desactivar(1L);
    }

    @Test
    @DisplayName("PATCH /api/rrhh/periodos-cts/{id}/activar -> activa entidad")
    void activar_idExistente_activaExitosamente() throws Exception {
        when(service.activar(1L)).thenReturn(RrhhTestFixtures.periodoCtsResponse(1L, "PC", "Período CTS"));

        mockMvc.perform(patch("/api/rrhh/periodos-cts/{id}/activar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).activar(1L);
    }

    @Test
    @DisplayName("GET /api/rrhh/periodos-cts/activos -> retorna lista activos")
    void listarActivos_retornaLista() throws Exception {
        when(service.listarActivos()).thenReturn(List.of(
                RrhhTestFixtures.periodoCtsResponse(1L, "PC", "Período CTS")
        ));

        mockMvc.perform(get("/api/rrhh/periodos-cts/activos"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).listarActivos();
    }
}