package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.rrhh.entity.TipoVivienda;
import java.util.List;
import java.util.Optional;

public interface TipoViviendaRepository extends JpaRepository<TipoVivienda, Long>, JpaSpecificationExecutor<TipoVivienda> {
    Optional<TipoVivienda> findByCodigo(String codigo);
    boolean existsByCodigo(String codigo);
    List<TipoVivienda> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
