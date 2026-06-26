package pe.restaurant.auth.service;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.auth.dto.seguridad.ActualizarUsuarioRequest;
import pe.restaurant.auth.dto.seguridad.CrearUsuarioRequest;
import pe.restaurant.auth.dto.seguridad.UsuarioAdminDto;
import pe.restaurant.auth.entity.Usuario;
import pe.restaurant.auth.repository.UsuarioRepository;
import pe.restaurant.common.exception.BusinessException;

import java.time.OffsetDateTime;
import java.util.List;

/**
 * CRUD de usuarios en {@code auth.usuario} para la sección de administración.
 * Solo consultas de lectura y escritura sobre la BD de seguridad; no toca tenants.
 */
@Service
@RequiredArgsConstructor
public class UsuarioAdminCrudService {

    private final UsuarioRepository usuarioRepository;
    private final JdbcTemplate jdbcTemplate;
    private final PasswordEncoder passwordEncoder;

    public List<UsuarioAdminDto> listarUsuarios() {
        return jdbcTemplate.query(
                """
                SELECT id, email, username, nombres, apellidos, nombre_completo,
                       flag_estado, bloqueado, flag_admin_sistema, fec_creacion
                FROM auth.usuario
                WHERE flag_estado = '1'
                ORDER BY nombre_completo
                """,
                (rs, i) -> UsuarioAdminDto.builder()
                        .id(rs.getLong("id"))
                        .email(rs.getString("email"))
                        .username(rs.getString("username"))
                        .nombres(rs.getString("nombres"))
                        .apellidos(rs.getString("apellidos"))
                        .nombreCompleto(rs.getString("nombre_completo"))
                        .activo("1".equals(rs.getString("flag_estado")))
                        .bloqueado(rs.getBoolean("bloqueado"))
                        .flagAdminSistema("1".equals(rs.getString("flag_admin_sistema")))
                        .fecCreacion(rs.getObject("fec_creacion", OffsetDateTime.class))
                        .build());
    }

    public UsuarioAdminDto obtenerUsuario(long id) {
        List<UsuarioAdminDto> list = jdbcTemplate.query(
                """
                SELECT id, email, username, nombres, apellidos, nombre_completo,
                       flag_estado, bloqueado, flag_admin_sistema, fec_creacion
                FROM auth.usuario WHERE id = ?
                """,
                (rs, i) -> UsuarioAdminDto.builder()
                        .id(rs.getLong("id"))
                        .email(rs.getString("email"))
                        .username(rs.getString("username"))
                        .nombres(rs.getString("nombres"))
                        .apellidos(rs.getString("apellidos"))
                        .nombreCompleto(rs.getString("nombre_completo"))
                        .activo("1".equals(rs.getString("flag_estado")))
                        .bloqueado(rs.getBoolean("bloqueado"))
                        .flagAdminSistema("1".equals(rs.getString("flag_admin_sistema")))
                        .fecCreacion(rs.getObject("fec_creacion", OffsetDateTime.class))
                        .build(),
                id);
        if (list.isEmpty()) {
            throw new BusinessException("Usuario no encontrado", HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND");
        }
        return list.get(0);
    }

    @Transactional
    public UsuarioAdminDto crearUsuario(CrearUsuarioRequest req) {
        if (usuarioRepository.existsByEmail(req.getEmail())) {
            throw new BusinessException("El email ya está registrado", HttpStatus.CONFLICT, "EMAIL_DUPLICADO");
        }

        Usuario entity = new Usuario();
        entity.setEmail(req.getEmail());
        entity.setUsername(req.getUsername());
        entity.setPassword(passwordEncoder.encode(req.getPassword()));
        entity.setNombres(req.getNombres());
        entity.setApellidos(req.getApellidos());
        entity.setNombreCompleto(req.getNombres() + " " + req.getApellidos());
        entity.setFlagEstado("1");
        entity.setBloqueado(false);
        entity.setDosFactorHabilitado(false);
        entity.setIntentosFallidos(0);
        entity.setFlagAdminSistema(req.getFlagAdminSistema() != null && req.getFlagAdminSistema() ? "1" : "0");

        entity = usuarioRepository.save(entity);
        return obtenerUsuario(entity.getId());
    }

    @Transactional
    public UsuarioAdminDto actualizarUsuario(long id, ActualizarUsuarioRequest req) {
        Usuario entity = usuarioRepository.findById(id)
                .orElseThrow(() -> new BusinessException("Usuario no encontrado", HttpStatus.NOT_FOUND, "RESOURCE_NOT_FOUND"));

        if (req.getEmail() != null && !req.getEmail().isBlank()) {
            entity.setEmail(req.getEmail());
        }
        if (req.getUsername() != null && !req.getUsername().isBlank()) {
            entity.setUsername(req.getUsername());
        }
        if (req.getNombres() != null && !req.getNombres().isBlank()) {
            entity.setNombres(req.getNombres());
        }
        if (req.getApellidos() != null && !req.getApellidos().isBlank()) {
            entity.setApellidos(req.getApellidos());
        }
        entity.setNombreCompleto(entity.getNombres() + " " + entity.getApellidos());

        if (req.getActivo() != null) {
            entity.setActivo(req.getActivo());
        }
        if (req.getBloqueado() != null) {
            entity.setBloqueado(req.getBloqueado());
            if (!req.getBloqueado()) {
                entity.setIntentosFallidos(0);
                entity.setBloqueadoHasta(null);
            }
        }
        if (req.getFlagAdminSistema() != null) {
            entity.setFlagAdminSistema(req.getFlagAdminSistema() ? "1" : "0");
        }

        usuarioRepository.save(entity);
        return obtenerUsuario(id);
    }

    public List<UsuarioAdminDto> listarUsuariosDeEmpresa(long empresaId) {
        return jdbcTemplate.query(
                """
                SELECT u.id, u.email, u.username, u.nombres, u.apellidos, u.nombre_completo,
                       u.flag_estado, u.bloqueado, u.flag_admin_sistema, u.fec_creacion
                FROM auth.usuario u
                JOIN auth.usuario_empresa ue ON ue.usuario_id = u.id
                WHERE ue.empresa_id = ? AND ue.flag_estado = '1' AND u.flag_estado = '1'
                ORDER BY u.nombre_completo
                """,
                (rs, i) -> UsuarioAdminDto.builder()
                        .id(rs.getLong("id"))
                        .email(rs.getString("email"))
                        .username(rs.getString("username"))
                        .nombres(rs.getString("nombres"))
                        .apellidos(rs.getString("apellidos"))
                        .nombreCompleto(rs.getString("nombre_completo"))
                        .activo("1".equals(rs.getString("flag_estado")))
                        .bloqueado(rs.getBoolean("bloqueado"))
                        .flagAdminSistema("1".equals(rs.getString("flag_admin_sistema")))
                        .fecCreacion(rs.getObject("fec_creacion", OffsetDateTime.class))
                        .build(),
                empresaId);
    }
}
