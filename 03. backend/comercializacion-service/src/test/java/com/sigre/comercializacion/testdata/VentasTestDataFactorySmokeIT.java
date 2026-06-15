package com.sigre.comercializacion.testdata;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import com.sigre.common.testutil.TenantContextTestExecutionListener;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Smoke test para validar que {@link VentasTestDataFactory} funciona correctamente
 * en el perfil de test (conexión real a PostgreSQL, datos insertados vía JDBC).
 *
 * <p>No usa {@code @Transactional} porque la factory ya es idempotente
 * ({@code ON CONFLICT DO UPDATE} / {@code WHERE NOT EXISTS}).
 */
@Tag("integration")
@SpringBootTest
@ActiveProfiles("test")
@TestExecutionListeners(
        listeners = TenantContextTestExecutionListener.class,
        mergeMode = TestExecutionListeners.MergeMode.MERGE_WITH_DEFAULTS
)
class VentasTestDataFactorySmokeIT {

    @Autowired
    private VentasTestDataFactory factory;

    @Test
    void ensureTransactionalData_returnsCounts() {
        var counts = factory.ensureVentasTransactionalData();
        assertThat(counts).isNotNull();
        assertThat(counts).containsKeys(
                "core.entidad_contribuyente",
                "ventas.vta_zona_venta",
                "ventas.punto_venta",
                "ventas.zona + mesa",
                "ventas.pedido_mesa",
                "ventas.comanda + det",
                "ventas.fs_factura_simpl + det + pagos",
                "ventas.orden_venta + det",
                "ventas.proforma + det",
                "ventas.cierre_caja",
                "ventas.descuento_promocion"
        );
        assertThat(counts.get("core.entidad_contribuyente")).isNotNegative();
        assertThat(counts.get("ventas.descuento_promocion")).isNotNegative();
    }

    @Test
    void ensureTransactionalData_isIdempotentByContract() {
        var first = factory.ensureVentasTransactionalData();
        var second = factory.ensureVentasTransactionalData();
        assertThat(second.keySet()).containsExactlyElementsOf(first.keySet());
    }
}

