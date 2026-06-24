package com.sigre.rrhh.repository;

import com.sigre.rrhh.entity.CalculoJudicial;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CalculoJudicialRepository extends JpaRepository<CalculoJudicial, Long> {
}
