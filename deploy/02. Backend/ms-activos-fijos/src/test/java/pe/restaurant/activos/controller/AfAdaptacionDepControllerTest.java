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
import pe.restaurant.activos.dto.AfAdaptacionDepRequest;
import pe.restaurant.activos.dto.AfAdaptacionDepResponse;
import pe.restaurant.activos.entity.AfAdaptacionDep;
import pe.restaurant.activos.mapper.AfAdaptacionDepMapper;
import pe.restaurant.activos.service.AfAdaptacionDepService;
import pe.restaurant.activos.support.ControllerMockMvcFactory;
import pe.restaurant.activos.util.ActivosFlagEstado;

import java.math.BigDecimal;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class AfAdaptacionDepControllerTest {

    @Mock
    private AfAdaptacionDepService service;
    @Mock
    private AfAdaptacionDepMapper mapper;
    @InjectMocks
    private AfAdaptacionDepController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private AfAdaptacionDep entity;
    private AfAdaptacionDepResponse response;
    private AfAdaptacionDepRequest request;

    @BeforeEach
    void setUp() {
        mockMvc = ControllerMockMvcFactory.standalone(controller);
        objectMapper = ControllerMockMvcFactory.objectMapper();

        entity = new AfAdaptacionDep();
        entity.setId(1L);
        entity.setAfAdaptacionId(1L);
        entity.setAnio(2024);
        entity.setMes(6);
        entity.setDepreciacionPeriodo(new BigDecimal("250.00"));
        entity.setDepreciacionAcumulada(new BigDecimal("1500.00"));
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);

        response = new AfAdaptacionDepResponse();
        response.setId(1L);
        response.setAfAdaptacionId(1L);
        response.setAnio(2024);
        response.setMes(6);
        response.setDepreciacionPeriodo(new BigDecimal("250.00"));
        response.setDepreciacionAcumulada(new BigDecimal("1500.00"));
        response.setFlagEstado("1");

        request = new AfAdaptacionDepRequest();
        request.setAfAdaptacionId(1L);
        request.setAnio(2024);
        request.setMes(6);
        request.setDepreciacionPeriodo(new BigDecimal("250.00"));
        request.setDepreciacionAcumulada(new BigDecimal("1500.00"));
    }

    @Test
    void obtenerPorIdReturnsEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(get("/api/activos/adaptaciones-depreciacion/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.anio").value(2024))
                .andExpect(jsonPath("$.data.mes").value(6))
                .andExpect(jsonPath("$.data.afAdaptacionId").value(1));
    }

    @Test
    void crearReturnsCreatedEntity() throws Exception {
        when(mapper.toEntity(any(AfAdaptacionDepRequest.class))).thenReturn(entity);
        when(service.create(any(AfAdaptacionDep.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/adaptaciones-depreciacion")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.anio").value(2024))
                .andExpect(jsonPath("$.data.mes").value(6))
                .andExpect(jsonPath("$.data.depreciacionPeriodo").value(250.00))
                .andExpect(jsonPath("$.message").value("Registro creado"));
    }

    @Test
    void actualizarReturnsUpdatedEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        doNothing().when(mapper).updateEntity(any(AfAdaptacionDepRequest.class), any(AfAdaptacionDep.class));
        when(service.update(eq(1L), any(AfAdaptacionDep.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(put("/api/activos/adaptaciones-depreciacion/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.anio").value(2024))
                .andExpect(jsonPath("$.data.mes").value(6))
                .andExpect(jsonPath("$.data.depreciacionPeriodo").value(250.00))
                .andExpect(jsonPath("$.message").value("Registro actualizado"));
    }

    @Test
    void eliminarReturnsTrue() throws Exception {
        doNothing().when(service).delete(1L);

        mockMvc.perform(delete("/api/activos/adaptaciones-depreciacion/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true))
                .andExpect(jsonPath("$.message").value("Registro eliminado"));
    }

    @Test
    void listarPorAdaptacionReturnsList() throws Exception {
        when(service.findByAdaptacion(1L)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/adaptaciones-depreciacion/adaptacion/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].anio").value(2024))
                .andExpect(jsonPath("$.data[0].mes").value(6))
                .andExpect(jsonPath("$.data[0].afAdaptacionId").value(1));
    }

    @Test
    void listarPorPeriodoReturnsList() throws Exception {
        when(service.findByPeriodo(2024, 6)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/adaptaciones-depreciacion/periodo/2024/6"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].anio").value(2024))
                .andExpect(jsonPath("$.data[0].mes").value(6))
                .andExpect(jsonPath("$.data[0].depreciacionPeriodo").value(250.00));
    }

    @Test
    void calcularDepreciacionReturnsCalculatedEntity() throws Exception {
        AfAdaptacionDep calculada = new AfAdaptacionDep();
        calculada.setId(1L);
        calculada.setAfAdaptacionId(1L);
        calculada.setAnio(2024);
        calculada.setMes(6);
        calculada.setDepreciacionPeriodo(new BigDecimal("300.00"));
        calculada.setDepreciacionAcumulada(new BigDecimal("1800.00"));
        calculada.setFlagEstado("1");

        AfAdaptacionDepResponse calculadaResponse = new AfAdaptacionDepResponse();
        calculadaResponse.setId(1L);
        calculadaResponse.setAfAdaptacionId(1L);
        calculadaResponse.setAnio(2024);
        calculadaResponse.setMes(6);
        calculadaResponse.setDepreciacionPeriodo(new BigDecimal("300.00"));
        calculadaResponse.setDepreciacionAcumulada(new BigDecimal("1800.00"));
        calculadaResponse.setFlagEstado("1");

        when(service.calcularDepreciacion(1L, 2024, 6)).thenReturn(calculada);
        when(mapper.toResponse(calculada)).thenReturn(calculadaResponse);

        mockMvc.perform(post("/api/activos/adaptaciones-depreciacion/adaptacion/1/calcular")
                        .param("anio", "2024")
                        .param("mes", "6"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.anio").value(2024))
                .andExpect(jsonPath("$.data.mes").value(6))
                .andExpect(jsonPath("$.data.depreciacionPeriodo").value(300.00))
                .andExpect(jsonPath("$.data.depreciacionAcumulada").value(1800.00))
                .andExpect(jsonPath("$.message").value("Depreciación calculada"));
    }

    @Test
    void crearWithInvalidDataReturnsBadRequest() throws Exception {
        AfAdaptacionDepRequest invalidRequest = new AfAdaptacionDepRequest();
        invalidRequest.setAfAdaptacionId(null);
        invalidRequest.setAnio(null);
        invalidRequest.setMes(null);
        invalidRequest.setDepreciacionPeriodo(null);
        invalidRequest.setDepreciacionAcumulada(null);

        mockMvc.perform(post("/api/activos/adaptaciones-depreciacion")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void listarPorAdaptacionWithEmptyListReturnsEmptyArray() throws Exception {
        when(service.findByAdaptacion(999L)).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/adaptaciones-depreciacion/adaptacion/999"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data").isEmpty());
    }

    @Test
    void listarPorPeriodoWithEmptyListReturnsEmptyArray() throws Exception {
        when(service.findByPeriodo(2025, 1)).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/adaptaciones-depreciacion/periodo/2025/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data").isEmpty());
    }

    @Test
    void calcularDepreciacionWithInvalidParametersReturnsBadRequest() throws Exception {
        mockMvc.perform(post("/api/activos/adaptaciones-depreciacion/adaptacion/1/calcular")
                        .param("anio", "2024")
                        // Missing mes parameter
                )
                .andExpect(status().isBadRequest());
    }
}
