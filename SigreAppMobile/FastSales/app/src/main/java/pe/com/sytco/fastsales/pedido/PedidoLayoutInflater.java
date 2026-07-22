package pe.com.sytco.fastsales.pedido;

import android.content.Context;
import android.content.res.Configuration;
import android.util.DisplayMetrics;
import android.view.LayoutInflater;

/**
 * Elige layout portrait/land según el tamaño real de ventana
 * (útil cuando el emulador rota la ventana sin cambiar Configuration.orientation).
 */
public final class PedidoLayoutInflater {

    private PedidoLayoutInflater() {
    }

    public static boolean isLandscapeWindow(Context context) {
        DisplayMetrics dm = context.getResources().getDisplayMetrics();
        return dm.widthPixels > dm.heightPixels;
    }

    public static LayoutInflater forWindow(Context context) {
        boolean land = isLandscapeWindow(context);
        Configuration base = context.getResources().getConfiguration();
        Configuration cfg = new Configuration(base);
        cfg.orientation = land
                ? Configuration.ORIENTATION_LANDSCAPE
                : Configuration.ORIENTATION_PORTRAIT;
        Context oriented = context.createConfigurationContext(cfg);
        // createConfigurationContext() no copia el theme de la Activity: sin esto,
        // los drawables que referencian atributos de theme (?attr/...) fallan al
        // inflar (UnsupportedOperationException: Failed to resolve attribute).
        oriented.getTheme().setTo(context.getTheme());
        return LayoutInflater.from(oriented);
    }
}
