package com.sigre.seguridad.util;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

class Ipv4Test {

    @Test
    void detectaPrivadasYPublicas() {
        assertTrue(Ipv4.isPrivateOrLoopback("192.168.0.225"));
        assertTrue(Ipv4.isPrivateOrLoopback("10.0.0.1"));
        assertTrue(Ipv4.isPrivateOrLoopback("127.0.0.1"));
        assertTrue(Ipv4.isPrivateOrLoopback("172.16.5.1"));
        assertFalse(Ipv4.isPrivateOrLoopback("190.117.68.30"));
        assertFalse(Ipv4.isPrivateOrLoopback("8.8.8.8"));
    }
}
