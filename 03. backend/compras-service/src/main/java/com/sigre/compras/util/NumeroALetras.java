package com.sigre.compras.util;

import java.math.BigDecimal;
import java.math.RoundingMode;

public final class NumeroALetras {

    private static final String[] UNIDADES = {
            "", "UNO", "DOS", "TRES", "CUATRO", "CINCO",
            "SEIS", "SIETE", "OCHO", "NUEVE", "DIEZ",
            "ONCE", "DOCE", "TRECE", "CATORCE", "QUINCE",
            "DIECISEIS", "DIECISIETE", "DIECIOCHO", "DIECINUEVE", "VEINTE",
            "VEINTIUNO", "VEINTIDOS", "VEINTITRES", "VEINTICUATRO", "VEINTICINCO",
            "VEINTISEIS", "VEINTISIETE", "VEINTIOCHO", "VEINTINUEVE"
    };

    private static final String[] DECENAS = {
            "", "", "", "TREINTA", "CUARENTA", "CINCUENTA",
            "SESENTA", "SETENTA", "OCHENTA", "NOVENTA"
    };

    private static final String[] CENTENAS = {
            "", "CIENTO", "DOSCIENTOS", "TRESCIENTOS", "CUATROCIENTOS", "QUINIENTOS",
            "SEISCIENTOS", "SETECIENTOS", "OCHOCIENTOS", "NOVECIENTOS"
    };

    private NumeroALetras() {
    }

    public static String convertir(BigDecimal monto, String monedaNombre) {
        if (monto == null) monto = BigDecimal.ZERO;
        monto = monto.abs().setScale(2, RoundingMode.HALF_UP);

        long parteEntera = monto.longValue();
        int decimales = monto.remainder(BigDecimal.ONE)
                .movePointRight(2).intValue();

        String letras = convertirEntero(parteEntera);
        if (parteEntera == 0) letras = "CERO";

        String moneda = monedaNombre != null ? monedaNombre.toUpperCase() : "";
        return letras + " Y " + String.format("%02d", decimales) + "/100 " + moneda;
    }

    private static String convertirEntero(long n) {
        if (n == 0) return "";
        if (n == 100) return "CIEN";

        if (n < 30) return UNIDADES[(int) n];
        if (n < 100) {
            int d = (int) (n / 10);
            int u = (int) (n % 10);
            return u == 0 ? DECENAS[d] : DECENAS[d] + " Y " + UNIDADES[u];
        }
        if (n < 1000) {
            int c = (int) (n / 100);
            long resto = n % 100;
            if (resto == 0) return n == 100 ? "CIEN" : CENTENAS[c];
            return CENTENAS[c] + " " + convertirEntero(resto);
        }
        if (n < 1_000_000) {
            long miles = n / 1000;
            long resto = n % 1000;
            String prefix = miles == 1 ? "MIL" : convertirEntero(miles) + " MIL";
            return resto == 0 ? prefix : prefix + " " + convertirEntero(resto);
        }
        if (n < 1_000_000_000_000L) {
            long millones = n / 1_000_000;
            long resto = n % 1_000_000;
            String prefix = millones == 1 ? "UN MILLON" : convertirEntero(millones) + " MILLONES";
            return resto == 0 ? prefix : prefix + " " + convertirEntero(resto);
        }
        return String.valueOf(n);
    }
}
