package com.sigre.core.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.core.entity.FormaPago;

public interface FormaPagoService {
    Page<FormaPago> findAll(Pageable pageable);
    FormaPago findById(Long id);
    FormaPago create(FormaPago entity);
    FormaPago update(Long id, FormaPago entity);
    void delete(Long id);
    FormaPago activate(Long id);
    FormaPago deactivate(Long id);
}
