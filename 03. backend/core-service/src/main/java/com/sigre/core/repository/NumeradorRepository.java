package com.sigre.core.repository;

import jakarta.persistence.LockModeType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Lock;
import org.springframework.data.jpa.repository.Query;
import com.sigre.core.entity.Numerador;

import java.util.Optional;

public interface NumeradorRepository extends JpaRepository<Numerador, Long> {
    Optional<Numerador> findByCodigo(String codigo);

    @Lock(LockModeType.PESSIMISTIC_WRITE)
    @Query("SELECT n FROM Numerador n WHERE n.codigo = :codigo")
    Optional<Numerador> findByCodigoForUpdate(String codigo);
}
