package com.sigre.almacen.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.almacen.entity.AlmacenTipo;

public interface AlmacenTipoRepository extends JpaRepository<AlmacenTipo, Long> {

    boolean existsByCodigoIgnoreCase(String codigo);

    boolean existsByCodigoIgnoreCaseAndIdNot(String codigo, Long id);
}
