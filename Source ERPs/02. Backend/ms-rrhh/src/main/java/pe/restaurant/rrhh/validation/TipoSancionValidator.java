package pe.restaurant.rrhh.validation;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.constants.TipoSancionConstants;
import pe.restaurant.rrhh.repository.TipoSancionRepository;

@Slf4j
@Component
@RequiredArgsConstructor
public class TipoSancionValidator {

    private final TipoSancionRepository repository;

    public void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Código duplicado: {}", codigo);
            throw new BusinessException(TipoSancionConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, TipoSancionConstants.ERROR_CODIGO_DUPLICADO);
        }
    }

    public void validarCodigoUnicoParaActualizacion(String codigo, Long id) {
        if (repository.existsByCodigoAndIdNot(codigo, id)) {
            log.warn("Código duplicado en actualización: {}", codigo);
            throw new BusinessException(TipoSancionConstants.MSG_CODIGO_DUPLICADO, HttpStatus.CONFLICT, TipoSancionConstants.ERROR_CODIGO_DUPLICADO);
        }
    }

    public void validarNoEnUsoEnSanciones(Long id) {
        if (repository.existsSancionesActivasByTipoSancionId(id)) {
            log.warn("Tipo sanción {} en uso en sanciones activas", id);
            throw new BusinessException(TipoSancionConstants.MSG_ELIMINACION_CON_SANCIONES, HttpStatus.BAD_REQUEST, TipoSancionConstants.ERROR_ELIMINACION_CON_SANCIONES);
        }
    }
}
