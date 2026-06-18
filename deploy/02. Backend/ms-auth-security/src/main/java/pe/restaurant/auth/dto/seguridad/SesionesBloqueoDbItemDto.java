package pe.restaurant.auth.dto.seguridad;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Muestreo de backends PostgreSQL en una base (security o tenant): espera por lock vs resto de sesiones activas.
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class SesionesBloqueoDbItemDto {

    /** SECURITY = BD de seguridad; TENANT = BD empresa. */
    private String alcance;
    private Long empresaId;
    /** Texto para UI (ej. nombre BD o razón social). */
    private String etiqueta;
    /** Backends en {@code state = active} esperando lock. */
    private long sesionesEsperandoLock;
    /** Backends activos que no reportan espera por lock. */
    private long sesionesActivasSinEsperaLock;
    /** Si no se pudo conectar al tenant (null si OK). */
    private String errorMuestreo;
}
