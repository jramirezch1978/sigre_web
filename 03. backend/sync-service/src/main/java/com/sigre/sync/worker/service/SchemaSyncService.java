package com.sigre.sync.worker.service;

import com.zaxxer.hikari.HikariDataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import com.sigre.common.schema.PgSchemaMetadataReader;
import com.sigre.common.schema.SchemaModels.DdlStatement;
import com.sigre.common.schema.SchemaModels.SchemaSnapshot;
import com.sigre.common.schema.SchemaModels.SchemaSyncPlan;
import com.sigre.sync.worker.config.DataSyncProperties;
import com.sigre.sync.worker.config.DynamicTenantDataSourceManager;
import com.sigre.sync.worker.dto.SchemaSyncRequest;
import com.sigre.sync.worker.dto.SchemaSyncResponse;
import com.sigre.sync.worker.dto.TenantSchemaSyncResult;
import com.sigre.sync.worker.entity.SchemaSyncCronLog;
import com.sigre.sync.worker.repository.SchemaSyncCronLogRepository;
import com.sigre.sync.worker.schema.PgSchemaDiffEngine;
import com.sigre.sync.worker.schema.SchemaSyncModels.TenantConnectionInfo;

import java.util.Arrays;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

@Slf4j
@Service
public class SchemaSyncService {

    private static final String STATUS_INICIO = "INICIO";
    private static final String STATUS_PROCESANDO = "PROCESANDO";
    private static final String STATUS_TERMINADO = "TERMINADO";
    private static final String STATUS_FALLIDO = "FALLIDO";
    private static final String FASE_GENERAL = "GENERAL";
    private static final String FASE_1 = "FASE_1";
    private static final String FASE_2 = "FASE_2";
    private static final String FASE_3 = "FASE_3";
    private static final String FASE_4 = "FASE_4";
    private static final String FASE_5 = "FASE_5";

    private static final Set<String> PHASE_1_CATEGORIES = Set.of(
            "CREATE_SEQUENCE", "CREATE_TABLE",
            "NEW_TABLE_PK", "NEW_TABLE_UX", "NEW_TABLE_FK", "NEW_TABLE_IX",
            "FK_PREREQ_COLUMN");
    private static final Set<String> PHASE_3_CATEGORIES = Set.of(
            "ADD_COLUMN", "ALTER_COLUMN_TYPE", "ADD_COLUMN_FK", "CREATE_INDEX");
    private static final Set<String> PHASE_4_CATEGORIES = Set.of(
            "ADD_PRIMARY_KEY", "ADD_UNIQUE", "ADD_FOREIGN_KEY");
    private static final int MAX_SCHEMA_OBJECT_LENGTH = 100;
    private static final String SQLSTATE_MISSING_UNIQUE_FOR_FK = "42830";
    private static final Pattern FK_ORIGIN_PATTERN = Pattern.compile(
            "(?i)ALTER\\s+TABLE\\s+((?:\"[^\"]+\"|[a-zA-Z_][\\w$]*)(?:\\.(?:\"[^\"]+\"|[a-zA-Z_][\\w$]*))?).*?FOREIGN\\s+KEY\\s*\\(([^)]+)\\)");
    private static final Pattern FK_REFERENCE_PATTERN = Pattern.compile(
            "(?i)REFERENCES\\s+((?:\"[^\"]+\"|[a-zA-Z_][\\w$]*)(?:\\.(?:\"[^\"]+\"|[a-zA-Z_][\\w$]*))?)\\s*\\(([^)]+)\\)");
    private static final Pattern ZERO_ARG_FUNCTION_CALL_PATTERN = Pattern.compile(
            "(?i)([a-zA-Z_][\\w$]*)\\.([a-zA-Z_][\\w$]*)\\s*\\(\\s*\\)");
    private static final Pattern TABLE_TOKEN_PATTERN = Pattern.compile(
            "(?i)\\b(?:from|join|update|into|table)\\s+((?:\"[^\"]+\"|[a-zA-Z_][\\w$]*)(?:\\.(?:\"[^\"]+\"|[a-zA-Z_][\\w$]*))?)");
    private static final Pattern ERROR_RELATION_PATTERN = Pattern.compile("relation\\s+\"([^\"]+)\"", Pattern.CASE_INSENSITIVE);
    private static final Pattern ERROR_COLUMN_PATTERN = Pattern.compile("column\\s+\"([^\"]+)\"", Pattern.CASE_INSENSITIVE);
    private static final Set<String> ROUTINE_DEPENDENCY_SQLSTATES = Set.of("42703", "42P01", "42883", "42704");

    private record DdlBatchResult(
            List<DdlStatement> succeeded,
            List<FailedDdl> failed) {
        int executedCount() { return succeeded.size(); }
        int failedCount() { return failed.size(); }
    }

    private record FailedDdl(DdlStatement statement, String error) {}
    private record TableColumns(String schema, String table, List<String> columns) {}
    private record ReferenceTarget(String schema, String table, List<String> columns) {}
    private record RoutineDefinition(String schema, String name, String identityArgs, String ddl) {
        String signature() {
            return schema + "." + name + "(" + identityArgs + ")";
        }
    }
    private record RoutineSyncResult(int planned, int applied, int failed, Set<String> syncedSignatures) {
        static RoutineSyncResult empty() {
            return new RoutineSyncResult(0, 0, 0, Set.of());
        }
    }

    private final PgSchemaMetadataReader metadataReader;
    private final PgSchemaDiffEngine diffEngine;
    private final DynamicTenantDataSourceManager dataSourceManager;
    private final SchemaSyncCronLogRepository cronLogRepository;
    private final SchemaSyncEmailNotifier emailNotifier;
    private final DataSyncProperties dataSyncProperties;

    @Value("${app.schema-sync.admin-secret:dev-schema-sync}")
    private String adminSecret;

    public SchemaSyncService(PgSchemaMetadataReader metadataReader,
                             PgSchemaDiffEngine diffEngine,
                             DynamicTenantDataSourceManager dataSourceManager,
                             SchemaSyncCronLogRepository cronLogRepository,
                             SchemaSyncEmailNotifier emailNotifier,
                             DataSyncProperties dataSyncProperties) {
        this.metadataReader = metadataReader;
        this.diffEngine = diffEngine;
        this.dataSourceManager = dataSourceManager;
        this.cronLogRepository = cronLogRepository;
        this.emailNotifier = emailNotifier;
        this.dataSyncProperties = dataSyncProperties;
    }

    public boolean isAdminSecretValid(String candidate) {
        return candidate != null && !candidate.isBlank() && candidate.equals(adminSecret);
    }

    public boolean isDestructiveConfirmed(SchemaSyncRequest request) {
        if (!request.isAllowDestructive()) return true;
        return request.getDestructiveConfirmationToken() != null
                && request.getDestructiveConfirmationToken().equals(adminSecret);
    }

    public SchemaSyncResponse execute(SchemaSyncRequest request, String requestedBy) {
        OffsetDateTime startedAt = OffsetDateTime.now();
        String executionId = UUID.randomUUID().toString();
        long startMs = System.currentTimeMillis();

        if (request.isAllowDestructive() && !isDestructiveConfirmed(request)) {
            throw new IllegalArgumentException(
                    "allowDestructive=true requiere destructiveConfirmationToken valido");
        }

        // --- INICIO ---
        SchemaSyncCronLog headerLog = persistHeader(executionId, request.isDryRun(), STATUS_INICIO,
                "Sincronizacion iniciada por " + requestedBy);

        try {
            List<TenantConnectionInfo> allActive = dataSourceManager.loadActiveTenants();
            dataSourceManager.evictInactiveTenants(allActive);
            List<TenantConnectionInfo> tenants = filterTenants(allActive, request);

            log.info("[{}] Sync iniciada. dryRun={}, failFast={}, tenants={}",
                    executionId, request.isDryRun(), request.isFailFast(),
                    tenants.stream().map(TenantConnectionInfo::dbName).toList());

            // --- PROCESANDO ---
            updateHeaderStatus(headerLog, STATUS_PROCESANDO,
                    "Procesando " + tenants.size() + " tenants");

            HikariDataSource templateDs = dataSourceManager.getTemplateDataSource();
            JdbcTemplate templateJdbc = new JdbcTemplate(templateDs);

            long snapshotStart = System.nanoTime();
            SchemaSnapshot templateSnapshot = metadataReader.readSnapshot(
                    templateJdbc, dataSourceManager.getTemplateDatabaseName());
            log.info("[{}] Snapshot template leido en {}ms ({} tablas, {} secuencias)",
                    executionId, elapsedMs(snapshotStart),
                    templateSnapshot.tables().size(), templateSnapshot.sequences().size());
            Map<String, RoutineDefinition> templateRoutines = loadTemplateRoutines(templateJdbc);
            log.info("[{}] Snapshot template rutinas leido ({} funciones/procedimientos)",
                    executionId, templateRoutines.size());

            List<TenantSchemaSyncResult> tenantResults = processSequential(
                    executionId, tenants, templateSnapshot, templateRoutines, templateJdbc, request);

            OffsetDateTime finishedAt = OffsetDateTime.now();
            SchemaSyncResponse.Summary summary = buildSummary(tenantResults);
            long totalMs = System.currentTimeMillis() - startMs;

            log.info("[{}] Sync finalizada en {}ms. ok={}, failed={}, changed={}, "
                            + "stmts={}/{} applied, pools={}",
                    executionId, totalMs, summary.getOkTenants(), summary.getFailedTenants(),
                    summary.getChangedTenants(),
                    summary.getAppliedStatements(), summary.getPlannedStatements(),
                    dataSourceManager.getActiveTenantPoolCount());

            // --- TERMINADO o FALLIDO ---
            boolean hasFailed = summary.getFailedTenants() > 0;
            String finalStatus = hasFailed ? STATUS_FALLIDO : STATUS_TERMINADO;
            String finalMessage = buildFinalMessage(summary, totalMs, request.isDryRun());
            updateHeaderFinal(headerLog, finalStatus, finalMessage, totalMs, hasFailed,
                    summary.getChangedTenants() > 0);
            emailNotifier.notifyIfNeeded(executionId, summary, request.isDryRun());

            return SchemaSyncResponse.builder()
                    .executionId(executionId)
                    .templateDatabase(dataSourceManager.getTemplateDatabaseName())
                    .dryRun(request.isDryRun())
                    .allowDestructive(request.isAllowDestructive())
                    .failFast(request.isFailFast())
                    .requestedBy(requestedBy)
                    .startedAt(startedAt)
                    .finishedAt(finishedAt)
                    .summary(summary)
                    .tenants(tenantResults)
                    .build();

        } catch (Exception ex) {
            long totalMs = System.currentTimeMillis() - startMs;
            log.error("[{}] Sync FALLIDA en {}ms: {}", executionId, totalMs, rootMessage(ex), ex);
            updateHeaderFinal(headerLog, STATUS_FALLIDO,
                    "Error fatal: " + rootMessage(ex), totalMs, true, false);
            throw ex;
        }
    }

    // ---- Processing strategies ----

    private List<TenantSchemaSyncResult> processSequential(
            String executionId, List<TenantConnectionInfo> tenants,
            SchemaSnapshot templateSnapshot, Map<String, RoutineDefinition> templateRoutines,
            JdbcTemplate templateJdbc,
            SchemaSyncRequest request) {
        List<TenantSchemaSyncResult> results = new ArrayList<>();
        for (TenantConnectionInfo tenant : tenants) {
            TenantSchemaSyncResult result = processTenant(
                    executionId, tenant, templateSnapshot, templateRoutines, templateJdbc, request);
            results.add(result);
            if (request.isFailFast() && !result.isSuccess()) {
                log.warn("[{}] Fail-fast en tenant {}", executionId, tenant.dbName());
                break;
            }
        }
        return results;
    }

    // ---- Per-tenant logic with parallel phases ----

