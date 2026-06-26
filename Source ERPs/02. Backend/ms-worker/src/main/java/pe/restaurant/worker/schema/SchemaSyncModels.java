package pe.restaurant.worker.schema;

/**
 * Records específicos del proceso de sincronización de esquemas del ms-worker.
 * Los modelos genéricos de esquema (TableMetadata, ColumnMetadata, etc.)
 * están en {@link pe.restaurant.common.schema.SchemaModels}.
 */
public final class SchemaSyncModels {

    private SchemaSyncModels() {
    }

    public record TenantConnectionInfo(
            Long empresaId,
            String codigo,
            String nombreEmpresa,
            String dbHost,
            Integer dbPort,
            String dbName,
            String dbUser,
            String dbPassword,
            boolean activo
    ) {
    }
}
