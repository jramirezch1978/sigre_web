package com.sigre.seguridad.service.impl;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.seguridad.dto.*;
import com.sigre.seguridad.entity.Usuario;
import com.sigre.seguridad.entity.master.EmpresaMaster;
import com.sigre.seguridad.repository.EmpresaMasterRepository;
import com.sigre.seguridad.repository.UsuarioRepository;
import com.sigre.seguridad.service.AuthService;
import com.sigre.seguridad.service.EmailService;
import com.sigre.seguridad.service.TenantConnectionService;
import com.sigre.seguridad.service.LogAccesoService;
import com.sigre.seguridad.service.TokensSessionService;
import com.sigre.seguridad.service.TurnstileVerificationService;
import com.sigre.seguridad.service.UsuarioEmpresaAdminService;
import com.sigre.seguridad.dto.TenantConnectionInfoResponse;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.security.JwtTokenProvider;
import com.sigre.common.util.AesEncryptor;

import javax.sql.DataSource;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Slf4j
@Service
public class AuthServiceImpl implements AuthService {

    private static final int MAX_INTENTOS = 3;
    private static final int HORAS_BLOQUEO = 24;

    private final UsuarioRepository usuarioRepository;
    private final EmpresaMasterRepository empresaMasterRepository;
    private final JwtTokenProvider jwtTokenProvider;
    private final PasswordEncoder passwordEncoder;
    private final AesEncryptor aesEncryptor;
    private final EmailService emailService;
    private final JdbcTemplate jdbcTemplate;
    private final TenantConnectionService tenantConnectionService;
    private final UsuarioEmpresaAdminService usuarioEmpresaAdminService;
    private final TokensSessionService tokensSessionService;
    private final LogAccesoService logAccesoService;
    private final TurnstileVerificationService turnstileVerificationService;

    @Value("${app.jwt.access-token-expiration:900000}")
    private long tempTokenExpiration;

    @Value("${app.jwt.definitive-token-expiration:900000}")
    private long definitiveTokenExpiration;

    @Value("${app.jwt.refresh-token-expiration:604800000}")
    private long refreshTokenExpirationMs;

