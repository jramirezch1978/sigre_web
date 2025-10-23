package com.sigre.asistencia.service;

import com.sigre.asistencia.dto.MarcacionRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;

/**
 * Servicio para validar horarios permitidos de movimientos de asistencia
 * Según prompt-ajustes-movimientos.txt: Validar que movimientos con horarios restringidos
 * solo se puedan registrar en sus horarios permitidos
 * 
 * NOTA: Los horarios vienen desde el frontend (appsettings.json)
 * NO se duplican parámetros en el backend
 */
@Service
@Slf4j
public class ValidacionHorarioService {
    
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
    
    /**
     * Validar si un movimiento puede registrarse en el horario especificado
     * 
     * @param tipoMovimiento Número del movimiento (1-10)
     * @param fechaHoraMarcacion Fecha y hora de la marcación
     * @param horariosPermitidos Horarios permitidos enviados desde frontend
     * @return ResultadoValidacionHorario con resultado y mensaje de error si aplica
     */
    public ResultadoValidacionHorario validarHorarioMovimiento(
            String tipoMovimiento, 
            LocalDateTime fechaHoraMarcacion,
            MarcacionRequest.HorariosPermitidos horariosPermitidos) {
        
        log.debug("🕐 Validando horario | Movimiento: {} | Fecha: {}", tipoMovimiento, fechaHoraMarcacion);
        
        // Si no vienen horarios, no validar (permitir)
        if (horariosPermitidos == null) {
            log.warn("⚠️ No se recibieron horarios permitidos desde frontend, omitiendo validación");
            return ResultadoValidacionHorario.valido();
        }
        
        // Solo validar movimientos 3 (Salida Almorzar) y 9 (Salida Cenar)
        if ("3".equals(tipoMovimiento)) {
            return validarHorarioSalidaAlmorzar(fechaHoraMarcacion, horariosPermitidos.getSalidaAlmorzar());
        } else if ("9".equals(tipoMovimiento)) {
            return validarHorarioSalidaCenar(fechaHoraMarcacion, horariosPermitidos.getSalidaCenar());
        }
        
        // Para otros movimientos, siempre es válido
        return ResultadoValidacionHorario.valido();
    }
    
    /**
     * Validar horario para Salida a Almorzar (Movimiento 3)
     */
    private ResultadoValidacionHorario validarHorarioSalidaAlmorzar(
            LocalDateTime fechaHora, 
            MarcacionRequest.HorarioRango horario) {
        
        if (horario == null || horario.getInicio() == null || horario.getFin() == null) {
            log.warn("⚠️ Horario de almuerzo no configurado, omitiendo validación");
            return ResultadoValidacionHorario.valido();
        }
        
        LocalTime horaActual = fechaHora.toLocalTime();
        LocalTime horaInicio = LocalTime.parse(horario.getInicio(), TIME_FORMATTER);
        LocalTime horaFin = LocalTime.parse(horario.getFin(), TIME_FORMATTER);
        
        if (horaActual.isBefore(horaInicio) || horaActual.isAfter(horaFin)) {
            String mensaje = String.format(
                "Salida a Almorzar solo permitida entre %s y %s. Hora actual: %s",
                horario.getInicio(), horario.getFin(), horaActual.format(TIME_FORMATTER)
            );
            log.warn("❌ {}", mensaje);
            return ResultadoValidacionHorario.invalido(mensaje);
        }
        
        log.debug("✅ Horario válido para Salida a Almorzar: {}", horaActual);
        return ResultadoValidacionHorario.valido();
    }
    
    /**
     * Validar horario para Salida a Cenar (Movimiento 9)
     */
    private ResultadoValidacionHorario validarHorarioSalidaCenar(
            LocalDateTime fechaHora, 
            MarcacionRequest.HorarioRango horario) {
        
        if (horario == null || horario.getInicio() == null || horario.getFin() == null) {
            log.warn("⚠️ Horario de cena no configurado, omitiendo validación");
            return ResultadoValidacionHorario.valido();
        }
        
        LocalTime horaActual = fechaHora.toLocalTime();
        LocalTime horaInicio = LocalTime.parse(horario.getInicio(), TIME_FORMATTER);
        LocalTime horaFin = LocalTime.parse(horario.getFin(), TIME_FORMATTER);
        
        if (horaActual.isBefore(horaInicio) || horaActual.isAfter(horaFin)) {
            String mensaje = String.format(
                "Salida a Cenar solo permitida entre %s y %s. Hora actual: %s",
                horario.getInicio(), horario.getFin(), horaActual.format(TIME_FORMATTER)
            );
            log.warn("❌ {}", mensaje);
            return ResultadoValidacionHorario.invalido(mensaje);
        }
        
        log.debug("✅ Horario válido para Salida a Cenar: {}", horaActual);
        return ResultadoValidacionHorario.valido();
    }
    
    /**
     * DTO para resultado de validación de horario
     */
    public static class ResultadoValidacionHorario {
        private final boolean valido;
        private final String mensajeError;
        
        private ResultadoValidacionHorario(boolean valido, String mensajeError) {
            this.valido = valido;
            this.mensajeError = mensajeError;
        }
        
        public static ResultadoValidacionHorario valido() {
            return new ResultadoValidacionHorario(true, null);
        }
        
        public static ResultadoValidacionHorario invalido(String mensaje) {
            return new ResultadoValidacionHorario(false, mensaje);
        }
        
        public boolean isValido() {
            return valido;
        }
        
        public String getMensajeError() {
            return mensajeError;
        }
    }
}

