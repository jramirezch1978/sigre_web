package pe.restaurant.compras.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.ImportAutoConfiguration;
import org.springframework.boot.autoconfigure.jackson.JacksonAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.SecurityFilterAutoConfiguration;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.compras.config.ComprasJwtAuthenticationFilter;
import pe.restaurant.compras.dto.SolicitudCompraDetalleResponse;
import pe.restaurant.compras.service.SolicitudCompraService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.GlobalExceptionHandler;
import pe.restaurant.common.filter.RequestLoggingFilter;
import pe.restaurant.common.tenant.TenantContextWebFilter;

import java.time.LocalDate;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(
        controllers = SolicitudCompraController.class,
        excludeAutoConfiguration = {SecurityAutoConfiguration.class, SecurityFilterAutoConfiguration.class},
        excludeFilters = {
                @ComponentScan.Filter(type = org.springframework.context.annotation.FilterType.ASSIGNABLE_TYPE, classes = ComprasJwtAuthenticationFilter.class),
                @ComponentScan.Filter(type = org.springframework.context.annotation.FilterType.ASSIGNABLE_TYPE, classes = RequestLoggingFilter.class),
                @ComponentScan.Filter(type = org.springframework.context.annotation.FilterType.ASSIGNABLE_TYPE, classes = TenantContextWebFilter.class)
        }
)
@AutoConfigureMockMvc(addFilters = false)
@Import(GlobalExceptionHandler.class)
@ImportAutoConfiguration(JacksonAutoConfiguration.class)
@DisplayName("SolicitudCompraController - WebMvc")
class SolicitudCompraControllerWebMvcTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockBean
    private SolicitudCompraService solicitudCompraService;


    @Test
    @DisplayName("crear() responde 201 y payload JSON")
    void crear_responde201YPayloadJson() throws Exception {
        SolicitudCompraDetalleResponse response = SolicitudCompraDetalleResponse.builder()
                .id(10L)
                .numero("SC-010")
                .fecha(LocalDate.of(2026, 5, 23))
                .flagEstado("1")
                .build();
        when(solicitudCompraService.crear(any())).thenReturn(response);

        String body = """
                {
                  "fecha": "2026-05-23",
                  "lineas": [
                    { "articuloId": 1, "cantidad": 2.5 }
                  ]
                }
                """;

        mockMvc.perform(post("/api/compras/solicitudes-compra")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.message").value("Solicitud de compra creada"))
                .andExpect(jsonPath("$.data.id").value(10))
                .andExpect(jsonPath("$.data.numero").value("SC-010"));
    }

    @Test
    @DisplayName("crear() request invalido responde 400 con validation error")
    void crear_requestInvalido_responde400() throws Exception {
        String body = """
                {
                  "lineas": []
                }
                """;

        mockMvc.perform(post("/api/compras/solicitudes-compra")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("VALIDATION_ERROR"))
                .andExpect(jsonPath("$.data").isArray());
    }

    @Test
    @DisplayName("aprobar() traduce BusinessException a HTTP 409")
    void aprobar_businessException_responde409() throws Exception {
        when(solicitudCompraService.aprobar(eq(22L), eq("Duplicada")))
                .thenThrow(new BusinessException("La solicitud ya fue aprobada", HttpStatus.CONFLICT, "COM-777"));

        mockMvc.perform(post("/api/compras/solicitudes-compra/{id}/aprobar", 22L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(new pe.restaurant.compras.dto.OrdenCompraObservacionRequest() {{
                            setObservacion("Duplicada");
                        }})))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("COM-777"))
                .andExpect(jsonPath("$.message").value("La solicitud ya fue aprobada"));
    }

    @Test
    @DisplayName("obtener() expone recurso en GET")
    void obtener_exponeRecursoEnGet() throws Exception {
        SolicitudCompraDetalleResponse response = SolicitudCompraDetalleResponse.builder()
                .id(30L)
                .numero("SC-030")
                .flagEstado("1")
                .build();
        when(solicitudCompraService.obtener(30L)).thenReturn(response);

        mockMvc.perform(get("/api/compras/solicitudes-compra/{id}", 30L))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(30))
                .andExpect(jsonPath("$.data.numero").value("SC-030"));
    }
}
