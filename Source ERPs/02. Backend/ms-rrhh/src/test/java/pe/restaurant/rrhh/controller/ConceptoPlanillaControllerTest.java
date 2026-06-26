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
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import pe.restaurant.rrhh.dto.request.ConceptoPlanillaCreateRequest;
import pe.restaurant.rrhh.dto.request.ConceptoPlanillaUpdateRequest;
import pe.restaurant.rrhh.dto.response.ConceptoPlanillaResponse;
import pe.restaurant.rrhh.service.ConceptoPlanillaService;

import java.math.BigDecimal;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

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

    @Test
    @DisplayName("listar() debe invocar service y retornar página")
    void listar_debeInvocarServiceYRetornarPagina() throws Exception {
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();
        response.setId(1L);
        response.setCodigo("1013");
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
                .param("codigo", "1013")
                .param("nombre", "PRIMA")
                .param("grupoCalculo", "10")
                .param("page", "0")
                .param("size", "10"))
            .andExpect(status().isOk());

        verify(service).listar(any(), any(), any(), any(), any());
    }

    @Test
    @DisplayName("obtenerPorId() debe invocar service y retornar concepto")
    void obtenerPorId_debeInvocarServiceYRetornarConcepto() throws Exception {
        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();
        response.setId(1L);
        response.setCodigo("1013");

        when(service.obtenerPorId(1L)).thenReturn(response);

        mockMvc.perform(get("/api/rrhh/conceptos-planilla/{id}", 1L))
            .andExpect(status().isOk());

        verify(service).obtenerPorId(1L);
    }

    @Test
    @DisplayName("crear() debe invocar service y retornar 201")
    void crear_debeInvocarServiceYRetornar201() throws Exception {
        ConceptoPlanillaCreateRequest request = crearRequestSigre();

        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();
        response.setId(1L);

        when(service.crear(any())).thenReturn(response);

        mockMvc.perform(post("/api/rrhh/conceptos-planilla")
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isCreated());

        verify(service).crear(any());
    }

    @Test
    @DisplayName("actualizar() debe invocar service y retornar 200")
    void actualizar_debeInvocarServiceYRetornar200() throws Exception {
        ConceptoPlanillaUpdateRequest request = crearUpdateRequestSigre();

        ConceptoPlanillaResponse response = new ConceptoPlanillaResponse();
        response.setId(1L);

        when(service.actualizar(any(), any())).thenReturn(response);

        mockMvc.perform(put("/api/rrhh/conceptos-planilla/{id}", 1L)
                .contentType(MediaType.APPLICATION_JSON)
                .content(objectMapper.writeValueAsString(request)))
            .andExpect(status().isOk());

        verify(service).actualizar(any(), any());
    }

    @Test
    @DisplayName("desactivar() debe invocar service y retornar 200")
    void desactivar_debeInvocarServiceYRetornar200() throws Exception {
        mockMvc.perform(patch("/api/rrhh/conceptos-planilla/{id}/desactivar", 1L))
            .andExpect(status().isOk());

        verify(service).desactivar(1L);
    }

    private ConceptoPlanillaCreateRequest crearRequestSigre() {
        ConceptoPlanillaCreateRequest request = new ConceptoPlanillaCreateRequest();
        request.setCodigo("1013");
        request.setNombre("PRIMA DE FRIO");
        request.setDescripcionBreve("PRIMA DE FRIO");
        request.setGrupoCalculo("10");
        request.setFactorPago(BigDecimal.ONE);
        request.setImporteTopeMin(BigDecimal.ZERO);
        request.setImporteTopeMax(BigDecimal.ZERO);
        request.setFlagReplicacion("1");
        request.setFlagSubsidio("0");
        request.setFlagReporteQuinta("0");
        return request;
    }

    private ConceptoPlanillaUpdateRequest crearUpdateRequestSigre() {
        ConceptoPlanillaUpdateRequest request = new ConceptoPlanillaUpdateRequest();
        request.setNombre("PRIMA DE FRIO ACTUALIZADA");
        request.setGrupoCalculo("10");
        request.setFactorPago(BigDecimal.ONE);
        request.setImporteTopeMin(BigDecimal.ZERO);
        request.setImporteTopeMax(BigDecimal.ZERO);
        request.setFlagReplicacion("1");
        request.setFlagSubsidio("0");
        request.setFlagReporteQuinta("0");
        return request;
    }
}
