package pe.restaurant.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import pe.restaurant.rrhh.entity.ConceptoPlanilla;

import java.util.List;
import java.util.Optional;

/**
 * Repositorio para la entidad ConceptoPlanilla.
 * Proporciona operaciones CRUD y consultas personalizadas para conceptos de planilla.
 * 
 * @author Equipo de Desarrollo RRHH
 */
@Repository
public interface ConceptoPlanillaRepository extends JpaRepository<ConceptoPlanilla, Long>,
                                                     JpaSpecificationExecutor<ConceptoPlanilla> {

    /**
     * Verifica si existe un concepto con el código especificado.
     * 
     * @param codigo Código del concepto a verificar
     * @return true si existe un concepto con ese código, false en caso contrario
     */
    boolean existsByCodigo(String codigo);

    /**
     * Verifica si existe un concepto con el código especificado, excluyendo el registro con el ID dado.
     * Útil para validar duplicados en actualizaciones.
     * 
     * @param codigo Código del concepto a verificar
     * @param id ID del registro a excluir de la búsqueda
     * @return true si existe otro concepto con ese código, false en caso contrario
     */
    boolean existsByCodigoAndIdNot(String codigo, Long id);

    /**
     * Busca un concepto por su código.
     * 
     * @param codigo Código del concepto a buscar
     * @return Optional con el concepto si existe, Optional.empty() en caso contrario
     */
    Optional<ConceptoPlanilla> findByCodigo(String codigo);

    List<ConceptoPlanilla> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
