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
import org.springframework.data.domain.PageRequest;
import org.springframework.data.web.PageableHandlerMethodArgumentResolver;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import com.sigre.rrhh.dto.request.ConceptoPlanillaCreateRequest;
import com.sigre.rrhh.dto.request.ConceptoPlanillaUpdateRequest;
import com.sigre.rrhh.dto.response.ConceptoPlanillaResponse;
import com.sigre.rrhh.service.ConceptoPlanillaService;

import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static com.sigre.rrhh.constants.ConceptoPlanillaConstants.*;

/**
 * Tests unitarios para ConceptoPlanillaController.
 * Usa MockMvc standalone sin levantar el contexto de Spring.
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Pruebas Unitarias - ConceptoPlanillaController")
class ConceptoPlanillaControllerTest {

    @Mock
    private ConceptoPlanillaService service;

    @InjectMocks
    private ConceptoPlanillaController controller;

    private MockMvc mockMvc;
    private ObjectMapper objectMapper;

    @BeforeEach
    void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(controller)
            .setCustomArgumentResolvers(new PageableHandlerMethodArgumentResolver())
            .build();
        objectMapper = new ObjectMapper();
        objectMapper.registerModule(new JavaTimeModule());
    }

    // ==== listar ====

    @Test
    @DisplayName("listar() debe invocar service y retornar página")
    void listar_debeInvocarServiceYRetornarPagina() throws Exception {
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();
        response.setId(1L);
        response.setCodigo("ING-001");
        Page<ConceptoPlanillaResponse> page = new PageImpl<>(List.of(response));

        when(service.listar(any(), any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/conceptos-planilla")
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk());

        verify(service).listar(any(), any(), any(), any(), any());
    }

    @Test
    @DisplayName("listar() con filtros debe invocar service")
    void listar_conFiltros_debeInvocarService() throws Exception {
        Page<ConceptoPlanillaResponse> page = new PageImpl<>(List.of());

        when(service.listar(any(), any(), any(), any(), any())).thenReturn(page);

        mockMvc.perform(get("/api/rrhh/conceptos-planilla")
                .param("codigo", "ING")
                .param("nombre", "Sueldo")
                .param("tipo", TIPO_INGRESO)
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk());

        verify(service).listar(any(), any(), any(), any(), any());
    }

    // ==== obtenerPorId ====

    @Test
    @DisplayName("obtenerPorId() debe invocar service y retornar concepto")
    void obtenerPorId_debeInvocarServiceYRetornarConcepto() throws Exception {
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();
        response.setId(1L);
        response.setCodigo("ING-001");

        when(service.obtenerPorId(1L)).thenReturn(response);

        mockMvc.perform(get("/api/rrhh/conceptos-planilla/{id}", 1L))
            .andExpect(status().isOk());

        verify(service).obtenerPorId(1L);
    }

    // ==== crear ====

    @Test
    @DisplayName("crear() debe invocar service y retornar 201")
    void crear_debeInvocarServiceYRetornar201() throws Exception {
        ConceptoPlanillaCreateRequest request = new ConceptoPlanillaCreateRequest();
        request.setCodigo("ING-001");
        request.setNombre("Sueldo Básico");
        request.setTipo(TIPO_INGRESO);
        request.setAfectoQuinta(true);
        request.setAfectoEssalud(true);
        request.setAplicaTodos(true);

        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();
        response.setId(1L);

        when(service.crear(any())).thenReturn(response);

        mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated());

        verify(service).crear(any());
    }

    // ==== actualizar ====

    @Test
    @DisplayName("actualizar() debe invocar service y retornar 200")
    void actualizar_debeInvocarServiceYRetornar200() throws Exception {
        ConceptoPlanillaUpdateRequest request = new ConceptoPlanillaUpdateRequest();
        request.setNombre("Sueldo Básico Actualizado");
        request.setTipo(TIPO_INGRESO);
        request.setAfectoQuinta(true);
        request.setAfectoEssalud(true);
        request.setAplicaTodos(true);

        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();
        response.setId(1L);

        when(service.actualizar(any(), any())).thenReturn(response);

        mockMvc.perform(put("/api/rrhh/conceptos-planilla/{id}", 1L)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk());

        verify(service).actualizar(any(), any());
    }

    // ==== eliminar ====

    @Test
    @DisplayName("desactivar() debe invocar service y retornar 200")
    void desactivar_debeInvocarServiceYRetornar200() throws Exception {
        mockMvc.perform(patch("/api/rrhh/conceptos-planilla/{id}/desactivar", 1L))
            .andExpect(status().isOk());

        verify(service).desactivar(1L);
    }
}
