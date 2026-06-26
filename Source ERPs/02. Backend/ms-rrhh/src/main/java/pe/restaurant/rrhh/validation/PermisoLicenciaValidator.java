package pe.restaurant.rrhh.validation;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.constants.PermisoLicenciaConstants;
import pe.restaurant.rrhh.repository.PermisoLicenciaDetRepository;
import pe.restaurant.rrhh.repository.TipoSuspensionLaboralRepository;
import pe.restaurant.rrhh.repository.TrabajadorRepository;

import java.time.LocalDate;

@Slf4j
@Component
@RequiredArgsConstructor
public class PermisoLicenciaValidator {

    private final PermisoLicenciaDetRepository detRepository;
    private final TrabajadorRepository trabajadorRepository;
    private final TipoSuspensionLaboralRepository tipoSuspensionRepository;

    public void validarTrabajador(Long trabajadorId) {
        if (!trabajadorRepository.existsById(trabajadorId)) {
            log.warn("Trabajador inexistente: {}", trabajadorId);
            throw new BusinessException(PermisoLicenciaConstants.MSG_TRABAJADOR_INEXISTENTE,
                    HttpStatus.NOT_FOUND, PermisoLicenciaConstants.ERROR_TRABAJADOR_INEXISTENTE);
        }
    }

    public void validarTipoSuspension(Long tipoSuspensionLaboralId) {
        if (tipoSuspensionLaboralId != null && !tipoSuspensionRepository.existsById(tipoSuspensionLaboralId)) {
            log.warn("Tipo suspensión inexistente: {}", tipoSuspensionLaboralId);
            throw new BusinessException(PermisoLicenciaConstants.MSG_TIPO_SUSPENSION_INEXISTENTE,
                    HttpStatus.NOT_FOUND, PermisoLicenciaConstants.ERROR_TIPO_SUSPENSION_INEXISTENTE);
        }
    }

    public void validarFechas(LocalDate fechaInicio, LocalDate fechaFin) {
        if (fechaFin != null && fechaFin.isBefore(fechaInicio)) {
            log.warn("Fechas inválidas: inicio={}, fin={}", fechaInicio, fechaFin);
            throw new BusinessException(PermisoLicenciaConstants.MSG_FECHAS_INVALIDAS,
                    HttpStatus.BAD_REQUEST, PermisoLicenciaConstants.ERROR_FECHAS_INVALIDAS);
        }
    }

    public void validarSinSolapamiento(Long trabajadorId, LocalDate fechaInicio, LocalDate fechaFin, Long excluirPermisoId) {
        LocalDate fin = fechaFin != null ? fechaFin : fechaInicio;
        if (detRepository.existsSolapamiento(trabajadorId, fechaInicio, fin, excluirPermisoId)) {
            log.warn("Solapamiento detectado para trabajador {} entre {} y {}", trabajadorId, fechaInicio, fin);
            throw new BusinessException(PermisoLicenciaConstants.MSG_SOLAPAMIENTO,
                    HttpStatus.CONFLICT, PermisoLicenciaConstants.ERROR_SOLAPAMIENTO);
        }
    }
}
