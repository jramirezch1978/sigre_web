package com.sigre.seguridad.repository;

import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import com.sigre.seguridad.entity.master.EmpresaMaster;

import java.util.Optional;

public interface EmpresaMasterRepository extends JpaRepository<EmpresaMaster, Long> {

    boolean existsByCodigo(String codigo);

    boolean existsByRuc(String ruc);

    boolean existsByDbName(String dbName);

    Optional<EmpresaMaster> findByCodigo(String codigo);

    Optional<EmpresaMaster> findByRuc(String ruc);

    Optional<EmpresaMaster> findByDbName(String dbName);

    @Query("""
            SELECT e
            FROM EmpresaMaster e
            WHERE (:codigo IS NULL OR e.codigo = :codigo)
              AND (:ruc IS NULL OR e.ruc = :ruc)
              AND (:dbName IS NULL OR e.dbName = :dbName)
            """)
    Optional<EmpresaMaster> findByLookupParams(
            @Param("codigo") String codigo,
            @Param("ruc") String ruc,
            @Param("dbName") String dbName);

    @Query(value = "SELECT nextval('master.seq_empresa_codigo')", nativeQuery = true)
    Long nextEmpresaCodigo();

}
