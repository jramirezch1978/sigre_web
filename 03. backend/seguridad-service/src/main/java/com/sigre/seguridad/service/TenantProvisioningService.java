package com.sigre.seguridad.service;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.sql.DataSource;
import com.sigre.seguridad.dto.ActualizarCredencialesBdRequest;
import com.sigre.seguridad.dto.ActualizarCredencialesBdResponse;
import com.sigre.seguridad.dto.DeleteEmpresaResponse;
import com.sigre.seguridad.dto.EmpresaLogoUploadResponse;
import com.sigre.seguridad.dto.EnviarCorreoBienvenidaResponse;
import com.sigre.seguridad.dto.EmpresaRegistroEmailDto;
import com.sigre.seguridad.dto.ProvisionEmpresaRequest;
import com.sigre.seguridad.dto.ProvisionEmpresaResponse;
import com.sigre.seguridad.dto.RecreateEmpresaRequest;
import com.sigre.seguridad.dto.RecreateEmpresaResponse;
import com.sigre.seguridad.entity.master.EmpresaMaster;
import com.sigre.seguridad.dto.seguridad.UbigeoResumenDto;
import com.sigre.seguridad.repository.EmpresaMasterRepository;
import com.sigre.common.exception.BusinessException;
import com.sigre.common.util.AesEncryptor;

import java.time.Instant;
import java.time.ZoneId;
import java.time.format.DateTimeFormatter;
import java.text.Normalizer;
import java.util.List;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * Provisionamiento de tenant: clonación de BD + datos en tenant + registro en {@code master.empresa} (BD security).
 * <p>
 * <strong>Orden estrictamente secuencial</strong> (no paralelo):
 * <ol>
 *   <li>Validar que no exista la BD ni el registro lógico.</li>
 *   <li>Crear la base ({@code CREATE DATABASE ... TEMPLATE}) — debe completarse antes del resto.</li>
 *   <li>Insertar fila en {@code master.empresa} en la BD security (la ficha de empresa no se duplica en {@code core.empresa} del tenant).</li>
 * </ol>
 * No hay transacción distribuida entre dos instancias PostgreSQL: ejecutar CREATE e INSERT en hilos distintos
 * rompería la atomicidad y el orden de dependencias. Si algún paso falla tras avanzar, se aplica
 * <strong>compensación</strong>: borrar registro en security (si llegó a insertarse) y {@code DROP DATABASE} si la BD se creó.
 */
@Slf4j
@Service
public class TenantProvisioningService {

    private static final Pattern SLUG_SAFE = Pattern.compile("^[a-z0-9_]{1,44}$");
    private static final Set<String> RESERVED_DB_NAMES = Set.of(
            "postgres", "template0", "template1", "rdsadmin",
            "sigre_template", "sigre_security"
    );
    private static final int MAX_LOGO_BYTES = 5 * 1024 * 1024;

    private static final Pattern EMAIL_PATTERN = Pattern.compile("^[\\w.+-]+@[\\w.-]+\\.[A-Za-z]{2,}$");
    private static final DateTimeFormatter FECHA_REGISTRO_FMT =
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm").withZone(ZoneId.of("America/Lima"));

    private final EmpresaMasterRepository empresaMasterRepository;
    private final JdbcTemplate adminJdbcTemplate;
    private final JdbcTemplate securityJdbcTemplate;
    private final AesEncryptor aesEncryptor;
    private final EmailService emailService;
    private final SeguridadService seguridadService;

    @Value("${app.tenant.template-database:sigre_template}")
    private String templateDatabase;

    @Value("${app.tenant.db-name-prefix:sigre_emp_}")
    private String dbNamePrefix;

    @Value("${app.tenant.default-db-host:localhost}")
    private String defaultDbHost;

    @Value("${app.tenant.default-db-port:5432}")
    private int defaultDbPort;

    @Value("${app.tenant.jdbc-ssl-mode:require}")
    private String jdbcSslMode;

    @Value("${spring.datasource.username}")
    private String provisioningDbUsername;

    @Value("${spring.datasource.password}")
    private String provisioningDbPassword;

    public TenantProvisioningService(
            EmpresaMasterRepository empresaMasterRepository,
            @Qualifier("adminJdbcTemplate") JdbcTemplate adminJdbcTemplate,
            DataSource dataSource,
            AesEncryptor aesEncryptor,
            EmailService emailService,
            SeguridadService seguridadService) {
        this.empresaMasterRepository = empresaMasterRepository;
        this.adminJdbcTemplate = adminJdbcTemplate;
        this.securityJdbcTemplate = new JdbcTemplate(dataSource);
        this.aesEncryptor = aesEncryptor;
        this.emailService = emailService;
        this.seguridadService = seguridadService;
    }

