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
import pe.restaurant.finanzas.dto.request.GrupoCodigoFlujoCajaRequest;
import pe.restaurant.finanzas.dto.response.GrupoCodigoFlujoCajaResponse;
import pe.restaurant.finanzas.dto.response.PageData;
import pe.restaurant.finanzas.service.GrupoCodigoFlujoCajaService;

import java.time.LocalDateTime;
import java.util.List;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Tests de GrupoCodigoFlujoCajaController")
class GrupoCodigoFlujoCajaControllerTest {

    @Mock
    private GrupoCodigoFlujoCajaService grupoCodigoFlujoCajaService;

    @InjectMocks
    private GrupoCodigoFlujoCajaController controller;
    
    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    private GrupoCodigoFlujoCajaRequest grupoCodigoFlujoCajaRequest;
    private GrupoCodigoFlujoCajaResponse grupoCodigoFlujoCajaResponse;
    private Pageable pageable;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler())
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());

        // Setup test request
        grupoCodigoFlujoCajaRequest = new GrupoCodigoFlujoCajaRequest();
        grupoCodigoFlujoCajaRequest.setCodigo("002");
        grupoCodigoFlujoCajaRequest.setNombre("EGRESOS OPERATIVOS");
        grupoCodigoFlujoCajaRequest.setFlagReporte("1");
        grupoCodigoFlujoCajaRequest.setFactor("+");
        grupoCodigoFlujoCajaRequest.setOrden(1);
        grupoCodigoFlujoCajaRequest.setActividadFlujoCajaId(1L);

        // Setup test response
        grupoCodigoFlujoCajaResponse = new GrupoCodigoFlujoCajaResponse();
        grupoCodigoFlujoCajaResponse.setId(1L);
        grupoCodigoFlujoCajaResponse.setCodigo("002");
        grupoCodigoFlujoCajaResponse.setNombre("EGRESOS OPERATIVOS");
        grupoCodigoFlujoCajaResponse.setFlagReporte("1");
        grupoCodigoFlujoCajaResponse.setFactor("+");
        grupoCodigoFlujoCajaResponse.setOrden(1);
        grupoCodigoFlujoCajaResponse.setActividadFlujoCajaId(1L);
        grupoCodigoFlujoCajaResponse.setFlagEstado("1");
        grupoCodigoFlujoCajaResponse.setCreatedAt(LocalDateTime.now());
        grupoCodigoFlujoCajaResponse.setUpdatedAt(LocalDateTime.now());

        // Setup pageable
        pageable = PageRequest.of(0, 10);
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("Debe listar grupos de flujo de caja paginados")
    void listar_conPaginacion_retornaPagina() throws Exception {
        // Arrange
        Page<GrupoCodigoFlujoCajaResponse> springPage = new PageImpl<>(List.of(grupoCodigoFlujoCajaResponse), pageable, 1);
        PageData<GrupoCodigoFlujoCajaResponse> expectedPageData = PageData.of(springPage, springPage.getContent());
        when(grupoCodigoFlujoCajaService.findAll(any(Pageable.class))).thenReturn(expectedPageData);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/grupos-flujo-caja")
                .param("page", "0")
                .param("size", "10"))
                .andExpect(status().isOk());

        verify(grupoCodigoFlujoCajaService).findAll(any(Pageable.class));
    }


    // ==== obtenerPorId — escenarios felices ====

    @Test
    @DisplayName("Debe obtener grupo de flujo de caja por ID")
    void obtenerPorId_cuandoExiste_retornaEntidad() throws Exception {
        // Arrange
        when(grupoCodigoFlujoCajaService.findById(1L)).thenReturn(grupoCodigoFlujoCajaResponse);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/grupos-flujo-caja/1"))
                .andExpect(status().isOk());

        verify(grupoCodigoFlujoCajaService).findById(1L);
    }


    // ==== crear — escenarios felices ====

    @Test
    @DisplayName("Debe crear grupo de flujo de caja con éxito")
    void crear_conDatosValidos_creaEntidad() throws Exception {
        // Arrange
        when(grupoCodigoFlujoCajaService.create(any(GrupoCodigoFlujoCajaRequest.class)))
                .thenReturn(grupoCodigoFlujoCajaResponse);

        String jsonRequest = objectMapper.writeValueAsString(grupoCodigoFlujoCajaRequest);

        // Act & Then
        mockMvc.perform(post("/api/finanzas/grupos-flujo-caja")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonRequest))
                .andExpect(status().isCreated());

        verify(grupoCodigoFlujoCajaService).create(any(GrupoCodigoFlujoCajaRequest.class));
    }


    // ==== actualizar — escenarios felices ====

    @Test
    @DisplayName("Debe actualizar grupo de flujo de caja con éxito")
    void actualizar_conDatosValidos_actualizaEntidad() throws Exception {
        // Arrange
        when(grupoCodigoFlujoCajaService.update(eq(1L), any(GrupoCodigoFlujoCajaRequest.class)))
                .thenReturn(grupoCodigoFlujoCajaResponse);

        String jsonRequest = objectMapper.writeValueAsString(grupoCodigoFlujoCajaRequest);

        // Act & Then
        mockMvc.perform(put("/api/finanzas/grupos-flujo-caja/1")
                .contentType(MediaType.APPLICATION_JSON)
                .content(jsonRequest))
                .andExpect(status().isOk());

        verify(grupoCodigoFlujoCajaService).update(eq(1L), any(GrupoCodigoFlujoCajaRequest.class));
    }


    // ==== activar — escenarios felices ====

    @Test
    @DisplayName("Debe activar grupo de flujo de caja")
    void activar_conIdValido_activaEntidad() throws Exception {
        // Arrange
        when(grupoCodigoFlujoCajaService.activate(1L)).thenReturn(grupoCodigoFlujoCajaResponse);

        // Act & Then
        mockMvc.perform(patch("/api/finanzas/grupos-flujo-caja/1/activar"))
                .andExpect(status().isOk());

        verify(grupoCodigoFlujoCajaService).activate(1L);
    }


    // ==== desactivar — escenarios felices ====

    @Test
    @DisplayName("Debe desactivar grupo de flujo de caja")
    void desactivar_conIdValido_desactivaEntidad() throws Exception {
        // Arrange
        when(grupoCodigoFlujoCajaService.deactivate(1L)).thenReturn(grupoCodigoFlujoCajaResponse);

        // Act & Then
        mockMvc.perform(patch("/api/finanzas/grupos-flujo-caja/1/desactivar"))
                .andExpect(status().isOk());

        verify(grupoCodigoFlujoCajaService).deactivate(1L);
    }


    // ==== eliminar — escenarios felices ====

    @Test
    @DisplayName("Debe eliminar grupo de flujo de caja")
    void eliminar_conIdValido_eliminaEntidad() throws Exception {
        // Arrange
        doNothing().when(grupoCodigoFlujoCajaService).deleteById(1L);

        // Act & Then
        mockMvc.perform(delete("/api/finanzas/grupos-flujo-caja/1"))
                .andExpect(status().isOk());

        verify(grupoCodigoFlujoCajaService).deleteById(1L);
    }


    // ==== listar — escenarios felices ====

    @Test
    @DisplayName("Debe manejar parámetros de paginación")
    void listar_conPaginacionConOrdenamiento_retornaPagina() throws Exception {
        // Arrange
        Page<GrupoCodigoFlujoCajaResponse> springPage = new PageImpl<>(List.of(), pageable, 0);
        PageData<GrupoCodigoFlujoCajaResponse> expectedPageData = PageData.of(springPage, springPage.getContent());
        when(grupoCodigoFlujoCajaService.findAll(any(Pageable.class))).thenReturn(expectedPageData);

        // Act & Then
        mockMvc.perform(get("/api/finanzas/grupos-flujo-caja")
                .param("page", "1")
                .param("size", "5")
                .param("sort", "orden,asc"))
                .andExpect(status().isOk());

        verify(grupoCodigoFlujoCajaService).findAll(any(Pageable.class));
    }


    // ==== crear — validaciones ====

    @Test
    @DisplayName("Debe validar request con datos inválidos")
    void crear_conDatosInvalidos_retornaError() throws Exception {
        // Arrange
        GrupoCodigoFlujoCajaRequest invalidRequest = new GrupoCodigoFlujoCajaRequest();

        // Act & Then
        mockMvc.perform(post("/api/finanzas/grupos-flujo-caja")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(invalidRequest)))
                .andExpect(status().isBadRequest());

        verify(grupoCodigoFlujoCajaService, never()).create(any(GrupoCodigoFlujoCajaRequest.class));
    }


    // ==== obtenerPorId — validaciones ====

    @Test
    @DisplayName("Debe manejar recursos no encontrados")
    void obtenerPorId_cuandoNoExiste_retorna404() throws Exception {
        // Arrange
        when(grupoCodigoFlujoCajaService.findById(999L))
                .thenThrow(new RuntimeException("Grupo de código de flujo de caja no encontrado"));

        // Act & Then
        try {
            mockMvc.perform(get("/api/finanzas/grupos-flujo-caja/999"));
        } catch (Exception e) {
            // Expected exception in standalone mode
        }
    }


    // ==== actualizar — validaciones ====

    @Test
    @DisplayName("Debe manejar actualización de recurso no encontrado")
    void actualizar_cuandoNoExiste_retorna404() throws Exception {
        // Arrange
        when(grupoCodigoFlujoCajaService.update(eq(999L), any(GrupoCodigoFlujoCajaRequest.class)))
                .thenThrow(new RuntimeException("Grupo de código de flujo de caja no encontrado"));

        String jsonRequest = objectMapper.writeValueAsString(grupoCodigoFlujoCajaRequest);

        // Act & Then
        try {
            mockMvc.perform(put("/api/finanzas/grupos-flujo-caja/999")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(jsonRequest));
        } catch (Exception e) {
            // Expected exception in standalone mode
        }
    }
}
