package pe.restaurant.common.exception;

import lombok.extern.slf4j.Slf4j;
import org.springframework.core.convert.ConversionFailedException;
import org.springframework.dao.DataAccessException;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.FieldError;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.servlet.resource.NoResourceFoundException;
import pe.restaurant.common.dto.ApiResponse;

import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import pe.restaurant.common.dto.ValidationError;

/**
 * Manejador global de excepciones para todos los microservicios.
 * Los mensajes devueltos al cliente son amigables (API de experiencia);
 * el detalle técnico se registra únicamente en logs.
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    private static final Pattern PG_UNIQUE_DETAIL = Pattern.compile(
            "Key \\(([^)]+)\\)=\\(([^)]+)\\) already exists", Pattern.CASE_INSENSITIVE);
    private static final Pattern PG_FK_STILL_REFERENCED = Pattern.compile(
            "is still referenced from table \"([^\"]+)\"", Pattern.CASE_INSENSITIVE);
    private static final Pattern PG_FK_NOT_PRESENT = Pattern.compile(
            "Key \\(([^\\)]+)\\)=\\(([^\\)]+)\\) is not present in table \"([^\"]+)\"", Pattern.CASE_INSENSITIVE);
    private static final Pattern PG_NOT_NULL = Pattern.compile(
            "null value in column \"([^\"]+)\"", Pattern.CASE_INSENSITIVE);

    // ── Excepciones de negocio ──────────────────────────────────────────

    @ExceptionHandler(BusinessException.class)
    public ResponseEntity<ApiResponse<Void>> handleBusinessException(BusinessException ex) {
        log.warn("Error de negocio: {} [{}]", ex.getMessage(), ex.getErrorCode());
        return ResponseEntity
                .status(ex.getStatus())
                .body(ApiResponse.error(ex.getMessage(), ex.getErrorCode()));
    }

    @ExceptionHandler(ResourceNotFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleResourceNotFound(ResourceNotFoundException ex) {
        log.warn("Recurso no encontrado: {}", ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(ApiResponse.error(ex.getMessage(), ex.getErrorCode()));
    }

    // ── Validación de entrada ───────────────────────────────────────────

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiResponse<List<ValidationError>>> handleValidation(MethodArgumentNotValidException ex) {
        List<ValidationError> errors = ex.getBindingResult().getAllErrors().stream()
                .map(error -> new ValidationError(
                        ((FieldError) error).getField(),
                        error.getDefaultMessage()))
                .toList();
        log.warn("Error de validación: {} campo(s) inválido(s)", errors.size());
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.validationError(errors));
    }

    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ApiResponse<Void>> handleTypeMismatch(MethodArgumentTypeMismatchException ex) {
        String param = ex.getName();
        Object raw = ex.getValue();
        String value = raw != null ? raw.toString() : "null";

        if (raw instanceof String str && str.isBlank()) {
            String msg = String.format(
                    "El parámetro '%s' no puede enviarse vacío. Quite ese parámetro de la URL o indique un valor válido.",
                    param);
            log.warn("Parámetro vacío en query: {}", param);
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST)
                    .body(ApiResponse.error(msg, "VALIDATION_ERROR"));
        }

        String requiredType = ex.getRequiredType() != null ? ex.getRequiredType().getSimpleName() : "desconocido";
        String msg = String.format("El parámetro '%s' con valor '%s' no es válido. Se esperaba un valor de tipo %s.",
                param, value, requiredType);
        log.warn("Error de tipo en parámetro: {}", msg);
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error(msg, "VALIDATION_ERROR"));
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ApiResponse<Void>> handleMissingRequestParameter(MissingServletRequestParameterException ex) {
        String msg = String.format(
                "El parámetro '%s' es obligatorio y no fue enviado en la solicitud.",
                ex.getParameterName());
        log.warn("Falta parámetro obligatorio en request: {}", ex.getParameterName());
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error(msg, "VALIDATION_ERROR"));
    }

    @ExceptionHandler(ConversionFailedException.class)
    public ResponseEntity<ApiResponse<Void>> handleConversionFailed(ConversionFailedException ex) {
        Throwable cause = ex.getMostSpecificCause();
        String msg = cause.getMessage() != null && !cause.getMessage().isBlank()
                ? cause.getMessage()
                : "El valor enviado no pudo convertirse al tipo esperado.";
        log.warn("Error de conversión de parámetro: {}", msg);
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error(msg, "VALIDATION_ERROR"));
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiResponse<Void>> handleMessageNotReadable(HttpMessageNotReadableException ex) {
        log.warn("Error al parsear body de la petición: {}",
                ex.getMostSpecificCause() != null ? ex.getMostSpecificCause().getMessage() : ex.getMessage());
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error(
                        "El formato de los datos enviados no es válido. Revise la estructura del JSON e intente nuevamente.",
                        "VALIDATION_ERROR"));
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ResponseEntity<ApiResponse<Void>> handleIllegalArgument(IllegalArgumentException ex) {
        String detail = ex.getMessage() != null ? ex.getMessage() : "Argumento inválido";
        log.warn("Argumento inválido: {}", detail);
        return ResponseEntity
                .status(HttpStatus.BAD_REQUEST)
                .body(ApiResponse.error(detail, "VALIDATION_ERROR"));
    }

    // ── HTTP / rutas ────────────────────────────────────────────────────

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ResponseEntity<ApiResponse<Void>> handleMethodNotSupported(HttpRequestMethodNotSupportedException ex) {
        String supported = ex.getSupportedHttpMethods() == null ? ""
                : ex.getSupportedHttpMethods().stream()
                .map(HttpMethod::name)
                .collect(Collectors.joining(", "));
        String msg = String.format(
                "Método HTTP no permitido para esta ruta (recibido: %s). Use uno de: %s",
                ex.getMethod(),
                supported.isBlank() ? "(ver OpenAPI/contrato)" : supported);
        log.warn("{} — uri sugerida mal configurada o cliente envió verbo incorrecto", msg);
        return ResponseEntity
                .status(HttpStatus.METHOD_NOT_ALLOWED)
                .body(ApiResponse.error(msg, "METHOD_NOT_ALLOWED"));
    }

    @ExceptionHandler(NoResourceFoundException.class)
    public ResponseEntity<ApiResponse<Void>> handleNoResourceFound(NoResourceFoundException ex) {
        String path = ex.getResourcePath();
        String msg = "Ruta no expuesta en este servicio: " + path
                + ". Verifique método HTTP (GET/POST), despliegue actualizado y prefijo /api.";
        log.warn("{}", msg);
        return ResponseEntity
                .status(HttpStatus.NOT_FOUND)
                .body(ApiResponse.error(msg, "ENDPOINT_NOT_FOUND"));
    }

    // ── Base de datos – integridad (unique, FK, not-null) ───────────────

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiResponse<Void>> handleDataIntegrity(DataIntegrityViolationException ex) {
        String rootMsg = ex.getMostSpecificCause() != null
                ? ex.getMostSpecificCause().getMessage() : "";
        log.error("Violación de integridad de datos: {}", rootMsg, ex);

        String userMessage = translateIntegrityViolation(rootMsg);

        HttpStatus status = userMessage.contains("ya existe") ? HttpStatus.CONFLICT : HttpStatus.BAD_REQUEST;
        String errorCode = userMessage.contains("ya existe") ? "DUPLICATE_ENTRY" : "DATA_INTEGRITY_ERROR";

        return ResponseEntity
                .status(status)
                .body(ApiResponse.error(userMessage, errorCode));
    }

    // ── Base de datos – otros errores de acceso ─────────────────────────

    @ExceptionHandler(DataAccessException.class)
    public ResponseEntity<ApiResponse<Void>> handleDataAccess(DataAccessException ex) {
        String rootMsg = ex.getMostSpecificCause() != null
                ? ex.getMostSpecificCause().getMessage() : ex.getClass().getSimpleName();
        log.error("Error de acceso a datos: {}", rootMsg, ex);
        
        // Detectar errores específicos de PostgreSQL RAISE EXCEPTION
        String userMessage = translateDatabaseError(rootMsg);

        // TODO(debug temporal): revertir. Expone la causa SQL real para diagnóstico.
        userMessage = userMessage + " [DEBUG causaSQL: " + rootMsg + "]";

        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error(userMessage, "DATABASE_ERROR"));
    }
    
    /**
     * Traduce errores de base de datos a mensajes amigables para el usuario.
     * Detecta errores específicos de funciones PL/pgSQL que usan RAISE EXCEPTION.
     */
    private String translateDatabaseError(String rootMessage) {
        if (rootMessage == null || rootMessage.isBlank()) {
            return "Ocurrió un error al procesar la operación. Por favor, intente nuevamente o contacte al administrador.";
        }
        
        // Detectar error de numeración faltante en doc_tipo_num_serie
        if (rootMessage.contains("no hay numeración en core.doc_tipo_num_serie")) {
            // Extraer parámetros del mensaje: doc_tipo_id=X, serie=Y, sucursal_id=Z
            Pattern pattern = Pattern.compile("doc_tipo_id=(\\d+), serie=([^,]+), sucursal_id=(\\d+)");
            Matcher matcher = pattern.matcher(rootMessage);
            if (matcher.find()) {
                String docTipoId = matcher.group(1);
                String serie = matcher.group(2);
                String sucursalId = matcher.group(3);
                return String.format(
                    "No existe configuración de numeración para el documento tipo %s, serie %s en la sucursal %s. " +
                    "Por favor, configure la numeración en el sistema antes de continuar.",
                    docTipoId, serie, sucursalId
                );
            }
            return "No existe configuración de numeración para este tipo de documento. Por favor, configure la numeración en el sistema.";
        }
        
        // Detectar error de secuencial que supera límite
        if (rootMessage.contains("secuencial supera 10 dígitos")) {
            return "El número de documento ha alcanzado el límite máximo permitido. Por favor, contacte al administrador.";
        }
        
        // Detectar errores de parámetros obligatorios en funciones
        if (rootMessage.contains("es obligatorio")) {
            return "Faltan datos obligatorios para completar la operación. Por favor, verifique la información enviada.";
        }
        
        // Mensaje genérico para otros errores de base de datos
        return "Ocurrió un error al procesar la operación. Por favor, intente nuevamente o contacte al administrador.";
    }

    // ── Fallback general ────────────────────────────────────────────────

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiResponse<Void>> handleGeneral(Exception ex) {
        log.error("Error interno no controlado: {}", ex.getMessage(), ex);
        return ResponseEntity
                .status(HttpStatus.INTERNAL_SERVER_ERROR)
                .body(ApiResponse.error(
                        "Ocurrió un error inesperado. Por favor, intente nuevamente o contacte al administrador.",
                        "INTERNAL_ERROR"));
    }

    // ── Utilidades privadas ─────────────────────────────────────────────

    private String translateIntegrityViolation(String rootMessage) {
        if (rootMessage == null || rootMessage.isBlank()) {
            return "No se pudo completar la operación por un conflicto con los datos existentes.";
        }

        Matcher uniqueMatcher = PG_UNIQUE_DETAIL.matcher(rootMessage);
        if (uniqueMatcher.find()) {
            String column = humanizeColumn(uniqueMatcher.group(1));
            String value = uniqueMatcher.group(2);
            return String.format("Ya existe un registro con %s '%s'. Por favor, use un valor diferente.", column, value);
        }
        if (rootMessage.toLowerCase().contains("unique constraint")
                || rootMessage.toLowerCase().contains("duplicate key")) {
            return "Ya existe un registro con los mismos datos. Por favor, verifique e intente con valores diferentes.";
        }

        Matcher fkRefMatcher = PG_FK_STILL_REFERENCED.matcher(rootMessage);
        if (fkRefMatcher.find()) {
            return "No se puede eliminar este registro porque tiene datos relacionados en uso. "
                    + "Primero elimine o desvincule los registros dependientes.";
        }

        Matcher fkNotPresent = PG_FK_NOT_PRESENT.matcher(rootMessage);
        if (fkNotPresent.find()) {
            String column = fkNotPresent.group(1);
            String value = fkNotPresent.group(2);
            String table = fkNotPresent.group(3);
            return String.format("El registro referenciado '%s=%s' no existe en %s. Verifique que los datos relacionados sean correctos.",
                    humanizeColumn(column), value, table);
        }

        Matcher notNullMatcher = PG_NOT_NULL.matcher(rootMessage);
        if (notNullMatcher.find()) {
            String column = humanizeColumn(notNullMatcher.group(1));
            return String.format("El campo %s es obligatorio y no fue proporcionado.", column);
        }

        if (rootMessage.toLowerCase().contains("check constraint")) {
            return "Los datos ingresados no cumplen con las reglas de validación. Revise los valores e intente nuevamente.";
        }

        return "No se pudo completar la operación por un conflicto con los datos. "
                + "Verifique la información e intente nuevamente.";
    }

    /**
     * Convierte nombres de columna técnicos (snake_case) a un formato legible.
     * Ejemplo: "cod_clase" → "cod clase", "tipo_impuesto" → "tipo impuesto".
     */
    private String humanizeColumn(String columnName) {
        if (columnName == null) return "campo";
        return columnName.replace("_", " ").trim();
    }
}
