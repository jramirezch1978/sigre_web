package com.sigre.comercializacion.client;

import org.springframework.cloud.openfeign.FeignClient;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import com.sigre.comercializacion.client.dto.LiquidacionDTO;
import com.sigre.comercializacion.client.dto.SolicitudGiroDTO;
import com.sigre.comercializacion.config.FeignConfig;

import java.time.LocalDate;
import java.util.List;

/**
 * Feign client para comunicarse con finanzas-service.
 * Permite obtener liquidaciones y órdenes de giro pendientes por cobrar.
 */
@FeignClient(
        name = "finanzas-service",
        url = "${feign.client.config.finanzas-service.url:http://finanzas-service:9005}",
        configuration = FeignConfig.class
)
public interface FinanzasClient {

    /**
     * Obtiene liquidaciones con saldo positivo (pendientes por cobrar).
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de liquidaciones pendientes por cobrar
     */
    @GetMapping("/api/finanzas/liquidaciones/pendientes-cobrar")
    List<LiquidacionDTO> obtenerLiquidacionesPendientesCobrar(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) LocalDate fechaDesde,
            @RequestParam(required = false) LocalDate fechaHasta);

    /**
     * Obtiene órdenes de giro marcadas como devolución aprobada (pendientes por cobrar).
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param solicitanteId ID de solicitante (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de órdenes de giro pendientes por cobrar
     */
    @GetMapping("/api/finanzas/ordenes-giro/pendientes-cobrar")
    List<SolicitudGiroDTO> obtenerOrdenesGiroPendientesCobrar(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long solicitanteId,
            @RequestParam(required = false) LocalDate fechaDesde,
            @RequestParam(required = false) LocalDate fechaHasta);
}
