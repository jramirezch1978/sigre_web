package com.sigre.rrhh.repository;

import com.sigre.rrhh.entity.AdelantoQuincena;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AdelantoQuincenaRepository extends JpaRepository<AdelantoQuincena, Long> {
}
