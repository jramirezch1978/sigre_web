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
import pe.restaurant.rrhh.dto.request.QuintaCategoriaProcesarRequest;
import pe.restaurant.rrhh.dto.response.QuintaCategoriaResponse;
import pe.restaurant.rrhh.entity.QuintaCategoria;
import pe.restaurant.rrhh.mapper.QuintaCategoriaMapper;
import pe.restaurant.rrhh.service.QuintaCategoriaService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - QuintaCategoriaController")
class QuintaCategoriaControllerTest {

    @Mock
    private QuintaCategoriaService service;

    @Mock
    private QuintaCategoriaMapper mapper;

    @InjectMocks
    private QuintaCategoriaController controller;

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
    @DisplayName("POST /api/rrhh/quinta-categoria/procesar -> procesa batch")
    void procesar_retornaListaProcesada() throws Exception {
        QuintaCategoriaProcesarRequest request = QuintaCategoriaProcesarRequest.builder()
                .anio(2026)
                .mes(6)
                .build();

        QuintaCategoria entity = RrhhTestFixtures.quintaCategoria(1L);
        when(service.procesar(2026, 6)).thenReturn(List.of(entity));
        when(mapper.toResponse(entity)).thenReturn(RrhhTestFixtures.quintaCategoriaResponse(1L));

        mockMvc.perform(post("/api/rrhh/quinta-categoria/procesar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data", hasSize(1)))
                .andExpect(jsonPath("$.data[0].id").value(1));

        verify(service).procesar(2026, 6);
    }

    @Test
    @DisplayName("GET /api/rrhh/quinta-categoria -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        QuintaCategoria entity = RrhhTestFixtures.quintaCategoria(1L);
        Page<QuintaCategoria> page = new PageImpl<>(List.of(entity));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);
        when(mapper.toResponse(entity)).thenReturn(RrhhTestFixtures.quintaCategoriaResponse(1L));

        mockMvc.perform(get("/api/rrhh/quinta-categoria")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)))
                .andExpect(jsonPath("$.data.content[0].id").value(1));

        verify(service).listar(any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/quinta-categoria/{id} -> retorna detalle")
    void obtener_idExistente_retornaDetalle() throws Exception {
        QuintaCategoria entity = RrhhTestFixtures.quintaCategoria(1L);
        when(service.obtenerPorId(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(RrhhTestFixtures.quintaCategoriaResponse(1L));

        mockMvc.perform(get("/api/rrhh/quinta-categoria/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("GET /api/rrhh/quinta-categoria con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() throws Exception {
        when(service.listar(eq(1L), eq(2026), eq(6), any()))
                .thenReturn(new PageImpl<>(List.of()));

        mockMvc.perform(get("/api/rrhh/quinta-categoria")
                        .param("trabajadorId", "1")
                        .param("anio", "2026")
                        .param("mes", "6")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk());

        verify(service).listar(eq(1L), eq(2026), eq(6), any());
    }
}
