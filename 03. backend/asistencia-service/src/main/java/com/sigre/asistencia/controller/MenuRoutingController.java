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
 *
 * Se combinan dos fuentes de IP:
 * 1. La IP local capturada por el navegador vía WebRTC (localIp) — util cuando
 *    el equipo esta detras de un proxy que oculta su IP real al servidor.
 * 2. La IP con la que el servidor recibe el request HTTP (X-Forwarded-For /
 *    X-Real-IP reenviados por nginx) — es la fuente mas confiable en la red
 *    local del cliente, ya que no depende de que el navegador logre exponer
 *    la IP LAN via WebRTC (que puede fallar por mDNS, permisos o políticas
 *    de red del equipo).
 */
@RestController
@RequestMapping("/menu")
@RequiredArgsConstructor
@Slf4j
public class MenuRoutingController {

    private final IpRoutingProperties ipRoutingProperties;

    /**
     * @param localIp IP local capturada por el navegador (WebRTC), enviada como
     *                primera opción. Si no coincide con ninguna configuración
     *                (o no llegó), se usa la IP real del request HTTP.
     */
    @GetMapping("/ruta-por-ip")
    public ResponseEntity<RutaPorIpResponse> obtenerRutaPorIp(
            @RequestParam(required = false) String localIp,
            HttpServletRequest httpRequest) {

        String ipSolicitud = IpUtils.obtenerIpReal(httpRequest);
        String ipLocal = localIp != null ? localIp.trim() : null;

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

        String ipParaMostrar = ipLocal != null && !ipLocal.isBlank() ? ipLocal : ipSolicitud;

        if (ruta == null) {
            log.info(
                    "🧭 Sin ruta automática para IP HTTP='{}', localIp='{}' (garita={}, produccion={}) - menú manual",
                    ipSolicitud, ipLocal,
                    ipRoutingProperties.getPuertaPrincipalSimplificado(),
                    ipRoutingProperties.getAreaProduccion());
            return ResponseEntity.ok(RutaPorIpResponse.builder().ipDetectada(ipParaMostrar).build());
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
