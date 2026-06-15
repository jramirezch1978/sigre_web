package com.sigre.contabilidad.enums;

/**
 * Naturaleza del asiento + módulo de origen.
 * <p>
 * naturaleza_asiento VARCHAR(1):
 * 1=CARTERA_PAGOS, 2=CARTERA_COBROS, 3=TRANSFERENCIA, 4=LIQUIDACION_GIRO,
 * 5=APLICACION_DOCUMENTOS, 6=CANJE_DOCUMENTOS, 7=REGISTRO_CNTAS_PAGAR,
 * 8=REGISTRO_CNTAS_COBRAR, A=AF_DEPRECIACION, B=AF_REVALUACION,
 * C=AF_INDEXACION, D=AF_DEVENGO_SEGUROS, E=AF_VENTA, F=AF_ALTA_ACTIVO,
 * G=AF_ADAPTACION, H=AF_BAJA_ACTIVO, I=AF_TRASLADO, M=MANUAL.
 * <p>
 * modulo_origen VARCHAR(1):
 * C=Contabilidad, F=Finanzas, V=Ventas, O=Activos Fijos, A=Almacén, P=Compras.
 */
public enum TipoOperacionContable {

    CARTERA_PAGOS("F", "1"),
    CARTERA_COBROS("V", "2"),
    TRANSFERENCIA("F", "3"),
    LIQUIDACION_GIRO("F", "4"),
    APLICACION_DOCUMENTOS("F", "5"),
    CANJE_DOCUMENTOS("F", "6"),
    REGISTRO_CNTAS_PAGAR("F", "7"),
    REGISTRO_CNTAS_COBRAR("V", "8"),

    AF_DEPRECIACION("O", "A"),
    AF_REVALUACION("O", "B"),
    AF_INDEXACION("O", "C"),
    AF_DEVENGO_SEGUROS("O", "D"),
    AF_VENTA("O", "E"),
    AF_ALTA_ACTIVO("O", "F"),
    AF_ADAPTACION("O", "G"),
    AF_BAJA_ACTIVO("O", "H"),
    AF_TRASLADO("O", "I"),

    MANUAL("C", "M");

    private final String modulo;
    private final String tipoOperacion;

    TipoOperacionContable(String modulo, String tipoOperacion) {
        this.modulo = modulo;
        this.tipoOperacion = tipoOperacion;
    }

    /** Flag CHAR(1) del módulo: C=Contabilidad, F=Finanzas, V=Ventas, O=Activos Fijos, A=Almacén, P=Compras */
    public String getModulo() { return modulo; }

    /** Flag CHAR(1) de naturaleza: 1..8, A..I, M */
    public String getTipoOperacion() { return tipoOperacion; }
}
