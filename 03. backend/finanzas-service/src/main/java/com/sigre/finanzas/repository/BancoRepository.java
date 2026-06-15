package com.sigre.finanzas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sigre.finanzas.entity.Banco;

@Repository
public interface BancoRepository extends JpaRepository<Banco, Long> {
    
    boolean existsByCodBancoIgnoreCase(String codBanco);
    
    boolean existsByCodBancoIgnoreCaseAndIdNot(String codBanco, Long id);
}
