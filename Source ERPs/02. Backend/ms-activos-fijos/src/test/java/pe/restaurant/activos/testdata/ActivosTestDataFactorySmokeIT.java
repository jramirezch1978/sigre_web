package pe.restaurant.activos.testdata;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import pe.restaurant.activos.integracion.AfIntegracionContableModulo;
import pe.restaurant.activos.support.ActivosIntegrationTest;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/**
 * Smoke integration test to ensure {@link ActivosTestDataFactory}
 * can run when a DB/tenant is available. Unitarios usan {@link pe.restaurant.activos.TestDataFactory}.
 *
 * <p>Disabled by default in CI/dev unless explicitly enabled. Run with:
 * {@code mvn test -pl ms-activos-fijos -Dtest=ActivosTestDataFactorySmokeIT -Dactivos.it=true}</p>
 */
@ActivosIntegrationTest
class ActivosTestDataFactorySmokeIT {

    @Autowired
    private ActivosTestDataFactory factory;

    @Test
    void ensureTransactionalData_returnsCounts() {
        factory.ensureActivosIntegracionDdl();
        assumeTrue(factory.isActivosSchemaReady(),
                "Tenant sin esquema activos (DDL 08-activos + migraciones ms-activos-fijos)");
        var counts = factory.ensureActivosTransactionalData();
        assertThat(counts).isNotNull();
        assertThat(counts).containsKeys(
                "core.entidad_contribuyente",
                "auth.sucursal",
                "activos.af_clase",
                "activos.af_sub_clase",
                "activos.af_ubicacion",
                "activos.af_matriz_sub_clase",
                "activos.af_maestro",
                "activos.af_calculo_cntbl",
                "activos.af_adaptacion + det + dep",
                "activos.af_aseguradora + poliza",
                "activos.af_traslado",
                "activos.af_historial"
        );
        counts.values().forEach(v -> assertThat(v).isNotNegative());
    }

    @Test
    void ensureTransactionalData_isIdempotentByContract() {
        factory.ensureActivosIntegracionDdl();
        assumeTrue(factory.isActivosSchemaReady(),
                "Tenant sin esquema activos (DDL 08-activos + migraciones ms-activos-fijos)");
        var first = factory.ensureActivosTransactionalData();
        var second = factory.ensureActivosTransactionalData();
        assertThat(second.keySet()).containsExactlyElementsOf(first.keySet());
    }

    @Test
    void ensureTransactionalData_persistsStableCodes() {
        factory.ensureActivosIntegracionDdl();
        assumeTrue(factory.isActivosSchemaReady(),
                "Tenant sin esquema activos (DDL 08-activos + migraciones ms-activos-fijos)");
        factory.ensureActivosTransactionalData();

        assertThat(factory.countMaestrosFactoryActivosEnBd()).isGreaterThanOrEqualTo(3);
        assertThat(factory.countCalculosFactoryEnBd()).isGreaterThanOrEqualTo(10);
        Long calculoId = factory.resolveCalculoDepreciacionContableId();
        assertThat(factory.countCalculoDepreciacionEnBd(calculoId)).isEqualTo(1);
        assertThat(factory.countValuacionesFactoryEnBd()).isGreaterThanOrEqualTo(2);
        assertThat(factory.countDocumentosFactoryEnBd()).isGreaterThanOrEqualTo(2);

        Long gastoDep = factory.resolvePlanContableDetId(ActivosTestDataFactory.PC_GASTO_DEP);
        assertThat(gastoDep).isNotNull();
        assertThat(factory.countMatrizConCuentasDepreciacion()).isGreaterThanOrEqualTo(1);
    }

    @Test
    void factory_insertaDatosDirectamenteEnBd() {
        factory.ensureActivosIntegracionDdl();
        assumeTrue(factory.isActivosSchemaReady(),
                "Tenant sin esquema activos (DDL 08-activos + migraciones ms-activos-fijos)");

        factory.ensureActivosTransactionalData();

        assertThat(factory.countMaestrosFactoryActivosEnBd()).isGreaterThanOrEqualTo(3);

        Long calculoId = factory.resolveCalculoDepreciacionContableId();
        assertThat(factory.countCalculoDepreciacionEnBd(calculoId)).isEqualTo(1);

        if (factory.hasTrasladoContableEjecutado()) {
            Long trasladoId = factory.resolveTrasladoEjecutadoContableId();
            assertThat(factory.countTrasladoEjecutadoEnBd(trasladoId)).isEqualTo(1);
        }

        assertThat(factory.countPlanContableFactoryEnBd()).isGreaterThanOrEqualTo(1);

        factory.resetDepreciacionContableFactoryState();
        assertThat(factory.countCntblAsientoPorOrigen(
                AfIntegracionContableModulo.MODULO, calculoId)).isZero();
    }
}
