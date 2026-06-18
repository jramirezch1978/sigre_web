package pe.restaurant.activos.integration;

import org.junit.jupiter.api.Test;
import pe.restaurant.activos.integracion.AfIntegracionContableModulo;

import java.lang.reflect.Constructor;

import static org.assertj.core.api.Assertions.assertThat;

class AfIntegracionContableModuloTest {

    @Test
    void allConstantsAreNonNull() {
        assertThat(AfIntegracionContableModulo.DEPRECIACION).isNotNull();
        assertThat(AfIntegracionContableModulo.DEVENGO_PRIMA).isNotNull();
        assertThat(AfIntegracionContableModulo.VENTA).isNotNull();
        assertThat(AfIntegracionContableModulo.VALUACION).isNotNull();
        assertThat(AfIntegracionContableModulo.ALTA_ACTIVO).isNotNull();
        assertThat(AfIntegracionContableModulo.ADAPTACION).isNotNull();
        assertThat(AfIntegracionContableModulo.BAJA_ACTIVO).isNotNull();
    }

    @Test
    void constantsHaveExpectedPrefix() {
        assertThat(AfIntegracionContableModulo.DEPRECIACION).startsWith("AF");
        assertThat(AfIntegracionContableModulo.DEVENGO_PRIMA).startsWith("AF_");
        assertThat(AfIntegracionContableModulo.VENTA).startsWith("AF_");
        assertThat(AfIntegracionContableModulo.VALUACION).startsWith("AF_");
        assertThat(AfIntegracionContableModulo.ALTA_ACTIVO).startsWith("AF_");
        assertThat(AfIntegracionContableModulo.ADAPTACION).startsWith("AF_");
        assertThat(AfIntegracionContableModulo.BAJA_ACTIVO).startsWith("AF_");
        assertThat(AfIntegracionContableModulo.TRASLADO).startsWith("AF_");
    }

    @Test
    void constantsHaveExpectedValues() {
        assertThat(AfIntegracionContableModulo.DEPRECIACION).isEqualTo("AF-001");
        assertThat(AfIntegracionContableModulo.DEVENGO_PRIMA).isEqualTo("AF_DEVENGO_PRIMA");
        assertThat(AfIntegracionContableModulo.VENTA).isEqualTo("AF_VENTA");
        assertThat(AfIntegracionContableModulo.VALUACION).isEqualTo("AF_VALUACION");
        assertThat(AfIntegracionContableModulo.ALTA_ACTIVO).isEqualTo("AF_ALTA_ACTIVO");
        assertThat(AfIntegracionContableModulo.ADAPTACION).isEqualTo("AF_ADAPTACION");
        assertThat(AfIntegracionContableModulo.BAJA_ACTIVO).isEqualTo("AF_BAJA_ACTIVO");
    }

    @Test
    void moduloFlagIsSingleChar() {
        assertThat(AfIntegracionContableModulo.MODULO).hasSize(1);
        assertThat(AfIntegracionContableModulo.MODULO).isEqualTo("O");
    }

    @Test
    void privateConstructorExists() throws Exception {
        Constructor<AfIntegracionContableModulo> ctor =
                AfIntegracionContableModulo.class.getDeclaredConstructor();
        assertThat(java.lang.reflect.Modifier.isPrivate(ctor.getModifiers())).isTrue();
    }

    @Test
    void classIsFinal() {
        assertThat(java.lang.reflect.Modifier.isFinal(AfIntegracionContableModulo.class.getModifiers())).isTrue();
    }
}
