package com.sigre.rrhh.repository;

import com.sigre.rrhh.entity.GrupoConceptosSeccion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface GrupoConceptosSeccionRepository extends JpaRepository<GrupoConceptosSeccion, Long> {
}
