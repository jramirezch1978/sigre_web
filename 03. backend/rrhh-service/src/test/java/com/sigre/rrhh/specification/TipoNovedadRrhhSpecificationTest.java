package com.sigre.rrhh.specification;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.data.jpa.domain.Specification;
import com.sigre.rrhh.entity.TipoNovedadRrhh;

import static org.assertj.core.api.Assertions.assertThat;

@DisplayName("TipoNovedadRrhhSpecification — Pruebas Unitarias")
class TipoNovedadRrhhSpecificationTest {

    @Test
    @DisplayName("codigoContains() -> debe crear especificación válida")
    void codigoContains_debeCrearEspecificacionValida() {
        Specification<TipoNovedadRrhh> spec = TipoNovedadRrhhSpecification.codigoContains("PER");

        assertThat(spec).isNotNull();
    }

    @Test
    @DisplayName("codigoContains() con null -> retorna null")
    void codigoContains_conNull_retornaNull() {
        Specification<TipoNovedadRrhh> spec = TipoNovedadRrhhSpecification.codigoContains(null);

        assertThat(spec).isNull();
    }

    @Test
    @DisplayName("codigoContains() con vacío -> retorna null")
    void codigoContains_conVacio_retornaNull() {
        Specification<TipoNovedadRrhh> spec = TipoNovedadRrhhSpecification.codigoContains("");

        assertThat(spec).isNull();
    }

    @Test
    @DisplayName("nombreContains() -> debe crear especificación válida")
    void nombreContains_debeCrearEspecificacionValida() {
        Specification<TipoNovedadRrhh> spec = TipoNovedadRrhhSpecification.nombreContains("Permiso");

        assertThat(spec).isNotNull();
    }

    @Test
    @DisplayName("nombreContains() con null -> retorna null")
    void nombreContains_conNull_retornaNull() {
        Specification<TipoNovedadRrhh> spec = TipoNovedadRrhhSpecification.nombreContains(null);

        assertThat(spec).isNull();
    }

    @Test
    @DisplayName("flagEstadoEquals() -> debe crear especificación válida")
    void flagEstadoEquals_debeCrearEspecificacionValida() {
        Specification<TipoNovedadRrhh> spec = TipoNovedadRrhhSpecification.flagEstadoEquals("1");

        assertThat(spec).isNotNull();
    }

    @Test
    @DisplayName("flagEstadoEquals() con null -> retorna null")
    void flagEstadoEquals_conNull_retornaNull() {
        Specification<TipoNovedadRrhh> spec = TipoNovedadRrhhSpecification.flagEstadoEquals(null);

        assertThat(spec).isNull();
    }

    @Test
    @DisplayName("flagEstadoEquals() con vacío -> retorna null")
    void flagEstadoEquals_conVacio_retornaNull() {
        Specification<TipoNovedadRrhh> spec = TipoNovedadRrhhSpecification.flagEstadoEquals("");

        assertThat(spec).isNull();
    }

    @Test
    @DisplayName("Combinación AND de especificaciones -> debe funcionar")
    void combinacionAND_debeFuncionar() {
        Specification<TipoNovedadRrhh> codigoSpec = TipoNovedadRrhhSpecification.codigoContains("PER");
        Specification<TipoNovedadRrhh> nombreSpec = TipoNovedadRrhhSpecification.nombreContains("Permiso");

        Specification<TipoNovedadRrhh> combined = codigoSpec.and(nombreSpec);

        assertThat(combined).isNotNull();
    }
}
