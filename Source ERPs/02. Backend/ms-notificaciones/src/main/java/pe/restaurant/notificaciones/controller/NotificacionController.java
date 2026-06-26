package pe.restaurant.notificaciones.controller;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import pe.restaurant.common.dto.ApiResponse;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.DefinitiveTokenClaims;
import pe.restaurant.notificaciones.dto.MarcarNotificacionLeidaRequestDto;
import pe.restaurant.notificaciones.dto.NotificacionDto;
import pe.restaurant.notificaciones.service.NotificacionService;

import java.util.List;

@RestController
@RequestMapping("/api/notificaciones")
@RequiredArgsConstructor
public class NotificacionController {

    private final NotificacionService notificacionService;

    @GetMapping
    public ApiResponse<List<NotificacionDto>> listar(Authentication authentication) {
        DefinitiveTokenClaims claims = extractClaims(authentication);
        List<NotificacionDto> data = notificacionService.listarPorUsuarioYEmpresa(
                claims.getUserId(), claims.getEmpresaId());
        return ApiResponse.ok(data, "Notificaciones del usuario");
    }

    @PostMapping("/leer")
    public ApiResponse<Boolean> marcarComoLeida(
            @RequestBody MarcarNotificacionLeidaRequestDto request,
            Authentication authentication) {
        if (request == null || request.getNotificacionId() == null || request.getNotificacionId() <= 0) {
            throw new BusinessException("El id de notificación es requerido",
                    HttpStatus.BAD_REQUEST, "NOTIFICACION_ID_REQUERIDO");
        }
        DefinitiveTokenClaims claims = extractClaims(authentication);
        boolean updated = notificacionService.marcarComoLeida(
                request.getNotificacionId(), claims.getUserId(), claims.getEmpresaId());
        return ApiResponse.ok(updated, updated ? "Notificación marcada como leída" : "Notificación ya estaba leída");
    }

    private static DefinitiveTokenClaims extractClaims(Authentication authentication) {
        if (authentication == null || !(authentication.getDetails() instanceof DefinitiveTokenClaims claims)) {
            throw new BusinessException("No autenticado", HttpStatus.UNAUTHORIZED, "NO_AUTENTICADO");
        }
        return claims;
    }
}
