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
import pe.restaurant.activos.dto.AfPolizaSeguroRequest;
import pe.restaurant.activos.dto.AfPolizaSeguroResponse;
import pe.restaurant.activos.dto.AfPrimaDevengoResponse;
import pe.restaurant.activos.entity.AfPolizaSeguro;
import pe.restaurant.activos.entity.AfPrimaDevengo;
import pe.restaurant.activos.mapper.AfPolizaSeguroMapper;
import pe.restaurant.activos.mapper.AfPrimaDevengoMapper;
import pe.restaurant.activos.service.AfPolizaSeguroService;
import pe.restaurant.activos.service.AfPrimaDevengoService;
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
class AfPolizaSeguroControllerTest {

    @Mock
    private AfPolizaSeguroService service;
    @Mock
    private AfPolizaSeguroMapper mapper;
    @Mock
    private AfPrimaDevengoService primaDevengoService;
    @Mock
    private AfPrimaDevengoMapper primaDevengoMapper;
    @InjectMocks
    private AfPolizaSeguroController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    private AfPolizaSeguro entity;
    private AfPolizaSeguroResponse response;
    private AfPolizaSeguroRequest request;

    @BeforeEach
    void setUp() {
        mockMvc = ControllerMockMvcFactory.standalone(controller, true);
        objectMapper = ControllerMockMvcFactory.objectMapper();

        entity = new AfPolizaSeguro();
        entity.setId(1L);
        entity.setAfAseguradoraId(1L);
        entity.setNumeroPoliza("POL-2024-001");
        entity.setFechaInicio(LocalDate.of(2024, 1, 1));
        entity.setFechaFin(LocalDate.of(2024, 12, 31));
        entity.setPrima(new BigDecimal("5000.00"));
        entity.setCobertura(new BigDecimal("100000.00"));
        entity.setFlagEstado(ActivosFlagEstado.ACTIVO);

        response = new AfPolizaSeguroResponse();
        response.setId(1L);
        response.setAfAseguradoraId(1L);
        response.setNumeroPoliza("POL-2024-001");
        response.setFechaInicio(LocalDate.of(2024, 1, 1));
        response.setFechaFin(LocalDate.of(2024, 12, 31));
        response.setPrima(new BigDecimal("5000.00"));
        response.setCobertura(new BigDecimal("100000.00"));
        response.setFlagEstado("1");

        request = new AfPolizaSeguroRequest();
        request.setAfAseguradoraId(1L);
        request.setNumeroPoliza("POL-2024-001");
        request.setFechaInicio(LocalDate.of(2024, 1, 1));
        request.setFechaFin(LocalDate.of(2024, 12, 31));
        request.setPrima(new BigDecimal("5000.00"));
        request.setCobertura(new BigDecimal("100000.00"));
    }

