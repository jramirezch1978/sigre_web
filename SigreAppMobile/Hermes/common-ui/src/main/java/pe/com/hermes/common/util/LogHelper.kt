package pe.com.hermes.common.util

import android.util.Log
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import java.util.TimeZone

/**
 * Logging con timestamp en hora de Lima y prefijo [HERMES] — equivalente
 * moderno de LogHelper.java de FastSales, útil para correlacionar logs de
 * dispositivo con logs de servidor (ambos en la misma zona horaria).
 */
object LogHelper {

    private val formato = SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale("es", "PE")).apply {
        timeZone = TimeZone.getTimeZone("America/Lima")
    }

    private fun marca(): String = "[HERMES ${formato.format(Date())}]"

    fun i(tag: String, mensaje: String) = Log.i(tag, "${marca()} $mensaje")
    fun d(tag: String, mensaje: String) = Log.d(tag, "${marca()} $mensaje")
    fun w(tag: String, mensaje: String) = Log.w(tag, "${marca()} $mensaje")
    fun e(tag: String, mensaje: String, error: Throwable? = null) = Log.e(tag, "${marca()} $mensaje", error)
}
