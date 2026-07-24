package com.sigre.seguridad.geo;

import com.fasterxml.jackson.databind.JsonNode;
import com.sigre.seguridad.util.Ipv4;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;

import java.util.Optional;

/**
 * Resuelve ciudad/país/coordenadas a partir de una IP pública (ip-api.com, sin API key).
 */
@Slf4j
@Service
public class IpGeoLocationService {

    private final RestClient restClient;
    private final boolean enabled;

    public IpGeoLocationService(
            @Value("${app.geo.ip.enabled:true}") boolean enabled,
            @Value("${app.geo.ip.connect-timeout-ms:2500}") int connectTimeoutMs,
            @Value("${app.geo.ip.read-timeout-ms:3500}") int readTimeoutMs) {
        this.enabled = enabled;
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(connectTimeoutMs);
        factory.setReadTimeout(readTimeoutMs);
        this.restClient = RestClient.builder().requestFactory(factory).build();
    }

    public Optional<IpGeoLocation> resolve(String ipPublica) {
        if (!enabled) {
            return Optional.empty();
        }
        String ip = Ipv4.normalizeOrNull(ipPublica);
        if (ip == null || Ipv4.isPrivateOrLoopback(ip)) {
            return Optional.empty();
        }
        try {
            JsonNode body = restClient.get()
                    .uri("http://ip-api.com/json/{ip}?fields=status,message,country,regionName,city,lat,lon,query", ip)
                    .retrieve()
                    .body(JsonNode.class);
            if (body == null || !"success".equalsIgnoreCase(text(body, "status"))) {
                log.warn("Geo IP sin resultado para {}: {}", ip, body != null ? text(body, "message") : "null");
                return Optional.empty();
            }
            if (!body.hasNonNull("lat") || !body.hasNonNull("lon")) {
                return Optional.empty();
            }
            return Optional.of(new IpGeoLocation(
                    text(body, "city"),
                    text(body, "regionName"),
                    text(body, "country"),
                    body.get("lat").asDouble(),
                    body.get("lon").asDouble()));
        } catch (Exception ex) {
            log.warn("No se pudo geolocalizar IP {}: {}", ip, ex.getMessage());
            return Optional.empty();
        }
    }

    private static String text(JsonNode node, String field) {
        JsonNode value = node.get(field);
        if (value == null || value.isNull()) {
            return null;
        }
        String s = value.asText();
        return s == null || s.isBlank() ? null : s.trim();
    }
}
