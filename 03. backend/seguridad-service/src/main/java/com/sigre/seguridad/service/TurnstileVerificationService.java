package com.sigre.seguridad.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sigre.common.exception.BusinessException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.time.Duration;

/**
 * Verificación server-side de Cloudflare Turnstile (POST siteverify).
 * Si {@code app.turnstile.secret-key} está vacío, la verificación queda desactivada.
 */
@Slf4j
@Service
public class TurnstileVerificationService {

    private static final URI SITE_VERIFY_URI =
            URI.create("https://challenges.cloudflare.com/turnstile/v0/siteverify");

    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    @Value("${app.turnstile.secret-key:}")
    private String secretKey;

    @Value("${app.turnstile.enabled:true}")
    private boolean enabled;

    public TurnstileVerificationService(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    public boolean isRequired() {
        return enabled && secretKey != null && !secretKey.isBlank();
    }

    public void requireValid(String token, String remoteIp) {
        if (!isRequired()) {
            return;
        }
        if (token == null || token.isBlank()) {
            throw new BusinessException(
                    "Complete la verificación de seguridad (Turnstile).",
                    HttpStatus.BAD_REQUEST,
                    "TURNSTILE_REQUERIDO");
        }

        try {
            String body = "secret=" + encode(secretKey)
                    + "&response=" + encode(token);
            if (remoteIp != null && !remoteIp.isBlank() && !"unknown".equalsIgnoreCase(remoteIp)) {
                body += "&remoteip=" + encode(remoteIp);
            }

            HttpRequest request = HttpRequest.newBuilder(SITE_VERIFY_URI)
                    .timeout(Duration.ofSeconds(15))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .POST(HttpRequest.BodyPublishers.ofString(body))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            JsonNode json = objectMapper.readTree(response.body());
            boolean success = json.path("success").asBoolean(false);

            if (!success) {
                log.warn("Turnstile rechazado: status={} errors={}", response.statusCode(), json.path("error-codes"));
                throw new BusinessException(
                        "Verificación de seguridad no válida. Intente de nuevo.",
                        HttpStatus.BAD_REQUEST,
                        "TURNSTILE_INVALIDO");
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("Error verificando Turnstile: {}", e.getMessage());
            throw new BusinessException(
                    "No se pudo validar la verificación de seguridad.",
                    HttpStatus.SERVICE_UNAVAILABLE,
                    "TURNSTILE_ERROR");
        }
    }

    private static String encode(String value) {
        return URLEncoder.encode(value, StandardCharsets.UTF_8);
    }
}
