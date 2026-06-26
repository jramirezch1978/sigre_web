package pe.restaurant.activos.testdata;

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
 * <p>{@code mvn test -pl ms-activos-fijos -Dactivos.it=true -Dactivos.it.persist=true
 * -Dtest=ActivosTestDataPersistIT}</p>
 */
@Tag("it")
@EnabledIfSystemProperty(named = "activos.it", matches = "true")
@EnabledIfSystemProperty(named = "activos.it.persist", matches = "true")
@ActiveProfiles("test")
@SpringBootTest
@Commit
@TestExecutionListeners(
        listeners = TenantContextTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
class ActivosTestDataPersistIT {

    @Autowired
    private ActivosTestDataFactory factory;

    @Test
    void cargaDatasetExtendido_persisteEnBd() {
        factory.ensureActivosIntegracionDdl();
        assumeTrue(factory.isActivosBaseSchemaReady(),
                "Tenant sin esquema activos (DDL 08-activos)");

        var counts = factory.ensureActivosTransactionalData();
        assertThat(counts).isNotEmpty();
        assertThat(factory.countMaestrosFactoryActivosEnBd()).isGreaterThanOrEqualTo(3);
        assertThat(factory.countMaestrosBulkEnBd()).isGreaterThanOrEqualTo(ActivosTestDataFactory.BULK_ROWS_PER_TABLE);
    }
}
