package com.sigre.asistencia.service;

import com.sigre.asistencia.dto.AsistenciaRequestDto;
import com.sigre.asistencia.dto.AsistenciaResponseDto;
import com.sigre.asistencia.entity.AsistenciaHt580;
import com.sigre.asistencia.entity.Maestro;
import com.sigre.asistencia.repository.AsistenciaHt580Repository;
import com.sigre.asistencia.repository.MaestroRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class AsistenciaService {
    
    private final AsistenciaHt580Repository asistenciaRepository;
    private final MaestroRepository maestroRepository;
    private final TrabajadorService trabajadorService;
    
    /**
     * Registrar asistencia de un trabajador
     */
    @Transactional
    public AsistenciaResponseDto registrarAsistencia(AsistenciaRequestDto request) {
        log.info("Registrando asistencia para trabajador: {} - Movimiento: {}", 
                request.getCodTrabajador(), request.getTipoMovimiento());
        
        try {
            // Validar que el trabajador existe y puede marcar
            Optional<Maestro> trabajador = maestroRepository.findByCodTrabajadorAndFlagEstado(request.getCodTrabajador(), "1");
            if (trabajador.isEmpty()) {
                return AsistenciaResponseDto.error("Trabajador no encontrado o inactivo");
            }
            
            if (!trabajadorService.puedeMarcarAsistencia(request.getCodTrabajador())) {
                return AsistenciaResponseDto.error("Trabajador no habilitado para marcar asistencia");
            }
            
            // Generar RECKEY único
            String reckey = generarReckey();
            
            // Determinar flag IN/OUT basado en el tipo de movimiento
            String flagInOut = determinarFlagInOut(request.getTipoMovimiento());
            
            // Crear registro de asistencia
            LocalDateTime ahora = LocalDateTime.now();
            AsistenciaHt580 asistencia = AsistenciaHt580.builder()
                    .reckey(reckey)
                    .codOrigen("01") // Código origen por defecto
                    .codigo(request.getCodTrabajador())
                    .flagInOut(flagInOut)
                    .fechaRegistro(ahora)
                    .fechaMovimiento(ahora)
                    .codUsuario(request.getCodUsuario())
                    .direccionIp(request.getDireccionIp())
                    .flagVerifyType("1") // Tipo verificación por defecto
                    .turno(request.getTurno() != null ? request.getTurno() : "0001")
                    .lecturaPda(String.format("Marcaje %s - %s", request.getTipoMarcaje(), request.getTipoMovimiento()))
                    .build();
            
            // Guardar en base de datos
            AsistenciaHt580 asistenciaGuardada = asistenciaRepository.save(asistencia);
            
            log.info("Asistencia registrada exitosamente - RECKEY: {}", reckey);
            
            return AsistenciaResponseDto.exitoso(
                    asistenciaGuardada.getReckey(),
                    trabajador.get().getCodTrabajador(),
                    trabajador.get().getNombreCompleto(),
                    request.getTipoMovimiento(),
                    request.getTipoMarcaje(),
                    asistenciaGuardada.getFechaRegistro(),
                    asistenciaGuardada.getFechaMovimiento(),
                    "Asistencia registrada exitosamente"
            );
            
        } catch (Exception e) {
            log.error("Error al registrar asistencia para trabajador: {}", request.getCodTrabajador(), e);
            return AsistenciaResponseDto.error("Error interno al registrar asistencia: " + e.getMessage());
        }
    }
    
    /**
     * Generar RECKEY único para el registro de asistencia
     */
    private String generarReckey() {
        // Formato: YYYYMMDDHHMM (12 caracteres)
        LocalDateTime ahora = LocalDateTime.now();
        String timestamp = ahora.format(DateTimeFormatter.ofPattern("yyyyMMddHHmm"));
        
        // Verificar que no existe
        String reckey = timestamp;
        int contador = 0;
        while (asistenciaRepository.existsById(reckey)) {
            contador++;
            reckey = timestamp.substring(0, 11) + contador; // Reemplazar último dígito con contador
            if (contador > 9) {
                // Si hay más de 9 registros en el mismo minuto, usar timestamp con segundos
                timestamp = ahora.format(DateTimeFormatter.ofPattern("yyyyMMddHHmmss"));
                reckey = timestamp.substring(0, 12);
                break;
            }
        }
        
        return reckey;
    }
    
    /**
     * Determinar flag IN/OUT basado en el tipo de movimiento
     */
    private String determinarFlagInOut(String tipoMovimiento) {
        switch (tipoMovimiento) {
            case "INGRESO_PLANTA":
            case "INGRESO_ALMORZAR":
            case "INGRESO_PRODUCCION":
                return "I"; // Ingreso
            case "SALIDA_PLANTA":
            case "SALIDA_ALMORZAR":
            case "SALIDA_PRODUCCION":
                return "O"; // Salida (Out)
            default:
                log.warn("Tipo de movimiento no reconocido: {}, usando 'I' por defecto", tipoMovimiento);
                return "I";
        }
    }
}