    private TenantSchemaSyncResult processTenant(
            String executionId, TenantConnectionInfo tenant,
            SchemaSnapshot templateSnapshot, Map<String, RoutineDefinition> templateRoutines,
            JdbcTemplate templateJdbc,
            SchemaSyncRequest request) {
        long started = System.nanoTime();
        String db = tenant.dbName();

        if (db == null || db.isBlank()
                || tenant.dbHost() == null || tenant.dbHost().isBlank()
                || tenant.dbUser() == null || tenant.dbUser().isBlank()) {
            long totalMs = elapsedMs(started);
            String msg = String.format("Tenant %s (empresa=%s) sin datos de conexion: db_host=%s, db_name=%s, db_user=%s",
                    tenant.codigo(), tenant.nombreEmpresa(),
                    tenant.dbHost(), db, tenant.dbUser());
            log.error("[{}] {}", executionId, msg);
            persistFailedTenantLog(executionId, request.isDryRun(), tenant, totalMs, msg);
            return TenantSchemaSyncResult.builder()
                    .tenantDbName(db != null ? db : "(sin db_name)")
                    .nombreEmpresa(tenant.nombreEmpresa())
                    .success(false).changed(false)
                    .dryRun(request.isDryRun())
                    .durationMs(totalMs)
                    .plannedStatements(0).appliedStatements(0)
                    .statements(List.of())
                    .warnings(List.of())
                    .error(msg)
                    .build();
        }

        try {
            HikariDataSource tenantDs = dataSourceManager.getTenantDataSource(tenant);
            JdbcTemplate tenantJdbc = new JdbcTemplate(tenantDs);
            long snapStart = System.nanoTime();
            SchemaSnapshot tenantSnapshot = metadataReader.readSnapshot(tenantJdbc, db);
            long snapMs = elapsedMs(snapStart);

            SchemaSyncPlan plan = diffEngine.calculatePlan(templateSnapshot, tenantSnapshot);

            List<String> sqlStatements = plan.statements().stream()
                    .map(DdlStatement::sql).toList();

            int appliedStatements = 0;
            int copiedRows = 0;
            int phase1Planned = 0;
            int phase2Planned = 0;
            int phase3Planned = 0;
            int phase4Planned = 0;
            long phase1Ms = 0;
            long phase2Ms = 0;
            long phase3Ms = 0;
            long phase4Ms = 0;
            long phase5Ms = 0;
            DdlBatchResult phase1Result = new DdlBatchResult(List.of(), List.of());
            DdlBatchResult phase3Result = new DdlBatchResult(List.of(), List.of());
            DdlBatchResult phase4Result = new DdlBatchResult(List.of(), List.of());
            RoutineSyncResult phase2Result = RoutineSyncResult.empty();

            List<DdlStatement> allSucceeded = new ArrayList<>();
            List<FailedDdl> allFailed = new ArrayList<>();
            List<DdlStatement> phase1 = new ArrayList<>();
            List<DdlStatement> phase3 = new ArrayList<>();
            List<DdlStatement> phase4 = new ArrayList<>();
            classifyStatements(plan.statements(), phase1, phase3, phase4);
            phase1Planned = phase1.size();
            phase3Planned = phase3.size();
            phase4Planned = phase4.size();

            Set<String> prePhase1FunctionSignatures = extractRequiredZeroArgFunctions(phase1, templateRoutines);
            int prePhase1FunctionCount = prePhase1FunctionSignatures.size();

            if (!request.isDryRun()) {
                try (HikariDataSource adminDs = dataSourceManager.createAdminPoolForTenant(tenant)) {
                    ensureSchemaPermissions(tenant, executionId, adminDs);

                    if (!prePhase1FunctionSignatures.isEmpty()) {
                        syncRoutinesToTenant(tenantDs, templateRoutines, prePhase1FunctionSignatures, executionId, db, "PRE-FASE_1");
                    }

                    long p1Start = System.nanoTime();
                    phase1Result = executeDdlBatch(tenantDs, phase1, executionId, db);
                    phase1Ms = elapsedMs(p1Start);
                    log.info("[{}] {} Fase 1: {}ms ({}/{} ok/fail)",
                            executionId, db, phase1Ms,
                            phase1Result.executedCount(), phase1Result.failedCount());

                    allSucceeded.addAll(phase1Result.succeeded());
                    allFailed.addAll(phase1Result.failed());

                    List<String> newTableKeys = phase1Result.succeeded().stream()
                            .filter(s -> "CREATE_TABLE".equals(s.category()))
                            .map(s -> extractTableKeyFromDescription(s.description()))
                            .filter(Objects::nonNull)
                            .toList();
                    if (!newTableKeys.isEmpty()) {
                        long copyStart = System.nanoTime();
                        copiedRows = copyDataForNewTables(tenantDs, templateJdbc, newTableKeys);
                        log.info("[{}] {} Copia datos: {}ms ({} filas, {} tablas)",
                                executionId, db, elapsedMs(copyStart), copiedRows, newTableKeys.size());
                    }

                    Set<String> phase2Targets = new LinkedHashSet<>(templateRoutines.keySet());
                    phase2Targets.removeAll(prePhase1FunctionSignatures);
                    phase2Planned = phase2Targets.size();
                    long p2Start = System.nanoTime();
                    phase2Result = syncRoutinesToTenantWithDependencies(
                            tenantDs,
                            templateRoutines,
                            phase2Targets,
                            phase3,
                            phase4,
                            executionId,
                            db,
                            allSucceeded,
                            allFailed);
                    phase2Ms = elapsedMs(p2Start);
                    log.info("[{}] {} Fase 2: {}ms (rutinas {}/{} ok/fail)",
                            executionId, db, phase2Ms,
                            phase2Result.applied(), phase2Result.failed());

                    // Fase 2 pudo consumir DDL dependiente de las fases estructurales.
                    phase3Planned = phase3.size();
                    phase4Planned = phase4.size();

                    long p3Start = System.nanoTime();
                    DdlBatchResult result3 = executeDdlBatch(tenantDs, phase3, executionId, db);
                    phase3Ms = elapsedMs(p3Start);
                    phase3Result = result3;
                    log.info("[{}] {} Fase 3: {}ms ({}/{} ok/fail)",
                            executionId, db, phase3Ms,
                            result3.executedCount(), result3.failedCount());

                    allSucceeded.addAll(result3.succeeded());
                    allFailed.addAll(result3.failed());

                    // Antes de Fase 4 (FKs): alinear sucursal_id en almacen.almacen y asegurar auth.sucursal.
                    // Si solo corremos esto en Fase 5, el DDL falla porque las FKs se aplican antes.
                    if (dataSyncProperties.isEnabled() && dataSyncTableListContains("almacen.almacen")) {
                        try {
                            if (dataSyncTableListContains("auth.sucursal")) {
                                int nSuc = upsertAuthSucursal(tenantDs, templateJdbc);
                                if (nSuc > 0) {
                                    log.info("[{}] {} Pre-Fase4 auth.sucursal: {} filas upserted", executionId, db, nSuc);
                                }
                            }
                            int nAlm = upsertAlmacenAlmacen(tenantDs, templateJdbc, executionId, db);
                            log.info("[{}] {} Pre-Fase4 almacen.almacen reconciliado ({} filas upserted) para DDL FK",
                                    executionId, db, nAlm);
                        } catch (Exception ex) {
                            log.warn("[{}] {} Pre-Fase4 datos almacen/sucursal (continua DDL): {}",
                                    executionId, db, rootMessage(ex));
                        }
                    }

                    long p4Start = System.nanoTime();
                    DdlBatchResult result4 = executeDdlBatch(tenantDs, phase4, executionId, db);
                    phase4Ms = elapsedMs(p4Start);
                    phase4Result = result4;
                    log.info("[{}] {} Fase 4: {}ms ({}/{} ok/fail)",
                            executionId, db, phase4Ms,
                            result4.executedCount(), result4.failedCount());

                    allSucceeded.addAll(result4.succeeded());
                    allFailed.addAll(result4.failed());

                    appliedStatements = allSucceeded.size();
                }
            } else {
                phase2Planned = Math.max(0, templateRoutines.size() - prePhase1FunctionCount);
            }

            int dataSyncRows = 0;
            int phase5Planned = dataSyncProperties.getTableList().size();
            if (!request.isDryRun() && dataSyncProperties.isEnabled()) {
                long dsStart = System.nanoTime();
                dataSyncRows = executeDataSyncPhase5(tenantDs, templateJdbc, executionId, tenant);
                phase5Ms = elapsedMs(dsStart);
            }

            long totalMs = elapsedMs(started);
            int totalFailed = allFailed.size() + phase2Result.failed();
            int ownershipFailed = countOwnershipErrors(allFailed);
            log.info("[{}] {} completado en {}ms (snapshot={}ms, plan={} stmts, applied={}, "
                            + "failed={}, warnings={}, rows={}, dataSync={}, routines={})",
                    executionId, db, totalMs, snapMs, plan.statements().size(),
                    appliedStatements, totalFailed, plan.warnings().size(), copiedRows, dataSyncRows, phase2Result.applied());
            if (ownershipFailed > 0) {
                log.error("[{}] {} Auditoria: {} DDL fallaron por ownership para usuario '{}'. "
                                + "Accion requerida: transferir ownership de objetos o ejecutar sync con owner.",
                        executionId, db, ownershipFailed, tenant.dbUser());
            }

            persistPhaseSummaryLog(executionId, request.isDryRun(), tenant, FASE_1,
                    phase1Planned, phase1Result.executedCount(), phase1Result.failedCount(), phase1Ms);
            persistPhaseSummaryLog(executionId, request.isDryRun(), tenant, FASE_2,
                    phase2Planned, phase2Result.applied(), phase2Result.failed(), phase2Ms);
            persistPhaseSummaryLog(executionId, request.isDryRun(), tenant, FASE_3,
                    phase3Planned, phase3Result.executedCount(), phase3Result.failedCount(), phase3Ms);
            persistPhaseSummaryLog(executionId, request.isDryRun(), tenant, FASE_4,
                    phase4Planned, phase4Result.executedCount(), phase4Result.failedCount(), phase4Ms);
            persistPhaseSummaryLog(executionId, request.isDryRun(), tenant, FASE_5,
                    phase5Planned, dataSyncRows, 0, phase5Ms);

            if (allSucceeded.isEmpty() && allFailed.isEmpty() && dataSyncRows == 0 && phase2Result.applied() == 0) {
                persistNoChangeTenantLog(executionId, request.isDryRun(), tenant, totalMs);
            }
            persistObjectLogs(executionId, request.isDryRun(), tenant, allSucceeded, totalMs);
            persistFailedDdlLogs(executionId, request.isDryRun(), tenant, allFailed, totalMs);

            List<String> warnings = new ArrayList<>(plan.warnings());
            for (FailedDdl f : allFailed) {
                warnings.add("DDL fallido [" + f.statement().category() + "]: " + f.error());
            }
            if (phase2Result.failed() > 0) {
                warnings.add("Rutinas fallidas en FASE_2: " + phase2Result.failed());
            }

            return TenantSchemaSyncResult.builder()
                    .tenantDbName(db)
                    .nombreEmpresa(tenant.nombreEmpresa())
                    .success(totalFailed == 0)
                    // FASE 2 (routines) se re-aplican siempre; solo contamos como "cambio"
                    // los DDLs estructurales reales (fases 1/3/4) o filas de datos modificadas.
                    .changed(!allSucceeded.isEmpty() || dataSyncRows > 0)
                    .dryRun(request.isDryRun())
                    .durationMs(totalMs)
                    .plannedStatements(plan.statements().size() + phase2Planned)
                    .appliedStatements(appliedStatements + phase2Result.applied())
                    .statements(sqlStatements)
                    .warnings(warnings)
                    .error(totalFailed > 0 ? totalFailed + " operaciones fallidas" : null)
                    .build();
        } catch (Exception ex) {
            long totalMs = elapsedMs(started);
            String message = rootMessage(ex);
            log.error("[{}] {} FALLO en {}ms: {}", executionId, db, totalMs, message, ex);

            persistFailedTenantLog(executionId, request.isDryRun(), tenant, totalMs, message);

            return TenantSchemaSyncResult.builder()
                    .tenantDbName(db)
                    .nombreEmpresa(tenant.nombreEmpresa())
                    .success(false).changed(false)
                    .dryRun(request.isDryRun())
                    .durationMs(totalMs)
                    .plannedStatements(0).appliedStatements(0)
                    .statements(List.of())
                    .warnings(List.of())
                    .error(message)
                    .build();
        }
    }

    // ---- Phase classification & execution ----

    private void classifyStatements(List<DdlStatement> all,
                                    List<DdlStatement> phase1,
                                    List<DdlStatement> phase3,
                                    List<DdlStatement> phase4) {
        for (DdlStatement stmt : all) {
            if (PHASE_1_CATEGORIES.contains(stmt.category())) {
                phase1.add(stmt);
            } else if (PHASE_3_CATEGORIES.contains(stmt.category())) {
                phase3.add(stmt);
            } else if (PHASE_4_CATEGORIES.contains(stmt.category())) {
                phase4.add(stmt);
            } else {
                phase4.add(stmt);
            }
        }
    }

    /**
     * Conecta como admin (postgres / owner de la BD) y otorga GRANT ALL ON SCHEMA
     * + ALTER DEFAULT PRIVILEGES al db_user del tenant para que pueda crear tablas, secuencias, etc.
     */
    private void ensureSchemaPermissions(TenantConnectionInfo tenant, String executionId, HikariDataSource adminDs) {
        String tenantUser = tenant.dbUser();
        String db = tenant.dbName();
        log.info("[{}] {} Auditoria paso 1/2: iniciando GRANT de schema para usuario '{}'",
                executionId, db, tenantUser);

        try (Connection conn = adminDs.getConnection();
             Statement st = conn.createStatement()) {

            String sql = """
                DO $$
                DECLARE
                    r RECORD;
                    tenant_role TEXT := %s;
                BEGIN
                    FOR r IN
                        SELECT schemaname AS schema_name, tablename AS object_name
                        FROM pg_tables
                        WHERE schemaname NOT LIKE 'pg_%%'
                          AND schemaname <> 'information_schema'
                    LOOP
                        BEGIN
                            EXECUTE format('ALTER TABLE %%I.%%I OWNER TO %%I',
                                           r.schema_name, r.object_name, tenant_role);
                        EXCEPTION WHEN OTHERS THEN
                            RAISE NOTICE 'No se pudo cambiar owner de tabla %%.%%: %%', r.schema_name, r.object_name, SQLERRM;
                        END;
                    END LOOP;

                    FOR r IN
                        SELECT sequence_schema AS schema_name, sequence_name AS object_name
                        FROM information_schema.sequences
                        WHERE sequence_schema NOT LIKE 'pg_%%'
                          AND sequence_schema <> 'information_schema'
                    LOOP
                        BEGIN
                            EXECUTE format('ALTER SEQUENCE %%I.%%I OWNER TO %%I',
                                           r.schema_name, r.object_name, tenant_role);
                        EXCEPTION WHEN OTHERS THEN
                            RAISE NOTICE 'No se pudo cambiar owner de secuencia %%.%%: %%', r.schema_name, r.object_name, SQLERRM;
                        END;
                    END LOOP;

                    FOR r IN
                        SELECT n.nspname AS schema_name,
                               p.proname AS object_name,
                               pg_get_function_identity_arguments(p.oid) AS identity_args,
                               p.prokind AS object_kind
                        FROM pg_proc p
                        JOIN pg_namespace n ON n.oid = p.pronamespace
                        WHERE n.nspname NOT LIKE 'pg_%%'
                          AND n.nspname <> 'information_schema'
                          AND p.prokind IN ('f', 'p')
                    LOOP
                        BEGIN
                            IF r.object_kind = 'p' THEN
                                EXECUTE format('ALTER PROCEDURE %%I.%%I(%%s) OWNER TO %%I',
                                               r.schema_name, r.object_name, COALESCE(r.identity_args, ''), tenant_role);
                            ELSE
                                EXECUTE format('ALTER FUNCTION %%I.%%I(%%s) OWNER TO %%I',
                                               r.schema_name, r.object_name, COALESCE(r.identity_args, ''), tenant_role);
                            END IF;
                        EXCEPTION WHEN OTHERS THEN
                            RAISE NOTICE 'No se pudo cambiar owner de rutina %%.%%: %%', r.schema_name, r.object_name, SQLERRM;
                        END;
                    END LOOP;

                    FOR r IN
                        SELECT nspname FROM pg_namespace
                        WHERE nspname NOT LIKE 'pg_%%'
                          AND nspname <> 'information_schema'
                    LOOP
                        BEGIN
                            EXECUTE format('GRANT USAGE, CREATE ON SCHEMA %%I TO %%I', r.nspname, tenant_role);
                            EXECUTE format('GRANT ALL ON SCHEMA %%I TO %%I', r.nspname, tenant_role);
                            EXECUTE format('GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA %%I TO %%I', r.nspname, tenant_role);
                            EXECUTE format('GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA %%I TO %%I', r.nspname, tenant_role);
                            EXECUTE format('GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA %%I TO %%I', r.nspname, tenant_role);
                            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %%I GRANT ALL ON TABLES TO %%I', r.nspname, tenant_role);
                            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %%I GRANT ALL ON SEQUENCES TO %%I', r.nspname, tenant_role);
                            EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %%I GRANT ALL ON FUNCTIONS TO %%I', r.nspname, tenant_role);
                        EXCEPTION WHEN OTHERS THEN
                            RAISE NOTICE 'No se pudo otorgar permisos en schema %%: %%', r.nspname, SQLERRM;
                        END;
                    END LOOP;
                END $$;
                """.formatted("'" + tenantUser.replace("'", "''") + "'");

            st.execute(sql);
            log.info("[{}] {} Auditoria ownership: intento de transferir owner de tablas/secuencias al usuario tenant '{}'",
                    executionId, db, tenantUser);
            log.info("[{}] {} Auditoria paso 1/2 finalizado: GRANT de schema ejecutado para '{}'",
                    executionId, db, tenantUser);
            log.info("[{}] {} Auditoria paso 2/2: iniciando DDL de sincronizacion", executionId, db);

        } catch (SQLException ex) {
            log.warn("[{}] {} Auditoria paso 1/2 FALLIDO para usuario '{}': {}",
                    executionId, db, tenantUser, sqlError(ex));
        }
    }

    private Map<String, RoutineDefinition> loadTemplateRoutines(JdbcTemplate templateJdbc) {
        List<RoutineDefinition> routines = templateJdbc.query(
                """
                SELECT n.nspname AS schema_name,
                       p.proname AS routine_name,
                       pg_get_function_identity_arguments(p.oid) AS identity_args,
                       pg_get_functiondef(p.oid) AS ddl
                FROM pg_proc p
                JOIN pg_namespace n ON n.oid = p.pronamespace
                WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
                  AND n.nspname NOT LIKE 'pg_toast%%'
                  AND n.nspname NOT LIKE 'pg_temp%%'
                  AND p.prokind IN ('f', 'p')
                ORDER BY n.nspname, p.proname, pg_get_function_identity_arguments(p.oid)
                """,
                (rs, rowNum) -> new RoutineDefinition(
                        rs.getString("schema_name"),
                        rs.getString("routine_name"),
                        rs.getString("identity_args"),
                        rs.getString("ddl"))
        );
        Map<String, RoutineDefinition> indexed = new java.util.LinkedHashMap<>();
        for (RoutineDefinition routine : routines) {
            indexed.put(routine.signature(), routine);
        }
        return indexed;
    }

