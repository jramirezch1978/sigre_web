package pe.restaurant.worker.entity;

import jakarta.persistence.*;
import lombok.*;

import java.time.OffsetDateTime;

@Entity
@Table(name = "schema_sync_cron_log", schema = "auditoria")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SchemaSyncCronLog {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "execution_id", length = 36)
    private String executionId;

    @Column(name = "status", nullable = false, length = 20)
    private String status;

    @Column(name = "fase", length = 20)
    private String fase;

    @Column(name = "dry_run", nullable = false)
    private boolean dryRun;

    @Column(name = "tenant_db_name", length = 100)
    private String tenantDbName;

    @Column(name = "message_final", columnDefinition = "text")
    private String messageFinal;

    @Column(name = "is_failed", nullable = false)
    private boolean isFailed;

    @Column(name = "is_changed", nullable = false)
    private boolean isChanged;

    @Column(name = "nombre_empresa", length = 100)
    private String nombreEmpresa;

    @Column(name = "statements_execute", columnDefinition = "text")
    private String statementsExecute;

    @Column(name = "schema_object", length = 100)
    private String schemaObject;

    @Column(name = "objects_summary", columnDefinition = "text")
    private String objectsSummary;

    @Column(name = "object_type", length = 20)
    private String objectType;

    @Column(name = "duration_ms", nullable = false)
    private long durationMs;

    @Column(name = "error_detail", columnDefinition = "text")
    private String errorDetail;

    @Column(name = "created_at", nullable = false, updatable = false)
    private OffsetDateTime createdAt;

    @PrePersist
    void prePersist() {
        if (createdAt == null) {
            createdAt = OffsetDateTime.now();
        }
    }
}
