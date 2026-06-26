package pe.restaurant.rrhh.validation;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.constants.CapacitacionConstants;
import pe.restaurant.rrhh.repository.CapacitacionRepository;
import pe.restaurant.rrhh.repository.CapacitacionTrabajadorRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;
import java.time.LocalDate;

@Slf4j
@Component
@RequiredArgsConstructor
public class CapacitacionValidator {

    private final CapacitacionRepository repository;
    private final CapacitacionTrabajadorRepository ctRepository;
    private final TrabajadorRepository trabajadorRepository;

    public void validarFechas(LocalDate fechaInicio, LocalDate fechaFin) {
        if (fechaInicio != null && fechaFin != null && fechaFin.isBefore(fechaInicio)) {
            log.warn("Fechas inválidas: inicio={}, fin={}", fechaInicio, fechaFin);
            throw new BusinessException(CapacitacionConstants.MSG_FECHAS_INVALIDAS, HttpStatus.BAD_REQUEST, CapacitacionConstants.ERROR_FECHAS_INVALIDAS);
        }
    }

    public void validarSinParticipantes(Long capacitacionId) {
        if (repository.existsParticipantesByCapacitacionId(capacitacionId)) {
            log.warn("Capacitación {} tiene participantes activos", capacitacionId);
            throw new BusinessException(CapacitacionConstants.MSG_ELIMINACION_CON_PARTICIPANTES, HttpStatus.BAD_REQUEST, CapacitacionConstants.ERROR_ELIMINACION_CON_PARTICIPANTES);
        }
    }

    public void validarTrabajador(Long trabajadorId) {
        if (!trabajadorRepository.existsById(trabajadorId)) {
            log.warn("Trabajador inexistente: {}", trabajadorId);
            throw new BusinessException(CapacitacionConstants.MSG_TRABAJADOR_INEXISTENTE, HttpStatus.NOT_FOUND, CapacitacionConstants.ERROR_TRABAJADOR_INEXISTENTE);
        }
    }

    public void validarParticipanteNoDuplicado(Long capacitacionId, Long trabajadorId) {
        if (ctRepository.existsByCapacitacionIdAndTrabajadorId(capacitacionId, trabajadorId)) {
            log.warn("Participante duplicado: capacitación={}, trabajador={}", capacitacionId, trabajadorId);
            throw new BusinessException(CapacitacionConstants.MSG_PARTICIPANTE_DUPLICADO, HttpStatus.CONFLICT, CapacitacionConstants.ERROR_PARTICIPANTE_DUPLICADO);
        }
    }
}
