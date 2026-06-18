package pe.restaurant.activos.integration;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import pe.restaurant.activos.config.IntegracionProperties;
import pe.restaurant.activos.integracion.ContabilidadAutoContabilizador;
import pe.restaurant.common.exception.BusinessException;

import java.util.concurrent.atomic.AtomicBoolean;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class ContabilidadAutoContabilizadorTest {

    @Mock
    private IntegracionProperties integracionProperties;
    @InjectMocks
    private ContabilidadAutoContabilizador autoContabilizador;

    private IntegracionProperties.Contabilidad stubContabilidad(boolean habilitada, boolean automatico) {
        IntegracionProperties.Contabilidad ctb = new IntegracionProperties.Contabilidad();
        ctb.setHabilitada(habilitada);
        ctb.setContabilizarAutomatico(automatico);
        return ctb;
    }

    @Test
    void isAutomaticoReturnsTrueWhenBothEnabled() {
        when(integracionProperties.getContabilidad())
                .thenReturn(stubContabilidad(true, true));
        assertThat(autoContabilizador.isAutomatico()).isTrue();
    }

    @Test
    void isAutomaticoReturnsFalseWhenHabilitadaDisabled() {
        when(integracionProperties.getContabilidad())
                .thenReturn(stubContabilidad(false, true));
        assertThat(autoContabilizador.isAutomatico()).isFalse();
    }

    @Test
    void isAutomaticoReturnsFalseWhenContabilizarAutomaticoDisabled() {
        when(integracionProperties.getContabilidad())
                .thenReturn(stubContabilidad(true, false));
        assertThat(autoContabilizador.isAutomatico()).isFalse();
    }

    @Test
    void isAutomaticoReturnsFalseWhenBothDisabled() {
        when(integracionProperties.getContabilidad())
                .thenReturn(stubContabilidad(false, false));
        assertThat(autoContabilizador.isAutomatico()).isFalse();
    }

    @Test
    void ejecutarSiAutomaticoRunsWhenAutomatic() {
        when(integracionProperties.getContabilidad())
                .thenReturn(stubContabilidad(true, true));
        AtomicBoolean executed = new AtomicBoolean(false);
        autoContabilizador.ejecutarSiAutomatico("TEST", () -> executed.set(true));
        assertThat(executed).isTrue();
    }

    @Test
    void ejecutarSiAutomaticoSkipsWhenNotAutomatic() {
        when(integracionProperties.getContabilidad())
                .thenReturn(stubContabilidad(false, true));
        AtomicBoolean executed = new AtomicBoolean(false);
        autoContabilizador.ejecutarSiAutomatico("TEST", () -> executed.set(true));
        assertThat(executed).isFalse();
    }

    @Test
    void ejecutarSiAutomaticoRethrowsBusinessException() {
        when(integracionProperties.getContabilidad())
                .thenReturn(stubContabilidad(true, true));
        BusinessException bex = new BusinessException("error contable");

        assertThatThrownBy(() ->
                autoContabilizador.ejecutarSiAutomatico("DEPRECIACION", () -> { throw bex; }))
                .isSameAs(bex);
    }

    private IntegracionProperties.Contabilidad stubTraslado(boolean habilitada, boolean traslado) {
        IntegracionProperties.Contabilidad ctb = new IntegracionProperties.Contabilidad();
        ctb.setHabilitada(habilitada);
        ctb.setContabilizarTrasladoAutomatico(traslado);
        return ctb;
    }

    @Test
    void ejecutarTrasladoSiAutomaticoRunsWhenEnabledAndTrasladoTrue() {
        when(integracionProperties.getContabilidad())
                .thenReturn(stubTraslado(true, true));
        AtomicBoolean executed = new AtomicBoolean(false);

        autoContabilizador.ejecutarTrasladoSiAutomatico("TRASLADO", () -> executed.set(true));

        assertThat(executed).isTrue();
    }

    @Test
    void ejecutarTrasladoSiAutomaticoSkipsWhenHabilitadaFalse() {
        when(integracionProperties.getContabilidad())
                .thenReturn(stubTraslado(false, true));
        AtomicBoolean executed = new AtomicBoolean(false);

        autoContabilizador.ejecutarTrasladoSiAutomatico("TRASLADO", () -> executed.set(true));

        assertThat(executed).isFalse();
    }

    @Test
    void ejecutarTrasladoSiAutomaticoSkipsWhenTrasladoFalse() {
        when(integracionProperties.getContabilidad())
                .thenReturn(stubTraslado(true, false));
        AtomicBoolean executed = new AtomicBoolean(false);

        autoContabilizador.ejecutarTrasladoSiAutomatico("TRASLADO", () -> executed.set(true));

        assertThat(executed).isFalse();
    }

    @Test
    void ejecutarTrasladoSiAutomaticoRethrowsBusinessException() {
        when(integracionProperties.getContabilidad())
                .thenReturn(stubTraslado(true, true));
        BusinessException bex = new BusinessException("error traslado");

        assertThatThrownBy(() ->
                autoContabilizador.ejecutarTrasladoSiAutomatico("TRASLADO", () -> { throw bex; }))
                .isSameAs(bex);
    }
}
