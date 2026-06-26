package pe.restaurant.rrhh.testdata;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.transaction.annotation.Transactional;
import pe.restaurant.common.testutil.TenantContextTestExecutionListener;

import static org.assertj.core.api.Assertions.assertThat;

@Tag("integration")
@SpringBootTest
@ActiveProfiles("test")
@Transactional
@TestExecutionListeners(
    listeners = TenantContextTestExecutionListener.class,
    mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
class RrhhTestDataFactorySmokeIT {

    @Autowired private RrhhTestDataFactory factory;

    @Test
    @DisplayName("ensureAreaTestData() es idempotente")
    void ensureAreaData_isIdempotent() {
        factory.ensureAreaTestData();
        Long count1 = factory.countAreaChildren(factory.getAreaIdByName("Gerencia General"));
        factory.ensureAreaTestData();
        Long count2 = factory.countAreaChildren(factory.getAreaIdByName("Gerencia General"));
        assertThat(count2).isEqualTo(count1);
    }

    @Test
    @DisplayName("ensureCargoTestData() es idempotente")
    void ensureCargoData_isIdempotent() {
        factory.ensureCargoTestData();
        boolean exists = factory.existsCargoByName("Cocinero");
        factory.ensureCargoTestData();
        assertThat(factory.existsCargoByName("Cocinero")).isEqualTo(exists);
    }

    @Test
    @DisplayName("ensureAdminAfpTestData() es idempotente")
    void ensureAdminAfpData_isIdempotent() {
        factory.ensureAdminAfpTestData();
        Long id1 = factory.resolveAdminAfpId();
        factory.ensureAdminAfpTestData();
        assertThat(factory.resolveAdminAfpId()).isEqualTo(id1);
    }

    @Test
    @DisplayName("ensureTipoNovedadRrhhTestData() es idempotente")
    void ensureTipoNovedadData_isIdempotent() {
        factory.ensureTipoNovedadRrhhTestData();
        Long id1 = factory.resolveTipoNovedadRrhhId();
        factory.ensureTipoNovedadRrhhTestData();
        assertThat(factory.resolveTipoNovedadRrhhId()).isEqualTo(id1);
    }
}
