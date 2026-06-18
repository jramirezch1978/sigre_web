package pe.restaurant.gateway.config;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.web.reactive.error.ErrorWebExceptionHandler;
import org.springframework.core.annotation.Order;
import org.springframework.core.io.buffer.DataBuffer;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.server.reactive.ServerHttpResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.web.server.ServerWebExchange;
import reactor.core.publisher.Mono;

import java.net.ConnectException;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.concurrent.TimeoutException;

/**
 * Interceptor global de errores del API Gateway (WebFlux).
 * Reemplaza la respuesta genérica de Spring por un JSON con detalle legible.
 */
@Slf4j
@Component
@Order(-2)
public class GatewayErrorHandler implements ErrorWebExceptionHandler {

    private final ObjectMapper mapper = new ObjectMapper();

    @Override
    public Mono<Void> handle(ServerWebExchange exchange, Throwable ex) {
        ServerHttpResponse response = exchange.getResponse();
        if (response.isCommitted()) {
            return Mono.error(ex);
        }

        HttpStatus status;
        String mensaje;
        String codigo;

        if (ex instanceof ResponseStatusException rse) {
            status = HttpStatus.valueOf(rse.getStatusCode().value());
            mensaje = resolverMensajeStatus(status, rse, exchange);
            codigo = status.name();
        } else if (ex instanceof ConnectException) {
            status = HttpStatus.SERVICE_UNAVAILABLE;
            mensaje = "Servicio no disponible: " + extraerServicio(exchange) + " no responde. Verifique que el pod esté corriendo.";
            codigo = "SERVICE_UNAVAILABLE";
            log.error("Gateway: servicio caído [{}] - {}", exchange.getRequest().getPath(), ex.getMessage());
        } else if (ex instanceof TimeoutException) {
            status = HttpStatus.GATEWAY_TIMEOUT;
            mensaje = "Timeout: " + extraerServicio(exchange) + " no respondió a tiempo.";
            codigo = "GATEWAY_TIMEOUT";
            log.error("Gateway: timeout [{}]", exchange.getRequest().getPath());
        } else {
            status = HttpStatus.INTERNAL_SERVER_ERROR;
            mensaje = "Error interno en gateway: " + ex.getClass().getSimpleName() + " — " + ex.getMessage();
            codigo = "GATEWAY_INTERNAL_ERROR";
            log.error("Gateway: error no controlado [{}]", exchange.getRequest().getPath(), ex);
        }

        response.setStatusCode(status);
        response.getHeaders().setContentType(MediaType.APPLICATION_JSON);

        Map<String, Object> body = new LinkedHashMap<>();
        body.put("success", false);
        body.put("message", mensaje);
        body.put("errorCode", codigo);
        body.put("status", status.value());
        body.put("path", exchange.getRequest().getPath().value());
        body.put("timestamp", LocalDateTime.now().toString());

        byte[] bytes;
        try {
            bytes = mapper.writeValueAsBytes(body);
        } catch (JsonProcessingException jpe) {
            bytes = ("{\"success\":false,\"message\":\"" + mensaje.replace("\"", "'") + "\"}").getBytes();
        }
        DataBuffer buffer = response.bufferFactory().wrap(bytes);
        return response.writeWith(Mono.just(buffer));
    }

    private String resolverMensajeStatus(HttpStatus status, ResponseStatusException rse, ServerWebExchange exchange) {
        return switch (status) {
            case NOT_FOUND -> "Ruta no encontrada: " + exchange.getRequest().getPath().value()
                    + ". Verifique que el endpoint exista y que el servicio esté desplegado.";
            case BAD_GATEWAY -> "Servicio downstream (" + extraerServicio(exchange) + ") devolvió un error. Revise logs del microservicio.";
            case SERVICE_UNAVAILABLE -> "Servicio " + extraerServicio(exchange) + " no disponible. Verifique que el pod esté corriendo.";
            case GATEWAY_TIMEOUT -> "Timeout al conectar con " + extraerServicio(exchange) + ".";
            case FORBIDDEN -> "Acceso denegado a " + exchange.getRequest().getPath().value() + ".";
            case UNAUTHORIZED -> "Autenticación requerida para " + exchange.getRequest().getPath().value() + ".";
            default -> rse.getReason() != null ? rse.getReason() : status.getReasonPhrase();
        };
    }

    private String extraerServicio(ServerWebExchange exchange) {
        String path = exchange.getRequest().getPath().value();
        String[] partes = path.split("/");
        if (partes.length >= 3) {
            return partes[2];
        }
        return "desconocido";
    }
}
