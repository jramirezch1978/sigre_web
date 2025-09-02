package com.sigre.asistencia.service;

import com.sigre.asistencia.dto.RacionRequestDto;
import com.sigre.asistencia.entity.Maestro;
import com.sigre.asistencia.entity.RacionesSeleccionadas;
import com.sigre.asistencia.repository.MaestroRepository;
import com.sigre.asistencia.repository.RacionesSeleccionadasRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Slf4j
public class RacionesService {
    
    private final RacionesSeleccionadasRepository racionesRepository;
    private final MaestroRepository maestroRepository;
    
    /**
     * Registrar selección de ración
     */
    @Transactional
    public String registrarRacion(RacionRequestDto request) {
        log.info("Registrando ración para trabajador: {} - Tipo: {}", 
                request.getCodTrabajador(), request.getTipoRacion());
        
        try {
            // Validar que el trabajador existe
            Optional<Maestro> trabajador = maestroRepository.findByCodTrabajadorAndFlagEstado(request.getCodTrabajador(), "1");
            if (trabajador.isEmpty()) {
                return "Error: Trabajador no encontrado o inactivo";
            }
            
            LocalDate hoy = LocalDate.now();
            
            // Verificar si ya seleccionó esta ración hoy
            boolean yaSeleccionada = racionesRepository.existsByCodTrabajadorAndFechaAndTipoRacionAndFlagEstado(
                    request.getCodTrabajador(), hoy, request.getTipoRacion(), "1");
            
            if (yaSeleccionada) {
                return "Error: Ya seleccionó esta ración hoy";
            }
            
            // Validar horarios de ración
            if (!validarHorarioRacion(request.getTipoRacion())) {
                return "Error: Ración no disponible en este horario";
            }
            
            // Crear registro de ración
            RacionesSeleccionadas racion = RacionesSeleccionadas.builder()
                    .codTrabajador(request.getCodTrabajador())
                    .fecha(hoy)
                    .tipoRacion(request.getTipoRacion())
                    .fechaRegistro(LocalDateTime.now())
                    .codUsuario(request.getCodUsuario())
                    .direccionIp(request.getDireccionIp())
                    .observaciones(request.getObservaciones())
                    .flagEstado("1")
                    .build();
            
            // Guardar en base de datos
            RacionesSeleccionadas racionGuardada = racionesRepository.save(racion);
            
            log.info("Ración registrada exitosamente - ID: {}", racionGuardada.getIdRacionComedor());
            
            return "Ración " + request.getTipoRacion() + " registrada exitosamente";
            
        } catch (Exception e) {
            log.error("Error al registrar ración para trabajador: {}", request.getCodTrabajador(), e);
            return "Error interno al registrar ración: " + e.getMessage();
        }
    }
    
    /**
     * Obtener raciones ya seleccionadas por un trabajador hoy
     */
    public List<String> getRacionesSeleccionadasHoy(String codTrabajador) {
        LocalDate hoy = LocalDate.now();
        return racionesRepository.findTiposRacionByTrabajadorAndFecha(codTrabajador, hoy);
    }
    
    /**
     * Validar si una ración está disponible en el horario actual
     */
    private boolean validarHorarioRacion(String tipoRacion) {
        int horaActual = LocalDateTime.now().getHour();
        
        switch (tipoRacion.toUpperCase()) {
            case "D":
                // Desayuno disponible de 6:00 a 9:00
                return horaActual >= 6 && horaActual < 9;
            case "A":
                // Almuerzo disponible hasta mediodía
                return horaActual < 12;
            case "C":
                // Cena disponible después de mediodía
                return horaActual >= 12;
            default:
                log.warn("Tipo de ración no reconocido: {}", tipoRacion);
                return false;
        }
    }
    
    /**
     * Obtener estadísticas de raciones por fecha
     */
    public long contarRacionesPorTipoYFecha(String tipoRacion, LocalDate fecha) {
        return racionesRepository.countRacionesByFechaAndTipo(fecha, tipoRacion);
    }
    
    /**
     * Verificar si un trabajador puede seleccionar más raciones hoy
     */
    public boolean puedeSeleccionarMasRaciones(String codTrabajador) {
        List<String> racionesHoy = getRacionesSeleccionadasHoy(codTrabajador);
        
        // Un trabajador puede seleccionar máximo 3 raciones por día (desayuno, almuerzo, cena)
        // Pero no puede repetir el mismo tipo
        return racionesHoy.size() < 3;
    }
}
