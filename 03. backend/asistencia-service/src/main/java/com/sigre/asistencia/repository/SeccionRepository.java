package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.Seccion;
import com.sigre.asistencia.entity.SeccionId;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SeccionRepository extends JpaRepository<Seccion, SeccionId> {
}
