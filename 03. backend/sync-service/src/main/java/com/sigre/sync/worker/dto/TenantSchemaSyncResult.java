package com.sigre.sync.worker.dto;

import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
@Builder
public class TenantSchemaSyncResult {

    private String tenantDbName;
    private String nombreEmpresa;
    private boolean success;
    private boolean changed;
    private boolean dryRun;
    private long durationMs;
    private int plannedStatements;
    private int appliedStatements;
    private List<String> statements;
    private List<String> warnings;
    private String error;
}
