package com.sigre.almacen.config;

import lombok.Getter;
import lombok.Setter;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;

import java.math.BigDecimal;

@Getter
@Setter
@Component
@ConfigurationProperties(prefix = "app.almacen.integracion")
public class AlmacenIntegracionProperties {

    /** Valida OC vs factura (cant_facturada) y opcionalmente conteo físico antes de recepcionar. */
    private boolean validarTresVias = true;

    private BigDecimal toleranciaTresVias = new BigDecimal("0.0001");
}
