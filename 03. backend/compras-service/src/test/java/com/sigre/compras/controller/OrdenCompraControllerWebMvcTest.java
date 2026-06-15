package com.sigre.compras.controller;

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
import com.sigre.compras.config.ComprasJwtAuthenticationFilter;
import com.sigre.compras.dto.OrdenCompraDetalleResponse;
import com.sigre.compras.service.OrdenCompraPdfService;
import com.sigre.compras.service.OrdenCompraService;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.exception.GlobalExceptionHandler;
import com.sigre.common.filter.RequestLoggingFilter;
import com.sigre.common.tenant.TenantContextWebFilter;

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
        controllers = OrdenCompraController.class,
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
@DisplayName("OrdenCompraController - WebMvc")
class OrdenCompraControllerWebMvcTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private OrdenCompraService ordenCompraService;

    @MockBean
    private OrdenCompraPdfService ordenCompraPdfService;


    @Test
    @DisplayName("crear() responde 201 y devuelve numero de documento")
    void crear_responde201YDevuelveNumero() throws Exception {
        OrdenCompraDetalleResponse response = OrdenCompraDetalleResponse.builder()
                .id(14L)
                .nroOrdenCompra("OC-000014")
                .sucursalId(1L)
                .proveedorId(2L)
                .fechaEmision(LocalDate.of(2026, 5, 23))
                .monedaId(1L)
                .total(new BigDecimal("250.75"))
                .build();
        when(ordenCompraService.crear(any())).thenReturn(response);

        String body = """
                {
                  "sucursalId": 1,
                  "proveedorId": 2,
                  "fechaEmision": "2026-05-23",
                  "monedaId": 1,
                  "lineas": [
                    {
                      "articuloId": 1,
                      "cantProyectada": 2,
                      "valorUnitario": 125.375,
                      "fechaEntrega": "2026-05-30"
                    }
                  ]
                }
                """;

        mockMvc.perform(post("/api/compras/ordenes-compra")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.id").value(14))
                .andExpect(jsonPath("$.data.nroOrdenCompra").value("OC-000014"));
    }

    @Test
    @DisplayName("crear() body invalido responde 400")
    void crear_bodyInvalido_responde400() throws Exception {
        String body = """
                {
                  "proveedorId": 2,
                  "lineas": []
                }
                """;

        mockMvc.perform(post("/api/compras/ordenes-compra")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(body))
                .andExpect(status().isBadRequest())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("VALIDATION_ERROR"));
    }

    @Test
    @DisplayName("aprobar() traduce conflicto de negocio")
    void aprobar_traduceConflictoDeNegocio() throws Exception {
        when(ordenCompraService.aprobar(eq(9L), eq("Fuera de rango")))
                .thenThrow(new BusinessException("El monto de la OC esta fuera del rango autorizado", HttpStatus.CONFLICT, "COM-023"));

        mockMvc.perform(post("/api/compras/ordenes-compra/{id}/aprobar", 9L)
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("{\"observacion\":\"Fuera de rango\"}"))
                .andExpect(status().isConflict())
                .andExpect(jsonPath("$.success").value(false))
                .andExpect(jsonPath("$.errorCode").value("COM-023"));
    }

    @Test
    @DisplayName("pdf() responde attachment application/pdf")
    void pdf_respondeAttachmentApplicationPdf() throws Exception {
        when(ordenCompraPdfService.generarPdf(5L)).thenReturn(new byte[]{1, 2, 3});

        mockMvc.perform(post("/api/compras/ordenes-compra/{id}/pdf", 5L))
                .andExpect(status().isOk())
                .andExpect(header().string("Content-Disposition", "attachment; filename=OC-5.pdf"))
                .andExpect(content().contentType(MediaType.APPLICATION_PDF))
                .andExpect(content().bytes(new byte[]{1, 2, 3}));
    }

    @Test
    @DisplayName("datosArticulo() expone parametros en GET")
    void datosArticulo_exponeParametrosEnGet() throws Exception {
        when(ordenCompraService.datosArticulo(eq(1L), eq(2L), eq(1L), eq(1L), eq(LocalDate.of(2026, 5, 23))))
                .thenReturn(com.sigre.compras.dto.DatosArticuloResponse.builder()
                        .precioPactado(new BigDecimal("80.00"))
                        .unidadMedidaId(7L)
                        .build());

        mockMvc.perform(get("/api/compras/ordenes-compra/datos-articulo")
                        .param("articuloId", "1")
                        .param("proveedorId", "2")
                        .param("monedaId", "1")
                        .param("sucursalId", "1")
                        .param("fechaEmision", "2026-05-23"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.success").value(true))
                .andExpect(jsonPath("$.data.precioPactado").value(80.00));
    }
}
