package com.sigre.rrhh.specification;

import org.springframework.data.jpa.domain.Specification;
import com.sigre.rrhh.entity.Area;

/**
 * Especificaciones JPA para filtrado dinámico de áreas.
 * Utiliza Criteria API para construir consultas dinámicas.
 */
public class AreaSpecification {
    
    private AreaSpecification() {
        throw new UnsupportedOperationException("Clase de especificaciones — no instanciable");
    }
    
    /**
     * Especificación para filtrar por nombre (búsqueda parcial case-insensitive).
     * 
     * @param nombre Texto a buscar en el nombre del área
     * @return Especificación para el filtro
     */
    public static Specification<Area> nombreContains(String nombre) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.like(
                criteriaBuilder.lower(root.get("nombre")), 
                "%" + nombre.toLowerCase() + "%"
            );
    }
    
    /**
     * Especificación para filtrar por área padre.
     * 
     * @param padreId ID del área padre
     * @return Especificación para el filtro
     */
    public static Specification<Area> padreIdEquals(Long padreId) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.equal(root.get("padreId"), padreId);
    }
}
