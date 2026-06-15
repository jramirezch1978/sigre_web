package com.sigre.rrhh.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sigre.rrhh.entity.ControlSubsidio;

@Repository
public interface ControlSubsidioRepository extends JpaRepository<ControlSubsidio, Long> {
}
