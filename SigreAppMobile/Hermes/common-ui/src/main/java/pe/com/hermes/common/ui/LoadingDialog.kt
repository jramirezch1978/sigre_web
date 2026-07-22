package pe.com.hermes.common.ui

import android.app.Activity
import android.app.Dialog
import com.google.android.material.dialog.MaterialAlertDialogBuilder
import pe.com.hermes.common.databinding.DialogLoadingBinding

/**
 * Diálogo de carga (spinner + mensaje) con show/dismiss seguros — equivalente
 * moderno de SafeProgress.java de FastSales (que envolvía el hoy-deprecado
 * ProgressDialog) y del uso que le daba spots-dialog en las pantallas de
 * Compras. Verifica que la Activity no esté finishing/destroyed antes de
 * mostrar o cerrar, para evitar el WindowLeaked/IllegalArgumentException
 * clásico de mostrar un diálogo sobre una Activity ya cerrada.
 */
object LoadingDialog {

    fun mostrar(activity: Activity, mensaje: String = "Cargando…"): Dialog? {
        if (activity.isFinishing || activity.isDestroyed) return null
        val binding = DialogLoadingBinding.inflate(activity.layoutInflater)
        binding.tvMensaje.text = mensaje
        return MaterialAlertDialogBuilder(activity)
            .setView(binding.root)
            .setCancelable(false)
            .show()
    }

    fun cerrar(activity: Activity, dialog: Dialog?) {
        if (dialog == null) return
        if (activity.isFinishing || activity.isDestroyed) return
        if (dialog.isShowing) dialog.dismiss()
    }
}