    private Set<String> extractRequiredZeroArgFunctions(List<DdlStatement> statements,
                                                        Map<String, RoutineDefinition> templateRoutines) {
        if (statements == null || statements.isEmpty() || templateRoutines.isEmpty()) {
            return Set.of();
        }
        Set<String> required = new LinkedHashSet<>();
        for (DdlStatement statement : statements) {
            if (statement == null || statement.sql() == null) {
                continue;
            }
            Matcher matcher = ZERO_ARG_FUNCTION_CALL_PATTERN.matcher(statement.sql());
            while (matcher.find()) {
                String schema = matcher.group(1);
                String routine = matcher.group(2);
                String signature = schema + "." + routine + "()";
                if (templateRoutines.containsKey(signature)) {
                    required.add(signature);
                }
            }
        }
        return required;
    }

    private RoutineSyncResult syncRoutinesToTenant(HikariDataSource tenantDs,
                                                   Map<String, RoutineDefinition> templateRoutines,
                                                   Set<String> targetSignatures,
                                                   String executionId,
                                                   String db,
                                                   String phaseLabel) {
        if (targetSignatures == null || targetSignatures.isEmpty()) {
            return RoutineSyncResult.empty();
        }
        List<RoutineDefinition> pending = targetSignatures.stream()
                .map(templateRoutines::get)
                .filter(Objects::nonNull)
                .collect(Collectors.toCollection(ArrayList::new));
        if (pending.isEmpty()) {
            return RoutineSyncResult.empty();
        }

        int planned = pending.size();
        int applied = 0;
        int failed = 0;
        Set<String> synced = new LinkedHashSet<>();
        int maxPasses = Math.max(1, pending.size());

        for (int pass = 1; pass <= maxPasses && !pending.isEmpty(); pass++) {
            int before = pending.size();
            List<RoutineDefinition> retry = new ArrayList<>();
            for (RoutineDefinition routine : pending) {
                try (Connection conn = tenantDs.getConnection();
                     Statement st = conn.createStatement()) {
                    st.execute(routine.ddl());
                    applied++;
                    synced.add(routine.signature());
                } catch (SQLException ex) {
                    retry.add(routine);
                    log.warn("[{}] {} {} rutina fallida [{}]: {}",
                            executionId, db, phaseLabel, routine.signature(), sqlError(ex));
                }
            }
            if (retry.size() == before) {
                failed += retry.size();
                break;
            }
            pending = retry;
        }

        if (!pending.isEmpty()) {
            failed = Math.max(failed, pending.size());
        }
        return new RoutineSyncResult(planned, applied, failed, synced);
    }

    private RoutineSyncResult syncRoutinesToTenantWithDependencies(
            HikariDataSource tenantDs,
            Map<String, RoutineDefinition> templateRoutines,
            Set<String> targetSignatures,
            List<DdlStatement> phase3Pending,
            List<DdlStatement> phase4Pending,
            String executionId,
            String db,
            List<DdlStatement> dependencySucceeded,
            List<FailedDdl> dependencyFailed) {
        if (targetSignatures == null || targetSignatures.isEmpty()) {
            return RoutineSyncResult.empty();
        }
        List<RoutineDefinition> pending = targetSignatures.stream()
                .map(templateRoutines::get)
                .filter(Objects::nonNull)
                .collect(Collectors.toCollection(ArrayList::new));
        if (pending.isEmpty()) {
            return RoutineSyncResult.empty();
        }

        int planned = pending.size();
        int applied = 0;
        int failed = 0;
        Set<String> synced = new LinkedHashSet<>();
        int maxPasses = Math.max(2, pending.size() * 2);

        for (int pass = 1; pass <= maxPasses && !pending.isEmpty(); pass++) {
            int before = pending.size();
            int passProgress = 0;
            List<RoutineDefinition> retry = new ArrayList<>();

            for (RoutineDefinition routine : pending) {
                try {
                    executeRoutine(tenantDs, routine);
                    applied++;
                    passProgress++;
                    synced.add(routine.signature());
                    continue;
                } catch (SQLException ex) {
                    if (!isRoutineDependencyError(ex)) {
                        retry.add(routine);
                        log.warn("[{}] {} FASE_2 rutina fallida [{}]: {}",
                                executionId, db, routine.signature(), sqlError(ex));
                        continue;
                    }

                    DdlBatchResult dependencyResult = executeRoutineDependencyChain(
                            tenantDs, routine, ex, phase3Pending, phase4Pending, executionId, db);
                    if (dependencyResult.executedCount() > 0 || dependencyResult.failedCount() > 0) {
                        dependencySucceeded.addAll(dependencyResult.succeeded());
                        dependencyFailed.addAll(dependencyResult.failed());
                    }

                    try {
                        executeRoutine(tenantDs, routine);
                        applied++;
                        passProgress++;
                        synced.add(routine.signature());
                    } catch (SQLException retryEx) {
                        retry.add(routine);
                        log.warn("[{}] {} FASE_2 rutina fallida tras resolver cadena [{}]: {}",
                                executionId, db, routine.signature(), sqlError(retryEx));
                    }
                }
            }

            pending = retry;
            if (pending.isEmpty()) {
                break;
            }
            if (pending.size() == before && passProgress == 0) {
                failed = pending.size();
                break;
            }
        }

        if (!pending.isEmpty()) {
            failed = Math.max(failed, pending.size());
        }
        return new RoutineSyncResult(planned, applied, failed, synced);
    }

    private DdlBatchResult executeRoutineDependencyChain(HikariDataSource tenantDs,
                                                         RoutineDefinition routine,
                                                         SQLException ex,
                                                         List<DdlStatement> phase3Pending,
                                                         List<DdlStatement> phase4Pending,
                                                         String executionId,
                                                         String db) {
        List<DdlStatement> phase3Candidates = pickDependencyStatementsForRoutine(routine, ex, phase3Pending);
        List<DdlStatement> phase4Candidates = pickDependencyStatementsForRoutine(routine, ex, phase4Pending);

        if (phase3Candidates.isEmpty() && phase4Candidates.isEmpty()) {
            phase3Candidates = new ArrayList<>(phase3Pending);
            phase4Candidates = new ArrayList<>(phase4Pending);
        }

        DdlBatchResult result3 = executeAndConsumeDependencyStatements(
                tenantDs, phase3Pending, phase3Candidates, executionId, db, "FASE_2->FASE_3");
        DdlBatchResult result4 = executeAndConsumeDependencyStatements(
                tenantDs, phase4Pending, phase4Candidates, executionId, db, "FASE_2->FASE_4");

        List<DdlStatement> success = new ArrayList<>(result3.succeeded());
        success.addAll(result4.succeeded());
        List<FailedDdl> failed = new ArrayList<>(result3.failed());
        failed.addAll(result4.failed());
        return new DdlBatchResult(success, failed);
    }

    private DdlBatchResult executeAndConsumeDependencyStatements(HikariDataSource tenantDs,
                                                                 List<DdlStatement> pending,
                                                                 List<DdlStatement> selected,
                                                                 String executionId,
                                                                 String db,
                                                                 String stageLabel) {
        if (selected == null || selected.isEmpty()) {
            return new DdlBatchResult(List.of(), List.of());
        }
        pending.removeAll(selected);
        DdlBatchResult result = executeDdlBatch(tenantDs, selected, executionId, db);
        if (result.executedCount() > 0 || result.failedCount() > 0) {
            log.info("[{}] {} {}: dependencias ejecutadas ({}/{} ok/fail)",
                    executionId, db, stageLabel, result.executedCount(), result.failedCount());
        }
        return result;
    }

    private List<DdlStatement> pickDependencyStatementsForRoutine(RoutineDefinition routine,
                                                                  SQLException ex,
                                                                  List<DdlStatement> pending) {
        if (pending == null || pending.isEmpty()) {
            return List.of();
        }
        String errorText = ex != null && ex.getMessage() != null ? ex.getMessage() : "";
        Set<String> tokens = new LinkedHashSet<>(extractRoutineTableTokens(routine));

        Matcher relationMatcher = ERROR_RELATION_PATTERN.matcher(errorText);
        if (relationMatcher.find()) {
            tokens.add(normalizeSqlToken(relationMatcher.group(1)));
        }
        Matcher columnMatcher = ERROR_COLUMN_PATTERN.matcher(errorText);
        String missingColumn = columnMatcher.find() ? normalizeSqlToken(columnMatcher.group(1)) : null;

        List<DdlStatement> matched = new ArrayList<>();
        for (DdlStatement stmt : pending) {
            String sql = stmt.sql();
            if (sql == null || sql.isBlank()) {
                continue;
            }
            String normalizedSql = normalizeSqlToken(sql);
            boolean tokenMatch = tokens.stream().anyMatch(t -> !t.isBlank() && normalizedSql.contains(t));
            boolean columnMatch = missingColumn != null && normalizedSql.contains(missingColumn);
            if (tokenMatch || columnMatch) {
                matched.add(stmt);
            }
        }
        return matched;
    }

    private Set<String> extractRoutineTableTokens(RoutineDefinition routine) {
        Set<String> tokens = new LinkedHashSet<>();
        if (routine == null || routine.ddl() == null || routine.ddl().isBlank()) {
            return tokens;
        }
        Matcher matcher = TABLE_TOKEN_PATTERN.matcher(routine.ddl());
        while (matcher.find()) {
            tokens.add(normalizeSqlToken(matcher.group(1)));
        }
        return tokens;
    }

    private boolean isRoutineDependencyError(SQLException ex) {
        return ex != null && ex.getSQLState() != null && ROUTINE_DEPENDENCY_SQLSTATES.contains(ex.getSQLState());
    }

    private void executeRoutine(HikariDataSource tenantDs, RoutineDefinition routine) throws SQLException {
        try (Connection conn = tenantDs.getConnection();
             Statement st = conn.createStatement()) {
            st.execute(routine.ddl());
        }
    }

