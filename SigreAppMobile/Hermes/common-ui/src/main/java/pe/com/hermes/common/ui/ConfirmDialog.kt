package pe.com.hermes.common.ui

import android.content.Context
import com.google.android.material.dialog.MaterialAlertDialogBuilder

/**
 * Diálogo Sí/No genérico — equivalente moderno de ConfirmDialog.java de FastSales
 * (que usaba una interfaz `Action` con métodos vacíos por defecto), reescrito con
 * lambdas de Kotlin y MaterialAlertDialogBuilder en vez de AlertDialog.Builder puro.
 */
object ConfirmDialog {

    fun mostrar(
        context: Context,
        mensaje: String,
        titulo: String? = null,
        textoSi: String = "Sí",
        textoNo: String = "Cancelar",
        cancelable: Boolean = true,
        onSi: () -> Unit,
        onNo: (() -> Unit)? = null,
    ) {
        val builder = MaterialAlertDialogBuilder(context)
            .setMessage(mensaje)
            .setCancelable(cancelable)
            .setPositiveButton(textoSi) { dialog, _ -> dialog.dismiss(); onSi() }
            .setNegativeButton(textoNo) { dialog, _ -> dialog.dismiss(); onNo?.invoke() }

        if (!titulo.isNullOrBlank()) builder.setTitle(titulo)
        builder.show()
    }
}
