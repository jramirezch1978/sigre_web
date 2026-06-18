package pe.restaurant.rrhh.util;

import pe.restaurant.rrhh.constants.PermisoLicenciaConstants;
import pe.restaurant.rrhh.constants.VacacionConstants;
import pe.restaurant.rrhh.entity.PermisoLicencia;
import pe.restaurant.rrhh.entity.Vacacion;

import java.util.List;

/**
 * Convierte {@code flag_estado} en letras legacy (P/A/R/…) al catálogo numérico del DDL.
 * Idempotente: valores ya numéricos no se alteran.
 */
public final class RrhhFlagEstadoLegacyNormalizer {

    private RrhhFlagEstadoLegacyNormalizer() {
        throw new UnsupportedOperationException("Clase de utilidad — no instanciable");
    }

    public static PermisoLicencia normalizePermiso(PermisoLicencia entity) {
        if (entity == null) {
            return null;
        }
        entity.setFlagEstado(normalizePermisoFlag(entity.getFlagEstado()));
        return entity;
    }

    public static String normalizePermisoFlag(String flagEstado) {
        if (flagEstado == null || flagEstado.isEmpty()) {
            return flagEstado;
        }
        if (isDigit(flagEstado)) {
            return flagEstado;
        }
        return switch (flagEstado) {
            case "P", "S" -> PermisoLicenciaConstants.ESTADO_SOLICITADO;
            case "A" -> PermisoLicenciaConstants.ESTADO_APROBADO;
            case "R" -> PermisoLicenciaConstants.ESTADO_RECHAZADO;
            case "O" -> PermisoLicenciaConstants.ESTADO_OBSERVADO;
            case "C" -> PermisoLicenciaConstants.ESTADO_CERRADO;
            default -> flagEstado;
        };
    }

    /** Valores posibles en BD para un filtro por estado (incluye letras no migradas). */
    public static List<String> permisoFlagEstadosParaFiltro(String flagEstado) {
        String normalized = normalizePermisoFlag(flagEstado);
        if (normalized == null) {
            return List.of();
        }
        return switch (normalized) {
            case PermisoLicenciaConstants.ESTADO_SOLICITADO ->
                    List.of(PermisoLicenciaConstants.ESTADO_SOLICITADO, "P", "S");
            case PermisoLicenciaConstants.ESTADO_APROBADO ->
                    List.of(PermisoLicenciaConstants.ESTADO_APROBADO, "A");
            case PermisoLicenciaConstants.ESTADO_RECHAZADO ->
                    List.of(PermisoLicenciaConstants.ESTADO_RECHAZADO, "R");
            case PermisoLicenciaConstants.ESTADO_OBSERVADO ->
                    List.of(PermisoLicenciaConstants.ESTADO_OBSERVADO, "O");
            case PermisoLicenciaConstants.ESTADO_CERRADO ->
                    List.of(PermisoLicenciaConstants.ESTADO_CERRADO, "C");
            default -> List.of(normalized);
        };
    }

    public static Vacacion normalizeVacacion(Vacacion entity) {
        if (entity == null) {
            return null;
        }
        entity.setFlagEstado(normalizeVacacionFlag(entity.getFlagEstado()));
        return entity;
    }

    public static String normalizeVacacionFlag(String flagEstado) {
        if (flagEstado == null || flagEstado.isEmpty()) {
            return flagEstado;
        }
        if (isDigit(flagEstado)) {
            return flagEstado;
        }
        return switch (flagEstado) {
            case "P", "O" -> VacacionConstants.ESTADO_PENDIENTE;
            case "A" -> VacacionConstants.ESTADO_APROBADO;
            case "R" -> VacacionConstants.ESTADO_RECHAZADO;
            case "C" -> VacacionConstants.ESTADO_CERRADO;
            default -> flagEstado;
        };
    }

    public static List<String> vacacionFlagEstadosParaFiltro(String flagEstado) {
        String normalized = normalizeVacacionFlag(flagEstado);
        if (normalized == null) {
            return List.of();
        }
        return switch (normalized) {
            case VacacionConstants.ESTADO_REGISTRADO -> List.of(VacacionConstants.ESTADO_REGISTRADO);
            case VacacionConstants.ESTADO_PENDIENTE ->
                    List.of(VacacionConstants.ESTADO_PENDIENTE, "P", "O");
            case VacacionConstants.ESTADO_APROBADO ->
                    List.of(VacacionConstants.ESTADO_APROBADO, "A");
            case VacacionConstants.ESTADO_RECHAZADO ->
                    List.of(VacacionConstants.ESTADO_RECHAZADO, "R");
            case VacacionConstants.ESTADO_CERRADO ->
                    List.of(VacacionConstants.ESTADO_CERRADO, "C");
            case VacacionConstants.ESTADO_ANULADO -> List.of(VacacionConstants.ESTADO_ANULADO);
            default -> List.of(normalized);
        };
    }

    private static boolean isDigit(String value) {
        return value.length() == 1 && value.charAt(0) >= '0' && value.charAt(0) <= '9';
    }
}