    public AuthServiceImpl(
            UsuarioRepository usuarioRepository,
            EmpresaMasterRepository empresaMasterRepository,
            JwtTokenProvider jwtTokenProvider,
            PasswordEncoder passwordEncoder,
            AesEncryptor aesEncryptor,
            EmailService emailService,
            TenantConnectionService tenantConnectionService,
            UsuarioEmpresaAdminService usuarioEmpresaAdminService,
            TokensSessionService tokensSessionService,
            LogAccesoService logAccesoService,
            TurnstileVerificationService turnstileVerificationService,
            DataSource dataSource) {
        this.usuarioRepository = usuarioRepository;
        this.empresaMasterRepository = empresaMasterRepository;
        this.jwtTokenProvider = jwtTokenProvider;
        this.passwordEncoder = passwordEncoder;
        this.aesEncryptor = aesEncryptor;
        this.emailService = emailService;
        this.tenantConnectionService = tenantConnectionService;
        this.usuarioEmpresaAdminService = usuarioEmpresaAdminService;
        this.tokensSessionService = tokensSessionService;
        this.logAccesoService = logAccesoService;
        this.turnstileVerificationService = turnstileVerificationService;
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    @Override
    @Transactional
    public LoginResponse login(LoginRequest request) {
        turnstileVerificationService.requireValid(request.getTurnstileToken(), request.getIpAddress());

        Usuario usuario = findUsuario(request.getEmail());

        checkBloqueo(usuario);

        String plainPassword = decryptPassword(request.getPassword(), request.getPasswordHash());

        if (!passwordEncoder.matches(plainPassword, usuario.getPassword())) {
            handleLoginFallido(usuario, request);
            throw new BusinessException("Credenciales inválidas", HttpStatus.UNAUTHORIZED, "CREDENCIALES_INVALIDAS");
        }

        usuario.setIntentosFallidos(0);
        usuario.setBloqueado(false);
        usuario.setBloqueadoHasta(null);
        usuario.setUltimoLoginEn(OffsetDateTime.now());
        usuarioRepository.save(usuario);

        Map<String, Object> claims = buildTemporalClaims(usuario, request);
        String token = jwtTokenProvider.generateAccessToken(usuario.getUsername(), claims);

        log.info("Login exitoso: user={} email={} ip={}",
                usuario.getUsername(), usuario.getEmail(), request.getIpAddress());

        return LoginResponse.builder()
                .accessToken(token)
                .tokenType("Bearer")
                .expiresInSeconds(tempTokenExpiration / 1000)
                .temporal(true)
                .userId(usuario.getId())
                .email(usuario.getEmail())
                .username(usuario.getUsername())
                .nombres(usuario.getNombres())
                .apellidos(usuario.getApellidos())
                .nombreCompleto(usuario.getNombreCompleto())
                .adminSistema(isFlagAdminSistema(usuario))
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public List<EmpresaUsuarioDto> listarEmpresas(Long usuarioId) {
        return jdbcTemplate.query(
                """
                SELECT e.id, e.codigo, e.razon_social, e.ruc, e.db_name
                FROM auth.usuario_empresa ue
                JOIN master.empresa e ON e.id = ue.empresa_id
                JOIN auth.usuario u ON u.id = ue.usuario_id
                WHERE ue.usuario_id = ? AND ue.flag_estado = '1' AND e.flag_estado = '1'
                  AND (u.flag_demo = '0' OR e.flag_demo = '1')
                ORDER BY e.razon_social
                """,
                (rs, rowNum) -> EmpresaUsuarioDto.builder()
                        .empresaId(rs.getLong("id"))
                        .codigo(rs.getString("codigo"))
                        .razonSocial(rs.getString("razon_social"))
                        .ruc(rs.getString("ruc"))
                        .dbName(rs.getString("db_name"))
                        .build(),
                usuarioId
        );
    }

    @Override
    @Transactional
    public Long authenticateCredentialsForSeleccionEmpresa(SeleccionEmpresaRequest request) {
        if (request.getEmail() == null || request.getEmail().isBlank()
                || request.getPassword() == null || request.getPassword().isBlank()) {
            throw new BusinessException(
                    "Sin encabezado Authorization se requieren email y contraseña (mismo cifrado que en login).",
                    HttpStatus.UNAUTHORIZED,
                    "CREDENCIALES_REQUERIDAS");
        }
        Usuario usuario = findUsuario(request.getEmail().trim());
        checkBloqueo(usuario);
        String plainPassword = decryptPassword(request.getPassword(), request.getPasswordHash());
        if (!passwordEncoder.matches(plainPassword, usuario.getPassword())) {
            handleLoginFallido(usuario, toLoginRequestFromSeleccion(request));
            throw new BusinessException("Credenciales inválidas", HttpStatus.UNAUTHORIZED, "CREDENCIALES_INVALIDAS");
        }
        usuario.setIntentosFallidos(0);
        usuario.setBloqueado(false);
        usuario.setBloqueadoHasta(null);
        usuario.setUltimoLoginEn(OffsetDateTime.now());
        usuarioRepository.save(usuario);
        registrarLogAcceso(usuario.getId(), request.getEmpresaId(), "SELECCION_EMPRESA_LOGIN", true,
                request.getIpAddress(), request.getIpPrivada(),
                request.getSistemaOperativo(), request.getBrowser());
        return usuario.getId();
    }

    private LoginRequest toLoginRequestFromSeleccion(SeleccionEmpresaRequest r) {
        LoginRequest lr = new LoginRequest();
        lr.setEmail(r.getEmail() != null ? r.getEmail().trim() : null);
        lr.setPassword(r.getPassword());
        lr.setPasswordHash(r.getPasswordHash());
        lr.setIpAddress(r.getIpAddress());
        lr.setIpPrivada(r.getIpPrivada());
        lr.setBrowser(r.getBrowser());
        lr.setSistemaOperativo(r.getSistemaOperativo());
        return lr;
    }

    private static boolean isFlagAdminSistema(Usuario usuario) {
        return usuario.getFlagAdminSistema() != null && "1".equals(usuario.getFlagAdminSistema());
    }

    private static void validarCompatibilidadDemo(Usuario usuario, EmpresaMaster empresa) {
        boolean usuarioDemo = "1".equals(usuario.getFlagDemo());
        boolean empresaDemo = "1".equals(empresa.getFlagDemo());
        if (usuarioDemo && !empresaDemo) {
            throw new BusinessException(
                    "Los usuarios demo solo pueden acceder a empresas demo.",
                    HttpStatus.FORBIDDEN, "DEMO_EMPRESA_NO_PERMITIDA");
        }
        if (!usuarioDemo && empresaDemo && !isFlagAdminSistema(usuario)) {
            throw new BusinessException(
                    "Esta empresa demo solo está disponible para usuarios registrados en modo demo.",
                    HttpStatus.FORBIDDEN, "DEMO_USUARIO_REQUERIDO");
        }
    }

    @Override
    @Transactional
    public LoginResponse seleccionarEmpresa(Long usuarioId, SeleccionEmpresaRequest request) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new BusinessException("Usuario no encontrado",
                        HttpStatus.NOT_FOUND, "USUARIO_NO_ENCONTRADO"));

        Long empresaId = request.getEmpresaId();

        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.usuario_empresa WHERE usuario_id = ? AND empresa_id = ? AND flag_estado = '1'",
                Integer.class, usuarioId, empresaId);

