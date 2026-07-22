package pe.com.hermes.common.ui;

import android.app.Activity;
import android.app.Dialog;
import com.google.android.material.dialog.MaterialAlertDialogBuilder;
import pe.com.hermes.common.databinding.DialogLoadingBinding;

/**
 * Dialogo de carga (spinner + mensaje) con show/dismiss seguros — equivalente
 * moderno de SafeProgress.java de FastSales.
 */
public final class LoadingDialog {

    private LoadingDialog() {
    }

    public static Dialog mostrar(Activity activity, String mensaje) {
        if (activity.isFinishing() || activity.isDestroyed()) return null;
        DialogLoadingBinding binding = DialogLoadingBinding.inflate(activity.getLayoutInflater());
        binding.tvMensaje.setText(mensaje);
        return new MaterialAlertDialogBuilder(activity)
                .setView(binding.getRoot())
                .setCancelable(false)
                .show();
    }

    public static Dialog mostrar(Activity activity) {
        return mostrar(activity, "Cargando…");
    }

    public static void cerrar(Activity activity, Dialog dialog) {
        if (dialog == null) return;
        if (activity.isFinishing() || activity.isDestroyed()) return;
        if (dialog.isShowing()) dialog.dismiss();
    }
}
