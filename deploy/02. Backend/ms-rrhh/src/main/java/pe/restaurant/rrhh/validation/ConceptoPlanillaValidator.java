package pe.restaurant.rrhh.validation;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.rrhh.repository.ConceptoPlanillaRepository;

import static pe.restaurant.rrhh.constants.ConceptoPlanillaConstants.*;

/**
 * Validador de reglas de negocio para Conceptos de Planilla.
 * Centraliza las validaciones complejas que no pueden ser manejadas por anotaciones.
 * 
 * @author Equipo de Desarrollo RRHH
 */
@Component
@RequiredArgsConstructor
public class ConceptoPlanillaValidator {

    private final ConceptoPlanillaRepository repository;

    /**
     * Valida que el código no exista en la base de datos.
     * Se utiliza en la creación de nuevos conceptos.
     * 
     * @param codigo Código a validar
     * @throws BusinessException si el código ya existe (RH-CP-002)
     */
    public void validarCodigoUnico(String codigo) {
        if (repository.existsByCodigo(codigo)) {
            throw new BusinessException(MSG_CODIGO_DUPLICADO, ERROR_CODIGO_DUPLICADO);
        }
    }

    /**
     * Valida que el código no exista en otro registro.
     * Se utiliza en la actualización para permitir que el registro mantenga su propio código.
     * 
     * @param codigo Código a validar
     * @param id ID del registro actual (se excluye de la validación)
     * @throws BusinessException si el código existe en otro registro (RH-CP-002)
     */
    public void validarCodigoUnicoParaActualizacion(String codigo, Long id) {
        if (repository.existsByCodigoAndIdNot(codigo, id)) {
            throw new BusinessException(MSG_CODIGO_DUPLICADO, ERROR_CODIGO_DUPLICADO);
        }
    }

    /**
     * Valida que el tipo sea uno de los valores permitidos: INGRESO, DESCUENTO o APORTE.
     * 
     * @param tipo Tipo a validar
     * @throws BusinessException si el tipo no es válido (RH-CP-003)
     */
    public void validarTipo(String tipo) {
        if (!TIPO_INGRESO.equals(tipo) && !TIPO_DESCUENTO.equals(tipo) && !TIPO_APORTE.equals(tipo)) {
            throw new BusinessException(MSG_TIPO_INVALIDO, ERROR_TIPO_INVALIDO);
        }
    }

    /**
     * Valida que el concepto no esté en uso en planillas procesadas.
     * Se utiliza antes de eliminar un concepto.
     * 
     * @param id ID del concepto a validar
     * @throws BusinessException si el concepto está en uso (RH-CP-004)
     */
    public void validarNoEnUso(Long id) {
        // TODO: Implementar cuando exista la tabla calculo_det
        // Por ahora, la validación está deshabilitada ya que la tabla no existe
        // boolean enUso = calculoDetRepository.existsByConceptoId(id);
        // if (enUso) {
        //     throw new BusinessException(MSG_EN_USO, ERROR_EN_USO);
        // }
    }
}
