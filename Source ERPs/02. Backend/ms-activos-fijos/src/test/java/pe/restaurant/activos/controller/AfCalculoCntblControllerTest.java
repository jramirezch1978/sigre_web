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
import pe.restaurant.activos.dto.AfCalculoCntblRequest;
import pe.restaurant.activos.dto.AfCalculoCntblResponse;
import pe.restaurant.activos.dto.DepreciacionMensualRequest;
import pe.restaurant.activos.entity.AfCalculoCntbl;
import pe.restaurant.activos.mapper.AfCalculoCntblMapper;
import pe.restaurant.activos.service.AfCalculoCntblService;
import pe.restaurant.activos.support.ControllerMockMvcFactory;
import pe.restaurant.activos.util.ActivosFlagEstado;

import java.math.BigDecimal;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class AfCalculoCntblControllerTest {

    @Mock
    private AfCalculoCntblService service;
    @Mock
    private AfCalculoCntblMapper mapper;
    @InjectMocks
    private AfCalculoCntblController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private AfCalculoCntbl entity;
    private AfCalculoCntblResponse response;
    private AfCalculoCntblRequest request;
    private DepreciacionMensualRequest mensualRequest;

    @BeforeEach
    void setUp() {
        mockMvc = ControllerMockMvcFactory.standalone(controller);
        objectMapper = ControllerMockMvcFactory.objectMapper();

        entity = new AfCalculoCntbl();
        entity.setId(1L);
        entity.setAfMaestroId(1L);
        entity.setAnio(2024);
        entity.setMes(6);
        entity.setDepreciacionPeriodo(new BigDecimal("250.00"));
        entity.setDepreciacionAcumulada(new BigDecimal("1500.00"));
        entity.setValorNeto(new BigDecimal("8500.00"));
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);

        response = new AfCalculoCntblResponse();
        response.setId(1L);
        response.setAfMaestroId(1L);
        response.setAnio(2024);
        response.setMes(6);
        response.setDepreciacionPeriodo(new BigDecimal("250.00"));
        response.setDepreciacionAcumulada(new BigDecimal("1500.00"));
        response.setValorNeto(new BigDecimal("8500.00"));
        response.setFlagEstado("1");

        request = new AfCalculoCntblRequest();
        request.setAfMaestroId(1L);
        request.setAnio(2024);
        request.setMes(6);
        request.setDepreciacionPeriodo(new BigDecimal("250.00"));
        request.setDepreciacionAcumulada(new BigDecimal("1500.00"));
        request.setValorNeto(new BigDecimal("8500.00"));

        mensualRequest = new DepreciacionMensualRequest();
        mensualRequest.setAnio(2024);
        mensualRequest.setMes(6);
    }

    @Test
    void obtenerPorIdReturnsEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(get("/api/activos/depreciacion/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.anio").value(2024))
                .andExpect(jsonPath("$.data.mes").value(6))
                .andExpect(jsonPath("$.data.afMaestroId").value(1));
    }

    @Test
    void obtenerHistorialPorActivoReturnsList() throws Exception {
        when(service.obtenerHistorialPorActivo(1L)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/depreciacion/maestro/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].anio").value(2024))
                .andExpect(jsonPath("$.data[0].mes").value(6))
                .andExpect(jsonPath("$.data[0].afMaestroId").value(1));
    }

    @Test
    void obtenerPorPeriodoReturnsList() throws Exception {
        when(service.obtenerPorPeriodo(2024, 6)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/depreciacion/periodo/2024/6"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].anio").value(2024))
                .andExpect(jsonPath("$.data[0].mes").value(6))
                .andExpect(jsonPath("$.data[0].depreciacionPeriodo").value(250.00));
    }

    @Test
    void calcularDepreciacionMensualReturnsCreatedEntity() throws Exception {
        when(service.calcularDepreciacionMensual(eq(1L), eq(2024), eq(6), nullable(Integer.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/depreciacion/calcular-mensual")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(mensualRequest))
                        .param("afMaestroId", "1"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.anio").value(2024))
                .andExpect(jsonPath("$.data.mes").value(6))
                .andExpect(jsonPath("$.data.depreciacionPeriodo").value(250.00))
                .andExpect(jsonPath("$.message").value("Depreciación calculada exitosamente"));
    }

    @Test
    void calcularDepreciacionMasivaReturnsCreatedEntity() throws Exception {
        when(service.calcularDepreciacionMasiva(2024, 6)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(post("/api/activos/depreciacion/calcular-masivo")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(mensualRequest)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].anio").value(2024))
                .andExpect(jsonPath("$.data[0].mes").value(6))
                .andExpect(jsonPath("$.message").value("Depreciación masiva calculada: 1 activos procesados"));
    }

    @Test
    void generarReporteReturnsList() throws Exception {
        when(service.obtenerPorPeriodo(2024, 6)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/depreciacion/reporte/2024/6"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].anio").value(2024))
                .andExpect(jsonPath("$.data[0].mes").value(6))
                .andExpect(jsonPath("$.data[0].valorNeto").value(8500.00));
    }

    @Test
    void actualizarReturnsUpdatedEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        doNothing().when(mapper).updateEntity(any(AfCalculoCntblRequest.class), any(AfCalculoCntbl.class));
        when(service.update(eq(1L), any(AfCalculoCntbl.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(put("/api/activos/depreciacion/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.anio").value(2024))
                .andExpect(jsonPath("$.data.mes").value(6))
                .andExpect(jsonPath("$.data.valorNeto").value(8500.00))
                .andExpect(jsonPath("$.message").value("Registro actualizado"));
    }

    @Test
    void eliminarReturnsTrue() throws Exception {
        doNothing().when(service).delete(1L);

        mockMvc.perform(delete("/api/activos/depreciacion/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true))
                .andExpect(jsonPath("$.message").value("Registro eliminado"));
    }

    @Test
    void calcularDepreciacionMensualWithInvalidDataReturnsBadRequest() throws Exception {
        DepreciacionMensualRequest invalidRequest = new DepreciacionMensualRequest();
        invalidRequest.setAnio(null);
        invalidRequest.setMes(null);

        mockMvc.perform(post("/api/activos/depreciacion/calcular-mensual")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest))
                        .param("afMaestroId", "1"))
                .andExpect(status().isBadRequest());
    }

    @Test
    void calcularDepreciacionMensualWithMissingParameterReturnsBadRequest() throws Exception {
        mockMvc.perform(post("/api/activos/depreciacion/calcular-mensual")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(mensualRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void calcularDepreciacionMasivaWithEmptyListReturnsEmptyArray() throws Exception {
        when(service.calcularDepreciacionMasiva(2024, 6)).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(post("/api/activos/depreciacion/calcular-masivo")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(mensualRequest)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data").isEmpty())
                .andExpect(jsonPath("$.message").value("Depreciación masiva calculada: 0 activos procesados"));
    }

    @Test
    void obtenerHistorialPorActivoWithEmptyListReturnsEmptyArray() throws Exception {
        when(service.obtenerHistorialPorActivo(999L)).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/depreciacion/maestro/999"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data").isEmpty());
    }

    @Test
    void obtenerPorPeriodoWithEmptyListReturnsEmptyArray() throws Exception {
        when(service.obtenerPorPeriodo(2025, 1)).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/depreciacion/periodo/2025/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data").isEmpty());
    }

    @Test
    void actualizarWithInvalidDataReturnsBadRequest() throws Exception {
        AfCalculoCntblRequest invalidRequest = new AfCalculoCntblRequest();
        invalidRequest.setAfMaestroId(null);
        invalidRequest.setAnio(null);
        invalidRequest.setMes(null);
        invalidRequest.setDepreciacionPeriodo(null);
        invalidRequest.setDepreciacionAcumulada(null);
        invalidRequest.setValorNeto(null);

        mockMvc.perform(put("/api/activos/depreciacion/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void calcularDepreciacionMasivaWithInvalidYearReturnsBadRequest() throws Exception {
        DepreciacionMensualRequest invalidRequest = new DepreciacionMensualRequest();
        invalidRequest.setAnio(1999); // Below minimum
        invalidRequest.setMes(6);

        mockMvc.perform(post("/api/activos/depreciacion/calcular-masivo")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void obtenerPorIdNotFoundThrowsException() throws Exception {
        when(service.findById(999L)).thenThrow(new RuntimeException("Entity not found"));

        try {
            mockMvc.perform(get("/api/activos/depreciacion/999"));
        } catch (Exception e) {
            assert e.getCause() instanceof RuntimeException;
            assert e.getCause().getMessage().equals("Entity not found");
        }
    }
}
