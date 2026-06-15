package com.sigre.almacen.smoke;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThatCode;

/**
 * Smoke ligero alineado al plan 02/05/2026 (ms-almacén): verifica que cada controller
 * REST tenga una clase de prueba homónima {@code XControllerTest} sin levantar BD.
 * Incluye {@code TestDataAdminController} (bean condicional; la clase de test existe siempre).
 * <p>
 * Ejecutar solo esta clase: {@code mvn test -pl almacen-service -Dtest=MsAlmacenSmokeTest}
 */
@Tag("smoke")
class MsAlmacenSmokeTest {

    private static final String[] CONTROLLER_SIMPLE_NAMES = {
            "AdminMigrationController",
            "AlmacenController",
            "AlmacenProcesoController",
            "AlmacenTipoController",
            "ArticuloBonificacionController",
            "ArticuloMovTipoController",
            "GuiasRemisionController",
            "InventarioConteoController",
            "IntegracionAlmacenController",
            "LotePalletController",
            "MotivoTrasladoController",
            "OrdenTrasladoController",
            "SolicitudesSalidaController",
            "TestDataAdminController",
            "TipoMovimientoController",
            "UbicacionAlmacenController",
            "ValeMovController"
    };

    @Test
    void cadaControllerTieneTestEnElMismoPaquete() {
        for (String name : CONTROLLER_SIMPLE_NAMES) {
            String testFqn = "com.sigre.almacen.controller." + name + "Test";
            assertThatCode(() -> Class.forName(testFqn))
                    .as("Debe existir %s para cubrir %s", testFqn, name)
                    .doesNotThrowAnyException();
        }
    }
}
