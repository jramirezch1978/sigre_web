package com.sigre.seguridad.geo;

/**
 * Ubicación aproximada obtenida por IP pública (nivel ciudad/región, no GPS exacto).
 */
public record IpGeoLocation(
        String city,
        String region,
        String country,
        double latitude,
        double longitude) {

    public String displayLabel() {
        StringBuilder sb = new StringBuilder();
        appendPart(sb, city);
        appendPart(sb, region);
        appendPart(sb, country);
        return sb.isEmpty() ? "—" : sb.toString();
    }

    private static void appendPart(StringBuilder sb, String part) {
        if (part == null || part.isBlank()) {
            return;
        }
        if (!sb.isEmpty()) {
            sb.append(", ");
        }
        sb.append(part.trim());
    }
}
