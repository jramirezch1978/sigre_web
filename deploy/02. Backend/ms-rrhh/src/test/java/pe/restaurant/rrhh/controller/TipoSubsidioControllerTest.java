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
import pe.restaurant.rrhh.dto.request.TipoSubsidioCreateRequest;
import pe.restaurant.rrhh.dto.request.TipoSubsidioUpdateRequest;
import pe.restaurant.rrhh.dto.response.TipoSubsidioResponse;
import pe.restaurant.rrhh.service.TipoSubsidioService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - TipoSubsidioController")
class TipoSubsidioControllerTest {

    @Mock
    private TipoSubsidioService service;

    @InjectMocks
    private TipoSubsidioController controller;

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
    @DisplayName("GET /api/rrhh/tipos-subsidio -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<TipoSubsidioResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.tipoSubsidioResponse(1L, "SUB", "Subsidio")
        ));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/tipos-subsidio")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content", hasSize(1)))
                .andExpect(jsonPath("$.data.content[0].codigo").value("SUB"));

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-subsidio con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() throws Exception {
        Page<TipoSubsidioResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.tipoSubsidioResponse(1L, "SUB", "Subsidio")
        ));
        when(service.listar(eq("SUB"), eq("Subsidio"), eq("1"), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/tipos-subsidio")
                        .param("codigo", "SUB")
                        .param("nombre", "Subsidio")
                        .param("flagEstado", "1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).listar(eq("SUB"), eq("Subsidio"), eq("1"), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-subsidio/{id} -> retorna entidad")
    void obtenerPorId_idExistente_retornaEntidad() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(
                RrhhTestFixtures.tipoSubsidioResponse(1L, "SUB", "Subsidio")
        );

        mockMvc.perform(get("/api/rrhh/tipos-subsidio/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").value("SUB"))
                .andExpect(jsonPath("$.data.nombre").value("Subsidio"));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/tipos-subsidio -> crea exitosamente")
    void crear_datosValidos_creaExitosamente() throws Exception {
        TipoSubsidioCreateRequest request = RrhhTestFixtures.tipoSubsidioCreateRequest("SUB", "Subsidio");
        when(service.crear(any())).thenReturn(
                RrhhTestFixtures.tipoSubsidioResponse(1L, "SUB", "Subsidio")
        );

        mockMvc.perform(post("/api/rrhh/tipos-subsidio")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1))
                .andExpect(jsonPath("$.data.codigo").value("SUB"));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/tipos-subsidio/{id} -> actualiza exitosamente")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        TipoSubsidioUpdateRequest request = RrhhTestFixtures.tipoSubsidioUpdateRequest("Subsidio Actualizado");
        when(service.actualizar(eq(1L), any())).thenReturn(
                RrhhTestFixtures.tipoSubsidioResponse(1L, "SUB", "Subsidio Actualizado")
        );

        mockMvc.perform(put("/api/rrhh/tipos-subsidio/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.nombre").value("Subsidio Actualizado"));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/tipos-subsidio/{id}/desactivar -> desactiva lógicamente")
    void desactivar_idExistente_desactiva() throws Exception {
        when(service.desactivar(1L)).thenReturn(RrhhTestFixtures.tipoSubsidioResponse(1L, "SUB", "Subsidio"));

        mockMvc.perform(patch("/api/rrhh/tipos-subsidio/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).desactivar(1L);
    }

    @Test
    @DisplayName("PATCH /api/rrhh/tipos-subsidio/{id}/activar -> activa entidad")
    void activar_idExistente_activaExitosamente() throws Exception {
        when(service.activar(1L)).thenReturn(RrhhTestFixtures.tipoSubsidioResponse(1L, "SUB", "Subsidio"));

        mockMvc.perform(patch("/api/rrhh/tipos-subsidio/{id}/activar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).activar(1L);
    }

    @Test
    @DisplayName("GET /api/rrhh/tipos-subsidio/activos -> retorna lista activos")
    void listarActivos_retornaLista() throws Exception {
        when(service.listarActivos()).thenReturn(List.of(
                RrhhTestFixtures.tipoSubsidioResponse(1L, "SUB", "Subsidio")
        ));

        mockMvc.perform(get("/api/rrhh/tipos-subsidio/activos"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).listarActivos();
    }
}
