package com.sigre.almacen.repository;

import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import com.sigre.almacen.entity.OrdenTraslado;

import java.util.Optional;

public interface OrdenTrasladoRepository extends JpaRepository<OrdenTraslado, Long>,
        JpaSpecificationExecutor<OrdenTraslado> {

    /**
     * Bloquea la cabecera para serializar ejecuciones concurrentes de traslado (salida + espejo)
     * y la lectura de líneas pendientes frente a otros hilos.
     */
    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT o FROM OrdenTraslado o WHERE o.id = :id")
    Optional<OrdenTraslado> findByIdForUpdate(@Param("id") Long id);
}
