package com.sigre.contabilidad.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.contabilidad.dto.request.UitRequest;
import com.sigre.contabilidad.entity.Uit;

import java.time.LocalDate;

public interface UitService {

    Page<Uit> findAll(Integer ano, String flagEstado, Pageable pageable);

    Uit findById(Long id);

    Uit findUltimaVigente(LocalDate fecha);

    Uit create(UitRequest request);

    Uit update(Long id, UitRequest request);

    void delete(Long id);
}
