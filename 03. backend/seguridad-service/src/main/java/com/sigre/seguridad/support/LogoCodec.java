package com.sigre.seguridad.support;

import com.sigre.common.exception.BusinessException;
import org.springframework.http.HttpStatus;

import java.util.Base64;

/**
 * Decodifica y valida el logo enviado en base64 (con o sin prefijo data-URL) desde los
 * formularios de alta de empresa (admin y registro demo). El logo es obligatorio en ambos.
 */
public final class LogoCodec {

    private static final int MAX_LOGO_BYTES = 5 * 1024 * 1024;

    private LogoCodec() {
    }

    public static byte[] decodeRequired(String logoBase64) {
        if (logoBase64 == null || logoBase64.isBlank()) {
            throw new BusinessException("El logo de la empresa es obligatorio", HttpStatus.BAD_REQUEST, "LOGO_REQUERIDO");
        }
        String payload = logoBase64.trim();
        int comma = payload.indexOf(',');
        if (payload.startsWith("data:") && comma > -1) {
            payload = payload.substring(comma + 1);
        }
        byte[] bytes;
        try {
            bytes = Base64.getDecoder().decode(payload);
        } catch (IllegalArgumentException ex) {
            throw new BusinessException("El logo enviado no es un archivo válido", HttpStatus.BAD_REQUEST, "LOGO_INVALIDO");
        }
        if (bytes.length == 0) {
            throw new BusinessException("El logo de la empresa es obligatorio", HttpStatus.BAD_REQUEST, "LOGO_REQUERIDO");
        }
        if (bytes.length > MAX_LOGO_BYTES) {
            throw new BusinessException("El logo excede el límite de 5 MB", HttpStatus.BAD_REQUEST, "LOGO_TAMANO_INVALIDO");
        }
        return bytes;
    }
}
