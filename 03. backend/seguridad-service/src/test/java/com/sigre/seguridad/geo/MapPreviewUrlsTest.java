package com.sigre.seguridad.geo;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertTrue;

class MapPreviewUrlsTest {

    @Test
    void googleMapsLinkUsaCoordenadas() {
        String url = MapPreviewUrls.googleMapsLink(-12.046374, -77.042793);
        assertTrue(url.contains("google.com/maps"));
        assertTrue(url.contains("-12.046374"));
        assertTrue(url.contains("-77.042793"));
    }

    @Test
    void sinApiKeyUsaOpenStreetMap() {
        String url = MapPreviewUrls.staticMapImageUrl(-12.046374, -77.042793, null);
        assertTrue(url.contains("openstreetmap.de"));
        assertTrue(url.contains("red-pushpin"));
    }

    @Test
    void conApiKeyUsaGoogleStaticMaps() {
        String url = MapPreviewUrls.staticMapImageUrl(-12.0, -77.0, "abc123");
        assertTrue(url.startsWith("https://maps.googleapis.com/maps/api/staticmap"));
        assertTrue(url.contains("key=abc123"));
    }
}
