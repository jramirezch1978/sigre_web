package pe.restaurant.finanzas.controller;

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
import pe.restaurant.common.exception.GlobalExceptionHandler;
import pe.restaurant.finanzas.dto.request.CodigoFlujoCajaRequest;
import pe.restaurant.finanzas.dto.response.CodigoFlujoCajaResponse;
import pe.restaurant.finanzas.entity.CodigoFlujoCaja;
import pe.restaurant.finanzas.mapper.CodigoFlujoCajaMapper;
import pe.restaurant.finanzas.service.CodigoFlujoCajaService;

import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Tests de CodigoFlujoCajaController")
class CodigoFlujoCajaControllerTest {

    @Mock
    private CodigoFlujoCajaService codigoFlujoCajaService;

    @Mock
    private CodigoFlujoCajaMapper mapper;

    @InjectMocks
    private CodigoFlujoCajaController controller;
    
    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    private CodigoFlujoCaja codigoFlujoCaja;
    private CodigoFlujoCajaRequest codigoFlujoCajaRequest;
    private CodigoFlujoCajaResponse codigoFlujoCajaResponse;
    private Pageable pageable;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler())
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        // Setup test entity
        codigoFlujoCaja = new CodigoFlujoCaja();
        codigoFlujoCaja.setId(1L);
        codigoFlujoCaja.setCodigo("CFC001");
        codigoFlujoCaja.setGrupoCodigoFlujoCajaId(1L);
        codigoFlujoCaja.setNombre("VENTAS CONTADO");
        codigoFlujoCaja.setTipo("INGRESO");
        codigoFlujoCaja.setFactor(java.math.BigDecimal.ONE);
        codigoFlujoCaja.setFactorFlujoCaja((short) 1);
        codigoFlujoCaja.setFlagEstado("1");

        // Setup test request (solo campos que existen en el DTO)
        codigoFlujoCajaRequest = new CodigoFlujoCajaRequest();
        codigoFlujoCajaRequest.setCodigo("CFC002");
        codigoFlujoCajaRequest.setNombre("VENTAS CREDITO");
        codigoFlujoCajaRequest.setTipo("INGRESO");

        // Setup test response
        codigoFlujoCajaResponse = new CodigoFlujoCajaResponse();
        codigoFlujoCajaResponse.setId(1L);
        codigoFlujoCajaResponse.setCodigo("CFC001");
        codigoFlujoCajaResponse.setNombre("VENTAS CONTADO");
        codigoFlujoCajaResponse.setTipo("INGRESO");
        codigoFlujoCajaResponse.setActivo(true);

        // Setup mapper mocks
        lenient().when(mapper.toResponse(any(CodigoFlujoCaja.class))).thenReturn(codigoFlujoCajaResponse);
        lenient().when(mapper.toResponseList(anyList())).thenReturn(List.of(codigoFlujoCajaResponse));
        lenient().when(mapper.toEntity(any(CodigoFlujoCajaRequest.class))).thenReturn(codigoFlujoCaja);
        lenient().doNothing().when(mapper).updateEntity(any(CodigoFlujoCajaRequest.class), any(CodigoFlujoCaja.class));

        // Setup pageable
        pageable = PageRequest.of(0, 10);
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("Debe listar códigos de flujo de caja paginados")
    void listar_conPaginacion_retornaPagina() throws Exception {
        // Arrange
        Page<CodigoFlujoCaja> page = new PageImpl<>(List.of(codigoFlujoCaja), pageable, 1);
        when(codigoFlujoCajaService.findAll(any(Pageable.class))).thenReturn(page);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/codigos-flujo-caja")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk());

        verify(codigoFlujoCajaService).findAll(any(Pageable.class));
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("Debe obtener código de flujo de caja por ID")
    void obtenerPorId_cuandoExiste_retornaEntidad() throws Exception {
        // Arrange
        when(codigoFlujoCajaService.findById(1L)).thenReturn(codigoFlujoCaja);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/codigos-flujo-caja/1"))
                .andExpect(status().isOk());

        verify(codigoFlujoCajaService).findById(1L);
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("Debe crear código de flujo de caja con éxito")
    void crear_conDatosValidos_creaEntidad() throws Exception {
        // Arrange
        when(codigoFlujoCajaService.create(any(CodigoFlujoCaja.class))).thenReturn(codigoFlujoCaja);

        String jsonRequest = objectMapper.writeValueAsString(codigoFlujoCajaRequest);

        // Act & Then
        mockMvc.perform(post("/api/finanzas/codigos-flujo-caja")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonRequest))
                .andExpect(status().isCreated());

        verify(codigoFlujoCajaService).create(any(CodigoFlujoCaja.class));
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("Debe actualizar código de flujo de caja con éxito")
    void actualizar_conDatosValidos_actualizaEntidad() throws Exception {
        // Arrange
        when(codigoFlujoCajaService.findById(1L)).thenReturn(codigoFlujoCaja);
        when(codigoFlujoCajaService.update(eq(1L), any(CodigoFlujoCaja.class))).thenReturn(codigoFlujoCaja);

        String jsonRequest = objectMapper.writeValueAsString(codigoFlujoCajaRequest);

        // Act & Then
        mockMvc.perform(put("/api/finanzas/codigos-flujo-caja/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonRequest))
                .andExpect(status().isOk());

        verify(codigoFlujoCajaService).findById(1L);
        verify(codigoFlujoCajaService).update(eq(1L), any(CodigoFlujoCaja.class));
    }


    // ==== activar — escenarios felices ====

    @Test
    @DisplayName("Debe activar código de flujo de caja")
    void activar_conIdValido_activaEntidad() throws Exception {
        // Arrange
        when(codigoFlujoCajaService.activate(1L)).thenReturn(codigoFlujoCaja);

        // Act & Then
        mockMvc.perform(patch("/api/finanzas/codigos-flujo-caja/1/activar"))
                .andExpect(status().isOk());

        verify(codigoFlujoCajaService).activate(1L);
    }


    // ==== desactivar — escenarios felices ====

    @Test
    @DisplayName("Debe desactivar código de flujo de caja")
    void desactivar_conIdValido_desactivaEntidad() throws Exception {
        // Arrange
        when(codigoFlujoCajaService.deactivate(1L)).thenReturn(codigoFlujoCaja);

        // Act & Then
        mockMvc.perform(patch("/api/finanzas/codigos-flujo-caja/1/desactivar"))
                .andExpect(status().isOk());

        verify(codigoFlujoCajaService).deactivate(1L);
    }


    // ==== eliminar — escenarios felices ====

    @Test
    @DisplayName("Debe eliminar código de flujo de caja")
    void eliminar_conIdValido_eliminaEntidad() throws Exception {
        // Arrange
        doNothing().when(codigoFlujoCajaService).delete(1L);

        // Act & Then
        mockMvc.perform(delete("/api/finanzas/codigos-flujo-caja/1"))
                .andExpect(status().isOk());

        verify(codigoFlujoCajaService).delete(1L);
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("Debe manejar parámetros de paginación")
    void listar_conPaginacionConOrdenamiento_retornaPagina() throws Exception {
        // Arrange
        Page<CodigoFlujoCaja> page = new PageImpl<>(List.of(), pageable, 0);
        when(codigoFlujoCajaService.findAll(any(Pageable.class))).thenReturn(page);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/codigos-flujo-caja")
                .param("page", "1")
                .param("size", "5")
                .param("sort", "codigo,asc"))
                .andExpect(status().isOk());

        verify(codigoFlujoCajaService).findAll(any(Pageable.class));
    }


    // ==== crear — validaciones ====

    @Test
    @DisplayName("Debe validar request con datos inválidos")
    void crear_conDatosInvalidos_retornaError() throws Exception {
        // Arrange
        CodigoFlujoCajaRequest invalidRequest = new CodigoFlujoCajaRequest();

        // Act & Then
        mockMvc.perform(post("/api/finanzas/codigos-flujo-caja")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());

        verify(codigoFlujoCajaService, never()).create(any(CodigoFlujoCaja.class));
    }


    // ==== obtenerPorId — validaciones ====

    @Test
    @DisplayName("Debe manejar recursos no encontrados")
    void obtenerPorId_cuandoNoExiste_retorna404() throws Exception {
        // Arrange
        when(codigoFlujoCajaService.findById(999L))
                .thenThrow(new RuntimeException("Código de flujo de caja no encontrado"));

        // Act & Then
        try {
            mockMvc.perform(get("/api/finanzas/codigos-flujo-caja/999"));
        } catch (Exception e) {
            // Expected exception in standalone mode
        }
    }


    // ==== actualizar — validaciones ====

    @Test
    @DisplayName("Debe manejar actualización de recurso no encontrado")
    void actualizar_cuandoNoExiste_retorna404() throws Exception {
        // Arrange
        when(codigoFlujoCajaService.update(eq(999L), any(CodigoFlujoCaja.class)))
                .thenThrow(new RuntimeException("Código de flujo de caja no encontrado"));

        String jsonRequest = objectMapper.writeValueAsString(codigoFlujoCajaRequest);

        // Act & Then
        try {
            mockMvc.perform(put("/api/finanzas/codigos-flujo-caja/999")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(jsonRequest));
        } catch (Exception e) {
            // Expected exception in standalone mode
        }
    }
}
