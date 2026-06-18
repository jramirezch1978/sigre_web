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
import pe.restaurant.activos.dto.AfValuacionRequest;
import pe.restaurant.activos.dto.AfValuacionResponse;
import pe.restaurant.activos.entity.AfValuacion;
import pe.restaurant.activos.mapper.AfValuacionMapper;
import pe.restaurant.activos.service.AfValuacionService;
import pe.restaurant.activos.support.ControllerMockMvcFactory;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class AfValuacionControllerTest {

    @Mock
    private AfValuacionService service;
    @Mock
    private AfValuacionMapper mapper;
    @InjectMocks
    private AfValuacionController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private AfValuacion entity;
    private AfValuacionResponse response;
    private AfValuacionRequest request;

    @BeforeEach
    void setUp() {
        mockMvc = ControllerMockMvcFactory.standalone(controller, true);
        objectMapper = ControllerMockMvcFactory.objectMapper();

        entity = new AfValuacion();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setFechaValuacion(LocalDate.now());
        entity.setValorAnterior(new BigDecimal("10000.00"));
        entity.setValorNuevo(new BigDecimal("12000.00"));
        entity.setMetodoValuacion("MERCADO");
        entity.setResponsableId(1L);
        entity.setObservaciones("Revaluación por mercado");
        entity.setFechaAprobacion(null);
        entity.setAprobadorId(null);

        response = new AfValuacionResponse();
        response.setId(1L);
        response.setAfMaestroId(1L);
        response.setFechaValuacion(LocalDate.now());
        response.setValorAnterior(new BigDecimal("10000.00"));
        response.setValorNuevo(new BigDecimal("12000.00"));
        response.setMetodoValuacion("MERCADO");
        response.setResponsableId(1L);
        response.setObservaciones("Revaluación por mercado");
        response.setFechaAprobacion(null);
        response.setAprobadorId(null);

        request = new AfValuacionRequest();
        request.setAfMaestroId(1L);
        request.setFechaValuacion(LocalDate.now());
        request.setValorAnterior(new BigDecimal("10000.00"));
        request.setValorNuevo(new BigDecimal("12000.00"));
        request.setMetodoValuacion("MERCADO");
        request.setResponsableId(1L);
        request.setObservaciones("Revaluación por mercado");
        request.setFechaAprobacion(null);
        request.setAprobadorId(null);
    }

    @Test
    void listarReturnsPageData() throws Exception {
        when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/valuaciones")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[0].metodoValuacion").value("MERCADO"));
    }

    @Test
    void obtenerPorIdReturnsEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(get("/api/activos/valuaciones/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.metodoValuacion").value("MERCADO"))
                .andExpect(jsonPath("$.data.afMaestroId").value(1));
    }

    @Test
    void crearReturnsCreatedEntity() throws Exception {
        when(mapper.toEntity(any(AfValuacionRequest.class))).thenReturn(entity);
        when(service.create(any(AfValuacion.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/valuaciones")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.metodoValuacion").value("MERCADO"))
                .andExpect(jsonPath("$.message").value("Registro creado"));
    }

    @Test
    void actualizarReturnsUpdatedEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        doNothing().when(mapper).updateEntity(any(AfValuacionRequest.class), any(AfValuacion.class));
        when(service.update(eq(1L), any(AfValuacion.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(put("/api/activos/valuaciones/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.metodoValuacion").value("MERCADO"))
                .andExpect(jsonPath("$.message").value("Registro actualizado"));
    }

    @Test
    void eliminarReturnsTrue() throws Exception {
        doNothing().when(service).delete(1L);

        mockMvc.perform(delete("/api/activos/valuaciones/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true))
                .andExpect(jsonPath("$.message").value("Registro eliminado"));
    }

    @Test
    void listarPorActivoReturnsList() throws Exception {
        when(service.findByActivo(1L)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/valuaciones/activo/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].metodoValuacion").value("MERCADO"))
                .andExpect(jsonPath("$.data[0].afMaestroId").value(1));
    }

    @Test
    void listarPorPeriodoReturnsList() throws Exception {
        LocalDate fechaInicio = LocalDate.of(2024, 1, 1);
        LocalDate fechaFin = LocalDate.of(2024, 12, 31);

        when(service.findByPeriodo(eq(fechaInicio), eq(fechaFin))).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/valuaciones/periodo")
                        .param("fechaInicio", fechaInicio.toString())
                        .param("fechaFin", fechaFin.toString()))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].metodoValuacion").value("MERCADO"))
                .andExpect(jsonPath("$.data[0].fechaValuacion").exists());
    }

    @Test
    void aprobarReturnsApprovedEntity() throws Exception {
        AfValuacion aprobada = new AfValuacion();
        aprobada.setId(1L);
        aprobada.setAfMaestroId(1L);
        aprobada.setFechaValuacion(LocalDate.now());
        aprobada.setValorAnterior(new BigDecimal("10000.00"));
        aprobada.setValorNuevo(new BigDecimal("12000.00"));
        aprobada.setMetodoValuacion("MERCADO");
        aprobada.setResponsableId(1L);
        aprobada.setObservaciones("Revaluación por mercado");
        aprobada.setFechaAprobacion(LocalDate.now());
        aprobada.setAprobadorId(2L);

        AfValuacionResponse aprobadaResponse = new AfValuacionResponse();
        aprobadaResponse.setId(1L);
        aprobadaResponse.setAfMaestroId(1L);
        aprobadaResponse.setFechaValuacion(LocalDate.now());
        aprobadaResponse.setValorAnterior(new BigDecimal("10000.00"));
        aprobadaResponse.setValorNuevo(new BigDecimal("12000.00"));
        aprobadaResponse.setMetodoValuacion("MERCADO");
        aprobadaResponse.setResponsableId(1L);
        aprobadaResponse.setObservaciones("Revaluación por mercado");
        aprobadaResponse.setFechaAprobacion(LocalDate.now());
        aprobadaResponse.setAprobadorId(2L);

        when(service.aprobar(1L)).thenReturn(aprobada);
        when(mapper.toResponse(aprobada)).thenReturn(aprobadaResponse);

        mockMvc.perform(patch("/api/activos/valuaciones/1/aprobar"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.metodoValuacion").value("MERCADO"))
                .andExpect(jsonPath("$.data.fechaAprobacion").exists())
                .andExpect(jsonPath("$.data.aprobadorId").value(2))
                .andExpect(jsonPath("$.message").value("Valuación aprobada — base depreciable actualizada"));
    }
}
