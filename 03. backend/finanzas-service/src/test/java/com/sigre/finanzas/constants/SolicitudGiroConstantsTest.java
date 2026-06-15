package com.sigre.finanzas.constants;

import static org.assertj.core.api.Assertions.assertThat;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;


@DisplayName("Pruebas Unitarias - SolicitudGiroConstants")
class SolicitudGiroConstantsTest {


    // ==== debeTenerConstantesCorrectas — otros ====

    @Test
    @DisplayName("Debe tener constantes de flagEstado correctas")
    void debeTenerConstantesCorrectas() {
        assertThat(SolicitudGiroConstants.FLAG_PENDIENTE).isEqualTo("3");
        assertThat(SolicitudGiroConstants.FLAG_APROBADA).isEqualTo("1");
        assertThat(SolicitudGiroConstants.FLAG_ANULADA).isEqualTo("0");
    }


    // ==== debeTenerTipoSolicitud — otros ====

    @Test
    @DisplayName("Debe tener constante de tipo de solicitud")
    void debeTenerTipoSolicitud() {
        assertThat(SolicitudGiroConstants.TIPO_ORDEN_GIRO).isEqualTo("O");
    }
}
