package com.sigre.contabilidad.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sigre.contabilidad.entity.CntblPreasientoDet;

@Repository
public interface CntblPreasientoDetRepository extends JpaRepository<CntblPreasientoDet, Long> {
}
