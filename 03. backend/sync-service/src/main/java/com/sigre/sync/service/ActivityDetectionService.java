package com.sigre.sync.service;

import com.sigre.sync.repository.local.AsistenciaHt580LocalRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

/**
 * Servicio para detectar actividad en el sistema antes de enviar reportes
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class ActivityDetectionService {
    
    private final AsistenciaHt580LocalRepository asistenciaLocalRepository;
    
    /**
     * Verificar si ha habido actividad en los últimos X minutos
     * Retorna true si:
     * - Han habido nuevas marcas de asistencia
     * - Ha ocurrido alguna sincronización 
     * - Ha habido algún error
     */
    public boolean hayActividadReciente(int minutosAtras) {
        LocalDateTime fechaLimite = LocalDateTime.now().minusMinutes(minutosAtras);
        
        log.info("🔍 Verificando actividad desde: {}", fechaLimite);
        
        // Verificar nuevos registros de asistencia
        long nuevosRegistros = asistenciaLocalRepository.countNuevosRegistrosDesde(fechaLimite);
        log.info("📝 Nuevos registros de asistencia: {}", nuevosRegistros);
        
        // Verificar sincronizaciones recientes
        long sincronizaciones = asistenciaLocalRepository.countSincronizacionesDesde(fechaLimite);
        log.info("🔄 Sincronizaciones recientes: {}", sincronizaciones);
        
        // Verificar errores recientes
        long errores = asistenciaLocalRepository.countErroresDesde(fechaLimite);
        log.info("❌ Errores recientes: {}", errores);
        
        boolean hayActividad = (nuevosRegistros > 0) || (sincronizaciones > 0) || (errores > 0);
        
        if (hayActividad) {
            log.info("✅ ACTIVIDAD DETECTADA - Se enviará reporte:");
            log.info("   📝 Nuevos registros: {}", nuevosRegistros);
            log.info("   🔄 Sincronizaciones: {}", sincronizaciones);
            log.info("   ❌ Errores: {}", errores);
        } else {
            log.info("😴 SIN ACTIVIDAD - No se enviará reporte (sistema tranquilo)");
        }
        
        return hayActividad;
    }
    
    /**
     * Obtener resumen de actividad para logs detallados
     */
    public String getResumenActividad(int minutosAtras) {
        LocalDateTime fechaLimite = LocalDateTime.now().minusMinutes(minutosAtras);
        
        long nuevosRegistros = asistenciaLocalRepository.countNuevosRegistrosDesde(fechaLimite);
        long sincronizaciones = asistenciaLocalRepository.countSincronizacionesDesde(fechaLimite);
        long errores = asistenciaLocalRepository.countErroresDesde(fechaLimite);
        
        return String.format("Actividad últimos %d min: %d registros, %d sync, %d errores", 
                minutosAtras, nuevosRegistros, sincronizaciones, errores);
    }
}
