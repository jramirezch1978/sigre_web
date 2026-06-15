package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.TipoContrato;

@Repository
public interface TipoContratoRepository extends JpaRepository<TipoContrato, Long>, JpaSpecificationExecutor<TipoContrato> {
    boolean existsByCodigo(String codigo);
    java.util.List<TipoContrato> findByFlagEstadoOrderByNombreAsc(String flagEstado);
}
