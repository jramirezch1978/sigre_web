package com.sigre.seguridad.geo;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class IpGeoLocationTest {

    @Test
    void displayLabelUnePartes() {
        assertEquals(
                "Lima, Lima, Peru",
                new IpGeoLocation("Lima", "Lima", "Peru", -12.0, -77.0).displayLabel());
        assertEquals("Peru", new IpGeoLocation(null, "  ", "Peru", 0, 0).displayLabel());
    }
}
