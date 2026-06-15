package com.sigre.core;

import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

import static org.assertj.core.api.Assertions.assertThat;

class CoreMaestrosApplicationTest {

    @Test
    void classExists() {
        assertThat(CoreMaestrosApplication.class).isNotNull();
    }

    @Test
    void mainMethodSignature_isPublicStaticVoidWithStringArray() throws NoSuchMethodException {
        Method main = CoreMaestrosApplication.class.getMethod("main", String[].class);

        assertThat(Modifier.isPublic(main.getModifiers())).isTrue();
        assertThat(Modifier.isStatic(main.getModifiers())).isTrue();
        assertThat(main.getReturnType()).isEqualTo(void.class);
    }

    @Test
    void hasSpringBootApplicationAnnotation() {
        assertThat(CoreMaestrosApplication.class
                .isAnnotationPresent(org.springframework.boot.autoconfigure.SpringBootApplication.class))
                .isTrue();
    }
}
