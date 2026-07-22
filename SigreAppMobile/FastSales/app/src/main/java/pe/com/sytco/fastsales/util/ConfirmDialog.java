package pe.com.sytco.fastsales.util;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;

/**
 * Diálogos Sí/No reutilizables (Template Method ligero).
 */
public final class ConfirmDialog {

    public interface Action {
        void run();
    }

    private ConfirmDialog() {
    }

    public static void ask(Context context, String title, String message,
                           final Action onYes) {
        ask(context, title, message, "Sí", "No", onYes, null);
    }

    public static void ask(Context context, String title, String message,
                           final Action onYes, final Action onNo) {
        ask(context, title, message, "Sí", "No", onYes, onNo);
    }

    public static void ask(Context context, String title, String message,
                           String yesLabel, String noLabel,
                           final Action onYes, final Action onNo) {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        builder.setTitle(title);
        builder.setMessage(message);
        builder.setCancelable(false);
        builder.setPositiveButton(yesLabel, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                if (onYes != null) {
                    onYes.run();
                }
            }
        });
        builder.setNegativeButton(noLabel, new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                if (onNo != null) {
                    onNo.run();
                }
            }
        });
        builder.show();
    }
}
