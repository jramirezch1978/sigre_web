package pe.restaurant.almacen.controller;

import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import lombok.extern.slf4j.Slf4j;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.restaurant.common.dto.ApiResponse;

@Slf4j
@RestController
@RequestMapping("/api/almacen/admin")
public class AdminMigrationController {

    @PersistenceContext
    private EntityManager em;

    @PostMapping("/migrate")
    @Transactional
    public ApiResponse<String> migrate() {
        em.createNativeQuery(
                "ALTER TABLE almacen.vale_mov ADD COLUMN IF NOT EXISTS vale_mov_orig_id BIGINT"
        ).executeUpdate();

        em.createNativeQuery(
                "CREATE INDEX IF NOT EXISTS ix_vale_mov_orig ON almacen.vale_mov (vale_mov_orig_id)"
        ).executeUpdate();

        log.info("Migración vale_mov_orig_id aplicada.");
        return ApiResponse.ok("Migración completada");
    }

}
