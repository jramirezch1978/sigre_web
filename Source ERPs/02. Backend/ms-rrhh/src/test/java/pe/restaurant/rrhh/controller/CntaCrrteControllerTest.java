package pe.restaurant.rrhh.controller;

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
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import pe.restaurant.common.exception.GlobalExceptionHandler;
import pe.restaurant.rrhh.RrhhTestFixtures;
import pe.restaurant.rrhh.dto.request.CntaCrrteCreateRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteMovimientoRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteMovimientoUpdateRequest;
import pe.restaurant.rrhh.dto.request.CntaCrrteUpdateRequest;
import pe.restaurant.rrhh.dto.response.CntaCrrteResponse;
import pe.restaurant.rrhh.service.CntaCrrteService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - CntaCrrteController")
class CntaCrrteControllerTest {

    @Mock
    private CntaCrrteService service;

    @InjectMocks
    private CntaCrrteController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler())
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .setMessageConverters(new MappingJackson2HttpMessageConverter(objectMapper))
                .build();
    }

    @Test
    @DisplayName("GET /api/rrhh/cuentas-corrientes -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<CntaCrrteResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.cntaCrrteResponse(1L)
        ));
        when(service.listar(any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/cuentas-corrientes")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).listar(any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/cuentas-corrientes/{id} -> retorna cuenta")
    void obtenerPorId_idExistente_retornaCuenta() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.cntaCrrteResponse(1L));

        mockMvc.perform(get("/api/rrhh/cuentas-corrientes/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/cuentas-corrientes -> crea cuenta")
    void crear_datosValidos_creaExitosamente() throws Exception {
        CntaCrrteCreateRequest request = RrhhTestFixtures.cntaCrrteCreateRequest();
        when(service.crear(any())).thenReturn(RrhhTestFixtures.cntaCrrteResponse(1L));

        mockMvc.perform(post("/api/rrhh/cuentas-corrientes")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/cuentas-corrientes/{id} -> actualiza cuenta")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        CntaCrrteUpdateRequest request = RrhhTestFixtures.cntaCrrteUpdateRequest();
        when(service.actualizar(eq(1L), any())).thenReturn(RrhhTestFixtures.cntaCrrteResponse(1L));

        mockMvc.perform(put("/api/rrhh/cuentas-corrientes/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/cuentas-corrientes/{id}/estado -> cambia estado")
    void cambiarEstado_idExistente_cambiaEstado() throws Exception {
        when(service.cambiarEstado(1L)).thenReturn(RrhhTestFixtures.cntaCrrteResponse(1L));

        mockMvc.perform(patch("/api/rrhh/cuentas-corrientes/{id}/estado", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).cambiarEstado(1L);
    }

    @Test
    @DisplayName("GET /api/rrhh/cuentas-corrientes/{id}/movimientos -> lista movimientos")
    void listarMovimientos_retornaLista() throws Exception {
        when(service.listarMovimientos(1L)).thenReturn(List.of(
                RrhhTestFixtures.cntaCrrteDetResponse(1L)
        ));

        mockMvc.perform(get("/api/rrhh/cuentas-corrientes/{id}/movimientos", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data", hasSize(1)));

        verify(service).listarMovimientos(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/cuentas-corrientes/{id}/movimientos -> crea movimiento")
    void crearMovimiento_datosValidos_creaExitosamente() throws Exception {
        CntaCrrteMovimientoRequest request = RrhhTestFixtures.cntaCrrteMovimientoRequest();
        when(service.crearMovimiento(eq(1L), any())).thenReturn(RrhhTestFixtures.cntaCrrteDetResponse(1L));

        mockMvc.perform(post("/api/rrhh/cuentas-corrientes/{id}/movimientos", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).crearMovimiento(eq(1L), any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/cuentas-corrientes/{id}/movimientos/{mid} -> actualiza movimiento")
    void actualizarMovimiento_datosValidos_actualizaExitosamente() throws Exception {
        CntaCrrteMovimientoUpdateRequest request = RrhhTestFixtures.cntaCrrteMovimientoUpdateRequest();
        when(service.actualizarMovimiento(eq(1L), eq(2L), any())).thenReturn(RrhhTestFixtures.cntaCrrteDetResponse(1L));

        mockMvc.perform(put("/api/rrhh/cuentas-corrientes/{id}/movimientos/{mid}", 1L, 2L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).actualizarMovimiento(eq(1L), eq(2L), any());
    }

    @Test
    @DisplayName("DELETE /api/rrhh/cuentas-corrientes/{id}/movimientos/{mid} -> elimina movimiento")
    void eliminarMovimiento_eliminaExitosamente() throws Exception {
        doNothing().when(service).eliminarMovimiento(1L, 2L);

        mockMvc.perform(delete("/api/rrhh/cuentas-corrientes/{id}/movimientos/{mid}", 1L, 2L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).eliminarMovimiento(1L, 2L);
    }

    @Test
    @DisplayName("GET /api/rrhh/cuentas-corrientes/{id}/movimientos/{movimientoId} -> retorna movimiento")
    void obtenerMovimiento_idExistente_retornaMovimiento() throws Exception {
        when(service.obtenerMovimiento(1L, 2L)).thenReturn(RrhhTestFixtures.cntaCrrteDetResponse(1L));

        mockMvc.perform(get("/api/rrhh/cuentas-corrientes/{id}/movimientos/{movimientoId}", 1L, 2L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerMovimiento(1L, 2L);
    }
}
