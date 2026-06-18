package com.sigre.sync.worker.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.sync.worker.dto.SchemaSyncRequest;
import com.sigre.sync.worker.dto.SchemaSyncResponse;
import com.sigre.sync.worker.entity.SchemaSyncCronLog;
import com.sigre.sync.worker.repository.SchemaSyncCronLogRepository;
import com.sigre.sync.worker.service.SchemaSyncService;

import java.util.List;

@RestController
@RequestMapping({"/api/sync/worker/schema-sync", "/api/worker/schema-sync"})
@RequiredArgsConstructor
public class SchemaSyncController {

    private final SchemaSyncService schemaSyncService;
    private final SchemaSyncCronLogRepository cronLogRepository;

    @PostMapping("/executions")
    public ApiResponse<SchemaSyncResponse> execute(
            @RequestHeader(value = "X-Admin-Secret", required = false) String adminSecret,
            HttpServletRequest request,
            @Valid @RequestBody(required = false) SchemaSyncRequest body
    ) {
        if (!schemaSyncService.isAdminSecretValid(adminSecret)) {
            throw new BusinessException(
                    "Cabecera X-Admin-Secret invalida",
                    HttpStatus.FORBIDDEN,
                    "SCHEMA_SYNC_UNAUTHORIZED");
        }
        SchemaSyncRequest payload = body != null ? body : new SchemaSyncRequest();

        if (payload.isAllowDestructive() && !schemaSyncService.isDestructiveConfirmed(payload)) {
            throw new BusinessException(
                    "allowDestructive=true requiere destructiveConfirmationToken valido (doble confirmacion)",
                    HttpStatus.BAD_REQUEST,
                    "SCHEMA_SYNC_DESTRUCTIVE_NOT_CONFIRMED");
        }

        SchemaSyncResponse response = schemaSyncService.execute(payload, request.getRemoteAddr());
        return ApiResponse.ok(response, payload.isDryRun() ? "Dry-run ejecutado" : "Sincronizacion ejecutada");
    }

    @GetMapping("/executions/{executionId}")
    public ApiResponse<List<SchemaSyncCronLog>> getExecution(
            @RequestHeader(value = "X-Admin-Secret", required = false) String adminSecret,
            @PathVariable String executionId
    ) {
        if (!schemaSyncService.isAdminSecretValid(adminSecret)) {
            throw new BusinessException(
                    "Cabecera X-Admin-Secret invalida",
                    HttpStatus.FORBIDDEN,
                    "SCHEMA_SYNC_UNAUTHORIZED");
        }
        List<SchemaSyncCronLog> logs = cronLogRepository.findByExecutionId(executionId);
        if (logs.isEmpty()) {
            throw new BusinessException(
                    "Ejecucion no encontrada: " + executionId,
                    HttpStatus.NOT_FOUND,
                    "SCHEMA_SYNC_EXECUTION_NOT_FOUND");
        }
        return ApiResponse.ok(logs, "Ejecucion encontrada");
    }
}
