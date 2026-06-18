package pe.restaurant.ventas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.FacturaSimplificadaDet;

import java.util.List;

@Repository
public interface FacturaSimplificadaDetRepository extends JpaRepository<FacturaSimplificadaDet, Long> {

    // Buscar items de una factura simplificada
    @Query("SELECT fsd FROM FacturaSimplificadaDet fsd WHERE fsd.facturaSimplificada.id = :facturaSimplificadaId AND fsd.flagEstado = '1' ORDER BY fsd.id")
    List<FacturaSimplificadaDet> findByFacturaSimplificadaId(@Param("facturaSimplificadaId") Long facturaSimplificadaId);

    // Validación de FK: articulo debe existir y estar activo
    @Query(value = "SELECT EXISTS(SELECT 1 FROM core.articulo WHERE id = :articuloId AND flag_estado = '1')", nativeQuery = true)
    boolean existsArticuloActivo(@Param("articuloId") Long articuloId);

    // Validación de FK: unidad_medida debe existir y estar activa
    @Query(value = "SELECT EXISTS(SELECT 1 FROM core.unidad_medida WHERE id = :unidadMedidaId AND flag_estado = '1')", nativeQuery = true)
    boolean existsUnidadMedidaActiva(@Param("unidadMedidaId") Long unidadMedidaId);
}
