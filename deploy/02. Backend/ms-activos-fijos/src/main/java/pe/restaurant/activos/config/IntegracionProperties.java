package pe.restaurant.activos.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

import java.math.BigDecimal;

@Data
@ConfigurationProperties(prefix = "app.integracion")
public class IntegracionProperties {

    private final Contabilidad contabilidad = new Contabilidad();
    private final Compras compras = new Compras();

    @Data
    public static class Contabilidad {
        private boolean habilitada = true;
        /** Genera asiento en ms-contabilidad al calcular/aprobar/capitalizar/alta (HU-AF-PRO-002). */
        private boolean contabilizarAutomatico = true;
        private Long libroId = 1L;
        private String tipoAsiento = "AF-001";
        private Long monedaId;
        /** Genera asiento de reclasificación CC al ejecutar traslado con CC distintos. */
        private boolean contabilizarTrasladoAutomatico = false;
    }

    @Data
    public static class Compras {
        private boolean habilitada = true;
        private BigDecimal toleranciaImporte = new BigDecimal("0.01");
    }
}
