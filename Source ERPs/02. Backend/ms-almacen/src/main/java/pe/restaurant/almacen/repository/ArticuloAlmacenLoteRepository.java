package pe.restaurant.almacen.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import pe.restaurant.almacen.entity.ArticuloAlmacenLote;

import java.util.Optional;

public interface ArticuloAlmacenLoteRepository extends JpaRepository<ArticuloAlmacenLote, Long> {

    Optional<ArticuloAlmacenLote> findByAlmacenIdAndArticuloIdAndLotePalletId(
            Long almacenId, Long articuloId, Long lotePalletId);

    @Query("""
            SELECT l FROM ArticuloAlmacenLote l
            WHERE (:almacenId IS NULL OR l.almacenId = :almacenId)
              AND (:articuloId IS NULL OR l.articuloId = :articuloId)
              AND (:lotePalletId IS NULL OR l.lotePalletId = :lotePalletId)
            """)
    Page<ArticuloAlmacenLote> buscarStockLote(@Param("almacenId") Long almacenId,
                                              @Param("articuloId") Long articuloId,
                                              @Param("lotePalletId") Long lotePalletId,
                                              Pageable pageable);
}
