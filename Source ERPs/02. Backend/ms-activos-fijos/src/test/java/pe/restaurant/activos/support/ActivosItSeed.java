package pe.restaurant.activos.support;

import pe.restaurant.activos.testdata.ActivosTestDataFactory;
import pe.restaurant.common.testutil.TestDataFactory;

import javax.sql.DataSource;

/**
 * Orquesta seed IT: rol A (common) + rol B ({@link ActivosTestDataFactory}).
 */
public final class ActivosItSeed {

    private ActivosItSeed() {}

    public static void standard(DataSource dataSource, ActivosTestDataFactory factory) {
        TestDataFactory.using(dataSource).seedEntidadContribuyente();
        factory.ensureActivosIntegracionDdl();
        factory.ensureActivosTransactionalData();
    }
}
