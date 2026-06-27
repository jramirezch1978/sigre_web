package com.sigre.seguridad.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.seguridad.dto.RegistroDemoRequest;
import com.sigre.seguridad.dto.RegistroDemoRequest.EmpresaDemo;
import com.sigre.seguridad.dto.RegistroDemoRequest.UsuarioDemo;
import com.sigre.seguridad.dto.seguridad.UbigeoLookupDto;
import com.sigre.seguridad.repository.EmpresaMasterRepository;
import com.sigre.seguridad.repository.UsuarioRepository;
import com.sigre.common.exception.BusinessException;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class RegistroDemoService {

    private static final int MAX_USUARIOS_DEMO = 5;
    private static final String DEMO_DB_HOST = "localhost";
    private static final int DEMO_DB_PORT = 5432;
    private static final String DEMO_DB_PREFIX = "sigre_demo_";
    private static final String DEMO_DB_USER = "sigre_demo";
    private static final String DEMO_DB_PASS_ENCRYPTED = "DEMO_NO_DB";

    private final JdbcTemplate jdbcTemplate;
    private final PasswordEncoder passwordEncoder;
    private final EmpresaMasterRepository empresaRepository;
    private final UsuarioRepository usuarioRepository;
    private final SeguridadService seguridadService;
    private final LicenciaService licenciaService;

    /** Resultado del alta demo: empresa creada, su BD destino y la licencia generada. */
    public record RegistroDemoResult(long empresaId, String dbName, LicenciaService.LicenciaDemo licencia) {}

    @Transactional
    public RegistroDemoResult registrarDemo(RegistroDemoRequest request) {
        EmpresaDemo emp = request.getEmpresa();
        UsuarioDemo admin = request.getAdminUser();
        List<UsuarioDemo> adicionales = request.getUsuariosAdicionales() != null
                ? request.getUsuariosAdicionales()
                : List.of();

        int totalUsuarios = 1 + adicionales.size();
        if (totalUsuarios > MAX_USUARIOS_DEMO) {
            throw new BusinessException(
                    "Una empresa demo no puede tener más de " + MAX_USUARIOS_DEMO + " usuarios.",
                    HttpStatus.BAD_REQUEST);
        }

        if (empresaRepository.existsByRuc(emp.getRuc())) {
            throw new BusinessException("Ya existe una empresa con el RUC " + emp.getRuc(), HttpStatus.CONFLICT);
        }

        if (usuarioRepository.findByUsernameAndActivoTrue(admin.getUsername()).isPresent()) {
            throw new BusinessException("El nombre de usuario '" + admin.getUsername() + "' ya está en uso.", HttpStatus.CONFLICT);
        }

        if (usuarioRepository.findByEmailAndActivoTrue(admin.getEmail()).isPresent()) {
            throw new BusinessException("El email '" + admin.getEmail() + "' ya está registrado.", HttpStatus.CONFLICT);
        }

        Long empresaCodigo = empresaRepository.nextEmpresaCodigo();
        String codigoEmpresa = String.format("DEMO%04d", empresaCodigo);
        String dbName = DEMO_DB_PREFIX + empresaCodigo;
        Long distritoId = resolverDistritoId(emp);

        Long empresaId = jdbcTemplate.queryForObject("""
                INSERT INTO master.empresa (codigo, ruc, razon_social, nombre_comercial,
                    direccion_fiscal, ubigeo, distrito_id, representante_legal, dni_representante_legal,
                    correo_contacto, telefono_contacto,
                    db_host, db_port, db_name, db_user, db_password_encrypted,
                    flag_demo, flag_estado)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, '1', '1')
                RETURNING id
                """, Long.class,
                codigoEmpresa, emp.getRuc(), emp.getRazonSocial(), emp.getNombreComercial(),
                emp.getDireccionFiscal(), emp.getUbigeo(), distritoId,
                emp.getRepresentanteLegal(), emp.getDniRepresentanteLegal(),
                emp.getCorreoContacto(), emp.getTelefonoContacto(),
                DEMO_DB_HOST, DEMO_DB_PORT, dbName, DEMO_DB_USER, DEMO_DB_PASS_ENCRYPTED);

        List<Long> userIds = new ArrayList<>();

        Long adminId = crearUsuarioDemo(admin);
        userIds.add(adminId);

        for (UsuarioDemo u : adicionales) {
            if (u.getUsername() == null || u.getUsername().isBlank()) continue;
            Long uid = crearUsuarioDemo(u);
            userIds.add(uid);
        }

        for (Long uid : userIds) {
            jdbcTemplate.update("""
                    INSERT INTO auth.usuario_empresa (usuario_id, empresa_id, flag_estado)
                    VALUES (?, ?, '1')
                    """, uid, empresaId);
        }

        Long rolId = jdbcTemplate.queryForObject("""
                INSERT INTO auth.rol (empresa_id, codigo, nombre, es_admin, flag_estado)
                VALUES (?, 'ADMIN', 'Administrador', true, '1')
                RETURNING id
                """, Long.class, empresaId);

        for (Long uid : userIds) {
            jdbcTemplate.update("""
                    INSERT INTO auth.rol_usuario (usuario_id, rol_id, flag_estado)
                    VALUES (?, ?, '1')
                    """, uid, rolId);
        }

        asignarMenuCompleto(rolId);

        // Licencia demo (edición Enterprise, 15 días). Su código + vencimiento se
        // devuelven para mostrarlos/enviarlos por correo.
        LicenciaService.LicenciaDemo licencia = licenciaService.crearLicenciaDemo(empresaId);

        log.info("Empresa demo registrada: {} (RUC: {}) con {} usuarios, licencia {} (vence {})",
                codigoEmpresa, emp.getRuc(), userIds.size(), licencia.codigo(), licencia.vencimiento());
        return new RegistroDemoResult(empresaId, dbName, licencia);
    }

    /** True si el usuario es demo (solo ellos pueden autogestionar usuarios de su empresa). */
    public boolean esUsuarioDemo(long usuarioId) {
        Integer n = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.usuario WHERE id = ? AND flag_demo = '1'", Integer.class, usuarioId);
        return n != null && n > 0;
    }

    /** Usuarios (activos e inactivos) de una empresa, para la autogestión demo. */
    public List<Map<String, Object>> listarUsuariosEmpresaDemo(long empresaId) {
        return jdbcTemplate.queryForList("""
                SELECT u.id, u.username, u.email, u.nombre_completo, u.flag_estado
                FROM auth.usuario u
                JOIN auth.usuario_empresa ue ON ue.usuario_id = u.id
                WHERE ue.empresa_id = ?
                ORDER BY u.nombre_completo
                """, empresaId);
    }

    /**
     * Agrega un usuario a una empresa demo. Reglas: el actor debe ser usuario demo,
     * la empresa debe ser demo y no superar {@value #MAX_USUARIOS_DEMO} usuarios.
     */
    @Transactional
    public void agregarUsuarioAEmpresaDemo(long actorId, long empresaId, UsuarioDemo nuevo) {
        if (!esUsuarioDemo(actorId)) {
            throw new BusinessException("Solo los usuarios demo pueden agregar usuarios.",
                    HttpStatus.FORBIDDEN);
        }
        Integer empDemo = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM master.empresa WHERE id = ? AND flag_demo = '1'", Integer.class, empresaId);
        if (empDemo == null || empDemo == 0) {
            throw new BusinessException("La empresa no es demo.", HttpStatus.UNPROCESSABLE_ENTITY);
        }
        Integer total = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM auth.usuario_empresa WHERE empresa_id = ? AND flag_estado = '1'",
                Integer.class, empresaId);
        if (total != null && total >= MAX_USUARIOS_DEMO) {
            throw new BusinessException("Una empresa demo no puede tener más de " + MAX_USUARIOS_DEMO + " usuarios.",
                    HttpStatus.UNPROCESSABLE_ENTITY);
        }
        if (nuevo.getUsername() == null || nuevo.getUsername().isBlank()) {
            throw new BusinessException("El nombre de usuario es requerido.", HttpStatus.BAD_REQUEST);
        }
        if (usuarioRepository.findByUsernameAndActivoTrue(nuevo.getUsername()).isPresent()) {
            throw new BusinessException("El usuario '" + nuevo.getUsername() + "' ya está en uso.", HttpStatus.CONFLICT);
        }
        if (nuevo.getEmail() != null && !nuevo.getEmail().isBlank()
                && usuarioRepository.findByEmailAndActivoTrue(nuevo.getEmail()).isPresent()) {
            throw new BusinessException("El email '" + nuevo.getEmail() + "' ya está registrado.", HttpStatus.CONFLICT);
        }

        Long uid = crearUsuarioDemo(nuevo);
        jdbcTemplate.update(
                "INSERT INTO auth.usuario_empresa (usuario_id, empresa_id, flag_estado) VALUES (?, ?, '1')",
                uid, empresaId);
        List<Long> roles = jdbcTemplate.queryForList(
                "SELECT id FROM auth.rol WHERE empresa_id = ? AND codigo = 'ADMIN' AND flag_estado = '1'",
                Long.class, empresaId);
        if (!roles.isEmpty()) {
            jdbcTemplate.update(
                    "INSERT INTO auth.rol_usuario (usuario_id, rol_id, flag_estado) VALUES (?, ?, '1')",
                    uid, roles.get(0));
        }
        log.info("Usuario demo '{}' agregado a empresa {} por usuario {}", nuevo.getUsername(), empresaId, actorId);
    }

    private Long resolverDistritoId(EmpresaDemo emp) {
        if (emp.getDistritoId() != null) {
            return emp.getDistritoId();
        }
        if (emp.getUbigeo() == null || emp.getUbigeo().isBlank()) {
            return null;
        }
        try {
            UbigeoLookupDto ubigeo = seguridadService.obtenerUbigeoPorCodigoDistrito(emp.getUbigeo());
            return ubigeo.getDistritoId();
        } catch (Exception ex) {
            log.warn("No se pudo resolver distrito para ubigeo {}: {}", emp.getUbigeo(), ex.getMessage());
            return null;
        }
    }

    private Long crearUsuarioDemo(UsuarioDemo u) {
        String nombreCompleto = u.getNombres() + (u.getApellidos() != null ? " " + u.getApellidos() : "");
        String passHash = passwordEncoder.encode(u.getPassword());

        return jdbcTemplate.queryForObject("""
                INSERT INTO auth.usuario (username, email, password, nombres, apellidos,
                    nombre_completo, flag_demo, flag_estado)
                VALUES (?, ?, ?, ?, ?, ?, '1', '1')
                RETURNING id
                """, Long.class,
                u.getUsername(), u.getEmail(), passHash,
                u.getNombres(), u.getApellidos() != null ? u.getApellidos() : "", nombreCompleto);
    }

    private void asignarMenuCompleto(Long rolId) {
        jdbcTemplate.update("""
                INSERT INTO auth.rol_opcion_menu (rol_id, opcion_menu_id, flag_estado)
                SELECT ?, om.id, '1'
                FROM auth.opcion_menu om
                WHERE om.flag_estado = '1'
                """, rolId);

        jdbcTemplate.update("""
                INSERT INTO auth.rol_opcion_menu_accion (rol_opcion_menu_id, accion_id, permitido, flag_estado)
                SELECT rom.id, a.id, true, '1'
                FROM auth.rol_opcion_menu rom
                CROSS JOIN auth.accion a
                WHERE rom.rol_id = ? AND a.flag_estado = '1'
                """, rolId);
    }
}
