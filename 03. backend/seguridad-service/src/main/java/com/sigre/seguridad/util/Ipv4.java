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

    /** True si es loopback, link-local o RFC1918 (no geolocalizable de forma útil). */
    public static boolean isPrivateOrLoopback(String ipv4) {
        String ip = normalizeOrNull(ipv4);
        if (ip == null) {
            return true;
        }
        String[] p = ip.split("\\.");
        int a = Integer.parseInt(p[0]);
        int b = Integer.parseInt(p[1]);
        if (a == 10 || a == 127) {
            return true;
        }
        if (a == 192 && b == 168) {
            return true;
        }
        if (a == 172 && b >= 16 && b <= 31) {
            return true;
        }
        if (a == 169 && b == 254) {
            return true;
        }
        return a == 0 || a >= 224;
    }
}
