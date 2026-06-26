package pe.restaurant.activos.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.activos.entity.AfDocumento;

import java.util.List;

public interface AfDocumentoRepository extends JpaRepository<AfDocumento, Long> {

    List<AfDocumento> findByAfMaestroIdOrderByFechaCargaDesc(Long afMaestroId);

    Page<AfDocumento> findByTipoDocumento(String tipoDocumento, Pageable pageable);

    List<AfDocumento> findByUsuarioCargaId(Long usuarioCargaId);

    @Query("SELECT d FROM AfDocumento d WHERE d.afMaestroId = :afMaestroId AND d.tipoDocumento = :tipoDocumento")
    List<AfDocumento> findByActivoAndTipo(@Param("afMaestroId") Long afMaestroId, @Param("tipoDocumento") String tipoDocumento);

    @Query("SELECT d FROM AfDocumento d WHERE d.extension = :extension")
    List<AfDocumento> findByExtension(@Param("extension") String extension);

    boolean existsByRutaArchivo(String rutaArchivo);
}
