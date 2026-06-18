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
import pe.restaurant.rrhh.dto.request.PermisoLicenciaCreateRequest;
import pe.restaurant.rrhh.dto.request.PermisoLicenciaUpdateRequest;
import pe.restaurant.rrhh.dto.response.PermisoLicenciaResponse;
import pe.restaurant.rrhh.service.PermisoLicenciaService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - PermisoLicenciaController")
class PermisoLicenciaControllerTest {

    @Mock
    private PermisoLicenciaService service;

    @InjectMocks
    private PermisoLicenciaController controller;

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
    @DisplayName("GET /api/rrhh/permisos-licencias -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<PermisoLicenciaResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.permisoLicenciaResponse(1L)
        ));
        when(service.listar(any(), any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/permisos-licencias")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)));

        verify(service).listar(any(), any(), any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/permisos-licencias/{id} -> retorna permiso")
    void obtenerPorId_idExistente_retornaPermiso() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        mockMvc.perform(get("/api/rrhh/permisos-licencias/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias -> crea permiso")
    void crear_datosValidos_creaExitosamente() throws Exception {
        PermisoLicenciaCreateRequest request = RrhhTestFixtures.permisoLicenciaCreateRequest();
        when(service.crear(any())).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        mockMvc.perform(post("/api/rrhh/permisos-licencias")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/permisos-licencias/{id} -> actualiza permiso")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        PermisoLicenciaUpdateRequest request = RrhhTestFixtures.permisoLicenciaUpdateRequest();
        when(service.actualizar(eq(1L), any())).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        mockMvc.perform(put("/api/rrhh/permisos-licencias/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias/{id}/aprobar -> aprueba permiso")
    void aprobar_idExistente_aprueba() throws Exception {
        when(service.aprobar(1L)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        mockMvc.perform(post("/api/rrhh/permisos-licencias/{id}/aprobar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias/{id}/rechazar -> rechaza permiso")
    void rechazar_idExistente_rechaza() throws Exception {
        when(service.rechazar(1L)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        mockMvc.perform(post("/api/rrhh/permisos-licencias/{id}/rechazar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("PATCH /api/rrhh/permisos-licencias/{id}/desactivar -> desactiva permiso")
    void desactivar_idExistente_desactivaExitosamente() throws Exception {
        when(service.desactivar(1L)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        mockMvc.perform(patch("/api/rrhh/permisos-licencias/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).desactivar(1L);
    }

    @Test
    @DisplayName("GET /api/rrhh/permisos-licencias/bandeja-aprobacion -> lista pendientes")
    void listarBandeja_retornaLista() throws Exception {
        when(service.listarBandeja()).thenReturn(List.of(RrhhTestFixtures.permisoLicenciaResponse(1L)));

        mockMvc.perform(get("/api/rrhh/permisos-licencias/bandeja-aprobacion"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data", hasSize(1)));

        verify(service).listarBandeja();
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias/{id}/observar -> observa permiso")
    void observar_idExistente_observa() throws Exception {
        when(service.observar(1L)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        mockMvc.perform(post("/api/rrhh/permisos-licencias/{id}/observar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias/{id}/anular -> anula permiso")
    void anular_idExistente_anula() throws Exception {
        when(service.anular(1L)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        mockMvc.perform(post("/api/rrhh/permisos-licencias/{id}/anular", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias/{id}/cerrar -> cierra permiso")
    void cerrar_idExistente_cierra() throws Exception {
        when(service.cerrar(1L)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        mockMvc.perform(post("/api/rrhh/permisos-licencias/{id}/cerrar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias/{id}/procesar -> procesa permiso individual")
    void procesar_idExistente_procesa() throws Exception {
        when(service.procesar(1L)).thenReturn(RrhhTestFixtures.permisoLicenciaResponse(1L));

        mockMvc.perform(post("/api/rrhh/permisos-licencias/{id}/procesar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("POST /api/rrhh/permisos-licencias/procesar -> procesa batch")
    void procesarBatch_procesaExitosamente() throws Exception {
        doNothing().when(service).procesarBatch();

        mockMvc.perform(post("/api/rrhh/permisos-licencias/procesar"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).procesarBatch();
    }
}
