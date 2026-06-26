package pe.restaurant.compras.schema;

import jakarta.persistence.Entity;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.ClassPathScanningCandidateComponentProvider;
import org.springframework.core.type.filter.AnnotationTypeFilter;
import org.springframework.jdbc.core.JdbcTemplate;
import pe.restaurant.common.schema.EntitySchemaValidator;
import pe.restaurant.common.schema.EntitySchemaValidator.EntitySchemaReport;
import pe.restaurant.common.schema.PgSchemaMetadataReader;
import pe.restaurant.common.schema.SchemaModels.SchemaSnapshot;
import pe.restaurant.compras.support.ComprasIntegrationTest;

import javax.sql.DataSource;
import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * IT de Fase 5: valida que las entidades JPA de ms-compras sean consistentes con el
 * esquema real de la BD tenant (tabla y columnas existentes).
 * <p>
 * Con {@code hibernate.ddl-auto=none} estas inconsistencias solo se detectan en runtime;
 * este test las adelanta. Detecta columnas fantasma y tablas inexistentes.
 * <p>
 * Gated: requiere conectividad a la BD tenant. Ejecutar manualmente:
 * <pre>mvn test -pl ms-compras -Dcompras.it=true -Dsurefire.excludedGroups= -Dtest=ComprasSchemaValidationIT</pre>
 */
@ComprasIntegrationTest
@DisplayName("Fase 5 - Validacion de esquema entidades vs BD (ms-compras)")
class ComprasSchemaValidationIT {

    private static final String ENTITY_BASE_PACKAGE = "pe.restaurant.compras.entity";

    @Autowired
    private DataSource dataSource;

    @Test
    @DisplayName("Las entidades JPA mapean tablas y columnas existentes en el esquema")
    void entidadesConsistentesConEsquema() {
        JdbcTemplate jdbc = new JdbcTemplate(dataSource);
        SchemaSnapshot snapshot = new PgSchemaMetadataReader().readSnapshot(jdbc, "tenant");

        List<Class<?>> entities = scanEntities();
        assertThat(entities).as("se deben descubrir entidades en %s", ENTITY_BASE_PACKAGE).isNotEmpty();

        EntitySchemaReport report = new EntitySchemaValidator().validate(snapshot, entities);

        assertThat(report.isValid())
                .as(report.describe())
                .isTrue();
    }

    private static List<Class<?>> scanEntities() {
        ClassPathScanningCandidateComponentProvider scanner =
                new ClassPathScanningCandidateComponentProvider(false);
        scanner.addIncludeFilter(new AnnotationTypeFilter(Entity.class));
        List<Class<?>> classes = new ArrayList<>();
        scanner.findCandidateComponents(ENTITY_BASE_PACKAGE).forEach(bd -> {
            try {
                classes.add(Class.forName(bd.getBeanClassName()));
            } catch (ClassNotFoundException e) {
                throw new IllegalStateException("No se pudo cargar la entidad " + bd.getBeanClassName(), e);
            }
        });
        return classes;
    }
}
