package com.sigre.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.sigre.finanzas.entity.ActividadFlujoCaja;

@Repository
public interface ActividadFlujoCajaRepository extends JpaRepository<ActividadFlujoCaja, Long>, JpaSpecificationExecutor<ActividadFlujoCaja> {

    boolean existsByCodigo(String codigo);

    boolean existsByCodigoAndIdNot(String codigo, Long id);
}
