package pe.restaurant.common.tenant;

import lombok.Builder;
import lombok.Getter;

/**
 * Conexión JDBC a la BD tenant de una empresa (desde {@code master.empresa}).
 */
@Getter
@Builder
public class TenantConnectionInfo {
    private final Long empresaId;
    private final String codigo;
    private final String jdbcUrl;
    private final String username;
    private final String password;
}
