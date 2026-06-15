package com.sigre.common.exception;

import lombok.Getter;
import org.springframework.http.HttpStatus;

/**
 * Excepción de negocio personalizada.
 * Se lanza cuando se viola una regla de negocio.
 */
@Getter
public class BusinessException extends RuntimeException {

    private final HttpStatus status;
    private final String errorCode;

    public BusinessException(String message) {
        super(message);
        this.status = HttpStatus.BAD_REQUEST;
        this.errorCode = "BUSINESS_ERROR";
    }

    public BusinessException(String message, HttpStatus status) {
        super(message);
        this.status = status;
        this.errorCode = "BUSINESS_ERROR";
    }

    public BusinessException(String message, String errorCode) {
        super(message);
        this.status = HttpStatus.BAD_REQUEST;
        this.errorCode = errorCode;
    }

    public BusinessException(String message, HttpStatus status, String errorCode) {
        super(message);
        this.status = status;
        this.errorCode = errorCode;
    }
}
