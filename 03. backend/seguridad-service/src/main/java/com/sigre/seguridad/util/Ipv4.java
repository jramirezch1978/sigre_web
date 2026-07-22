package com.sigre.seguridad.util;

import java.util.regex.Pattern;

/** Normaliza y valida direcciones IPv4 (máx. 15 chars: 255.255.255.255). Rechaza IPv6. */
public final class Ipv4 {

    private static final Pattern IPV4 = Pattern.compile(
            "^(?:(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)\\.){3}(?:25[0-5]|2[0-4]\\d|[01]?\\d\\d?)$");

    private Ipv4() {}

    /** @return IP IPv4 normalizada, o null si vacía / IPv6 / inválida. */
    public static String normalizeOrNull(String value) {
        if (value == null || value.isBlank()) {
            return null;
        }
        String ip = value.trim();
        // IPv6 o mapped (::ffff:x.x.x.x): no aceptar; solo v4 pura.
        if (ip.contains(":")) {
            return null;
        }
        if (ip.length() > 15 || !IPV4.matcher(ip).matches()) {
            return null;
        }
        return ip;
    }
}
