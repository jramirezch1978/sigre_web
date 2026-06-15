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
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.converter.ByteArrayHttpMessageConverter;
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import com.sigre.common.exception.GlobalExceptionHandler;
import com.sigre.rrhh.RrhhTestFixtures;
import com.sigre.rrhh.dto.request.ProgramVacacionCreateRequest;
import com.sigre.rrhh.dto.request.ProgramVacacionImportarRequest;
import com.sigre.rrhh.dto.request.ProgramVacacionUpdateRequest;
import com.sigre.rrhh.dto.response.ProgramVacacionResponse;
import com.sigre.rrhh.service.ProgramVacacionService;

import java.util.List;

import static org.hamcrest.Matchers.hasSize;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - ProgramVacacionController")
class ProgramVacacionControllerTest {

    @Mock
    private ProgramVacacionService service;

    @InjectMocks
    private ProgramVacacionController controller;

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
    @DisplayName("GET /api/rrhh/vacaciones/programacion -> retorna lista paginada")
    void listar_retornaListaPaginada() throws Exception {
        Page<ProgramVacacionResponse> page = new PageImpl<>(List.of(
                RrhhTestFixtures.programVacacionResponse(1L)
        ));
        when(service.listar(any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/vacaciones/programacion")
                        .param("page", "0")
                        .param("size", "10"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.content", hasSize(1)))
                .andExpect(jsonPath("$.data.content[0].id").value(1));

        verify(service).listar(any(), any(), any());
    }

    @Test
    @DisplayName("GET /api/rrhh/vacaciones/programacion/{id} -> retorna programación")
    void obtenerPorId_idExistente_retornaProgramacion() throws Exception {
        when(service.obtenerPorId(1L)).thenReturn(RrhhTestFixtures.programVacacionResponse(1L));

        mockMvc.perform(get("/api/rrhh/vacaciones/programacion/{id}", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("POST /api/rrhh/vacaciones/programacion -> crea programación")
    void crear_datosValidos_creaExitosamente() throws Exception {
        ProgramVacacionCreateRequest request = RrhhTestFixtures.programVacacionCreateRequest();
        when(service.crear(any())).thenReturn(RrhhTestFixtures.programVacacionResponse(1L));

        mockMvc.perform(post("/api/rrhh/vacaciones/programacion")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).crear(any());
    }

    @Test
    @DisplayName("PUT /api/rrhh/vacaciones/programacion/{id} -> actualiza programación")
    void actualizar_datosValidos_actualizaExitosamente() throws Exception {
        ProgramVacacionUpdateRequest request = RrhhTestFixtures.programVacacionUpdateRequest();
        when(service.actualizar(eq(1L), any())).thenReturn(RrhhTestFixtures.programVacacionResponse(1L));

        mockMvc.perform(put("/api/rrhh/vacaciones/programacion/{id}", 1L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(1));

        verify(service).actualizar(eq(1L), any());
    }

    @Test
    @DisplayName("PATCH /api/rrhh/vacaciones/programacion/{id}/desactivar -> desactiva")
    void desactivar_idExistente_desactiva() throws Exception {
        when(service.desactivar(1L)).thenReturn(RrhhTestFixtures.programVacacionResponse(1L));

        mockMvc.perform(patch("/api/rrhh/vacaciones/programacion/{id}/desactivar", 1L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true));

        verify(service).desactivar(1L);
    }

    // ══════════════════════════════════════════════════════════════
    //  IMPORTACIÓN / EXPORTACIÓN
    // ══════════════════════════════════════════════════════════════

    @Test
    @DisplayName("POST /api/rrhh/vacaciones/programacion/importar -> importa batch")
    void importar_datosValidos_importaExitosamente() throws Exception {
        ProgramVacacionImportarRequest request = new ProgramVacacionImportarRequest(
                2026,
                List.of(new ProgramVacacionImportarRequest.ProgramVacacionImportRow(1L, 3, 15, "Vacaciones programadas"))
        );
        when(service.importar(any())).thenReturn(List.of(RrhhTestFixtures.programVacacionResponse(1L)));

        mockMvc.perform(post("/api/rrhh/vacaciones/programacion/importar")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data", hasSize(1)));

        verify(service).importar(any());
    }

    @Test
    @DisplayName("GET /api/rrhh/vacaciones/programacion/exportar -> descarga Excel")
    void exportar_retornaExcel() throws Exception {
        when(service.exportarExcel(any())).thenReturn(new byte[]{1, 2, 3});

        mockMvc.perform(get("/api/rrhh/vacaciones/programacion/exportar")
                        .param("anio", "2026"))
                .andExpect(status().isOk())
                .andExpect(header().string(HttpHeaders.CONTENT_DISPOSITION,
                        "attachment; filename=programacion-vacaciones.xlsx"))
                .andExpect(content().contentType(
                        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));

        verify(service).exportarExcel(any());
    }
}
