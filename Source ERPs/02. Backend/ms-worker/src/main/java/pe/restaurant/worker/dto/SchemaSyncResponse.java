package pe.restaurant.worker.dto;

import lombok.Builder;
import lombok.Data;

import java.time.OffsetDateTime;
import java.util.List;

@Data
@Builder
public class SchemaSyncResponse {

    private String executionId;
    private String templateDatabase;
    private boolean dryRun;
    private boolean allowDestructive;
    private boolean failFast;
    private String requestedBy;
    private OffsetDateTime startedAt;
    private OffsetDateTime finishedAt;
    private Summary summary;
    private List<TenantSchemaSyncResult> tenants;

    @Data
    @Builder
    public static class Summary {
        private int totalTenants;
        private int okTenants;
        private int failedTenants;
        private int noChangeTenants;
        private int changedTenants;
        private int appliedStatements;
        private int plannedStatements;
    }
}
