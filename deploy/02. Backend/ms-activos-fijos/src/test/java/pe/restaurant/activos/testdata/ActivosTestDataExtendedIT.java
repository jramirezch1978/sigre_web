package pe.restaurant.activos.testdata;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import pe.restaurant.activos.support.ActivosIntegrationTest;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/**
 * Verifica dataset factory extendido + bulk en la transacción del test (rollback al finalizar).
 */
@ActivosIntegrationTest
class ActivosTestDataExtendedIT {

    @Autowired
    private ActivosTestDataFactory factory;

    @Test
    void cargaDatasetExtendido_enTransaccionIt() {
        factory.ensureActivosIntegracionDdl();
        assumeTrue(factory.isActivosSchemaReady(),
                "Tenant sin esquema activos (DDL 08-activos + migraciones ms-activos-fijos)");

        var counts = factory.ensureActivosTransactionalData();

        assertThat(counts.get("activos.af_maestro_extra")).isNotNegative();
        assertThat(counts.get("activos.af_calculo_cntbl_periodos")).isNotNegative();
        assertThat(factory.countMaestrosFactoryActivosEnBd()).isGreaterThanOrEqualTo(3);
        assertThat(factory.countCalculosFactoryEnBd()).isGreaterThanOrEqualTo(10);
        assertThat(factory.countValuacionesFactoryEnBd()).isGreaterThanOrEqualTo(2);
        assertThat(factory.countDocumentosFactoryEnBd()).isGreaterThanOrEqualTo(2);
        assertThat(factory.countHistorialFactoryEnBd()).isGreaterThanOrEqualTo(8);
        assertThat(factory.countAccesoriosFactoryEnBd()).isGreaterThanOrEqualTo(5);
        assertThat(factory.countOperacionesFactoryEnBd()).isGreaterThanOrEqualTo(4);
        assertThat(factory.countSoftwareFactoryEnBd()).isGreaterThanOrEqualTo(3);

        assertThat(counts.get("bulk.activos.af_maestro")).isNotNegative();
        assertThat(factory.countMaestrosBulkEnBd()).isGreaterThanOrEqualTo(ActivosTestDataFactory.BULK_ROWS_PER_TABLE);
        assertThat(factory.countTablaBulkActivos("af_clase")).isGreaterThanOrEqualTo(ActivosTestDataFactory.BULK_ROWS_PER_TABLE);
        assertThat(factory.countTablaBulkActivos("af_ubicacion")).isGreaterThanOrEqualTo(ActivosTestDataFactory.BULK_ROWS_PER_TABLE);
        assertThat(factory.countTablaBulkActivos("af_calculo_cntbl")).isGreaterThanOrEqualTo(ActivosTestDataFactory.BULK_ROWS_PER_TABLE);
        assertThat(factory.countTablaBulkActivos("af_historial")).isGreaterThanOrEqualTo(ActivosTestDataFactory.BULK_ROWS_PER_TABLE);
    }
}
