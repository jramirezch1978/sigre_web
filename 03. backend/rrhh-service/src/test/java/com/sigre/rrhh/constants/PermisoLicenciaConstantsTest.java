package com.sigre.rrhh.constants;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@DisplayName("PermisoLicenciaConstants — Pruebas Unitarias")
class PermisoLicenciaConstantsTest {

    @Test
    @DisplayName("Constructor privado -> lanza UnsupportedOperationException")
    void constructorPrivado_lanzaExcepcion() throws Exception {
        Constructor<PermisoLicenciaConstants> constructor = PermisoLicenciaConstants.class.getDeclaredConstructor();
        constructor.setAccessible(true);

        assertThatThrownBy(constructor::newInstance)
            .isInstanceOf(InvocationTargetException.class)
            .hasRootCauseInstanceOf(UnsupportedOperationException.class);
    }

    @Test
    @DisplayName("Códigos de error -> valores correctos")
    void codigosError_valoresCorrectos() {
        assertThat(PermisoLicenciaConstants.ERROR_DATOS_INCOMPLETOS).isEqualTo("RH-PL-001");
        assertThat(PermisoLicenciaConstants.ERROR_TRABAJADOR_INEXISTENTE).isEqualTo("RH-PL-002");
        assertThat(PermisoLicenciaConstants.ERROR_FECHAS_INVALIDAS).isEqualTo("RH-PL-003");
        assertThat(PermisoLicenciaConstants.ERROR_SOLAPAMIENTO).isEqualTo("RH-PL-004");
        assertThat(PermisoLicenciaConstants.ERROR_YA_APROBADO_RECHAZADO).isEqualTo("RH-PL-005");
        assertThat(PermisoLicenciaConstants.ERROR_NO_ENCONTRADO).isEqualTo("RH-PL-006");
        assertThat(PermisoLicenciaConstants.ERROR_TIPO_SUSPENSION_INEXISTENTE).isEqualTo("RH-PL-007");
    }

    @Test
    @DisplayName("Mensajes de error -> no vacíos")
    void mensajesError_noVacios() {
        assertThat(PermisoLicenciaConstants.MSG_DATOS_INCOMPLETOS).isNotBlank();
        assertThat(PermisoLicenciaConstants.MSG_TRABAJADOR_INEXISTENTE).isNotBlank();
        assertThat(PermisoLicenciaConstants.MSG_FECHAS_INVALIDAS).isNotBlank();
        assertThat(PermisoLicenciaConstants.MSG_SOLAPAMIENTO).isNotBlank();
        assertThat(PermisoLicenciaConstants.MSG_YA_APROBADO_RECHAZADO).isNotBlank();
        assertThat(PermisoLicenciaConstants.MSG_NO_ENCONTRADO).isNotBlank();
        assertThat(PermisoLicenciaConstants.MSG_TIPO_SUSPENSION_INEXISTENTE).isNotBlank();
    }

    @Test
    @DisplayName("Mensajes de éxito -> no vacíos")
    void mensajesExito_noVacios() {
        assertThat(PermisoLicenciaConstants.MSG_CREADO).isNotBlank();
        assertThat(PermisoLicenciaConstants.MSG_ACTUALIZADO).isNotBlank();
        assertThat(PermisoLicenciaConstants.MSG_APROBADO).isNotBlank();
        assertThat(PermisoLicenciaConstants.MSG_RECHAZADO).isNotBlank();
        assertThat(PermisoLicenciaConstants.MSG_ELIMINADO).isNotBlank();
        assertThat(PermisoLicenciaConstants.MSG_OBTENIDOS).isNotBlank();
    }
}
