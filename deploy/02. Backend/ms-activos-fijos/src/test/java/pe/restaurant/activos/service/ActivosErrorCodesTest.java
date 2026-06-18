package pe.restaurant.activos.service;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Modifier;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

class ActivosErrorCodesTest {

    @Test
    void allPublicStaticFieldsAreNonNullStrings() throws IllegalAccessException {
        for (Field field : ActivosErrorCodes.class.getDeclaredFields()) {
            if (Modifier.isPublic(field.getModifiers())
                    && Modifier.isStatic(field.getModifiers())
                    && field.getType() == String.class) {
                String value = (String) field.get(null);
                assertThat(value)
                        .as("Field %s should not be null", field.getName())
                        .isNotNull()
                        .isNotBlank();
            }
        }
    }

    @Test
    void allCodesFollowACTPrefix() throws IllegalAccessException {
        for (Field field : ActivosErrorCodes.class.getDeclaredFields()) {
            if (Modifier.isPublic(field.getModifiers())
                    && Modifier.isStatic(field.getModifiers())
                    && field.getType() == String.class) {
                String value = (String) field.get(null);
                assertThat(value)
                        .as("Field %s should start with ACT-", field.getName())
                        .startsWith("ACT-");
            }
        }
    }

    @Test
    void spotCheckKnownCodes() {
        assertThat(ActivosErrorCodes.CLASE_CODIGO_DUPLICADO).isEqualTo("ACT-001");
        assertThat(ActivosErrorCodes.SUB_CLASE_CODIGO_DUPLICADO).isEqualTo("ACT-002");
        assertThat(ActivosErrorCodes.UBICACION_CODIGO_DUPLICADO).isEqualTo("ACT-003");
        assertThat(ActivosErrorCodes.ACTIVO_MAESTRO_NO_ENCONTRADO).isEqualTo("ACT-018");
        assertThat(ActivosErrorCodes.SEED_BD_INCOMPATIBLE).isEqualTo("ACT-060");
        assertThat(ActivosErrorCodes.ADAPTACION_NO_CAPITALIZADA).isEqualTo("ACT-077");
    }

    @Test
    void allCodesAreUnique() throws IllegalAccessException {
        java.util.Set<String> seen = new java.util.HashSet<>();
        for (Field field : ActivosErrorCodes.class.getDeclaredFields()) {
            if (Modifier.isPublic(field.getModifiers())
                    && Modifier.isStatic(field.getModifiers())
                    && field.getType() == String.class) {
                String value = (String) field.get(null);
                assertThat(seen.add(value))
                        .as("Duplicate code %s in field %s", value, field.getName())
                        .isTrue();
            }
        }
    }

    @Test
    void privateConstructorThrowsUnsupportedOperationException() throws Exception {
        Constructor<ActivosErrorCodes> ctor = ActivosErrorCodes.class.getDeclaredConstructor();
        ctor.setAccessible(true);
        assertThatThrownBy(ctor::newInstance)
                .isInstanceOf(InvocationTargetException.class)
                .hasCauseInstanceOf(UnsupportedOperationException.class);
    }

    @Test
    void classIsFinal() {
        assertThat(Modifier.isFinal(ActivosErrorCodes.class.getModifiers())).isTrue();
    }

    @Test
    void hasMinimumNumberOfCodes() throws IllegalAccessException {
        long count = 0;
        for (Field field : ActivosErrorCodes.class.getDeclaredFields()) {
            if (Modifier.isPublic(field.getModifiers())
                    && Modifier.isStatic(field.getModifiers())
                    && field.getType() == String.class) {
                count++;
            }
        }
        assertThat(count).isGreaterThanOrEqualTo(50);
    }
}
