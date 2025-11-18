package com.sigre.contabilidad.controller;

import com.sigre.contabilidad.model.entity.AsientoContable;
import com.sigre.contabilidad.service.AsientoService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * Controlador REST para Asientos Contables
 */
@Slf4j
@RestController
@RequestMapping("/asientos")
@RequiredArgsConstructor
@Tag(name = "Asientos Contables", description = "APIs para gestión de asientos contables")
public class AsientoController {

    private final AsientoService asientoService;

    @GetMapping("/periodo")
    @Operation(summary = "Obtener asientos por periodo", 
               description = "Obtiene todos los asientos de un libro y periodo específico")
    public ResponseEntity<List<AsientoContable>> obtenerPorPeriodo(
            @RequestParam String empresa,
            @RequestParam String libro,
            @RequestParam String periodo) {
        
        log.info("GET /asientos/periodo - Empresa: {}, Libro: {}, Periodo: {}", 
                 empresa, libro, periodo);
        
        List<AsientoContable> asientos = asientoService.obtenerAsientosPorPeriodo(empresa, libro, periodo);
        return ResponseEntity.ok(asientos);
    }

    @GetMapping("/rango-fechas")
    @Operation(summary = "Obtener asientos por rango de fechas",
               description = "Obtiene todos los asientos dentro de un rango de fechas")
    public ResponseEntity<List<AsientoContable>> obtenerPorRangoFechas(
            @RequestParam String empresa,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaInicio,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fechaFin) {
        
        log.info("GET /asientos/rango-fechas - Empresa: {}, Desde: {}, Hasta: {}", 
                 empresa, fechaInicio, fechaFin);
        
        List<AsientoContable> asientos = asientoService.obtenerAsientosPorRangoFechas(
            empresa, fechaInicio, fechaFin);
        return ResponseEntity.ok(asientos);
    }

    @PostMapping
    @Operation(summary = "Crear asiento contable",
               description = "Crea un nuevo asiento contable")
    public ResponseEntity<AsientoContable> crearAsiento(@RequestBody AsientoContable asiento) {
        log.info("POST /asientos - Libro: {}, Origen: {}", 
                 asiento.getId().getLibro(), asiento.getId().getOrigen());
        
        AsientoContable nuevoAsiento = asientoService.crearAsiento(asiento);
        return ResponseEntity.ok(nuevoAsiento);
    }

    @GetMapping("/pendientes")
    @Operation(summary = "Obtener asientos pendientes de integración",
               description = "Obtiene asientos que aún no han sido transferidos desde otro módulo")
    public ResponseEntity<List<AsientoContable>> obtenerPendientes(
            @RequestParam String empresa,
            @RequestParam String origenIntegracion) {
        
        log.info("GET /asientos/pendientes - Empresa: {}, Origen: {}", 
                 empresa, origenIntegracion);
        
        List<AsientoContable> pendientes = asientoService.obtenerAsientosPendientes(
            empresa, origenIntegracion);
        return ResponseEntity.ok(pendientes);
    }

    @GetMapping("/health")
    @Operation(summary = "Health check del módulo de contabilidad")
    public ResponseEntity<Map<String, String>> health() {
        return ResponseEntity.ok(Map.of(
            "status", "UP",
            "service", "contabilidad-service",
            "module", "asientos",
            "timestamp", LocalDate.now().toString()
        ));
    }
}

