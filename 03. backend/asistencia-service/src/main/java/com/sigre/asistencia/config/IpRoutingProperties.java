package com.sigre.asistencia.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

/**
 * Mapeo de IPs fijas de equipos marcadores a la pantalla de asistencia que
 * debe cargarse por defecto (garita → simplificado, producción → área de producción).
 * Configurable vía application.yml / config-server sin necesidad de recompilar.
 */
@Component
@ConfigurationProperties(prefix = "asistencia.ip-routing")
@Data
public class IpRoutingProperties {

    /** IPs de garita (entrada/salida) que deben abrir el marcaje simplificado de Puerta Principal. */
    private List<String> puertaPrincipalSimplificado = new ArrayList<>();

    /** IPs de los puestos de producción (bajo/alto riesgo) que deben abrir el marcaje de Área de Producción. */
    private List<String> areaProduccion = new ArrayList<>();
}
