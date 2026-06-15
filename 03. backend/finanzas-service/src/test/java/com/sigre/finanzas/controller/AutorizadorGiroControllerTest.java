package com.sigre.finanzas.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
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
import com.sigre.common.exception.GlobalExceptionHandler;
import com.sigre.finanzas.dto.request.AutorizadorGiroRequest;
import com.sigre.finanzas.dto.response.AutorizadorGiroResponse;
import com.sigre.finanzas.service.AutorizadorGiroService;

import java.math.BigDecimal;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Tests de AutorizadorGiroController")
class AutorizadorGiroControllerTest {

    @Mock
    private AutorizadorGiroService autorizadorGiroService;

    @InjectMocks
    private AutorizadorGiroController controller;
    
    private MockMvc mockMvc;
    private ObjectMapper objectMapper;
    
    private AutorizadorGiroResponse autorizadorGiroResponse;
    private AutorizadorGiroRequest autorizadorGiroRequest;
    private Pageable pageable;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler())
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        // Setup pageable
        pageable = PageRequest.of(0, 20);

        // Setup test data
        autorizadorGiroResponse = new AutorizadorGiroResponse();
        autorizadorGiroResponse.setId(1L);
        autorizadorGiroResponse.setCentrosCostoId(124L);
        autorizadorGiroResponse.setUsuarioId(6L);

        autorizadorGiroRequest = new AutorizadorGiroRequest();
        autorizadorGiroRequest.setCentrosCostoId(124L);
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("Debe listar autorizadores de giro paginados")
    void listar_retornaPagina() throws Exception {
        // Arrange
        Page<AutorizadorGiroResponse> page = new PageImpl<>(List.of(autorizadorGiroResponse), pageable, 1);
        when(autorizadorGiroService.findAll(any(Pageable.class))).thenReturn(page);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/autorizadores-giro")
                .param("page", "0")
                .param("size", "20"))
                .andExpect(status().isOk());

        verify(autorizadorGiroService).findAll(any(Pageable.class));
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("Debe obtener autorizador de giro por ID")
    void obtenerPorId_cuandoExiste_retornaAutorizador() throws Exception {
        // Arrange
        when(autorizadorGiroService.findById(1L)).thenReturn(autorizadorGiroResponse);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/autorizadores-giro/{id}", 1L))
                .andExpect(status().isOk());

        verify(autorizadorGiroService).findById(1L);
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("Debe crear nuevo autorizador de giro con éxito")
    void crear_conDatosValidos_creaAutorizador() throws Exception {
        // Arrange
        when(autorizadorGiroService.create(any(AutorizadorGiroRequest.class))).thenReturn(autorizadorGiroResponse);

        String jsonRequest = objectMapper.writeValueAsString(autorizadorGiroRequest);

        // Act & Then
        mockMvc.perform(post("/api/finanzas/autorizadores-giro")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonRequest))
                .andExpect(status().isCreated());

        verify(autorizadorGiroService).create(any(AutorizadorGiroRequest.class));
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("Debe actualizar autorizador de giro con éxito")
    void actualizar_conDatosValidos_actualizaAutorizador() throws Exception {
        // Arrange
        when(autorizadorGiroService.update(eq(1L), any(AutorizadorGiroRequest.class))).thenReturn(autorizadorGiroResponse);

        String jsonRequest = objectMapper.writeValueAsString(autorizadorGiroRequest);

        // Act & Then
        mockMvc.perform(put("/api/finanzas/autorizadores-giro/{id}", 1L)
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonRequest))
                .andExpect(status().isOk());

        verify(autorizadorGiroService).update(eq(1L), any(AutorizadorGiroRequest.class));
    }


    // ==== eliminar — escenarios felices ====

    @Test
    @DisplayName("Debe eliminar autorizador de giro")
    void eliminar_conIdValido_eliminaAutorizador_WhenValidId() throws Exception {
        // Arrange
        doNothing().when(autorizadorGiroService).deleteById(1L);

        // Act & Then
        mockMvc.perform(delete("/api/finanzas/autorizadores-giro/{id}", 1L))
                .andExpect(status().isOk());

        verify(autorizadorGiroService).deleteById(1L);
    }


    // ==== activar — escenarios felices ====

    @Test
    @DisplayName("Debe activar autorizador de giro")
    void activar_conIdValido_activaAutorizador_WhenValidId() throws Exception {
        // Arrange
        when(autorizadorGiroService.activate(1L)).thenReturn(autorizadorGiroResponse);

        // Act & Then
        mockMvc.perform(patch("/api/finanzas/autorizadores-giro/{id}/activar", 1L))
                .andExpect(status().isOk());

        verify(autorizadorGiroService).activate(1L);
    }


    // ==== desactivar — escenarios felices ====

    @Test
    @DisplayName("Debe desactivar autorizador de giro")
    void desactivar_conIdValido_desactivaAutorizador_WhenValidId() throws Exception {
        // Arrange
        when(autorizadorGiroService.deactivate(1L)).thenReturn(autorizadorGiroResponse);

        // Act & Then
        mockMvc.perform(patch("/api/finanzas/autorizadores-giro/{id}/desactivar", 1L))
                .andExpect(status().isOk());

        verify(autorizadorGiroService).deactivate(1L);
    }


    // ==== findByCentroCosto — escenarios felices ====

    @Test
    @DisplayName("Debe obtener autorizadores por centro de costo")
    void findByCentroCosto_cuandoExiste_retornaAutorizadores() throws Exception {
        // Arrange
        List<AutorizadorGiroResponse> autorizadores = List.of(autorizadorGiroResponse);
        when(autorizadorGiroService.findByCentroCosto(124L)).thenReturn(autorizadores);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/autorizadores-giro/centro-costo/{centrosCostoId}", 124L))
                .andExpect(status().isOk());

        verify(autorizadorGiroService).findByCentroCosto(124L);
    }


    // ==== findActivosByCentroCosto — escenarios felices ====

    @Test
    @DisplayName("Debe obtener autorizadores activos por centro de costo")
    void findActivosByCentroCosto_cuandoExiste_retornaActivos() throws Exception {
        // Arrange
        List<AutorizadorGiroResponse> autorizadores = List.of(autorizadorGiroResponse);
        when(autorizadorGiroService.findActivosByCentroCosto(124L)).thenReturn(autorizadores);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/autorizadores-giro/centro-costo/{centrosCostoId}/activos", 124L))
                .andExpect(status().isOk());

        verify(autorizadorGiroService).findActivosByCentroCosto(124L);
    }
}
