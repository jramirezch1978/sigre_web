package com.sigre.rrhh.specification;

import org.springframework.data.jpa.domain.Specification;
import com.sigre.rrhh.entity.ConceptoPlanilla;

/**
 * Especificaciones JPA para filtrar conceptos de planilla.
 * Proporciona criterios de búsqueda dinámicos para consultas.
 * 
 * @author Equipo de Desarrollo RRHH
 */
public class ConceptoPlanillaSpecification {

    private ConceptoPlanillaSpecification() {
        // Constructor privado para clase utilitaria
    }

    /**
     * Filtra conceptos por código usando LIKE (case insensitive).
     * 
     * @param codigo Código a buscar (puede ser parcial)
     * @return Specification para filtrar por código
     */
    public static Specification<ConceptoPlanilla> conCodigo(String codigo) {
        return (root, query, criteriaBuilder) ->
            codigo != null && !codigo.isEmpty()
                ? criteriaBuilder.like(
                    criteriaBuilder.lower(root.get("codigo")),
                    "%" + codigo.toLowerCase() + "%"
                )
                : null;
    }

    /**
     * Filtra conceptos por nombre usando LIKE (case insensitive).
     * 
     * @param nombre Nombre a buscar (puede ser parcial)
     * @return Specification para filtrar por nombre
     */
    public static Specification<ConceptoPlanilla> conNombre(String nombre) {
        return (root, query, criteriaBuilder) ->
            nombre != null && !nombre.isEmpty()
                ? criteriaBuilder.like(
                    criteriaBuilder.lower(root.get("nombre")),
                    "%" + nombre.toLowerCase() + "%"
                )
                : null;
    }

    /**
     * Filtra conceptos por grupo de cálculo exacto (SIGRE GRUPO_CALC).
     */
    public static Specification<ConceptoPlanilla> conGrupoCalculo(String grupoCalculo) {
        return (root, query, criteriaBuilder) ->
            grupoCalculo != null && !grupoCalculo.isEmpty()
                ? criteriaBuilder.equal(root.join("grupoConceptosPlanilla").get("codigo"), grupoCalculo)
                : null;
    }
}
