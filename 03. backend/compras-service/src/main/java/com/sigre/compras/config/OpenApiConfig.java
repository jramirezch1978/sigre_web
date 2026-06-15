package com.sigre.compras.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.tags.Tag;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.List;

@Configuration
public class OpenApiConfig {

    @Bean
    public OpenAPI comprasOpenAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("compras-service API")
                        .description("Microservicio de Compras - SIGRE ERP. "
                                + "Gestión de órdenes de compra, órdenes de servicio, cotizaciones, "
                                + "solicitudes de compra, programación de compras, contratos marco y actas de conformidad.")
                        .version("1.0.0"))
                .tags(List.of(
                        new Tag().name("Ordenes de Compra").description("CRUD y ciclo de vida de OC"),
                        new Tag().name("Ordenes de Servicio").description("CRUD y ciclo de vida de OS"),
                        new Tag().name("Cotizaciones").description("Registro, comparativo y conversión a OC"),
                        new Tag().name("Solicitudes de Compra").description("Solicitudes internas y conversión"),
                        new Tag().name("Programacion de Compras").description("Planificación mensual"),
                        new Tag().name("Contratos Marco").description("Gestión de contratos con proveedores"),
                        new Tag().name("Actas de Conformidad").description("Conformidad de servicios"),
                        new Tag().name("Maestros - Aprobadores").description("Configuración de aprobadores"),
                        new Tag().name("Maestros - Compradores").description("Compradores y categorías"),
                        new Tag().name("Maestros - Precios Pactados").description("Precios pactados por artículo/proveedor"),
                        new Tag().name("Maestros - Articulo Estructura").description("Estructura padre-hijo de artículos"),
                        new Tag().name("Maestros - Servicios Catalogo").description("Catálogo de servicios"),
                        new Tag().name("Maestros - Tipos Entidad").description("Clasificación de entidades")
                ));
    }
}
