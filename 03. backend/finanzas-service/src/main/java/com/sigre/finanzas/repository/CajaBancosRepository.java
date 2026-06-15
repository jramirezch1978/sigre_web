package com.sigre.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.stereotype.Repository;
import com.sigre.finanzas.entity.CajaBancos;

import java.util.Optional;

@Repository
public interface CajaBancosRepository extends JpaRepository<CajaBancos, Long>, JpaSpecificationExecutor<CajaBancos> {

    Optional<CajaBancos> findByNroRegistro(String nroRegistro);

    boolean existsByNroRegistro(String nroRegistro);
}
