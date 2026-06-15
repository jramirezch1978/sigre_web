package com.sigre.almacen.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import com.sigre.almacen.entity.AlmacenTipoMov;

import java.util.Optional;

public interface AlmacenTipoMovRepository extends JpaRepository<AlmacenTipoMov, Long>,
        JpaSpecificationExecutor<AlmacenTipoMov> {

    boolean existsByAlmacenIdAndArticuloMovTipoIdAndFlagEstado(Long almacenId,
                                                            Long articuloMovTipoId,
                                                            String flagEstado);

    Page<AlmacenTipoMov> findByAlmacenId(Long almacenId, Pageable pageable);

    Optional<AlmacenTipoMov> findByAlmacenIdAndArticuloMovTipoId(Long almacenId, Long articuloMovTipoId);
}
