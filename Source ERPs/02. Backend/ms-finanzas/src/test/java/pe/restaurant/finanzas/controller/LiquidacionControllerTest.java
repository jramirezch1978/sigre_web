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
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;
import pe.restaurant.finanzas.dto.request.CerrarLiquidacionRequest;
import pe.restaurant.finanzas.dto.request.LiquidacionDetalleRequest;
import pe.restaurant.finanzas.dto.request.LiquidacionRequest;
import pe.restaurant.finanzas.dto.response.LiquidacionDetalleResponse;
import pe.restaurant.finanzas.dto.response.LiquidacionResponse;
import pe.restaurant.finanzas.dto.response.ValidacionCierreResponse;
import pe.restaurant.finanzas.service.LiquidacionService;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
class LiquidacionControllerTest {

    @Mock
    private LiquidacionService service;

    @InjectMocks
    private LiquidacionController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    private LiquidacionRequest request;
    private LiquidacionResponse response;
    private LiquidacionDetalleResponse detalleResponse;

    @BeforeEach
    void setUp() {
        LocalValidatorFactoryBean validator = new LocalValidatorFactoryBean();
        validator.afterPropertiesSet();
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new pe.restaurant.common.exception.GlobalExceptionHandler())
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .setValidator(validator)
                .build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        request = new LiquidacionRequest();
        request.setSolicitudGiroId(4L);
        request.setSucursalId(1L);
        request.setNroLiquidacion("LQ-2026-0001");  // max 12 chars (@Size)
        request.setImporteNeto(new BigDecimal("4800.00"));
        request.setTasaCambio(BigDecimal.ONE);
        request.setCntblLibroId(1L);  // Campo obligatorio que faltaba
        request.setObservacion("Test");
        request.setConceptoFinancieroId(1L);

        List<LiquidacionDetalleRequest> detalles = new ArrayList<>();
        LiquidacionDetalleRequest det1 = new LiquidacionDetalleRequest();
        det1.setItem(1);
        det1.setImporte(new BigDecimal("2500.00"));
        det1.setFactorSigno((short) 1);
        det1.setCntasPagarId(1L);  // Campo requerido por @AtLeastOneNotNull
        det1.setConceptoFinancieroId(1L);
        detalles.add(det1);
        
        LiquidacionDetalleRequest det2 = new LiquidacionDetalleRequest();
        det2.setItem(2);
        det2.setImporte(new BigDecimal("2300.00"));
        det2.setFactorSigno((short) 1);
        det2.setCntasPagarId(2L);  // Campo requerido por @AtLeastOneNotNull
        det2.setConceptoFinancieroId(1L);
        detalles.add(det2);
        
        request.setDetalles(detalles);
        
        response = new LiquidacionResponse();
        response.setId(1L);
        response.setNroLiquidacion("LQ-2026-0001");
        
        detalleResponse = new LiquidacionDetalleResponse();
        detalleResponse.setId(1L);
        detalleResponse.setNroLiquidacion("LQ-2026-0001");
        detalleResponse.setFlagEstado("1");
    }


    // ==== listar — otros ====

    @Test
    void listar_DebeRetornarPaginaDeResultados() throws Exception {
        Page<LiquidacionResponse> page = new PageImpl<>(List.of(response));
        when(service.listarLiquidaciones(any())).thenReturn(page);

        mockMvc.perform(get("/api/finanzas/liquidaciones")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk());

        verify(service).listarLiquidaciones(any());
    }


    // ==== obtenerPorId — otros ====

    @Test
    void obtenerPorId_DebeRetornarLiquidacion() throws Exception {
        when(service.obtenerPorId(eq(1L))).thenReturn(detalleResponse);

        mockMvc.perform(get("/api/finanzas/liquidaciones/1"))
                .andExpect(status().isOk());

        verify(service).obtenerPorId(eq(1L));
    }


    // ==== crear — escenarios felices ====

    @Test
    void crear_DebeCrearYRetornarLiquidacion() throws Exception {
        when(service.crearLiquidacion(any(LiquidacionRequest.class))).thenReturn(detalleResponse);

        mockMvc.perform(post("/api/finanzas/liquidaciones")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated());

        verify(service).crearLiquidacion(any(LiquidacionRequest.class));
    }


    // ==== actualizar — escenarios felices ====

    @Test
    void actualizar_DebeActualizarYRetornarLiquidacion() throws Exception {
        when(service.actualizarLiquidacion(eq(1L), any(LiquidacionRequest.class))).thenReturn(detalleResponse);

        mockMvc.perform(put("/api/finanzas/liquidaciones/1")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk());

        verify(service).actualizarLiquidacion(eq(1L), any(LiquidacionRequest.class));
    }


    // ==== anular — otros ====

    @Test
    void anular_DebeAnularYRetornarResultado() throws Exception {
        Map<String, Object> result = new HashMap<>();
        result.put("id", 1L);
        result.put("flagEstado", "0");
        
        when(service.anularLiquidacion(eq(1L))).thenReturn(result);

        mockMvc.perform(post("/api/finanzas/liquidaciones/1/anular"))
                .andExpect(status().isOk());

        verify(service).anularLiquidacion(eq(1L));
    }


    // ==== validarCierre — escenarios felices ====

    @Test
    void validarCierre_DebeRetornarValidacion() throws Exception {
        ValidacionCierreResponse validacion = new ValidacionCierreResponse();
        validacion.setId(1L);
        validacion.setCuadrado(true);
        validacion.setPuedeCerrar(true);
        
        when(service.validarCierre(eq(1L))).thenReturn(validacion);

        mockMvc.perform(get("/api/finanzas/liquidaciones/1/validacion-cierre"))
                .andExpect(status().isOk());

        verify(service).validarCierre(eq(1L));
    }


    // ==== cerrar — otros ====

    @Test
    void cerrar_DebeCerrarYRetornarLiquidacion() throws Exception {
        CerrarLiquidacionRequest cerrarRequest = new CerrarLiquidacionRequest();
        cerrarRequest.setObservacion("Cierre aprobado");
        
        detalleResponse.setFlagEstado("2");
        when(service.cerrarLiquidacion(eq(1L), anyString())).thenReturn(detalleResponse);

        mockMvc.perform(post("/api/finanzas/liquidaciones/1/cerrar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(cerrarRequest)))
                .andExpect(status().isOk());

        verify(service).cerrarLiquidacion(eq(1L), eq("Cierre aprobado"));
    }
}
