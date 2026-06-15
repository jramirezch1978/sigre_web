package com.sigre.compras.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.compras.entity.OrdenServicio;
import com.sigre.compras.entity.OrdenServicioDet;
import com.sigre.compras.repository.TiposImpuestoRefRepository;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Component
@RequiredArgsConstructor
public class OrdenServicioCalculator {

    private static final int SCALE = 4;
    private static final BigDecimal CIEN = new BigDecimal("100");

    private final TiposImpuestoRefRepository tiposImpuestoRefRepository;

    public void calcularTotales(OrdenServicio os) {
        BigDecimal montoTotal = BigDecimal.ZERO;
        for (OrdenServicioDet linea : os.getLineas()) {
            if ("0".equals(linea.getFlagEstado())) continue;
            calcularLinea(linea);
            montoTotal = montoTotal.add(safe(linea.getSubtotal()));
        }
        os.setMontoTotal(montoTotal);
    }

    public void calcularLinea(OrdenServicioDet linea) {
        BigDecimal importe = safe(linea.getImporte());
        BigDecimal dsctoPct = safe(linea.getDsctoPorcentaje());
        BigDecimal decuento = importe.multiply(dsctoPct)
                .divide(CIEN, SCALE, RoundingMode.HALF_UP);
        linea.setDecuento(decuento);

        BigDecimal neto = importe.subtract(decuento);

        BigDecimal imp1 = BigDecimal.ZERO;
        if (linea.getTiposImpuestoId() != null) {
            imp1 = calcularImpuestoPorId(neto, linea.getTiposImpuestoId());
        }
        linea.setImpuesto(imp1);

        BigDecimal imp2 = BigDecimal.ZERO;
        if (linea.getTiposImpuesto2Id() != null) {
            imp2 = calcularImpuestoPorId(neto, linea.getTiposImpuesto2Id());
        }
        linea.setImpuesto2(imp2);

        linea.setSubtotal(neto.add(imp1).add(imp2));
    }

    private BigDecimal calcularImpuestoPorId(BigDecimal base, Long tipoImpuestoId) {
        return tiposImpuestoRefRepository.findById(tipoImpuestoId)
                .map(t -> {
                    BigDecimal tasa = t.getTasaImpuesto() != null ? t.getTasaImpuesto() : BigDecimal.ZERO;
                    String signo = t.getSigno() != null ? t.getSigno() : "+";
                    BigDecimal monto = base.multiply(tasa)
                            .divide(CIEN, SCALE, RoundingMode.HALF_UP);
                    return "-".equals(signo) ? monto.negate() : monto;
                })
                .orElse(BigDecimal.ZERO);
    }

    private BigDecimal safe(BigDecimal v) {
        return v != null ? v : BigDecimal.ZERO;
    }
}
