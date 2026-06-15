package com.sigre.rrhh.controller;

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
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import com.sigre.common.exception.GlobalExceptionHandler;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.AsistenciaImportarRequest;
import com.sigre.rrhh.dto.request.AsistenciaRegularizarRequest;
import com.sigre.rrhh.dto.request.AsistenciaRequest;
import com.sigre.rrhh.dto.request.ProcesarPeriodoRequest;
import com.sigre.rrhh.mapper.AsistenciaMapper;
import com.sigre.rrhh.service.AsistenciaService;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import static org.hamcrest.Matchers.hasSize;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - AsistenciaController")
class AsistenciaControllerTest {

    @Mock private AsistenciaService service;
    @Mock private AsistenciaMapper mapper;

    @InjectMocks private AsistenciaController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
                .setControllerAdvice(new GlobalExceptionHandler())
                .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
                .setMessageConverters(new MappingJackson2HttpMessageConverter(objectMapper), new ByteArrayHttpMessageConverter())
                .build();
    }

    @Test
    @DisplayName("GET /api/rrhh/asistencias -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        when(service.listar(any(), any(), any(), any(), any())).thenAnswer(invocation -> {
            Pageable p = invocation.getArgument(4);
            return new PageImpl<>(List.of(RrhhTestFixtures.asistencia(1L)), p, 1);
        });
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.asistenciaResponse(1L));

        mockMvc.perform(get("/api/rrhh/asistencias")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    @Test
    @DisplayName("GET /api/rrhh/asistencias/{id} -> retorna entidad")
    void obtener_idExistente_retornaEntidad() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.asistencia(1L));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.asistenciaResponse(1L));

        mockMvc.perform(get("/api/rrhh/asistencias/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("POST /api/rrhh/asistencias -> crea exitosamente")
    void crear_datosValidos_creaExitosamente() throws Exception {
        AsistenciaRequest request = RrhhTestFixtures.asistenciaRequest();
        when(service.crear(any())).thenReturn(RrhhTestFixtures.asistencia(1L));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.asistenciaResponse(1L));

        mockMvc.perform(post("/api/rrhh/asistencias")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("PUT /api/rrhh/asistencias/{id} -> actualiza exitosamente")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        AsistenciaRequest request = RrhhTestFixtures.asistenciaRequest();
        when(service.actualizar(eq(1L), any())).thenReturn(RrhhTestFixtures.asistencia(1L));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.asistenciaResponse(1L));

        mockMvc.perform(put("/api/rrhh/asistencias/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));
    }

    @Test
    @DisplayName("POST /api/rrhh/asistencias/{id}/anular -> anula registro")
    void anular_idExistente_anula() throws Exception {
        doNothing().when(service).anular(1L);

        mockMvc.perform(post("/api/rrhh/asistencias/{id}/anular", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));
    }

    // ══════════════════════════════════════════════════════════════
    //  TRANSICIONES DE ESTADO
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("POST /api/rrhh/asistencias/{id}/aprobar -> aprueba registro")
    void aprobar_idExistente_apruebaExitosamente() throws Exception {
        when(service.aprobar(1L)).thenReturn(RrhhTestFixtures.asistencia(1L));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.asistenciaResponse(1L));

        mockMvc.perform(post("/api/rrhh/asistencias/{id}/aprobar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).aprobar(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/asistencias/{id}/rechazar -> rechaza registro")
    void rechazar_idExistente_rechazaExitosamente() throws Exception {
        when(service.rechazar(1L)).thenReturn(RrhhTestFixtures.asistencia(1L));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.asistenciaResponse(1L));

        mockMvc.perform(post("/api/rrhh/asistencias/{id}/rechazar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).rechazar(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/asistencias/{id}/regularizar -> regulariza registro")
    void regularizar_datosValidos_regularizaExitosamente() throws Exception {
        AsistenciaRegularizarRequest request = new AsistenciaRegularizarRequest(
                LocalTime.of(8, 30), LocalTime.of(17, 30), "Retardo justificado");
        when(service.regularizar(eq(1L), any())).thenReturn(RrhhTestFixtures.asistencia(1L));
        when(mapper.toResponse(any())).thenReturn(RrhhTestFixtures.asistenciaResponse(1L));

        mockMvc.perform(post("/api/rrhh/asistencias/{id}/regularizar", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).regularizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/asistencias/{id}/desactivar -> desactiva registro")
    void desactivar_idExistente_desactivaExitosamente() throws Exception {
        when(service.desactivar(1L)).thenReturn(RrhhTestFixtures.asistenciaResponse(1L));

        mockMvc.perform(patch("/api/rrhh/asistencias/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).desactivar(1L);
    }

    // ══════════════════════════════════════════════════════════════
    //  IMPORTACIÓN / EXPORTACIÓN / PROCESAR
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("POST /api/rrhh/asistencias/importar -> importa batch")
    void importar_datosValidos_importaExitosamente() throws Exception {
        AsistenciaImportarRequest request = new AsistenciaImportarRequest(
                List.of(new AsistenciaImportarRequest.AsistenciaImportRow(1L, LocalDate.now(), null, null, null)));
        when(service.importar(any())).thenReturn(List.of(RrhhTestFixtures.asistenciaResponse(1L)));

        mockMvc.perform(post("/api/rrhh/asistencias/importar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data", hasSize(1)));

        verify(service).importar(any());
    }

    @Test
    @DisplayName("GET /api/rrhh/asistencias/exportar -> descarga Excel")
    void exportar_retornaExcel() throws Exception {
        when(service.exportarExcel(any(), any())).thenReturn(new byte[]{1, 2, 3});

        mockMvc.perform(get("/api/rrhh/asistencias/exportar")
                        .param("fechaDesde", "2026-01-01")
                        .param("fechaHasta", "2026-12-31"))
                .andExpect(status().isOk())
                .andExpect(header().string(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=asistencias.xlsx"))
                .andExpect(content().contentType(
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));

        verify(service).exportarExcel(any(), any());
    }

    @Test
    @DisplayName("POST /api/rrhh/asistencias/procesar -> procesa período")
    void procesarPeriodo_datosValidos_procesaExitosamente() throws Exception {
        ProcesarPeriodoRequest request = new ProcesarPeriodoRequest(
                LocalDate.of(2026, 1, 1), LocalDate.of(2026, 1, 31));
        doNothing().when(service).procesarPeriodo(any(), any());

        mockMvc.perform(post("/api/rrhh/asistencias/procesar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).procesarPeriodo(any(), any());
    }
}
