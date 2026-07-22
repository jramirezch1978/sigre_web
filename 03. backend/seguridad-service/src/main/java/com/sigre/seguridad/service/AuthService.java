package com.sigre.seguridad.service;

import com.sigre.seguridad.dto.*;

import java.util.List;

public interface AuthService {

    LoginResponse login(LoginRequest request);

    /**
     * Login sin verificación Turnstile. Útil para pruebas con Postman.
     * Requiere credenciales válidas (email + contraseña). No omite bloqueo por intentos fallidos.
     */
    LoginResponse loginDev(LoginRequest request);

    /**
     * Login para apps móviles nativas (sin Cloudflare Turnstile, que es un widget web):
     * en su lugar exige que {@code request.getNroRegistroDispositivo()} corresponda a un
     * dispositivo ya registrado y autorizado en {@code auth.dispositivo}.
     */
    LoginResponse loginMobile(LoginRequest request);

    List<EmpresaUsuarioDto> listarEmpresas(Long usuarioId);

    /**
     * Sucursales asignadas al usuario en el tenant de la empresa (token temporal OK).
     * Usado en el flujo de login móvil/web antes de {@code /seleccionar-empresa}.
     */
    List<SucursalDto> listarSucursalesDelUsuario(Long usuarioId, Long empresaId);

    LoginResponse seleccionarEmpresa(Long usuarioId, SeleccionEmpresaRequest request);

    /**
     * Valida email/contraseña como en {@link #login(LoginRequest)} sin emitir token temporal.
     * Usado por {@code POST /seleccionar-empresa} cuando no se envía {@code Authorization}.
     */
    Long authenticateCredentialsForSeleccionEmpresa(SeleccionEmpresaRequest request);

    void logout(Long usuarioId, String bearerToken);

    RefreshTokenResponse refreshToken(RefreshTokenRequest request);

    AuthMeResponse getProfile(String accessToken);
}
