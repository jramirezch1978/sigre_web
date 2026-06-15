package com.sigre.rrhh.validation;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import com.sigre.common.exception.BusinessException;
import com.sigre.rrhh.constants.NovedadRrhhConstants;
import com.sigre.rrhh.repository.NovedadRrhhRepository;
import com.sigre.rrhh.repository.TipoNovedadRrhhRepository;
import com.sigre.rrhh.repository.TrabajadorRepository;
import java.time.LocalDate;

@Slf4j
@Component
@RequiredArgsConstructor
public class NovedadRrhhValidator {

    private final TrabajadorRepository trabajadorRepository;
    private final TipoNovedadRrhhRepository tipoNovedadRepository;
    private final NovedadRrhhRepository repository;

    public void validarTrabajador(Long trabajadorId) {
        if (!trabajadorRepository.existsById(trabajadorId))
            throw new BusinessException(NovedadRrhhConstants.MSG_TRABAJADOR_INEXISTENTE, HttpStatus.NOT_FOUND, NovedadRrhhConstants.ERROR_TRABAJADOR_INEXISTENTE);
    }

    public void validarTipoNovedad(Long tipoNovedadId) {
        if (!tipoNovedadRepository.existsById(tipoNovedadId))
            throw new BusinessException(NovedadRrhhConstants.MSG_TIPO_NOVEDAD_INEXISTENTE, HttpStatus.NOT_FOUND, NovedadRrhhConstants.ERROR_TIPO_NOVEDAD_INEXISTENTE);
    }

    public void validarFechas(LocalDate fechaIni, LocalDate fechaFin) {
        if (fechaFin.isBefore(fechaIni))
            throw new BusinessException(NovedadRrhhConstants.MSG_FECHAS_INVALIDAS, HttpStatus.BAD_REQUEST, NovedadRrhhConstants.ERROR_FECHAS_INVALIDAS);
    }

    public void validarSinDuplicado(Long trabajadorId, Long tipoNovedadId, LocalDate fechaIni, LocalDate fechaFin, Long excluirId) {
        if (repository.existsDuplicadoPeriodo(trabajadorId, tipoNovedadId, fechaIni, fechaFin, excluirId))
            throw new BusinessException(NovedadRrhhConstants.MSG_DUPLICADO_PERIODO, HttpStatus.CONFLICT, NovedadRrhhConstants.ERROR_DUPLICADO_PERIODO);
    }
}
