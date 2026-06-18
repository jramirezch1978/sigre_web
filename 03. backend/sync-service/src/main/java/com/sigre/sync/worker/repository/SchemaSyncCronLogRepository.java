package com.sigre.sync.worker.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.sigre.sync.worker.entity.SchemaSyncCronLog;

import java.util.List;

public interface SchemaSyncCronLogRepository extends JpaRepository<SchemaSyncCronLog, Long> {

    List<SchemaSyncCronLog> findByExecutionId(String executionId);

    List<SchemaSyncCronLog> findByExecutionIdOrderByIdAsc(String executionId);
}
