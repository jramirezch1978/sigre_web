package pe.restaurant.activos.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.activos.dto.AfAdaptacionDetRequest;
import pe.restaurant.activos.dto.AfAdaptacionDetResponse;
import pe.restaurant.activos.entity.AfAdaptacionDet;
import pe.restaurant.activos.mapper.AfAdaptacionDetMapper;
import pe.restaurant.activos.service.AfAdaptacionDetService;
import pe.restaurant.activos.support.ControllerMockMvcFactory;
import pe.restaurant.activos.util.ActivosFlagEstado;

import java.math.BigDecimal;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class AfAdaptacionDetControllerTest {

    @Mock
    private AfAdaptacionDetService service;
    @Mock
    private AfAdaptacionDetMapper mapper;
    @InjectMocks
    private AfAdaptacionDetController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private AfAdaptacionDet entity;
    private AfAdaptacionDetResponse response;
    private AfAdaptacionDetRequest request;

    @BeforeEach
    void setUp() {
        mockMvc = ControllerMockMvcFactory.standalone(controller);
        objectMapper = ControllerMockMvcFactory.objectMapper();

        entity = new AfAdaptacionDet();
        entity.setId(1L);
        entity.setAfAdaptacionId(1L);
        entity.setDescripcion("Instalación de sistema de aire acondicionado");
        entity.setMonto(new BigDecimal("1500.00"));
        entity.setUnidadMedidaId(1L);
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);

        response = new AfAdaptacionDetResponse();
        response.setId(1L);
        response.setAfAdaptacionId(1L);
        response.setDescripcion("Instalación de sistema de aire acondicionado");
        response.setMonto(new BigDecimal("1500.00"));
        response.setUnidadMedidaId(1L);
        response.setFlagEstado("1");

        request = new AfAdaptacionDetRequest();
        request.setAfAdaptacionId(1L);
        request.setDescripcion("Instalación de sistema de aire acondicionado");
        request.setMonto(new BigDecimal("1500.00"));
        request.setUnidadMedidaId(1L);
    }

    @Test
    void obtenerPorIdReturnsEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(get("/api/activos/adaptaciones-detalles/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.descripcion").value("Instalación de sistema de aire acondicionado"))
                .andExpect(jsonPath("$.data.monto").value(1500.00))
                .andExpect(jsonPath("$.data.afAdaptacionId").value(1));
    }

    @Test
    void crearReturnsCreatedEntity() throws Exception {
        when(mapper.toEntity(any(AfAdaptacionDetRequest.class))).thenReturn(entity);
        when(service.create(any(AfAdaptacionDet.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/adaptaciones-detalles")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.descripcion").value("Instalación de sistema de aire acondicionado"))
                .andExpect(jsonPath("$.data.monto").value(1500.00))
                .andExpect(jsonPath("$.message").value("Registro creado"));
    }

    @Test
    void actualizarReturnsUpdatedEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        doNothing().when(mapper).updateEntity(any(AfAdaptacionDetRequest.class), any(AfAdaptacionDet.class));
        when(service.update(eq(1L), any(AfAdaptacionDet.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(put("/api/activos/adaptaciones-detalles/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.descripcion").value("Instalación de sistema de aire acondicionado"))
                .andExpect(jsonPath("$.data.monto").value(1500.00))
                .andExpect(jsonPath("$.message").value("Registro actualizado"));
    }

    @Test
    void eliminarReturnsTrue() throws Exception {
        doNothing().when(service).delete(1L);

        mockMvc.perform(delete("/api/activos/adaptaciones-detalles/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true))
                .andExpect(jsonPath("$.message").value("Registro eliminado"));
    }

    @Test
    void listarPorAdaptacionReturnsList() throws Exception {
        when(service.findByAdaptacion(1L)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/adaptaciones-detalles/adaptacion/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].descripcion").value("Instalación de sistema de aire acondicionado"))
                .andExpect(jsonPath("$.data[0].afAdaptacionId").value(1));
    }

    @Test
    void calcularTotalReturnsBigDecimal() throws Exception {
        BigDecimal total = new BigDecimal("3500.00");
        when(service.calcularTotal(1L)).thenReturn(total);

        mockMvc.perform(get("/api/activos/adaptaciones-detalles/adaptacion/1/total"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(3500.00));
    }

    @Test
    void crearWithInvalidDataReturnsBadRequest() throws Exception {
        AfAdaptacionDetRequest invalidRequest = new AfAdaptacionDetRequest();
        invalidRequest.setAfAdaptacionId(null);
        invalidRequest.setDescripcion("");
        invalidRequest.setMonto(null);

        mockMvc.perform(post("/api/activos/adaptaciones-detalles")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void crearWithZeroMontoReturnsBadRequest() throws Exception {
        AfAdaptacionDetRequest invalidRequest = new AfAdaptacionDetRequest();
        invalidRequest.setAfAdaptacionId(1L);
        invalidRequest.setDescripcion("Test");
        invalidRequest.setMonto(BigDecimal.ZERO);

        mockMvc.perform(post("/api/activos/adaptaciones-detalles")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void listarPorAdaptacionWithEmptyListReturnsEmptyArray() throws Exception {
        when(service.findByAdaptacion(999L)).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/adaptaciones-detalles/adaptacion/999"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data").isEmpty());
    }

    @Test
    void calcularTotalWithZeroReturnsZero() throws Exception {
        when(service.calcularTotal(999L)).thenReturn(BigDecimal.ZERO);

        mockMvc.perform(get("/api/activos/adaptaciones-detalles/adaptacion/999/total"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(0.0));
    }

    @Test
    void crearWithNullUnidadMedidaReturnsSuccess() throws Exception {
        AfAdaptacionDetRequest requestWithNullUnidad = new AfAdaptacionDetRequest();
        requestWithNullUnidad.setAfAdaptacionId(1L);
        requestWithNullUnidad.setDescripcion("Instalación de sistema");
        requestWithNullUnidad.setMonto(new BigDecimal("1500.00"));
        requestWithNullUnidad.setUnidadMedidaId(null);

        when(mapper.toEntity(any(AfAdaptacionDetRequest.class))).thenReturn(entity);
        when(service.create(any(AfAdaptacionDet.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/adaptaciones-detalles")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(requestWithNullUnidad)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.descripcion").value("Instalación de sistema de aire acondicionado"));
    }

    @Test
    void obtenerPorIdNotFoundThrowsException() throws Exception {
        when(service.findById(999L)).thenThrow(new RuntimeException("Entity not found"));

        try {
            mockMvc.perform(get("/api/activos/adaptaciones-detalles/999"));
        } catch (Exception e) {
            assert e.getCause() instanceof RuntimeException;
            assert e.getCause().getMessage().equals("Entity not found");
        }
    }
}
