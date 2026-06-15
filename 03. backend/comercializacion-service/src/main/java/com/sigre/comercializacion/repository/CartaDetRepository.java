package com.sigre.comercializacion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.CartaDet;

import java.util.List;
import java.util.Optional;

@Repository
public interface CartaDetRepository extends JpaRepository<CartaDet, Long> {

    @Query("SELECT cd FROM CartaDet cd WHERE cd.carta.id = :cartaId AND cd.flagEstado = '1'")
    List<CartaDet> findByCartaIdAndActivo(@Param("cartaId") Long cartaId);

    @Query("SELECT cd FROM CartaDet cd WHERE cd.carta.id = :cartaId AND cd.articulo.id = :articuloId AND cd.flagEstado = '1'")
    Optional<CartaDet> findByCartaIdAndArticuloIdAndActivo(@Param("cartaId") Long cartaId,
                                                           @Param("articuloId") Long articuloId);

    @Query("SELECT COUNT(cd) > 0 FROM CartaDet cd WHERE cd.carta.id = :cartaId AND cd.articulo.id = :articuloId AND cd.flagEstado = '1'")
    boolean existsByCartaIdAndArticuloIdAndActivo(@Param("cartaId") Long cartaId,
                                                  @Param("articuloId") Long articuloId);
}
