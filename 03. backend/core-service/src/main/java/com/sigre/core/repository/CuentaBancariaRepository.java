package com.sigre.core.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.core.entity.CuentaBancaria;

import java.util.List;

public interface CuentaBancariaRepository extends JpaRepository<CuentaBancaria, Long> {
    List<CuentaBancaria> findByRelacionComercialIdAndFlagEstado(Long relacionComercialId, String flagEstado);
}
