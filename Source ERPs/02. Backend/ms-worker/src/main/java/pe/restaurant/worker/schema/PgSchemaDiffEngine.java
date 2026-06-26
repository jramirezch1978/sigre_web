package pe.restaurant.worker.schema;

import org.springframework.stereotype.Component;
import pe.restaurant.common.schema.SchemaModels.ColumnMetadata;
import pe.restaurant.common.schema.SchemaModels.ConstraintMetadata;
import pe.restaurant.common.schema.SchemaModels.DataTypeInfo;
import pe.restaurant.common.schema.SchemaModels.DdlStatement;
import pe.restaurant.common.schema.SchemaModels.IndexMetadata;
import pe.restaurant.common.schema.SchemaModels.SchemaSnapshot;
import pe.restaurant.common.schema.SchemaModels.SchemaSyncPlan;
import pe.restaurant.common.schema.SchemaModels.SequenceMetadata;
import pe.restaurant.common.schema.SchemaModels.TableMetadata;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.StringJoiner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Component
public class PgSchemaDiffEngine {

    private static final Pattern SEQ_NUM_PATTERN = Pattern.compile("_(\\d+)$");
    private static final Pattern FK_REFERENCES_PATTERN =
            Pattern.compile("(?i)REFERENCES\\s+(?:\"?([\\w]+)\"?\\.)?\"?([\\w]+)\"?\\s*\\((.+?)\\)");

    public SchemaSyncPlan calculatePlan(SchemaSnapshot template, SchemaSnapshot tenant) {
        List<DdlStatement> statements = new ArrayList<>();
        List<String> warnings = new ArrayList<>();
        Set<String> columnsPreCreatedByPhase1 = new HashSet<>();

        generateSequenceStatements(template, tenant, statements);
        generateNewTableStatements(template, tenant, statements, columnsPreCreatedByPhase1);
        generateExistingTableColumnStatements(template, tenant, statements, warnings, columnsPreCreatedByPhase1);
        generateConstraintAndIndexStatements(template, tenant, statements, warnings);

        return new SchemaSyncPlan(statements, warnings);
    }

    // ---- Sequences ----

    private void generateSequenceStatements(SchemaSnapshot template, SchemaSnapshot tenant,
                                            List<DdlStatement> statements) {
        for (SequenceMetadata sequence : template.sequences().values()) {
            if (tenant.sequences().containsKey(key(sequence.schemaName(), sequence.sequenceName()))) {
                continue;
            }
            statements.add(new DdlStatement(
                    "CREATE_SEQUENCE",
                    "Crear secuencia " + key(sequence.schemaName(), sequence.sequenceName()),
                    buildCreateSequence(sequence),
                    false));
        }
    }

    // ---- Tablas NUEVAS (Fase 1): CREATE TABLE + constraints + pre-crear columnas FK referenciadas ----

    private void generateNewTableStatements(
            SchemaSnapshot template, SchemaSnapshot tenant,
            List<DdlStatement> statements, Set<String> columnsPreCreatedByPhase1) {

        for (TableMetadata templateTable : template.tables().values()) {
            String tableKey = key(templateTable.schemaName(), templateTable.tableName());
            TableMetadata tenantTable = tenant.tables().get(tableKey);

            if (tenantTable != null) {
                continue;
            }

            statements.add(new DdlStatement(
                    "CREATE_TABLE",
                    "Crear tabla " + tableKey,
                    buildCreateTable(templateTable),
                    false));
            addConstraintsForNewTable(templateTable, tableKey, statements);
            preCreateFkReferencedColumns(templateTable, template, tenant,
                    statements, columnsPreCreatedByPhase1);
        }
    }

