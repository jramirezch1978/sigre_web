package com.sigre.almacen.domain;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class ValeMovFlagEstadoTest {

    @Test
    void toLabel_codigosYDesconocido() {
        assertThat(ValeMovFlagEstado.toLabel(ValeMovFlagEstado.ACTIVO)).isEqualTo("ACTIVO");
        assertThat(ValeMovFlagEstado.toLabel(ValeMovFlagEstado.ANULADO)).isEqualTo("ANULADO");
        assertThat(ValeMovFlagEstado.toLabel("9")).isEqualTo("9");
        assertThat(ValeMovFlagEstado.toLabel(null)).isNull();
        assertThat(ValeMovFlagEstado.toLabel("")).isNull();
    }

    @Test
    void fromFiltro_aceptaEtiquetasYCodigos() {
        assertThat(ValeMovFlagEstado.fromFiltro("ACTIVO")).isEqualTo(ValeMovFlagEstado.ACTIVO);
        assertThat(ValeMovFlagEstado.fromFiltro("REGISTRADO")).isEqualTo(ValeMovFlagEstado.ACTIVO);
        assertThat(ValeMovFlagEstado.fromFiltro("ANULADO")).isEqualTo(ValeMovFlagEstado.ANULADO);
        assertThat(ValeMovFlagEstado.fromFiltro("CERRADO")).isEqualTo(ValeMovFlagEstado.CERRADO);
        assertThat(ValeMovFlagEstado.fromFiltro("1")).isEqualTo("1");
        assertThat(ValeMovFlagEstado.fromFiltro("  ")).isNull();
        assertThat(ValeMovFlagEstado.fromFiltro("DESCONOCIDO")).isNull();
    }
}
