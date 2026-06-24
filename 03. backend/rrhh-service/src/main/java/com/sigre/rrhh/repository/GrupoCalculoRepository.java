package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.GrupoCalculo;

import java.util.List;
import java.util.Optional;

@Repository
public interface GrupoCalculoRepository extends JpaRepository<GrupoCalculo, Long> {

    Optional<GrupoCalculo> findByCodigo(String codigo);

    List<GrupoCalculo> findByFlagEstadoOrderByCodigoAsc(String flagEstado);

    @Query("SELECT gc.id FROM GrupoCalculo gc WHERE gc.codigo = :codigo")
    Optional<Long> findIdByCodigo(@Param("codigo") String codigo);
}