    /**
     * Para cada FK de una tabla nueva, verifica si la columna referenciada existe
     * en el tenant. Si no existe, la crea como Phase 1 (FK_PREREQ_COLUMN) y la
     * marca en columnsPreCreatedByPhase1 para que Phase 2 no la duplique.
     */
    private void preCreateFkReferencedColumns(
            TableMetadata newTable, SchemaSnapshot template, SchemaSnapshot tenant,
            List<DdlStatement> statements, Set<String> columnsPreCreatedByPhase1) {

        for (ConstraintMetadata fk : newTable.foreignKeys().values()) {
            if (fk.definition() == null) continue;

            Matcher m = FK_REFERENCES_PATTERN.matcher(fk.definition());
            if (!m.find()) continue;

            String refSchema = m.group(1) != null ? m.group(1) : newTable.schemaName();
            String refTableName = m.group(2);
            String refColumns = m.group(3);
            String refTableKey = key(refSchema, refTableName);

            TableMetadata tenantRefTable = tenant.tables().get(refTableKey);
            if (tenantRefTable == null) {
                continue;
            }

            TableMetadata templateRefTable = template.tables().get(refTableKey);
            if (templateRefTable == null) {
                continue;
            }

            for (String refColRaw : refColumns.split(",")) {
                String refCol = refColRaw.trim().replace("\"", "");
                if (tenantRefTable.columns().containsKey(refCol)) {
                    continue;
                }
                ColumnMetadata templateCol = templateRefTable.columns().get(refCol);
                if (templateCol == null) {
                    continue;
                }

                String columnKey = refTableKey + "." + refCol;
                if (columnsPreCreatedByPhase1.contains(columnKey)) {
                    continue;
                }

                statements.add(new DdlStatement(
                        "FK_PREREQ_COLUMN",
                        "Pre-crear columna " + columnKey + " (prerequisito FK de "
                                + key(newTable.schemaName(), newTable.tableName()) + ")",
                        buildAddColumn(templateRefTable, templateCol),
                        false));
                columnsPreCreatedByPhase1.add(columnKey);
            }
        }
    }

    // ---- Tablas EXISTENTES (Fase 2): ADD COLUMN, ALTER COLUMN TYPE ----

    private void generateExistingTableColumnStatements(
            SchemaSnapshot template, SchemaSnapshot tenant,
            List<DdlStatement> statements, List<String> warnings,
            Set<String> columnsPreCreatedByPhase1) {

        for (TableMetadata templateTable : template.tables().values()) {
            String tableKey = key(templateTable.schemaName(), templateTable.tableName());
            TableMetadata tenantTable = tenant.tables().get(tableKey);

            if (tenantTable == null) {
                continue;
            }

            for (ColumnMetadata templateColumn : templateTable.columns().values()) {
                String columnKey = tableKey + "." + templateColumn.columnName();

                if (columnsPreCreatedByPhase1.contains(columnKey)) {
                    continue;
                }

                ColumnMetadata tenantColumn = tenantTable.columns().get(templateColumn.columnName());

                if (tenantColumn == null) {
                    statements.add(new DdlStatement(
                            "ADD_COLUMN",
                            "Agregar columna " + columnKey,
                            buildAddColumn(templateTable, templateColumn),
                            false));
                    addForeignKeysForColumn(templateTable, tenantTable,
                            templateColumn.columnName(), tableKey, statements, warnings);
                    continue;
                }

                if (!normalize(templateColumn.dataType()).equals(normalize(tenantColumn.dataType()))) {
                    evaluateColumnTypeChange(templateTable, templateColumn, tenantColumn,
                            tableKey, statements, warnings);
                }
            }
        }
    }

    /**
     * Al agregar una columna nueva, busca si el template tiene un FK
     * que involucra esa columna y lo agrega junto con la columna.
     */
    private void addForeignKeysForColumn(TableMetadata templateTable, TableMetadata tenantTable,
                                         String columnName, String tableKey,
                                         List<DdlStatement> statements, List<String> warnings) {
        for (ConstraintMetadata fk : templateTable.foreignKeys().values()) {
            String defLower = fk.definition() == null ? "" : fk.definition().toLowerCase();
            if (!defLower.contains("(" + columnName.toLowerCase() + ")")
                    && !defLower.contains(", " + columnName.toLowerCase())
                    && !defLower.contains(columnName.toLowerCase() + ",")) {
                continue;
            }
            if (hasMatchingConstraintDef(fk, tenantTable.foreignKeys())) {
                continue;
            }
            Map<String, Integer> counters = new HashMap<>();
            String newName = nextSequentialName("FK", templateTable.tableName(),
                    tenantTable.foreignKeys(), counters);
            statements.add(new DdlStatement(
                    "ADD_COLUMN_FK",
                    "Agregar FK " + newName + " para columna " + columnName + " en " + tableKey,
                    buildAddConstraintWithName(templateTable, newName, fk.definition()),
                    false));
            warnings.add("FK " + newName + " creado junto con columna " + columnName);
        }
    }

