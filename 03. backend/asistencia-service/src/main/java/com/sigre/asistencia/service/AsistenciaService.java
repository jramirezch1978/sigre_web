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
            
            // Determinar flag IN/OUT basado en el tipo de movimiento (ahora usa números 1-8)
            String flagInOut = mapearTipoMovimientoANumero(request.getTipoMovimiento());
            
            // Crear registro de asistencia
            LocalDateTime ahora = LocalDateTime.now();
            AsistenciaHt580 asistencia = AsistenciaHt580.builder()
                    .reckey(reckey)
                    .codOrigen(request.getCodOrigen() != null ? request.getCodOrigen() : "SE") // ✅ Usar codOrigen del request, fallback a SE
                    .codigo(request.getCodTrabajador())
                    .flagInOut(flagInOut)
                    .fechaRegistro(ahora)
                    .fechaMovimiento(ahora.toLocalDate())  // ✅ Convertir a LocalDate
                    .codUsuario(request.getCodUsuario())
                    .direccionIp(request.getDireccionIp())
                    .flagVerifyType("1") // Tipo verificación por defecto
                    .turno(request.getTurno() != null ? request.getTurno() : "0001")
                    .lecturaPda(String.format("Marcaje %s - %s", request.getTipoMarcaje(), request.getTipoMovimiento()))
                    .tipoMarcacion(determinarTipoMarcacion(request.getTipoMarcaje()))
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
                    asistenciaGuardada.getFechaMovimiento().atStartOfDay(),  // ✅ Convertir LocalDate a LocalDateTime
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
     * Mapear tipo de movimiento del frontend (string) a número (1-8) para FLAG_IN_OUT
     */
    private String mapearTipoMovimientoANumero(String tipoMovimiento) {
        if (tipoMovimiento == null) return "1"; // Por defecto ingreso
        
        return switch (tipoMovimiento.trim()) {
            case "INGRESO_PLANTA" -> "1";
            case "SALIDA_PLANTA" -> "2";
            case "SALIDA_ALMORZAR" -> "3";
            case "REGRESO_ALMORZAR" -> "4";
            case "SALIDA_COMISION" -> "5";
            case "RETORNO_COMISION" -> "6";
            case "INGRESO_PRODUCCION" -> "7";
            case "SALIDA_PRODUCCION" -> "8";
            default -> {
                log.warn("⚠️ Tipo movimiento no reconocido: '{}', usando 1 por defecto", tipoMovimiento);
                yield "1";
            }
        };
    }
    
    /**
     * Determinar tipo de marcación numérico para campo obligatorio
     */
    private String determinarTipoMarcacion(String tipoMarcaje) {
        if (tipoMarcaje == null) return "1"; // Por defecto puerta principal
        
        return switch (tipoMarcaje.trim()) {
            case "puerta-principal" -> "1";
            case "area-produccion" -> "2";
            default -> {
                log.warn("⚠️ Tipo marcaje no reconocido: '{}', usando 1 por defecto", tipoMarcaje);
                yield "1";
            }
        };
    }
}
