package pe.restaurant.common.schema;

import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.common.schema.SchemaModels.ColumnMetadata;
import pe.restaurant.common.schema.SchemaModels.ConstraintMetadata;
import pe.restaurant.common.schema.SchemaModels.IndexMetadata;
import pe.restaurant.common.schema.SchemaModels.SchemaSnapshot;
import pe.restaurant.common.schema.SchemaModels.SequenceMetadata;
import pe.restaurant.common.schema.SchemaModels.TableMetadata;

import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Lee metadatos de esquema PostgreSQL (tablas, columnas, constraints, índices, secuencias)
 * usando catálogos del sistema (pg_class, pg_attribute, pg_constraint, pg_indexes, etc.).
 * <p>
 * Clase reutilizable sin anotaciones Spring: instanciar como {@code @Bean}
 * en el microservicio que la necesite.
 */
public class PgSchemaMetadataReader {

    private static final String FILTER_SCHEMAS = """
            
            n.nspname NOT IN ('pg_catalog', 'information_schema')
            AND n.nspname NOT LIKE 'pg_toast%%'
            AND n.nspname NOT LIKE 'pg_temp%%'
            """;

    public SchemaSnapshot readSnapshot(JdbcTemplate jdbcTemplate, String databaseName) {
        Map<String, TableMetadataBuilder> builders = loadTables(jdbcTemplate);
        loadColumns(jdbcTemplate, builders);
        loadPrimaryAndUniqueConstraints(jdbcTemplate, builders);
        loadForeignKeys(jdbcTemplate, builders);
        loadIndexes(jdbcTemplate, builders);
        Map<String, SequenceMetadata> sequences = loadSequences(jdbcTemplate);

        Map<String, TableMetadata> tables = new LinkedHashMap<>();
        for (Map.Entry<String, TableMetadataBuilder> entry : builders.entrySet()) {
            tables.put(entry.getKey(), entry.getValue().build());
        }
        return new SchemaSnapshot(databaseName, tables, sequences);
    }

    private Map<String, TableMetadataBuilder> loadTables(JdbcTemplate jdbcTemplate) {
        return jdbcTemplate.query("""
                        SELECT n.nspname AS schema_name, c.relname AS table_name
                        FROM pg_class c
                        JOIN pg_namespace n ON n.oid = c.relnamespace
                        WHERE c.relkind = 'r'
                          AND """ + FILTER_SCHEMAS + """
                        ORDER BY n.nspname, c.relname
                        """,
                rs -> {
                    Map<String, TableMetadataBuilder> builders = new LinkedHashMap<>();
                    while (rs.next()) {
                        String schema = rs.getString("schema_name");
                        String table = rs.getString("table_name");
                        builders.put(key(schema, table), new TableMetadataBuilder(schema, table));
                    }
                    return builders;
                });
    }

    private void loadColumns(JdbcTemplate jdbcTemplate, Map<String, TableMetadataBuilder> builders) {
        jdbcTemplate.query("""
                        SELECT n.nspname AS schema_name,
                               c.relname AS table_name,
                               a.attname AS column_name,
                               format_type(a.atttypid, a.atttypmod) AS data_type,
                               NOT a.attnotnull AS nullable,
                               pg_get_expr(ad.adbin, ad.adrelid) AS column_default,
                               a.attnum AS ordinal_position
                        FROM pg_attribute a
                        JOIN pg_class c ON c.oid = a.attrelid
                        JOIN pg_namespace n ON n.oid = c.relnamespace
                        LEFT JOIN pg_attrdef ad ON ad.adrelid = a.attrelid AND ad.adnum = a.attnum
                        WHERE c.relkind = 'r'
                          AND a.attnum > 0
                          AND NOT a.attisdropped
                          AND """ + FILTER_SCHEMAS + """
                        ORDER BY n.nspname, c.relname, a.attnum
                        """,
                rs -> {
                    while (rs.next()) {
                        String tableKey = key(rs.getString("schema_name"), rs.getString("table_name"));
                        TableMetadataBuilder builder = builders.get(tableKey);
                        if (builder == null) continue;
                        ColumnMetadata column = new ColumnMetadata(
                                rs.getString("schema_name"),
                                rs.getString("table_name"),
                                rs.getString("column_name"),
                                rs.getString("data_type"),
                                rs.getBoolean("nullable"),
                                rs.getString("column_default"),
                                rs.getInt("ordinal_position"));
                        builder.columns.put(column.columnName(), column);
                    }
                    return null;
                });
    }

    private void loadPrimaryAndUniqueConstraints(JdbcTemplate jdbcTemplate, Map<String, TableMetadataBuilder> builders) {
        jdbcTemplate.query("""
                        SELECT n.nspname AS schema_name,
                               c.relname AS table_name,
                               con.conname AS constraint_name,
                               con.contype AS constraint_type,
                               pg_get_constraintdef(con.oid, true) AS definition
                        FROM pg_constraint con
                        JOIN pg_class c ON c.oid = con.conrelid
                        JOIN pg_namespace n ON n.oid = c.relnamespace
                        WHERE con.contype IN ('p', 'u')
                          AND """ + FILTER_SCHEMAS + """
                        ORDER BY n.nspname, c.relname, con.conname
                        """,
                rs -> {
                    while (rs.next()) {
                        String tableKey = key(rs.getString("schema_name"), rs.getString("table_name"));
                        TableMetadataBuilder builder = builders.get(tableKey);
                        if (builder == null) continue;
                        ConstraintMetadata metadata = new ConstraintMetadata(
                                rs.getString("schema_name"),
                                rs.getString("table_name"),
                                rs.getString("constraint_name"),
                                rs.getString("constraint_type"),
                                rs.getString("definition"));
                        if ("p".equals(rs.getString("constraint_type"))) {
                            builder.primaryKey = metadata;
                        } else {
                            builder.uniqueConstraints.put(metadata.constraintName(), metadata);
                        }
                    }
                    return null;
                });
    }

