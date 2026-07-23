package pe.com.hermes.appmobile.ui.menu;

import android.graphics.Typeface;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.List;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.menu.MenuNodo;

/** Adapter expandible del drawer (módulos → secciones → opciones). */
public class DrawerMenuAdapter extends RecyclerView.Adapter<DrawerMenuAdapter.VH> {

    public interface Listener {
        void onOpcionClick(MenuNodo nodo);
    }

    private final List<MenuNodo> roots;
    private final List<Row> visibles = new ArrayList<>();
    private final Listener listener;

    public DrawerMenuAdapter(List<MenuNodo> roots, Listener listener) {
        this.roots = roots != null ? roots : List.of();
        this.listener = listener;
        rebuild();
    }

    public void rebuild() {
        visibles.clear();
        for (MenuNodo root : roots) {
            addVisible(root, 0);
        }
        notifyDataSetChanged();
    }

    private void addVisible(MenuNodo n, int depth) {
        visibles.add(new Row(n, depth));
        if (!n.esHoja() && n.expandido) {
            for (MenuNodo h : n.hijos) {
                addVisible(h, depth + 1);
            }
        }
    }

    @NonNull
    @Override
    public VH onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.item_drawer_menu, parent, false);
        return new VH(v);
    }

    @Override
    public void onBindViewHolder(@NonNull VH h, int position) {
        Row row = visibles.get(position);
        MenuNodo n = row.nodo;
        h.tvNombre.setText(n.nombre);
        h.tvNombre.setPaddingRelative(dp(h.itemView, 12 + row.depth * 14), 0, 0, 0);

        boolean modulo = n.tipo == MenuNodo.Tipo.MODULO;
        boolean seccion = n.tipo == MenuNodo.Tipo.SECCION;
        h.tvNombre.setTypeface(null, modulo || seccion ? Typeface.BOLD : Typeface.NORMAL);
        h.tvNombre.setTextSize(modulo ? 15f : (seccion ? 13.5f : 13f));

        if (!n.esHoja()) {
            h.ivExpand.setVisibility(View.VISIBLE);
            h.ivExpand.setRotation(n.expandido ? 90f : 0f);
        } else {
            h.ivExpand.setVisibility(View.GONE);
        }

        h.itemView.setOnClickListener(v -> {
            if (!n.esHoja()) {
                n.expandido = !n.expandido;
                rebuild();
            } else if (listener != null) {
                listener.onOpcionClick(n);
            }
        });
    }

    @Override
    public int getItemCount() {
        return visibles.size();
    }

    static class VH extends RecyclerView.ViewHolder {
        final TextView tvNombre;
        final ImageView ivExpand;

        VH(@NonNull View itemView) {
            super(itemView);
            tvNombre = itemView.findViewById(R.id.tvNombre);
            ivExpand = itemView.findViewById(R.id.ivExpand);
        }
    }

    private record Row(MenuNodo nodo, int depth) {
    }

    private static int dp(View v, int value) {
        return Math.round(value * v.getResources().getDisplayMetrics().density);
    }
}
