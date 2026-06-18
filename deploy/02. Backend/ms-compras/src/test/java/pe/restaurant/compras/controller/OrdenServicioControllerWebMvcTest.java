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
import pe.restaurant.compras.dto.DatosServicioResponse;
import pe.restaurant.compras.dto.OrdenServicioDetalleResponse;
import pe.restaurant.compras.service.OrdenServicioPdfService;
import pe.restaurant.compras.service.OrdenServicioService;
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
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.header;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(
        controllers = OrdenServicioController.class,
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
@DisplayName("OrdenServicioController - WebMvc")
class OrdenServicioControllerWebMvcTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private OrdenServicioService ordenServicioService;

    @MockBean
    private OrdenServicioPdfService ordenServicioPdfService;


    @Test
    @DisplayName("crear() responde 201 y devuelve numero")
    void crear_responde201YDevuelveNumero() throws Exception {
        OrdenServicioDetalleResponse response = OrdenServicioDetalleResponse.builder()
                .id(21L)
                .nroOs("OS-000021")
                .sucursalId(1L)
                .proveedorId(2L)
                .fecRegistro(LocalDate.of(2026, 5, 23))
                .monedaId(1L)
                .montoTotal(new BigDecimal("700.00"))
                .build();
        when(ordenServicioService.crear(any())).thenReturn(response);

        String body = """
                {
                  "sucursalId": 1,
                  "codOrigen": "OS",
                  "proveedorId": 2,
                  "fecRegistro": "2026-05-23",
                  "monedaId": 1,
                  "lineas": [
                    {
                      "servicioId": 5,
                      "fecProyect": "2026-05-30",
                      "importe": 700.00
                    }
                  ]
                }
                """;

        mockMvc.perform(post("/api/compras/ordenes-servicio")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(21))
                .andExpect(jsonPath("$.data.nroOs").value("OS-000021"));
    }

    @Test
    @DisplayName("crear() body invalido responde 400")
    void crear_bodyInvalido_responde400() throws Exception {
        String body = """
                {
                  "sucursalId": 1,
                  "proveedorId": 2,
                  "lineas": []
                }
                """;

        mockMvc.perform(post("/api/compras/ordenes-servicio")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("VALIDATION_ERROR"));
    }

    @Test
    @DisplayName("aprobar() traduce conflicto de negocio")
    void aprobar_traduceConflictoDeNegocio() throws Exception {
        when(ordenServicioService.aprobar(eq(11L), eq("Duplicada")))
                .thenThrow(new BusinessException("La orden de servicio ya fue aprobada", HttpStatus.CONFLICT, "COM-OS-1"));

        mockMvc.perform(post("/api/compras/ordenes-servicio/{id}/aprobar", 11L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"observacion\":\"Duplicada\"}"))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("COM-OS-1"));
    }

    @Test
    @DisplayName("pdf() responde attachment application/pdf")
    void pdf_respondeAttachmentApplicationPdf() throws Exception {
        when(ordenServicioPdfService.generarPdf(7L)).thenReturn(new byte[]{9, 8, 7});

        mockMvc.perform(get("/api/compras/ordenes-servicio/{id}/pdf", 7L))
                .andExpect(status().isOk())
                .andExpect(header().string("Content-Disposition", "attachment; filename=OS-7.pdf"))
                .andExpect(content().contentType(MediaType.APPLICATION_PDF))
                .andExpect(content().bytes(new byte[]{9, 8, 7}));
    }

    @Test
    @DisplayName("datosServicio() expone parametros en GET")
    void datosServicio_exponeParametrosEnGet() throws Exception {
        when(ordenServicioService.datosServicio(5L, 2L, 1L, 1L))
                .thenReturn(DatosServicioResponse.builder()
                        .servicioId(5L)
                        .precioPactado(new BigDecimal("90.00"))
                        .build());

        mockMvc.perform(get("/api/compras/ordenes-servicio/datos-servicio")
                        .param("servicioId", "5")
                        .param("proveedorId", "2")
                        .param("monedaId", "1")
                        .param("sucursalId", "1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.precioPactado").value(90.00));
    }
}
