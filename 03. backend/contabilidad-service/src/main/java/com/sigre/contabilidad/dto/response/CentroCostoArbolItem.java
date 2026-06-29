package com.sigre.contabilidad.dto.response;

/**
 * Centro de costo (hoja) con su jerarquía de 3 niveles, para construir el treeview en el frontend.
 * id = FK destino (contabilidad.centros_costo.id).
 */
public record CentroCostoArbolItem(
        Long id,
        String cencos,
        String descCencos,
        String codN1,
        String descN1,
        String codN2,
        String descN2,
        String codN3,
        String descN3) {
}
