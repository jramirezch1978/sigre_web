package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.dto.DetraccionRequest;
import com.sigre.core.dto.DetraccionResponse;
import com.sigre.core.entity.Detraccion;

public interface DetraccionService {
    Page<Detraccion> list(Pageable pageable);
    DetraccionResponse getById(String bienServ);
    DetraccionResponse create(DetraccionRequest request);
    DetraccionResponse update(String bienServ, DetraccionRequest request);
    void delete(String bienServ);
    Detraccion activate(String bienServ);
    Detraccion deactivate(String bienServ);
}
