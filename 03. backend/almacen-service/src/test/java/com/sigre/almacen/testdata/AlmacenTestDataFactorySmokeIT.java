package com.sigre.almacen.testdata;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import com.sigre.almacen.support.AlmacenIntegrationTest;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assumptions.assumeTrue;

/**
 * Smoke IT: {@link AlmacenTestDataFactory} persiste dataset factory en tenant.
 *
 * <p>{@code mvn test -pl almacen-service -Dalmacen.it=true -Dtest=AlmacenTestDataFactorySmokeIT}</p>
 */
@AlmacenIntegrationTest
class AlmacenTestDataFactorySmokeIT {

    @Autowired
    private AlmacenTestDataFactory factory;

    @Test
    void ensureTransactionalData_returnsCountsForAllTables() {
        assumeTrue(factory.isAlmacenSchemaReady(), "Tenant sin esquema almacen (DDL 02-almacen)");
        var counts = factory.ensureAlmacenTransactionalData();
        assertThat(counts).containsKeys(
                "core.articulo",
                "almacen.almacen",
                "almacen.ubicacion_almacen",
                "almacen.lote_pallet",
                "almacen.vale_mov + det",
                "almacen.orden_traslado + det",
                "almacen.guia + det",
                "almacen.sol_salida + det",
                "almacen.inventario_conteo",
                "almacen.articulo_bonificacion",
                "almacen.articulo_almacen",
                "almacen.articulo_almacen_posicion",
                "almacen.articulo_almacen_lote",
                "almacen.articulo_saldo_mensual"
        );
        counts.values().forEach(v -> assertThat(v).isNotNegative());
    }

    @Test
    void ensureTransactionalData_isIdempotentByContract() {
        assumeTrue(factory.isAlmacenSchemaReady(), "Tenant sin esquema almacen (DDL 02-almacen)");
        var first = factory.ensureAlmacenTransactionalData();
        var second = factory.ensureAlmacenTransactionalData();
        assertThat(second.keySet()).containsExactlyElementsOf(first.keySet());
    }

    @Test
    void ensureTransactionalData_persistsValeAndAllFactoryRows() {
        assumeTrue(factory.isAlmacenSchemaReady(), "Tenant sin esquema almacen (DDL 02-almacen)");
        factory.ensureAlmacenTransactionalData();

        assertThat(factory.resolveValeMovId()).isPositive();
        assertThat(factory.countValeMovDetalles()).isGreaterThanOrEqualTo(2);
        assertThat(factory.countTablaFactory("ubicacion_almacen")).isGreaterThanOrEqualTo(2);
        assertThat(factory.countTablaFactory("lote_pallet")).isGreaterThanOrEqualTo(1);
        assertThat(factory.countTablaFactory("orden_traslado")).isEqualTo(1);
        assertThat(factory.countTablaFactory("sol_salida")).isEqualTo(1);
        assertThat(factory.countTablaFactory("guia")).isEqualTo(1);
    }
}
