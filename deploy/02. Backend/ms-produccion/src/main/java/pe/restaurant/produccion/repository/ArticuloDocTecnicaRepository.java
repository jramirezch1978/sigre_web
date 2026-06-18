package pe.restaurant.produccion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import pe.restaurant.produccion.entity.ArticuloDocTecnica;

public interface ArticuloDocTecnicaRepository extends JpaRepository<ArticuloDocTecnica, Long>,
        JpaSpecificationExecutor<ArticuloDocTecnica> {

    boolean existsByNombreDocumentoIgnoreCase(String nombreDocumento);

    boolean existsByNombreDocumentoIgnoreCaseAndIdNot(String nombreDocumento, Long id);
}
