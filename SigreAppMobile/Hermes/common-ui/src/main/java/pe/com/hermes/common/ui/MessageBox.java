package pe.com.hermes.common.ui;

import android.content.Context;
import com.google.android.material.dialog.MaterialAlertDialogBuilder;
import pe.com.hermes.common.R;

/**
 * Alertas informativas con icono (info/exito/error) — equivalente moderno de
 * MessageBox.java de FastSales.
 */
public final class MessageBox {

    public enum Tipo { INFO, EXITO, ERROR }

    public interface OnAceptar {
        void run();
    }

    private MessageBox() {
    }

    public static void mostrar(Context context, String mensaje, String titulo, Tipo tipo, boolean cancelable, OnAceptar onAceptar) {
        int icono;
        switch (tipo) {
            case EXITO: icono = R.drawable.ic_check_circle; break;
            case ERROR: icono = R.drawable.ic_error_circle; break;
            default: icono = R.drawable.ic_info_circle; break;
        }
        new MaterialAlertDialogBuilder(context)
                .setTitle(titulo)
                .setMessage(mensaje)
                .setIcon(icono)
                .setCancelable(cancelable)
                .setPositiveButton("Aceptar", (dialog, which) -> {
                    dialog.dismiss();
                    if (onAceptar != null) onAceptar.run();
                })
                .show();
    }

    public static void exito(Context context, String mensaje) {
        mostrar(context, mensaje, "Éxito", Tipo.EXITO, false, null);
    }

    public static void exito(Context context, String mensaje, OnAceptar onAceptar) {
        mostrar(context, mensaje, "Éxito", Tipo.EXITO, false, onAceptar);
    }

    public static void error(Context context, String mensaje) {
        mostrar(context, mensaje, "Error", Tipo.ERROR, false, null);
    }

    public static void info(Context context, String mensaje, String titulo) {
        mostrar(context, mensaje, titulo, Tipo.INFO, false, null);
    }
}
