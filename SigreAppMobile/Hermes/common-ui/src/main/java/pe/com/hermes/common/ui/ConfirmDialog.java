package pe.com.hermes.common.ui;

import android.content.Context;
import com.google.android.material.dialog.MaterialAlertDialogBuilder;

/**
 * Dialogo Si/No generico — equivalente moderno de ConfirmDialog.java de FastSales.
 */
public final class ConfirmDialog {

    public interface OnAccion {
        void run();
    }

    private ConfirmDialog() {
    }

    public static void mostrar(Context context, String titulo, String mensaje, String textoSi, String textoNo,
                                boolean cancelable, OnAccion onSi, OnAccion onNo) {
        MaterialAlertDialogBuilder builder = new MaterialAlertDialogBuilder(context)
                .setMessage(mensaje)
                .setCancelable(cancelable)
                .setPositiveButton(textoSi, (dialog, which) -> {
                    dialog.dismiss();
                    if (onSi != null) onSi.run();
                })
                .setNegativeButton(textoNo, (dialog, which) -> {
                    dialog.dismiss();
                    if (onNo != null) onNo.run();
                });
        if (titulo != null && !titulo.trim().isEmpty()) builder.setTitle(titulo);
        builder.show();
    }

    public static void mostrar(Context context, String titulo, String mensaje, boolean cancelable, OnAccion onSi) {
        mostrar(context, titulo, mensaje, "Sí", "Cancelar", cancelable, onSi, null);
    }
}
