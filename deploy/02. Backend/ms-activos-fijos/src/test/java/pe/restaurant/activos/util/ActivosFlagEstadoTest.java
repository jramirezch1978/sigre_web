package pe.restaurant.activos.util;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Constructor;
import java.lang.reflect.Modifier;

import static org.assertj.core.api.Assertions.assertThat;

class ActivosFlagEstadoTest {

    @Test
    void activoConstant() {
        assertThat(ActivosFlagEstado.ACTIVO).isEqualTo("1");
    }

    @Test
    void inactivoConstant() {
        assertThat(ActivosFlagEstado.INACTIVO).isEqualTo("0");
    }

    @Test
    void capitalizadaConstant() {
        assertThat(ActivosFlagEstado.CAPITALIZADA).isEqualTo("2");
    }

    @Test
    void allConstantsAreNonNull() {
        assertThat(ActivosFlagEstado.ACTIVO).isNotNull();
        assertThat(ActivosFlagEstado.INACTIVO).isNotNull();
        assertThat(ActivosFlagEstado.CAPITALIZADA).isNotNull();
    }

    @Test
    void constantsAreSingleCharacterStrings() {
        assertThat(ActivosFlagEstado.ACTIVO).hasSize(1);
        assertThat(ActivosFlagEstado.INACTIVO).hasSize(1);
        assertThat(ActivosFlagEstado.CAPITALIZADA).hasSize(1);
    }

    @Test
    void classIsFinal() {
        assertThat(Modifier.isFinal(ActivosFlagEstado.class.getModifiers())).isTrue();
    }

    @Test
    void privateConstructorExists() throws NoSuchMethodException {
        Constructor<ActivosFlagEstado> ctor = ActivosFlagEstado.class.getDeclaredConstructor();
        assertThat(Modifier.isPrivate(ctor.getModifiers())).isTrue();
    }
}
