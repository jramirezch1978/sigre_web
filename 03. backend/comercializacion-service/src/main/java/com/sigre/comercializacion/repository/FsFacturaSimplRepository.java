package com.sigre.comercializacion.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import com.sigre.comercializacion.entity.FsFacturaSimpl;

@Repository
public interface FsFacturaSimplRepository extends JpaRepository<FsFacturaSimpl, Long>, JpaSpecificationExecutor<FsFacturaSimpl> {

    @Query("SELECT CASE WHEN COUNT(f) > 0 THEN true ELSE false END FROM FsFacturaSimpl f WHERE f.id = :id AND f.flagEstado <> '0'")
    boolean existsByIdAndNotAnulada(@Param("id") Long id);
}
