package com.sigre.asistencia.util;

import jakarta.servlet.http.HttpServletRequest;

/**
 * Utilidad para detectar la IP real del cliente considerando los proxies
 * (nginx del frontend, API Gateway) que se encuentran delante del servicio.
 */
public final class IpUtils {

    private IpUtils() {
    }

    /**
     * Obtiene la IP real del cliente a partir de los headers estándar de proxy
     * (X-Forwarded-For, X-Real-IP) y, en su defecto, de la IP de la conexión TCP.
     */
    public static String obtenerIpReal(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("X-Real-IP");
        }
        if (ip == null || ip.isEmpty() || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }

        if (ip != null && ip.contains(",")) {
            ip = ip.split(",")[0].trim();
        }

        return ip != null ? ip.trim() : "0.0.0.0";
    }
}