    @Test
    void listarReturnsPageData() throws Exception {
        when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/polizas")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[0].numeroPoliza").value("POL-2024-001"));
    }

    @Test
    void obtenerPorIdReturnsEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(get("/api/activos/polizas/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.numeroPoliza").value("POL-2024-001"))
                .andExpect(jsonPath("$.data.afAseguradoraId").value(1));
    }

    @Test
    void crearReturnsCreatedEntity() throws Exception {
        when(mapper.toEntity(any(AfPolizaSeguroRequest.class))).thenReturn(entity);
        when(service.create(any(AfPolizaSeguro.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/polizas")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.numeroPoliza").value("POL-2024-001"))
                .andExpect(jsonPath("$.message").value("Registro creado"));
    }

    @Test
    void actualizarReturnsUpdatedEntity() throws Exception {
        when(service.findById(1L)).thenReturn(entity);
        doNothing().when(mapper).updateEntity(any(AfPolizaSeguroRequest.class), any(AfPolizaSeguro.class));
        when(service.update(eq(1L), any(AfPolizaSeguro.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(put("/api/activos/polizas/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.numeroPoliza").value("POL-2024-001"))
                .andExpect(jsonPath("$.message").value("Registro actualizado"));
    }

    @Test
    void eliminarReturnsTrue() throws Exception {
        doNothing().when(service).delete(1L);

        mockMvc.perform(delete("/api/activos/polizas/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").value(true))
                .andExpect(jsonPath("$.message").value("Registro eliminado"));
    }

    @Test
    void listarVigentesReturnsPageData() throws Exception {
        when(service.findPolizasVigentes(any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/polizas/vigentes")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[0].numeroPoliza").value("POL-2024-001"));
    }

    @Test
    void listarPorVencerReturnsList() throws Exception {
        when(service.findPolizasPorVencer(30)).thenReturn(List.of(entity));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/polizas/por-vencer/30"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data[0].numeroPoliza").value("POL-2024-001"))
                .andExpect(jsonPath("$.data[0].fechaFin").exists());
    }

    @Test
    void listarPorAseguradoraReturnsPageData() throws Exception {
        when(service.findByAseguradora(eq(1L), any(Pageable.class))).thenReturn(new PageImpl<>(List.of(entity)));
        when(mapper.toResponseList(any())).thenReturn(List.of(response));

        mockMvc.perform(get("/api/activos/polizas/aseguradora/1")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content[0].numeroPoliza").value("POL-2024-001"))
                .andExpect(jsonPath("$.data.content[0].afAseguradoraId").value(1));
    }

    @Test
    void renovarReturnsUpdatedEntity() throws Exception {
        AfPolizaSeguro renovada = new AfPolizaSeguro();
        renovada.setId(1L);
        renovada.setAfAseguradoraId(1L);
        renovada.setNumeroPoliza("POL-2025-001");
        renovada.setFechaInicio(LocalDate.of(2025, 1, 1));
        renovada.setFechaFin(LocalDate.of(2025, 12, 31));
        renovada.setPrima(new BigDecimal("5500.00"));
        renovada.setCobertura(new BigDecimal("110000.00"));
        renovada.setFlagEstado("1");

        AfPolizaSeguroResponse renovadaResponse = new AfPolizaSeguroResponse();
        renovadaResponse.setId(1L);
        renovadaResponse.setAfAseguradoraId(1L);
        renovadaResponse.setNumeroPoliza("POL-2025-001");
        renovadaResponse.setFechaInicio(LocalDate.of(2025, 1, 1));
        renovadaResponse.setFechaFin(LocalDate.of(2025, 12, 31));
        renovadaResponse.setPrima(new BigDecimal("5500.00"));
        renovadaResponse.setCobertura(new BigDecimal("110000.00"));
        renovadaResponse.setFlagEstado("1");

        when(mapper.toEntity(any(AfPolizaSeguroRequest.class))).thenReturn(entity);
        when(service.renovarPoliza(eq(1L), any(AfPolizaSeguro.class))).thenReturn(renovada);
        when(mapper.toResponse(renovada)).thenReturn(renovadaResponse);

        mockMvc.perform(patch("/api/activos/polizas/1/renovar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.numeroPoliza").value("POL-2025-001"))
                .andExpect(jsonPath("$.data.prima").value(5500.00))
                .andExpect(jsonPath("$.data.cobertura").value(110000.00))
                .andExpect(jsonPath("$.message").value("Póliza renovada"));
    }

    @Test
    void crearWithInvalidDataReturnsBadRequest() throws Exception {
        AfPolizaSeguroRequest invalidRequest = new AfPolizaSeguroRequest();
        invalidRequest.setAfAseguradoraId(null);
        invalidRequest.setNumeroPoliza("");
        invalidRequest.setFechaInicio(null);
        invalidRequest.setPrima(null);
        invalidRequest.setCobertura(null);

        mockMvc.perform(post("/api/activos/polizas")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void crearWithNegativePrimaReturnsBadRequest() throws Exception {
        AfPolizaSeguroRequest invalidRequest = new AfPolizaSeguroRequest();
        invalidRequest.setAfAseguradoraId(1L);
        invalidRequest.setNumeroPoliza("POL-2024-001");
        invalidRequest.setFechaInicio(LocalDate.of(2024, 1, 1));
        invalidRequest.setPrima(new BigDecimal("-1000.00"));
        invalidRequest.setCobertura(new BigDecimal("100000.00"));

        mockMvc.perform(post("/api/activos/polizas")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void crearWithNegativeCoberturaReturnsBadRequest() throws Exception {
        AfPolizaSeguroRequest invalidRequest = new AfPolizaSeguroRequest();
        invalidRequest.setAfAseguradoraId(1L);
        invalidRequest.setNumeroPoliza("POL-2024-001");
        invalidRequest.setFechaInicio(LocalDate.of(2024, 1, 1));
        invalidRequest.setPrima(new BigDecimal("5000.00"));
        invalidRequest.setCobertura(new BigDecimal("-100000.00"));

        mockMvc.perform(post("/api/activos/polizas")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void crearWithInvalidDateRangeReturnsBadRequest() throws Exception {
        AfPolizaSeguroRequest invalidRequest = new AfPolizaSeguroRequest();
        invalidRequest.setAfAseguradoraId(1L);
        invalidRequest.setNumeroPoliza("POL-2024-001");
        invalidRequest.setFechaInicio(null); // Campo requerido nulo
        invalidRequest.setFechaFin(null); // Campo requerido nulo

        mockMvc.perform(post("/api/activos/polizas")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void listarReturnsEmptyPageData() throws Exception {
        when(service.findAll(any(Pageable.class))).thenReturn(new PageImpl<>(List.of()));
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/polizas")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content").isEmpty());
    }

    @Test
    void listarVigentesWithEmptyListReturnsEmptyArray() throws Exception {
        when(service.findPolizasVigentes(any(Pageable.class))).thenReturn(new PageImpl<>(List.of()));
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/polizas/vigentes")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content").isEmpty());
    }

    @Test
    void listarPorVencerWithEmptyListReturnsEmptyArray() throws Exception {
        when(service.findPolizasPorVencer(999)).thenReturn(List.of());
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/polizas/por-vencer/999"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data").isArray())
                .andExpect(jsonPath("$.data").isEmpty());
    }

    @Test
    void listarPorAseguradoraWithEmptyListReturnsEmptyArray() throws Exception {
        when(service.findByAseguradora(eq(999L), any(Pageable.class))).thenReturn(new PageImpl<>(List.of()));
        when(mapper.toResponseList(any())).thenReturn(List.of());

        mockMvc.perform(get("/api/activos/polizas/aseguradora/999")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content").isArray())
                .andExpect(jsonPath("$.data.content").isEmpty());
    }

    @Test
    void renovarWithInvalidDataReturnsBadRequest() throws Exception {
        AfPolizaSeguroRequest invalidRequest = new AfPolizaSeguroRequest();
        invalidRequest.setAfAseguradoraId(null);
        invalidRequest.setNumeroPoliza("");

        mockMvc.perform(patch("/api/activos/polizas/1/renovar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void crearWithNullFechaFinReturnsSuccess() throws Exception {
        AfPolizaSeguroRequest requestWithNullFin = new AfPolizaSeguroRequest();
        requestWithNullFin.setAfAseguradoraId(1L);
        requestWithNullFin.setNumeroPoliza("POL-2024-001");
        requestWithNullFin.setFechaInicio(LocalDate.of(2024, 1, 1));
        requestWithNullFin.setPrima(new BigDecimal("5000.00"));
        requestWithNullFin.setCobertura(new BigDecimal("100000.00"));
        when(mapper.toEntity(any(AfPolizaSeguroRequest.class))).thenReturn(entity);
        when(service.create(any(AfPolizaSeguro.class))).thenReturn(entity);
        when(mapper.toResponse(entity)).thenReturn(response);

        mockMvc.perform(post("/api/activos/polizas")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(requestWithNullFin)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.numeroPoliza").value("POL-2024-001"));
    }

    @Test
    void actualizarWithInvalidDataReturnsBadRequest() throws Exception {
        AfPolizaSeguroRequest invalidRequest = new AfPolizaSeguroRequest();
        invalidRequest.setAfAseguradoraId(null);
        invalidRequest.setNumeroPoliza("");

        mockMvc.perform(put("/api/activos/polizas/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());
    }

    @Test
    void registrarDevengoMensualReturnsCreated() throws Exception {
        AfPrimaDevengo dev = new AfPrimaDevengo();
        dev.setId(99L);
        dev.setAfPolizaSeguroId(1L);
        dev.setAnio(2024);
        dev.setMes(3);
        dev.setImporteDevengado(new BigDecimal("416.6667"));
        AfPrimaDevengoResponse devResp = new AfPrimaDevengoResponse();
        devResp.setId(99L);
        devResp.setAfPolizaSeguroId(1L);
        devResp.setAnio(2024);
        devResp.setMes(3);
        when(primaDevengoService.registrarDevengoMensual(1L, 2024, 3)).thenReturn(dev);
        when(primaDevengoMapper.toResponse(dev)).thenReturn(devResp);

        mockMvc.perform(post("/api/activos/polizas/1/devengo-mensual")
                        .param("anio", "2024")
                        .param("mes", "3"))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.mes").value(3));
    }

    @Test
    void listarDevengosReturnsOk() throws Exception {
        AfPrimaDevengo dev = new AfPrimaDevengo();
        dev.setId(1L);
        AfPrimaDevengoResponse devResp = new AfPrimaDevengoResponse();
        devResp.setId(1L);
        when(primaDevengoService.listByPoliza(1L)).thenReturn(List.of(dev));
        when(primaDevengoMapper.toResponseList(anyList())).thenReturn(List.of(devResp));

        mockMvc.perform(get("/api/activos/polizas/1/devengos"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data[0].id").value(1));
    }

    @Test
    void obtenerPorIdNotFoundThrowsException() throws Exception {
        when(service.findById(999L)).thenThrow(new RuntimeException("Entity not found"));

        try {
            mockMvc.perform(get("/api/activos/polizas/999"));
        } catch (Exception e) {
            assert e.getCause() instanceof RuntimeException;
            assert e.getCause().getMessage().equals("Entity not found");
        }
    }
}
