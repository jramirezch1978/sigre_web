package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.Sucursal;

public interface SucursalRepository extends JpaRepository<Sucursal, Long> {
}
