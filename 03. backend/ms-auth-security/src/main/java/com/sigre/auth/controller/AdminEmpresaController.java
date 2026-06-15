package com.sigre.auth.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import com.sigre.auth.dto.ActualizarCredencialesBdRequest;
import com.sigre.auth.dto.ActualizarCredencialesBdResponse;
import com.sigre.auth.dto.DeleteEmpresaResponse;
import com.sigre.auth.dto.DeleteEmpresaRequest;
import com.sigre.auth.dto.EmpresaLogoUploadResponse;
import com.sigre.auth.dto.ProvisionEmpresaRequest;
import com.sigre.auth.dto.ProvisionEmpresaResponse;
import com.sigre.auth.dto.RecreateEmpresaRequest;
import com.sigre.auth.dto.RecreateEmpresaResponse;
import com.sigre.auth.service.TenantProvisioningService;
import com.sigre.auth.dto.UsuarioEmpresaSyncResponse;
import com.sigre.auth.service.LogAccesoService;
import com.sigre.auth.service.TokensSessionService;
import com.sigre.auth.service.UsuarioEmpresaAdminService;
import com.sigre.common.dto.ApiResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.JwtTokenProvider;

import javax.crypto.SecretKey;

/**
 * Administración de empresas: provisioning y de-provisioning de tenants.
 */
@RestController
@RequestMapping("/api/admin/empresas")
@RequiredArgsConstructor
public class AdminEmpresaController {

    private static final Logger log = LoggerFactory.getLogger(AdminEmpresaController.class);

    private final TenantProvisioningService tenantProvisioningService;
    private final UsuarioEmpresaAdminService usuarioEmpresaAdminService;
    private final TokensSessionService tokensSessionService;
    private final JwtTokenProvider jwtTokenProvider;
    private final LogAccesoService logAccesoService;

    @Value("${app.provisioning.secret:}")
    private String provisionSecret;

    @Value("${app.jwt.secret}")
    private String jwtSecretBase64;

    @PostMapping("/provision")
    public ApiResponse<ProvisionEmpresaResponse> provision(
            HttpServletRequest httpRequest,
            @Valid @RequestBody ProvisionEmpresaRequest body) {
        validateProvisionSecret(httpRequest);
        validateProvisionAuthToken(httpRequest);
        ProvisionEmpresaResponse data = tenantProvisioningService.provision(body);
        return ApiResponse.ok(data, data.getMensaje());
    }

    /**
     * Elimina empresa: borra registro en {@code master.empresa} y la BD física.
     * Busca por {@code codigo}, {@code ruc} o {@code dbName} (al menos uno).
     * Si se envían varios, todos deben coincidir con el mismo registro.
     */
    @DeleteMapping("/deprovision")
    public ApiResponse<DeleteEmpresaResponse> deprovision(
            HttpServletRequest httpRequest,
            @Valid @RequestBody DeleteEmpresaRequest body) {
        validateProvisionSecret(httpRequest);
        DeleteEmpresaResponse data = tenantProvisioningService.deprovision(
                body.getCodigo(), body.getRuc(), body.getDbName());
        return ApiResponse.ok(data, data.getMensaje());
    }

    /**
     * Actualiza credenciales del rol PostgreSQL del tenant y {@code master.empresa} (db_user, db_password_encrypted).
     * Identificación de empresa: al menos uno de codigo, ruc o dbName. Cabecera {@code X-Provision-Secret} obligatoria.
     */
    @PutMapping("/credenciales-bd")
    public ApiResponse<ActualizarCredencialesBdResponse> actualizarCredencialesBd(
            HttpServletRequest httpRequest,
            @Valid @RequestBody ActualizarCredencialesBdRequest body) {
        validateProvisionSecret(httpRequest);
        ActualizarCredencialesBdResponse data = tenantProvisioningService.actualizarCredencialesBd(body);
        return ApiResponse.ok(data, data.getMensaje());
    }

