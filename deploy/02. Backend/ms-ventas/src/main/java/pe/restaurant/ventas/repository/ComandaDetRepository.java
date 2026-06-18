package pe.restaurant.ventas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import pe.restaurant.ventas.entity.ComandaDet;

import java.util.List;

@Repository
public interface ComandaDetRepository extends JpaRepository<ComandaDet, Long> {

    // Buscar items de una comanda
    @Query("SELECT cd FROM ComandaDet cd WHERE cd.comanda.id = :comandaId AND cd.flagEstado = '1' ORDER BY cd.id")
    List<ComandaDet> findByComandaId(@Param("comandaId") Long comandaId);

    // Validación de FK: articulo debe existir y estar activo
    @Query(value = "SELECT EXISTS(SELECT 1 FROM core.articulo WHERE id = :articuloId AND flag_estado = '1')", nativeQuery = true)
    boolean existsArticuloActivo(@Param("articuloId") Long articuloId);
}
