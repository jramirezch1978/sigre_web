package com.sigre.rrhh.validation;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.common.exception.BusinessException;
import com.sigre.rrhh.repository.ConceptoPlanillaRepository;
import com.sigre.rrhh.repository.GrupoConceptosPlanillaRepository;

import static com.sigre.rrhh.constants.ConceptoPlanillaConstants.*;

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
    private final GrupoConceptosPlanillaRepository grupoConceptosPlanillaRepository;

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
     * Valida que el grupo de cálculo esté informado.
     *
     * @param grupoCalculo Grupo SIGRE (GRUPO_CALC)
     * @throws BusinessException si el grupo es nulo o vacío (RH-CP-003)
     */
    public void validarGrupoCalculo(String grupoCalculo) {
        if (grupoCalculo == null || grupoCalculo.isBlank()) {
            throw new BusinessException(MSG_GRUPO_CALCULO_INVALIDO, ERROR_GRUPO_CALCULO_INVALIDO);
        }
        if (grupoConceptosPlanillaRepository.findByCodigo(grupoCalculo).isEmpty()) {
            throw new BusinessException(MSG_GRUPO_CALCULO_INVALIDO, ERROR_GRUPO_CALCULO_INVALIDO);
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