        if (count == null || count == 0) {
            throw new BusinessException("No tiene acceso a esta empresa",
                    HttpStatus.FORBIDDEN, "EMPRESA_NO_ASIGNADA");
        }

        int asignacionSucursal = countUsuarioSucursalEnTenant(empresaId, usuarioId, request.getSucursalId());

        if (asignacionSucursal == 0) {
            logSucursalNoAsignadaDiagnostico(usuarioId, empresaId, request);
            throw new BusinessException("No tiene acceso a esta sucursal o no está asignada",
                    HttpStatus.FORBIDDEN, "SUCURSAL_NO_ASIGNADA");
        }

        EmpresaMaster empresa = empresaMasterRepository.findById(empresaId)
                .orElseThrow(() -> new BusinessException("Empresa no encontrada",
                        HttpStatus.NOT_FOUND, "EMPRESA_NO_ENCONTRADA"));

        validarCompatibilidadDemo(usuario, empresa);

        DatosSucursalTenant datosSucursal = obtenerDatosSucursalTenant(empresa.getId(), request.getSucursalId());
        String sucursalNombre = datosSucursal != null ? datosSucursal.nombre() : null;
        String ciudadSucursal = datosSucursal != null ? datosSucursal.ciudad() : null;

        Optional<String> jwtReuso = tokensSessionService.buscarJwtReutilizable(
                usuarioId, empresaId, request.getSucursalId());
        if (jwtReuso.isPresent()) {
            registrarLogAcceso(usuario.getId(), empresaId, "SELECCION_EMPRESA_REUSO_TOKEN", true,
                    request.getIpAddress(), request.getIpPrivada(),
                    request.getSistemaOperativo(), request.getBrowser());
            return construirLoginResponseDefinitivo(jwtReuso.get(), usuario, empresa, request, sucursalNombre, null);
        }

        usuarioEmpresaAdminService.sincronizarUsuarioEnTenantPorSeleccionEmpresa(usuarioId, empresaId);

        tokensSessionService.inactivarActivosUsuarioEmpresa(usuarioId, empresaId);

        OffsetDateTime expiraEn = OffsetDateTime.now().plusSeconds(refreshTokenExpirationMs / 1000);
        long tokensSessionId = tokensSessionService.insertarSesionPendiente(
                usuarioId, empresaId, request.getSucursalId(), expiraEn);

        Map<String, Object> claims = buildDefinitiveClaims(
                usuario, empresa, request, sucursalNombre, ciudadSucursal, tokensSessionId);

        if (request.getIpAddress() != null) claims.put("ipAddress", request.getIpAddress());
        if (request.getIpPrivada() != null) claims.put("ipPrivada", request.getIpPrivada());
        if (request.getSistemaOperativo() != null) claims.put("sistemaOperativo", request.getSistemaOperativo());
        if (request.getBrowser() != null) claims.put("browser", request.getBrowser());

        String token = jwtTokenProvider.generateDefinitiveToken(usuario.getUsername(), claims);
        tokensSessionService.guardarJwt(tokensSessionId, token);

        Map<String, Object> refreshClaims = new LinkedHashMap<>();
        refreshClaims.put("userId", usuario.getId());
        refreshClaims.put("tokensSessionId", tokensSessionId);
        String refreshTokenStr = jwtTokenProvider.generateRefreshToken(usuario.getUsername(), refreshClaims);

        registrarLogAcceso(usuario.getId(), empresaId, "SELECCION_EMPRESA", true,
                request.getIpAddress(), request.getIpPrivada(),
                request.getSistemaOperativo(), request.getBrowser());

