package pe.restaurant.rrhh.constants;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DisplayName("TipoNovedadRrhhConstants — Pruebas Unitarias")
class TipoNovedadRrhhConstantsTest {

    @Test
    @DisplayName("Constructor privado -> lanza UnsupportedOperationException")
    void constructorPrivado_lanzaExcepcion() throws Exception {
        Constructor<TipoNovedadRrhhConstants> constructor = TipoNovedadRrhhConstants.class.getDeclaredConstructor();
        constructor.setAccessible(true);

        assertThatThrownBy(constructor::newInstance)
            .isInstanceOf(InvocationTargetException.class)
            .hasRootCauseInstanceOf(UnsupportedOperationException.class);
    }

    @Test
    @DisplayName("Códigos de error -> valores correctos")
    void codigosError_valoresCorrectos() {
        assertThat(TipoNovedadRrhhConstants.ERROR_CODIGO_OBLIGATORIO).isEqualTo("RH-TN-001");
        assertThat(TipoNovedadRrhhConstants.ERROR_CODIGO_DUPLICADO).isEqualTo("RH-TN-002");
        assertThat(TipoNovedadRrhhConstants.ERROR_NOMBRE_OBLIGATORIO).isEqualTo("RH-TN-003");
        assertThat(TipoNovedadRrhhConstants.ERROR_DESACTIVACION_EN_USO).isEqualTo("RH-TN-004");
        assertThat(TipoNovedadRrhhConstants.ERROR_NO_ENCONTRADO).isEqualTo("RH-TN-005");
    }

    @Test
    @DisplayName("Mensajes de error -> no vacíos")
    void mensajesError_noVacios() {
        assertThat(TipoNovedadRrhhConstants.MSG_CODIGO_OBLIGATORIO).isNotBlank();
        assertThat(TipoNovedadRrhhConstants.MSG_CODIGO_DUPLICADO).isNotBlank();
        assertThat(TipoNovedadRrhhConstants.MSG_NOMBRE_OBLIGATORIO).isNotBlank();
        assertThat(TipoNovedadRrhhConstants.MSG_DESACTIVACION_EN_USO).isNotBlank();
        assertThat(TipoNovedadRrhhConstants.MSG_NO_ENCONTRADO).isNotBlank();
    }

    @Test
    @DisplayName("Mensajes de éxito -> no vacíos")
    void mensajesExito_noVacios() {
        assertThat(TipoNovedadRrhhConstants.MSG_CREADO).isNotBlank();
        assertThat(TipoNovedadRrhhConstants.MSG_ACTUALIZADO).isNotBlank();
        assertThat(TipoNovedadRrhhConstants.MSG_ELIMINADO).isNotBlank();
        assertThat(TipoNovedadRrhhConstants.MSG_OBTENIDOS).isNotBlank();
    }
}
