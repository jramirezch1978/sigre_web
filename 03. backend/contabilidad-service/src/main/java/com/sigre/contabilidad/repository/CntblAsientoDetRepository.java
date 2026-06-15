package com.sigre.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sigre.contabilidad.entity.CntblAsientoDet;

import java.util.List;

@Repository
public interface CntblAsientoDetRepository extends JpaRepository<CntblAsientoDet, Long> {
    
    List<CntblAsientoDet> findByCntblAsientoIdOrderById(Long cntblAsientoId);
    
    void deleteByCntblAsientoId(Long cntblAsientoId);
}
