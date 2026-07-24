package pe.com.hermes.appmobile.ui.common;

import android.view.ViewGroup;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import pe.com.hermes.appmobile.R;

/**
 * Branding Hermes: listas continuas tipo ListView (sin huecos arriba/abajo entre registros).
 */
public final class HermesListUi {

    private HermesListUi() {}

    /** Aplica layout manager, sin decoraciones y sin animaciones que separen filas. */
    public static void aplicarListaContinua(RecyclerView recycler) {
        if (recycler == null) {
            return;
        }
        while (recycler.getItemDecorationCount() > 0) {
            recycler.removeItemDecorationAt(0);
        }
        recycler.setLayoutManager(new LinearLayoutManager(recycler.getContext()));
        recycler.setItemAnimator(null);
        recycler.setClipToPadding(false);
        recycler.setOverScrollMode(RecyclerView.OVER_SCROLL_IF_CONTENT_SCROLLS);
        recycler.setBackgroundResource(R.color.hermes_surface_elevated);
    }

    /** Anula márgenes verticales del item (defensa ante layouts legacy). */
    public static void anularMargenesVerticales(ViewGroup.LayoutParams lp) {
        if (lp instanceof ViewGroup.MarginLayoutParams mlp) {
            mlp.topMargin = 0;
            mlp.bottomMargin = 0;
        }
    }
}