    private void loadForeignKeys(JdbcTemplate jdbcTemplate, Map<String, TableMetadataBuilder> builders) {
        jdbcTemplate.query("""
                        SELECT n.nspname AS schema_name,
                               c.relname AS table_name,
                               con.conname AS constraint_name,
                               pg_get_constraintdef(con.oid, true) AS definition
                        FROM pg_constraint con
                        JOIN pg_class c ON c.oid = con.conrelid
                        JOIN pg_namespace n ON n.oid = c.relnamespace
                        WHERE con.contype = 'f'
                          AND """ + FILTER_SCHEMAS + """
                        ORDER BY n.nspname, c.relname, con.conname
                        """,
                rs -> {
                    while (rs.next()) {
                        String tableKey = key(rs.getString("schema_name"), rs.getString("table_name"));
                        TableMetadataBuilder builder = builders.get(tableKey);
                        if (builder == null) continue;
                        ConstraintMetadata metadata = new ConstraintMetadata(
                                rs.getString("schema_name"),
                                rs.getString("table_name"),
                                rs.getString("constraint_name"),
                                "f",
                                rs.getString("definition"));
                        builder.foreignKeys.put(metadata.constraintName(), metadata);
                    }
                    return null;
                });
    }

    private void loadIndexes(JdbcTemplate jdbcTemplate, Map<String, TableMetadataBuilder> builders) {
        jdbcTemplate.query("""
                        SELECT schemaname AS schema_name,
                               tablename AS table_name,
                               indexname AS index_name,
                               indexdef AS index_def
                        FROM pg_indexes idx
                        WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
                          AND schemaname NOT LIKE 'pg_toast%%'
                          AND schemaname NOT LIKE 'pg_temp%%'
                          AND NOT EXISTS (
                              SELECT 1
                              FROM pg_constraint con
                              JOIN pg_class tbl ON tbl.oid = con.conrelid
                              JOIN pg_namespace ns ON ns.oid = tbl.relnamespace
                              JOIN pg_class idxcls ON idxcls.oid = con.conindid
                              WHERE ns.nspname = idx.schemaname
                                AND tbl.relname = idx.tablename
                                AND idxcls.relname = idx.indexname
                          )
                        ORDER BY schemaname, tablename, indexname
                        """,
                rs -> {
                    while (rs.next()) {
                        String tableKey = key(rs.getString("schema_name"), rs.getString("table_name"));
                        TableMetadataBuilder builder = builders.get(tableKey);
                        if (builder == null) continue;
                        IndexMetadata metadata = new IndexMetadata(
                                rs.getString("schema_name"),
                                rs.getString("table_name"),
                                rs.getString("index_name"),
                                rs.getString("index_def"));
                        builder.indexes.put(metadata.indexName(), metadata);
                    }
                    return null;
                });
    }

    private Map<String, SequenceMetadata> loadSequences(JdbcTemplate jdbcTemplate) {
        return jdbcTemplate.query("""
                        SELECT sequence_schema,
                               sequence_name,
                               data_type,
                               start_value,
                               minimum_value,
                               maximum_value,
                               increment,
                               cycle_option
                        FROM information_schema.sequences
                        WHERE sequence_schema NOT IN ('pg_catalog', 'information_schema')
                        ORDER BY sequence_schema, sequence_name
                        """,
                rs -> {
                    Map<String, SequenceMetadata> sequences = new LinkedHashMap<>();
                    while (rs.next()) {
                        SequenceMetadata metadata = new SequenceMetadata(
                                rs.getString("sequence_schema"),
                                rs.getString("sequence_name"),
                                rs.getString("data_type"),
                                rs.getString("start_value"),
                                rs.getString("minimum_value"),
                                rs.getString("maximum_value"),
                                rs.getString("increment"),
                                "YES".equalsIgnoreCase(rs.getString("cycle_option")));
                        sequences.put(key(metadata.schemaName(), metadata.sequenceName()), metadata);
                    }
                    return sequences;
                });
    }

    private static String key(String schema, String name) {
        return schema + "." + name;
    }

    private static final class TableMetadataBuilder {
        private final String schemaName;
        private final String tableName;
        private final Map<String, ColumnMetadata> columns = new LinkedHashMap<>();
        private ConstraintMetadata primaryKey;
        private final Map<String, ConstraintMetadata> uniqueConstraints = new LinkedHashMap<>();
        private final Map<String, ConstraintMetadata> foreignKeys = new LinkedHashMap<>();
        private final Map<String, IndexMetadata> indexes = new LinkedHashMap<>();

        private TableMetadataBuilder(String schemaName, String tableName) {
            this.schemaName = schemaName;
            this.tableName = tableName;
        }

        private TableMetadata build() {
            return new TableMetadata(schemaName, tableName, columns, primaryKey, uniqueConstraints, foreignKeys, indexes);
        }
    }
}
