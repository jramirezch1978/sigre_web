package pe.restaurant.activos.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.activos.dto.AfAdaptacionRequest;
import pe.restaurant.activos.dto.AfAdaptacionResponse;
import pe.restaurant.activos.entity.AfAdaptacion;
import pe.restaurant.activos.mapper.AfAdaptacionMapper;
import pe.restaurant.activos.service.AfAdaptacionService;
import pe.restaurant.activos.support.ControllerMockMvcFactory;
import pe.restaurant.activos.util.ActivosFlagEstado;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class AfAdaptacionControllerTest {

    @Mock
    private AfAdaptacionService service;
    @Mock
    private AfAdaptacionMapper mapper;
    @InjectMocks
    private AfAdaptacionController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private AfAdaptacion entity;
    private AfAdaptacionResponse response;
    private AfAdaptacionRequest request;

    @BeforeEach
    void setUp() {
        mockMvc = ControllerMockMvcFactory.standalone(controller, true);
        objectMapper = ControllerMockMvcFactory.objectMapper();

        entity = new AfAdaptacion();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setFecha(LocalDate.now());
        entity.setDescripcion("Instalación de aire acondicionado");
        entity.setMontoTotal(new BigDecimal("2500.00"));
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);

        response = new AfAdaptacionResponse();
        response.setId(1L);
        response.setAfMaestroId(1L);
        response.setFecha(LocalDate.now());
        response.setDescripcion("Instalación de aire acondicionado");
        response.setMontoTotal(new BigDecimal("2500.00"));
        response.setFlagEstado("1");

        request = new AfAdaptacionRequest();
        request.setAfMaestroId(1L);
        request.setFecha(LocalDate.now());
        request.setDescripcion("Instalación de aire acondicionado");
        request.setMontoTotal(new BigDecimal("2500.00"));
    }

    @Test
    void listarReturnsPageData() throws Exception {
        when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/adaptaciones")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[0].descripcion").value("Instalación de aire acondicionado"));
    }

    @Test
    void obtenerPorIdReturnsEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(get("/api/activos/adaptaciones/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.descripcion").value("Instalación de aire acondicionado"))
                .andExpect(jsonPath("$.data.afMaestroId").value(1));
    }

    @Test
    void crearReturnsCreatedEntity() throws Exception {
        when(mapper.toEntity(any(AfAdaptacionRequest.class))).thenReturn(entity);
        when(service.create(any(AfAdaptacion.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/adaptaciones")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.descripcion").value("Instalación de aire acondicionado"))
                .andExpect(jsonPath("$.message").value("Registro creado"));
    }

    @Test
    void actualizarReturnsUpdatedEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        doNothing().when(mapper).updateEntity(any(AfAdaptacionRequest.class), any(AfAdaptacion.class));
        when(service.update(eq(1L), any(AfAdaptacion.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(put("/api/activos/adaptaciones/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.descripcion").value("Instalación de aire acondicionado"))
                .andExpect(jsonPath("$.message").value("Registro actualizado"));
    }

    @Test
    void eliminarReturnsTrue() throws Exception {
        doNothing().when(service).delete(1L);

        mockMvc.perform(delete("/api/activos/adaptaciones/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true))
                .andExpect(jsonPath("$.message").value("Registro eliminado"));
    }

    @Test
    void listarPorActivoReturnsList() throws Exception {
        when(service.findByActivo(1L)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/adaptaciones/activo/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].descripcion").value("Instalación de aire acondicionado"))
                .andExpect(jsonPath("$.data[0].afMaestroId").value(1));
    }

    @Test
    void listarPorRangoFechasReturnsList() throws Exception {
        LocalDate fechaInicio = LocalDate.of(2024, 1, 1);
        LocalDate fechaFin = LocalDate.of(2024, 12, 31);

        when(service.findByFechaRange(eq(fechaInicio), eq(fechaFin))).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/adaptaciones/rango-fechas")
                        .param("fechaInicio", fechaInicio.toString())
                        .param("fechaFin", fechaFin.toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].descripcion").value("Instalación de aire acondicionado"))
                .andExpect(jsonPath("$.data[0].fecha").exists());
    }

    @Test
    void capitalizarReturnsCapitalizedEntity() throws Exception {
        AfAdaptacion capitalizada = new AfAdaptacion();
        capitalizada.setId(1L);
        capitalizada.setAfMaestroId(1L);
        capitalizada.setFecha(LocalDate.now());
        capitalizada.setDescripcion("Instalación de aire acondicionado");
        capitalizada.setMontoTotal(new BigDecimal("2500.00"));
        capitalizada.setFlagEstado("1");

        AfAdaptacionResponse capitalizadaResponse = new AfAdaptacionResponse();
        capitalizadaResponse.setId(1L);
        capitalizadaResponse.setAfMaestroId(1L);
        capitalizadaResponse.setFecha(LocalDate.now());
        capitalizadaResponse.setDescripcion("Instalación de aire acondicionado");
        capitalizadaResponse.setMontoTotal(new BigDecimal("2500.00"));
        capitalizadaResponse.setFlagEstado("1");

        when(service.capitalizar(1L)).thenReturn(capitalizada);
        when(mapper.toResponse(capitalizada)).thenReturn(capitalizadaResponse);

        mockMvc.perform(patch("/api/activos/adaptaciones/1/capitalizar"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.descripcion").value("Instalación de aire acondicionado"))
                .andExpect(jsonPath("$.message").value("Adaptación capitalizada — base depreciable actualizada"));
    }

    @Test
    void obtenerTotalCapitalizadoReturnsBigDecimal() throws Exception {
        BigDecimal totalCapitalizado = new BigDecimal("7500.00");
        when(service.obtenerTotalCapitalizado(1L)).thenReturn(totalCapitalizado);

        mockMvc.perform(get("/api/activos/adaptaciones/activo/1/total-capitalizado"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(7500.00));
    }
}
