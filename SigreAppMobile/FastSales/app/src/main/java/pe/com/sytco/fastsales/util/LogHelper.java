package pe.com.sytco.fastsales.util;

import android.util.Log;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

/**
 * Utilidad para logging con timestamps en zona horaria de Lima (GMT-5)
 */
public class LogHelper {
    
    private static final String TAG_PREFIX = "[MOBILE]";
    private static final SimpleDateFormat sdf;
    
    static {
        sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.US);
        sdf.setTimeZone(TimeZone.getTimeZone("America/Lima"));
    }
    
    /**
     * Obtiene el timestamp actual en formato string con zona horaria Lima
     */
    public static String getTimestamp() {
        return sdf.format(new Date());
    }
    
    /**
     * Obtiene el timestamp actual en milisegundos
     */
    public static long getTimestampMillis() {
        return System.currentTimeMillis();
    }
    
    /**
     * Log con timestamp de Lima - Nivel INFO
     */
    public static void i(String tag, String message) {
        String fullMessage = String.format("[%s] %s %s: %s", 
                getTimestamp(), TAG_PREFIX, tag, message);
        Log.i(tag, fullMessage);
        System.out.println(fullMessage);
    }
    
    /**
     * Log con timestamp de Lima - Nivel DEBUG
     */
    public static void d(String tag, String message) {
        String fullMessage = String.format("[%s] %s %s: %s", 
                getTimestamp(), TAG_PREFIX, tag, message);
        Log.d(tag, fullMessage);
        System.out.println(fullMessage);
    }
    
    /**
     * Log con timestamp de Lima - Nivel ERROR
     */
    public static void e(String tag, String message) {
        String fullMessage = String.format("[%s] %s %s: %s", 
                getTimestamp(), TAG_PREFIX, tag, message);
        Log.e(tag, fullMessage);
        System.err.println(fullMessage);
    }
    
    /**
     * Log con timestamp de Lima y excepción - Nivel ERROR
     */
    public static void e(String tag, String message, Throwable throwable) {
        String fullMessage = String.format("[%s] %s %s: %s", 
                getTimestamp(), TAG_PREFIX, tag, message);
        Log.e(tag, fullMessage, throwable);
        System.err.println(fullMessage);
        if (throwable != null) {
            throwable.printStackTrace();
        }
    }
    
    /**
     * Log de inicio de método con timestamp
     */
    public static void logMethodStart(String tag, String methodName) {
        i(tag, ">>> INICIO " + methodName);
    }
    
    /**
     * Log de fin de método con timestamp y duración
     */
    public static void logMethodEnd(String tag, String methodName, long startTimeMillis) {
        long duration = System.currentTimeMillis() - startTimeMillis;
        i(tag, "<<< FIN " + methodName + " | Duración: " + duration + "ms");
    }
    
    /**
     * Log de checkpoint con timestamp y tiempo transcurrido
     */
    public static void logCheckpoint(String tag, String checkpointName, long startTimeMillis) {
        long elapsed = System.currentTimeMillis() - startTimeMillis;
        i(tag, "    [CHECKPOINT] " + checkpointName + " | Transcurrido: " + elapsed + "ms");
    }
}

