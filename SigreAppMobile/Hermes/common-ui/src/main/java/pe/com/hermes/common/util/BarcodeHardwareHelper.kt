package pe.com.hermes.common.util

import android.content.Context
import android.content.pm.PackageManager
import android.os.Build

/**
 * Heurística de detección de hardware de escáner integrado (PDA) — equivalente
 * moderno de BarcodeHardwareHelper.java de FastSales. Útil para decidir entre
 * un campo "wedge" (foco de teclado esperando al lector físico) o abrir cámara,
 * en pantallas de Almacén/Logística que corran también en PDAs Zebra/Honeywell/etc.
 */
object BarcodeHardwareHelper {

    private val FABRICANTES_PDA = listOf(
        "zebra", "honeywell", "datalogic", "urovo", "chainway", "newland", "cipherlab", "point mobile",
    )

    fun tieneEscanerIntegrado(context: Context): Boolean {
        val fabricante = Build.MANUFACTURER.lowercase()
        val modelo = Build.MODEL.lowercase()
        val esFabricantePda = FABRICANTES_PDA.any { fabricante.contains(it) || modelo.contains(it) }
        val tieneCamara = context.packageManager.hasSystemFeature(PackageManager.FEATURE_CAMERA_ANY)
        return esFabricantePda && tieneCamara
    }
}
