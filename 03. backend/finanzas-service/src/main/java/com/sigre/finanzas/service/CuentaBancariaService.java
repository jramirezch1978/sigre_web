package com.sigre.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.entity.BancoCnta;

import java.math.BigDecimal;

public interface CuentaBancariaService {

    Page<BancoCnta> findAll(Pageable pageable);

    BancoCnta findById(Long id);

    BigDecimal getSaldoActual(Long id);

    BancoCnta create(BancoCnta entity);

    BancoCnta update(Long id, BancoCnta entity);

    BancoCnta activate(Long id);

    BancoCnta deactivate(Long id);

    void delete(Long id);
}
