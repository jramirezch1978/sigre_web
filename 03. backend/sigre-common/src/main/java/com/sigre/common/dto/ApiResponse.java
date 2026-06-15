package com.sigre.common.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.ZoneId;
import java.time.ZonedDateTime;

/**
 * Respuesta estándar de la API para todos los microservicios.
 *
 * @param <T> tipo de dato del payload
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {

    private static final ZoneId LIMA_ZONE = ZoneId.of("America/Lima");

    private boolean success;
    private String message;
    private String errorCode;
    private T data;

    @Builder.Default
    @JsonFormat(pattern = "dd/MM/yyyy HH:mm:ss", timezone = "America/Lima")
    private ZonedDateTime timestamp = ZonedDateTime.now(LIMA_ZONE);

    public static <T> ApiResponse<T> ok(T data) {
        return ApiResponse.<T>builder()
                .success(true)
                .data(data)
                .build();
    }

    public static <T> ApiResponse<T> ok(T data, String message) {
        return ApiResponse.<T>builder()
                .success(true)
                .message(message)
                .data(data)
                .build();
    }

    public static <T> ApiResponse<T> error(String message, String errorCode) {
        return ApiResponse.<T>builder()
                .success(false)
                .message(message)
                .errorCode(errorCode)
                .build();
    }

    public static <T> ApiResponse<T> validationError(T errors) {
        return ApiResponse.<T>builder()
                .success(false)
                .message("Error de validación")
                .errorCode("VALIDATION_ERROR")
                .data(errors)
                .build();
    }
}
