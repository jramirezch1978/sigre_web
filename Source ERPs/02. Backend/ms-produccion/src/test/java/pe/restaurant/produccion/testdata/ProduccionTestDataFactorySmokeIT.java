package pe.restaurant.produccion.testdata;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;

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
class ProduccionTestDataFactorySmokeIT {

    @Autowired private ProduccionTestDataFactory factory;

    @Test
    @DisplayName("ensurePlanificacionData() es idempotente")
    void ensurePlanificacionData_isIdempotent() {
        Map<String, Object> primera = factory.ensurePlanificacionData();
        Map<String, Object> segunda = factory.ensurePlanificacionData();
        assertThat(segunda).isEqualTo(primera);
    }
}