    @Transactional
    public ProvisionEmpresaResponse provision(ProvisionEmpresaRequest req) {
        String host = req.getDbHost() != null && !req.getDbHost().isBlank() ? req.getDbHost() : defaultDbHost;
        int port = req.getDbPort() != null ? req.getDbPort() : defaultDbPort;

        validatePreconditions(req);

        String slug = resolveTenantSlug(req);
        String dbName = dbNamePrefix + slug;

        if (!SLUG_SAFE.matcher(slug).matches()) {
            throw new BusinessException("Slug de tenant invalido tras normalizar: " + slug, HttpStatus.BAD_REQUEST, "TENANT_SLUG_INVALIDO");
        }
        if (RESERVED_DB_NAMES.contains(dbName)) {
            throw new BusinessException("Nombre de base reservado: " + dbName, HttpStatus.BAD_REQUEST, "DB_NOMBRE_RESERVADO");
        }
        if (empresaMasterRepository.existsByDbName(dbName)) {
            throw new BusinessException("Ya existe una empresa con sigla/dbName '" + dbName + "'. La sigla no puede repetirse.", HttpStatus.CONFLICT, "SIGLA_DUPLICADA");
        }
        if (Boolean.TRUE.equals(databaseExists(dbName))) {
            throw new BusinessException("Ya existe la base de datos PostgreSQL: " + dbName, HttpStatus.CONFLICT, "DB_FISICA_EXISTE");
        }

        TenantDbCredentials tenantDb = resolveTenantDbCredentials(req, slug);

        boolean dbCreated = false;
        Long masterEmpresaId = null;

        try {
            assertDatabaseAbsentBeforeCreate(dbName);

            createDatabaseFromTemplate(dbName, provisioningDbUsername);
            dbCreated = true;

            String codigo = generateNextCodigo();
            req.setCodigo(codigo);

            EmpresaMaster saved = saveMasterEmpresa(req, host, port, dbName, tenantDb);
            masterEmpresaId = saved.getId();

            ensureTenantRoleAndPrivileges(saved, tenantDb);

            notificarRegistroEmpresa(req, saved, slug, host, port);

            return ProvisionEmpresaResponse.builder()
                    .exitoso(true)
                    .mensaje("Empresa registrada y base clonada correctamente")
                    .empresaId(saved.getId())
                    .codigo(saved.getCodigo())
                    .ruc(saved.getRuc())
                    .dbName(saved.getDbName())
                    .tenantDbUser(tenantDb.user())
                    .dbHost(saved.getDbHost())
                    .dbPort(saved.getDbPort())
                    .build();
        } catch (BusinessException e) {
            rollbackProvisioning(dbName, dbCreated, masterEmpresaId);
            throw e;
        } catch (Exception e) {
            rollbackProvisioning(dbName, dbCreated, masterEmpresaId);
            log.error("Fallo provisionamiento tenant {}", dbName, e);
            throw new BusinessException("Error al provisionar empresa: " + e.getMessage(), HttpStatus.INTERNAL_SERVER_ERROR, "PROVISION_ERROR");
        }
    }

    /**
     * Provisiona físicamente la BD de una empresa demo YA registrada: clona el template
     * y deja credenciales reales (rol + grants) para que el ERP pueda conectarse.
     * NO es transaccional a propósito: CREATE DATABASE no puede ir dentro de una transacción,
     * por eso se llama después de confirmar el registro demo.
     */
    public void provisionarBaseDatosDemo(long empresaId) {
        EmpresaMaster emp = empresaMasterRepository.findById(empresaId)
                .orElseThrow(() -> new BusinessException("Empresa demo no encontrada: " + empresaId,
                        HttpStatus.NOT_FOUND, "EMPRESA_NO_ENCONTRADA"));
        String dbName = emp.getDbName();
        if (Boolean.TRUE.equals(databaseExists(dbName))) {
            log.info("BD demo {} ya existe; no se reaprovisiona", dbName);
            return;
        }
        TenantDbCredentials creds = new TenantDbCredentials(
                dbName, java.util.UUID.randomUUID().toString().replace("-", ""));
        createDatabaseFromTemplate(dbName, provisioningDbUsername);
        securityJdbcTemplate.update(
                "UPDATE master.empresa SET db_user = ?, db_password_encrypted = ? WHERE id = ?",
                creds.user(), aesEncryptor.encrypt(creds.password()), empresaId);
        ensureTenantRoleAndPrivileges(emp, creds);
        log.info("BD demo {} provisionada (empresa {}, rol {})", dbName, empresaId, creds.user());
    }

