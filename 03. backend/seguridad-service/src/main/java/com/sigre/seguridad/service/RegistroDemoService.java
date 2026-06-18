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

    @Transactional
    public void registrarDemo(RegistroDemoRequest request) {
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

        log.info("Empresa demo registrada: {} (RUC: {}) con {} usuarios",
                codigoEmpresa, emp.getRuc(), userIds.size());
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
