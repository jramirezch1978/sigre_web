package pe.restaurant.common.schema;

import jakarta.persistence.Column;
import jakarta.persistence.Embedded;
import jakarta.persistence.EmbeddedId;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import pe.restaurant.common.schema.SchemaModels.ColumnMetadata;
import pe.restaurant.common.schema.SchemaModels.SchemaSnapshot;
import pe.restaurant.common.schema.SchemaModels.TableMetadata;

import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Valida que el mapeo de entidades JPA sea consistente con un esquema PostgreSQL real
 * (representado por un {@link SchemaSnapshot} leído con {@link PgSchemaMetadataReader}).
 * <p>
 * Detecta dos clases de inconsistencias de alto impacto en runtime (con
 * {@code hibernate.ddl-auto=none} no se detectan al arrancar):
 * <ul>
 *   <li><b>Tabla inexistente</b>: la entidad apunta a una tabla que no está en el esquema.</li>
 *   <li><b>Columna fantasma</b>: un campo persistente mapea a una columna que no existe.</li>
 * </ul>
 * La validación es de <b>existencia</b> (nombre de tabla/columna); deliberadamente no compara
 * tipos para evitar falsos positivos por equivalencias del dialecto Hibernate.
 * <p>
 * Lógica pura y sin dependencias de Spring: testeable con snapshots sintéticos.
 */
public final class EntitySchemaValidator {

    /** Tipo de inconsistencia detectada. */
    public enum IssueType {
        MISSING_TABLE,
        MISSING_COLUMN
    }

    /** Inconsistencia concreta entre una entidad y el esquema. */
    public record SchemaIssue(
            IssueType type,
            String entityClass,
            String schema,
            String table,
            String column,
            String detail
    ) {
        @Override
        public String toString() {
            return "[" + type + "] " + entityClass + " -> " + detail;
        }
    }

    /** Resultado de validar un conjunto de entidades. */
    public record EntitySchemaReport(List<SchemaIssue> issues) {
        public boolean isValid() {
            return issues.isEmpty();
        }

        public String describe() {
            if (issues.isEmpty()) {
                return "Esquema consistente con las entidades JPA.";
            }
            StringBuilder sb = new StringBuilder("Se encontraron ")
                    .append(issues.size())
                    .append(" inconsistencia(s) entidad/esquema:\n");
            for (SchemaIssue issue : issues) {
                sb.append("  - ").append(issue).append('\n');
            }
            return sb.toString();
        }
    }

    /**
     * Valida cada entidad contra el snapshot.
     *
     * @param snapshot      esquema real (BD/template)
     * @param entityClasses clases anotadas con {@code @Entity}
     * @return reporte con las inconsistencias encontradas
     */
    public EntitySchemaReport validate(SchemaSnapshot snapshot, Iterable<Class<?>> entityClasses) {
        List<SchemaIssue> issues = new ArrayList<>();
        for (Class<?> entityClass : entityClasses) {
            validateEntity(snapshot, entityClass, issues);
        }
        return new EntitySchemaReport(issues);
    }

    private void validateEntity(SchemaSnapshot snapshot, Class<?> entityClass, List<SchemaIssue> issues) {
        String schema = resolveSchema(entityClass);
        String table = resolveTable(entityClass);

        TableMetadata tableMetadata = findTable(snapshot, schema, table);
        if (tableMetadata == null) {
            issues.add(new SchemaIssue(IssueType.MISSING_TABLE, entityClass.getName(),
                    schema, table, null,
                    "tabla '" + qualify(schema, table) + "' no existe en el esquema"));
            return;
        }

        Map<String, String> columnsLower = lowerKeyView(tableMetadata.columns());
        for (Field field : persistentFields(entityClass)) {
            String column = resolveColumnName(field);
            if (column == null) {
                continue;
            }
            if (!columnsLower.containsKey(column.toLowerCase(Locale.ROOT))) {
                issues.add(new SchemaIssue(IssueType.MISSING_COLUMN, entityClass.getName(),
                        tableMetadata.schemaName(), tableMetadata.tableName(), column,
                        "campo '" + field.getName() + "' -> columna '" + column
                                + "' no existe en '" + qualify(tableMetadata.schemaName(), tableMetadata.tableName()) + "'"));
            }
        }
    }

