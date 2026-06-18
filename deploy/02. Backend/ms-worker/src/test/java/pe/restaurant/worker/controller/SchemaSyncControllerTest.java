package pe.restaurant.worker.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.context.annotation.Import;
import org.springframework.http.MediaType;
import org.springframework.test.context.bean.override.mockito.MockitoBean;
import org.springframework.test.web.servlet.MockMvc;
import pe.restaurant.common.exception.GlobalExceptionHandler;
import pe.restaurant.worker.config.WorkerSecurityConfig;
import pe.restaurant.common.security.JwtTokenProvider;
import pe.restaurant.worker.dto.SchemaSyncRequest;
import pe.restaurant.worker.dto.SchemaSyncResponse;
import pe.restaurant.worker.dto.TenantSchemaSyncResult;
import pe.restaurant.worker.repository.SchemaSyncCronLogRepository;
import pe.restaurant.worker.service.SchemaSyncService;

import java.time.OffsetDateTime;
import java.util.List;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

@WebMvcTest(SchemaSyncController.class)
@Import({WorkerSecurityConfig.class, GlobalExceptionHandler.class})
class SchemaSyncControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private ObjectMapper objectMapper;

    @MockitoBean
    private SchemaSyncService schemaSyncService;

    @MockitoBean
    private SchemaSyncCronLogRepository cronLogRepository;

    @MockitoBean
    private JwtTokenProvider jwtTokenProvider;

    @Test
    @DisplayName("CA-06: Sin X-Admin-Secret retorna 403")
    void missingAdminSecretReturns403() throws Exception {
        when(schemaSyncService.isAdminSecretValid(any())).thenReturn(false);

        mockMvc.perform(post("/api/worker/schema-sync/executions")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("CA-06: X-Admin-Secret invalido retorna 403")
    void invalidAdminSecretReturns403() throws Exception {
        when(schemaSyncService.isAdminSecretValid("wrong")).thenReturn(false);

        mockMvc.perform(post("/api/worker/schema-sync/executions")
                        .header("X-Admin-Secret", "wrong")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isForbidden());
    }

    @Test
    @DisplayName("CA-03: Dry-run ejecutado retorna respuesta con dryRun=true")
    void dryRunExecution() throws Exception {
        when(schemaSyncService.isAdminSecretValid("valid")).thenReturn(true);
        when(schemaSyncService.isDestructiveConfirmed(any())).thenReturn(true);
        when(schemaSyncService.execute(any(), anyString())).thenReturn(buildMockResponse(true));

        SchemaSyncRequest request = new SchemaSyncRequest();
        request.setDryRun(true);

        mockMvc.perform(post("/api/worker/schema-sync/executions")
                        .header("X-Admin-Secret", "valid")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.dryRun").value(true))
                .andExpect(jsonPath("$.data.executionId").exists());
    }

    @Test
    @DisplayName("allowDestructive sin token retorna 400")
    void destructiveWithoutConfirmation() throws Exception {
        when(schemaSyncService.isAdminSecretValid("valid")).thenReturn(true);
        when(schemaSyncService.isDestructiveConfirmed(any())).thenReturn(false);

        SchemaSyncRequest request = new SchemaSyncRequest();
        request.setDryRun(false);
        request.setAllowDestructive(true);

        mockMvc.perform(post("/api/worker/schema-sync/executions")
                        .header("X-Admin-Secret", "valid")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isBadRequest());
    }

    @Test
    @DisplayName("Apply mode retorna respuesta con dryRun=false")
    void applyExecution() throws Exception {
        when(schemaSyncService.isAdminSecretValid("valid")).thenReturn(true);
        when(schemaSyncService.isDestructiveConfirmed(any())).thenReturn(true);
        when(schemaSyncService.execute(any(), anyString())).thenReturn(buildMockResponse(false));

        SchemaSyncRequest request = new SchemaSyncRequest();
        request.setDryRun(false);

        mockMvc.perform(post("/api/worker/schema-sync/executions")
                        .header("X-Admin-Secret", "valid")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(request)))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.data.dryRun").value(false));
    }

    private SchemaSyncResponse buildMockResponse(boolean dryRun) {
        return SchemaSyncResponse.builder()
                .executionId("test-exec-001")
                .templateDatabase("restaurant_pe_template")
                .dryRun(dryRun)
                .allowDestructive(false)
                .failFast(false)
                .requestedBy("127.0.0.1")
                .startedAt(OffsetDateTime.now())
                .finishedAt(OffsetDateTime.now())
                .summary(SchemaSyncResponse.Summary.builder()
                        .totalTenants(1)
                        .okTenants(1)
                        .failedTenants(0)
                        .noChangeTenants(0)
                        .changedTenants(1)
                        .plannedStatements(2)
                        .appliedStatements(dryRun ? 0 : 2)
                        .build())
                .tenants(List.of(TenantSchemaSyncResult.builder()
                        .tenantDbName("restaurant_pe_emp_acme")
                        .nombreEmpresa("ACME Corp")
                        .success(true)
                        .changed(true)
                        .dryRun(dryRun)
                        .durationMs(150)
                        .plannedStatements(2)
                        .appliedStatements(dryRun ? 0 : 2)
                        .statements(List.of("CREATE TABLE ...", "ADD COLUMN ..."))
                        .warnings(List.of())
                        .build()))
                .build();
    }
}
