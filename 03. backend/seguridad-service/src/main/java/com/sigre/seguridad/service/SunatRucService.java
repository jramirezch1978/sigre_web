package com.sigre.seguridad.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sigre.common.exception.BusinessException;
import com.sigre.seguridad.dto.ConsultaRucDto;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.regex.Pattern;

@Slf4j
@Service
public class SunatRucService {

    private static final Pattern RUC_PATTERN = Pattern.compile("^\\d{11}$");

    private final ObjectMapper objectMapper;
    private final HttpClient httpClient;

    @Value("${app.sunat.api-base-url:http://pegazus.serveftp.com:9080/SunatWebServices}")
    private String apiBaseUrl;

    @Value("${app.sunat.usuario:sigre}")
    private String usuario;

    @Value("${app.sunat.clave:sigre1234}")
    private String clave;

    @Value("${app.sunat.empresa:TRANSMARINA}")
    private String empresa;

    @Value("${app.sunat.ruc-origen:20100070970}")
    private String rucOrigen;

    @Value("${app.sunat.ip-local:192.168.1.100}")
    private String ipLocal;

    @Value("${app.sunat.computer-name:SIGRE-WEB}")
    private String computerName;

    private volatile String cachedToken;
    private volatile long tokenExpiresAtMs;

    public SunatRucService(ObjectMapper objectMapper) {
        this.objectMapper = objectMapper;
        this.httpClient = HttpClient.newBuilder()
                .connectTimeout(Duration.ofSeconds(10))
                .build();
    }

    public ConsultaRucDto consultar(String ruc) {
        String rucNormalizado = ruc == null ? "" : ruc.trim();
        if (!RUC_PATTERN.matcher(rucNormalizado).matches()) {
            throw new BusinessException(
                    "El RUC debe tener 11 dígitos numéricos.",
                    HttpStatus.BAD_REQUEST,
                    "RUC_INVALIDO");
        }

        try {
            String token = obtenerToken();
            JsonNode data = consultarRucRemoto(token, rucNormalizado);
            String razonSocial = text(data, "razonSocial");

            return ConsultaRucDto.builder()
                    .ruc(text(data, "ruc", rucNormalizado))
                    .razonSocial(razonSocial)
                    .nombreComercial(razonSocial)
                    .direccionFiscal(construirDireccion(data))
                    .estado(text(data, "estado"))
                    .condicion(text(data, "condicion"))
                    .ubigeo(text(data, "ubigeo"))
                    .build();
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("Error consultando RUC {} en SUNAT: {}", rucNormalizado, e.getMessage());
            throw new BusinessException(
                    "No se pudo consultar el RUC en SUNAT. Intente nuevamente.",
                    HttpStatus.SERVICE_UNAVAILABLE,
                    "RUC_CONSULTA_ERROR");
        }
    }