    /**
     * Elimina empresa: borra registro en {@code master.empresa} y la BD física.
     * Proceso atómico: si no se puede eliminar la BD, se revierte el borrado del registro.
     * Acepta búsqueda por {@code codigo}, {@code ruc} o {@code dbName} (al menos uno requerido).
     * Si se envían varios parámetros, todos deben coincidir con el mismo registro.
     */
    @Transactional
    public DeleteEmpresaResponse deprovision(String codigo, String ruc, String dbName) {
        if (isBlank(codigo) && isBlank(ruc) && isBlank(dbName)) {
            throw new BusinessException(
                    "Debe enviar al menos uno: codigo, ruc o dbName",
                    HttpStatus.BAD_REQUEST, "PARAMETRO_REQUERIDO");
        }

        EmpresaMaster empresa = resolveEmpresa(codigo, ruc, dbName);

        String targetDbName = empresa.getDbName();
        Long empresaId = empresa.getId();
        String empresaCodigo = empresa.getCodigo();
        String empresaRuc = empresa.getRuc();

        if (RESERVED_DB_NAMES.contains(targetDbName)) {
            throw new BusinessException(
                    "No se puede eliminar una base protegida: " + targetDbName,
                    HttpStatus.FORBIDDEN, "DB_PROTEGIDA");
        }

        boolean registroEliminado = false;

        try {
            eliminarRelacionesEmpresaEnSecurity(empresaId);
            empresaMasterRepository.deleteById(empresaId);
            registroEliminado = true;
            log.info("Eliminado master.empresa id={} codigo={} ruc={} dbName={}",
                    empresaId, empresaCodigo, empresaRuc, targetDbName);

            if (Boolean.TRUE.equals(databaseExists(targetDbName))) {
                terminateConnections(targetDbName);
                adminJdbcTemplate.execute("DROP DATABASE " + quoteIdent(targetDbName));
                log.info("DROP DATABASE {} completado", targetDbName);
            } else {
                log.warn("La BD fisica {} no existia; solo se elimino el registro", targetDbName);
            }

            String mensaje = String.format("Empresa %s (RUC %s) y base %s eliminadas correctamente",
                    empresaCodigo, empresaRuc, targetDbName);
            return DeleteEmpresaResponse.builder()
                    .empresaId(empresaId)
                    .codigo(empresaCodigo)
                    .ruc(empresaRuc)
                    .dbName(targetDbName)
                    .mensaje(mensaje)
                    .build();

        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            if (registroEliminado) {
                try {
                    empresaMasterRepository.save(empresa);
                    log.warn("Rollback: restaurado master.empresa id={} tras fallo en DROP DATABASE", empresaId);
                } catch (Exception rollbackEx) {
                    log.error("Rollback fallido: no se pudo restaurar master.empresa id={}; inconsistencia manual",
                            empresaId, rollbackEx);
                }
            }
            log.error("Fallo eliminacion de empresa {} / BD {}", empresaCodigo, targetDbName, e);
            throw new BusinessException(
                    "Error al eliminar empresa: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "DEPROVISION_ERROR");
        }
    }

    /**
     * Actualiza usuario y contraseña del rol PostgreSQL del tenant y los campos {@code db_user} /
     * {@code db_password_encrypted} en {@code master.empresa}. Requiere privilegios de administración en el cluster.
     */
    @Transactional
    public ActualizarCredencialesBdResponse actualizarCredencialesBd(ActualizarCredencialesBdRequest req) {
        if (isBlank(req.getCodigo()) && isBlank(req.getRuc()) && isBlank(req.getDbName())) {
            throw new BusinessException(
                    "Debe enviar al menos uno: codigo, ruc o dbName",
                    HttpStatus.BAD_REQUEST, "PARAMETRO_REQUERIDO");
        }

        EmpresaMaster empresa = resolveEmpresa(req.getCodigo(), req.getRuc(), req.getDbName());
        String oldUser = empresa.getDbUser();
        String newUser = req.getDbUser().trim();
        String newPassword = req.getDbPassword();

        try {
            aplicarCredencialesRolPostgres(empresa, oldUser, newUser, newPassword);
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("Fallo credenciales BD para empresa dbName={}", empresa.getDbName(), e);
            Throwable root = e;
            while (root.getCause() != null) {
                root = root.getCause();
            }
            throw new BusinessException(
                    "No se pudo actualizar el rol en PostgreSQL: " + root.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR, "CREDENCIALES_BD_ERROR");
        }

        empresa.setDbUser(newUser);
        empresa.setDbPasswordEncrypted(aesEncryptor.encrypt(newPassword));
        empresaMasterRepository.save(empresa);

        return ActualizarCredencialesBdResponse.builder()
                .empresaId(empresa.getId())
                .codigo(empresa.getCodigo())
                .ruc(empresa.getRuc())
                .dbName(empresa.getDbName())
                .mensaje("Credenciales de conexión a la base del tenant actualizadas correctamente")
                .build();
    }

    @Transactional
    public RecreateEmpresaResponse recrearTenantDesdeTemplate(RecreateEmpresaRequest req) {
        boolean porId = req.getEmpresaId() != null;
        boolean porClaves = !isBlank(req.getCodigo()) || !isBlank(req.getRuc()) || !isBlank(req.getDbName());
        if (!porId && !porClaves) {
            throw new BusinessException(
                    "Debe enviar al menos uno: empresaId, codigo, ruc o nombre de la base (dbName / JSON nombre)",
                    HttpStatus.BAD_REQUEST,
                    "PARAMETRO_REQUERIDO");
        }

        EmpresaMaster empresa;
        if (porId) {
            empresa = empresaMasterRepository.findById(req.getEmpresaId())
                    .orElseThrow(() -> new BusinessException(
                            "No existe empresa con id " + req.getEmpresaId(),
                            HttpStatus.NOT_FOUND,
                            "EMPRESA_NO_ENCONTRADA"));
        } else {
            empresa = resolveEmpresa(req.getCodigo(), req.getRuc(), req.getDbName());
        }
        String targetDbName = empresa.getDbName();

        if (RESERVED_DB_NAMES.contains(targetDbName)) {
            throw new BusinessException(
                    "No se puede recrear una base protegida: " + targetDbName,
                    HttpStatus.FORBIDDEN,
                    "DB_PROTEGIDA");
        }

        try {
            if (Boolean.TRUE.equals(databaseExists(targetDbName))) {
                terminateConnections(targetDbName);
                adminJdbcTemplate.execute("DROP DATABASE " + quoteIdent(targetDbName));
                log.info("DROP DATABASE {} completado para recreación", targetDbName);
            }

            createDatabaseFromTemplate(targetDbName, provisioningDbUsername);
            String tenantPassword = aesEncryptor.decrypt(empresa.getDbPasswordEncrypted());
            ensureTenantRoleAndPrivileges(empresa, new TenantDbCredentials(empresa.getDbUser(), tenantPassword));

            String mensaje = String.format(
                    "Base tenant %s recreada correctamente desde template %s",
                    targetDbName,
                    templateDatabase);
            return RecreateEmpresaResponse.builder()
                    .empresaId(empresa.getId())
                    .codigo(empresa.getCodigo())
                    .ruc(empresa.getRuc())
                    .dbName(targetDbName)
                    .mensaje(mensaje)
                    .build();
        } catch (BusinessException e) {
            throw e;
        } catch (Exception e) {
            log.error("Fallo recreación de empresa {} / BD {}", empresa.getCodigo(), targetDbName, e);
            throw new BusinessException(
                    "Error al recrear base tenant: " + e.getMessage(),
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "RECREATE_TENANT_ERROR");
        }
    }

    @Transactional
    public EmpresaLogoUploadResponse actualizarLogoEmpresa(Long empresaId, byte[] logoBytes) {
        if (empresaId == null) {
            throw new BusinessException("Empresa no identificada en token", HttpStatus.UNAUTHORIZED, "TOKEN_EMPRESA_REQUERIDA");
        }
        if (logoBytes == null || logoBytes.length == 0) {
            throw new BusinessException("Debe enviar un archivo de logo no vacío", HttpStatus.BAD_REQUEST, "LOGO_REQUERIDO");
        }
        if (logoBytes.length > MAX_LOGO_BYTES) {
            throw new BusinessException(
                    "El logo excede el límite de 5 MB",
                    HttpStatus.BAD_REQUEST,
                    "LOGO_TAMANO_INVALIDO");
        }

        EmpresaMaster empresa = empresaMasterRepository.findById(empresaId)
                .orElseThrow(() -> new BusinessException(
                        "No existe empresa con id " + empresaId,
                        HttpStatus.NOT_FOUND,
                        "EMPRESA_NO_ENCONTRADA"));

        empresa.setLogo(logoBytes);
        empresa.setModificadoEn(Instant.now());
        empresaMasterRepository.save(empresa);

        return EmpresaLogoUploadResponse.builder()
                .empresaId(empresa.getId())
                .codigo(empresa.getCodigo())
                .logoSizeBytes((long) logoBytes.length)
                .mensaje("Logo de empresa actualizado correctamente")
                .build();
    }

    private static String escapePgLiteral(String password) {
        return password == null ? "" : password.replace("'", "''");
    }

    /**
     * Quita relaciones en la BD de seguridad que referencian {@code master.empresa},
     * para poder eliminar el registro y ejecutar {@code DROP DATABASE} sin violar FK.
     */
    private void eliminarRelacionesEmpresaEnSecurity(Long empresaId) {
        securityJdbcTemplate.update("DELETE FROM auth.tokens_session WHERE empresa_id = ?", empresaId);
        securityJdbcTemplate.update(
                """
                DELETE FROM auth.rol_opcion_menu_accion
                WHERE rol_opcion_menu_id IN (
                    SELECT rom.id FROM auth.rol_opcion_menu rom
                    INNER JOIN auth.rol r ON r.id = rom.rol_id
                    WHERE r.empresa_id = ?
                )
                """,
                empresaId);
        securityJdbcTemplate.update(
                "DELETE FROM auth.rol_opcion_menu WHERE rol_id IN (SELECT id FROM auth.rol WHERE empresa_id = ?)",
                empresaId);
        securityJdbcTemplate.update(
                "DELETE FROM auth.rol_usuario WHERE rol_id IN (SELECT id FROM auth.rol WHERE empresa_id = ?)",
                empresaId);
        securityJdbcTemplate.update("DELETE FROM auth.usuario_opcion_menu WHERE empresa_id = ?", empresaId);
        securityJdbcTemplate.update("DELETE FROM auth.usuario_empresa WHERE empresa_id = ?", empresaId);
        securityJdbcTemplate.update("DELETE FROM auth.notificacion WHERE empresa_id = ?", empresaId);
        securityJdbcTemplate.update("DELETE FROM auth.log_acceso WHERE empresa_id = ?", empresaId);
        securityJdbcTemplate.update("DELETE FROM auth.rol WHERE empresa_id = ?", empresaId);
        log.info("Relaciones de seguridad eliminadas para empresa_id={}", empresaId);
    }

    private EmpresaMaster resolveEmpresa(String codigo, String ruc, String dbName) {
        String codigoFiltro = trimOrNull(codigo);
        String rucFiltro = trimOrNull(ruc);
        String dbNameFiltro = trimOrNull(dbName);

        return empresaMasterRepository.findByLookupParams(codigoFiltro, rucFiltro, dbNameFiltro)
                .orElseThrow(() -> new BusinessException(
                        buildEmpresaNotFoundMessage(codigoFiltro, rucFiltro, dbNameFiltro),
                        HttpStatus.NOT_FOUND,
                        "EMPRESA_NO_ENCONTRADA"));
    }

    private static boolean isBlank(String s) {
        return s == null || s.isBlank();
    }

    private static String buildEmpresaNotFoundMessage(String codigo, String ruc, String dbName) {
        StringBuilder message = new StringBuilder("No existe empresa con los parámetros enviados");
        String separator = ": ";

        if (codigo != null) {
            message.append(separator).append("codigo=").append(codigo);
            separator = ", ";
        }
        if (ruc != null) {
            message.append(separator).append("ruc=").append(ruc);
            separator = ", ";
        }
        if (dbName != null) {
            message.append(separator).append("dbName=").append(dbName);
        }

        return message.toString();
    }

    private void validatePreconditions(ProvisionEmpresaRequest req) {
        String correo = firstNonBlank(req.getCorreoContacto(), req.getEmail());
        if (isBlank(correo)) {
            throw new BusinessException(
                    "El correo de contacto es obligatorio",
                    HttpStatus.BAD_REQUEST,
                    "CORREO_CONTACTO_REQUERIDO");
        }
        correo = correo.trim();
        if (!EMAIL_PATTERN.matcher(correo).matches()) {
            throw new BusinessException(
                    "El correo de contacto no es válido",
                    HttpStatus.BAD_REQUEST,
                    "CORREO_CONTACTO_INVALIDO");
        }
        req.setCorreoContacto(correo);

        if (empresaMasterRepository.existsByRuc(req.getRuc())) {
            throw new BusinessException("Ya existe una empresa con RUC " + req.getRuc(), HttpStatus.CONFLICT, "EMPRESA_RUC_DUPLICADO");
        }
    }

    @Transactional(readOnly = true)
    public EnviarCorreoBienvenidaResponse enviarCorreoBienvenida(long empresaId) {
        EmpresaMaster empresa = empresaMasterRepository.findById(empresaId)
                .orElseThrow(() -> new BusinessException(
                        "Empresa no encontrada",
                        HttpStatus.NOT_FOUND,
                        "EMPRESA_NO_ENCONTRADA"));

        String correo = trimOrNull(empresa.getCorreoContacto());
        if (isBlank(correo)) {
            throw new BusinessException(
                    "La empresa no tiene correo de contacto registrado",
                    HttpStatus.BAD_REQUEST,
                    "CORREO_CONTACTO_REQUERIDO");
        }
        if (!EMAIL_PATTERN.matcher(correo).matches()) {
            throw new BusinessException(
                    "El correo de contacto registrado no es válido",
                    HttpStatus.BAD_REQUEST,
                    "CORREO_CONTACTO_INVALIDO");
        }

        EmpresaRegistroEmailDto datos = buildEmpresaRegistroEmailDto(empresa);
        emailService.enviarConfirmacionRegistroEmpresa(datos);

        return EnviarCorreoBienvenidaResponse.builder()
                .empresaId(empresa.getId())
                .codigo(empresa.getCodigo())
                .razonSocial(empresa.getRazonSocial())
                .correoContacto(correo)
                .mensaje("Correo de bienvenida enviado a " + correo)
                .build();
    }

    private void notificarRegistroEmpresa(
            ProvisionEmpresaRequest req,
            EmpresaMaster saved,
            String slug,
            String host,
            int port) {
        emailService.enviarConfirmacionRegistroEmpresa(buildEmpresaRegistroEmailDto(saved, req, slug, host, port));
    }

    private EmpresaRegistroEmailDto buildEmpresaRegistroEmailDto(EmpresaMaster empresa) {
        return buildEmpresaRegistroEmailDto(
                empresa,
                null,
                resolveSiglaFromEmpresa(empresa),
                empresa.getDbHost(),
                empresa.getDbPort());
    }

    private EmpresaRegistroEmailDto buildEmpresaRegistroEmailDto(
            EmpresaMaster saved,
            ProvisionEmpresaRequest req,
            String slug,
            String host,
            int port) {
        UbigeoResumenDto ubigeo = seguridadService.obtenerUbigeoResumenPorDistrito(saved.getDistritoId()).orElse(null);

        return EmpresaRegistroEmailDto.builder()
                .codigo(saved.getCodigo())
                .ruc(saved.getRuc())
                .razonSocial(saved.getRazonSocial())
                .nombreComercial(saved.getNombreComercial())
                .sigla(resolveSiglaForEmail(saved, req, slug))
                .direccionFiscal(saved.getDireccionFiscal())
                .departamento(ubigeo != null ? ubigeo.getDepartamentoNombre() : req != null ? trimOrNull(req.getDirDepartamento()) : null)
                .provincia(ubigeo != null ? ubigeo.getProvinciaNombre() : req != null ? trimOrNull(req.getDirProvincia()) : null)
                .distrito(ubigeo != null ? ubigeo.getDistritoNombre() : req != null ? trimOrNull(req.getDirDistrito()) : null)
                .ubigeo(firstNonBlank(
                        ubigeo != null ? ubigeo.getDistritoCodigo() : null,
                        saved.getUbigeo(),
                        req != null ? req.getDirUbigeo() : null))
                .representanteLegal(saved.getRepresentanteLegal())
                .dniRepresentanteLegal(saved.getDniRepresentanteLegal())
                .correoContacto(saved.getCorreoContacto())
                .telefonoContacto(saved.getTelefonoContacto())
                .dbHost(host)
                .dbPort(port)
                .dbName(saved.getDbName())
                .dbUser(saved.getDbUser())
                .fechaRegistro(FECHA_REGISTRO_FMT.format(Instant.now()))
                .build();
    }

    private String resolveSiglaForEmail(EmpresaMaster saved, ProvisionEmpresaRequest req, String slug) {
        if (req != null && req.getSigla() != null && !req.getSigla().isBlank()) {
            return req.getSigla().trim().toUpperCase(Locale.ROOT);
        }
        if (slug != null && !slug.isBlank()) {
            return slug.toUpperCase(Locale.ROOT);
        }
        return resolveSiglaFromEmpresa(saved);
    }

    private String resolveSiglaFromEmpresa(EmpresaMaster empresa) {
        String dbName = empresa.getDbName();
        if (dbName != null && dbName.startsWith(dbNamePrefix)) {
            return dbName.substring(dbNamePrefix.length()).toUpperCase(Locale.ROOT);
        }
        if (empresa.getDbUser() != null && !empresa.getDbUser().isBlank()) {
            return empresa.getDbUser().trim().toUpperCase(Locale.ROOT);
        }
        return empresa.getCodigo();
    }

    /**
     * Evita carrera entre dos peticiones concurrentes: revalidar justo antes del CREATE.
     */
    private void assertDatabaseAbsentBeforeCreate(String dbName) {
        if (Boolean.TRUE.equals(databaseExists(dbName))) {
            throw new BusinessException("La base de datos ya existe (condición de carrera): " + dbName, HttpStatus.CONFLICT, "DB_FISICA_EXISTE");
        }
    }

    /**
     * Compensación: primero quitar el registro en security (si existe), luego eliminar la BD física.
     */
    private void rollbackProvisioning(String dbName, boolean dbCreated, Long masterEmpresaId) {
        if (masterEmpresaId != null) {
            try {
                empresaMasterRepository.deleteById(masterEmpresaId);
                log.warn("Rollback: eliminado master.empresa id={} por fallo en provisionamiento", masterEmpresaId);
            } catch (Exception ex) {
                log.error("Rollback: no se pudo eliminar master.empresa id={}; revisar consistencia manualmente", masterEmpresaId, ex);
            }
        }
        if (dbCreated) {
            dropDatabaseQuietly(dbName);
        }
    }

    /**
     * Reglas: ninguno → sigla/sigla; solo usuario → usuario/usuario; ambos → tal cual;
     * solo contraseña → usuario = siglas normalizadas (minúsculas), contraseña = la enviada.
     */
    private TenantDbCredentials resolveTenantDbCredentials(ProvisionEmpresaRequest req, String slug) {
        String u = trimOrNull(req.getDbUser());
        String p = trimOrNull(req.getDbPassword());
        if (u != null && p != null) {
            return new TenantDbCredentials(u.trim(), p);
        }
        if (u != null) {
            String user = u.trim();
            return new TenantDbCredentials(user, user);
        }
        if (p != null) {
            return new TenantDbCredentials(slug, p);
        }
        return new TenantDbCredentials(slug, slug);
    }

    private EmpresaMaster saveMasterEmpresa(ProvisionEmpresaRequest req, String host, int port, String dbName, TenantDbCredentials tenantDb) {
        String direccionFiscal = firstNonBlank(req.getDireccion(), req.getDirCalle());
        String telefono = firstNonBlank(req.getCelular(), req.getFonoFijo());
        String repLegal = firstNonBlank(req.getRepresLegal(), req.getRepresentante());

        EmpresaMaster entity = EmpresaMaster.builder()
                .codigo(req.getCodigo().trim())
                .ruc(req.getRuc().trim())
                .razonSocial(req.getRazonSocial().trim())
                .nombreComercial(trimOrNull(req.getNombreComercial()))
                .direccionFiscal(trimOrNull(direccionFiscal))
                .ubigeo(trimOrNull(req.getDirUbigeo()))
                .distritoId(req.getDistritoId())
                .representanteLegal(trimOrNull(repLegal))
                .dniRepresentanteLegal(trimOrNull(req.getDniRepresLegal()))
                .correoContacto(trimOrNull(firstNonBlank(req.getCorreoContacto(), req.getEmail())))
                .telefonoContacto(trimOrNull(telefono))
                .dbHost(host)
                .dbPort(port)
                .dbName(dbName)
                .dbUser(tenantDb.user())
                .dbPasswordEncrypted(aesEncryptor.encrypt(tenantDb.password()))
                .flagEstado("1")
                .build();
        return empresaMasterRepository.save(entity);
    }

    /**
     * Genera el siguiente código de empresa: T0000001, T0000002, ...
     * Formato: 'T' + 7 dígitos con ceros a la izquierda (8 chars total).
     */
    private String generateNextCodigo() {
        Long siguienteNumero = empresaMasterRepository.nextEmpresaCodigo();
        if (siguienteNumero == null) {
            throw new BusinessException(
                    "No se pudo obtener el siguiente código de empresa",
                    HttpStatus.INTERNAL_SERVER_ERROR,
                    "CORRELATIVO_EMPRESA_NO_DISPONIBLE"
            );
        }
        return String.format("T%07d", siguienteNumero);
    }

    private record TenantDbCredentials(String user, String password) {}

    private void createDatabaseFromTemplate(String newDbName, String owner) {
        terminateConnections(templateDatabase);
        String sql = String.format(
                Locale.ROOT,
                "CREATE DATABASE %s TEMPLATE %s OWNER %s",
                quoteIdent(newDbName),
                quoteIdent(templateDatabase),
                quoteIdent(owner)
        );
        adminJdbcTemplate.execute(sql);
        log.info("CREATE DATABASE {} desde template {}", newDbName, templateDatabase);
    }

    private void terminateConnections(String databaseName) {
        adminJdbcTemplate.query(
                "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = ? AND pid <> pg_backend_pid()",
                rs -> { /* se descarta el resultado; solo interesa el efecto de desconectar sesiones */ },
                databaseName
        );
    }

    private Boolean databaseExists(String name) {
        Integer n = adminJdbcTemplate.queryForObject(
                "SELECT count(*) FROM pg_database WHERE datname = ?",
                Integer.class,
                name
        );
        return n != null && n > 0;
    }

    private void dropDatabaseQuietly(String dbName) {
        try {
            if (!Boolean.TRUE.equals(databaseExists(dbName))) {
                return;
            }
            terminateConnections(dbName);
            adminJdbcTemplate.execute("DROP DATABASE " + quoteIdent(dbName));
            log.warn("DROP DATABASE {} tras rollback de provisionamiento", dbName);
        } catch (Exception e) {
            log.error("No se pudo hacer DROP DATABASE de {}: {}", dbName, e.getMessage());
        }
    }

    /**
     * Crea o sincroniza el rol LOGIN del tenant, {@code GRANT CONNECT} a la BD y privilegios sobre esquemas
     * (equivalente a lo necesario para seguridad-service y microservicios contra la BD tenant).
     * <p>
     * Debe ejecutarse tras crear la BD desde plantilla en {@link #provision}; antes solo existía el OWNER admin.
     */
    private void ensureTenantRoleAndPrivileges(EmpresaMaster empresa, TenantDbCredentials tenantDb) {
        String role = tenantDb.user();
        String pwd = tenantDb.password();
        if (!pgRoleExists(role)) {
            adminJdbcTemplate.execute(
                    "CREATE ROLE " + quoteIdent(role)
                            + " WITH LOGIN PASSWORD '" + escapePgLiteral(pwd) + "'");
            log.info("Rol tenant '{}' creado (LOGIN) en PostgreSQL", role);
        } else {
            adminJdbcTemplate.execute(
                    "ALTER ROLE " + quoteIdent(role)
                            + " WITH PASSWORD '" + escapePgLiteral(pwd) + "'");
            log.info("Rol tenant '{}' ya existía; contraseña sincronizada con master.empresa", role);
        }
        adminJdbcTemplate.execute(
                "GRANT CONNECT ON DATABASE " + quoteIdent(empresa.getDbName())
                        + " TO " + quoteIdent(role));
        grantTenantSchemaPrivileges(empresa, role);
    }

    /**
     * Ajusta rol/contraseña en el cluster. Si el rol aún no existía, crea LOGIN y privilegios;
     * si ya existía, sincroniza contraseña y vuelve a aplicar grants (corrige desvíos).
     */
    private void aplicarCredencialesRolPostgres(EmpresaMaster empresa, String oldUser, String newUser, String newPassword) {
        if (oldUser.equals(newUser)) {
            ensureTenantRoleAndPrivileges(empresa, new TenantDbCredentials(newUser, newPassword));
            return;
        }
        if (!pgRoleExists(oldUser)) {
            throw new BusinessException(
                    "El rol PostgreSQL actual '" + oldUser + "' no existe; no se puede renombrar a '" + newUser + "'.",
                    HttpStatus.BAD_REQUEST, "ROL_ORIGEN_INEXISTENTE");
        }
        adminJdbcTemplate.execute(
                "ALTER ROLE " + quoteIdent(oldUser) + " RENAME TO " + quoteIdent(newUser));
        adminJdbcTemplate.execute(
                "ALTER ROLE " + quoteIdent(newUser)
                        + " WITH PASSWORD '" + escapePgLiteral(newPassword) + "'");
        adminJdbcTemplate.execute(
                "GRANT CONNECT ON DATABASE " + quoteIdent(empresa.getDbName())
                        + " TO " + quoteIdent(newUser));
        grantTenantSchemaPrivileges(empresa, newUser);
    }

    private boolean pgRoleExists(String rolname) {
        Integer n = adminJdbcTemplate.queryForObject(
                "SELECT count(*)::int FROM pg_catalog.pg_roles WHERE rolname = ?",
                Integer.class,
                rolname);
        return n != null && n > 0;
    }

    /**
     * Otorga ALL (incluye CREATE) en schemas y ALL en tablas/secuencias al rol del tenant,
     * más ALTER DEFAULT PRIVILEGES para objetos futuros.
     */
    private void grantTenantSchemaPrivileges(EmpresaMaster empresa, String roleName) {
        String url = String.format(Locale.ROOT, "jdbc:postgresql://%s:%d/%s?sslmode=%s",
                empresa.getDbHost(), empresa.getDbPort(), empresa.getDbName(), jdbcSslMode);
        HikariConfig cfg = new HikariConfig();
        cfg.setJdbcUrl(url);
        cfg.setUsername(provisioningDbUsername);
        cfg.setPassword(provisioningDbPassword);
        cfg.setMaximumPoolSize(1);
        cfg.setPoolName("grant-tenant-" + roleName);

        List<String> schemas = List.of(
                "public", "config", "auth", "core", "almacen", "compras", "ventas", "finanzas",
                "contabilidad", "rrhh", "activos", "produccion", "auditoria");

        try (HikariDataSource ds = new HikariDataSource(cfg)) {
            JdbcTemplate jdbc = new JdbcTemplate(ds);
            for (String schema : schemas) {
                try {
                    Integer exists = jdbc.queryForObject(
                            "SELECT count(*)::int FROM pg_namespace WHERE nspname = ?",
                            Integer.class,
                            schema);
                    if (exists == null || exists == 0) {
                        continue;
                    }
                    jdbc.execute("GRANT ALL ON SCHEMA " + quoteIdent(schema) + " TO " + quoteIdent(roleName));
                    jdbc.execute("GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA " + quoteIdent(schema)
                            + " TO " + quoteIdent(roleName));
                    jdbc.execute("GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA " + quoteIdent(schema)
                            + " TO " + quoteIdent(roleName));
                    jdbc.execute("ALTER DEFAULT PRIVILEGES IN SCHEMA " + quoteIdent(schema)
                            + " GRANT ALL ON TABLES TO " + quoteIdent(roleName));
                    jdbc.execute("ALTER DEFAULT PRIVILEGES IN SCHEMA " + quoteIdent(schema)
                            + " GRANT ALL ON SEQUENCES TO " + quoteIdent(roleName));
                } catch (Exception ex) {
                    log.warn("Grant en schema {} ({}): {}", schema, empresa.getDbName(), ex.getMessage());
                }
            }
        }
    }

    private static String quoteIdent(String ident) {
        if (!ident.chars().allMatch(c -> Character.isLetterOrDigit(c) || c == '_')) {
            throw new BusinessException("Identificador PostgreSQL no permitido: " + ident, HttpStatus.BAD_REQUEST, "IDENT_INVALIDO");
        }
        return "\"" + ident.replace("\"", "\"\"") + "\"";
    }

    private String resolveTenantSlug(ProvisionEmpresaRequest req) {
        return sanitizeSlug(req.getSigla());
    }

    private static String sanitizeSlug(String raw) {
        String s = Normalizer.normalize(raw.trim(), Normalizer.Form.NFD).replaceAll("\\p{M}", "");
        s = s.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9]+", "_");
        s = s.replaceAll("_+", "_").replaceAll("^_+|_+$", "");
        if (s.isEmpty()) {
            throw new BusinessException("La sigla no produce un identificador de BD válido tras normalizar", HttpStatus.BAD_REQUEST, "TENANT_SLUG_VACIO");
        }
        if (s.length() > 44) {
            s = s.substring(0, 44).replaceAll("_+$", "");
        }
        return s;
    }

    private static String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }
        for (String v : values) {
            if (v != null && !v.isBlank()) {
                return v.trim();
            }
        }
        return null;
    }

    private static String trimOrNull(String s) {
        if (s == null || s.isBlank()) {
            return null;
        }
        return s.trim();
    }

    private static String flagOrDefault(String flag, String def) {
        return trimOrNull(flag) != null ? flag.trim() : def;
    }
}
