package com.sigre.finanzas.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import com.sigre.finanzas.dto.request.ProgramacionPagoDetalleRequest;
import com.sigre.finanzas.dto.request.ProgramacionPagoRequest;
import com.sigre.finanzas.dto.response.EjecucionProgramacionResponse;
import com.sigre.finanzas.dto.response.ProgramacionPagoListResponse;
import com.sigre.finanzas.dto.response.ProgramacionPagoResponse;
import com.sigre.finanzas.service.ProgramacionPagoService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class ProgramacionPagoControllerTest {

    @Mock
    private ProgramacionPagoService service;

    @InjectMocks
    private ProgramacionPagoController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    private ProgramacionPagoRequest request;
    private ProgramacionPagoResponse response;
    private ProgramacionPagoListResponse listResponse;
    private EjecucionProgramacionResponse ejecucionResponse;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        request = new ProgramacionPagoRequest();
        request.setFechaProgramada(LocalDate.of(2026, 5, 15));
        
        List<ProgramacionPagoDetalleRequest> detalles = new ArrayList<>();
        ProgramacionPagoDetalleRequest det1 = new ProgramacionPagoDetalleRequest();
        det1.setCntasPagarId(1001L);
        det1.setMontoProgramado(new BigDecimal("500.00"));
        detalles.add(det1);
        
        request.setDetalles(detalles);

        response = new ProgramacionPagoResponse();
        response.setId(1L);
        response.setFechaProgramada(LocalDate.of(2026, 5, 15));
        response.setFlagEstado("1");

        listResponse = new ProgramacionPagoListResponse();
        listResponse.setId(1L);
        listResponse.setFechaProgramada(LocalDate.of(2026, 5, 15));
        listResponse.setTotalProgramado(new BigDecimal("500.00"));
        listResponse.setCantidadDocumentos(1);

        ejecucionResponse = new EjecucionProgramacionResponse();
        ejecucionResponse.setId(1L);
        ejecucionResponse.setFlagEstado("2");
        ejecucionResponse.setPagosGenerados(1);
        ejecucionResponse.setTotalPagado(new BigDecimal("500.00"));
    }


    // ==== listar — otros ====

    @Test
    void listar_DebeRetornarPaginaConProgramaciones() throws Exception {
        Pageable pageable = PageRequest.of(0, 10);
        Page<ProgramacionPagoListResponse> page = new PageImpl<>(List.of(listResponse));
        
        when(service.listar(any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/finanzas/programacion-pagos")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk());

        verify(service).listar(any(), any(), any(), any());
    }


    // ==== obtenerPorId — otros ====

    @Test
    void obtenerPorId_DebeRetornarProgramacion() throws Exception {
        when(service.obtenerPorId(eq(1L))).thenReturn(response);

        mockMvc.perform(get("/api/finanzas/programacion-pagos/1"))
                .andExpect(status().isOk());

        verify(service).obtenerPorId(eq(1L));
    }


    // ==== crear — escenarios felices ====

    @Test
    void crear_DebeCrearProgramacion() throws Exception {
        when(service.crear(any())).thenReturn(response);

        mockMvc.perform(post("/api/finanzas/programacion-pagos")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());

        verify(service).crear(any());
    }


    // ==== actualizar — escenarios felices ====

    @Test
    void actualizar_DebeActualizarProgramacion() throws Exception {
        when(service.actualizar(eq(1L), any())).thenReturn(response);

        mockMvc.perform(put("/api/finanzas/programacion-pagos/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());

        verify(service).actualizar(eq(1L), any());
    }


    // ==== ejecutar — otros ====

    @Test
    void ejecutar_DebeEjecutarProgramacion() throws Exception {
        when(service.ejecutar(eq(1L))).thenReturn(ejecucionResponse);

        mockMvc.perform(post("/api/finanzas/programacion-pagos/1/ejecutar"))
                .andExpect(status().isOk());

        verify(service).ejecutar(eq(1L));
    }


    // ==== anular — otros ====

    @Test
    void anular_DebeAnularProgramacion() throws Exception {
        when(service.anular(eq(1L))).thenReturn(response);

        mockMvc.perform(post("/api/finanzas/programacion-pagos/1/anular"))
                .andExpect(status().isOk());

        verify(service).anular(eq(1L));
    }
}
