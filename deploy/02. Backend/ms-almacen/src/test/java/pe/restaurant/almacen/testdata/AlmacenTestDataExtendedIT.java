package pe.restaurant.almacen.testdata;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import pe.restaurant.almacen.support.AlmacenIntegrationTest;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/**
 * Verifica dataset factory completo + bulk en la transacción del test (rollback al finalizar).
 */
@AlmacenIntegrationTest
class AlmacenTestDataExtendedIT {

    @Autowired
    private AlmacenTestDataFactory factory;

    @Test
    void cargaDatasetCompleto_enTransaccionIt() {
        assumeTrue(factory.isAlmacenSchemaReady(), "Tenant sin esquema almacen (DDL 02-almacen)");

        var counts = factory.ensureAlmacenTransactionalData();

        assertThat(counts.get("almacen.vale_mov + det")).isNotNegative();
        assertThat(counts.get("almacen.enriquecimiento_sin_nulos")).isNotNegative();
        assertThat(factory.countValeMovDetalles(AlmacenTestDataFactory.NRO_VALE)).isGreaterThanOrEqualTo(3);
        assertThat(factory.countValeMovDetalles(AlmacenTestDataFactory.NRO_VALE_2)).isGreaterThanOrEqualTo(2);
        assertThat(factory.countTablaFactory("articulo_bonificacion")).isGreaterThanOrEqualTo(3);
        assertThat(factory.countArticuloAlmacenFactory()).isGreaterThanOrEqualTo(3);

        assertThat(counts.get("bulk.almacen.vale_mov")).isNotNegative();
        assertThat(factory.countValesBulkEnBd()).isGreaterThanOrEqualTo(AlmacenTestDataFactory.BULK_ROWS_PER_TABLE);
        assertThat(factory.countTablaBulkAlmacen("almacen", null, AlmacenTestDataFactoryBulk.PREFIX_ALM + "%"))
                .isGreaterThanOrEqualTo(AlmacenTestDataFactory.BULK_ROWS_PER_TABLE);
        assertThat(factory.countTablaBulkAlmacen("ubicacion_almacen", "codigo", AlmacenTestDataFactoryBulk.PREFIX_UBI + "%"))
                .isGreaterThanOrEqualTo(AlmacenTestDataFactory.BULK_ROWS_PER_TABLE);
    }
}
