package pe.restaurant.common.exception;

import org.springframework.http.HttpStatus;

/**
 * Excepción para recursos no encontrados (HTTP 404).
 */
public class ResourceNotFoundException extends BusinessException {

    public ResourceNotFoundException(String resource, Long id) {
        super(
            String.format("Recurso '%s' con id %d no encontrado", resource, id),
            HttpStatus.NOT_FOUND,
            "RESOURCE_NOT_FOUND"
        );
    }

    public ResourceNotFoundException(String resource, String field, String value) {
        super(
            String.format("Recurso '%s' con %s='%s' no encontrado", resource, field, value),
            HttpStatus.NOT_FOUND,
            "RESOURCE_NOT_FOUND"
        );
    }
}
