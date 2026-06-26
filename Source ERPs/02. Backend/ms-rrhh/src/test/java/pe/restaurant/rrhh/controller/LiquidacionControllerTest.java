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
import pe.restaurant.rrhh.dto.request.LiquidacionCalcularRequest;
import pe.restaurant.rrhh.dto.response.LiquidacionResponse;
import pe.restaurant.rrhh.entity.Liquidacion;
import pe.restaurant.rrhh.mapper.LiquidacionMapper;
import pe.restaurant.rrhh.service.LiquidacionService;

import java.time.LocalDate;
import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - LiquidacionController")
class LiquidacionControllerTest {

    @Mock
    private LiquidacionService service;

    @Mock
    private LiquidacionMapper mapper;

    @InjectMocks
    private LiquidacionController controller;

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
    @DisplayName("POST /api/rrhh/liquidaciones/calcular -> calcula liquidación")
    void calcular_retornaLiquidacion() throws Exception {
        LiquidacionCalcularRequest request = new LiquidacionCalcularRequest();
        request.setTrabajadorId(1L);
        request.setFechaCese(LocalDate.of(2026, 1, 31));

        Liquidacion liquidacion = RrhhTestFixtures.liquidacion(1L);
        when(service.calcular(1L, LocalDate.of(2026, 1, 31))).thenReturn(liquidacion);
        when(mapper.toResponse(liquidacion)).thenReturn(RrhhTestFixtures.liquidacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/liquidaciones/calcular")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).calcular(1L, LocalDate.of(2026, 1, 31));
    }

    @Test
    @DisplayName("GET /api/rrhh/liquidaciones -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Liquidacion entity = RrhhTestFixtures.liquidacion(1L);
        Page<Liquidacion> page = new PageImpl<>(List.of(entity));
        when(service.listar(any(), any(), any(), any(), any())).thenReturn(page);
        when(mapper.toResponse(entity)).thenReturn(RrhhTestFixtures.liquidacionResponse(1L));

        mockMvc.perform(get("/api/rrhh/liquidaciones")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)))
                .andExpect(jsonPath("$.data.content[0].id").value(1));

        verify(service).listar(any(), any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/liquidaciones con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() throws Exception {
        when(service.listar(eq(1L), eq("1"), any(), any(), any()))
                .thenReturn(new PageImpl<>(List.of()));

        mockMvc.perform(get("/api/rrhh/liquidaciones")
                        .param("trabajadorId", "1")
                        .param("flagEstado", "1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk());

        verify(service).listar(eq(1L), eq("1"), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/liquidaciones/{id} -> retorna detalle")
    void obtener_idExistente_retornaDetalle() throws Exception {
        Liquidacion entity = RrhhTestFixtures.liquidacion(1L);
        when(service.obtenerPorId(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(RrhhTestFixtures.liquidacionResponse(1L));

        mockMvc.perform(get("/api/rrhh/liquidaciones/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/liquidaciones/{id}/aprobar -> aprueba liquidación")
    void aprobar_apruebaLiquidacion() throws Exception {
        Liquidacion liquidacion = RrhhTestFixtures.liquidacion(1L);
        liquidacion.setFlagEstado("2");
        when(service.aprobar(1L)).thenReturn(liquidacion);
        when(mapper.toResponse(liquidacion)).thenReturn(RrhhTestFixtures.liquidacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/liquidaciones/{id}/aprobar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).aprobar(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/liquidaciones/{id}/anular -> anula liquidación")
    void anular_anulaLiquidacion() throws Exception {
        Liquidacion liquidacion = RrhhTestFixtures.liquidacion(1L);
        liquidacion.setFlagEstado("0");
        when(service.anular(1L)).thenReturn(liquidacion);
        when(mapper.toResponse(liquidacion)).thenReturn(RrhhTestFixtures.liquidacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/liquidaciones/{id}/anular", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).anular(1L);
    }
}
