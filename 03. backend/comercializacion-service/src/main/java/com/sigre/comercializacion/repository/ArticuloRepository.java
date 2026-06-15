package com.sigre.comercializacion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.CartaDet;

import java.util.Optional;

@Repository
public interface ArticuloRepository extends JpaRepository<CartaDet.Articulo, Long> {
    
    @Query(value = "SELECT a FROM core.articulo a WHERE a.id = :id AND a.flag_estado = '1'", nativeQuery = true)
    Optional<CartaDet.Articulo> findByIdAndActivo(@Param("id") Long id);
    
    @Query(value = "SELECT CASE WHEN COUNT(a) > 0 THEN true ELSE false END FROM core.articulo a WHERE a.id = :id AND a.flag_estado = :flagEstado", nativeQuery = true)
    boolean existsByIdAndFlagEstado(@Param("id") Long id, @Param("flagEstado") String flagEstado);
}