    /**
     * Recrea la BD tenant de una empresa usando el template:
     * DROP DATABASE (si existe) + CREATE DATABASE ... TEMPLATE.
     * Requiere {@code X-Provision-Secret} y JWT temporal (mismo criterio que {@code /provision}).
     */
    @PostMapping("/recreate")
    public ApiResponse<RecreateEmpresaResponse> recreate(
            HttpServletRequest httpRequest,
            @Valid @RequestBody RecreateEmpresaRequest body) {
        validateProvisionSecret(httpRequest);
        validateProvisionTemporalToken(httpRequest);
        RecreateEmpresaResponse data = tenantProvisioningService.recrearTenantDesdeTemplate(body);
        return ApiResponse.ok(data, data.getMensaje());
    }

    /**
     * Sube/actualiza logo de la empresa del token definitivo activo.
     * Requiere JWT no temporal y sesión vigente.
     */
    @PostMapping(value = "/logo", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ApiResponse<EmpresaLogoUploadResponse> uploadLogo(
            HttpServletRequest httpRequest,
            @RequestParam("file") MultipartFile file) {
        Long empresaId = validateDefinitiveToken(httpRequest);
        byte[] logoBytes;
        try {
            logoBytes = file.getBytes();
        } catch (Exception ex) {
            throw new BusinessException("No se pudo leer el archivo de logo", HttpStatus.BAD_REQUEST, "LOGO_INVALIDO");
        }
        EmpresaLogoUploadResponse data = tenantProvisioningService.actualizarLogoEmpresa(empresaId, logoBytes);
        return ApiResponse.ok(data, data.getMensaje());
    }

    @PostMapping("/{empresaId}/usuarios/{usuarioId}")
    public ApiResponse<UsuarioEmpresaSyncResponse> asociarUsuarioAEmpresa(
            HttpServletRequest httpRequest,
            @PathVariable Long empresaId,
            @PathVariable Long usuarioId) {
        validateProvisionSecret(httpRequest);
        UsuarioEmpresaSyncResponse data = usuarioEmpresaAdminService.asociarUsuarioAEmpresa(empresaId, usuarioId);
        return ApiResponse.ok(data, data.getMensaje());
    }

    @DeleteMapping("/{empresaId}/usuarios/{usuarioId}")
    public ApiResponse<UsuarioEmpresaSyncResponse> retirarUsuarioDeEmpresa(
            HttpServletRequest httpRequest,
            @PathVariable Long empresaId,
            @PathVariable Long usuarioId) {
        validateProvisionSecret(httpRequest);
        UsuarioEmpresaSyncResponse data = usuarioEmpresaAdminService.retirarUsuarioDeEmpresa(empresaId, usuarioId);
        return ApiResponse.ok(data, data.getMensaje());
    }

    private void validateProvisionSecret(HttpServletRequest request) {
        String header = request.getHeader("X-Provision-Secret");
        if (header == null || !provisionSecret.equals(header)) {
            throw new BusinessException("Cabecera X-Provision-Secret invalida", HttpStatus.FORBIDDEN, "PROVISION_UNAUTHORIZED");
        }
    }

    /**
     * Aprovisionamiento: JWT válido (temporal o definitivo con sesión activa) + {@code X-Provision-Secret}.
     */
    private void validateProvisionAuthToken(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            throw new BusinessException("Token requerido", HttpStatus.UNAUTHORIZED, "TOKEN_REQUERIDO");
        }

        String token = authHeader.substring(7);
        if (!jwtTokenProvider.validateToken(token)) {
            throw new BusinessException(
                    "Su sesión ha expirado. Por favor, inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED,
                    "TOKEN_EXPIRADO");
        }

        Claims claims = parseClaims(token);
        Boolean temporal = claims.get("temporal", Boolean.class);

        Long userId = claimToLong(claims.get("userId"));
        String username = claimToString(claims.get("username"));
        if (userId == null || username == null || username.isBlank()) {
            throw new BusinessException("Token inválido", HttpStatus.UNAUTHORIZED, "TOKEN_INVALIDO");
        }

        if (Boolean.TRUE.equals(temporal)) {
            String tokenIp = normalizeIp(claimToString(claims.get("ipAddress")));
            String requestIp = resolveClientIp(request);
            if (tokenIp == null || requestIp == null || !tokenIp.equals(requestIp)) {
                log.warn(
                        "Token temporal: IP del claim distinta a la de la solicitud (solo informativo, no bloquea). "
                                + "tokenIp={}, requestIp={}, userId={}, username={}",
                        tokenIp,
                        requestIp,
                        userId,
                        username);
                String userAgent = request.getHeader("User-Agent");
                if (userAgent == null || userAgent.isBlank()) {
                    userAgent = claimToString(claims.get("browser"));
                }
                logAccesoService.registrar(
                        userId,
                        null,
                        "PROVISION_TOKEN_IP_DISTINTA",
                        true,
                        "WARN",
                        requestIp,
                        tokenIp,
                        claimToString(claims.get("sistemaOperativo")),
                        userAgent);
            }
            return;
        }

        Long tokensSessionId = claimToLong(claims.get("tokensSessionId"));
        if (tokensSessionId != null && !tokensSessionService.sesionActivaParaToken(userId, tokensSessionId)) {
            throw new BusinessException(
                    "Su sesión ha sido cerrada o está inactiva. Inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED,
                    "SESION_REVOCADA");
        }
    }