    /**
     * Compara tipos de columna. Si mismo tipo base y template tiene mayor tamaño,
     * genera ALTER COLUMN TYPE. Si tipo base difiere, también genera ALTER TYPE
     * con cláusula USING para el cast.
     */
    private void evaluateColumnTypeChange(TableMetadata table,
                                          ColumnMetadata templateCol, ColumnMetadata tenantCol,
                                          String tableKey,
                                          List<DdlStatement> statements, List<String> warnings) {

        DataTypeInfo tplType = DataTypeInfo.parse(templateCol.dataType());
        DataTypeInfo tntType = DataTypeInfo.parse(tenantCol.dataType());

        if (tplType.hasSameBaseType(tntType)) {
            if (tplType.isLargerThan(tntType)) {
                statements.add(new DdlStatement(
                        "ALTER_COLUMN_TYPE",
                        "Actualizar tipo " + tableKey + "." + templateCol.columnName()
                                + " de " + tenantCol.dataType() + " a " + templateCol.dataType(),
                        buildAlterColumnType(table, templateCol),
                        false));
            }
        } else {
            statements.add(new DdlStatement(
                    "ALTER_COLUMN_TYPE",
                    "Cambiar tipo " + tableKey + "." + templateCol.columnName()
                            + " de " + tenantCol.dataType() + " a " + templateCol.dataType(),
                    buildAlterColumnTypeWithCast(table, templateCol),
                    false));
            warnings.add("Tipo base cambiado en " + tableKey + "." + templateCol.columnName()
                    + ": " + tenantCol.dataType() + " -> " + templateCol.dataType());
        }
    }

    // ---- Constraints & Indexes para tablas NUEVAS (Fase 1) ----

    private void addConstraintsForNewTable(TableMetadata templateTable, String tableKey,
                                           List<DdlStatement> statements) {
        if (templateTable.primaryKey() != null) {
            statements.add(new DdlStatement(
                    "NEW_TABLE_PK",
                    "Agregar PK en " + tableKey,
                    buildAddConstraint(templateTable, templateTable.primaryKey()),
                    false));
        }
        templateTable.uniqueConstraints().values().stream()
                .sorted(Comparator.comparing(ConstraintMetadata::constraintName))
                .forEach(ux -> statements.add(new DdlStatement(
                        "NEW_TABLE_UX",
                        "Agregar unique " + ux.constraintName() + " en " + tableKey,
                        buildAddConstraint(templateTable, ux),
                        false)));
        templateTable.foreignKeys().values().stream()
                .sorted(Comparator.comparing(ConstraintMetadata::constraintName))
                .forEach(fk -> statements.add(new DdlStatement(
                        "NEW_TABLE_FK",
                        "Agregar FK " + fk.constraintName() + " en " + tableKey,
                        buildAddConstraint(templateTable, fk),
                        false)));
        templateTable.indexes().values().stream()
                .sorted(Comparator.comparing(IndexMetadata::indexName))
                .forEach(ix -> statements.add(new DdlStatement(
                        "NEW_TABLE_IX",
                        "Crear indice " + ix.indexName(),
                        withIfNotExists(ix.definition()),
                        false)));
    }

    // ---- Constraints & Indexes para tablas EXISTENTES (Fase 3) ----

    private void generateConstraintAndIndexStatements(
            SchemaSnapshot template, SchemaSnapshot tenant,
            List<DdlStatement> statements, List<String> warnings) {

        Map<String, Integer> ixCounters = new HashMap<>();
        Map<String, Integer> fkCounters = new HashMap<>();
        Map<String, Integer> uxCounters = new HashMap<>();

        for (TableMetadata templateTable : template.tables().values()) {
            String tableKey = key(templateTable.schemaName(), templateTable.tableName());
            TableMetadata tenantTable = tenant.tables().get(tableKey);

            if (tenantTable == null) {
                continue;
            }

            addMissingPrimaryKey(templateTable, tenantTable, tableKey, statements);
            addMissingUniqueConstraints(templateTable, tenantTable, tableKey, statements, uxCounters, warnings);
            addMissingForeignKeys(templateTable, tenantTable, tableKey, statements, fkCounters, warnings);
            addMissingIndexes(templateTable, tenantTable, tableKey, statements, ixCounters, warnings);
        }
    }

    private void addMissingPrimaryKey(TableMetadata templateTable, TableMetadata tenantTable,
                                      String tableKey, List<DdlStatement> statements) {
        if (templateTable.primaryKey() != null && tenantTable.primaryKey() == null) {
            statements.add(new DdlStatement(
                    "ADD_PRIMARY_KEY",
                    "Agregar PK en " + tableKey,
                    buildAddConstraint(templateTable, templateTable.primaryKey()),
                    false));
        }
    }

