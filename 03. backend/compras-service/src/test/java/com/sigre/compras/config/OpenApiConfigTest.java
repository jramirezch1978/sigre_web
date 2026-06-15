package com.sigre.compras.config;

import io.swagger.v3.oas.models.OpenAPI;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("OpenApiConfig — Pruebas Unitarias")
class OpenApiConfigTest {

    private final OpenApiConfig config = new OpenApiConfig();

    @Test
    @DisplayName("comprasOpenAPI() tiene titulo y version")
    void comprasOpenAPI_tieneTituloYVersion() {
        OpenAPI openAPI = config.comprasOpenAPI();

        assertThat(openAPI).isNotNull();
        assertThat(openAPI.getInfo().getTitle()).isEqualTo("compras-service API");
        assertThat(openAPI.getInfo().getVersion()).isEqualTo("1.0.0");
    }

    @Test
    @DisplayName("comprasOpenAPI() tiene descripción")
    void comprasOpenAPI_tieneDescripcion() {
        OpenAPI openAPI = config.comprasOpenAPI();

        assertThat(openAPI.getInfo().getDescription()).contains("Microservicio de Compras");
    }

    @Test
    @DisplayName("comprasOpenAPI() tiene 13 tags")
    void comprasOpenAPI_tiene13Tags() {
        OpenAPI openAPI = config.comprasOpenAPI();

        assertThat(openAPI.getTags()).hasSize(13);
    }

    @Test
    @DisplayName("comprasOpenAPI() tiene tag ordenes compra")
    void comprasOpenAPI_tieneTagOrdenesCompra() {
        OpenAPI openAPI = config.comprasOpenAPI();

        assertThat(openAPI.getTags())
                .extracting("name")
                .contains("Ordenes de Compra", "Ordenes de Servicio",
                        "Cotizaciones", "Solicitudes de Compra",
                        "Programacion de Compras", "Contratos Marco",
                        "Actas de Conformidad");
    }
}
