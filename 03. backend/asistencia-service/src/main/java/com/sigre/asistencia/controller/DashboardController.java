package com.sigre.asistencia.controller;

import com.sigre.asistencia.dto.dashboard.*;
import com.sigre.asistencia.service.DashboardService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

/**
 * Controlador REST para el dashboard de asistencia
 * Proporciona endpoints para estadísticas y visualización de datos
 */
@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
@Slf4j
public class DashboardController {
    
    private final DashboardService dashboardService;
    
    /**
     * Obtener dashboard completo con todas las estadísticas
     */
    @GetMapping("/completo")
    public ResponseEntity<DashboardResponseDto> obtenerDashboardCompleto() {
        log.info("📊 Solicitando dashboard completo");
        try {
            DashboardResponseDto dashboard = dashboardService.obtenerDashboardCompleto();
            log.info("✅ Dashboard generado exitosamente");
            return ResponseEntity.ok(dashboard);
        } catch (Exception e) {
            log.error("❌ Error generando dashboard completo: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    /**
     * Obtener estadísticas generales
     */
    @GetMapping("/estadisticas-generales")
    public ResponseEntity<EstadisticasGeneralesDto> obtenerEstadisticasGenerales() {
        log.info("📈 Solicitando estadísticas generales");
        try {
            EstadisticasGeneralesDto estadisticas = dashboardService.obtenerEstadisticasGenerales();
            return ResponseEntity.ok(estadisticas);
        } catch (Exception e) {
            log.error("❌ Error obteniendo estadísticas generales: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    /**
     * Obtener marcajes por hora del día actual
     */
    @GetMapping("/marcajes-del-dia")
    public ResponseEntity<MarcajesPorHoraDto> obtenerMarcajesDelDia() {
        log.info("📊 Solicitando marcajes por hora del día");
        try {
            MarcajesPorHoraDto marcajes = dashboardService.obtenerMarcajesDelDia();
            return ResponseEntity.ok(marcajes);
        } catch (Exception e) {
            log.error("❌ Error obteniendo marcajes del día: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    /**
     * Obtener marcajes por hora de las últimas 24 horas
     */
    @GetMapping("/marcajes-24h")
    public ResponseEntity<MarcajesPorHoraDto> obtenerMarcajesUltimas24Horas() {
        log.info("📊 Solicitando marcajes de las últimas 24 horas");
        try {
            MarcajesPorHoraDto marcajes = dashboardService.obtenerMarcajesUltimas24Horas();
            return ResponseEntity.ok(marcajes);
        } catch (Exception e) {
            log.error("❌ Error obteniendo marcajes últimas 24h: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    /**
     * Obtener listado detallado de marcajes del día
     */
    @GetMapping("/listado-marcajes")
    public ResponseEntity<List<MarcajeDelDiaDto>> obtenerListadoMarcajesHoy() {
        log.info("📋 Solicitando listado de marcajes del día");
        try {
            List<MarcajeDelDiaDto> marcajes = dashboardService.obtenerListadoMarcajesHoy();
            log.info("📋 Obtenidos {} marcajes del día", marcajes.size());
            return ResponseEntity.ok(marcajes);
        } catch (Exception e) {
            log.error("❌ Error obteniendo listado de marcajes: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    /**
     * Obtener resumen de marcajes por centro de costo
     */
    @GetMapping("/resumen-centro-costo")
    public ResponseEntity<List<MarcajesPorCentroCostoDto.ResumenCentroCosto>> obtenerResumenPorCentroCosto() {
        log.info("🏢 Solicitando resumen por centro de costo");
        try {
            List<MarcajesPorCentroCostoDto.ResumenCentroCosto> resumen = 
                dashboardService.obtenerResumenPorCentroCosto();
            return ResponseEntity.ok(resumen);
        } catch (Exception e) {
            log.error("❌ Error obteniendo resumen por centro de costo: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    /**
     * Obtener marcajes detallados por centro de costo específico
     */
    @GetMapping("/marcajes-centro-costo/{centroCosto}")
    public ResponseEntity<MarcajesPorCentroCostoDto> obtenerMarcajesPorCentroCosto(
            @PathVariable String centroCosto) {
        log.info("🏢 Solicitando marcajes para centro de costo: {}", centroCosto);
        try {
            MarcajesPorCentroCostoDto marcajes = dashboardService.obtenerMarcajesPorCentroCosto(centroCosto);
            return ResponseEntity.ok(marcajes);
        } catch (Exception e) {
            log.error("❌ Error obteniendo marcajes para centro {}: {}", centroCosto, e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    /**
     * Obtener raciones por tipo del día actual
     */
    @GetMapping("/raciones-por-tipo")
    public ResponseEntity<RacionesPorTipoDto> obtenerRacionesPorTipo() {
        log.info("🍽️ Solicitando raciones por tipo del día");
        try {
            RacionesPorTipoDto raciones = dashboardService.obtenerRacionesPorTipo();
            return ResponseEntity.ok(raciones);
        } catch (Exception e) {
            log.error("❌ Error obteniendo raciones por tipo: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    /**
     * Obtener total de trabajadores únicos que han marcado hoy
     */
    @GetMapping("/trabajadores-unicos-hoy")
    public ResponseEntity<Long> obtenerTrabajadoresUnicosHoy() {
        log.info("👥 Solicitando trabajadores únicos que han marcado hoy");
        try {
            Long trabajadores = dashboardService.obtenerTrabajadoresUnicosHoy();
            return ResponseEntity.ok(trabajadores);
        } catch (Exception e) {
            log.error("❌ Error obteniendo trabajadores únicos: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
    
    /**
     * Health check específico para el dashboard
     */
    @GetMapping("/health")
    public ResponseEntity<String> health() {
        try {
            EstadisticasGeneralesDto stats = dashboardService.obtenerEstadisticasGenerales();
            return ResponseEntity.ok("Dashboard Service OK - Última actualización: " +
                stats.getUltimaActualizacion());
        } catch (Exception e) {
            log.error("❌ Health check falló: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError()
                .body("Dashboard Service ERROR: " + e.getMessage());
        }
    }

    /**
     * Obtener indicadores de centros de costo con movimientos pivoteados
     */
    @GetMapping("/indicadores-centros-costo")
    public ResponseEntity<List<MarcajesPorCentroCostoDto.IndicadorCentroCosto>> obtenerIndicadoresCentrosCosto(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {
        log.info("📊 Solicitando indicadores de centros de costo para fecha: {}", fecha);
        try {
            List<MarcajesPorCentroCostoDto.IndicadorCentroCosto> indicadores =
                fecha != null ? dashboardService.obtenerIndicadoresCentrosCosto(fecha) :
                               dashboardService.obtenerIndicadoresCentrosCosto();
            return ResponseEntity.ok(indicadores);
        } catch (Exception e) {
            log.error("❌ Error obteniendo indicadores de centros de costo: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Obtener indicadores de áreas con movimientos pivoteados
     */
    @GetMapping("/indicadores-areas")
    public ResponseEntity<List<IndicadoresAreaDto>> obtenerIndicadoresAreas(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {
        log.info("📊 Solicitando indicadores de áreas para fecha: {}", fecha);
        try {
            List<IndicadoresAreaDto> indicadores =
                fecha != null ? dashboardService.obtenerIndicadoresAreas(fecha) :
                               dashboardService.obtenerIndicadoresAreas();
            return ResponseEntity.ok(indicadores);
        } catch (Exception e) {
            log.error("❌ Error obteniendo indicadores de áreas: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Obtener indicadores de secciones con movimientos pivoteados
     */
    @GetMapping("/indicadores-secciones")
    public ResponseEntity<List<IndicadoresSeccionDto>> obtenerIndicadoresSecciones(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fecha) {
        log.info("📊 Solicitando indicadores de secciones para fecha: {}", fecha);
        try {
            List<IndicadoresSeccionDto> indicadores =
                fecha != null ? dashboardService.obtenerIndicadoresSecciones(fecha) :
                               dashboardService.obtenerIndicadoresSecciones();
            return ResponseEntity.ok(indicadores);
        } catch (Exception e) {
            log.error("❌ Error obteniendo indicadores de secciones: {}", e.getMessage(), e);
            return ResponseEntity.internalServerError().build();
        }
    }
}
