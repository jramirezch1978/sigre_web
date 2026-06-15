package com.sigre.almacen.service.integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import com.sigre.almacen.support.AlmacenIntegrationTest;
import com.sigre.almacen.support.AlmacenItSeed;
import com.sigre.almacen.testdata.AlmacenTestDataFactory;

import javax.sql.DataSource;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/**
 * IT de servicio con datos de {@link AlmacenTestDataFactory} (sin mocks de repositorio).
 */
@AlmacenIntegrationTest
@DisplayName("IT — ValeMovService + AlmacenTestDataFactory")
class ValeMovServiceIT {

    @Autowired
    private AlmacenTestDataFactory factory;

    @Autowired
    private DataSource dataSource;

    @BeforeEach
    void seed() {
        AlmacenItSeed.standard(dataSource, factory);
        assumeTrue(factory.isAlmacenSchemaReady(), "Tenant sin esquema almacen (DDL 02-almacen)");
    }

    @Test
    @DisplayName("vale factory LM-TEST-0001 con líneas en BD (sin obtener HTTP)")
    void valeFactory_conLineasEnBd() {
        Long valeId = factory.resolveValeMovId();
        assertThat(valeId).isPositive();
        assertThat(factory.countValeMovDetalles(AlmacenTestDataFactory.NRO_VALE)).isGreaterThanOrEqualTo(2);
        assertThat(factory.countTablaFactory("vale_mov")).isGreaterThanOrEqualTo(2);
    }

    @Test
    @DisplayName("ensureAlmacenTransactionalData es idempotente")
    void factoryIdempotente() {
        var first = factory.ensureAlmacenTransactionalData();
        var second = factory.ensureAlmacenTransactionalData();
        assertThat(second.keySet()).containsExactlyElementsOf(first.keySet());
        assertThat(factory.resolveValeMovId()).isEqualTo(factory.resolveValeMovId());
    }
}
