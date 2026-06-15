package com.sigre.common.schema;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Modelos reutilizables para introspección de esquemas PostgreSQL.
 * Usados por ms-worker y potencialmente por cualquier servicio que necesite
 * leer/comparar metadatos de tablas, columnas, índices, constraints y secuencias.
 */
public final class SchemaModels {

    private SchemaModels() {
    }

    public record DataTypeInfo(String rawType, String baseType, Integer length, Integer scale) {

        private static final Pattern TYPE_WITH_PARAMS =
                Pattern.compile("^(.+?)\\s*\\(\\s*(\\d+)\\s*(?:,\\s*(\\d+)\\s*)?\\)$");

        public static DataTypeInfo parse(String dataType) {
            if (dataType == null || dataType.isBlank()) {
                return new DataTypeInfo("", "", null, null);
            }
            String trimmed = dataType.trim().toLowerCase();
            Matcher m = TYPE_WITH_PARAMS.matcher(trimmed);
            if (m.matches()) {
                return new DataTypeInfo(
                        trimmed,
                        m.group(1).trim(),
                        Integer.parseInt(m.group(2)),
                        m.group(3) != null ? Integer.parseInt(m.group(3)) : null);
            }
            return new DataTypeInfo(trimmed, trimmed, null, null);
        }

        public boolean hasSameBaseType(DataTypeInfo other) {
            return this.baseType.equals(other.baseType);
        }

        public boolean isLargerThan(DataTypeInfo other) {
            if (this.length == null || other.length == null) return false;
            if (!this.length.equals(other.length)) return this.length > other.length;
            if (this.scale == null && other.scale == null) return false;
            if (this.scale == null || other.scale == null) return false;
            return this.scale > other.scale;
        }
    }

    public record SchemaSnapshot(
            String databaseName,
            Map<String, TableMetadata> tables,
            Map<String, SequenceMetadata> sequences
    ) {
        public static SchemaSnapshot empty(String databaseName) {
            return new SchemaSnapshot(databaseName, new LinkedHashMap<>(), new LinkedHashMap<>());
        }
    }

    public record TableMetadata(
            String schemaName,
            String tableName,
            Map<String, ColumnMetadata> columns,
            ConstraintMetadata primaryKey,
            Map<String, ConstraintMetadata> uniqueConstraints,
            Map<String, ConstraintMetadata> foreignKeys,
            Map<String, IndexMetadata> indexes
    ) {
    }

    public record ColumnMetadata(
            String schemaName,
            String tableName,
            String columnName,
            String dataType,
            boolean nullable,
            String defaultExpression,
            Integer ordinalPosition
    ) {
    }

    public record ConstraintMetadata(
            String schemaName,
            String tableName,
            String constraintName,
            String constraintType,
            String definition
    ) {
    }

    public record IndexMetadata(
            String schemaName,
            String tableName,
            String indexName,
            String definition
    ) {
    }

    public record SequenceMetadata(
            String schemaName,
            String sequenceName,
            String dataType,
            String startValue,
            String minimumValue,
            String maximumValue,
            String increment,
            boolean cycle
    ) {
    }

    public record DdlStatement(
            String category,
            String description,
            String sql,
            boolean destructive
    ) {
    }

    public record SchemaSyncPlan(
            List<DdlStatement> statements,
            List<String> warnings
    ) {
        public static SchemaSyncPlan empty() {
            return new SchemaSyncPlan(new ArrayList<>(), new ArrayList<>());
        }
    }
}