        return construirLoginResponseDefinitivo(token, usuario, empresa, request, sucursalNombre, refreshTokenStr);
    }

    @Override
    @Transactional
    public void logout(Long usuarioId, String bearerToken) {
        String token = bearerToken != null && bearerToken.startsWith("Bearer ")
                ? bearerToken.substring(7)
                : bearerToken;
        if (token == null || token.isBlank()) {
            return;
        }
        Long tsId = jwtTokenProvider.getClaim(token, "tokensSessionId", Long.class);
        if (tsId != null) {
            tokensSessionService.inactivarPorId(tsId, usuarioId);
        }
    }

    @Override
    @Transactional
    public RefreshTokenResponse refreshToken(RefreshTokenRequest request) {
        String rt = request.getRefreshToken();
        if (rt == null || rt.isBlank()) {
            throw new BusinessException("Refresh token requerido", HttpStatus.BAD_REQUEST, "VALIDATION_ERROR");
        }
        if (!jwtTokenProvider.validateToken(rt)) {
            throw new BusinessException("Refresh token inválido o expirado",
                    HttpStatus.UNAUTHORIZED, "REFRESH_TOKEN_INVALIDO");
        }
        if (!jwtTokenProvider.isRefreshToken(rt)) {
            throw new BusinessException("El token no es un refresh token",
                    HttpStatus.UNAUTHORIZED, "REFRESH_TOKEN_INVALIDO");
        }
        Long userId = jwtTokenProvider.getUserId(rt);
        if (userId == null) {
            userId = claimToLong(jwtTokenProvider.getClaim(rt, "userId", Object.class));
        }
        Long tokensSessionId = jwtTokenProvider.getClaim(rt, "tokensSessionId", Long.class);
        if (tokensSessionId == null) {
            tokensSessionId = claimToLong(jwtTokenProvider.getClaim(rt, "tokensSessionId", Object.class));
        }
        if (userId == null || tokensSessionId == null) {
            throw new BusinessException("Refresh token mal formado",
                    HttpStatus.UNAUTHORIZED, "REFRESH_TOKEN_INVALIDO");
        }

        Optional<TokensSessionService.SesionActivaRow> sesionOpt =
                tokensSessionService.findSesionActiva(tokensSessionId, userId);
        if (sesionOpt.isEmpty()) {
            throw new BusinessException(
                    "Sesión cerrada o expirada. Inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED, "SESION_REVOADA");
        }
        TokensSessionService.SesionActivaRow sesion = sesionOpt.get();

        Usuario usuario = usuarioRepository.findById(userId)
                .orElseThrow(() -> new BusinessException("Usuario no encontrado",
                        HttpStatus.NOT_FOUND, "USUARIO_NO_ENCONTRADO"));

        EmpresaMaster empresa = empresaMasterRepository.findById(sesion.empresaId())
                .orElseThrow(() -> new BusinessException("Empresa no encontrada",
                        HttpStatus.NOT_FOUND, "EMPRESA_NO_ENCONTRADA"));

        SeleccionEmpresaRequest sel = new SeleccionEmpresaRequest();
        sel.setEmpresaId(sesion.empresaId());
        sel.setSucursalId(sesion.sucursalId());

        DatosSucursalTenant datosSucursal = obtenerDatosSucursalTenant(empresa.getId(), sesion.sucursalId());
        String sucursalNombre = datosSucursal != null ? datosSucursal.nombre() : null;
        String ciudadSucursal = datosSucursal != null ? datosSucursal.ciudad() : null;

        OffsetDateTime nuevaExpira = OffsetDateTime.now().plusSeconds(refreshTokenExpirationMs / 1000);

        Map<String, Object> claims = buildDefinitiveClaims(
                usuario, empresa, sel, sucursalNombre, ciudadSucursal, tokensSessionId);

        String newAccess = jwtTokenProvider.generateDefinitiveToken(usuario.getUsername(), claims);

        Map<String, Object> refreshClaims = new LinkedHashMap<>();
        refreshClaims.put("userId", usuario.getId());
        refreshClaims.put("tokensSessionId", tokensSessionId);
        String newRefresh = jwtTokenProvider.generateRefreshToken(usuario.getUsername(), refreshClaims);

        tokensSessionService.renovarExpiracionYJwt(tokensSessionId, userId, nuevaExpira, newAccess);

        return RefreshTokenResponse.builder()
                .accessToken(newAccess)
                .refreshToken(newRefresh)
                .tokenType("Bearer")
                .expiresInSeconds(definitiveTokenExpiration / 1000)
                .userId(usuario.getId())
                .email(usuario.getEmail())
                .username(usuario.getUsername())
                .nombres(usuario.getNombres())
                .apellidos(usuario.getApellidos())
                .nombreCompleto(usuario.getNombreCompleto())
                .empresaId(empresa.getId())
                .empresaCodigo(empresa.getCodigo())
                .empresaNombre(empresa.getRazonSocial())
                .empresaRuc(empresa.getRuc())
                .sucursalId(sesion.sucursalId())
                .sucursalNombre(sucursalNombre)
                .build();
    }

    @Override
    @Transactional(readOnly = true)
    public AuthMeResponse getProfile(String accessToken) {
        if (accessToken == null || accessToken.isBlank()) {
            throw new BusinessException("Token requerido", HttpStatus.UNAUTHORIZED, "TOKEN_REQUERIDO");
        }
        if (!jwtTokenProvider.validateToken(accessToken)) {
            throw new BusinessException(
                    "Su sesión ha expirado. Por favor, inicie sesión nuevamente.",
                    HttpStatus.UNAUTHORIZED, "TOKEN_EXPIRADO");
        }

        Boolean temporal = jwtTokenProvider.getClaim(accessToken, "temporal", Boolean.class);
        boolean isTemporal = Boolean.TRUE.equals(temporal);

        Long userId = jwtTokenProvider.getUserId(accessToken);
        if (userId == null) {
            userId = claimToLong(jwtTokenProvider.getClaim(accessToken, "userId", Object.class));
        }

        Long tokensSessionId = jwtTokenProvider.getClaim(accessToken, "tokensSessionId", Long.class);
        if (tokensSessionId == null) {
            tokensSessionId = claimToLong(jwtTokenProvider.getClaim(accessToken, "tokensSessionId", Object.class));
        }

        if (!isTemporal && tokensSessionId != null && userId != null) {
            if (!tokensSessionService.sesionActivaParaToken(userId, tokensSessionId)) {
                throw new BusinessException(
                        "Su sesión ha sido cerrada o está inactiva. Inicie sesión nuevamente.",
                        HttpStatus.UNAUTHORIZED, "SESION_REVOADA");
            }
        }

        AuthMeResponse response = isTemporal ? buildAuthMeTemporal(accessToken, userId) : buildAuthMeDefinitivo(accessToken, userId, tokensSessionId);
        applyAdminSistemaFlag(response, userId);
        return response;
    }

    private void applyAdminSistemaFlag(AuthMeResponse response, Long userId) {
        if (userId == null) {
            return;
        }
        usuarioRepository.findById(userId).ifPresent(u -> response.setAdminSistema(isFlagAdminSistema(u)));
    }

    private static Long claimToLong(Object raw) {
        if (raw == null) {
            return null;
        }
        if (raw instanceof Number n) {
            return n.longValue();
        }
        return null;
    }

    private AuthMeResponse buildAuthMeTemporal(String token, Long userId) {
        AuthMeResponse.MeUsuarioClaims usuarioNested = extractUsuarioClaims(token);
        return AuthMeResponse.builder()
                .temporal(true)
                .userId(userId)
                .username(jwtTokenProvider.getClaim(token, "username", String.class))
                .email(jwtTokenProvider.getClaim(token, "email", String.class))
                .nombres(jwtTokenProvider.getClaim(token, "nombres", String.class))
                .apellidos(jwtTokenProvider.getClaim(token, "apellidos", String.class))
                .nombreCompleto(jwtTokenProvider.getClaim(token, "nombreCompleto", String.class))
                .usuario(usuarioNested)
                .build();
    }

    private AuthMeResponse buildAuthMeDefinitivo(String token, Long userId, Long tokensSessionId) {
        AuthMeResponse.MeUsuarioClaims u = extractUsuarioClaims(token);
        AuthMeResponse.MeEmpresaClaims e = extractEmpresaClaims(token);
        AuthMeResponse.MeSucursalClaims s = extractSucursalClaims(token);

        return AuthMeResponse.builder()
                .temporal(false)
                .tokensSessionId(tokensSessionId)
                .userId(userId)
                .username(jwtTokenProvider.getClaim(token, "username", String.class))
                .email(jwtTokenProvider.getClaim(token, "email", String.class))
                .nombres(jwtTokenProvider.getClaim(token, "nombres", String.class))
                .apellidos(jwtTokenProvider.getClaim(token, "apellidos", String.class))
                .nombreCompleto(jwtTokenProvider.getClaim(token, "nombreCompleto", String.class))
                .empresaId(claimToLong(jwtTokenProvider.getClaim(token, "empresaId", Object.class)))
                .empresaCodigo(jwtTokenProvider.getClaim(token, "empresaCodigo", String.class))
                .empresaNombre(jwtTokenProvider.getClaim(token, "empresaNombre", String.class))
                .empresaRuc(jwtTokenProvider.getClaim(token, "empresaRuc", String.class))
                .dbName(jwtTokenProvider.getClaim(token, "dbName", String.class))
                .sucursalId(claimToLong(jwtTokenProvider.getClaim(token, "sucursalId", Object.class)))
                .sucursalNombre(jwtTokenProvider.getClaim(token, "sucursalNombre", String.class))
                .usuario(u)
                .empresa(e)
                .sucursal(s)
                .build();
    }

    @SuppressWarnings("unchecked")
    private AuthMeResponse.MeUsuarioClaims extractUsuarioClaims(String token) {
        Map<String, Object> m = jwtTokenProvider.getClaim(token, "usuario", Map.class);
        if (m == null || m.isEmpty()) {
            return null;
        }
        return AuthMeResponse.MeUsuarioClaims.builder()
                .id(claimToLong(m.get("id")))
                .username((String) m.get("username"))
                .nombres((String) m.get("nombres"))
                .apellidos((String) m.get("apellidos"))
                .email((String) m.get("email"))
                .build();
    }

    @SuppressWarnings("unchecked")
    private AuthMeResponse.MeEmpresaClaims extractEmpresaClaims(String token) {
        Map<String, Object> m = jwtTokenProvider.getClaim(token, "empresa", Map.class);
        if (m == null || m.isEmpty()) {
            return null;
        }
        return AuthMeResponse.MeEmpresaClaims.builder()
                .id(claimToLong(m.get("id")))
                .nombre((String) m.get("nombre"))
                .ruc((String) m.get("ruc"))
                .codigo((String) m.get("codigo"))
                .build();
    }

    @SuppressWarnings("unchecked")
    private AuthMeResponse.MeSucursalClaims extractSucursalClaims(String token) {
        Map<String, Object> m = jwtTokenProvider.getClaim(token, "sucursal", Map.class);
        if (m == null || m.isEmpty()) {
            return null;
        }
        return AuthMeResponse.MeSucursalClaims.builder()
                .id(claimToLong(m.get("id")))
                .nombre((String) m.get("nombre"))
                .ciudad((String) m.get("ciudad"))
                .build();
    }

    private LoginResponse construirLoginResponseDefinitivo(
            String token,
            Usuario usuario,
            EmpresaMaster empresa,
            SeleccionEmpresaRequest request,
            String sucursalNombre,
            String refreshToken) {
        LoginResponse.LoginResponseBuilder b = LoginResponse.builder()
                .accessToken(token)
                .tokenType("Bearer")
                .expiresInSeconds(definitiveTokenExpiration / 1000)
                .temporal(false)
                .userId(usuario.getId())
                .email(usuario.getEmail())
                .username(usuario.getUsername())
                .nombres(usuario.getNombres())
                .apellidos(usuario.getApellidos())
                .nombreCompleto(usuario.getNombreCompleto())
                .empresaId(empresa.getId())
                .empresaCodigo(empresa.getCodigo())
                .empresaNombre(empresa.getRazonSocial())
                .empresaRuc(empresa.getRuc())
                .sucursalId(request.getSucursalId())
                .sucursalNombre(sucursalNombre)
                .adminSistema(isFlagAdminSistema(usuario));
        if (refreshToken != null && !refreshToken.isBlank()) {
            b.refreshToken(refreshToken);
        }
        return b.build();
    }

    private Usuario findUsuario(String emailOrUsername) {
        return usuarioRepository.findByEmailAndActivoTrue(emailOrUsername)
                .or(() -> usuarioRepository.findByUsernameAndActivoTrue(emailOrUsername))
                .orElseThrow(() -> new BusinessException(
                        "Credenciales inválidas", HttpStatus.UNAUTHORIZED, "CREDENCIALES_INVALIDAS"));
    }

    private void checkBloqueo(Usuario usuario) {
        if (usuario.getBloqueadoHasta() != null) {
            if (OffsetDateTime.now().isBefore(usuario.getBloqueadoHasta())) {
                throw new BusinessException(
                        "Usuario bloqueado por seguridad. Intente nuevamente después de 24 horas.",
                        HttpStatus.FORBIDDEN, "USUARIO_BLOQUEADO");
            }
            usuario.setBloqueado(false);
            usuario.setBloqueadoHasta(null);
            usuario.setIntentosFallidos(0);
            usuarioRepository.save(usuario);
        }
    }

    private String decryptPassword(String encryptedPassword, String passwordHash) {
        try {
            if (passwordHash != null && !passwordHash.isBlank()) {
                return aesEncryptor.decryptAndVerify(encryptedPassword, passwordHash);
            }
            return aesEncryptor.decryptFromFrontend(encryptedPassword);
        } catch (Exception e) {
            log.warn("No se pudo desencriptar/verificar la contraseña: {}", e.getMessage());
            throw new BusinessException("Error al procesar credenciales",
                    HttpStatus.BAD_REQUEST, "CREDENCIALES_INVALIDAS");
        }
    }

    private void handleLoginFallido(Usuario usuario, LoginRequest request) {
        int intentos = usuario.getIntentosFallidos() + 1;
        usuario.setIntentosFallidos(intentos);

        if (intentos >= MAX_INTENTOS) {
            usuario.setBloqueado(true);
            usuario.setBloqueadoHasta(OffsetDateTime.now().plusHours(HORAS_BLOQUEO));
            log.warn("Usuario {} bloqueado por {} intentos fallidos desde ip={}",
                    usuario.getUsername(), MAX_INTENTOS, request.getIpAddress());

            String adminEmail = findAdminEmail();
            emailService.enviarAlertaBloqueo(
                    usuario.getEmail(), adminEmail, usuario.getUsername(),
                    request.getIpAddress(), request.getBrowser(),
                    request.getIpPrivada(), request.getSistemaOperativo());
        }

        usuarioRepository.save(usuario);
    }

    private Map<String, Object> buildTemporalClaims(Usuario usuario, LoginRequest request) {
        Map<String, Object> claims = new LinkedHashMap<>();
        claims.put("userId", usuario.getId());
        claims.put("username", usuario.getUsername());
        claims.put("email", usuario.getEmail());
        claims.put("nombres", usuario.getNombres());
        claims.put("apellidos", usuario.getApellidos());
        claims.put("nombreCompleto", usuario.getNombreCompleto());
        claims.put("temporal", true);

        Map<String, Object> usuarioClaim = new LinkedHashMap<>();
        usuarioClaim.put("id", usuario.getId());
        usuarioClaim.put("username", usuario.getUsername());
        usuarioClaim.put("nombres", usuario.getNombres());
        usuarioClaim.put("apellidos", usuario.getApellidos());
        usuarioClaim.put("email", usuario.getEmail());
        claims.put("usuario", usuarioClaim);

        if (request.getIpAddress() != null) claims.put("ipAddress", request.getIpAddress());
        if (request.getBrowser() != null) claims.put("browser", request.getBrowser());
        if (request.getSistemaOperativo() != null) claims.put("sistemaOperativo", request.getSistemaOperativo());
        if (request.getDeviceName() != null && !request.getDeviceName().isBlank()) {
            claims.put("deviceName", request.getDeviceName());
        }
        return claims;
    }

    private Map<String, Object> buildDefinitiveClaims(
            Usuario usuario,
            EmpresaMaster empresa,
            SeleccionEmpresaRequest request,
            String sucursalNombre,
            String ciudadSucursal,
            long tokensSessionId
    ) {
        Map<String, Object> claims = new LinkedHashMap<>();

        claims.put("tokensSessionId", tokensSessionId);
        claims.put("userId", usuario.getId());
        claims.put("username", usuario.getUsername());
        claims.put("email", usuario.getEmail());
        claims.put("nombres", usuario.getNombres());
        claims.put("apellidos", usuario.getApellidos());
        claims.put("nombreCompleto", usuario.getNombreCompleto());
        claims.put("empresaId", empresa.getId());
        claims.put("empresaCodigo", empresa.getCodigo());
        claims.put("empresaNombre", empresa.getRazonSocial());
        claims.put("empresaRuc", empresa.getRuc());
        claims.put("dbName", empresa.getDbName());
        claims.put("temporal", false);

        claims.put("sucursalId", request.getSucursalId());
        if (sucursalNombre != null && !sucursalNombre.isBlank()) {
            claims.put("sucursalNombre", sucursalNombre);
        }

        Map<String, Object> usuarioClaim = new LinkedHashMap<>();
        usuarioClaim.put("id", usuario.getId());
        usuarioClaim.put("username", usuario.getUsername());
        usuarioClaim.put("nombres", usuario.getNombres());
        usuarioClaim.put("apellidos", usuario.getApellidos());
        usuarioClaim.put("email", usuario.getEmail());
        claims.put("usuario", usuarioClaim);

        Map<String, Object> empresaClaim = new LinkedHashMap<>();
        empresaClaim.put("id", empresa.getId());
        empresaClaim.put("nombre", empresa.getRazonSocial());
        empresaClaim.put("ruc", empresa.getRuc());
        empresaClaim.put("codigo", empresa.getCodigo());
        claims.put("empresa", empresaClaim);

        Map<String, Object> sucursalClaim = new LinkedHashMap<>();
        sucursalClaim.put("id", request.getSucursalId());
        sucursalClaim.put("nombre", sucursalNombre);
        if (ciudadSucursal != null && !ciudadSucursal.isBlank()) {
            sucursalClaim.put("ciudad", ciudadSucursal);
        }
        claims.put("sucursal", sucursalClaim);

        return claims;
    }

    /**
     * Diagnóstico solo en log: lectura de {@code auth.usuario_sucursal} en BD tenant (no existe en security).
     */
    private void logSucursalNoAsignadaDiagnostico(Long usuarioId, Long empresaId, SeleccionEmpresaRequest request) {
        Long sucursalSolicitada = request.getSucursalId();
        String jdbcEmpresaTenant = null;
        String empresaCodigo = null;
        List<Map<String, Object>> filasUsuario = List.of();
        List<Map<String, Object>> filaSucursalPuntual = List.of();
        try {
            EmpresaMaster em = empresaMasterRepository.findById(empresaId).orElse(null);
            if (em != null) {
                empresaCodigo = em.getCodigo();
                jdbcEmpresaTenant = String.format("jdbc:postgresql://%s:%d/%s",
                        em.getDbHost(), em.getDbPort(), em.getDbName());
            }
            TenantConnectionInfoResponse conn = tenantConnectionService.getTenantConnection(empresaId);
            try (Connection tc = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword())) {
                filasUsuario = queryUsuarioSucursalRows(tc,
                        """
                        SELECT id, usuario_id, sucursal_id, flag_estado
                        FROM auth.usuario_sucursal
                        WHERE usuario_id = ?
                        ORDER BY sucursal_id
                        """,
                        usuarioId);
                filaSucursalPuntual = queryUsuarioSucursalRows(tc,
                        """
                        SELECT id, usuario_id, sucursal_id, flag_estado
                        FROM auth.usuario_sucursal
                        WHERE usuario_id = ? AND sucursal_id = ?
                        """,
                        usuarioId, sucursalSolicitada);
            }
        } catch (Exception ex) {
            log.debug("logSucursalNoAsignadaDiagnostico tenant: {}", ex.getMessage());
        }
        log.warn(
                "[SUCURSAL_NO_ASIGNADA] usuarioId={}, empresaId={}, empresaCodigo={}, sucursalIdSolicitada={}, "
                        + "usuarioSucursalEnTenant(usuario_id)={}, "
                        + "usuarioSucursalEnTenant(usuario_id+sucursal_id)={}, "
                        + "jdbcEmpresaTenant(sin credenciales)={}",
                usuarioId, empresaId, empresaCodigo, sucursalSolicitada,
                filasUsuario, filaSucursalPuntual, jdbcEmpresaTenant);
    }

    private static List<Map<String, Object>> queryUsuarioSucursalRows(Connection tc, String sql, Object... params)
            throws SQLException {
        try (PreparedStatement ps = tc.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            try (ResultSet rs = ps.executeQuery()) {
                List<Map<String, Object>> out = new ArrayList<>();
                int cols = rs.getMetaData().getColumnCount();
                while (rs.next()) {
                    Map<String, Object> row = new LinkedHashMap<>();
                    for (int c = 1; c <= cols; c++) {
                        row.put(rs.getMetaData().getColumnLabel(c), rs.getObject(c));
                    }
                    out.add(row);
                }
                return out;
            }
        }
    }

    private int countUsuarioSucursalEnTenant(Long empresaId, Long usuarioId, Long sucursalId) {
        try {
            TenantConnectionInfoResponse conn = tenantConnectionService.getTenantConnection(empresaId);
            try (Connection c = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
                 PreparedStatement ps = c.prepareStatement(
                         """
                         SELECT COUNT(*)::int FROM auth.usuario_sucursal
                         WHERE usuario_id = ? AND sucursal_id = ? AND flag_estado = '1'
                         """)) {
                ps.setLong(1, usuarioId);
                ps.setLong(2, sucursalId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.warn("countUsuarioSucursalEnTenant empresaId={}: {}", empresaId, e.getMessage());
            throw new BusinessException(
                    "No se pudo validar la asignación de sucursal en el tenant: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "TENANT_SUCURSAL_VALIDACION_ERROR");
        }
        return 0;
    }

    private record DatosSucursalTenant(String nombre, String ciudad) {}

    private String findAdminEmail() {
        try {
            return jdbcTemplate.queryForObject(
                    """
                    SELECT u.email FROM auth.usuario u
                    JOIN auth.rol_usuario ru ON ru.usuario_id = u.id AND ru.flag_estado = '1'
                    JOIN auth.rol r ON r.id = ru.rol_id AND r.es_admin = TRUE
                    WHERE u.flag_estado = '1' AND u.email IS NOT NULL
                    LIMIT 1
                    """,
                    String.class);
        } catch (Exception e) {
            log.warn("No se encontró email de administrador para alerta de bloqueo");
            return null;
        }
    }

    private DatosSucursalTenant obtenerDatosSucursalTenant(Long empresaId, Long sucursalId) {
        try {
            TenantConnectionInfoResponse conn = tenantConnectionService.getTenantConnection(empresaId);
            try (Connection tenantConn = DriverManager.getConnection(conn.getJdbcUrl(), conn.getUsername(), conn.getPassword());
                 PreparedStatement ps = tenantConn.prepareStatement(
                         "SELECT nombre, ciudad FROM auth.sucursal WHERE id = ? AND flag_estado = '1'")) {
                ps.setLong(1, sucursalId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return new DatosSucursalTenant(rs.getString("nombre"), rs.getString("ciudad"));
                }
                return null;
            }
        } catch (Exception e) {
            log.warn("Error al obtener datos de sucursal {}: {}", sucursalId, e.getMessage());
            return null;
        }
    }

    private void registrarLogAcceso(Long usuarioId, Long empresaId, String evento, boolean exito,
                                    String ip, String ipPrivada, String sistemaOperativo, String userAgent) {
        logAccesoService.registrar(
                usuarioId, empresaId, evento, exito, "INFO", ip, ipPrivada, sistemaOperativo, userAgent);
    }
}
