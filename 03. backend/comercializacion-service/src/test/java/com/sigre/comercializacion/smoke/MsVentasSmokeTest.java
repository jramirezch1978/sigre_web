package com.sigre.comercializacion.smoke;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThatCode;

/**
 * Verifica que cada controller público tenga clase de prueba {@code XControllerTest} (sin levantar BD).
 */
@Tag("smoke")
class MsVentasSmokeTest {

    private static final String[] CONTROLLER_SIMPLE_NAMES = {
            "CanalDistribucionController",
            "CartaController",
            "CartaItemController",
            "ComandaController",
            "CuentaCobrarController",
            "FacturaSimplificadaController",
            "MesaController",
            "PedidoMesaController",
            "PuntoVentaController",
            "ServiciosCxCController",
            "VendedorController",
            "ZonaController",
            "ZonaDespachoController",
            "ZonaRepartoController",
            "ZonaVentaController"
    };

    @Test
    void cadaControllerTieneTestEnElMismoPaquete() {
        for (String name : CONTROLLER_SIMPLE_NAMES) {
            String testFqn = "com.sigre.comercializacion.controller." + name + "Test";
            assertThatCode(() -> Class.forName(testFqn))
                    .as("Debe existir %s para cubrir %s", testFqn, name)
                    .doesNotThrowAnyException();
        }
    }
}
