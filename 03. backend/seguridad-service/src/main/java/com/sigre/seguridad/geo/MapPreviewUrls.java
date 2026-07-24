package com.sigre.seguridad.geo;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Locale;

/**
 * URLs de mapa para embeber en correo HTML y abrir en Google Maps.
 */
public final class MapPreviewUrls {

    private MapPreviewUrls() {
    }

    /** Enlace interactivo a Google Maps (siempre disponible, sin API key). */
    public static String googleMapsLink(double latitude, double longitude) {
        return String.format(Locale.US, "https://www.google.com/maps?q=%.6f,%.6f", latitude, longitude);
    }

    /**
     * Imagen estática para {@code <img>} en el correo.
     * Si hay API key de Google Static Maps, la usa; si no, OpenStreetMap (sin key).
     */
    public static String staticMapImageUrl(double latitude, double longitude, String googleStaticApiKey) {
        if (googleStaticApiKey != null && !googleStaticApiKey.isBlank()) {
            return String.format(Locale.US,
                    "https://maps.googleapis.com/maps/api/staticmap"
                            + "?center=%.6f,%.6f&zoom=13&size=600x280&scale=2&maptype=roadmap"
                            + "&markers=color:red%%7C%.6f,%.6f&key=%s",
                    latitude, longitude, latitude, longitude,
                    URLEncoder.encode(googleStaticApiKey.trim(), StandardCharsets.UTF_8));
        }
        return String.format(Locale.US,
                "https://staticmap.openstreetmap.de/staticmap.php"
                        + "?center=%.6f,%.6f&zoom=13&size=600x280&maptype=mapnik"
                        + "&markers=%.6f,%.6f,red-pushpin",
                latitude, longitude, latitude, longitude);
    }
}
