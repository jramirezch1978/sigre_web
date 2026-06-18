package pe.restaurant.finanzas.service.impl.tax;

import pe.restaurant.finanzas.dto.request.ImpuestoItemRequest;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Clasifica impuestos según tipo de cálculo y esFiscalizado.
 * No tiene estado ni dependencias — pura función de clasificación.
 */
public class ClasificadorImpuestos {

    public static class Clasificacion {
        public BigDecimal tasaIgv = BigDecimal.ZERO;           // tipoCalculo=1 AND esFiscalizado=true
        public BigDecimal tasaBaseAffecting = BigDecimal.ZERO; // tipoCalculo=3
        public BigDecimal tasaOtros = BigDecimal.ZERO;         // tipoCalculo=1 AND esFiscalizado=false

        public List<ImpuestoItemRequest> igvList = Collections.emptyList();
        public List<ImpuestoItemRequest> baseAffectingList = Collections.emptyList();
        public List<ImpuestoItemRequest> otrosList = Collections.emptyList();
        public List<ImpuestoItemRequest> montoFijoList = Collections.emptyList();
    }

    /**
     * Clasifica los impuestos de un ítem.
     *
     * @param impuestos  lista de impuestos del ítem
     * @param paisCodigo código del país (usado para determinarScale, no para clasificación)
     * @return Clasificacion con los grupos separados y tasas sumadas
     */
    public static Clasificacion clasificar(List<ImpuestoItemRequest> impuestos, String paisCodigo) {
        Clasificacion c = new Clasificacion();

        if (impuestos == null || impuestos.isEmpty()) {
            return c;
        }

        List<ImpuestoItemRequest> igvList = new ArrayList<>();
        List<ImpuestoItemRequest> baseAffectingList = new ArrayList<>();
        List<ImpuestoItemRequest> otrosList = new ArrayList<>();
        List<ImpuestoItemRequest> montoFijoList = new ArrayList<>();

        for (ImpuestoItemRequest imp : impuestos) {
            Integer tc = imp.getTipoCalculo() != null ? imp.getTipoCalculo() : 1;
            switch (tc) {
                case 2: // MONTO_FIJO
                    montoFijoList.add(imp);
                    break;
                case 3: // BASE_AFFECTING (ISC-equivalent)
                    baseAffectingList.add(imp);
                    c.tasaBaseAffecting = c.tasaBaseAffecting.add(imp.getTasa());
                    break;
                default: // PORCENTAJE (1)
                    if (Boolean.TRUE.equals(imp.getEsFiscalizado())) {
                        igvList.add(imp);
                        c.tasaIgv = c.tasaIgv.add(imp.getTasa());
                    } else {
                        otrosList.add(imp);
                        c.tasaOtros = c.tasaOtros.add(imp.getTasa());
                    }
                    break;
            }
        }

        c.igvList = igvList;
        c.baseAffectingList = baseAffectingList;
        c.otrosList = otrosList;
        c.montoFijoList = montoFijoList;

        return c;
    }
}
