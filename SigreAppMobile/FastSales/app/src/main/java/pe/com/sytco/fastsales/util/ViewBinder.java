package pe.com.sytco.fastsales.util;

import android.view.View;

/**
 * Binding seguro de vistas (evita NPE por IDs faltantes en layouts).
 */
public final class ViewBinder {

    private final View root;

    public ViewBinder(View root) {
        if (root == null) {
            throw new IllegalArgumentException("root requerido");
        }
        this.root = root;
    }

    @SuppressWarnings("unchecked")
    public <T extends View> T require(int id, String name) {
        View view = root.findViewById(id);
        if (view == null) {
            throw new IllegalStateException("Vista no encontrada en layout: " + name);
        }
        return (T) view;
    }

    public void onClick(View view, View.OnClickListener listener) {
        if (view != null && listener != null) {
            view.setOnClickListener(listener);
        }
    }
}
