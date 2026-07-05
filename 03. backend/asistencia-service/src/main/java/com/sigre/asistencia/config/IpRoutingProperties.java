package com.sigre.asistencia.config;

import jakarta.annotation.PostConstruct;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Mapeo de IPs fijas de equipos marcadores a la pantalla de asistencia que
 * debe cargarse por defecto (garita → simplificado, producción → área de producción).
 * Configurable vía application.yml, config-server o variables de entorno Docker.
 */
@Component
@ConfigurationProperties(prefix = "asistencia.ip-routing")
@Data
public class IpRoutingProperties {

    private static final String ENV_IPS_GARITA = "ASISTENCIA_IPS_GARITA";
    private static final String ENV_IPS_PRODUCCION = "ASISTENCIA_IPS_PRODUCCION";

    /** IPs de garita (entrada/salida) que deben abrir el marcaje simplificado de Puerta Principal. */
    private List<String> puertaPrincipalSimplificado = new ArrayList<>();

    /** IPs de los puestos de producción (bajo/alto riesgo) que deben abrir el marcaje de Área de Producción. */
    private List<String> areaProduccion = new ArrayList<>();

    /**
     * Permite sobrescribir las listas desde docker-compose sin recompilar:
     * ASISTENCIA_IPS_GARITA=192.168.30.61,192.168.30.62
     * ASISTENCIA_IPS_PRODUCCION=192.168.30.63,192.168.30.64
     */
    @PostConstruct
    void aplicarVariablesEntorno() {
        String ipsGarita = System.getenv(ENV_IPS_GARITA);
        if (ipsGarita != null && !ipsGarita.isBlank()) {
            puertaPrincipalSimplificado = parsearListaIps(ipsGarita);
        }
        String ipsProduccion = System.getenv(ENV_IPS_PRODUCCION);
        if (ipsProduccion != null && !ipsProduccion.isBlank()) {
            areaProduccion = parsearListaIps(ipsProduccion);
        }
        puertaPrincipalSimplificado = normalizarLista(puertaPrincipalSimplificado);
        areaProduccion = normalizarLista(areaProduccion);
    }

    public boolean esGarita(String ip) {
        return contieneIp(puertaPrincipalSimplificado, ip);
    }

    public boolean esProduccion(String ip) {
        return contieneIp(areaProduccion, ip);
    }

    private static boolean contieneIp(List<String> lista, String ip) {
        if (ip == null || ip.isBlank()) {
            return false;
        }
        String normalizada = ip.trim();
        return lista.stream().anyMatch(configurada -> configurada.equals(normalizada));
    }

    private static List<String> parsearListaIps(String valor) {
        return Arrays.stream(valor.split(","))
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .collect(Collectors.toCollection(ArrayList::new));
    }

    private static List<String> normalizarLista(List<String> lista) {
        if (lista == null) {
            return new ArrayList<>();
        }
        return lista.stream()
                .filter(ip -> ip != null && !ip.isBlank())
                .map(String::trim)
                .collect(Collectors.toCollection(ArrayList::new));
    }
}
