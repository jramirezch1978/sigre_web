package pe.restaurant.finanzas.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import pe.restaurant.common.exception.BusinessException;
import pe.restaurant.common.security.TenantContext;
import pe.restaurant.finanzas.client.AuthSecurityClient;
import pe.restaurant.finanzas.dto.response.PermisosMenuRolesResponse;

import java.util.List;

/**
 * Valida (solo lectura) que el usuario actual tenga permiso para una acción sobre la
 * opción de menú de cierre de liquidación (HU-FIN-ADL-004).
 *
 * Reutiliza el RBAC existente: consulta {@code permisos-menu-roles} en ms-auth-security
 * con el usuario y empresa del token. NO crea ni modifica permisos. Concede acceso si el
 * usuario es administrador ({@code esAdmin}) o si tiene la acción permitida en la opción
 * {@code FINANZAS_ADEL_CIERRE}.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class PermisoCierreValidator {

    /** Código de opción de menú del seed de seguridad (01-carga-inicial-security.sql). */
    public static final String OPCION_CIERRE = "FINANZAS_ADEL_CIERRE";

    public static final String ACCION_CERRAR = "CERRAR";
    public static final String ACCION_ANULAR = "ANULAR";
    public static final String ACCION_PROCESAR = "PROCESAR";
    public static final String ACCION_CONSULTAR = "CONSULTAR";

    // Acciones del flujo de aprobación de rendición de gastos (HU-FIN-OPE-004).
    public static final String ACCION_APROBAR = "APROBAR";
    public static final String ACCION_RECHAZAR = "RECHAZAR";
    public static final String ACCION_OBSERVAR = "OBSERVAR";

    private final AuthSecurityClient authSecurityClient;

    /**
     * Lanza {@link BusinessException} 403 si el usuario actual no puede ejecutar la acción
     * indicada sobre la opción de cierre de liquidación.
     */
    public void validar(String accionCodigo) {
        Long usuarioId = TenantContext.getUsuarioId();
        Long empresaId = TenantContext.getEmpresaId();

        if (usuarioId == null || empresaId == null) {
            throw new BusinessException(
                    "No hay contexto de usuario/empresa para validar permisos",
                    HttpStatus.FORBIDDEN,
                    FinanzasErrorCodes.ACCESO_DENEGADO);
        }

        PermisosMenuRolesResponse permisos;
        try {
            permisos = authSecurityClient.obtenerPermisosMenuRoles(empresaId, usuarioId).getData();
        } catch (feign.FeignException e) {
            log.error("No se pudieron obtener permisos del usuario {} (empresa {}): {}",
                    usuarioId, empresaId, e.getMessage());
            throw new BusinessException(
                    "No se pudo validar permisos con seguridad",
                    HttpStatus.SERVICE_UNAVAILABLE,
                    FinanzasErrorCodes.ERROR_COMUNICACION_AUTH_SECURITY);
        }

        if (permisos == null) {
            throw new BusinessException(
                    "No se pudo determinar los permisos del usuario",
                    HttpStatus.FORBIDDEN,
                    FinanzasErrorCodes.ACCESO_DENEGADO);
        }

        if (esAdmin(permisos) || tieneAccion(permisos, accionCodigo)) {
            return;
        }

        throw new BusinessException(
                "No tiene permiso para la acción '" + accionCodigo + "' en Cierre de liquidación de adelantos",
                HttpStatus.FORBIDDEN,
                FinanzasErrorCodes.ACCESO_DENEGADO);
    }

    private boolean esAdmin(PermisosMenuRolesResponse permisos) {
        List<PermisosMenuRolesResponse.Rol> roles = permisos.getRoles();
        if (roles == null) {
            return false;
        }
        return roles.stream().anyMatch(r -> Boolean.TRUE.equals(r.getEsAdmin()));
    }

    private boolean tieneAccion(PermisosMenuRolesResponse permisos, String accionCodigo) {
        List<PermisosMenuRolesResponse.OpcionMenuPermiso> opciones = permisos.getOpcionesMenu();
        if (opciones == null) {
            return false;
        }
        return opciones.stream()
                .filter(o -> o.getOpcionMenu() != null
                        && OPCION_CIERRE.equals(o.getOpcionMenu().getCodigo()))
                .filter(o -> o.getAcciones() != null)
                .flatMap(o -> o.getAcciones().stream())
                .anyMatch(a -> Boolean.TRUE.equals(a.getPermitido())
                        && a.getAccion() != null
                        && accionCodigo.equals(a.getAccion().getCodigo()));
    }
}
