package com.sigre.finanzas.enums;

public enum TipoMovimientoCxP {
    REGISTRO,
    PAGO,
    NOTA_CREDITO,
    AJUSTE,
    CANJE_ORIGEN,
    CANJE_DESTINO,
    LETRA;
    
    public static TipoMovimientoCxP fromString(String tipo) {
        if (tipo == null) {
            return null;
        }
        for (TipoMovimientoCxP e : TipoMovimientoCxP.values()) {
            if (e.name().equalsIgnoreCase(tipo)) {
                return e;
            }
        }
        throw new IllegalArgumentException("Tipo de movimiento CxP inválido: " + tipo);
    }
}
