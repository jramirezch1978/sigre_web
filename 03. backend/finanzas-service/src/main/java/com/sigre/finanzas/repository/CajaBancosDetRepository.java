package com.sigre.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sigre.finanzas.entity.CajaBancosDet;

import java.util.List;

@Repository
public interface CajaBancosDetRepository extends JpaRepository<CajaBancosDet, Long> {

    List<CajaBancosDet> findByCajaBancosIdAndFlagEstado(Long cajaBancosId, String flagEstado);
}
