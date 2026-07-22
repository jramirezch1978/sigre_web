package pe.com.hermes.common.util;

import android.util.Log;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

/**
 * Logging con timestamp en hora de Lima y prefijo [HERMES] — equivalente
 * moderno de LogHelper.java de FastSales.
 */
public final class LogHelper {

    private static final SimpleDateFormat FORMATO = crearFormato();

    private LogHelper() {
    }

    private static SimpleDateFormat crearFormato() {
        SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", new Locale("es", "PE"));
        formato.setTimeZone(TimeZone.getTimeZone("America/Lima"));
        return formato;
    }

    private static String marca() {
        synchronized (FORMATO) {
            return "[HERMES " + FORMATO.format(new Date()) + "]";
        }
    }

    public static void i(String tag, String mensaje) { Log.i(tag, marca() + " " + mensaje); }
    public static void d(String tag, String mensaje) { Log.d(tag, marca() + " " + mensaje); }
    public static void w(String tag, String mensaje) { Log.w(tag, marca() + " " + mensaje); }
    public static void e(String tag, String mensaje) { Log.e(tag, marca() + " " + mensaje); }
    public static void e(String tag, String mensaje, Throwable error) { Log.e(tag, marca() + " " + mensaje, error); }
}
