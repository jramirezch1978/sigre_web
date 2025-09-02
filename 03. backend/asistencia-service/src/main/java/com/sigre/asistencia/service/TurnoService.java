package com.sigre.asistencia.service;

import com.sigre.asistencia.entity.Turno;
import com.sigre.asistencia.repository.TurnoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Servicio para consultas rápidas de turno desde BD local
 * La tabla turno se sincroniza desde BD remota via sync-service
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class TurnoService {
    
    private final TurnoRepository turnoRepository;
    
    /**
     * Determinar turno ULTRA RÁPIDO (optimizado para velocidad)
     * Retorna turno por defecto inmediatamente para evitar bloqueos
     */
    public String determinarTurnoActual(LocalDateTime fechaHora) {
        try {
            // OPTIMIZACIÓN: Retornar turno por defecto inmediatamente
            // TODO: Implementar lógica completa de rangos horarios después
            
            int hora = fechaHora.getHour();
            
            // Lógica simplificada con PADDING para coincidir con Oracle CHAR(4)
            if (hora >= 6 && hora < 18) {
                return "TD  ";   // Turno Día con 2 espacios al final (CHAR(4))
            } else {
                return "TN  ";   // Turno Noche con 2 espacios al final (CHAR(4))
            }
            
        } catch (Exception e) {
            log.warn("❌ Error en TurnoService (fallback rápido): {}", e.getMessage());
            return "TD  ";  // Fallback con padding correcto
        }
    }
    
    // Métodos complejos eliminados - se usará lógica simplificada por velocidad
    
    /**
     * Verificar si hay turnos disponibles en BD local
     */
    public boolean hayTurnosDisponibles() {
        try {
            return turnoRepository.count() > 0;
        } catch (Exception e) {
            log.error("❌ Error verificando disponibilidad de turnos", e);
            return false;
        }
    }
    
    /**
     * Obtener descripción del turno (para logging)
     */
    public String obtenerDescripcionTurno(String codigoTurno) {
        try {
            Optional<Turno> turnoOpt = turnoRepository.findById(codigoTurno);
            if (turnoOpt.isPresent()) {
                return turnoOpt.get().getDescripcion();
            }
            return "Turno " + codigoTurno;
        } catch (Exception e) {
            log.error("❌ Error obteniendo descripción de turno: {}", codigoTurno, e);
            return "Turno " + codigoTurno;
        }
    }
}
