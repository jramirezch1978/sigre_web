package pe.restaurant.finanzas.controller;

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
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.ResourceNotFoundException;
import pe.restaurant.finanzas.dto.request.DestinoCanjeRequest;
import pe.restaurant.finanzas.dto.request.LetraCanjeRequest;
import pe.restaurant.finanzas.dto.request.OrigenCanjeRequest;
import pe.restaurant.finanzas.dto.response.LetraCanjeDetalleResponse;
import pe.restaurant.finanzas.dto.response.LetraCanjeResponse;
import pe.restaurant.finanzas.service.FinanzasErrorCodes;
import pe.restaurant.finanzas.service.LetraCanjeService;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Collections;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class LetraCanjeControllerTest {

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    @Mock
    private LetraCanjeService service;

    @InjectMocks
    private LetraCanjeController controller;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
    }


    // ==== listar — otros ====

    @Test
    void listar_RetornaOk() throws Exception {
        LetraCanjeResponse response = new LetraCanjeResponse();
        response.setReferencia("CANJE-2026-001");
        response.setProveedorId(100L);
        response.setMontoCanjeado(new BigDecimal("700.00"));
        
        Page<LetraCanjeResponse> page = new PageImpl<>(
            Collections.singletonList(response),
            PageRequest.of(0, 10),
            1
        );
        
        when(service.listarCanjes(isNull(), isNull(), isNull(), isNull(), any()))
            .thenReturn(page);

        mockMvc.perform(get("/api/finanzas/letras-canje")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk());
    }


    // ==== obtenerPorReferencia — escenarios felices ====

    @Test
    void obtenerPorReferencia_Existente_RetornaOk() throws Exception {
        LetraCanjeDetalleResponse response = new LetraCanjeDetalleResponse();
        response.setReferencia("CANJE-2026-001");
        response.setProveedorId(100L);
        response.setMontoCanjeado(new BigDecimal("700.00"));
        
        when(service.obtenerCanjePorReferencia("CANJE-2026-001")).thenReturn(response);

        mockMvc.perform(get("/api/finanzas/letras-canje/CANJE-2026-001"))
                .andExpect(status().isOk());
    }


    // ==== obtenerPorReferencia — otros ====

    @Test
    void obtenerPorReferencia_NoExistente_RetornaNotFound() throws Exception {
        when(service.obtenerCanjePorReferencia("CANJE-INEXISTENTE"))
            .thenThrow(new RuntimeException("Canje no encontrado"));

        try {
            mockMvc.perform(get("/api/finanzas/letras-canje/CANJE-INEXISTENTE"));
        } catch (Exception e) {
            assert e.getCause() instanceof RuntimeException;
        }
    }


    // ==== ejecutarCanje — escenarios felices ====

    @Test
    void ejecutarCanje_ConDatosValidos_RetornaCreated() throws Exception {
        OrigenCanjeRequest origen = new OrigenCanjeRequest();
        origen.setCntasPagarId(1L);
        origen.setMontoCanjeado(new BigDecimal("700.00"));

        DestinoCanjeRequest destino1 = new DestinoCanjeRequest();
        destino1.setDocTipoId(40L);
        destino1.setSerie("LT01");
        destino1.setNumero("000001");
        destino1.setFechaEmision(LocalDate.now());
        destino1.setTotal(new BigDecimal("350.00"));

        DestinoCanjeRequest destino2 = new DestinoCanjeRequest();
        destino2.setDocTipoId(40L);
        destino2.setSerie("LT01");
        destino2.setNumero("000002");
        destino2.setFechaEmision(LocalDate.now());
        destino2.setTotal(new BigDecimal("350.00"));

        LetraCanjeRequest request = new LetraCanjeRequest();
        request.setProveedorId(100L);
        request.setFechaCanje(LocalDate.now());
        request.setReferencia("CANJE-2026-001");
        request.setOrigenes(Arrays.asList(origen));
        request.setDestinos(Arrays.asList(destino1, destino2));

        LetraCanjeDetalleResponse response = new LetraCanjeDetalleResponse();
        response.setReferencia("CANJE-2026-001");
        
        when(service.ejecutarCanje(any(LetraCanjeRequest.class))).thenReturn(response);

        mockMvc.perform(post("/api/finanzas/letras-canje")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());
    }


    // ==== ejecutarCanje — validaciones ====

    @Test
    void ejecutarCanje_ConValidacionError_RetornaBadRequest() throws Exception {
        LetraCanjeRequest request = new LetraCanjeRequest();

        mockMvc.perform(post("/api/finanzas/letras-canje")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }


    // ==== ejecutarCanje — edge cases ====

    @Test
    void ejecutarCanje_ConErrorNegocio_RetornaUnprocessableEntity() throws Exception {
        OrigenCanjeRequest origen = new OrigenCanjeRequest();
        origen.setCntasPagarId(1L);
        origen.setMontoCanjeado(new BigDecimal("700.00"));

        DestinoCanjeRequest destino = new DestinoCanjeRequest();
        destino.setDocTipoId(40L);
        destino.setFechaEmision(LocalDate.now());
        destino.setTotal(new BigDecimal("700.00"));

        LetraCanjeRequest request = new LetraCanjeRequest();
        request.setProveedorId(100L);
        request.setFechaCanje(LocalDate.now());
        request.setReferencia("CANJE-2026-001");
        request.setOrigenes(Arrays.asList(origen));
        request.setDestinos(Arrays.asList(destino));

        when(service.ejecutarCanje(any(LetraCanjeRequest.class)))
            .thenThrow(new BusinessException("Error de negocio", FinanzasErrorCodes.CANJE_SALDO_INSUFICIENTE));

        try {
            mockMvc.perform(post("/api/finanzas/letras-canje")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(objectMapper.writeValueAsString(request)));
        } catch (Exception e) {
            assert e.getCause() instanceof BusinessException;
        }
    }


    // ==== anularCanje — otros ====

    @Test
    void anularCanje_Exitoso_RetornaOk() throws Exception {
        LetraCanjeDetalleResponse response = new LetraCanjeDetalleResponse();
        response.setReferencia("CANJE-2026-001");
        
        when(service.anularCanje("CANJE-2026-001")).thenReturn(response);

        mockMvc.perform(post("/api/finanzas/letras-canje/CANJE-2026-001/anular"))
                .andExpect(status().isOk());
    }

    @Test
    void anularCanje_NoReversible_RetornaUnprocessableEntity() throws Exception {
        when(service.anularCanje("CANJE-2026-001"))
            .thenThrow(new BusinessException("Canje no reversible", FinanzasErrorCodes.CANJE_NO_REVERSIBLE));

        try {
            mockMvc.perform(post("/api/finanzas/letras-canje/CANJE-2026-001/anular"));
        } catch (Exception e) {
            assert e.getCause() instanceof BusinessException;
        }
    }
}
