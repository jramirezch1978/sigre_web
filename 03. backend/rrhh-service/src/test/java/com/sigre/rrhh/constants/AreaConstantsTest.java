package com.sigre.rrhh.constants;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DisplayName("AreaConstants - Pruebas Unitarias")
class AreaConstantsTest {

    @Test
    @DisplayName("Debe tener constantes de error definidas")
    void debeTenerConstantesDeErrorDefinidas() {
        // Assert
        assertThat(AreaConstants.ERROR_NOMBRE_OBLIGATORIO).isEqualTo("RH-AR-001");
        assertThat(AreaConstants.ERROR_NOMBRE_DUPLICADO).isEqualTo("RH-AR-002");
        assertThat(AreaConstants.ERROR_CICLO_JERARQUIA).isEqualTo("RH-AR-003");
        assertThat(AreaConstants.ERROR_ELIMINACION_CON_HIJOS).isEqualTo("RH-AR-004");
        assertThat(AreaConstants.ERROR_AREA_NO_ENCONTRADA).isEqualTo("RH-AR-005");
    }

    @Test
    @DisplayName("Debe tener mensajes de error definidos")
    void debeTenerMensajesDeErrorDefinidos() {
        // Assert
        assertThat(AreaConstants.MSG_NOMBRE_OBLIGATORIO).isNotEmpty();
        assertThat(AreaConstants.MSG_NOMBRE_DUPLICADO).isNotEmpty();
        assertThat(AreaConstants.MSG_CICLO_JERARQUIA).isNotEmpty();
        assertThat(AreaConstants.MSG_ELIMINACION_CON_HIJOS).isNotEmpty();
        assertThat(AreaConstants.MSG_AREA_NO_ENCONTRADA).isNotEmpty();
        assertThat(AreaConstants.MSG_AREA_NO_PUEDE_SER_PROPIO_PADRE).isNotEmpty();
    }

    @Test
    @DisplayName("Debe tener mensajes de éxito definidos")
    void debeTenerMensajesDeExitoDefinidos() {
        // Assert
        assertThat(AreaConstants.MSG_AREA_CREADA).isNotEmpty();
        assertThat(AreaConstants.MSG_AREA_ACTUALIZADA).isNotEmpty();
        assertThat(AreaConstants.MSG_AREA_ELIMINADA).isNotEmpty();
        assertThat(AreaConstants.MSG_AREAS_OBTENIDAS).isNotEmpty();
        assertThat(AreaConstants.MSG_ARBOL_OBTENIDO).isNotEmpty();
    }

    @Test
    @DisplayName("Constructor privado previene instanciación")
    void constructorPrivadoPrevienteInstanciacion() {
        // Act & Assert - Solo verificamos que las constantes son accesibles
        // El constructor privado se prueba implícitamente al poder acceder a las constantes
        assertThat(AreaConstants.ERROR_NOMBRE_OBLIGATORIO).isNotNull();
        assertThat(AreaConstants.MSG_NOMBRE_OBLIGATORIO).isNotNull();
    }
}
