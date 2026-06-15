package com.sigre.almacen.support;

import com.sigre.almacen.testdata.AlmacenTestDataFactory;
import com.sigre.common.testutil.TestDataFactory;

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
