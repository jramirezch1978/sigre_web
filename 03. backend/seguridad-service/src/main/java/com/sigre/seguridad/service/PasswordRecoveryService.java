package com.sigre.seguridad.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.seguridad.entity.Usuario;
import com.sigre.seguridad.repository.UsuarioRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.util.AesEncryptor;

import javax.sql.DataSource;

@Slf4j
@Service
public class PasswordRecoveryService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final AesEncryptor aesEncryptor;
    private final EmailService emailService;
    private final AuthCodigoService authCodigoService;
    private final JdbcTemplate jdbcTemplate;

    public PasswordRecoveryService(
            UsuarioRepository usuarioRepository,
            PasswordEncoder passwordEncoder,
            AesEncryptor aesEncryptor,
            EmailService emailService,
            AuthCodigoService authCodigoService,
            DataSource dataSource) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.aesEncryptor = aesEncryptor;
        this.emailService = emailService;
        this.authCodigoService = authCodigoService;
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public String obtenerEmailOfuscado(String usernameOrEmail) {
        Usuario usuario = findUsuarioByUsernameOrEmail(normalizeLogin(usernameOrEmail));
        return ocultarEmail(usuario.getEmail());
    }

    public String verificarEmail(String email) {
        Usuario usuario = findUsuarioByEmail(email);
        return ocultarEmail(usuario.getEmail());
    }

    @Transactional
    public void enviarCodigo(String email) {
        Usuario usuario = findUsuarioByEmail(email);
        AuthCodigoService.CodigoEmitido emitido = authCodigoService.emitir(
                usuario.getId(), AuthCodigoService.Proposito.RECUPERACION);
        emailService.enviarCodigoRecuperacion(usuario.getEmail(), emitido.codigo());
        log.info("Código de recuperación enviado para usuario={}", usuario.getUsername());
    }

    @Transactional(readOnly = true)
    public void validarCodigo(String email, String codigo) {
        Usuario usuario = findUsuarioByEmail(email);
        authCodigoService.validar(usuario.getId(), codigo, AuthCodigoService.Proposito.RECUPERACION);
    }

    @Transactional
    public void cambiarPassword(String email, String codigo, String nuevaPasswordEncriptada, String nuevaPasswordHash) {
        Usuario usuario = findUsuarioByEmail(email);
        authCodigoService.consumir(usuario.getId(), codigo, AuthCodigoService.Proposito.RECUPERACION);

        String plainPassword;
        try {
            if (nuevaPasswordHash != null && !nuevaPasswordHash.isBlank()) {
                plainPassword = aesEncryptor.decryptAndVerify(nuevaPasswordEncriptada, nuevaPasswordHash);
            } else {
                plainPassword = aesEncryptor.decryptFromFrontend(nuevaPasswordEncriptada);
            }
        } catch (Exception e) {
            throw new BusinessException("Error al procesar la nueva contraseña",
                    HttpStatus.BAD_REQUEST, "PASSWORD_DECRYPT_ERROR");
        }

        validarComplejidad(plainPassword);

        usuario.setPassword(passwordEncoder.encode(plainPassword));
        usuario.setIntentosFallidos(0);
        usuario.setBloqueado(false);
        usuario.setBloqueadoHasta(null);
        usuarioRepository.save(usuario);

        log.info("Contraseña cambiada exitosamente para usuario={}", usuario.getUsername());
    }

    @Async
    @Transactional
    public void desactivarCodigosExpiradosAsync() {
        int actualizados = jdbcTemplate.update(
                "UPDATE auth.codigo_recuperacion SET usado = TRUE WHERE usado = FALSE AND expira_en <= NOW()");
        if (actualizados > 0) {
            log.info("Códigos expirados desactivados: {}", actualizados);
        }
    }

    private String normalizeLogin(String value) {
        return value == null ? "" : value.trim();
    }

    private Usuario findUsuarioByEmail(String email) {
        return usuarioRepository.findByEmailAndActivoTrue(normalizeLogin(email))
                .orElseThrow(() -> new BusinessException(
                        "No se encontró una cuenta con ese correo electrónico",
                        HttpStatus.NOT_FOUND, "EMAIL_NO_ENCONTRADO"));
    }

    private Usuario findUsuarioByUsernameOrEmail(String usernameOrEmail) {
        String login = normalizeLogin(usernameOrEmail);
        return usuarioRepository.findByEmailAndActivoTrue(login)
                .or(() -> usuarioRepository.findByUsernameAndActivoTrue(login))
                .orElseThrow(() -> new BusinessException(
                        "No se encontró una cuenta con ese usuario o correo",
                        HttpStatus.NOT_FOUND, "USUARIO_NO_ENCONTRADO"));
    }

    private String ocultarEmail(String email) {
        int atIndex = email.indexOf('@');
        if (atIndex <= 2) return email;

        String local = email.substring(0, atIndex);
        String localOculto = local.substring(0, 1)
                + "*".repeat(Math.max(1, local.length() - 2))
                + local.substring(local.length() - 1);

        String domainFull = email.substring(atIndex + 1);
        String[] partes = domainFull.split("\\.");

        StringBuilder dominioOculto = new StringBuilder();
        for (int i = 0; i < partes.length; i++) {
            if (i > 0) dominioOculto.append('.');
            String parte = partes[i];
            if (i == partes.length - 1) {
                dominioOculto.append(parte);
            } else if (parte.length() <= 2) {
                dominioOculto.append("*".repeat(parte.length()));
            } else {
                dominioOculto.append(parte.charAt(0))
                        .append("*".repeat(parte.length() - 2))
                        .append(parte.charAt(parte.length() - 1));
            }
        }

        return localOculto + "@" + dominioOculto;
    }

    private void validarComplejidad(String password) {
        if (password.length() < 8) {
            throw new BusinessException("La contraseña debe tener al menos 8 caracteres",
                    HttpStatus.BAD_REQUEST, "PASSWORD_MUY_CORTA");
        }
        if (!password.matches(".*[A-Z].*")) {
            throw new BusinessException("La contraseña debe contener al menos una mayúscula",
                    HttpStatus.BAD_REQUEST, "PASSWORD_SIN_MAYUSCULA");
        }
        if (!password.matches(".*[a-z].*")) {
            throw new BusinessException("La contraseña debe contener al menos una minúscula",
                    HttpStatus.BAD_REQUEST, "PASSWORD_SIN_MINUSCULA");
        }
        if (!password.matches(".*\\d.*")) {
            throw new BusinessException("La contraseña debe contener al menos un número",
                    HttpStatus.BAD_REQUEST, "PASSWORD_SIN_NUMERO");
        }
        if (!password.matches(".*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>/?].*")) {
            throw new BusinessException("La contraseña debe contener al menos un carácter especial",
                    HttpStatus.BAD_REQUEST, "PASSWORD_SIN_ESPECIAL");
        }
    }
}
