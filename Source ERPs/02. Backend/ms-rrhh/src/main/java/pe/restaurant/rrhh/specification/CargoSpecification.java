package pe.restaurant.rrhh.specification;

import org.springframework.data.jpa.domain.Specification;
import pe.restaurant.rrhh.entity.Cargo;

/**
 * Especificaciones JPA para filtrado dinámico de cargos.
 * Utiliza Criteria API para construir consultas dinámicas.
 */
public class CargoSpecification {
    
    private CargoSpecification() {
        throw new UnsupportedOperationException("Clase de especificaciones — no instanciable");
    }
    
    /**
     * Especificación para filtrar por nombre (búsqueda parcial case-insensitive).
     * 
     * @param nombre Texto a buscar en el nombre del cargo
     * @return Especificación para el filtro
     */
    public static Specification<Cargo> nombreContains(String nombre) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.like(
                criteriaBuilder.lower(root.get("nombre")), 
                "%" + nombre.toLowerCase() + "%"
            );
    }
    
    /**
     * Especificación para filtrar por nivel exacto.
     * 
     * @param nivel Nivel del cargo
     * @return Especificación para el filtro
     */
    public static Specification<Cargo> nivelEquals(String nivel) {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.equal(root.get("nivel"), nivel);
    }
}
