package com.sigre.compras.integration;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import com.sigre.common.testutil.TestDataFactory;
import com.sigre.compras.support.ComprasIntegrationTest;
import com.sigre.compras.testdata.ComprasTestDataFactory;

import javax.sql.DataSource;
import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

@ComprasIntegrationTest
@DisplayName("ComprasTestDataFactory - Smoke test de idempotencia")
class ComprasTestDataFactorySmokeIT {

    @Autowired private ComprasTestDataFactory factory;
    @Autowired private DataSource dataSource;

    @BeforeEach
    void seed() {
        TestDataFactory.using(dataSource)
                .seedDocTipo()
                .seedArticulo()
                .seedEntidadContribuyente()
                .seedComprador()
                .seedAprobadorConfigurado()
                .seedServicio();
    }

    @Test
    @DisplayName("ensureComprasTransactionalData() es idempotente")
    void ensureTransactionalData_isIdempotent() {
        Map<String, Integer> primera = factory.ensureComprasTransactionalData();
        Map<String, Integer> segunda = factory.ensureComprasTransactionalData();
        assertThat(segunda).isNotNull();
        assertThat(primera).isNotNull();
    }

    @Test
    @DisplayName("resolve*Id() retorna IDs validos despues del seed")
    void resolveIds_afterSeed_returnsValidIds() {
        factory.ensureComprasTransactionalData();

        assertThat(factory.resolveArticuloId()).isPositive();
        assertThat(factory.resolveProveedorId()).isPositive();
        assertThat(factory.resolveSucursalId()).isPositive();
        assertThat(factory.resolveServicioId()).isPositive();
        assertThat(factory.resolveDocTipoId("OC")).isPositive();
        assertThat(factory.resolveDocTipoId("OS")).isPositive();
    }
}
