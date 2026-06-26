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
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.activos.dto.AfPolizaActivoRequest;
import pe.restaurant.activos.dto.AfPolizaActivoResponse;
import pe.restaurant.activos.entity.AfPolizaActivo;
import pe.restaurant.activos.mapper.AfPolizaActivoMapper;
import pe.restaurant.activos.service.AfPolizaActivoService;
import pe.restaurant.activos.support.ControllerMockMvcFactory;
import pe.restaurant.activos.util.ActivosFlagEstado;

import java.math.BigDecimal;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class AfPolizaActivoControllerTest {

    @Mock
    private AfPolizaActivoService service;
    @Mock
    private AfPolizaActivoMapper mapper;
    @InjectMocks
    private AfPolizaActivoController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private AfPolizaActivo entity;
    private AfPolizaActivoResponse response;
    private AfPolizaActivoRequest request;

    @BeforeEach
    void setUp() {
        mockMvc = ControllerMockMvcFactory.standalone(controller, true);
        objectMapper = ControllerMockMvcFactory.objectMapper();

        entity = new AfPolizaActivo();
        entity.setId(1L);
        entity.setAfPolizaSeguroId(1L);
        entity.setAfMaestroId(1L);
        entity.setValorAsegurado(new BigDecimal("50000.00"));
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);

        response = new AfPolizaActivoResponse();
        response.setId(1L);
        response.setAfPolizaSeguroId(1L);
        response.setAfMaestroId(1L);
        response.setValorAsegurado(new BigDecimal("50000.00"));
        response.setFlagEstado(ActivosFlagEstado.ACTIVO);

        request = new AfPolizaActivoRequest();
        request.setAfPolizaSeguroId(1L);
        request.setAfMaestroId(1L);
        request.setValorAsegurado(new BigDecimal("50000.00"));
    }

    @Test
    void listarReturnsPageData() throws Exception {
        when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/polizas-activos")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[0].valorAsegurado").value(50000.00))
                .andExpect(jsonPath("$.data.content[0].afMaestroId").value(1));
    }

    @Test
    void obtenerPorIdReturnsEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(get("/api/activos/polizas-activos/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.valorAsegurado").value(50000.00))
                .andExpect(jsonPath("$.data.afPolizaSeguroId").value(1));
    }

    @Test
    void crearReturnsCreatedEntity() throws Exception {
        when(mapper.toEntity(any(AfPolizaActivoRequest.class))).thenReturn(entity);
        when(service.create(any(AfPolizaActivo.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/polizas-activos")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.valorAsegurado").value(50000.00))
                .andExpect(jsonPath("$.data.afMaestroId").value(1))
                .andExpect(jsonPath("$.message").value("Registro creado"));
    }

    @Test
    void actualizarReturnsUpdatedEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        doNothing().when(mapper).updateEntity(any(AfPolizaActivoRequest.class), any(AfPolizaActivo.class));
        when(service.update(eq(1L), any(AfPolizaActivo.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(put("/api/activos/polizas-activos/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.valorAsegurado").value(50000.00))
                .andExpect(jsonPath("$.data.afMaestroId").value(1))
                .andExpect(jsonPath("$.message").value("Registro actualizado"));
    }

    @Test
    void eliminarReturnsTrue() throws Exception {
        doNothing().when(service).delete(1L);

        mockMvc.perform(delete("/api/activos/polizas-activos/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true))
                .andExpect(jsonPath("$.message").value("Registro eliminado"));
    }

    @Test
    void listarPorPolizaReturnsList() throws Exception {
        when(service.findByPoliza(1L)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/polizas-activos/poliza/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].valorAsegurado").value(50000.00))
                .andExpect(jsonPath("$.data[0].afPolizaSeguroId").value(1));
    }

    @Test
    void listarPorActivoReturnsList() throws Exception {
        when(service.findByActivo(1L)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/polizas-activos/activo/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].valorAsegurado").value(50000.00))
                .andExpect(jsonPath("$.data[0].afMaestroId").value(1));
    }

    @Test
    void crearWithInvalidDataReturnsBadRequest() throws Exception {
        AfPolizaActivoRequest invalidRequest = new AfPolizaActivoRequest();
        invalidRequest.setAfPolizaSeguroId(null);
        invalidRequest.setAfMaestroId(null);
        invalidRequest.setValorAsegurado(null);

        mockMvc.perform(post("/api/activos/polizas-activos")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void crearWithNegativeValueReturnsBadRequest() throws Exception {
        AfPolizaActivoRequest invalidRequest = new AfPolizaActivoRequest();
        invalidRequest.setAfPolizaSeguroId(1L);
        invalidRequest.setAfMaestroId(1L);
        invalidRequest.setValorAsegurado(new BigDecimal("-1000.00"));

        mockMvc.perform(post("/api/activos/polizas-activos")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void listarReturnsEmptyPageData() throws Exception {
        when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of()));
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/polizas-activos")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content").isEmpty());
    }

    @Test
    void listarPorPolizaWithEmptyListReturnsEmptyArray() throws Exception {
        when(service.findByPoliza(999L)).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/polizas-activos/poliza/999"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data").isEmpty());
    }

    @Test
    void listarPorActivoWithEmptyListReturnsEmptyArray() throws Exception {
        when(service.findByActivo(999L)).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/polizas-activos/activo/999"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data").isEmpty());
    }

    @Test
    void crearWithZeroValueReturnsSuccess() throws Exception {
        AfPolizaActivoRequest requestWithZero = new AfPolizaActivoRequest();
        requestWithZero.setAfPolizaSeguroId(1L);
        requestWithZero.setAfMaestroId(1L);
        requestWithZero.setValorAsegurado(BigDecimal.ZERO);

        when(mapper.toEntity(any(AfPolizaActivoRequest.class))).thenReturn(entity);
        when(service.create(any(AfPolizaActivo.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/polizas-activos")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(requestWithZero)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.valorAsegurado").value(50000.00));
    }

    @Test
    void actualizarWithInvalidDataReturnsBadRequest() throws Exception {
        AfPolizaActivoRequest invalidRequest = new AfPolizaActivoRequest();
        invalidRequest.setAfPolizaSeguroId(null);
        invalidRequest.setAfMaestroId(null);
        invalidRequest.setValorAsegurado(null);

        mockMvc.perform(put("/api/activos/polizas-activos/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void obtenerPorIdNotFoundThrowsException() throws Exception {
        when(service.findById(999L)).thenThrow(new RuntimeException("Entity not found"));

        try {
            mockMvc.perform(get("/api/activos/polizas-activos/999"));
        } catch (Exception e) {
            assert e.getCause() instanceof RuntimeException;
            assert e.getCause().getMessage().equals("Entity not found");
        }
    }
}