    private void addMissingUniqueConstraints(TableMetadata templateTable, TableMetadata tenantTable,
                                             String tableKey, List<DdlStatement> statements,
                                             Map<String, Integer> counters, List<String> warnings) {
        for (ConstraintMetadata templateUx : templateTable.uniqueConstraints().values()) {
            if (hasMatchingConstraintDef(templateUx, tenantTable.uniqueConstraints())) {
                continue;
            }
            String newName = nextSequentialName("UX", templateTable.tableName(),
                    tenantTable.uniqueConstraints(), counters);
            statements.add(new DdlStatement(
                    "ADD_UNIQUE",
                    "Agregar unique " + newName + " en " + tableKey,
                    buildAddConstraintWithName(templateTable, newName, templateUx.definition()),
                    false));
            warnings.add("UX creado como " + newName + " (estructura de " + templateUx.constraintName() + ")");
        }
    }

    private void addMissingForeignKeys(TableMetadata templateTable, TableMetadata tenantTable,
                                       String tableKey, List<DdlStatement> statements,
                                       Map<String, Integer> counters, List<String> warnings) {
        for (ConstraintMetadata templateFk : templateTable.foreignKeys().values()) {
            if (hasMatchingConstraintDef(templateFk, tenantTable.foreignKeys())) {
                continue;
            }
            String newName = nextSequentialName("FK", templateTable.tableName(),
                    tenantTable.foreignKeys(), counters);
            statements.add(new DdlStatement(
                    "ADD_FOREIGN_KEY",
                    "Agregar FK " + newName + " en " + tableKey,
                    buildAddConstraintWithName(templateTable, newName, templateFk.definition()),
                    false));
            warnings.add("FK creado como " + newName + " (estructura de " + templateFk.constraintName() + ")");
        }
    }

    private void addMissingIndexes(TableMetadata templateTable, TableMetadata tenantTable,
                                   String tableKey, List<DdlStatement> statements,
                                   Map<String, Integer> counters, List<String> warnings) {
        for (IndexMetadata templateIdx : templateTable.indexes().values()) {
            if (hasMatchingIndexStructure(templateIdx, tenantTable)) {
                continue;
            }
            String newName = nextSequentialName("IX", templateTable.tableName(),
                    tenantTable.indexes(), counters);
            String newDef = replaceIndexNameInDef(templateIdx.definition(), newName);
            statements.add(new DdlStatement(
                    "CREATE_INDEX",
                    "Crear indice " + newName + " en " + tableKey,
                    withIfNotExists(newDef),
                    false));
            warnings.add("IX creado como " + newName + " (estructura de " + templateIdx.indexName() + ")");
        }
    }

    // ---- Structural comparison helpers ----

    private boolean hasMatchingConstraintDef(ConstraintMetadata template,
                                             Map<String, ConstraintMetadata> tenantConstraints) {
        String tplDef = normalize(template.definition());
        for (ConstraintMetadata tenant : tenantConstraints.values()) {
            if (tplDef.equals(normalize(tenant.definition()))) {
                return true;
            }
        }
        return false;
    }

    private boolean hasMatchingIndexStructure(IndexMetadata templateIdx, TableMetadata tenantTable) {
        String tplStructure = extractIndexStructure(templateIdx.definition());
        for (IndexMetadata tenantIdx : tenantTable.indexes().values()) {
            if (tplStructure.equals(extractIndexStructure(tenantIdx.definition()))) {
                return true;
            }
        }
        return false;
    }

    private String extractIndexStructure(String definition) {
        if (definition == null) return "";
        String lower = definition.toLowerCase().trim().replaceAll("\\s+", " ");
        int usingIdx = lower.indexOf(" using ");
        if (usingIdx >= 0) {
            return lower.substring(usingIdx + 7).trim();
        }
        int parenStart = lower.indexOf('(');
        int parenEnd = lower.lastIndexOf(')');
        if (parenStart >= 0 && parenEnd > parenStart) {
            return lower.substring(parenStart, parenEnd + 1);
        }
        return lower;
    }

    // ---- Sequential naming ----

    private String nextSequentialName(String prefix, String tableName,
                                      Map<String, ?> tenantExisting,
                                      Map<String, Integer> counters) {
        String upperTable = tableName.toUpperCase();
        String counterKey = prefix + "_" + upperTable;
        Integer current = counters.get(counterKey);
        if (current == null) {
            current = findMaxSeqNumber(prefix, upperTable, tenantExisting);
        }
        current++;
        counters.put(counterKey, current);
        return prefix + "_" + upperTable + "_" + String.format("%02d", current);
    }

