package com.sigre.asistencia.controller;

import com.sigre.asistencia.config.IpRoutingProperties;
import com.sigre.asistencia.util.IpUtils;
import jakarta.servlet.http.HttpServletRequest;
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
 * Resuelve qué pantalla de marcaje debe abrirse por defecto según la IP del
 * equipo que solicita el menú inicial (garita → simplificado, producción →
 * área de producción). Si la IP no coincide con ninguna configuración,
 * el frontend debe mostrar el menú de selección manual.
 */
@RestController
@RequestMapping("/menu")
@RequiredArgsConstructor
@Slf4j
public class MenuRoutingController {

    private final IpRoutingProperties ipRoutingProperties;

    /**
     * @param localIp IP local capturada por el navegador (WebRTC) enviada como respaldo.
     *                Se usa solo si la IP detectada en el propio request HTTP no coincide
     *                con ninguna configuración (la IP del request es la fuente más fiable
     *                en una red local, ya que no depende de restricciones del navegador).
     */
    @GetMapping("/ruta-por-ip")
    public ResponseEntity<RutaPorIpResponse> obtenerRutaPorIp(
            @RequestParam(required = false) String localIp,
            HttpServletRequest httpRequest) {

        String ipSolicitud = IpUtils.obtenerIpReal(httpRequest);
        String ipLocal = localIp != null ? localIp.trim() : null;

        // Priorizar la IP local del navegador (WebRTC): en kioscos suele ser la IP fija
        // del equipo (192.168.30.x), aunque el proxy HTTP vea otra IP intermedia.
        RutaPorIpResponse ruta = null;
        String ipCoincidente = null;

        if (ipLocal != null && !ipLocal.isBlank()) {
            ruta = resolverRuta(ipLocal);
            if (ruta != null) {
                ipCoincidente = ipLocal;
            }
        }
        if (ruta == null) {
            ruta = resolverRuta(ipSolicitud);
            if (ruta != null) {
                ipCoincidente = ipSolicitud;
            }
        }

        if (ruta == null) {
            log.info(
                    "🧭 Sin ruta automática para IP HTTP='{}', localIp='{}' (garita={}, produccion={}) - menú manual",
                    ipSolicitud, ipLocal,
                    ipRoutingProperties.getPuertaPrincipalSimplificado(),
                    ipRoutingProperties.getAreaProduccion());
            return ResponseEntity.ok(RutaPorIpResponse.builder().ipDetectada(ipSolicitud).build());
        }

        log.info("🧭 Ruta automática resuelta: IP coincidente='{}' (HTTP='{}', localIp='{}') -> tipoMarcaje={}, modoMarcaje={}",
                ipCoincidente, ipSolicitud, ipLocal, ruta.getTipoMarcaje(), ruta.getModoMarcaje());
        return ResponseEntity.ok(ruta.toBuilder().ipDetectada(ipCoincidente).build());
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
