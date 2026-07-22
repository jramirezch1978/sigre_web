package pe.com.sytco.fastsales.util;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import java.util.Locale;

/**
 * Detecta si el equipo parece un PDA / terminal con lector de códigos incorporado.
 * En teléfono, tablet o emulador típico retorna false → usar cámara.
 */
public final class BarcodeHardwareHelper {

    /** Fabricantes habituales de PDA / industrial scanners. */
    private static final String[] PDA_MANUFACTURERS = {
            "zebra", "motorola", "symbol", "honeywell", "intermec",
            "datalogic", "pointmobile", "point mobile", "unitech",
            "cipherlab", "newland", "urovo", "chainway", "idata",
            "seuic", "bluebird", "janam", "casio", "opticon",
            "m3mobile", "m3 mobile", "atid", "denso", "koamtac",
            "memtec", "ruggon", "getac", "panasonic",
            "advantech", "emdoor", "sunmi"
    };

    /** Modelos / familias típicas (Zebra TC/MC, Honeywell EDA, etc.). */
    private static final String[] PDA_MODEL_HINTS = {
            "tc20", "tc21", "tc25", "tc26", "tc51", "tc52", "tc55", "tc56",
            "tc57", "tc70", "tc72", "tc75", "tc77", "tc8000", "tc8300",
            "mc32", "mc33", "mc36", "mc40", "mc67", "mc92", "mc93",
            "wt6000", "wt6300", "et50", "et51", "et55", "et56",
            "eda50", "eda51", "eda52", "eda56", "eda57", "ct40", "ct60",
            "ck65", "cn51", "cn80", "dolphin", "memor", "falcon",
            "skorpio", "joya", "pm66", "pm67", "pm84", "pm90",
            "ht580", "ht-580", "c70", "c71", "i6300", "rt40"
    };

    private BarcodeHardwareHelper() {
    }

    public static boolean hasBuiltInBarcodeReader(Context context) {
        if (matchesPdaFingerprint()) {
            return true;
        }
        if (context != null && declaresBarcodeFeature(context)) {
            return true;
        }
        // Emuladores / teléfonos: no asumir lector por teclado USB genérico.
        return false;
    }

    private static boolean matchesPdaFingerprint() {
        String blob = (safe(Build.MANUFACTURER) + " "
                + safe(Build.BRAND) + " "
                + safe(Build.MODEL) + " "
                + safe(Build.DEVICE) + " "
                + safe(Build.PRODUCT) + " "
                + safe(Build.HARDWARE)).toLowerCase(Locale.US);

        for (String maker : PDA_MANUFACTURERS) {
            if (blob.contains(maker)) {
                return true;
            }
        }
        for (String hint : PDA_MODEL_HINTS) {
            if (blob.contains(hint)) {
                return true;
            }
        }
        return false;
    }

    private static boolean declaresBarcodeFeature(Context context) {
        PackageManager pm = context.getPackageManager();
        String[] features = {
                "android.hardware.barcode",
                "android.hardware.barcode_scanner",
                "com.honeywell.barcode",
                "com.symbol.emdk",
                "com.zebra.emdk",
                "com.datalogic.device"
        };
        for (String feature : features) {
            try {
                if (pm.hasSystemFeature(feature)) {
                    return true;
                }
            } catch (Exception ignored) {
                // Feature name desconocido en algunos API levels
            }
        }
        return false;
    }

    private static String safe(String value) {
        return value != null ? value : "";
    }
}