    private void validateProvisionTemporalToken(HttpServletRequest request) {
        validateProvisionAuthToken(request);
        String token = request.getHeader("Authorization").substring(7);
        Claims claims = parseClaims(token);
        if (!Boolean.TRUE.equals(claims.get("temporal", Boolean.class))) {
            throw new BusinessException(
                    "Se requiere token temporal para esta operación.",
                    HttpStatus.FORBIDDEN,
                    "TOKEN_TEMPORAL_REQUERIDO");
        }
    }

    private Long validateDefinitiveToken(HttpServletRequest request) {
        String authHeader = request.getHeader("Authorization");
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            throw new BusinessException("Token requerido", HttpStatus.UNAUTHORIZED, "TOKEN_REQUERIDO");
        }

        String token = authHeader.substring(7);
        if (!jwtTokenProvider.validateToken(token)) {
            throw new BusinessException(
                    "Su sesión ha expirado. Por favor, inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED,
                    "TOKEN_EXPIRADO");
        }

        Claims claims = parseClaims(token);
        Boolean temporal = claims.get("temporal", Boolean.class);
        if (Boolean.TRUE.equals(temporal)) {
            throw new BusinessException(
                    "Se requiere token definitivo para actualizar el logo.",
                    HttpStatus.FORBIDDEN,
                    "TOKEN_DEFINITIVO_REQUERIDO");
        }

        Long userId = claimToLong(claims.get("userId"));
        Long empresaId = claimToLong(claims.get("empresaId"));
        Long tokensSessionId = claimToLong(claims.get("tokensSessionId"));
        if (userId == null || empresaId == null) {
            throw new BusinessException("Token inválido", HttpStatus.UNAUTHORIZED, "TOKEN_INVALIDO");
        }
        if (tokensSessionId != null && !tokensSessionService.sesionActivaParaToken(userId, tokensSessionId)) {
            throw new BusinessException(
                    "Su sesión ha sido cerrada o está inactiva. Inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED,
                    "SESION_REVOCADA");
        }
        return empresaId;
    }

    private static String resolveClientIp(HttpServletRequest request) {
        String forwardedFor = request.getHeader("X-Forwarded-For");
        if (forwardedFor != null && !forwardedFor.isBlank()) {
            return normalizeIp(forwardedFor.split(",")[0]);
        }
        String realIp = request.getHeader("X-Real-IP");
        if (realIp != null && !realIp.isBlank()) {
            return normalizeIp(realIp);
        }
        return normalizeIp(request.getRemoteAddr());
    }

    private static String normalizeIp(String ip) {
        if (ip == null || ip.isBlank()) {
            return null;
        }
        return ip.trim();
    }

    private static Long claimToLong(Object raw) {
        if (raw instanceof Number n) {
            return n.longValue();
        }
        return null;
    }

    private static String claimToString(Object raw) {
        return raw != null ? String.valueOf(raw) : null;
    }

    private Claims parseClaims(String token) {
        try {
            SecretKey key = Keys.hmacShaKeyFor(Decoders.BASE64.decode(jwtSecretBase64));
            return Jwts.parser()
                    .verifyWith(key)
                    .build()
                    .parseSignedClaims(token)
                    .getPayload();
        } catch (JwtException | IllegalArgumentException ex) {
            throw new BusinessException(
                    "Su sesión ha expirado. Por favor, inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED,
                    "TOKEN_EXPIRADO");
        }
    }
}
