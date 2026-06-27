package com.sigre.seguridad.controller;

import com.sigre.common.dto.ApiResponse;
import com.sigre.seguridad.service.NotificacionService;
import com.sigre.seguridad.support.SeguridadContextHelper;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Notificaciones del usuario para el dashboard: conteo de no leídas (badge) y listado completo
 * (al abrir el panel). El usuario y la empresa se resuelven del token.
 */
@RestController
@RequestMapping("/api/auth/seguridad/notificaciones")
@RequiredArgsConstructor
public class NotificacionController {

    private final SeguridadContextHelper contextHelper;
    private final NotificacionService notificacionService;

    /** Resumen para el dashboard: cantidad no leída + listado completo (con tipo para el icono). */
    @GetMapping
    public ApiResponse<Map<String, Object>> resumen(@RequestHeader("Authorization") String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long empresaId = contextHelper.requireEmpresaIdFromToken(auth);
        List<Map<String, Object>> items = notificacionService.listar(uid, empresaId);
        Map<String, Object> r = new LinkedHashMap<>();
        r.put("noLeidas", notificacionService.contarNoLeidas(uid, empresaId));
        r.put("items", items);
        return ApiResponse.ok(r, "Notificaciones");
    }

    @PostMapping("/{id}/leer")
    public ApiResponse<Void> marcarLeida(@RequestHeader("Authorization") String auth, @PathVariable long id) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long empresaId = contextHelper.requireEmpresaIdFromToken(auth);
        notificacionService.marcarLeida(uid, empresaId, id);
        return ApiResponse.ok(null, "Notificación marcada como leída");
    }

    @PostMapping("/leer-todas")
    public ApiResponse<Map<String, Object>> marcarTodasLeidas(@RequestHeader("Authorization") String auth) {
        long uid = contextHelper.requireUserIdDefinitivo(auth);
        long empresaId = contextHelper.requireEmpresaIdFromToken(auth);
        int n = notificacionService.marcarTodasLeidas(uid, empresaId);
        Map<String, Object> r = new LinkedHashMap<>();
        r.put("marcadas", n);
        return ApiResponse.ok(r, "Notificaciones marcadas como leídas");
    }
}
