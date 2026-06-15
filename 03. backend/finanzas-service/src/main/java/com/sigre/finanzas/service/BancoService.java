package com.sigre.finanzas.service;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import com.sigre.finanzas.entity.Banco;

public interface BancoService {
    
    Page<Banco> findAll(Pageable pageable);
    
    Banco findById(Long id);
    
    Banco create(Banco entity);
    
    Banco update(Long id, Banco entity);
    
    void delete(Long id);
    
    Banco activate(Long id);
    
    Banco deactivate(Long id);
}
