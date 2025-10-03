package com.sigre.asistencia.repository;

import com.sigre.asistencia.entity.TipoTrabajador;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TipoTrabajadorRepository extends JpaRepository<TipoTrabajador, String> {
}
