package pe.restaurant.rrhh.validation;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.constants.TipoSuspensionLaboralConstants;
import pe.restaurant.rrhh.repository.TipoSuspensionLaboralRepository;

@Slf4j
@Component
@RequiredArgsConstructor
public class TipoSuspensionLaboralValidator {

    private final TipoSuspensionLaboralRepository repository;

    public void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException(TipoSuspensionLaboralConstants.MSG_CODIGO_DUPLICADO,
                    HttpStatus.CONFLICT, TipoSuspensionLaboralConstants.ERROR_CODIGO_DUPLICADO);
        }
    }

    public void validarCodigoUnicoParaActualizacion(String codigo, Long id) {
        if (repository.existsByCodigoAndIdNot(codigo, id)) {
            log.warn("Código duplicado en actualización: {} (excluye id={})", codigo, id);
            throw new BusinessException(TipoSuspensionLaboralConstants.MSG_CODIGO_DUPLICADO,
                    HttpStatus.CONFLICT, TipoSuspensionLaboralConstants.ERROR_CODIGO_DUPLICADO);
        }
    }

    public void validarNoEnUsoEnPermisos(Long id) {
        if (repository.existsPermisosActivosByTipoSuspensionId(id)) {
            log.warn("Tipo suspensión {} en uso en permisos activos", id);
            throw new BusinessException(TipoSuspensionLaboralConstants.MSG_ELIMINACION_CON_PERMISOS,
                    HttpStatus.BAD_REQUEST, TipoSuspensionLaboralConstants.ERROR_ELIMINACION_CON_PERMISOS);
        }
    }
}