    private String normalizeSqlToken(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\"", "").trim().toLowerCase(Locale.ROOT);
    }

    private DdlBatchResult executeDdlBatch(HikariDataSource ds, List<DdlStatement> stmts,
                                           String executionId, String db) {
        if (stmts.isEmpty()) return new DdlBatchResult(List.of(), List.of());
        List<DdlStatement> succeeded = new ArrayList<>();
        List<FailedDdl> failed = new ArrayList<>();
        try (Connection conn = ds.getConnection()) {
            conn.setAutoCommit(true);
            try (Statement st = conn.createStatement()) {
                for (DdlStatement ddl : stmts) {
                    try {
                        st.execute(ddl.sql());
                        succeeded.add(ddl);
                    } catch (SQLException ex) {
                        SQLException handledEx = ex;
                        if (isMissingReferencedUniqueConstraint(ex) && isFkCategory(ddl.category())) {
                            boolean prepared = ensureReferencedTableUniqueForFk(conn, ddl, executionId, db);
                            if (prepared) {
                                try {
                                    st.execute(ddl.sql());
                                    succeeded.add(ddl);
                                    log.info("[{}] {} FK reintentada y aplicada [{}]",
                                            executionId, db, ddl.description());
                                    continue;
                                } catch (SQLException retryEx) {
                                    handledEx = retryEx;
                                }
                            }
                        }
                        String error = sqlError(handledEx);
                        failed.add(new FailedDdl(ddl, error));
                        log.warn("[{}] {} DDL fallido [{}]: {}", executionId, db, ddl.description(), error);
                    }
                }
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error obteniendo conexion para DDL batch", ex);
        }
        return new DdlBatchResult(succeeded, failed);
    }

    // ---- Data copy ----

    private int copyDataForNewTables(HikariDataSource tenantDs, JdbcTemplate templateJdbc,
                                     List<String> tableKeys) {
        int totalRows = 0;
        try (Connection conn = tenantDs.getConnection()) {
            conn.setAutoCommit(false);
            try (Statement stmt = conn.createStatement()) {
                for (String tableKey : tableKeys) {
                    totalRows += copyTable(conn, templateJdbc, tableKey);
                }
                conn.commit();
                resetSequences(tenantDs, tableKeys);
            } catch (Exception ex) {
                conn.rollback();
                log.error("Rollback copia de datos: {}", rootMessage(ex));
                throw ex;
            }
        } catch (SQLException ex) {
            log.error("Error conexion para copia: {}", rootMessage(ex));
        }
        return totalRows;
    }

    private int copyTable(Connection tenantConn, JdbcTemplate templateJdbc, String tableKey) {
        String qualifiedName = buildQualifiedName(tableKey);
        List<Map<String, Object>> rows = templateJdbc.queryForList("SELECT * FROM " + qualifiedName);
        if (rows.isEmpty()) {
            log.debug("  {} sin datos en template", tableKey);
            return 0;
        }

        List<String> columns = new ArrayList<>(rows.get(0).keySet());
        String colList = columns.stream().map(c -> "\"" + c + "\"").collect(Collectors.joining(", "));
        String placeholders = columns.stream().map(c -> "?").collect(Collectors.joining(", "));
        String insertSql = "INSERT INTO " + qualifiedName + " (" + colList + ") VALUES (" + placeholders + ")";

        try (PreparedStatement pstmt = tenantConn.prepareStatement(insertSql)) {
            int batchSize = 500;
            int count = 0;
            for (Map<String, Object> row : rows) {
                int idx = 1;
                for (String col : columns) {
                    pstmt.setObject(idx++, row.get(col));
                }
                pstmt.addBatch();
                count++;
                if (count % batchSize == 0) pstmt.executeBatch();
            }
            if (count % batchSize != 0) pstmt.executeBatch();
            log.debug("  {} -> {} registros copiados", tableKey, count);
            return count;
        } catch (SQLException ex) {
            throw new RuntimeException("Error copiando datos a " + tableKey, ex);
        }
    }

    private void resetSequences(HikariDataSource tenantDs, List<String> tableKeys) {
        JdbcTemplate tenantJdbc = new JdbcTemplate(tenantDs);
        for (String tableKey : tableKeys) {
            try {
                String qn = buildQualifiedName(tableKey);
                List<Map<String, Object>> seqs = tenantJdbc.queryForList("""
                        SELECT a.attname AS column_name,
                               pg_get_serial_sequence(%s::regclass::text, a.attname) AS seq_name
                        FROM pg_attribute a
                        JOIN pg_class c ON c.oid = a.attrelid
                        WHERE c.oid = %s::regclass
                          AND a.attnum > 0 AND NOT a.attisdropped
                          AND pg_get_serial_sequence(%s::regclass::text, a.attname) IS NOT NULL
                        """.formatted(literal(qn), literal(qn), literal(qn)));
                for (Map<String, Object> s : seqs) {
                    String col = (String) s.get("column_name");
                    String seq = (String) s.get("seq_name");
                    if (seq != null) {
                        tenantJdbc.execute("SELECT setval('%s', COALESCE((SELECT MAX(\"%s\") FROM %s), 1))"
                                .formatted(seq, col, qn));
                    }
                }
            } catch (Exception ex) {
                log.warn("No se resetearon secuencias para {}: {}", tableKey, ex.getMessage());
            }
        }
    }

    // ---- Audit: ciclo INICIO → PROCESANDO → TERMINADO / FALLIDO ----

    private SchemaSyncCronLog persistHeader(String executionId, boolean dryRun,
                                            String status, String message) {
        try {
            SchemaSyncCronLog header = SchemaSyncCronLog.builder()
                    .executionId(executionId)
                    .status(status)
                    .fase(FASE_GENERAL)
                    .dryRun(dryRun)
                    .messageFinal(message)
                    .isFailed(false)
                    .isChanged(false)
                    .durationMs(0)
                    .build();
            return cronLogRepository.save(header);
        } catch (Exception ex) {
            log.warn("No se pudo persistir header INICIO: {}", ex.getMessage());
            return null;
        }
    }

    private void updateHeaderStatus(SchemaSyncCronLog header, String status, String message) {
        if (header == null) return;
        try {
            header.setStatus(status);
            header.setMessageFinal(message);
            cronLogRepository.save(header);
        } catch (Exception ex) {
            log.warn("No se pudo actualizar header a {}: {}", status, ex.getMessage());
        }
    }

    private void updateHeaderFinal(SchemaSyncCronLog header, String status, String message,
                                   long durationMs, boolean failed, boolean changed) {
        if (header == null) return;
        try {
            header.setStatus(status);
            header.setMessageFinal(message);
            header.setDurationMs(durationMs);
            header.setFailed(failed);
            header.setChanged(changed);
            cronLogRepository.save(header);
        } catch (Exception ex) {
            log.warn("No se pudo actualizar header final a {}: {}", status, ex.getMessage());
        }
    }

    private void persistObjectLogs(String executionId, boolean dryRun,
                                   TenantConnectionInfo tenant,
                                   List<DdlStatement> statements, long tenantDurationMs) {
        if (statements == null || statements.isEmpty()) return;
        try {
            List<SchemaSyncCronLog> logs = new ArrayList<>();
            for (DdlStatement stmt : statements) {
                logs.add(SchemaSyncCronLog.builder()
                        .executionId(executionId)
                        .status(STATUS_TERMINADO)
                        .fase(resolvePhaseByCategory(stmt.category()))
                        .dryRun(dryRun)
                        .tenantDbName(tenant.dbName())
                        .messageFinal(dryRun ? "Dry-run planificado" : "Sincronizado")
                        .isFailed(false)
                        .isChanged(true)
                        .nombreEmpresa(tenant.nombreEmpresa())
                        .statementsExecute(stmt.sql())
                        .schemaObject(truncate(extractSchemaObject(stmt.sql()), MAX_SCHEMA_OBJECT_LENGTH))
                        .objectsSummary(extractObjectLabel(stmt.sql()))
                        .objectType(resolveObjectType(stmt.category()))
                        .durationMs(tenantDurationMs)
                        .build());
            }
            cronLogRepository.saveAll(logs);
        } catch (Exception ex) {
            log.warn("No se persistieron logs de objetos para {}: {}", tenant.dbName(), ex.getMessage());
        }
    }

    private void persistFailedDdlLogs(String executionId, boolean dryRun,
                                       TenantConnectionInfo tenant,
                                       List<FailedDdl> failedList, long tenantDurationMs) {
        if (failedList == null || failedList.isEmpty()) return;
        try {
            List<SchemaSyncCronLog> logs = new ArrayList<>();
            for (FailedDdl f : failedList) {
                logs.add(SchemaSyncCronLog.builder()
                        .executionId(executionId)
                        .status(STATUS_FALLIDO)
                        .fase(resolvePhaseByCategory(f.statement().category()))
                        .dryRun(dryRun)
                        .tenantDbName(tenant.dbName())
                        .messageFinal("DDL fallido: " + truncate(f.error(), 200))
                        .isFailed(true)
                        .isChanged(false)
                        .nombreEmpresa(tenant.nombreEmpresa())
                        .statementsExecute(f.statement().sql())
                        .schemaObject(truncate(extractSchemaObject(f.statement().sql()), MAX_SCHEMA_OBJECT_LENGTH))
                        .objectsSummary(extractObjectLabel(f.statement().sql()))
                        .objectType(resolveObjectType(f.statement().category()))
                        .durationMs(tenantDurationMs)
                        .errorDetail(f.error())
                        .build());
            }
            cronLogRepository.saveAll(logs);
        } catch (Exception ex) {
            log.warn("No se persistieron logs de DDL fallidos para {}: {}", tenant.dbName(), ex.getMessage());
        }
    }

    private void persistNoChangeTenantLog(String executionId, boolean dryRun,
                                          TenantConnectionInfo tenant, long durationMs) {
        try {
            cronLogRepository.save(SchemaSyncCronLog.builder()
                    .executionId(executionId)
                    .status(STATUS_TERMINADO)
                    .fase(FASE_GENERAL)
                    .dryRun(dryRun)
                    .tenantDbName(tenant.dbName())
                    .messageFinal("Sin cambios detectados")
                    .isFailed(false)
                    .isChanged(false)
                    .nombreEmpresa(tenant.nombreEmpresa())
                    .durationMs(durationMs)
                    .build());
        } catch (Exception ex) {
            log.warn("No se persistio log sin cambios para {}: {}", tenant.dbName(), ex.getMessage());
        }
    }

    private void persistFailedTenantLog(String executionId, boolean dryRun,
                                        TenantConnectionInfo tenant,
                                        long durationMs, String errorMessage) {
        try {
            cronLogRepository.save(SchemaSyncCronLog.builder()
                    .executionId(executionId)
                    .status(STATUS_FALLIDO)
                    .fase(FASE_GENERAL)
                    .dryRun(dryRun)
                    .tenantDbName(tenant.dbName())
                    .messageFinal("Error: " + truncate(errorMessage, 200))
                    .isFailed(true)
                    .isChanged(false)
                    .nombreEmpresa(tenant.nombreEmpresa())
                    .durationMs(durationMs)
                    .errorDetail(errorMessage)
                    .build());
        } catch (Exception ex) {
            log.warn("No se persistio log de error para {}: {}", tenant.dbName(), ex.getMessage());
        }
    }

    private void persistPhaseSummaryLog(String executionId, boolean dryRun,
                                        TenantConnectionInfo tenant, String fase,
                                        int planned, int applied, int failed, long durationMs) {
        try {
            boolean hasChanges = planned > 0;
            boolean hasFailures = failed > 0;
            String status = hasFailures ? STATUS_FALLIDO : STATUS_TERMINADO;
            String message;
            if (!hasChanges) {
                message = "Fase sin cambios detectados";
            } else if (dryRun) {
                message = String.format("Dry-run fase: planificados=%d, ejecutados=%d, fallidos=%d", planned, applied, failed);
            } else {
                message = String.format("Fase ejecutada: planificados=%d, aplicados=%d, fallidos=%d", planned, applied, failed);
            }
            cronLogRepository.save(SchemaSyncCronLog.builder()
                    .executionId(executionId)
                    .status(status)
                    .fase(fase)
                    .dryRun(dryRun)
                    .tenantDbName(tenant.dbName())
                    .messageFinal(message)
                    .isFailed(hasFailures)
                    .isChanged(hasChanges)
                    .nombreEmpresa(tenant.nombreEmpresa())
                    .objectType("FASE")
                    .durationMs(durationMs)
                    .build());
        } catch (Exception ex) {
            log.warn("No se persistio resumen de {} para {}: {}", fase, tenant.dbName(), ex.getMessage());
        }
    }

    // ---- Object type & label resolution ----

    private String resolveObjectType(String category) {
        if (category == null) return "OTHER";
        return switch (category) {
            case "CREATE_TABLE" -> "TABLA";
            case "ADD_COLUMN", "ALTER_COLUMN_TYPE", "FK_PREREQ_COLUMN" -> "CAMPO";
            case "ADD_PRIMARY_KEY", "NEW_TABLE_PK" -> "PK";
            case "ADD_UNIQUE", "NEW_TABLE_UX" -> "UX";
            case "ADD_FOREIGN_KEY", "ADD_COLUMN_FK", "NEW_TABLE_FK" -> "FK";
            case "CREATE_INDEX", "NEW_TABLE_IX" -> "INDICE";
            case "CREATE_SEQUENCE" -> "SECUENCIA";
            default -> "OTHER";
        };
    }

    private String resolvePhaseByCategory(String category) {
        if (category == null) return FASE_GENERAL;
        if (PHASE_1_CATEGORIES.contains(category)) return FASE_1;
        if (PHASE_3_CATEGORIES.contains(category)) return FASE_3;
        if (PHASE_4_CATEGORIES.contains(category)) return FASE_4;
        return FASE_GENERAL;
    }

    private String extractSchemaObject(String sql) {
        if (sql == null) return null;
        String upper = sql.trim().toUpperCase();
        if (upper.startsWith("CREATE TABLE")) return extractNameAfterKeyword(sql, "TABLE");
        if (upper.startsWith("ALTER TABLE")) return extractNameAfterKeyword(sql, "TABLE");
        if (upper.contains("INDEX")) return extractNameAfterKeyword(sql, "INDEX");
        if (upper.startsWith("CREATE SEQUENCE")) return extractNameAfterKeyword(sql, "SEQUENCE");
        return null;
    }

    private String extractObjectLabel(String sql) {
        if (sql == null) return null;
        String upper = sql.trim().toUpperCase();
        if (upper.startsWith("CREATE TABLE")) return "CREATE TABLE " + extractNameAfterKeyword(sql, "TABLE");
        if (upper.startsWith("ALTER TABLE") && upper.contains("ADD COLUMN")) return "ADD COLUMN en " + extractNameAfterKeyword(sql, "TABLE");
        if (upper.startsWith("ALTER TABLE") && upper.contains("ALTER COLUMN")) return "ALTER COLUMN en " + extractNameAfterKeyword(sql, "TABLE");
        if (upper.startsWith("ALTER TABLE") && upper.contains("ADD CONSTRAINT")) return "ADD CONSTRAINT en " + extractNameAfterKeyword(sql, "TABLE");
        if (upper.startsWith("CREATE SEQUENCE")) return "CREATE SEQUENCE " + extractNameAfterKeyword(sql, "SEQUENCE");
        if (upper.contains("INDEX")) return "CREATE INDEX " + extractNameAfterKeyword(sql, "INDEX");
        return sql.length() > 80 ? sql.substring(0, 80) + "..." : sql;
    }

    private String extractNameAfterKeyword(String sql, String keyword) {
        String upper = sql.toUpperCase();
        int idx = upper.indexOf(keyword);
        if (idx < 0) return "?";
        String rest = sql.substring(idx + keyword.length()).trim();
        if (rest.toUpperCase().startsWith("IF NOT EXISTS")) {
            rest = rest.substring(13).trim();
        }
        int end = rest.indexOf(' ');
        if (end < 0) end = rest.indexOf('(');
        if (end < 0) end = rest.length();
        return rest.substring(0, end).replace("\"", "");
    }

    private String buildFinalMessage(SchemaSyncResponse.Summary s, long totalMs, boolean dryRun) {
        return String.format("%s en %dms: %d tenants (ok=%d, fallidos=%d, cambios=%d, stmts=%d/%d)",
                dryRun ? "Dry-run terminado" : "Sincronizacion terminada",
                totalMs, s.getTotalTenants(), s.getOkTenants(), s.getFailedTenants(),
                s.getChangedTenants(), s.getAppliedStatements(), s.getPlannedStatements());
    }

    // ---- Helpers ----

    private String extractTableKeyFromDescription(String desc) {
        if (desc == null) return null;
        return desc.startsWith("Crear tabla ") ? desc.substring(12).trim() : null;
    }

    private String buildQualifiedName(String tableKey) {
        String[] parts = tableKey.split("\\.", 2);
        return parts.length == 2
                ? "\"" + parts[0] + "\".\"" + parts[1] + "\""
                : "\"" + tableKey + "\"";
    }

    private String literal(String v) {
        return "'" + v.replace("'", "''") + "'";
    }

    private List<TenantConnectionInfo> filterTenants(List<TenantConnectionInfo> active,
                                                     SchemaSyncRequest request) {
        if (request.targetsAllTenants()) return active;
        Set<String> names = request.getTenantDbNames().stream()
                .filter(Objects::nonNull).map(String::trim).filter(n -> !n.isBlank())
                .collect(LinkedHashSet::new, Set::add, Set::addAll);
        return active.stream()
                .filter(t -> names.contains(t.dbName()))
                .sorted(Comparator.comparing(TenantConnectionInfo::dbName))
                .toList();
    }

    private SchemaSyncResponse.Summary buildSummary(List<TenantSchemaSyncResult> results) {
        int ok = 0, failed = 0, noChange = 0, changed = 0;
        int applied = 0, planned = 0;
        for (TenantSchemaSyncResult r : results) {
            if (r.isSuccess()) ok++; else failed++;
            if (r.isChanged()) changed++;
            else if (r.getError() == null) noChange++;
            planned += r.getPlannedStatements();
            applied += r.getAppliedStatements();
        }
        return SchemaSyncResponse.Summary.builder()
                .totalTenants(results.size())
                .okTenants(ok).failedTenants(failed)
                .noChangeTenants(noChange).changedTenants(changed)
                .appliedStatements(applied).plannedStatements(planned)
                .build();
    }

    private long elapsedMs(long nanoStart) {
        return (System.nanoTime() - nanoStart) / 1_000_000L;
    }

    private String rootMessage(Throwable t) {
        Throwable c = t;
        while (c.getCause() != null) c = c.getCause();
        return c.getMessage() == null ? c.getClass().getSimpleName() : c.getMessage();
    }

    private String sqlError(SQLException ex) {
        String state = ex.getSQLState();
        if (state == null || state.isBlank()) {
            return ex.getMessage();
        }
        return "SQLSTATE " + state + ": " + ex.getMessage();
    }

    private boolean isMissingReferencedUniqueConstraint(SQLException ex) {
        return ex != null && SQLSTATE_MISSING_UNIQUE_FOR_FK.equals(ex.getSQLState());
    }

    private boolean isFkCategory(String category) {
        if (category == null) return false;
        return "ADD_FOREIGN_KEY".equals(category)
                || "ADD_COLUMN_FK".equals(category)
                || "NEW_TABLE_FK".equals(category);
    }

    private boolean ensureReferencedTableUniqueForFk(Connection conn, DdlStatement ddl,
                                                     String executionId, String db) {
        ReferenceTarget target = parseReferenceTarget(ddl.sql());
        if (target == null) {
            log.warn("[{}] {} No se pudo parsear tabla referenciada para FK [{}]",
                    executionId, db, ddl.description());
            return false;
        }
        try {
            TableColumns origin = parseOriginTarget(ddl.sql());
            if (origin == null || !tableHasAllColumns(conn, origin)) {
                log.warn("[{}] {} FK [{}] omitida para autocorreccion: columnas origen no validas",
                        executionId, db, ddl.description());
                return false;
            }
            if (!tableHasAllColumns(conn, new TableColumns(target.schema(), target.table(), target.columns()))) {
                log.warn("[{}] {} FK [{}] omitida para autocorreccion: columnas destino no validas",
                        executionId, db, ddl.description());
                return false;
            }
            if (hasMatchingPkOrUnique(conn, target)) {
                return true;
            }

            String constraintName = buildNextUniqueConstraintName(conn, target.schema(), target.table());
            String colList = target.columns().stream().map(this::quoteIdentifier).collect(Collectors.joining(", "));
            String sql = "ALTER TABLE " + quoteIdentifier(target.schema()) + "." + quoteIdentifier(target.table())
                    + " ADD CONSTRAINT " + quoteIdentifier(constraintName)
                    + " UNIQUE (" + colList + ")";
            try (Statement st = conn.createStatement()) {
                st.execute(sql);
            }
            log.info("[{}] {} Constraint UNIQUE creada {}.{}({}) para habilitar FK",
                    executionId, db, target.schema(), target.table(), String.join(", ", target.columns()));
            return true;
        } catch (SQLException ex) {
            log.warn("[{}] {} No se pudo crear UNIQUE previa para FK [{}]: {}",
                    executionId, db, ddl.description(), sqlError(ex));
            return false;
        }
    }

    private ReferenceTarget parseReferenceTarget(String fkSql) {
        if (fkSql == null || fkSql.isBlank()) return null;
        Matcher matcher = FK_REFERENCE_PATTERN.matcher(fkSql);
        if (!matcher.find()) return null;
        String relation = matcher.group(1);
        String columnsPart = matcher.group(2);

        String[] relationParts = relation.split("\\.", 2);
        String schema = relationParts.length == 2 ? unquoteIdentifier(relationParts[0]) : "public";
        String table = unquoteIdentifier(relationParts.length == 2 ? relationParts[1] : relationParts[0]);

        List<String> columns = List.of(columnsPart.split(",")).stream()
                .map(String::trim)
                .map(this::unquoteIdentifier)
                .filter(v -> !v.isBlank())
                .toList();
        if (table.isBlank() || columns.isEmpty()) return null;
        return new ReferenceTarget(schema, table, columns);
    }

    private TableColumns parseOriginTarget(String fkSql) {
        if (fkSql == null || fkSql.isBlank()) return null;
        Matcher matcher = FK_ORIGIN_PATTERN.matcher(fkSql);
        if (!matcher.find()) return null;
        String relation = matcher.group(1);
        String columnsPart = matcher.group(2);
        String[] relationParts = relation.split("\\.", 2);
        String schema = relationParts.length == 2 ? unquoteIdentifier(relationParts[0]) : "public";
        String table = unquoteIdentifier(relationParts.length == 2 ? relationParts[1] : relationParts[0]);
        List<String> columns = List.of(columnsPart.split(",")).stream()
                .map(String::trim)
                .map(this::unquoteIdentifier)
                .filter(v -> !v.isBlank())
                .toList();
        if (table.isBlank() || columns.isEmpty()) return null;
        return new TableColumns(schema, table, columns);
    }

    private boolean tableHasAllColumns(Connection conn, TableColumns tableColumns) throws SQLException {
        String sql = """
                SELECT COUNT(*)
                FROM pg_attribute a
                JOIN pg_class t ON t.oid = a.attrelid
                JOIN pg_namespace n ON n.oid = t.relnamespace
                WHERE n.nspname = ?
                  AND t.relname = ?
                  AND a.attnum > 0
                  AND NOT a.attisdropped
                  AND a.attname::text = ANY(?::text[])
                """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tableColumns.schema());
            ps.setString(2, tableColumns.table());
            ps.setArray(3, conn.createArrayOf("text", tableColumns.columns().toArray(new String[0])));
            try (var rs = ps.executeQuery()) {
                if (!rs.next()) return false;
                return rs.getInt(1) == tableColumns.columns().size();
            }
        }
    }

    private boolean hasMatchingPkOrUnique(Connection conn, ReferenceTarget target) throws SQLException {
        String sql = """
                SELECT EXISTS (
                    SELECT 1
                    FROM pg_constraint c
                    JOIN pg_class t ON t.oid = c.conrelid
                    JOIN pg_namespace n ON n.oid = t.relnamespace
                    WHERE n.nspname = ?
                      AND t.relname = ?
                      AND c.contype IN ('p', 'u')
                      AND (
                            SELECT array_agg(att.attname::text ORDER BY k.ord)
                            FROM unnest(c.conkey) WITH ORDINALITY AS k(attnum, ord)
                            JOIN pg_attribute att
                              ON att.attrelid = t.oid
                             AND att.attnum = k.attnum
                          ) = ?::text[]
                )
                """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, target.schema());
            ps.setString(2, target.table());
            ps.setArray(3, conn.createArrayOf("text", target.columns().toArray(new String[0])));
            try (var rs = ps.executeQuery()) {
                return rs.next() && rs.getBoolean(1);
            }
        }
    }

    private String buildNextUniqueConstraintName(Connection conn, String schema, String table) throws SQLException {
        String base = "UX_" + table.toUpperCase(Locale.ROOT).replaceAll("[^A-Z0-9_]", "_");
        if (base.length() > 55) {
            base = base.substring(0, 55);
        }
        String regex = "^" + base + "_[0-9]{2}$";
        String sql = """
                SELECT MAX(CASE
                    WHEN c.conname ~ ? THEN CAST(substring(c.conname FROM '([0-9]{2})$') AS int)
                    ELSE 0
                END)
                FROM pg_constraint c
                JOIN pg_class t ON t.oid = c.conrelid
                JOIN pg_namespace n ON n.oid = t.relnamespace
                WHERE n.nspname = ?
                  AND t.relname = ?
                  AND c.contype = 'u'
                """;
        int next = 1;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, regex);
            ps.setString(2, schema);
            ps.setString(3, table);
            try (var rs = ps.executeQuery()) {
                if (rs.next()) {
                    next = Math.max(1, rs.getInt(1) + 1);
                }
            }
        }
        return base + "_" + String.format("%02d", next);
    }

    private String quoteIdentifier(String identifier) {
        return "\"" + identifier.replace("\"", "\"\"") + "\"";
    }

    private String unquoteIdentifier(String identifier) {
        if (identifier == null) return "";
        String value = identifier.trim();
        if (value.startsWith("\"") && value.endsWith("\"") && value.length() >= 2) {
            value = value.substring(1, value.length() - 1);
        }
        return value;
    }

    private int countOwnershipErrors(List<FailedDdl> failedList) {
        if (failedList == null || failedList.isEmpty()) return 0;
        int count = 0;
        for (FailedDdl failedDdl : failedList) {
            if (failedDdl != null && isOwnershipError(failedDdl.error())) {
                count++;
            }
        }
        return count;
    }

    private boolean isOwnershipError(String error) {
        if (error == null || error.isBlank()) return false;
        return error.toLowerCase().contains("must be owner of");
    }

    private static String truncate(String v, int max) {
        if (v == null) return null;
        return v.length() <= max ? v : v.substring(0, max - 3) + "...";
    }

    // ================================================================
    // FASE 5: sincronización de datos maestros template → tenant
    // ================================================================

    private int executeDataSyncPhase5(HikariDataSource tenantDs, JdbcTemplate templateJdbc,
                                      String executionId, TenantConnectionInfo tenant) {
        List<String> tables = dataSyncProperties.getTableList();
        if (tables.isEmpty()) {
            return 0;
        }
        String db = tenant.dbName();
        int totalUpserted = 0;
        log.info("[{}] {} Fase 5: sincronizando datos maestros ({} tablas)", executionId, db, tables.size());

        for (String qualifiedTable : tables) {
            try {
                int rows = upsertTableData(tenantDs, templateJdbc, qualifiedTable, executionId, db);
                if (rows > 0) {
                    log.info("[{}] {} Fase 5: {} -> {} registros upserted", executionId, db, qualifiedTable, rows);
                    persistDataSyncLog(executionId, tenant, qualifiedTable, rows, null);
                }
                totalUpserted += rows;
            } catch (Exception ex) {
                String error = rootMessage(ex);
                log.warn("[{}] {} Fase 5: error en {}: {}", executionId, db, qualifiedTable, error);
                persistDataSyncLog(executionId, tenant, qualifiedTable, 0, error);
            }
        }

        log.info("[{}] {} Fase 5 completada: {} registros totales upserted", executionId, db, totalUpserted);
        return totalUpserted;
    }

    private static final Set<String> AUDIT_COLUMNS = Set.of(
            "id", "creado_en", "actualizado_en", "modificado_en",
            "created_at", "updated_at", "creado_por", "modificado_por");

    private static final int PAGE_SIZE = 2000;

    private int upsertTableData(HikariDataSource tenantDs, JdbcTemplate templateJdbc, String qualifiedTable,
                String executionId, String tenantDb) {
        Integer totalCount = templateJdbc.queryForObject("SELECT COUNT(*) FROM " + qualifiedTable, Integer.class);
        if (totalCount == null || totalCount == 0) {
            return 0;
        }
        // Tablas con remapeo de FKs por codigo (natural key) porque los IDs del template
        // no necesariamente coinciden con los del tenant. El id se resuelve buscando el
        // codigo del padre en el tenant.
        String tbl = qualifiedTable.toLowerCase();
        if ("core.tipo_cambio".equals(tbl)) {
            return upsertTipoCambioByCodigoMoneda(tenantDs, templateJdbc);
        }
        if ("core.departamento".equals(tbl)) {
            return upsertCoreDepartamento(tenantDs, templateJdbc);
        }
        if ("core.provincia".equals(tbl)) {
            return upsertCoreProvincia(tenantDs, templateJdbc);
        }
        if ("core.distrito".equals(tbl)) {
            return upsertCoreDistrito(tenantDs, templateJdbc);
        }
        if ("auth.usuario".equals(tbl)) {
            return upsertAuthUsuario(tenantDs, templateJdbc);
        }
        if ("auth.sucursal".equals(tbl)) {
            return upsertAuthSucursal(tenantDs, templateJdbc);
        }
        if ("almacen.almacen".equals(tbl)) {
            return upsertAlmacenAlmacen(tenantDs, templateJdbc, executionId, tenantDb);
        }
        if ("almacen.almacen_tipo_mov".equals(tbl)) {
            return upsertAlmacenAlmacenTipoMov(tenantDs, templateJdbc);
        }
        if ("contabilidad.tipo_mov_matriz_subcat".equals(tbl)) {
            return upsertContabilidadTipoMovMatrizSubcat(tenantDs, templateJdbc);
        }

        List<Map<String, Object>> firstPage = templateJdbc.queryForList(
                "SELECT * FROM " + qualifiedTable + " LIMIT 1");
        if (firstPage.isEmpty()) {
            return 0;
        }

        String uniqueKeyCsv = dataSyncProperties.getUniqueKeyForTable(qualifiedTable);
        List<String> uniqueKeys = Arrays.stream(uniqueKeyCsv.split(","))
                .map(String::trim)
                .toList();

        List<String> insertColumns = new ArrayList<>(firstPage.get(0).keySet()).stream()
                .filter(c -> !AUDIT_COLUMNS.contains(c.toLowerCase()))
                .toList();

        List<String> updateColumns = insertColumns.stream()
                .filter(c -> uniqueKeys.stream().noneMatch(c::equalsIgnoreCase))
                .toList();

        String colList = insertColumns.stream().map(c -> "\"" + c + "\"").collect(Collectors.joining(", "));
        String placeholders = insertColumns.stream().map(c -> "?").collect(Collectors.joining(", "));
        String conflictCols = uniqueKeys.stream().map(c -> "\"" + c + "\"").collect(Collectors.joining(", "));

        String updateSet;
        if (updateColumns.isEmpty()) {
            updateSet = "DO NOTHING";
        } else {
            updateSet = "DO UPDATE SET " + updateColumns.stream()
                    .map(c -> "\"" + c + "\" = EXCLUDED.\"" + c + "\"")
                    .collect(Collectors.joining(", "))
                    + " WHERE " + updateColumns.stream()
                    .map(c -> qualifiedTable + ".\"" + c + "\" IS DISTINCT FROM EXCLUDED.\"" + c + "\"")
                    .collect(Collectors.joining(" OR "));
        }

        String upsertSql = "INSERT INTO " + qualifiedTable + " (" + colList + ") VALUES (" + placeholders + ") "
                + "ON CONFLICT (" + conflictCols + ") " + updateSet;

        int totalAffected = 0;
        for (int offset = 0; offset < totalCount; offset += PAGE_SIZE) {
            List<Map<String, Object>> page = templateJdbc.queryForList(
                    "SELECT * FROM " + qualifiedTable + " ORDER BY 1 LIMIT " + PAGE_SIZE + " OFFSET " + offset);
            if (page.isEmpty()) {
                break;
            }

            try (Connection conn = tenantDs.getConnection()) {
                conn.setAutoCommit(false);
                try (PreparedStatement pstmt = conn.prepareStatement(upsertSql)) {
                    for (Map<String, Object> row : page) {
                        int idx = 1;
                        for (String col : insertColumns) {
                            pstmt.setObject(idx++, row.get(col));
                        }
                        pstmt.addBatch();
                    }
                    int[] results = pstmt.executeBatch();
                    for (int r : results) {
                        if (r > 0) totalAffected++;
                    }
                    conn.commit();
                } catch (Exception ex) {
                    conn.rollback();
                    throw ex;
                }
            } catch (SQLException ex) {
                throw new RuntimeException("Error upsert en " + qualifiedTable + " (offset=" + offset + ")", ex);
            }
        }
        return totalAffected;
    }

    // ================================================================
    // Upserts con resolución de FKs por código (natural key).
    // Los IDs del template NO necesariamente coinciden con los del tenant,
    // por eso cada FK se resuelve buscando el padre en el tenant por su codigo.
    // Sin ON CONFLICT para evitar depender de UNIQUE constraints inexistentes.
    // ================================================================

    private Map<String, Long> loadIdByCodigo(HikariDataSource tenantDs, String qualifiedTable) {
        JdbcTemplate j = new JdbcTemplate(tenantDs);
        return j.query("SELECT id, codigo FROM " + qualifiedTable + " WHERE codigo IS NOT NULL", rs -> {
            Map<String, Long> out = new LinkedHashMap<>();
            while (rs.next()) {
                out.put(rs.getString("codigo"), rs.getLong("id"));
            }
            return out;
        });
    }

    /**
     * Tabla referenciada por la FK de {@code schema.table(column)} (p. ej. {@code core.sucursal}).
     */
    private String resolvePgFkReferencedTable(HikariDataSource tenantDs, String schema, String table, String column) {
        JdbcTemplate j = new JdbcTemplate(tenantDs);
        try {
            return j.queryForObject(
                    """
                            SELECT c.confrelid::regclass::text
                            FROM pg_constraint c
                            JOIN pg_attribute a ON a.attrelid = c.conrelid AND a.attnum = ANY (c.conkey)
                            WHERE c.conrelid = CAST(? AS regclass)
                              AND c.contype = 'f'
                              AND a.attname = ?
                            ORDER BY c.conname
                            LIMIT 1
                            """,
                    String.class,
                    schema + "." + table,
                    column);
        } catch (Exception ex) {
            log.debug("resolvePgFkReferencedTable {}.{} {}: {}", schema, table, column, ex.getMessage());
            return null;
        }
    }

    private boolean dataSyncTableListContains(String qualifiedTable) {
        String t = qualifiedTable.toLowerCase(Locale.ROOT);
        return dataSyncProperties.getTableList().stream()
                .map(s -> s.toLowerCase(Locale.ROOT))
                .anyMatch(s -> s.equals(t));
    }

    private static final Pattern QUALIFIED_TABLE_NAME_PATTERN =
            Pattern.compile("[a-zA-Z_][a-zA-Z0-9_]*\\.[a-zA-Z_][a-zA-Z0-9_]*");

    /** Tabla referenciada por la FK de sucursal_id en almacen.almacen; por defecto auth.sucursal. */
    private String resolveAlmacenSucursalFkTarget(HikariDataSource tenantDs) {
        String ref = resolvePgFkReferencedTable(tenantDs, "almacen", "almacen", "sucursal_id");
        if (ref != null && isSafeQualifiedTableName(ref)) {
            return ref;
        }
        return "auth.sucursal";
    }

    private static boolean isSafeQualifiedTableName(String name) {
        return name != null && QUALIFIED_TABLE_NAME_PATTERN.matcher(name).matches();
    }

    /**
     * Filas de {@code almacen.almacen} en el template con {@code sucursal_codigo} por JOIN
     * a {@code auth.sucursal} (única tabla de sucursales según DDL).
     */
    private List<Map<String, Object>> queryTemplateAlmacenRows(JdbcTemplate templateJdbc) {
        return templateJdbc.queryForList("""
                SELECT a.codigo, a.nombre, a.flag_estado,
                       s.codigo AS sucursal_codigo,
                       at.codigo AS almacen_tipo_codigo
                FROM almacen.almacen a
                LEFT JOIN auth.sucursal s ON s.id = a.sucursal_id
                LEFT JOIN almacen.almacen_tipo at ON at.id = a.almacen_tipo_id
                ORDER BY a.id
                """);
    }

    private int upsertCoreDepartamento(HikariDataSource tenantDs, JdbcTemplate templateJdbc) {
        List<Map<String, Object>> rows = templateJdbc.queryForList("""
                SELECT d.codigo, d.nombre, d.flag_estado, p.codigo AS pais_codigo
                FROM core.departamento d
                LEFT JOIN core.pais p ON p.id = d.pais_id
                ORDER BY d.id
                """);
        if (rows.isEmpty()) return 0;
        Map<String, Long> paisByCodigo = loadIdByCodigo(tenantDs, "core.pais");
        int affected = 0;
        try (Connection conn = tenantDs.getConnection()) {
            conn.setAutoCommit(false);
            try {
                for (Map<String, Object> r : rows) {
                    String paisCodigo = Objects.toString(r.get("pais_codigo"), null);
                    Long paisId = paisCodigo != null ? paisByCodigo.get(paisCodigo) : null;
                    if (paisId == null) continue;
                    String codigo = Objects.toString(r.get("codigo"));
                    String nombre = Objects.toString(r.get("nombre"));
                    String flag = Objects.toString(r.get("flag_estado"), "1");
                    int upd = jdbcUpdate(conn,
                            "UPDATE core.departamento SET nombre = ?, flag_estado = ? "
                                    + "WHERE codigo = ? AND pais_id = ? "
                                    + "AND (nombre IS DISTINCT FROM ? OR flag_estado IS DISTINCT FROM ?)",
                            nombre, flag, codigo, paisId, nombre, flag);
                    if (upd > 0) {
                        affected++;
                    } else if (!existsRow(conn, "core.departamento",
                            "codigo = ? AND pais_id = ?", codigo, paisId)) {
                        jdbcUpdate(conn,
                                "INSERT INTO core.departamento (codigo, nombre, pais_id, flag_estado) VALUES (?, ?, ?, ?)",
                                codigo, nombre, paisId, flag);
                        affected++;
                    }
                }
                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error upsert core.departamento", ex);
        }
        return affected;
    }

    private int upsertCoreProvincia(HikariDataSource tenantDs, JdbcTemplate templateJdbc) {
        List<Map<String, Object>> rows = templateJdbc.queryForList("""
                SELECT pr.codigo, pr.nombre, pr.flag_estado, d.codigo AS dep_codigo
                FROM core.provincia pr
                LEFT JOIN core.departamento d ON d.id = pr.departamento_id
                ORDER BY pr.id
                """);
        if (rows.isEmpty()) return 0;
        Map<String, Long> depByCodigo = loadIdByCodigo(tenantDs, "core.departamento");
        int affected = 0;
        try (Connection conn = tenantDs.getConnection()) {
            conn.setAutoCommit(false);
            try {
                for (Map<String, Object> r : rows) {
                    String depCodigo = Objects.toString(r.get("dep_codigo"), null);
                    Long depId = depCodigo != null ? depByCodigo.get(depCodigo) : null;
                    if (depId == null) continue;
                    String codigo = Objects.toString(r.get("codigo"));
                    String nombre = Objects.toString(r.get("nombre"));
                    String flag = Objects.toString(r.get("flag_estado"), "1");
                    int upd = jdbcUpdate(conn,
                            "UPDATE core.provincia SET nombre = ?, flag_estado = ? "
                                    + "WHERE codigo = ? AND departamento_id = ? "
                                    + "AND (nombre IS DISTINCT FROM ? OR flag_estado IS DISTINCT FROM ?)",
                            nombre, flag, codigo, depId, nombre, flag);
                    if (upd > 0) {
                        affected++;
                    } else if (!existsRow(conn, "core.provincia",
                            "codigo = ? AND departamento_id = ?", codigo, depId)) {
                        jdbcUpdate(conn,
                                "INSERT INTO core.provincia (codigo, nombre, departamento_id, flag_estado) VALUES (?, ?, ?, ?)",
                                codigo, nombre, depId, flag);
                        affected++;
                    }
                }
                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error upsert core.provincia", ex);
        }
        return affected;
    }

    private int upsertCoreDistrito(HikariDataSource tenantDs, JdbcTemplate templateJdbc) {
        List<Map<String, Object>> rows = templateJdbc.queryForList("""
                SELECT di.codigo, di.nombre, di.flag_estado,
                       pr.codigo AS prov_codigo, d.codigo AS dep_codigo
                FROM core.distrito di
                LEFT JOIN core.provincia pr ON pr.id = di.provincia_id
                LEFT JOIN core.departamento d ON d.id = pr.departamento_id
                ORDER BY di.id
                """);
        if (rows.isEmpty()) return 0;
        // Resolver id de provincia por (dep_codigo, prov_codigo) en el tenant.
        JdbcTemplate tj = new JdbcTemplate(tenantDs);
        Map<String, Long> provByDepProv = tj.query("""
                SELECT pr.id, pr.codigo AS prov_codigo, d.codigo AS dep_codigo
                FROM core.provincia pr
                LEFT JOIN core.departamento d ON d.id = pr.departamento_id
                """, rs -> {
            Map<String, Long> out = new LinkedHashMap<>();
            while (rs.next()) {
                String k = rs.getString("dep_codigo") + "|" + rs.getString("prov_codigo");
                out.put(k, rs.getLong("id"));
            }
            return out;
        });
        int affected = 0;
        try (Connection conn = tenantDs.getConnection()) {
            conn.setAutoCommit(false);
            try {
                for (Map<String, Object> r : rows) {
                    String depCodigo = Objects.toString(r.get("dep_codigo"), null);
                    String provCodigo = Objects.toString(r.get("prov_codigo"), null);
                    if (depCodigo == null || provCodigo == null) continue;
                    Long provId = provByDepProv.get(depCodigo + "|" + provCodigo);
                    if (provId == null) continue;
                    String codigo = Objects.toString(r.get("codigo"));
                    String nombre = Objects.toString(r.get("nombre"));
                    String flag = Objects.toString(r.get("flag_estado"), "1");
                    int upd = jdbcUpdate(conn,
                            "UPDATE core.distrito SET nombre = ?, flag_estado = ? "
                                    + "WHERE codigo = ? AND provincia_id = ? "
                                    + "AND (nombre IS DISTINCT FROM ? OR flag_estado IS DISTINCT FROM ?)",
                            nombre, flag, codigo, provId, nombre, flag);
                    if (upd > 0) {
                        affected++;
                    } else if (!existsRow(conn, "core.distrito",
                            "codigo = ? AND provincia_id = ?", codigo, provId)) {
                        jdbcUpdate(conn,
                                "INSERT INTO core.distrito (codigo, nombre, provincia_id, flag_estado) VALUES (?, ?, ?, ?)",
                                codigo, nombre, provId, flag);
                        affected++;
                    }
                }
                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error upsert core.distrito", ex);
        }
        return affected;
    }

    /**
     * Template → tenant: usuarios de aplicación en {@code auth.usuario}.
     * Inserción: copia completa (incl. hash de password del template).
     * Actualización: no sobrescribe {@code password} ni {@code ultimo_login_en} del tenant.
     */
    private int upsertAuthUsuario(HikariDataSource tenantDs, JdbcTemplate templateJdbc) {
        List<Map<String, Object>> rows = templateJdbc.queryForList("SELECT * FROM auth.usuario ORDER BY id");
        if (rows.isEmpty()) {
            return 0;
        }
        int affected = 0;
        try (Connection conn = tenantDs.getConnection()) {
            conn.setAutoCommit(false);
            try {
                for (Map<String, Object> r : rows) {
                    long id = ((Number) Objects.requireNonNull(r.get("id"), "auth.usuario.id")).longValue();
                    if (!existsRow(conn, "auth.usuario", "id = ?", id)) {
                        jdbcUpdate(conn,
                                """
                                INSERT INTO auth.usuario (
                                    id, username, email, password, nombres, apellidos, nombre_completo,
                                    dos_factor_habilitado, bloqueado, ultimo_login_en, flag_estado,
                                    created_by, fec_creacion, updated_by, fec_modificacion
                                ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                                """,
                                id,
                                r.get("username"),
                                r.get("email"),
                                r.get("password"),
                                r.get("nombres"),
                                r.get("apellidos"),
                                r.get("nombre_completo"),
                                r.get("dos_factor_habilitado"),
                                r.get("bloqueado"),
                                r.get("ultimo_login_en"),
                                r.get("flag_estado"),
                                r.get("created_by"),
                                r.get("fec_creacion"),
                                r.get("updated_by"),
                                r.get("fec_modificacion"));
                        affected++;
                    } else {
                        int upd = jdbcUpdate(conn,
                                """
                                UPDATE auth.usuario SET
                                    username = ?, email = ?, nombres = ?, apellidos = ?, nombre_completo = ?,
                                    dos_factor_habilitado = ?, bloqueado = ?, flag_estado = ?,
                                    updated_by = ?, fec_modificacion = ?
                                WHERE id = ?
                                  AND (username IS DISTINCT FROM ? OR email IS DISTINCT FROM ? OR nombres IS DISTINCT FROM ?
                                       OR apellidos IS DISTINCT FROM ? OR nombre_completo IS DISTINCT FROM ?
                                       OR dos_factor_habilitado IS DISTINCT FROM ? OR bloqueado IS DISTINCT FROM ?
                                       OR flag_estado IS DISTINCT FROM ? OR updated_by IS DISTINCT FROM ?
                                       OR fec_modificacion IS DISTINCT FROM ?)
                                """,
                                r.get("username"),
                                r.get("email"),
                                r.get("nombres"),
                                r.get("apellidos"),
                                r.get("nombre_completo"),
                                r.get("dos_factor_habilitado"),
                                r.get("bloqueado"),
                                r.get("flag_estado"),
                                r.get("updated_by"),
                                r.get("fec_modificacion"),
                                id,
                                r.get("username"),
                                r.get("email"),
                                r.get("nombres"),
                                r.get("apellidos"),
                                r.get("nombre_completo"),
                                r.get("dos_factor_habilitado"),
                                r.get("bloqueado"),
                                r.get("flag_estado"),
                                r.get("updated_by"),
                                r.get("fec_modificacion"));
                        if (upd > 0) {
                            affected++;
                        }
                    }
                }
                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error upsert auth.usuario", ex);
        }
        return affected;
    }

    private int upsertAuthSucursal(HikariDataSource tenantDs, JdbcTemplate templateJdbc) {
        List<Map<String, Object>> rows = templateJdbc.queryForList("""
                SELECT s.codigo, s.nombre, s.direccion, s.ciudad, s.ubigeo, s.flag_estado,
                       pa.codigo AS pais_codigo,
                       d.codigo  AS dep_codigo,
                       pr.codigo AS prov_codigo,
                       di.codigo AS dist_codigo,
                       m.codigo  AS moneda_codigo
                FROM auth.sucursal s
                LEFT JOIN core.pais pa       ON pa.id = s.pais_id
                LEFT JOIN core.departamento d ON d.id = s.departamento_id
                LEFT JOIN core.provincia pr   ON pr.id = s.provincia_id
                LEFT JOIN core.distrito di    ON di.id = s.distrito_id
                LEFT JOIN core.moneda m       ON m.id = s.moneda_defult_id
                ORDER BY s.id
                """);
        if (rows.isEmpty()) return 0;
        Map<String, Long> paisByCod = loadIdByCodigo(tenantDs, "core.pais");
        Map<String, Long> monedaByCod = loadIdByCodigo(tenantDs, "core.moneda");
        Map<String, Long> depByCod = loadIdByCodigo(tenantDs, "core.departamento");
        JdbcTemplate tj = new JdbcTemplate(tenantDs);
        Map<String, Long> provByDepProv = tj.query("""
                SELECT pr.id, pr.codigo AS prov_codigo, d.codigo AS dep_codigo
                FROM core.provincia pr
                LEFT JOIN core.departamento d ON d.id = pr.departamento_id
                """, rs -> {
            Map<String, Long> out = new LinkedHashMap<>();
            while (rs.next()) {
                out.put(rs.getString("dep_codigo") + "|" + rs.getString("prov_codigo"), rs.getLong("id"));
            }
            return out;
        });
        Map<String, Long> distByProvDist = tj.query("""
                SELECT di.id, di.codigo AS dist_codigo, pr.codigo AS prov_codigo, d.codigo AS dep_codigo
                FROM core.distrito di
                LEFT JOIN core.provincia pr ON pr.id = di.provincia_id
                LEFT JOIN core.departamento d ON d.id = pr.departamento_id
                """, rs -> {
            Map<String, Long> out = new LinkedHashMap<>();
            while (rs.next()) {
                String k = rs.getString("dep_codigo") + "|" + rs.getString("prov_codigo")
                        + "|" + rs.getString("dist_codigo");
                out.put(k, rs.getLong("id"));
            }
            return out;
        });
        boolean sucursalTieneEmpresaId = tenantHasColumn(tenantDs, "auth", "sucursal", "empresa_id");
        Long empresaIdPorTenant = sucursalTieneEmpresaId ? resolveTenantEmpresaId(tenantDs) : null;
        boolean authTieneSucursalIdFk = tenantHasColumn(tenantDs, "auth", "sucursal", "sucursal_id");
        boolean coreSucursalExists = tenantHasTable(tenantDs, "core", "sucursal");
        boolean enlazarAuthACore = authTieneSucursalIdFk && coreSucursalExists;
        if (authTieneSucursalIdFk && !coreSucursalExists) {
            log.warn("auth.sucursal tiene columna sucursal_id pero no existe core.sucursal en el tenant; "
                    + "revisar DDL (FK esperada hacia core.sucursal).");
        }
        int affected = 0;
        try (Connection conn = tenantDs.getConnection()) {
            conn.setAutoCommit(false);
            try {
                for (Map<String, Object> r : rows) {
                    String codigo = Objects.toString(r.get("codigo"));
                    String nombre = Objects.toString(r.get("nombre"));
                    String direccion = Objects.toString(r.get("direccion"), null);
                    String ciudad = Objects.toString(r.get("ciudad"), null);
                    String ubigeo = Objects.toString(r.get("ubigeo"), null);
                    String flag = Objects.toString(r.get("flag_estado"), "1");
                    Long paisId = paisByCod.get(Objects.toString(r.get("pais_codigo"), null));
                    Long depId = depByCod.get(Objects.toString(r.get("dep_codigo"), null));
                    String depCod = Objects.toString(r.get("dep_codigo"), null);
                    String provCod = Objects.toString(r.get("prov_codigo"), null);
                    String distCod = Objects.toString(r.get("dist_codigo"), null);
                    Long provId = (depCod != null && provCod != null)
                            ? provByDepProv.get(depCod + "|" + provCod) : null;
                    Long distId = (depCod != null && provCod != null && distCod != null)
                            ? distByProvDist.get(depCod + "|" + provCod + "|" + distCod) : null;
                    Long monedaId = monedaByCod.get(Objects.toString(r.get("moneda_codigo"), null));

                    Long coreSucursalId = null;
                    if (enlazarAuthACore) {
                        coreSucursalId = upsertCoreSucursalReturningId(conn, codigo, nombre, direccion, ciudad,
                                ubigeo, flag, paisId, depId, provId, distId);
                        if (coreSucursalId == null) {
                            log.warn("Fase 5 auth.sucursal: no se pudo asegurar core.sucursal para codigo={}", codigo);
                        }
                    }

                    int upd;
                    if (enlazarAuthACore && coreSucursalId != null) {
                        upd = jdbcUpdate(conn,
                                """
                                UPDATE auth.sucursal
                                SET nombre = ?, direccion = ?, ciudad = ?, ubigeo = ?, flag_estado = ?,
                                    pais_id = ?, departamento_id = ?, provincia_id = ?, distrito_id = ?,
                                    moneda_defult_id = COALESCE(?, moneda_defult_id),
                                    sucursal_id = ?
                                WHERE codigo = ?
                                  AND (nombre IS DISTINCT FROM ?
                                    OR direccion IS DISTINCT FROM ?
                                    OR ciudad IS DISTINCT FROM ?
                                    OR ubigeo IS DISTINCT FROM ?
                                    OR flag_estado IS DISTINCT FROM ?
                                    OR pais_id IS DISTINCT FROM ?
                                    OR departamento_id IS DISTINCT FROM ?
                                    OR provincia_id IS DISTINCT FROM ?
                                    OR distrito_id IS DISTINCT FROM ?
                                    OR sucursal_id IS DISTINCT FROM ?)
                                """,
                                nombre, direccion, ciudad, ubigeo, flag,
                                paisId, depId, provId, distId, monedaId, coreSucursalId, codigo,
                                nombre, direccion, ciudad, ubigeo, flag,
                                paisId, depId, provId, distId, coreSucursalId);
                    } else {
                        upd = jdbcUpdate(conn,
                                """
                                UPDATE auth.sucursal
                                SET nombre = ?, direccion = ?, ciudad = ?, ubigeo = ?, flag_estado = ?,
                                    pais_id = ?, departamento_id = ?, provincia_id = ?, distrito_id = ?,
                                    moneda_defult_id = COALESCE(?, moneda_defult_id)
                                WHERE codigo = ?
                                  AND (nombre IS DISTINCT FROM ?
                                    OR direccion IS DISTINCT FROM ?
                                    OR ciudad IS DISTINCT FROM ?
                                    OR ubigeo IS DISTINCT FROM ?
                                    OR flag_estado IS DISTINCT FROM ?
                                    OR pais_id IS DISTINCT FROM ?
                                    OR departamento_id IS DISTINCT FROM ?
                                    OR provincia_id IS DISTINCT FROM ?
                                    OR distrito_id IS DISTINCT FROM ?)
                                """,
                                nombre, direccion, ciudad, ubigeo, flag,
                                paisId, depId, provId, distId, monedaId, codigo,
                                nombre, direccion, ciudad, ubigeo, flag,
                                paisId, depId, provId, distId);
                    }
                    if (upd > 0) {
                        affected++;
                    } else if (!existsRow(conn, "auth.sucursal", "codigo = ?", codigo)) {
                        if (enlazarAuthACore && coreSucursalId == null) {
                            continue;
                        }
                        if (sucursalTieneEmpresaId && empresaIdPorTenant != null) {
                            if (enlazarAuthACore) {
                                jdbcUpdate(conn,
                                        """
                                        INSERT INTO auth.sucursal
                                            (codigo, nombre, direccion, ciudad, ubigeo, flag_estado,
                                             pais_id, departamento_id, provincia_id, distrito_id, moneda_defult_id,
                                             empresa_id, sucursal_id)
                                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, COALESCE(?, core.fn_moneda_default_pen_id()), ?, ?)
                                        """,
                                        codigo, nombre, direccion, ciudad, ubigeo, flag,
                                        paisId, depId, provId, distId, monedaId, empresaIdPorTenant, coreSucursalId);
                            } else {
                                jdbcUpdate(conn,
                                        """
                                        INSERT INTO auth.sucursal
                                            (codigo, nombre, direccion, ciudad, ubigeo, flag_estado,
                                             pais_id, departamento_id, provincia_id, distrito_id, moneda_defult_id,
                                             empresa_id)
                                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, COALESCE(?, core.fn_moneda_default_pen_id()), ?)
                                        """,
                                        codigo, nombre, direccion, ciudad, ubigeo, flag,
                                        paisId, depId, provId, distId, monedaId, empresaIdPorTenant);
                            }
                        } else {
                            if (enlazarAuthACore) {
                                jdbcUpdate(conn,
                                        """
                                        INSERT INTO auth.sucursal
                                            (codigo, nombre, direccion, ciudad, ubigeo, flag_estado,
                                             pais_id, departamento_id, provincia_id, distrito_id, moneda_defult_id,
                                             sucursal_id)
                                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, COALESCE(?, core.fn_moneda_default_pen_id()), ?)
                                        """,
                                        codigo, nombre, direccion, ciudad, ubigeo, flag,
                                        paisId, depId, provId, distId, monedaId, coreSucursalId);
                            } else {
                                jdbcUpdate(conn,
                                        """
                                        INSERT INTO auth.sucursal
                                            (codigo, nombre, direccion, ciudad, ubigeo, flag_estado,
                                             pais_id, departamento_id, provincia_id, distrito_id, moneda_defult_id)
                                        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, COALESCE(?, core.fn_moneda_default_pen_id()))
                                        """,
                                        codigo, nombre, direccion, ciudad, ubigeo, flag,
                                        paisId, depId, provId, distId, monedaId);
                            }
                        }
                        affected++;
                    }
                }
                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error upsert auth.sucursal", ex);
        }
        return affected;
    }

    /**
     * ID de {@code master.empresa} para el tenant actual (BD con columna legacy {@code empresa_id} en
     * {@code auth.sucursal}). Sin esto el INSERT de Fase 5 viola NOT NULL en tenants no migrados al DDL nuevo.
     */
    private Long resolveTenantEmpresaId(HikariDataSource tenantDs) {
        JdbcTemplate j = new JdbcTemplate(tenantDs);
        try {
            return j.queryForObject(
                    "SELECT id FROM master.empresa WHERE db_name = current_database()::text ORDER BY id LIMIT 1",
                    Long.class);
        } catch (Exception ex) {
            log.debug("resolveTenantEmpresaId por db_name: {}", ex.getMessage());
        }
        try {
            Long id = j.queryForObject("SELECT MIN(id) FROM master.empresa", Long.class);
            if (id != null) {
                return id;
            }
        } catch (Exception ex) {
            log.warn("resolveTenantEmpresaId MIN(id): {}", ex.getMessage());
        }
        log.warn("resolveTenantEmpresaId: usando 1 como ultimo recurso (revisar master.empresa en el tenant)");
        return 1L;
    }

    /**
     * Corrige {@code sucursal_id} que no existe en la tabla referenciada por la FK del tenant
     * (p. ej. {@code auth.sucursal}), asignando el id correcto por codigo. Solo {@code UPDATE}
     * por PK; no se borran filas.
     */
    private void reconcileOrphanSucursalIdAlmacen(
            Connection conn, String fkParentQualified, String codigoAlmacen, Long sucId,
            String executionId, String tenantDb) throws SQLException {
        if (!isSafeQualifiedTableName(fkParentQualified)) {
            return;
        }
        List<Long> orphanIds = new ArrayList<>();
        String sql = "SELECT id FROM almacen.almacen WHERE codigo = ? AND sucursal_id IS NOT NULL "
                + "AND sucursal_id NOT IN (SELECT id FROM " + fkParentQualified + ")";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, codigoAlmacen);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    orphanIds.add(rs.getLong(1));
                }
            }
        }
        int fixed = 0;
        for (Long almacenPk : orphanIds) {
            try {
                int u = jdbcUpdate(conn,
                        "UPDATE almacen.almacen SET sucursal_id = ? WHERE id = ?", sucId, almacenPk);
                if (u > 0) {
                    fixed++;
                    if (executionId != null && tenantDb != null) {
                        log.info("[{}] {} almacen.almacen: sucursal_id huerfano corregido por codigo "
                                        + "almacen_pk={} almacen codigo='{}' -> sucursal_id={} (en {})",
                                executionId, tenantDb, almacenPk, codigoAlmacen, sucId, fkParentQualified);
                    }
                }
            } catch (SQLException ex) {
                if ("23505".equals(ex.getSQLState())) {
                    log.warn("reconcileOrphanSucursalIdAlmacen: codigo={} id={} no se pudo "
                            + "unificar sucursal_id={} (UNIQUE sucursal_id+codigo): {}",
                            codigoAlmacen, almacenPk, sucId, ex.getMessage());
                } else {
                    throw ex;
                }
            }
        }
        if (fixed > 0 && executionId != null && tenantDb != null) {
            log.info("[{}] {} almacen.almacen: total filas con sucursal_id corregido por codigo "
                            + "(almacen codigo='{}'): {}",
                    executionId, tenantDb, codigoAlmacen, fixed);
        }
    }

    /**
     * En template el codigo puede ser {@code EMPRESA-SUFIJO} (p. ej. E0000000-CH); en el tenant
     * {@code auth.sucursal.codigo} suele ser solo el sufijo (CH) porque la empresa ya es el propio tenant.
     */
    private record SucursalCodigoMatch(Long sucursalId) {
        static SucursalCodigoMatch vacio() {
            return new SucursalCodigoMatch(null);
        }
    }

    private static SucursalCodigoMatch lookupSucursalIdByCodigoMap(Map<String, Long> sucByCod, String templateCodigo) {
        if (templateCodigo == null || templateCodigo.isBlank()) {
            return SucursalCodigoMatch.vacio();
        }
        String t = templateCodigo.trim();
        Long id = findSucursalIdIgnoreCase(sucByCod, t);
        if (id != null) {
            return new SucursalCodigoMatch(id);
        }
        String sufijo = sucursalSufijoSinPrefijoEmpresa(t);
        if (sufijo != null && !sufijo.equalsIgnoreCase(t)) {
            id = findSucursalIdIgnoreCase(sucByCod, sufijo);
            if (id != null) {
                return new SucursalCodigoMatch(id);
            }
        }
        return SucursalCodigoMatch.vacio();
    }

    /** Parte tras el ultimo guion (ej. E0000000-CH -> CH). */
    private static String sucursalSufijoSinPrefijoEmpresa(String codigo) {
        int dash = codigo.lastIndexOf('-');
        if (dash >= 0 && dash < codigo.length() - 1) {
            return codigo.substring(dash + 1).trim();
        }
        return null;
    }

    private static Long findSucursalIdIgnoreCase(Map<String, Long> m, String key) {
        if (key == null) {
            return null;
        }
        Long id = m.get(key);
        if (id != null) {
            return id;
        }
        for (Map.Entry<String, Long> e : m.entrySet()) {
            if (e.getKey() != null && e.getKey().trim().equalsIgnoreCase(key.trim())) {
                return e.getValue();
            }
        }
        return null;
    }

    private void logAlmacenSucursalResolution(String executionId, String tenantDb, String fkParent,
            String almacenCodigo, String sucCodigoTemplate, SucursalCodigoMatch match) {
        if (sucCodigoTemplate == null) {
            log.warn("[{}] {} almacen.almacen: almacen codigo='{}' sin sucursal_codigo (JOIN template); "
                            + "no se usa id del template",
                    executionId, tenantDb, almacenCodigo);
            return;
        }
        if (match.sucursalId() != null) {
            return;
        }
        String suf = sucursalSufijoSinPrefijoEmpresa(sucCodigoTemplate.trim());
        log.warn("[{}] {} almacen.almacen: sucursal codigo template='{}' (sufijo '{}') NO existe en {}; "
                        + "almacen codigo='{}' omitido",
                executionId, tenantDb, sucCodigoTemplate, suf != null ? suf : "(n/a)", fkParent, almacenCodigo);
    }

    /**
     * Sincroniza {@code almacen.almacen}: {@code sucursal_id} por codigo natural en la tabla
     * que referencia la FK en el tenant (habitualmente {@code auth.sucursal}).
     */
    private int upsertAlmacenAlmacen(HikariDataSource tenantDs, JdbcTemplate templateJdbc,
            String executionId, String tenantDb) {
        List<Map<String, Object>> rows = queryTemplateAlmacenRows(templateJdbc);
        if (rows.isEmpty()) return 0;
        String fkSucursalParent = resolveAlmacenSucursalFkTarget(tenantDs);
        Map<String, Long> sucByCod = loadIdByCodigo(tenantDs, fkSucursalParent);
        Map<String, Long> almTipoByCod = loadIdByCodigo(tenantDs, "almacen.almacen_tipo");
        int affected = 0;
        int skippedSinSucursalCodigo = 0;
        int skippedSucursalNoEnTenant = 0;
        try (Connection conn = tenantDs.getConnection()) {
            conn.setAutoCommit(false);
            try {
                for (Map<String, Object> r : rows) {
                    String sucCodigo = Objects.toString(r.get("sucursal_codigo"), null);
                    if (sucCodigo != null) {
                        sucCodigo = sucCodigo.trim();
                        if (sucCodigo.isEmpty()) {
                            sucCodigo = null;
                        }
                    }
                    SucursalCodigoMatch sucMatch = lookupSucursalIdByCodigoMap(sucByCod, sucCodigo);
                    Long sucId = sucMatch.sucursalId();
                    String codigoAlmacen = Objects.toString(r.get("codigo"));
                    if (executionId != null && tenantDb != null) {
                        logAlmacenSucursalResolution(executionId, tenantDb, fkSucursalParent,
                                codigoAlmacen, sucCodigo, sucMatch);
                    }
                    if (sucCodigo == null) {
                        skippedSinSucursalCodigo++;
                        continue;
                    }
                    if (sucId == null) {
                        skippedSucursalNoEnTenant++;
                        continue;
                    }
                    reconcileOrphanSucursalIdAlmacen(conn, fkSucursalParent, codigoAlmacen, sucId, executionId, tenantDb);
                    String nombre = Objects.toString(r.get("nombre"));
                    String flag = Objects.toString(r.get("flag_estado"), "1");
                    String almTipoCodigo = Objects.toString(r.get("almacen_tipo_codigo"), null);
                    Long almTipoId = almTipoCodigo != null ? almTipoByCod.get(almTipoCodigo) : null;
                    int upd = jdbcUpdate(conn,
                            "UPDATE almacen.almacen SET nombre = ?, flag_estado = ?, "
                                    + "almacen_tipo_id = COALESCE(CAST(? AS BIGINT), almacen_tipo_id) "
                                    + "WHERE codigo = ? AND sucursal_id = ? "
                                    + "AND (nombre IS DISTINCT FROM ? OR flag_estado IS DISTINCT FROM ? "
                                    + "OR (CAST(? AS BIGINT) IS NOT NULL "
                                    + "AND almacen_tipo_id IS DISTINCT FROM CAST(? AS BIGINT)))",
                            nombre, flag, almTipoId, codigoAlmacen, sucId,
                            nombre, flag, almTipoId, almTipoId);
                    if (upd > 0) {
                        affected++;
                    } else if (!existsRow(conn, "almacen.almacen",
                            "codigo = ? AND sucursal_id = ?", codigoAlmacen, sucId)) {
                        jdbcUpdate(conn,
                                "INSERT INTO almacen.almacen (codigo, nombre, sucursal_id, almacen_tipo_id, flag_estado) "
                                        + "VALUES (?, ?, ?, CAST(? AS BIGINT), ?)",
                                codigoAlmacen, nombre, sucId, almTipoId, flag);
                        affected++;
                    }
                }
                if (executionId != null && tenantDb != null
                        && (skippedSinSucursalCodigo > 0 || skippedSucursalNoEnTenant > 0)) {
                    log.warn("[{}] {} almacen.almacen resumen: filas template={}, omitidas sin sucursal_codigo={}, "
                                    + "omitidas sucursal codigo inexistente en tenant={}",
                            executionId, tenantDb, rows.size(), skippedSinSucursalCodigo, skippedSucursalNoEnTenant);
                }
                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error upsert almacen.almacen", ex);
        }
        return affected;
    }

    private int jdbcUpdate(Connection conn, String sql, Object... params) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            return ps.executeUpdate();
        }
    }

    /**
     * Verifica si existe una fila que cumpla el {@code whereSql} con los {@code params}.
     */
    private boolean existsRow(Connection conn, String qualifiedTable, String whereSql, Object... params)
            throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "SELECT 1 FROM " + qualifiedTable + " WHERE " + whereSql + " LIMIT 1")) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            try (var rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Detecta si una columna existe en una tabla del tenant (por si el tenant
     * conserva columnas legacy que ya no están en el template).
     */
    private boolean tenantHasColumn(HikariDataSource tenantDs, String schema, String table, String column) {
        JdbcTemplate j = new JdbcTemplate(tenantDs);
        Integer cnt = j.queryForObject(
                "SELECT COUNT(*)::int FROM information_schema.columns "
                        + "WHERE table_schema = ? AND table_name = ? AND column_name = ?",
                Integer.class, schema, table, column);
        return cnt != null && cnt > 0;
    }

    private boolean tenantHasTable(HikariDataSource tenantDs, String schema, String table) {
        JdbcTemplate j = new JdbcTemplate(tenantDs);
        Integer cnt = j.queryForObject(
                "SELECT COUNT(*)::int FROM information_schema.tables "
                        + "WHERE table_schema = ? AND table_name = ?",
                Integer.class, schema, table);
        return cnt != null && cnt > 0;
    }

    /**
     * Asegura fila en {@code core.sucursal} por {@code codigo} y devuelve su id.
     * Necesario cuando {@code auth.sucursal.sucursal_id NOT NULL} referencia {@code core.sucursal(id)}.
     */
    private Long upsertCoreSucursalReturningId(Connection conn, String codigo, String nombre, String direccion,
            String ciudad, String ubigeo, String flag, Long paisId, Long depId, Long provId, Long distId)
            throws SQLException {
        String sql = """
                INSERT INTO core.sucursal (codigo, nombre, direccion, ciudad, pais_id, departamento_id, provincia_id, distrito_id, ubigeo, flag_estado)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                ON CONFLICT (codigo) DO UPDATE SET
                  nombre = EXCLUDED.nombre,
                  direccion = EXCLUDED.direccion,
                  ciudad = EXCLUDED.ciudad,
                  pais_id = EXCLUDED.pais_id,
                  departamento_id = EXCLUDED.departamento_id,
                  provincia_id = EXCLUDED.provincia_id,
                  distrito_id = EXCLUDED.distrito_id,
                  ubigeo = EXCLUDED.ubigeo,
                  flag_estado = EXCLUDED.flag_estado
                RETURNING id
                """;
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, codigo);
            ps.setString(2, nombre);
            ps.setString(3, direccion);
            ps.setString(4, ciudad);
            ps.setObject(5, paisId);
            ps.setObject(6, depId);
            ps.setObject(7, provId);
            ps.setObject(8, distId);
            ps.setString(9, ubigeo);
            ps.setString(10, flag);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        return null;
    }

    /**
     * Upsert {@code almacen.almacen_tipo_mov}: resuelve FKs por codigo y si el tenant
     * tiene la columna legacy {@code tipo_mov} (VARCHAR NOT NULL) la popula con el
     * {@code tipo_mov} del {@code almacen.articulo_mov_tipo} para no violar NOT NULL.
     */
    private int upsertAlmacenAlmacenTipoMov(HikariDataSource tenantDs, JdbcTemplate templateJdbc) {
        List<Map<String, Object>> rows = templateJdbc.queryForList("""
                SELECT m.flag_estado,
                       a.codigo  AS almacen_codigo,
                       s.codigo  AS sucursal_codigo,
                       at.tipo_mov AS mov_codigo
                FROM almacen.almacen_tipo_mov m
                LEFT JOIN almacen.almacen a         ON a.id = m.almacen_id
                LEFT JOIN auth.sucursal s            ON s.id = a.sucursal_id
                LEFT JOIN almacen.articulo_mov_tipo at ON at.id = m.articulo_mov_tipo_id
                ORDER BY m.id
                """);
        if (rows.isEmpty()) return 0;
        JdbcTemplate tj = new JdbcTemplate(tenantDs);
        Map<String, Long> almByClave = tj.query("""
                SELECT a.id, a.codigo AS alm_codigo, s.codigo AS suc_codigo
                FROM almacen.almacen a
                LEFT JOIN auth.sucursal s ON s.id = a.sucursal_id
                """, rs -> {
            Map<String, Long> out = new LinkedHashMap<>();
            while (rs.next()) {
                out.put(rs.getString("suc_codigo") + "|" + rs.getString("alm_codigo"), rs.getLong("id"));
            }
            return out;
        });
        Map<String, Long> movByTipo = tj.query(
                "SELECT id, tipo_mov FROM almacen.articulo_mov_tipo WHERE tipo_mov IS NOT NULL",
                rs -> {
                    Map<String, Long> out = new LinkedHashMap<>();
                    while (rs.next()) out.put(rs.getString("tipo_mov"), rs.getLong("id"));
                    return out;
                });
        boolean hasLegacyTipoMov = tenantHasColumn(tenantDs, "almacen", "almacen_tipo_mov", "tipo_mov");
        int affected = 0;
        try (Connection conn = tenantDs.getConnection()) {
            conn.setAutoCommit(false);
            try {
                for (Map<String, Object> r : rows) {
                    String almCod = Objects.toString(r.get("almacen_codigo"), null);
                    String sucCod = Objects.toString(r.get("sucursal_codigo"), null);
                    String movCod = Objects.toString(r.get("mov_codigo"), null);
                    if (almCod == null || sucCod == null || movCod == null) continue;
                    Long almId = almByClave.get(sucCod + "|" + almCod);
                    Long movId = movByTipo.get(movCod);
                    if (almId == null || movId == null) continue;
                    String flag = Objects.toString(r.get("flag_estado"), "1");

                    int upd;
                    if (hasLegacyTipoMov) {
                        upd = jdbcUpdate(conn,
                                "UPDATE almacen.almacen_tipo_mov SET flag_estado = ?, tipo_mov = ? "
                                        + "WHERE almacen_id = ? AND articulo_mov_tipo_id = ? "
                                        + "AND (flag_estado IS DISTINCT FROM ? OR tipo_mov IS DISTINCT FROM ?)",
                                flag, movCod, almId, movId, flag, movCod);
                        if (upd > 0) {
                            affected++;
                        } else if (!existsRow(conn, "almacen.almacen_tipo_mov",
                                "almacen_id = ? AND articulo_mov_tipo_id = ?", almId, movId)) {
                            jdbcUpdate(conn,
                                    "INSERT INTO almacen.almacen_tipo_mov (almacen_id, articulo_mov_tipo_id, flag_estado, tipo_mov) "
                                            + "VALUES (?, ?, ?, ?)",
                                    almId, movId, flag, movCod);
                            affected++;
                        }
                    } else {
                        upd = jdbcUpdate(conn,
                                "UPDATE almacen.almacen_tipo_mov SET flag_estado = ? "
                                        + "WHERE almacen_id = ? AND articulo_mov_tipo_id = ? "
                                        + "AND flag_estado IS DISTINCT FROM ?",
                                flag, almId, movId, flag);
                        if (upd > 0) {
                            affected++;
                        } else if (!existsRow(conn, "almacen.almacen_tipo_mov",
                                "almacen_id = ? AND articulo_mov_tipo_id = ?", almId, movId)) {
                            jdbcUpdate(conn,
                                    "INSERT INTO almacen.almacen_tipo_mov (almacen_id, articulo_mov_tipo_id, flag_estado) "
                                            + "VALUES (?, ?, ?)",
                                    almId, movId, flag);
                            affected++;
                        }
                    }
                }
                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error upsert almacen.almacen_tipo_mov", ex);
        }
        return affected;
    }

    /**
     * Upsert {@code contabilidad.tipo_mov_matriz_subcat}: resuelve {@code matriz_cntbl_finan_id}
     * por codigo y si el tenant conserva la columna legacy {@code matriz} la popula con el
     * codigo de {@code matriz_cntbl_finan} para no violar NOT NULL.
     */
    private int upsertContabilidadTipoMovMatrizSubcat(HikariDataSource tenantDs, JdbcTemplate templateJdbc) {
        List<Map<String, Object>> rows = templateJdbc.queryForList("""
                SELECT tmms.tipo_mov, tmms.grp_cntbl, tmms.cod_sub_cat, tmms.item,
                       mcf.codigo AS matriz_codigo
                FROM contabilidad.tipo_mov_matriz_subcat tmms
                LEFT JOIN contabilidad.matriz_cntbl_finan mcf ON mcf.id = tmms.matriz_cntbl_finan_id
                ORDER BY tmms.tipo_mov, tmms.grp_cntbl, tmms.cod_sub_cat, tmms.item
                """);
        if (rows.isEmpty()) return 0;
        JdbcTemplate tj = new JdbcTemplate(tenantDs);
        Map<String, Long> matrizByCod = tj.query(
                "SELECT id, codigo FROM contabilidad.matriz_cntbl_finan WHERE codigo IS NOT NULL",
                rs -> {
                    Map<String, Long> out = new LinkedHashMap<>();
                    while (rs.next()) out.put(rs.getString("codigo"), rs.getLong("id"));
                    return out;
                });
        boolean hasLegacyMatriz = tenantHasColumn(tenantDs, "contabilidad", "tipo_mov_matriz_subcat", "matriz");
        int affected = 0;
        try (Connection conn = tenantDs.getConnection()) {
            conn.setAutoCommit(false);
            try {
                for (Map<String, Object> r : rows) {
                    String tipoMov = Objects.toString(r.get("tipo_mov"), null);
                    String grpCntbl = Objects.toString(r.get("grp_cntbl"), null);
                    String codSubCat = Objects.toString(r.get("cod_sub_cat"), null);
                    Object itemObj = r.get("item");
                    String matrizCod = Objects.toString(r.get("matriz_codigo"), null);
                    if (tipoMov == null || grpCntbl == null || codSubCat == null
                            || itemObj == null || matrizCod == null) {
                        continue;
                    }
                    Long matrizId = matrizByCod.get(matrizCod);
                    if (matrizId == null) continue;

                    int upd;
                    String pkWhere = "tipo_mov = ? AND grp_cntbl = ? AND cod_sub_cat = ? AND item = ?";
                    if (hasLegacyMatriz) {
                        upd = jdbcUpdate(conn,
                                """
                                UPDATE contabilidad.tipo_mov_matriz_subcat
                                SET matriz_cntbl_finan_id = ?, matriz = ?
                                WHERE tipo_mov = ? AND grp_cntbl = ? AND cod_sub_cat = ? AND item = ?
                                  AND (matriz_cntbl_finan_id IS DISTINCT FROM ?
                                    OR matriz IS DISTINCT FROM ?)
                                """,
                                matrizId, matrizCod,
                                tipoMov, grpCntbl, codSubCat, itemObj,
                                matrizId, matrizCod);
                        if (upd > 0) {
                            affected++;
                        } else if (!existsRow(conn, "contabilidad.tipo_mov_matriz_subcat",
                                pkWhere, tipoMov, grpCntbl, codSubCat, itemObj)) {
                            jdbcUpdate(conn,
                                    """
                                    INSERT INTO contabilidad.tipo_mov_matriz_subcat
                                    (tipo_mov, grp_cntbl, cod_sub_cat, item, matriz_cntbl_finan_id, matriz)
                                    VALUES (?, ?, ?, ?, ?, ?)
                                    """,
                                    tipoMov, grpCntbl, codSubCat, itemObj, matrizId, matrizCod);
                            affected++;
                        }
                    } else {
                        upd = jdbcUpdate(conn,
                                """
                                UPDATE contabilidad.tipo_mov_matriz_subcat
                                SET matriz_cntbl_finan_id = ?
                                WHERE tipo_mov = ? AND grp_cntbl = ? AND cod_sub_cat = ? AND item = ?
                                  AND matriz_cntbl_finan_id IS DISTINCT FROM ?
                                """,
                                matrizId,
                                tipoMov, grpCntbl, codSubCat, itemObj,
                                matrizId);
                        if (upd > 0) {
                            affected++;
                        } else if (!existsRow(conn, "contabilidad.tipo_mov_matriz_subcat",
                                pkWhere, tipoMov, grpCntbl, codSubCat, itemObj)) {
                            jdbcUpdate(conn,
                                    """
                                    INSERT INTO contabilidad.tipo_mov_matriz_subcat
                                    (tipo_mov, grp_cntbl, cod_sub_cat, item, matriz_cntbl_finan_id)
                                    VALUES (?, ?, ?, ?, ?)
                                    """,
                                    tipoMov, grpCntbl, codSubCat, itemObj, matrizId);
                            affected++;
                        }
                    }
                }
                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error upsert contabilidad.tipo_mov_matriz_subcat", ex);
        }
        return affected;
    }

    private int upsertTipoCambioByCodigoMoneda(HikariDataSource tenantDs, JdbcTemplate templateJdbc) {
        List<Map<String, Object>> sourceRows = templateJdbc.queryForList("""
                SELECT tc.fecha,
                       tc.compra,
                       tc.venta,
                       m.codigo AS moneda_codigo
                FROM core.tipo_cambio tc
                JOIN core.moneda m ON m.id = tc.moneda_id
                ORDER BY tc.fecha, m.codigo
                """);
        if (sourceRows.isEmpty()) {
            return 0;
        }

        Map<String, Long> tenantMonedaByCodigo = loadTenantMonedaByCodigo(tenantDs);
        // WHERE: solo cuenta filas afectadas si los valores difieren (evita spam de correos / "changed" en cada cron)
        String upsertSql = """
                INSERT INTO core.tipo_cambio (moneda_id, fecha, compra, venta)
                VALUES (?, ?, ?, ?)
                ON CONFLICT (moneda_id, fecha)
                DO UPDATE
                   SET compra = EXCLUDED.compra,
                       venta = EXCLUDED.venta
                WHERE core.tipo_cambio.compra IS DISTINCT FROM EXCLUDED.compra
                   OR core.tipo_cambio.venta IS DISTINCT FROM EXCLUDED.venta
                """;

        int affected = 0;
        try (Connection conn = tenantDs.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement pstmt = conn.prepareStatement(upsertSql)) {
                for (Map<String, Object> row : sourceRows) {
                    String monedaCodigo = Objects.toString(row.get("moneda_codigo"), null);
                    Long tenantMonedaId = monedaCodigo == null ? null : tenantMonedaByCodigo.get(monedaCodigo);
                    if (tenantMonedaId == null) {
                        log.warn("Fase 5: omitiendo core.tipo_cambio porque no existe moneda '{}' en tenant", monedaCodigo);
                        continue;
                    }
                    pstmt.setLong(1, tenantMonedaId);
                    pstmt.setObject(2, row.get("fecha"));
                    pstmt.setObject(3, row.get("compra"));
                    pstmt.setObject(4, row.get("venta"));
                    pstmt.addBatch();
                }
                int[] results = pstmt.executeBatch();
                for (int r : results) {
                    if (r > 0) {
                        affected++;
                    }
                }
                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                throw ex;
            }
        } catch (SQLException ex) {
            throw new RuntimeException("Error upsert en core.tipo_cambio", ex);
        }
        return affected;
    }

    private Map<String, Long> loadTenantMonedaByCodigo(HikariDataSource tenantDs) {
        JdbcTemplate tenantJdbc = new JdbcTemplate(tenantDs);
        return tenantJdbc.query("SELECT id, codigo FROM core.moneda", rs -> {
            Map<String, Long> out = new LinkedHashMap<>();
            while (rs.next()) {
                String codigo = rs.getString("codigo");
                long id = rs.getLong("id");
                if (codigo != null) {
                    out.put(codigo, id);
                }
            }
            return out;
        });
    }

    private void persistDataSyncLog(String executionId, TenantConnectionInfo tenant,
                                     String tableName, int rowCount, String error) {
        try {
            SchemaSyncCronLog logEntry = new SchemaSyncCronLog();
            logEntry.setExecutionId(executionId);
            logEntry.setStatus(error == null ? STATUS_TERMINADO : STATUS_FALLIDO);
            logEntry.setDryRun(false);
            logEntry.setTenantDbName(tenant.dbName());
            logEntry.setNombreEmpresa(tenant.nombreEmpresa());
            logEntry.setFase(FASE_5);
            logEntry.setSchemaObject(truncate(tableName, MAX_SCHEMA_OBJECT_LENGTH));
            logEntry.setObjectType("DATO");
            logEntry.setObjectsSummary(rowCount + " registros");
            logEntry.setFailed(error != null);
            logEntry.setChanged(rowCount > 0);
            logEntry.setDurationMs(0L);
            if (error != null) {
                logEntry.setErrorDetail(error);
            }
            cronLogRepository.save(logEntry);
        } catch (Exception ex) {
            log.warn("No se pudo persistir log Fase 5 para {}: {}", tableName, ex.getMessage());
        }
    }
}
