package com.sigre.finanzas.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.sigre.finanzas.client.dto.LiquidacionDTO;
import com.sigre.finanzas.client.dto.SolicitudGiroDTO;
import com.sigre.finanzas.entity.Liquidacion;
import com.sigre.finanzas.entity.SolicitudGiro;
import com.sigre.finanzas.mapper.LiquidacionMapper;
import com.sigre.finanzas.mapper.SolicitudGiroMapper;
import com.sigre.finanzas.repository.LiquidacionRepository;
import com.sigre.finanzas.repository.SolicitudGiroRepository;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Controller para endpoints de integración con otros microservicios.
 * Expone datos de finanzas para consumo vía Feign desde comercializacion-service.
 */
@Slf4j
@RestController
@RequestMapping("/api/finanzas")
@RequiredArgsConstructor
@Tag(name = "Integración Finanzas", description = "Endpoints para comunicación inter-microservicios")
public class FinanzasIntegrationController {

    private final LiquidacionRepository liquidacionRepository;
    private final SolicitudGiroRepository solicitudGiroRepository;
    private final LiquidacionMapper liquidacionMapper;
    private final SolicitudGiroMapper solicitudGiroMapper;

    /**
     * Obtiene liquidaciones con saldo positivo (pendientes por cobrar).
     * Endpoint para consumo exclusivo de comercializacion-service.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param proveedorId ID de proveedor (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de liquidaciones pendientes por cobrar
     */
    @GetMapping("/liquidaciones/pendientes-cobrar")
    @Operation(summary = "Obtener liquidaciones pendientes por cobrar",
               description = "Endpoint para consumo de comercializacion-service. Retorna liquidaciones con saldo positivo.")
    public ResponseEntity<List<LiquidacionDTO>> obtenerLiquidacionesPendientesCobrar(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long proveedorId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        
        log.info("GET /api/finanzas/liquidaciones/pendientes-cobrar - sucursal: {}, proveedor: {}, fechas: {} - {}", 
                sucursalId, proveedorId, fechaDesde, fechaHasta);

        List<Liquidacion> liquidaciones = liquidacionRepository.findPendientesPorCobrar(
                sucursalId, proveedorId, fechaDesde, fechaHasta);

        List<LiquidacionDTO> dtos = liquidaciones.stream()
                .map(liquidacionMapper::toDTO)
                .collect(Collectors.toList());

        return ResponseEntity.ok(dtos);
    }

    /**
     * Obtiene órdenes de giro marcadas como devolución aprobada (pendientes por cobrar).
     * Endpoint para consumo exclusivo de comercializacion-service.
     * 
     * @param sucursalId ID de sucursal (opcional)
     * @param solicitanteId ID de solicitante (opcional)
     * @param fechaDesde Fecha desde (opcional)
     * @param fechaHasta Fecha hasta (opcional)
     * @return Lista de órdenes de giro pendientes por cobrar
     */
    @GetMapping("/ordenes-giro/pendientes-cobrar")
    @Operation(summary = "Obtener órdenes de giro pendientes por cobrar",
               description = "Endpoint para consumo de comercializacion-service. Retorna órdenes de giro con devolución aprobada.")
    public ResponseEntity<List<SolicitudGiroDTO>> obtenerOrdenesGiroPendientesCobrar(
            @RequestParam(required = false) Long sucursalId,
            @RequestParam(required = false) Long solicitanteId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaDesde,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaHasta) {
        
        log.info("GET /api/finanzas/ordenes-giro/pendientes-cobrar - sucursal: {}, solicitante: {}, fechas: {} - {}", 
                sucursalId, solicitanteId, fechaDesde, fechaHasta);

        List<SolicitudGiro> ordenesGiro = solicitudGiroRepository.findPendientesPorCobrar(
                sucursalId, solicitanteId, fechaDesde, fechaHasta);

        List<SolicitudGiroDTO> dtos = ordenesGiro.stream()
                .map(solicitudGiroMapper::toDTO)
                .collect(Collectors.toList());

        return ResponseEntity.ok(dtos);
    }
}
