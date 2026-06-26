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
 * Valida (solo lectura) que el usuario actual tenga permiso para aprobar / rechazar Órdenes de
 * Giro (HU-FIN-ADL-002), reutilizando el RBAC existente de ms-auth-security. <b>No crea ni
 * modifica permisos, roles ni acciones, y no toca la BD de auth.</b>
 *
 * <p>Opción de menú: {@code FINANZAS_ADEL_APROB_GIRO} ("Aprobación de órdenes de giro" en
 * {@code 01-carga-inicial-security.sql}). El seed de esa opción define las acciones
 * {@code CONSULTAR, MODIFICAR, ANULAR, CERRAR, PROCESAR} (no existe una acción "APROBAR"/"RECHAZAR"
 * propia). Para funcionar <b>hoy sin cambiar el seed</b>, las decisiones se mapean a acciones
 * realmente sembradas:</p>
 * <ul>
 *   <li>Aprobar  → {@code CERRAR}</li>
 *   <li>Rechazar → {@code ANULAR}</li>
 *   <li>Masivo   → {@code PROCESAR}</li>
 *   <li>Consultar / Exportar → {@code CONSULTAR}</li>
 * </ul>
 *
 * <p>El administrador ({@code esAdmin = true}) siempre pasa. <b>Falla cerrada:</b> si auth no
 * responde, deniega. Se aísla del {@link PermisoCierreValidator} (clavado a otra opción de menú)
 * para no cambiar su comportamiento.</p>
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class PermisoAprobacionGiroValidator {

    /** Código de opción de menú del seed de seguridad. */
    public static final String OPCION_APROB_GIRO = "FINANZAS_ADEL_APROB_GIRO";

    /** Mapeo decisión ADL-002 → acción realmente sembrada para esta opción. */
    public static final String ACCION_APROBAR = "CERRAR";
    public static final String ACCION_RECHAZAR = "ANULAR";
    public static final String ACCION_MASIVO = "PROCESAR";
    public static final String ACCION_CONSULTAR = "CONSULTAR";

    private final AuthSecurityClient authSecurityClient;

    /**
     * Lanza {@link BusinessException} 403 si el usuario actual no puede ejecutar la acción
     * indicada sobre la opción de aprobación de órdenes de giro.
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
                "No tiene permiso para la acción '" + accionCodigo + "' en Aprobación de órdenes de giro",
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
                        && OPCION_APROB_GIRO.equals(o.getOpcionMenu().getCodigo()))
                .filter(o -> o.getAcciones() != null)
                .flatMap(o -> o.getAcciones().stream())
                .anyMatch(a -> Boolean.TRUE.equals(a.getPermitido())
                        && a.getAccion() != null
                        && accionCodigo.equals(a.getAccion().getCodigo()));
    }
}
