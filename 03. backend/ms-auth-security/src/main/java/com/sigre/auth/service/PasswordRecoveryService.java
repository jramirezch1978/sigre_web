package com.sigre.auth.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.auth.entity.Usuario;
import com.sigre.auth.repository.UsuarioRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.util.AesEncryptor;

import javax.sql.DataSource;
import java.security.SecureRandom;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

@Slf4j
@Service
public class PasswordRecoveryService {

    private static final int CODIGO_VALIDITY_MINUTES = 5;
    private static final String MAYUSCULAS = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    private static final String MINUSCULAS = "abcdefghijkmnopqrstuvwxyz";
    private static final String NUMEROS = "0123456789";

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;
    private final AesEncryptor aesEncryptor;
    private final EmailService emailService;
    private final JdbcTemplate jdbcTemplate;

    public PasswordRecoveryService(
            UsuarioRepository usuarioRepository,
            PasswordEncoder passwordEncoder,
            AesEncryptor aesEncryptor,
            EmailService emailService,
            DataSource dataSource) {
        this.usuarioRepository = usuarioRepository;
        this.passwordEncoder = passwordEncoder;
        this.aesEncryptor = aesEncryptor;
        this.emailService = emailService;
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public String obtenerEmailOfuscado(String username) {
        Usuario usuario = usuarioRepository.findByUsernameAndActivoTrue(username)
                .orElseThrow(() -> new BusinessException(
                        "No se encontró una cuenta con ese usuario",
                        HttpStatus.NOT_FOUND, "USUARIO_NO_ENCONTRADO"));
        return ocultarEmail(usuario.getEmail());
    }

    public String verificarEmail(String email) {
        Usuario usuario = findUsuarioByEmail(email);
        return ocultarEmail(usuario.getEmail());
    }

    @Transactional
    public void enviarCodigo(String email) {
        Usuario usuario = findUsuarioByEmail(email);

        jdbcTemplate.update(
                "UPDATE auth.codigo_recuperacion SET usado = TRUE WHERE usuario_id = ? AND usado = FALSE",
                usuario.getId());

        String codigo = generarCodigo();
        OffsetDateTime expiraEn = OffsetDateTime.now().plusMinutes(CODIGO_VALIDITY_MINUTES);

        jdbcTemplate.update(
                """
                INSERT INTO auth.codigo_recuperacion (usuario_id, codigo, expira_en, usado, fec_creacion)
                VALUES (?, ?, ?, FALSE, NOW())
                """,
                usuario.getId(), codigo, expiraEn);

        emailService.enviarCodigoRecuperacion(usuario.getEmail(), codigo);

        log.info("Código de recuperación enviado para usuario={}", usuario.getUsername());
    }

    @Transactional(readOnly = true)
    public void validarCodigo(String email, String codigo) {
        Usuario usuario = findUsuarioByEmail(email);

        Integer count = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*) FROM auth.codigo_recuperacion
                WHERE usuario_id = ? AND codigo = ? AND usado = FALSE AND expira_en > NOW()
                """,
                Integer.class, usuario.getId(), codigo);

        if (count == null || count == 0) {
            throw new BusinessException(
                    "Código inválido o expirado",
                    HttpStatus.BAD_REQUEST, "CODIGO_INVALIDO");
        }
    }

    @Transactional
    public void cambiarPassword(String email, String codigo, String nuevaPasswordEncriptada, String nuevaPasswordHash) {
        Usuario usuario = findUsuarioByEmail(email);

        Integer count = jdbcTemplate.queryForObject(
                """
                SELECT COUNT(*) FROM auth.codigo_recuperacion
                WHERE usuario_id = ? AND codigo = ? AND usado = FALSE AND expira_en > NOW()
                """,
                Integer.class, usuario.getId(), codigo);

        if (count == null || count == 0) {
            throw new BusinessException(
                    "Código inválido o expirado",
                    HttpStatus.BAD_REQUEST, "CODIGO_INVALIDO");
        }

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

        jdbcTemplate.update(
                "UPDATE auth.codigo_recuperacion SET usado = TRUE WHERE usuario_id = ? AND codigo = ?",
                usuario.getId(), codigo);

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

    private Usuario findUsuarioByEmail(String email) {
        return usuarioRepository.findByEmailAndActivoTrue(email)
                .orElseThrow(() -> new BusinessException(
                        "No se encontró una cuenta con ese correo electrónico",
                        HttpStatus.NOT_FOUND, "EMAIL_NO_ENCONTRADO"));
    }

    private String generarCodigo() {
        SecureRandom random = new SecureRandom();
        String codigo;
        do {
            List<Character> chars = new ArrayList<>(8);
            for (int i = 0; i < 4; i++)
                chars.add(NUMEROS.charAt(random.nextInt(NUMEROS.length())));
            for (int i = 0; i < 2; i++)
                chars.add(MAYUSCULAS.charAt(random.nextInt(MAYUSCULAS.length())));
            for (int i = 0; i < 2; i++)
                chars.add(MINUSCULAS.charAt(random.nextInt(MINUSCULAS.length())));
            Collections.shuffle(chars, random);
            StringBuilder sb = new StringBuilder(8);
            chars.forEach(sb::append);
            codigo = sb.toString();
        } while (codigoExiste(codigo));
        return codigo;
    }

    private boolean codigoExiste(String codigo) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.codigo_recuperacion WHERE codigo = ? AND usado = FALSE",
                Integer.class, codigo);
        return count != null && count > 0;
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
