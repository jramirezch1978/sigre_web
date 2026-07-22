package pe.com.hermes.common.util;

import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Build;
import java.util.Arrays;
import java.util.List;

/**
 * Heuristica de deteccion de hardware de escaner integrado (PDA) — equivalente
 * moderno de BarcodeHardwareHelper.java de FastSales.
 */
public final class BarcodeHardwareHelper {

    private static final List<String> FABRICANTES_PDA = Arrays.asList(
            "zebra", "honeywell", "datalogic", "urovo", "chainway", "newland", "cipherlab", "point mobile"
    );

    private BarcodeHardwareHelper() {
    }

    public static boolean tieneEscanerIntegrado(Context context) {
        String fabricante = Build.MANUFACTURER.toLowerCase();
        String modelo = Build.MODEL.toLowerCase();
        boolean esFabricantePda = false;
        for (String candidato : FABRICANTES_PDA) {
            if (fabricante.contains(candidato) || modelo.contains(candidato)) {
                esFabricantePda = true;
                break;
            }
        }
        boolean tieneCamara = context.getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY);
        return esFabricantePda && tieneCamara;
    }
}
