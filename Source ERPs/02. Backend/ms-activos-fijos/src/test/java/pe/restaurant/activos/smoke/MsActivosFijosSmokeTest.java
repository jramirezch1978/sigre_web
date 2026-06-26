package pe.restaurant.activos.smoke;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThatCode;

/**
 * Smoke ligero alineado a ms-almacén: verifica que cada controller REST tenga una clase de prueba
 * homónima {@code XControllerTest} sin levantar BD.
 * Incluye {@code TestDataAdminController} (bean condicional; la clase de test existe siempre).
 * <p>
 * Ejecutar solo esta clase: {@code mvn test -pl ms-activos-fijos -Dtest=MsActivosFijosSmokeTest}
 */
@Tag("smoke")
class MsActivosFijosSmokeTest {

    private static final String[] CONTROLLER_SIMPLE_NAMES = {
            "AfAccesorioController",
            "AfAdaptacionController",
            "AfAdaptacionDepController",
            "AfAdaptacionDetController",
            "AfAseguradoraController",
            "AfCalculoCntblController",
            "AfClaseController",
            "AfDocumentoController",
            "AfHistorialController",
            "AfIntegracionController",
            "AfJobsController",
            "AfMaestroController",
            "AfMatrizSubClaseController",
            "AfNumeracionController",
            "AfOperacionesController",
            "AfPolizaActivoController",
            "AfPolizaSeguroController",
            "AfReporteController",
            "AfSubClaseController",
            "AfTipoOperacionController",
            "AfTrasladoController",
            "AfUbicacionController",
            "AfValuacionController",
            "AfVentaController",
            "TestDataAdminController"
    };

    @Test
    void cadaControllerTieneTestEnElMismoPaquete() {
        for (String name : CONTROLLER_SIMPLE_NAMES) {
            String testFqn = "pe.restaurant.activos.controller." + name + "Test";
            assertThatCode(() -> Class.forName(testFqn))
                    .as("Debe existir %s para cubrir %s", testFqn, name)
                    .doesNotThrowAnyException();
        }
    }
}
