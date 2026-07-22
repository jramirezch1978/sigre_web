package pe.com.sytco.fastsales.util;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.ContextWrapper;
import android.os.Build;

/**
 * Creación/cierre seguro de ProgressDialog (evita leaks y NPE).
 */
public final class SafeProgress {

    private SafeProgress() {
    }

    public static ProgressDialog show(Context context, String message) {
        ProgressDialog dialog = new ProgressDialog(context);
        dialog.setMessage(message);
        dialog.setIndeterminate(false);
        dialog.setCancelable(false);
        dialog.show();
        return dialog;
    }

    public static void dismiss(ProgressDialog dialog) {
        if (dialog == null || !dialog.isShowing()) {
            return;
        }
        try {
            Context context = dialog.getContext();
            if (context instanceof ContextWrapper) {
                context = ((ContextWrapper) context).getBaseContext();
            }
            if (context instanceof Activity) {
                Activity activity = (Activity) context;
                if (activity.isFinishing()) {
                    return;
                }
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1 && activity.isDestroyed()) {
                    return;
                }
            }
            dialog.dismiss();
        } catch (Exception ignored) {
        }
    }
}
