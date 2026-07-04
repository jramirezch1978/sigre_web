package com.sigre.asistencia.controller;

import com.sigre.asistencia.config.IpRoutingProperties;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * Resuelve qué pantalla de marcaje debe abrirse por defecto según la IP privada
 * del dispositivo (tablet/móvil/kiosco) enviada por el frontend.
 *
 * La IP del request HTTP al servidor NO se usa: el servidor ve su propia IP o
 * la del proxy, no la del equipo donde corre el navegador.
 */
@RestController
@RequestMapping("/menu")
@RequiredArgsConstructor
@Slf4j
public class MenuRoutingController {

    private final IpRoutingProperties ipRoutingProperties;

    /**
     * @param localIp IP privada capturada en el navegador del dispositivo (WebRTC).
     *                Es la única fuente válida para el enrutamiento automático.
     */
    @GetMapping("/ruta-por-ip")
    public ResponseEntity<RutaPorIpResponse> obtenerRutaPorIp(
            @RequestParam(required = false) String localIp) {

        String ipDispositivo = localIp != null ? localIp.trim() : null;

        if (ipDispositivo == null || ipDispositivo.isBlank()) {
            log.info("🧭 Sin IP de dispositivo en la petición - se mostrará el menú manual");
            return ResponseEntity.ok(RutaPorIpResponse.builder().build());
        }

        RutaPorIpResponse ruta = resolverRuta(ipDispositivo);

        if (ruta == null) {
            log.info(
                    "🧭 Sin ruta automática para IP dispositivo='{}' (garita={}, produccion={}) - menú manual",
                    ipDispositivo,
                    ipRoutingProperties.getPuertaPrincipalSimplificado(),
                    ipRoutingProperties.getAreaProduccion());
            return ResponseEntity.ok(RutaPorIpResponse.builder().ipDetectada(ipDispositivo).build());
        }

        log.info("🧭 Ruta automática resuelta: IP dispositivo='{}' -> tipoMarcaje={}, modoMarcaje={}",
                ipDispositivo, ruta.getTipoMarcaje(), ruta.getModoMarcaje());
        return ResponseEntity.ok(ruta.toBuilder().ipDetectada(ipDispositivo).build());
    }

    private RutaPorIpResponse resolverRuta(String ip) {
        if (ip == null || ip.isBlank()) {
            return null;
        }
        if (ipRoutingProperties.esGarita(ip)) {
            return RutaPorIpResponse.builder()
                    .tipoMarcaje("puerta-principal")
                    .modoMarcaje("simplificado")
                    .build();
        }
        if (ipRoutingProperties.esProduccion(ip)) {
            return RutaPorIpResponse.builder()
                    .tipoMarcaje("area-produccion")
                    .build();
        }
        return null;
    }

    @Data
    @Builder(toBuilder = true)
    @NoArgsConstructor
    @AllArgsConstructor
    public static class RutaPorIpResponse {
        /** Null cuando la IP no coincide con ninguna configuración -> el frontend debe mostrar el menú manual. */
        private String tipoMarcaje;
        private String modoMarcaje;
        private String ipDetectada;
    }
}
