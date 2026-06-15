package com.sigre.compras.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;
import com.sigre.compras.entity.OrdenCompra;
import com.sigre.compras.entity.OrdenCompraDet;
import com.sigre.compras.entity.TipoPercepcion;
import com.sigre.compras.entity.TiposImpuestoRef;
import com.sigre.compras.repository.TipoPercepcionRepository;
import com.sigre.compras.repository.TiposImpuestoRefRepository;

import java.math.BigDecimal;
import java.math.RoundingMode;

@Component
@RequiredArgsConstructor
public class OrdenCompraCalculator {

    private static final int SCALE_MONTO = 4;
    private static final int SCALE_PRECIO = 6;
    private static final BigDecimal CIEN = new BigDecimal("100");

    private final TiposImpuestoRefRepository tiposImpuestoRefRepository;
    private final TipoPercepcionRepository tipoPercepcionRepository;

    public void calcularTotales(OrdenCompra oc) {
        BigDecimal sumSubtotal = BigDecimal.ZERO;
        BigDecimal sumDescuento = BigDecimal.ZERO;
        BigDecimal sumIgv = BigDecimal.ZERO;
        BigDecimal sumPercepcion = BigDecimal.ZERO;

        for (OrdenCompraDet linea : oc.getLineas()) {
            if ("0".equals(linea.getFlagEstado())) continue;
            calcularLinea(linea);

            BigDecimal baseLinea = linea.getCantProyectada()
                    .multiply(linea.getValorUnitario())
                    .setScale(SCALE_MONTO, RoundingMode.HALF_UP);
            sumSubtotal = sumSubtotal.add(baseLinea);
            sumDescuento = sumDescuento.add(safe(linea.getDescuentoMonto()));
            sumIgv = sumIgv.add(safe(linea.getValorImpuesto()));
            sumPercepcion = sumPercepcion.add(safe(linea.getPercepcionMonto()));
        }

        oc.setSubtotal(sumSubtotal);
        oc.setDescuentoTotal(sumDescuento);
        oc.setIgvTotal(sumIgv);
        oc.setPercepcionTotal(sumPercepcion);
        oc.setTotal(sumSubtotal.subtract(sumDescuento).add(sumIgv).add(sumPercepcion));
    }

    public void calcularLinea(OrdenCompraDet linea) {
        BigDecimal baseLinea = linea.getCantProyectada()
                .multiply(linea.getValorUnitario())
                .setScale(SCALE_MONTO, RoundingMode.HALF_UP);

        BigDecimal dscto = BigDecimal.ZERO;
        if (linea.getDescuentoPorcentaje() != null && linea.getDescuentoPorcentaje().signum() > 0) {
            dscto = baseLinea.multiply(linea.getDescuentoPorcentaje())
                    .divide(CIEN, SCALE_MONTO, RoundingMode.HALF_UP);
        }
        linea.setDescuentoMonto(dscto);

        BigDecimal netoLinea = baseLinea.subtract(dscto);

        BigDecimal igv = BigDecimal.ZERO;
        if (linea.getTipoImpuestoId() != null) {
            igv = calcularImpuestoPorId(netoLinea, linea.getTipoImpuestoId());
        }
        linea.setValorImpuesto(igv);

        BigDecimal percepcion = BigDecimal.ZERO;
        if (linea.getTipoPercepcionId() != null) {
            BigDecimal basePercepcion = netoLinea.add(igv);
            percepcion = calcularPercepcionPorId(basePercepcion, linea.getTipoPercepcionId());
        }
        linea.setPercepcionMonto(percepcion);

        linea.setSubtotal(netoLinea.add(igv).add(percepcion));
    }

    public BigDecimal precioSinIgv(BigDecimal precioConIgv, BigDecimal igvTasa) {
        if (igvTasa == null || igvTasa.signum() == 0) return precioConIgv;
        BigDecimal divisor = BigDecimal.ONE.add(igvTasa.divide(CIEN, 10, RoundingMode.HALF_UP));
        return precioConIgv.divide(divisor, SCALE_PRECIO, RoundingMode.HALF_UP);
    }

    private BigDecimal calcularImpuestoPorId(BigDecimal base, Long tipoImpuestoId) {
        return tiposImpuestoRefRepository.findById(tipoImpuestoId)
                .map(t -> {
                    BigDecimal tasa = t.getTasaImpuesto() != null ? t.getTasaImpuesto() : BigDecimal.ZERO;
                    String signo = t.getSigno() != null ? t.getSigno() : "+";
                    BigDecimal monto = base.multiply(tasa)
                            .divide(CIEN, SCALE_MONTO, RoundingMode.HALF_UP);
                    return "-".equals(signo) ? monto.negate() : monto;
                })
                .orElse(BigDecimal.ZERO);
    }

    private BigDecimal calcularPercepcionPorId(BigDecimal base, Long tipoPercepcionId) {
        return tipoPercepcionRepository.findById(tipoPercepcionId)
                .map(tp -> base.multiply(tp.getTasa())
                        .divide(CIEN, SCALE_MONTO, RoundingMode.HALF_UP))
                .orElse(BigDecimal.ZERO);
    }

    private BigDecimal safe(BigDecimal v) {
        return v != null ? v : BigDecimal.ZERO;
    }
}
