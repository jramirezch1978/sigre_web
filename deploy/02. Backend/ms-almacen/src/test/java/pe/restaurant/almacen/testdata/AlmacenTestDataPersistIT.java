package pe.restaurant.almacen.testdata;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfSystemProperty;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Commit;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/**
 * Opcional: deja el dataset factory en BD (sin rollback). Solo QA/local explícito.
 *
 * <p>{@code mvn test -pl ms-almacen -Dalmacen.it=true -Dalmacen.it.persist=true
 * -Dtest=AlmacenTestDataPersistIT}</p>
 */
@Tag("it")
@EnabledIfSystemProperty(named = "almacen.it", matches = "true")
@EnabledIfSystemProperty(named = "almacen.it.persist", matches = "true")
@ActiveProfiles("test")
@SpringBootTest
@Commit
@TestExecutionListeners(
        listeners = TenantContextTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
class AlmacenTestDataPersistIT {

    @Autowired
    private AlmacenTestDataFactory factory;

    @Test
    void cargaDatasetCompleto_persisteEnBd() {
        assumeTrue(factory.isAlmacenSchemaReady(), "Tenant sin esquema almacen (DDL 02-almacen)");

        var counts = factory.ensureAlmacenTransactionalData();
        assertThat(counts).isNotEmpty();
        assertThat(factory.resolveValeMovId()).isPositive();
        assertThat(factory.countValesBulkEnBd()).isGreaterThanOrEqualTo(AlmacenTestDataFactory.BULK_ROWS_PER_TABLE);
    }
}
