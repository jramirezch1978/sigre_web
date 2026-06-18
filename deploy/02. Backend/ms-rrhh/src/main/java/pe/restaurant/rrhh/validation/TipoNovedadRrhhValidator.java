package pe.restaurant.rrhh.validation;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.repository.TipoNovedadRrhhRepository;

import static pe.restaurant.rrhh.constants.TipoNovedadRrhhConstants.*;

@Slf4j
@Component
@RequiredArgsConstructor
public class TipoNovedadRrhhValidator {

    private final TipoNovedadRrhhRepository repository;

    public void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            log.warn("Intento de duplicar c\u00f3digo de tipo de novedad: {}", codigo);
            throw new BusinessException(MSG_CODIGO_DUPLICADO, ERROR_CODIGO_DUPLICADO);
        }
    }

    public void validarCodigoUnicoParaActualizacion(String codigo, Long id) {
        if (repository.existsByCodigoAndIdNot(codigo, id)) {
            log.warn("Intento de duplicar c\u00f3digo de tipo de novedad en actualizaci\u00f3n: {}", codigo);
            throw new BusinessException(MSG_CODIGO_DUPLICADO, ERROR_CODIGO_DUPLICADO);
        }
    }

    public void validarNoEnUsoEnNovedadesActivas(Long id) {
        if (repository.existsNovedadesActivasByTipoNovedadId(id)) {
            log.warn("Intento de desactivar tipo de novedad en uso: {}", id);
            throw new BusinessException(MSG_DESACTIVACION_EN_USO, ERROR_DESACTIVACION_EN_USO);
        }
    }
}
