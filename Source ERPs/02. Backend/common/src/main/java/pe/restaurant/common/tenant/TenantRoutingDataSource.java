package pe.restaurant.common.tenant;

import org.springframework.jdbc.datasource.AbstractDataSource;
import pe.restaurant.common.security.TenantContext;

import java.sql.Connection;
import java.sql.SQLException;

/**
 * DataSource {@code @Primary} para JPA: delega al pool del tenant según {@link TenantContext}.
 * No usa ninguna BD fija en el arranque.
 */
public class TenantRoutingDataSource extends AbstractDataSource {

    private final TenantDataSourceRegistry registry;

    public TenantRoutingDataSource(TenantDataSourceRegistry registry) {
        this.registry = registry;
    }

    @Override
    public Connection getConnection() throws SQLException {
        Long empresaId = TenantContext.getEmpresaId();
        if (empresaId == null) {
            throw new SQLException(
                    "Sin contexto de empresa: JWT con claim empresaId, cabecera X-Empresa-Id o ruta /api/{modulo}/empresas/{id}/...");
        }
        return registry.getOrCreateDataSource(empresaId).getConnection();
    }

    @Override
    public Connection getConnection(String username, String password) throws SQLException {
        return getConnection();
    }
}
