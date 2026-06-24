package com.sigre.rrhh.repository;

import com.sigre.rrhh.entity.RetencionJudicial;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RetencionJudicialRepository extends JpaRepository<RetencionJudicial, Long> {
}
