package com.sigre.comercializacion.testdata;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.condition.EnabledIfSystemProperty;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Commit;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.testutil.TenantContextTestExecutionListener;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/**
 * Carga dataset factory ventas (mínimo + bulk) en BD tenant.
 */
@Tag("it")
@EnabledIfSystemProperty(named = "ventas.it", matches = "true")
@ActiveProfiles("test")
@SpringBootTest
@Commit
@Transactional
@TestExecutionListeners(
        listeners = TenantContextTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
class VentasTestDataExtendedIT {

    @Autowired
    private VentasTestDataFactory factory;

    @Test
    void cargaDatasetExtendido_persisteEnBd() {
        assumeTrue(factory.isVentasSchemaReady(), "Tenant sin esquema ventas (DDL 04-ventas)");

        var counts = factory.ensureVentasTransactionalData();

        assertThat(counts.get("ventas.comanda + det")).isNotNegative();
        assertThat(counts.get("bulk.ventas.comanda")).isNotNegative();
        assertThat(factory.countComandasBulkEnBd()).isGreaterThanOrEqualTo(VentasTestDataFactory.BULK_ROWS_PER_TABLE);
        assertThat(factory.countOrdenesVentaBulkEnBd()).isGreaterThanOrEqualTo(VentasTestDataFactory.BULK_ROWS_PER_TABLE);
        assertThat(factory.countFacturasBulkEnBd()).isGreaterThanOrEqualTo(VentasTestDataFactory.BULK_ROWS_PER_TABLE);
    }
}
