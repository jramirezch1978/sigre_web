package com.sigre.seguridad.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.seguridad.dto.AuthMeResponse;
import com.sigre.seguridad.dto.CodigoEmailResponse;
import com.sigre.seguridad.dto.PerfilUsuarioUpdateRequest;
import com.sigre.seguridad.entity.Usuario;
import com.sigre.seguridad.repository.UsuarioRepository;
import com.sigre.common.exception.BusinessException;

/**
 * Self-service de perfil (Facade sobre {@link UsuarioRepository} + {@link AuthCodigoService}).
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class PerfilUsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final AuthCodigoService authCodigoService;
    private final EmailService emailService;

    @Transactional(readOnly = true)
    public AuthMeResponse enriquecerDesdeBd(AuthMeResponse base, Long userId) {
        if (base == null || userId == null) {
            return base;
        }
        usuarioRepository.findById(userId).ifPresent(u -> {
            base.setUsername(u.getUsername());
            base.setEmail(u.getEmail());
            base.setNombres(u.getNombres());
            base.setApellidos(u.getApellidos());
            base.setNombreCompleto(u.getNombreCompleto());
            base.setNumeroDocumento(u.getNumeroDocumento());
            base.setFlagConfirmacionEmail("1".equals(u.getFlagConfirmacionEmail()));
            if (base.getUsuario() != null) {
                base.getUsuario().setUsername(u.getUsername());
                base.getUsuario().setEmail(u.getEmail());
                base.getUsuario().setNombres(u.getNombres());
                base.getUsuario().setApellidos(u.getApellidos());
            }
        });
        return base;
    }

    @Transactional
    public CodigoEmailResponse enviarCodigoConfirmacionEmail(long userId, String emailNuevo) {
        Usuario usuario = requireUsuario(userId);
        String email = normalize(emailNuevo);
        if (email.isBlank()) {
            throw new BusinessException("El correo es obligatorio", HttpStatus.BAD_REQUEST, "EMAIL_REQUERIDO");
        }
        validarEmailDisponible(usuario.getId(), email);

        AuthCodigoService.CodigoEmitido emitido = authCodigoService.emitir(
                usuario.getId(), AuthCodigoService.Proposito.CONFIRMACION_EMAIL);
        emailService.enviarCodigoConfirmacionEmail(email, emitido.codigo());
        log.info("Código confirmación email enviado userId={} destino={}", userId, email);
        return CodigoEmailResponse.builder()
                .validezSegundos(emitido.validezSegundos())
                .reenvioSegundos(emitido.reenvioSegundos())
                .emailDestino(email)
                .build();
    }

    @Transactional
    public AuthMeResponse actualizarPerfil(long userId, PerfilUsuarioUpdateRequest request) {
        Usuario usuario = requireUsuario(userId);
        String nombres = normalize(request.getNombres());
        String apellidos = normalize(request.getApellidos());
        String documento = normalize(request.getNumeroDocumento());
        String emailNuevo = normalize(request.getEmail());

        if (nombres.isBlank()) {
            throw new BusinessException("Los nombres son obligatorios", HttpStatus.BAD_REQUEST, "NOMBRES_REQUERIDOS");
        }
        if (emailNuevo.isBlank()) {
            throw new BusinessException("El correo es obligatorio", HttpStatus.BAD_REQUEST, "EMAIL_REQUERIDO");
        }

        String emailActual = usuario.getEmail() != null ? usuario.getEmail().trim() : "";
        boolean emailCambio = !emailNuevo.equalsIgnoreCase(emailActual);
        boolean emailSinConfirmar = !"1".equals(usuario.getFlagConfirmacionEmail());

        if (emailCambio || (emailSinConfirmar && !emailNuevo.isBlank())) {
            String codigo = request.getCodigoConfirmacionEmail();
            if (codigo == null || codigo.isBlank()) {
                throw new BusinessException(
                        "Debe verificar el correo con el código enviado",
                        HttpStatus.BAD_REQUEST, "CODIGO_EMAIL_REQUERIDO");
            }
            validarEmailDisponible(usuario.getId(), emailNuevo);
            authCodigoService.consumir(
                    usuario.getId(), codigo.trim(), AuthCodigoService.Proposito.CONFIRMACION_EMAIL);
            usuario.setEmail(emailNuevo);
            usuario.setFlagConfirmacionEmail("1");
        }

        usuario.setNombres(nombres);
        usuario.setApellidos(apellidos.isBlank() ? "" : apellidos);
        usuario.setNumeroDocumento(documento.isBlank() ? null : documento);
        String completo = (nombres + " " + (apellidos == null ? "" : apellidos)).trim();
        usuario.setNombreCompleto(completo);
        usuarioRepository.save(usuario);

        AuthMeResponse me = AuthMeResponse.builder()
                .userId(usuario.getId())
                .username(usuario.getUsername())
                .email(usuario.getEmail())
                .nombres(usuario.getNombres())
                .apellidos(usuario.getApellidos())
                .nombreCompleto(usuario.getNombreCompleto())
                .numeroDocumento(usuario.getNumeroDocumento())
                .flagConfirmacionEmail("1".equals(usuario.getFlagConfirmacionEmail()))
                .build();
        return me;
    }

    private void validarEmailDisponible(long userId, String email) {
        usuarioRepository.findByEmailIgnoreCase(email).ifPresent(otro -> {
            if (!otro.getId().equals(userId)) {
                throw new BusinessException(
                        "El correo ya está registrado por otro usuario",
                        HttpStatus.CONFLICT, "EMAIL_EN_USO");
            }
        });
    }

    private Usuario requireUsuario(long userId) {
        return usuarioRepository.findById(userId)
                .orElseThrow(() -> new BusinessException(
                        "Usuario no encontrado", HttpStatus.NOT_FOUND, "USUARIO_NO_ENCONTRADO"));
    }

    private static String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
