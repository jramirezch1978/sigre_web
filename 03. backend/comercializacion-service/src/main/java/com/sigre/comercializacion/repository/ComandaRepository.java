package com.sigre.comercializacion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.Comanda;

import java.util.Optional;

@Repository
public interface ComandaRepository extends JpaRepository<Comanda, Long>, JpaSpecificationExecutor<Comanda> {

    @Query("SELECT DISTINCT c FROM Comanda c LEFT JOIN FETCH c.detalles WHERE c.id = :id")
    Optional<Comanda> findByIdWithDetalles(@Param("id") Long id);
}
