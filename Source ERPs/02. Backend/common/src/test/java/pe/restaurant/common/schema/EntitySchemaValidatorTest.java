package pe.restaurant.common.schema;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.MappedSuperclass;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import jakarta.persistence.Transient;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import pe.restaurant.common.schema.EntitySchemaValidator.EntitySchemaReport;
import pe.restaurant.common.schema.EntitySchemaValidator.IssueType;
import pe.restaurant.common.schema.SchemaModels.ColumnMetadata;
import pe.restaurant.common.schema.SchemaModels.SchemaSnapshot;
import pe.restaurant.common.schema.SchemaModels.TableMetadata;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

class EntitySchemaValidatorTest {

    private final EntitySchemaValidator validator = new EntitySchemaValidator();

    // ---- camelToSnake ----

    @Nested
    @DisplayName("camelToSnake replica la estrategia por defecto de Spring Boot")
    class CamelToSnake {

        @Test
        void convierteCamelCase() {
            assertThat(EntitySchemaValidator.camelToSnake("fecCreacion")).isEqualTo("fec_creacion");
            assertThat(EntitySchemaValidator.camelToSnake("entidadContribuyenteId")).isEqualTo("entidad_contribuyente_id");
            assertThat(EntitySchemaValidator.camelToSnake("codigo")).isEqualTo("codigo");
            assertThat(EntitySchemaValidator.camelToSnake("id")).isEqualTo("id");
        }
    }

    // ---- Casos válidos ----

    @Nested
    @DisplayName("Entidad consistente con el esquema -> sin issues")
    class Valid {

        @Test
        @DisplayName("Columnas explícitas, heredadas y por defecto resuelven OK")
        void entidadValida() {
            TableMetadata marca = table("core", "marca",
                    "id", "codigo", "nombre", "flag_estado", "created_by");

            SchemaSnapshot snapshot = snapshot(marca);

            EntitySchemaReport report = validator.validate(snapshot, List.of(MarcaEntity.class));

            assertThat(report.isValid()).isTrue();
            assertThat(report.issues()).isEmpty();
        }
    }

    // ---- Tabla inexistente ----

    @Nested
    @DisplayName("Tabla inexistente -> MISSING_TABLE")
    class MissingTable {

        @Test
        void tablaNoExiste() {
            SchemaSnapshot snapshot = snapshot(table("core", "otra", "id"));

            EntitySchemaReport report = validator.validate(snapshot, List.of(MarcaEntity.class));

            assertThat(report.issues()).hasSize(1);
            assertThat(report.issues().get(0).type()).isEqualTo(IssueType.MISSING_TABLE);
            assertThat(report.issues().get(0).table()).isEqualTo("marca");
        }
    }

    // ---- Columna fantasma ----

    @Nested
    @DisplayName("Columna fantasma -> MISSING_COLUMN")
    class MissingColumn {

        @Test
        @DisplayName("Campo mapeado a columna inexistente se reporta")
        void columnaFantasma() {
            TableMetadata marca = table("core", "marca", "id", "codigo", "flag_estado", "created_by");

            EntitySchemaReport report = validator.validate(snapshot(marca), List.of(MarcaEntity.class));

            assertThat(report.issues()).hasSize(1);
            assertThat(report.issues().get(0).type()).isEqualTo(IssueType.MISSING_COLUMN);
            assertThat(report.issues().get(0).column()).isEqualTo("nombre");
        }

        @Test
        @DisplayName("@Transient y @OneToMany no se validan")
        void ignoraTransientYRelaciones() {
            TableMetadata t = table("core", "con_relaciones", "id", "padre_id");

            EntitySchemaReport report = validator.validate(snapshot(t), List.of(ConRelaciones.class));

            assertThat(report.isValid()).isTrue();
        }

        @Test
        @DisplayName("@ManyToOne sin @JoinColumn usa <campo>_id; @JoinColumn explícito respeta el nombre")
        void resuelveRelaciones() {
            TableMetadata ok = table("core", "rel", "id", "proveedor_id", "moneda_fk");
            assertThat(validator.validate(snapshot(ok), List.of(RelEntity.class)).isValid()).isTrue();

            TableMetadata bad = table("core", "rel", "id", "moneda_fk");
            EntitySchemaReport report = validator.validate(snapshot(bad), List.of(RelEntity.class));
            assertThat(report.issues()).hasSize(1);
            assertThat(report.issues().get(0).column()).isEqualTo("proveedor_id");
        }
    }

    // ---- Entidades sintéticas ----

    @MappedSuperclass
    static class Base {
        @Id
        @Column
        Long id;
        @Column(name = "flag_estado")
        String flagEstado;
        @Column(name = "created_by")
        Long createdBy;
    }

    @Entity
    @Table(name = "marca", schema = "core")
    static class MarcaEntity extends Base {
        @Column
        String codigo;
        @Column
        String nombre;
    }

    @Entity
    @Table(name = "con_relaciones", schema = "core")
    static class ConRelaciones {
        @Id
        Long id;
        @Column(name = "padre_id")
        Long padreId;
        @Transient
        String calculado;
        @OneToMany
        List<Object> hijos;
    }

    @Entity
    @Table(name = "rel", schema = "core")
    static class RelEntity {
        @Id
        Long id;
        @ManyToOne
        Object proveedor;
        @ManyToOne
        @JoinColumn(name = "moneda_fk")
        Object moneda;
    }

    // ---- Helpers ----

    private static TableMetadata table(String schema, String name, String... columns) {
        Map<String, ColumnMetadata> cols = new LinkedHashMap<>();
        int ordinal = 1;
        for (String column : columns) {
            cols.put(column, new ColumnMetadata(schema, name, column, "text", true, null, ordinal++));
        }
        return new TableMetadata(schema, name, cols, null, new LinkedHashMap<>(), new LinkedHashMap<>(), new LinkedHashMap<>());
    }

    private static SchemaSnapshot snapshot(TableMetadata... tables) {
        Map<String, TableMetadata> map = new LinkedHashMap<>();
        for (TableMetadata t : tables) {
            map.put(t.schemaName() + "." + t.tableName(), t);
        }
        return new SchemaSnapshot("test", map, new LinkedHashMap<>());
    }
}
