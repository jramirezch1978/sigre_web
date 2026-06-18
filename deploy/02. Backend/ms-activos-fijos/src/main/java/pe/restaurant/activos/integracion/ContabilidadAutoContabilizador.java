package pe.restaurant.activos.integracion;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import pe.restaurant.activos.config.IntegracionProperties;
import pe.restaurant.common.exception.BusinessException;

/**
 * Ejecuta contabilización automática cuando {@code app.integracion.contabilidad.contabilizar-automatico=true}.
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class ContabilidadAutoContabilizador {

    private final IntegracionProperties integracionProperties;

    public boolean isAutomatico() {
        var cfg = integracionProperties.getContabilidad();
        return cfg.isHabilitada() && cfg.isContabilizarAutomatico();
    }

    public void ejecutarSiAutomatico(String operacion, Runnable contabilizar) {
        if (!isAutomatico()) {
            return;
        }
        ejecutarContabilizacion(operacion, contabilizar);
    }

    public void ejecutarTrasladoSiAutomatico(String operacion, Runnable contabilizar) {
        var cfg = integracionProperties.getContabilidad();
        if (!cfg.isHabilitada() || !cfg.isContabilizarTrasladoAutomatico()) {
            return;
        }
        ejecutarContabilizacion(operacion, contabilizar);
    }

    private void ejecutarContabilizacion(String operacion, Runnable contabilizar) {
        try {
            contabilizar.run();
        } catch (BusinessException e) {
            log.warn("Contabilización automática omitida en {}: {}", operacion, e.getMessage());
            throw e;
        }
    }
}
