package pe.com.hermes.common.ui

import android.content.Context
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import pe.com.hermes.common.R

/**
 * Alertas informativas con ícono (info/éxito/error) — equivalente moderno de
 * MessageBox.java de FastSales (que usaba `R.drawable.exito`/`R.drawable.fail`
 * propios de esa app). Aquí los íconos viven en esta misma librería, así que
 * cualquier app que la use los obtiene automáticamente.
 */
object MessageBox {

    enum class Tipo { INFO, EXITO, ERROR }

    fun mostrar(
        context: Context,
        mensaje: String,
        titulo: String? = null,
        tipo: Tipo = Tipo.INFO,
        cancelable: Boolean = false,
        onAceptar: (() -> Unit)? = null,
    ) {
        val icono = when (tipo) {
            Tipo.EXITO -> R.drawable.ic_check_circle
            Tipo.ERROR -> R.drawable.ic_error_circle
            Tipo.INFO -> R.drawable.ic_info_circle
        }
        MaterialAlertDialogBuilder(context)
            .setTitle(titulo)
            .setMessage(mensaje)
            .setIcon(icono)
            .setCancelable(cancelable)
            .setPositiveButton("Aceptar") { dialog, _ -> dialog.dismiss(); onAceptar?.invoke() }
            .show()
    }

    fun exito(context: Context, mensaje: String, titulo: String = "Éxito", onAceptar: (() -> Unit)? = null) =
        mostrar(context, mensaje, titulo, Tipo.EXITO, onAceptar = onAceptar)

    fun error(context: Context, mensaje: String, titulo: String = "Error", onAceptar: (() -> Unit)? = null) =
        mostrar(context, mensaje, titulo, Tipo.ERROR, onAceptar = onAceptar)

    fun info(context: Context, mensaje: String, titulo: String? = null, onAceptar: (() -> Unit)? = null) =
        mostrar(context, mensaje, titulo, Tipo.INFO, onAceptar = onAceptar)
}
