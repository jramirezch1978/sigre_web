package pe.restaurant.core.smoke;

import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThatCode;

/**
 * Smoke ligero: verifica que cada controller público tenga una clase de prueba
 * homónima {@code XControllerTest} en el classpath, sin levantar BD ni contexto Spring.
 */
@Tag("smoke")
class MsCoreMaestrosSmokeTest {

    private static final String[] CONTROLLER_SIMPLE_NAMES = {
            "ArticuloController",
            "ArticuloCategController",
            "ArticuloClaseController",
            "ArticuloEquivalenciaController",
            "ArticuloSubCategController",
            "CondicionPagoController",
            "ConfiguracionController",
            "ConversionUnidadController",
            "DetraccionController",
            "DocTipoController",
            "EjercicioPeriodoController",
            "EmpresaSucursalController",
            "FormaPagoController",
            "GeografiaController",
            "MonedaController",
            "NaturalezaContableController",
            "NumeradorController",
            "ParametroSistemaController",
            "RelacionComercialController",
            "SucursalController",
            "TipoCambioController",
            "TipoDocIdentidadController",
            "TiposImpuestoController",
            "UnidadMedidaController"
    };

    @Test
    void cadaControllerTieneTestEnElMismoPaquete() {
        for (String name : CONTROLLER_SIMPLE_NAMES) {
            String testFqn = "pe.restaurant.core.controller." + name + "Test";
            assertThatCode(() -> Class.forName(testFqn))
                    .as("Debe existir %s para cubrir %s", testFqn, name)
                    .doesNotThrowAnyException();
        }
    }
}
