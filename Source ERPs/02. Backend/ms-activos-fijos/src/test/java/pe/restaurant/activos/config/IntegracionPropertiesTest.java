package pe.restaurant.activos.config;

import org.junit.jupiter.api.Test;

import java.math.BigDecimal;

import static org.assertj.core.api.Assertions.assertThat;

class IntegracionPropertiesTest {

    @Test
    void contabilidadDefaults() {
        IntegracionProperties props = new IntegracionProperties();
        IntegracionProperties.Contabilidad ctb = props.getContabilidad();

        assertThat(ctb.isHabilitada()).isTrue();
        assertThat(ctb.isContabilizarAutomatico()).isTrue();
        assertThat(ctb.getLibroId()).isEqualTo(1L);
        assertThat(ctb.getTipoAsiento()).isEqualTo("AF-001");
        assertThat(ctb.getMonedaId()).isNull();
    }

    @Test
    void comprasDefaults() {
        IntegracionProperties props = new IntegracionProperties();
        IntegracionProperties.Compras compras = props.getCompras();

        assertThat(compras.isHabilitada()).isTrue();
        assertThat(compras.getToleranciaImporte()).isEqualByComparingTo(new BigDecimal("0.01"));
    }

    @Test
    void contabilidadSettersWork() {
        IntegracionProperties props = new IntegracionProperties();
        IntegracionProperties.Contabilidad ctb = props.getContabilidad();

        ctb.setHabilitada(false);
        ctb.setContabilizarAutomatico(false);
        ctb.setLibroId(5L);
        ctb.setTipoAsiento("07");
        ctb.setMonedaId(10L);

        assertThat(ctb.isHabilitada()).isFalse();
        assertThat(ctb.isContabilizarAutomatico()).isFalse();
        assertThat(ctb.getLibroId()).isEqualTo(5L);
        assertThat(ctb.getTipoAsiento()).isEqualTo("07");
        assertThat(ctb.getMonedaId()).isEqualTo(10L);
    }

    @Test
    void comprasSettersWork() {
        IntegracionProperties props = new IntegracionProperties();
        IntegracionProperties.Compras compras = props.getCompras();

        compras.setHabilitada(false);
        compras.setToleranciaImporte(new BigDecimal("0.05"));

        assertThat(compras.isHabilitada()).isFalse();
        assertThat(compras.getToleranciaImporte()).isEqualByComparingTo(new BigDecimal("0.05"));
    }

    @Test
    void nestedObjectsAreNeverNull() {
        IntegracionProperties props = new IntegracionProperties();
        assertThat(props.getContabilidad()).isNotNull();
        assertThat(props.getCompras()).isNotNull();
    }

    @Test
    void hasConfigurationPropertiesAnnotation() {
        var annotation = IntegracionProperties.class
                .getAnnotation(org.springframework.boot.context.properties.ConfigurationProperties.class);
        assertThat(annotation).isNotNull();
        assertThat(annotation.prefix()).isEqualTo("app.integracion");
    }
}
