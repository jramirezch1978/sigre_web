package com.sigre.sync.worker.schema;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import com.sigre.common.schema.SchemaModels.*;

import java.util.LinkedHashMap;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

class PgSchemaDiffEngineTest {

    private PgSchemaDiffEngine engine;

    @BeforeEach
    void setUp() {
        engine = new PgSchemaDiffEngine();
    }

    // ---- CA-01 ----

    @Nested
    @DisplayName("CA-01: Tenant alineado con template -> sin cambios")
    class AlignedSchemas {

        @Test
        @DisplayName("Ambos vacios -> plan vacio")
        void bothEmpty() {
            SchemaSnapshot template = SchemaSnapshot.empty("template");
            SchemaSnapshot tenant = SchemaSnapshot.empty("tenant");

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements()).isEmpty();
            assertThat(plan.warnings()).isEmpty();
        }

        @Test
        @DisplayName("Misma tabla y columnas -> sin statements")
        void identicalTable() {
            TableMetadata table = buildTable("public", "products",
                    Map.of("id", col("public", "products", "id", "bigint", false, null, 1),
                            "name", col("public", "products", "name", "character varying(100)", true, null, 2)));

            SchemaSnapshot template = snapshot("template", Map.of("public.products", table));
            SchemaSnapshot tenant = snapshot("tenant", Map.of("public.products", table));

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements()).isEmpty();
        }
    }

    // ---- CA-02 ----

    @Nested
    @DisplayName("CA-02: Tenant con objetos faltantes -> expansión")
    class MissingObjects {

        @Test
        @DisplayName("Tabla faltante en tenant -> CREATE TABLE")
        void missingTable() {
            TableMetadata table = buildTable("public", "categories",
                    Map.of("id", col("public", "categories", "id", "bigint", false, null, 1)));

            SchemaSnapshot template = snapshot("template", Map.of("public.categories", table));
            SchemaSnapshot tenant = SchemaSnapshot.empty("tenant");

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements()).anyMatch(s -> s.category().equals("CREATE_TABLE"));
        }

        @Test
        @DisplayName("Columna faltante en tenant -> ADD COLUMN")
        void missingColumn() {
            TableMetadata templateTable = buildTable("public", "products",
                    Map.of("id", col("public", "products", "id", "bigint", false, null, 1),
                            "price", col("public", "products", "price", "numeric(10,2)", true, null, 2)));

            TableMetadata tenantTable = buildTable("public", "products",
                    Map.of("id", col("public", "products", "id", "bigint", false, null, 1)));

            SchemaSnapshot template = snapshot("template", Map.of("public.products", templateTable));
            SchemaSnapshot tenant = snapshot("tenant", Map.of("public.products", tenantTable));

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements()).hasSize(1);
            assertThat(plan.statements().get(0).category()).isEqualTo("ADD_COLUMN");
            assertThat(plan.statements().get(0).sql()).contains("price");
        }

        @Test
        @DisplayName("Secuencia faltante en tenant -> CREATE SEQUENCE")
        void missingSequence() {
            SequenceMetadata seq = new SequenceMetadata("public", "products_id_seq", "bigint", "1", "1", "9223372036854775807", "1", false);
            SchemaSnapshot template = new SchemaSnapshot("template", new LinkedHashMap<>(), Map.of("public.products_id_seq", seq));
            SchemaSnapshot tenant = SchemaSnapshot.empty("tenant");

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements()).hasSize(1);
            assertThat(plan.statements().get(0).category()).isEqualTo("CREATE_SEQUENCE");
        }

        @Test
        @DisplayName("Indice faltante en tenant -> CREATE INDEX")
        void missingIndex() {
            Map<String, IndexMetadata> templateIndexes = new LinkedHashMap<>();
            templateIndexes.put("ix_products_name", new IndexMetadata("public", "products", "ix_products_name",
                    "CREATE INDEX ix_products_name ON public.products USING btree (name)"));

            TableMetadata templateTable = new TableMetadata("public", "products",
                    Map.of("id", col("public", "products", "id", "bigint", false, null, 1)),
                    null, new LinkedHashMap<>(), new LinkedHashMap<>(), templateIndexes);

            TableMetadata tenantTable = new TableMetadata("public", "products",
                    Map.of("id", col("public", "products", "id", "bigint", false, null, 1)),
                    null, new LinkedHashMap<>(), new LinkedHashMap<>(), new LinkedHashMap<>());

            SchemaSnapshot template = snapshot("template", Map.of("public.products", templateTable));
            SchemaSnapshot tenant = snapshot("tenant", Map.of("public.products", tenantTable));

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements()).anyMatch(s -> s.category().equals("CREATE_INDEX"));
        }

        @Test
        @DisplayName("FK faltante en tenant -> ADD FOREIGN KEY")
        void missingForeignKey() {
            Map<String, ConstraintMetadata> templateFks = new LinkedHashMap<>();
            templateFks.put("fk_product_category", new ConstraintMetadata("public", "products",
                    "fk_product_category", "f", "FOREIGN KEY (category_id) REFERENCES public.categories(id)"));

            TableMetadata templateTable = new TableMetadata("public", "products",
                    Map.of("id", col("public", "products", "id", "bigint", false, null, 1)),
                    null, new LinkedHashMap<>(), templateFks, new LinkedHashMap<>());

            TableMetadata tenantTable = new TableMetadata("public", "products",
                    Map.of("id", col("public", "products", "id", "bigint", false, null, 1)),
                    null, new LinkedHashMap<>(), new LinkedHashMap<>(), new LinkedHashMap<>());

            SchemaSnapshot template = snapshot("template", Map.of("public.products", templateTable));
            SchemaSnapshot tenant = snapshot("tenant", Map.of("public.products", tenantTable));

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements()).anyMatch(s -> s.category().equals("ADD_FOREIGN_KEY"));
        }
    }

    // ---- CA-04 ----

    @Nested
    @DisplayName("CA-04: Cambios destructivos bloqueados por defecto")
    class DestructiveChanges {

        @Test
        @DisplayName("Cambio de tipo de columna -> ALTER COLUMN TYPE con USING cast")
        void typeChange() {
            TableMetadata templateTable = buildTable("public", "products",
                    Map.of("price", col("public", "products", "price", "numeric(10,2)", true, null, 1)));

            TableMetadata tenantTable = buildTable("public", "products",
                    Map.of("price", col("public", "products", "price", "integer", true, null, 1)));

            SchemaSnapshot template = snapshot("template", Map.of("public.products", templateTable));
            SchemaSnapshot tenant = snapshot("tenant", Map.of("public.products", tenantTable));

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements()).anyMatch(s -> s.category().equals("ALTER_COLUMN_TYPE"));
        }

        @Test
        @DisplayName("Misma nulabilidad diferente -> sin cambios (no se gestiona)")
        void nullabilityChange() {
            TableMetadata templateTable = buildTable("public", "products",
                    Map.of("name", col("public", "products", "name", "character varying(100)", false, null, 1)));

            TableMetadata tenantTable = buildTable("public", "products",
                    Map.of("name", col("public", "products", "name", "character varying(100)", true, null, 1)));

            SchemaSnapshot template = snapshot("template", Map.of("public.products", templateTable));
            SchemaSnapshot tenant = snapshot("tenant", Map.of("public.products", tenantTable));

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements()).isEmpty();
        }

        @Test
        @DisplayName("Tabla extra en tenant -> se ignora sin warnings ni statements")
        void extraTableInTenantIgnored() {
            TableMetadata extraTable = buildTable("public", "legacy_data",
                    Map.of("id", col("public", "legacy_data", "id", "bigint", false, null, 1)));

            SchemaSnapshot template = SchemaSnapshot.empty("template");
            SchemaSnapshot tenant = snapshot("tenant", Map.of("public.legacy_data", extraTable));

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements()).isEmpty();
            assertThat(plan.warnings()).isEmpty();
        }

        @Test
        @DisplayName("Columna extra en tenant -> se ignora sin warnings ni statements")
        void extraColumnInTenantIgnored() {
            TableMetadata templateTable = buildTable("public", "products",
                    Map.of("id", col("public", "products", "id", "bigint", false, null, 1)));

            TableMetadata tenantTable = buildTable("public", "products",
                    Map.of("id", col("public", "products", "id", "bigint", false, null, 1),
                            "legacy_field", col("public", "products", "legacy_field", "text", true, null, 2)));

            SchemaSnapshot template = snapshot("template", Map.of("public.products", templateTable));
            SchemaSnapshot tenant = snapshot("tenant", Map.of("public.products", tenantTable));

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements()).isEmpty();
            assertThat(plan.warnings()).isEmpty();
        }
    }

    // ---- DDL generation correctness ----

    @Nested
    @DisplayName("Generacion de DDL correcta")
    class DdlGeneration {

        @Test
        @DisplayName("CREATE TABLE incluye IF NOT EXISTS y columnas con tipos")
        void createTableSyntax() {
            TableMetadata table = buildTable("core", "categories",
                    Map.of("id", col("core", "categories", "id", "bigint", false, "nextval('core.categories_id_seq'::regclass)", 1),
                            "name", col("core", "categories", "name", "character varying(100)", false, null, 2)));

            SchemaSnapshot template = snapshot("template", Map.of("core.categories", table));
            SchemaSnapshot tenant = SchemaSnapshot.empty("tenant");

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            DdlStatement createStmt = plan.statements().stream()
                    .filter(s -> s.category().equals("CREATE_TABLE"))
                    .findFirst().orElseThrow();

            assertThat(createStmt.sql()).contains("CREATE TABLE IF NOT EXISTS");
            assertThat(createStmt.sql()).contains("\"core\".\"categories\"");
            assertThat(createStmt.sql()).contains("\"id\"");
            assertThat(createStmt.sql()).contains("\"name\"");
        }

        @Test
        @DisplayName("ADD COLUMN incluye IF NOT EXISTS")
        void addColumnSyntax() {
            TableMetadata templateTable = buildTable("public", "items",
                    Map.of("id", col("public", "items", "id", "bigint", false, null, 1),
                            "description", col("public", "items", "description", "text", true, null, 2)));

            TableMetadata tenantTable = buildTable("public", "items",
                    Map.of("id", col("public", "items", "id", "bigint", false, null, 1)));

            SchemaSnapshot template = snapshot("template", Map.of("public.items", templateTable));
            SchemaSnapshot tenant = snapshot("tenant", Map.of("public.items", tenantTable));

            SchemaSyncPlan plan = engine.calculatePlan(template, tenant);

            assertThat(plan.statements().get(0).sql()).contains("ADD COLUMN IF NOT EXISTS");
        }
    }

    // ---- Helpers ----

    private static ColumnMetadata col(String schema, String table, String column, String dataType,
                                       boolean nullable, String defaultExpr, int ordinal) {
        return new ColumnMetadata(schema, table, column, dataType, nullable, defaultExpr, ordinal);
    }

    private static TableMetadata buildTable(String schema, String table, Map<String, ColumnMetadata> columns) {
        return new TableMetadata(schema, table, new LinkedHashMap<>(columns),
                null, new LinkedHashMap<>(), new LinkedHashMap<>(), new LinkedHashMap<>());
    }

    private static SchemaSnapshot snapshot(String dbName, Map<String, TableMetadata> tables) {
        return new SchemaSnapshot(dbName, new LinkedHashMap<>(tables), new LinkedHashMap<>());
    }
}
