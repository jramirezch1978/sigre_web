package com.sigre.almacen.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.almacen.entity.Guia;

import java.util.Optional;

public interface GuiaRepository extends JpaRepository<Guia, Long>, JpaSpecificationExecutor<Guia> {
    Page<Guia> findBySucursalId(Long sucursalId, Pageable pageable);

    boolean existsBySucursalIdAndSerieAndNumero(Long sucursalId, String serie, String numero);

    boolean existsBySucursalIdAndSerieIgnoreCaseAndNumeroIgnoreCaseAndIdNot(
            Long sucursalId, String serie, String numero, Long id);

    Optional<Guia> findByIdAndSucursalIdAndFlagEstado(Long id, Long sucursalId, String flagEstado);

    Optional<Guia> findBySucursalIdAndSerieIgnoreCaseAndNumeroIgnoreCaseAndFlagEstado(
            Long sucursalId, String serie, String numero, String flagEstado);
}
