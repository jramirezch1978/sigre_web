package com.sigre.almacen.controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.sigre.common.dto.ApiResponse;

import java.util.ArrayList;
import java.util.List;

/**
 * Endpoint de administración para aplicar migraciones de schema que no se
 * pueden incluir en el DDL inicial (schema drift).
 * Todas las sentencias usan IF NOT EXISTS / IF EXISTS para ser idempotentes:
 * se puede ejecutar múltiples veces sin efectos secundarios.
 */
@Slf4j
@RestController
@RequestMapping("/api/almacen/admin")
public class AdminMigrationController {

    @PersistenceContext
    private EntityManager em;

    @PostMapping("/migrate")
    @Transactional
    public ApiResponse<List<String>> migrate() {
        List<String> aplicadas = new ArrayList<>();

        // v1 — vale_mov_orig_id: referencia al vale de origen en devoluciones
        runDdl("ALTER TABLE almacen.vale_mov ADD COLUMN IF NOT EXISTS vale_mov_orig_id BIGINT",
                aplicadas, "vale_mov.vale_mov_orig_id");
        runDdl("CREATE INDEX IF NOT EXISTS ix_vale_mov_orig ON almacen.vale_mov (vale_mov_orig_id)",
                aplicadas, "ix_vale_mov_orig");

        // v2 — almacen.ano_apertura: año de apertura del almacen
        runDdl("ALTER TABLE almacen.almacen ADD COLUMN IF NOT EXISTS ano_apertura INTEGER",
                aplicadas, "almacen.ano_apertura");

        log.info("[AdminMigration] {} sentencias aplicadas: {}", aplicadas.size(), aplicadas);
        return ApiResponse.ok(aplicadas, aplicadas.size() + " migración(es) aplicada(s)");
    }

    private void runDdl(String sql, List<String> aplicadas, String descripcion) {
        try {
            em.createNativeQuery(sql).executeUpdate();
            aplicadas.add("OK: " + descripcion);
            log.info("[AdminMigration] {}: OK", descripcion);
        } catch (Exception ex) {
            aplicadas.add("SKIP: " + descripcion + " (" + ex.getMessage() + ")");
            log.warn("[AdminMigration] {}: {}", descripcion, ex.getMessage());
        }
    }
}
