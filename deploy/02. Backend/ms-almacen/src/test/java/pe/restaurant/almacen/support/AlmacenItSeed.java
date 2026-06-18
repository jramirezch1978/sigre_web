package pe.restaurant.almacen.support;

import pe.restaurant.almacen.testdata.AlmacenTestDataFactory;
import pe.restaurant.common.testutil.TestDataFactory;

import javax.sql.DataSource;

/**
 * Orquesta seed IT: rol A (common) + rol B ({@link AlmacenTestDataFactory}).
 */
public final class AlmacenItSeed {

    private AlmacenItSeed() {}

    public static void standard(DataSource dataSource, AlmacenTestDataFactory factory) {
        TestDataFactory.using(dataSource).seedEntidadContribuyente();
        factory.ensureAlmacenTransactionalData();
    }
}
