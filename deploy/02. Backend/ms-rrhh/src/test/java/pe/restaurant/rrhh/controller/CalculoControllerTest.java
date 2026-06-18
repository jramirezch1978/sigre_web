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
import org.springframework.data.domain.PageImpl;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import pe.restaurant.common.exception.GlobalExceptionHandler;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.CalculoProcesarRequest;
import pe.restaurant.rrhh.dto.response.CalculoResponse;
import pe.restaurant.rrhh.service.CalculoService;

import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - CalculoController")
class CalculoControllerTest {

    @Mock private CalculoService service;

    @InjectMocks private CalculoController controller;

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
    @DisplayName("GET /api/rrhh/calculos -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        var page = new PageImpl<>(List.of(RrhhTestFixtures.calculoResponse(1L)));
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/calculos")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray());
    }

    @Test
    @DisplayName("GET /api/rrhh/calculos con filtros -> aplica filtros")
    void listar_conFiltros_aplicaFiltros() throws Exception {
        var page = new PageImpl<>(List.of(RrhhTestFixtures.calculoResponse(1L)));
        when(service.listar(eq(2026), eq(6), eq(1L), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/calculos")
                        .param("anio", "2026")
                        .param("mes", "6")
                        .param("tipoPlanillaId", "1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/calculos/{id} -> retorna detalle")
    void obtener_idExistente_retornaDetalle() throws Exception {
        when(service.obtenerDetalle(1L)).thenReturn(RrhhTestFixtures.calculoDetalleResponse(1L));

        mockMvc.perform(get("/api/rrhh/calculos/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("POST /api/rrhh/calculos/procesar -> procesa planilla")
    void procesar_datosValidos_procesa() throws Exception {
        CalculoProcesarRequest request = RrhhTestFixtures.calculoProcesarRequest();
        when(service.procesar(2026, 6, 1L)).thenReturn(RrhhTestFixtures.calculoDetalleResponse(1L));

        mockMvc.perform(post("/api/rrhh/calculos/procesar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("DELETE /api/rrhh/calculos/{id} -> elimina cálculo")
    void eliminar_idExistente_elimina() throws Exception {
        doNothing().when(service).eliminar(1L);

        mockMvc.perform(delete("/api/rrhh/calculos/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true));
    }

}
