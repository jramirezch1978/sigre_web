package pe.restaurant.compras.controller;

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
import org.springframework.context.annotation.Import;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.compras.config.ComprasJwtAuthenticationFilter;
import pe.restaurant.compras.dto.CotizacionDetalleResponse;
import pe.restaurant.compras.service.CotizacionService;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.exception.GlobalExceptionHandler;
import pe.restaurant.common.filter.RequestLoggingFilter;
import pe.restaurant.common.tenant.TenantContextWebFilter;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(
        controllers = CotizacionController.class,
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
@DisplayName("CotizacionController - WebMvc")
class CotizacionControllerWebMvcTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private CotizacionService cotizacionService;


    @Test
    @DisplayName("crear() responde 201 y serializa monto")
    void crear_responde201YSerializaMonto() throws Exception {
        CotizacionDetalleResponse response = CotizacionDetalleResponse.builder()
                .id(8L)
                .proveedorId(10L)
                .fecha(LocalDate.of(2026, 5, 23))
                .total(new BigDecimal("125.50"))
                .flagEstado("1")
                .build();
        when(cotizacionService.crear(any())).thenReturn(response);

        String body = """
                {
                  "proveedorId": 10,
                  "fecha": "2026-05-23",
                  "lineas": [
                    { "articuloId": 1, "cantidad": 2, "precioUnitario": 62.75 }
                  ]
                }
                """;

        mockMvc.perform(post("/api/compras/cotizaciones")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(8))
                .andExpect(jsonPath("$.data.total").value(125.50));
    }

    @Test
    @DisplayName("crear() body invalido responde 400")
    void crear_bodyInvalido_responde400() throws Exception {
        String body = """
                {
                  "fecha": "2026-05-23",
                  "lineas": [
                    { "articuloId": 1, "cantidad": 0, "precioUnitario": 0 }
                  ]
                }
                """;

        mockMvc.perform(post("/api/compras/cotizaciones")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("VALIDATION_ERROR"));
    }

    @Test
    @DisplayName("convertirOc() traduce conflicto de negocio")
    void convertirOc_traduceConflictoDeNegocio() throws Exception {
        when(cotizacionService.convertirOc(eq(4L), any()))
                .thenThrow(new BusinessException("La cotizacion no esta seleccionada", HttpStatus.CONFLICT, "COM-901"));

        String body = """
                {
                  "fechaEmision": "2026-05-23",
                  "fechaEntrega": "2026-05-30"
                }
                """;

        mockMvc.perform(post("/api/compras/cotizaciones/{id}/convertir-oc", 4L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("COM-901"));
    }

    @Test
    @DisplayName("comparativo() expone 400 cuando falta parametro obligatorio")
    void comparativo_faltaParametroObligatorio_responde400() throws Exception {
        mockMvc.perform(get("/api/compras/cotizaciones/comparativo"))
                .andExpect(status().isBadRequest());
    }
}
