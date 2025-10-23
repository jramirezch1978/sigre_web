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
     * Determinar turno actual basándose en la hora de marcación
     * Algoritmo genérico que funciona con CUALQUIER cantidad de turnos:
     * 
     * LÓGICA: Calcula la distancia en minutos entre la hora de marcación
     * y la hora de INICIO de cada turno, y elige el turno MÁS CERCANO.
     * 
     * Ejemplos:
     * - 06:00 AM: Más cerca de 08:00 (TD) que de 20:00 (TN) → Asigna TD
     * - 07:50 PM: Más cerca de 20:00 (TN) que de 08:00 (TD) → Asigna TN
     * 
     * @throws RuntimeException si no hay turnos configurados
     */
    public String determinarTurnoActual(LocalDateTime fechaHoraMarcacion) {
        // Obtener todos los turnos activos
        List<Turno> turnosActivos = turnoRepository.findByFlagEstadoOrderByTurno("1");
        
        if (turnosActivos.isEmpty()) {
            String error = "No hay turnos activos configurados en el sistema. Por favor contacte al administrador.";
            log.error("❌ {}", error);
            throw new RuntimeException(error);
        }
        
        java.time.LocalDate fechaMarcacion = fechaHoraMarcacion.toLocalDate();
        
        String turnoMasCercano = null;
        long menorDistancia = Long.MAX_VALUE;
        LocalDateTime inicioTurnoMasCercano = null;
        LocalDateTime finTurnoMasCercano = null;
        
        // Evaluar TODOS los turnos y encontrar el que tenga la hora de inicio MÁS CERCANA
        for (Turno turno : turnosActivos) {
            if (turno.getHoraInicioNorm() == null || turno.getHoraFinalNorm() == null) {
                log.warn("⚠️ Turno {} no tiene horas configuradas, se omite", turno.getTurno());
                continue;
            }
            
            java.time.LocalTime horaInicio = turno.getHoraInicioNorm().toLocalTime();
            java.time.LocalTime horaFin = turno.getHoraFinalNorm().toLocalTime();
            
            // Construir inicio de turno para HOY
            LocalDateTime inicioTurnoHoy = fechaMarcacion.atTime(horaInicio);
            
            // Construir fin de intervalo según si es turno normal o nocturno
            LocalDateTime finIntervalo;
            if (horaFin.isAfter(horaInicio)) {
                // Turno normal: fin el mismo día
                finIntervalo = fechaMarcacion.atTime(horaFin);
            } else {
                // Turno nocturno: fin al día siguiente
                finIntervalo = fechaMarcacion.plusDays(1).atTime(horaFin);
            }
            
            // Calcular distancia entre hora de marcación e inicio del turno (solo HOY)
            long distancia = Math.abs(java.time.Duration.between(
                fechaHoraMarcacion, 
                inicioTurnoHoy).toMinutes());
            
            log.debug("📏 Turno {} | Inicio: {} | Fin: {} | Distancia: {} min", 
                    turno.getTurno(), inicioTurnoHoy, finIntervalo, distancia);
            
            // Actualizar si este turno está más cercano
            if (distancia < menorDistancia) {
                menorDistancia = distancia;
                turnoMasCercano = turno.getTurno();
                inicioTurnoMasCercano = inicioTurnoHoy;
                finTurnoMasCercano = finIntervalo;
            }
        }
        
        if (turnoMasCercano == null) {
            String error = "No se pudo determinar un turno válido. Verifique la configuración de turnos en el sistema.";
            log.error("❌ {}", error);
            throw new RuntimeException(error);
        }
        
        log.info("✅ TURNO DETERMINADO: {} | Distancia al inicio: {} min | Hora marcación: {} | Intervalo: {} - {}", 
                turnoMasCercano,
                menorDistancia,
                fechaHoraMarcacion,
                inicioTurnoMasCercano,
                finTurnoMasCercano);
        
        return turnoMasCercano;
    }
    
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
