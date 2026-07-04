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

        RutaPorIpResponse ruta = resolverRuta(ipSolicitud);
        if (ruta == null && localIp != null && !localIp.isBlank()) {
            ruta = resolverRuta(localIp.trim());
        }

        if (ruta == null) {
            log.info("🧭 Sin ruta automática configurada para IP '{}' (localIp frontend: '{}') - se mostrará el menú por defecto",
                    ipSolicitud, localIp);
            return ResponseEntity.ok(RutaPorIpResponse.builder().ipDetectada(ipSolicitud).build());
        }

        log.info("🧭 Ruta automática resuelta para IP '{}' -> tipoMarcaje={}, modoMarcaje={}",
                ipSolicitud, ruta.getTipoMarcaje(), ruta.getModoMarcaje());
        return ResponseEntity.ok(ruta.toBuilder().ipDetectada(ipSolicitud).build());
    }

    private RutaPorIpResponse resolverRuta(String ip) {
        if (ip == null || ip.isBlank()) {
            return null;
        }
        if (ipRoutingProperties.getPuertaPrincipalSimplificado().contains(ip)) {
            return RutaPorIpResponse.builder()
                    .tipoMarcaje("puerta-principal")
                    .modoMarcaje("simplificado")
                    .build();
        }
        if (ipRoutingProperties.getAreaProduccion().contains(ip)) {
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
