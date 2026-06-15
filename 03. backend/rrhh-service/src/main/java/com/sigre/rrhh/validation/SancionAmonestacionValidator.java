package com.sigre.rrhh.validation;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import com.sigre.common.exception.BusinessException;
import com.sigre.rrhh.constants.SancionAmonestacionConstants;
import com.sigre.rrhh.repository.SancionAmonestacionRepository;
import com.sigre.rrhh.repository.TipoSancionRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;
import java.time.LocalDate;

@Slf4j
@Component
@RequiredArgsConstructor
public class SancionAmonestacionValidator {

    private final TrabajadorRepository trabajadorRepository;
    private final TipoSancionRepository tipoSancionRepository;

    public void validarTrabajador(Long trabajadorId) {
        if (!trabajadorRepository.existsById(trabajadorId)) {
            log.warn("Trabajador inexistente: {}", trabajadorId);
            throw new BusinessException(SancionAmonestacionConstants.MSG_TRABAJADOR_INEXISTENTE, HttpStatus.NOT_FOUND, SancionAmonestacionConstants.ERROR_TRABAJADOR_INEXISTENTE);
        }
    }

    public void validarTipoSancion(Long tipoSancionId) {
        if (!tipoSancionRepository.existsById(tipoSancionId)) {
            log.warn("Tipo sanción inexistente: {}", tipoSancionId);
            throw new BusinessException(SancionAmonestacionConstants.MSG_TIPO_SANCION_INEXISTENTE, HttpStatus.NOT_FOUND, SancionAmonestacionConstants.ERROR_TIPO_SANCION_INEXISTENTE);
        }
    }

    public void validarFechaNoFutura(LocalDate fecha) {
        if (fecha != null && fecha.isAfter(LocalDate.now())) {
            log.warn("Fecha futura no permitida: {}", fecha);
            throw new BusinessException(SancionAmonestacionConstants.MSG_FECHA_FUTURA, HttpStatus.BAD_REQUEST, SancionAmonestacionConstants.ERROR_FECHA_FUTURA);
        }
    }
}
