package com.sigre.compras.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.compras.entity.AlmacenTacitoRef;

import java.util.Optional;

public interface AlmacenTacitoRefRepository extends JpaRepository<AlmacenTacitoRef, Long> {
    Optional<AlmacenTacitoRef> findFirstByCodClaseAndSucursalId(String codClase, Long sucursalId);
}