    private String obtenerToken() throws Exception {
        long ahora = System.currentTimeMillis();
        if (cachedToken != null && ahora < tokenExpiresAtMs - 30_000L) {
            return cachedToken;
        }

        synchronized (this) {
            ahora = System.currentTimeMillis();
            if (cachedToken != null && ahora < tokenExpiresAtMs - 30_000L) {
                return cachedToken;
            }

            Map<String, String> body = new LinkedHashMap<>();
            body.put("usuario", usuario);
            body.put("clave", clave);
            body.put("empresa", empresa);
            body.put("ipLocal", ipLocal);
            body.put("computerName", computerName);

            HttpRequest request = HttpRequest.newBuilder(tokenUri())
                    .timeout(Duration.ofSeconds(15))
                    .header("Content-Type", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(body)))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
            JsonNode json = objectMapper.readTree(response.body());

            if (!json.path("success").asBoolean(false)) {
                String mensaje = text(json, "mensaje");
                throw new BusinessException(
                        mensaje != null && !mensaje.isBlank()
                                ? mensaje
                                : "No se pudo autenticar con el servicio SUNAT.",
                        HttpStatus.SERVICE_UNAVAILABLE,
                        "SUNAT_TOKEN_ERROR");
            }

            cachedToken = text(json, "token");
            if (cachedToken == null || cachedToken.isBlank()) {
                throw new BusinessException(
                        "El servicio SUNAT no devolvió un token válido.",
                        HttpStatus.SERVICE_UNAVAILABLE,
                        "SUNAT_TOKEN_VACIO");
            }

            int expiresIn = json.path("expiresIn").asInt(900);
            tokenExpiresAtMs = System.currentTimeMillis() + (expiresIn * 1000L);
            return cachedToken;
        }
    }

    private JsonNode consultarRucRemoto(String token, String ruc) throws Exception {
        Map<String, String> body = new LinkedHashMap<>();
        body.put("rucConsulta", ruc);
        body.put("rucOrigen", rucOrigen);
        body.put("computerName", computerName);

        HttpRequest request = HttpRequest.newBuilder(consultaUri())
                .timeout(Duration.ofSeconds(20))
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer " + token)
                .POST(HttpRequest.BodyPublishers.ofString(objectMapper.writeValueAsString(body)))
                .build();

        HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());
        JsonNode json = objectMapper.readTree(response.body());

        if (!json.path("success").asBoolean(false)) {
            String mensaje = text(json, "mensaje");
            throw new BusinessException(
                    mensaje != null && !mensaje.isBlank()
                            ? mensaje
                            : "No se encontró información para el RUC indicado.",
                    HttpStatus.NOT_FOUND,
                    "RUC_NO_ENCONTRADO");
        }

        JsonNode data = json.path("data");
        if (data.isMissingNode() || data.isNull()) {
            throw new BusinessException(
                    "No se encontró información para el RUC indicado.",
                    HttpStatus.NOT_FOUND,
                    "RUC_NO_ENCONTRADO");
        }

        return data;
    }

    private URI tokenUri() {
        return URI.create(normalizeBaseUrl() + "/api/auth/token");
    }

    private URI consultaUri() {
        return URI.create(normalizeBaseUrl() + "/api/ruc/consultar");
    }

    private String normalizeBaseUrl() {
        String base = apiBaseUrl == null ? "" : apiBaseUrl.trim();
        while (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        return base;
    }

    private static String construirDireccion(JsonNode data) {
        StringBuilder sb = new StringBuilder();
        appendPart(sb, text(data, "tipoVia"));
        appendPart(sb, text(data, "nombreVia"));
        appendPart(sb, text(data, "numero"));

        String codigoZona = text(data, "codigoZona");
        String tipoZona = text(data, "tipoZona");
        if (codigoZona != null || tipoZona != null) {
            appendRaw(sb, ((codigoZona != null ? codigoZona : "") + " " + (tipoZona != null ? tipoZona : "")).trim());
        }

        appendPrefixed(sb, text(data, "interior"), "INT.");
        appendPrefixed(sb, text(data, "lote"), "LOTE");
        appendPrefixed(sb, text(data, "manzana"), "MZ.");
        appendPrefixed(sb, text(data, "kilometro"), "KM.");
        appendPart(sb, text(data, "descDistrito"));
        appendPart(sb, text(data, "descProvincia"));
        appendPart(sb, text(data, "descDepartamento"));

        return sb.toString().replaceAll("\\s+", " ").trim();
    }

    private static void appendPart(StringBuilder sb, String value) {
        if (!isValid(value)) {
            return;
        }
        if (!sb.isEmpty()) {
            sb.append(' ');
        }
        sb.append(value.trim());
    }

    private static void appendRaw(StringBuilder sb, String value) {
        if (!isValid(value)) {
            return;
        }
        if (!sb.isEmpty()) {
            sb.append(' ');
        }
        sb.append(value.trim());
    }

    private static void appendPrefixed(StringBuilder sb, String value, String prefix) {
        if (!isValid(value)) {
            return;
        }
        if (!sb.isEmpty()) {
            sb.append(' ');
        }
        sb.append(prefix).append(' ').append(value.trim());
    }

    private static boolean isValid(String value) {
        return value != null && !value.isBlank() && !"-".equals(value.trim());
    }

    private static String text(JsonNode node, String field) {
        return text(node, field, null);
    }

    private static String text(JsonNode node, String field, String defaultValue) {
        if (node == null || node.isMissingNode() || node.isNull()) {
            return defaultValue;
        }
        JsonNode value = node.path(field);
        if (value.isMissingNode() || value.isNull()) {
            return defaultValue;
        }
        String text = value.asText();
        return text == null || text.isBlank() ? defaultValue : text.trim();
    }
}