    private static List<Field> persistentFields(Class<?> entityClass) {
        List<Field> fields = new ArrayList<>();
        Class<?> current = entityClass;
        while (current != null && current != Object.class) {
            for (Field field : current.getDeclaredFields()) {
                if (isPersistent(field)) {
                    fields.add(field);
                }
            }
            current = current.getSuperclass();
        }
        return fields;
    }

    private static boolean isPersistent(Field field) {
        int mods = field.getModifiers();
        if (Modifier.isStatic(mods) || Modifier.isTransient(mods) || field.isSynthetic()) {
            return false;
        }
        if (field.isAnnotationPresent(Transient.class)) {
            return false;
        }
        if (field.isAnnotationPresent(OneToMany.class) || field.isAnnotationPresent(ManyToMany.class)) {
            return false;
        }
        OneToOne oneToOne = field.getAnnotation(OneToOne.class);
        if (oneToOne != null && !oneToOne.mappedBy().isBlank()) {
            return false;
        }
        // @Embedded / @EmbeddedId requerirían recursión; se omiten (no usados en este dominio).
        return !field.isAnnotationPresent(Embedded.class) && !field.isAnnotationPresent(EmbeddedId.class);
    }

    private static String resolveColumnName(Field field) {
        Column column = field.getAnnotation(Column.class);
        if (column != null && !column.name().isBlank()) {
            return column.name();
        }
        JoinColumn joinColumn = field.getAnnotation(JoinColumn.class);
        if (joinColumn != null && !joinColumn.name().isBlank()) {
            return joinColumn.name();
        }
        // Relación @ManyToOne sin @JoinColumn explícito: Hibernate genera <campo>_id.
        if (field.isAnnotationPresent(ManyToOne.class)) {
            return camelToSnake(field.getName()) + "_id";
        }
        return camelToSnake(field.getName());
    }

    private static String resolveSchema(Class<?> entityClass) {
        Table table = findTableAnnotation(entityClass);
        if (table != null && !table.schema().isBlank()) {
            return table.schema();
        }
        return "";
    }

    private static String resolveTable(Class<?> entityClass) {
        Table table = findTableAnnotation(entityClass);
        if (table != null && !table.name().isBlank()) {
            return table.name();
        }
        return camelToSnake(entityClass.getSimpleName());
    }

    private static Table findTableAnnotation(Class<?> entityClass) {
        Class<?> current = entityClass;
        while (current != null && current != Object.class) {
            Table table = current.getDeclaredAnnotation(Table.class);
            if (table != null) {
                return table;
            }
            current = current.getSuperclass();
        }
        return null;
    }

    private static TableMetadata findTable(SchemaSnapshot snapshot, String schema, String table) {
        if (!schema.isBlank()) {
            TableMetadata exact = snapshot.tables().get(schema + "." + table);
            if (exact != null) {
                return exact;
            }
        }
        // Sin schema explícito: buscar por nombre de tabla en cualquier schema.
        for (TableMetadata candidate : snapshot.tables().values()) {
            if (candidate.tableName().equalsIgnoreCase(table)
                    && (schema.isBlank() || candidate.schemaName().equalsIgnoreCase(schema))) {
                return candidate;
            }
        }
        return null;
    }

    private static Map<String, String> lowerKeyView(Map<String, ColumnMetadata> columns) {
        Map<String, String> view = new java.util.HashMap<>();
        for (String key : columns.keySet()) {
            view.put(key.toLowerCase(Locale.ROOT), key);
        }
        return view;
    }

    private static String qualify(String schema, String table) {
        return schema == null || schema.isBlank() ? table : schema + "." + table;
    }

    /** Imita la estrategia por defecto de Spring Boot (CamelCaseToUnderscores). */
    static String camelToSnake(String name) {
        StringBuilder sb = new StringBuilder(name.length() + 8);
        for (int i = 0; i < name.length(); i++) {
            char c = name.charAt(i);
            if (Character.isUpperCase(c)) {
                if (i > 0) {
                    sb.append('_');
                }
                sb.append(Character.toLowerCase(c));
            } else {
                sb.append(c);
            }
        }
        return sb.toString();
    }

}
