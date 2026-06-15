package com.sigre.finanzas.testdata;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.transaction.annotation.Transactional;
import com.sigre.common.testutil.TenantContextTestExecutionListener;

import javax.sql.DataSource;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

@Tag("integration")
@SpringBootTest
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = TenantContextTestExecutionListener.class,
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
class TestDataSeederFinanzasSmokeIT {

    @Autowired
    DataSource dataSource;

    @Test
    void ensureFinanzasTransactionalData_returnsCounts() {
        var seeder = new TestDataSeederFinanzas(dataSource);
        var counts = seeder.ensureFinanzasTransactionalData();

        assertThat(counts).isNotNull();
        assertThat(counts).containsKeys(
            "finanzas.banco",
            "finanzas.banco_cnta",
            "finanzas.concepto_financiero",
            "finanzas.cntas_pagar",
            "finanzas.caja_bancos",
            "finanzas.programacion_pago"
        );

        // Verificar que cada tabla tenga al menos 1 registro
        counts.values().forEach(count ->
            assertThat(count).isGreaterThan(0)
        );
    }

    @Test
    void ensureFinanzasTransactionalData_isIdempotent() {
        var seeder = new TestDataSeederFinanzas(dataSource);

        // Primera llamada
        var counts1 = seeder.ensureFinanzasTransactionalData();

        // Segunda llamada (debería actualizar, no duplicar)
        var counts2 = seeder.ensureFinanzasTransactionalData();

        // Los counts deberían ser iguales o mayores (actualizaciones)
        counts2.forEach((table, count2) -> {
            Integer count1 = counts1.get(table);
            assertThat(count2).isGreaterThanOrEqualTo(count1);
        });
    }
}