    private int findMaxSeqNumber(String prefix, String upperTable, Map<String, ?> existing) {
        String expectedPrefix = (prefix + "_" + upperTable + "_").toUpperCase();
        int max = 0;
        for (String name : existing.keySet()) {
            String upper = name.toUpperCase();
            if (upper.startsWith(expectedPrefix)) {
                Matcher m = SEQ_NUM_PATTERN.matcher(upper);
                if (m.find()) {
                    int num = Integer.parseInt(m.group(1));
                    if (num > max) max = num;
                }
            }
        }
        return max;
    }

    // ---- DDL builders ----

    private String buildCreateSequence(SequenceMetadata seq) {
        return "CREATE SEQUENCE IF NOT EXISTS "
                + q(seq.schemaName()) + "." + q(seq.sequenceName())
                + " AS " + seq.dataType()
                + " INCREMENT BY " + seq.increment()
                + " MINVALUE " + seq.minimumValue()
                + " MAXVALUE " + seq.maximumValue()
                + " START WITH " + seq.startValue()
                + (seq.cycle() ? " CYCLE" : " NO CYCLE");
    }

    private String buildCreateTable(TableMetadata table) {
        StringJoiner joiner = new StringJoiner(", ");
        table.columns().values().stream()
                .sorted(Comparator.comparing(ColumnMetadata::ordinalPosition))
                .forEach(col -> joiner.add(buildColumnDef(col)));
        return "CREATE TABLE IF NOT EXISTS "
                + q(table.schemaName()) + "." + q(table.tableName())
                + " (" + joiner + ")";
    }

    private String buildAddColumn(TableMetadata table, ColumnMetadata column) {
        return "ALTER TABLE " + q(table.schemaName()) + "." + q(table.tableName())
                + " ADD COLUMN IF NOT EXISTS " + buildColumnDef(column);
    }

    private String buildAlterColumnType(TableMetadata table, ColumnMetadata column) {
        return "ALTER TABLE " + q(table.schemaName()) + "." + q(table.tableName())
                + " ALTER COLUMN " + q(column.columnName()) + " TYPE " + column.dataType();
    }

    private String buildAlterColumnTypeWithCast(TableMetadata table, ColumnMetadata column) {
        return "ALTER TABLE " + q(table.schemaName()) + "." + q(table.tableName())
                + " ALTER COLUMN " + q(column.columnName()) + " TYPE " + column.dataType()
                + " USING " + q(column.columnName()) + "::" + column.dataType();
    }

    private String buildColumnDef(ColumnMetadata column) {
        StringBuilder sb = new StringBuilder()
                .append(q(column.columnName())).append(" ").append(column.dataType());
        if (column.defaultExpression() != null && !column.defaultExpression().isBlank()) {
            sb.append(" DEFAULT ").append(column.defaultExpression());
        }
        if (!column.nullable()) {
            sb.append(" NOT NULL");
        }
        return sb.toString();
    }

    private String buildAddConstraint(TableMetadata table, ConstraintMetadata constraint) {
        return "ALTER TABLE " + q(table.schemaName()) + "." + q(table.tableName())
                + " ADD CONSTRAINT " + q(constraint.constraintName()) + " " + constraint.definition();
    }

    private String buildAddConstraintWithName(TableMetadata table, String name, String definition) {
        return "ALTER TABLE " + q(table.schemaName()) + "." + q(table.tableName())
                + " ADD CONSTRAINT " + q(name) + " " + definition;
    }

    private String replaceIndexNameInDef(String definition, String newName) {
        return definition.replaceFirst(
                "(?i)(CREATE\\s+(?:UNIQUE\\s+)?INDEX\\s+)(?:IF\\s+NOT\\s+EXISTS\\s+)?\\S+",
                "$1" + q(newName));
    }

    private String withIfNotExists(String indexDef) {
        String result = indexDef.replaceFirst("(?i)^CREATE UNIQUE INDEX ",
                "CREATE UNIQUE INDEX IF NOT EXISTS ");
        if (!result.equals(indexDef)) return result;
        return indexDef.replaceFirst("(?i)^CREATE INDEX ", "CREATE INDEX IF NOT EXISTS ");
    }

    // ---- Utilities ----

    private static String q(String id) {
        return "\"" + id.replace("\"", "\"\"") + "\"";
    }

    private static String key(String schema, String name) {
        return schema + "." + name;
    }

    private static String normalize(String value) {
        return value == null ? "" : value.trim().replaceAll("\\s+", " ").toLowerCase();
    }
}
