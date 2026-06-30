package com.sigre.almacen.repository;

import com.sigre.almacen.entity.CntblLibroRef;
import org.springframework.data.jpa.repository.JpaRepository;

/** Lectura de libros contables (contabilidad.cntbl_libro) desde almacen-service. */
public interface CntblLibroRefRepository extends JpaRepository<CntblLibroRef, Long> {
}
