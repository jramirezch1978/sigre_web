package com.sigre.seguridad.service;

import com.sigre.seguridad.model.dto.LoginRequest;
import com.sigre.seguridad.model.dto.LoginResponse;
import com.sigre.seguridad.model.entity.Permiso;
import com.sigre.seguridad.model.entity.Rol;
import com.sigre.seguridad.model.entity.Usuario;
import com.sigre.seguridad.repository.UsuarioRepository;
import com.sigre.seguridad.security.JwtUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Set;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * Servicio de Autenticación
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtUtil jwtUtil;
    private final RedisTemplate<String, String> redisTemplate;

    /**
     * Autentica un usuario y genera tokens JWT
     */
    @Transactional
    public LoginResponse login(LoginRequest request) {
        log.info("Intento de login para usuario: {}", request.getUsuario());

        // Buscar usuario con roles y permisos
        Usuario usuario = usuarioRepository.findByIdWithRolesAndPermissions(request.getUsuario())
            .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        // Validar que el usuario esté activo
        if (!usuario.isActivo()) {
            log.warn("Intento de login con usuario inactivo: {}", request.getUsuario());
            throw new RuntimeException("Usuario inactivo o bloqueado");
        }

        // Validar contraseña
        if (!passwordEncoder.matches(request.getPassword(), usuario.getPassword())) {
            // Incrementar intentos fallidos
            usuario.setIntentosFallidos(usuario.getIntentosFallidos() != null ? 
                usuario.getIntentosFallidos() + 1 : 1);
            
            // Bloquear si supera 5 intentos
            if (usuario.getIntentosFallidos() >= 5) {
                usuario.setBloqueado("S");
                log.warn("Usuario bloqueado por intentos fallidos: {}", request.getUsuario());
            }
            
            usuarioRepository.save(usuario);
            throw new RuntimeException("Credenciales inválidas");
        }

        // Login exitoso - resetear intentos fallidos
        usuario.setIntentosFallidos(0);
        usuario.setUltimoAcceso(LocalDateTime.now());
        usuarioRepository.save(usuario);

        // Generar tokens
        String token = jwtUtil.generateToken(usuario);
        String refreshToken = jwtUtil.generateRefreshToken(usuario.getCodUser());

        // Guardar en Redis para validación rápida
        String redisKey = "token:" + usuario.getCodUser();
        redisTemplate.opsForValue().set(redisKey, token, jwtUtil.getExpirationTime(), TimeUnit.SECONDS);

        // Extraer roles y permisos
        Set<String> roles = usuario.getRoles().stream()
            .map(Rol::getCodRol)
            .collect(Collectors.toSet());

        Set<String> permisos = usuario.getRoles().stream()
            .flatMap(rol -> rol.getPermisos().stream())
            .map(Permiso::getCodPermiso)
            .collect(Collectors.toSet());

        log.info("Login exitoso para usuario: {}", request.getUsuario());

        return LoginResponse.builder()
            .token(token)
            .refreshToken(refreshToken)
            .tipo("Bearer")
            .usuario(usuario.getCodUser())
            .nombreCompleto(usuario.getNomUser())
            .email(usuario.getEmail())
            .empresa(usuario.getEmpresa())
            .roles(roles)
            .permisos(permisos)
            .expiresIn(jwtUtil.getExpirationTime())
            .build();
    }

    /**
     * Cierra sesión invalidando el token
     */
    public void logout(String usuario) {
        String redisKey = "token:" + usuario;
        redisTemplate.delete(redisKey);
        log.info("Logout exitoso para usuario: {}", usuario);
    }

    /**
     * Refresca el token JWT
     */
    public LoginResponse refreshToken(String refreshToken) {
        if (!jwtUtil.validateToken(refreshToken)) {
            throw new RuntimeException("Refresh token inválido");
        }

        String usuario = jwtUtil.getUserFromToken(refreshToken);
        Usuario user = usuarioRepository.findByIdWithRolesAndPermissions(usuario)
            .orElseThrow(() -> new RuntimeException("Usuario no encontrado"));

        String newToken = jwtUtil.generateToken(user);
        String newRefreshToken = jwtUtil.generateRefreshToken(user.getCodUser());

        // Actualizar en Redis
        String redisKey = "token:" + user.getCodUser();
        redisTemplate.opsForValue().set(redisKey, newToken, jwtUtil.getExpirationTime(), TimeUnit.SECONDS);

        Set<String> roles = user.getRoles().stream()
            .map(Rol::getCodRol)
            .collect(Collectors.toSet());

        Set<String> permisos = user.getRoles().stream()
            .flatMap(rol -> rol.getPermisos().stream())
            .map(Permiso::getCodPermiso)
            .collect(Collectors.toSet());

        return LoginResponse.builder()
            .token(newToken)
            .refreshToken(newRefreshToken)
            .tipo("Bearer")
            .usuario(user.getCodUser())
            .nombreCompleto(user.getNomUser())
            .email(user.getEmail())
            .empresa(user.getEmpresa())
            .roles(roles)
            .permisos(permisos)
            .expiresIn(jwtUtil.getExpirationTime())
            .build();
    }
}

