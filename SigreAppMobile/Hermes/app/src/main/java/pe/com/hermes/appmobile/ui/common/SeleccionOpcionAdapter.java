package pe.com.hermes.appmobile.ui.common;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import pe.com.hermes.appmobile.databinding.ItemSeleccionOpcionBinding;

/** Lista de opciones para modales de selección (empresa / sucursal) en login. */
public class SeleccionOpcionAdapter extends RecyclerView.Adapter<SeleccionOpcionAdapter.VH> {

    public interface OnItemClick {
        void onClick(SimpleItem item);
    }

    private List<SimpleItem> items = Collections.emptyList();
    private final OnItemClick onClick;

    public SeleccionOpcionAdapter(OnItemClick onClick) {
        this.onClick = onClick;
    }

    public void actualizar(List<SimpleItem> nuevos) {
        items = nuevos != null ? nuevos : new ArrayList<>();
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public VH onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        ItemSeleccionOpcionBinding binding = ItemSeleccionOpcionBinding.inflate(
                LayoutInflater.from(parent.getContext()), parent, false);
        return new VH(binding);
    }

    @Override
    public void onBindViewHolder(@NonNull VH holder, int position) {
        holder.bind(items.get(position), onClick);
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    static final class VH extends RecyclerView.ViewHolder {
        private final ItemSeleccionOpcionBinding binding;

        VH(ItemSeleccionOpcionBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }

        void bind(SimpleItem item, OnItemClick onClick) {
            binding.tvTitulo.setText(item.titulo);
            boolean tieneSub = item.subtitulo != null && !item.subtitulo.trim().isEmpty();
            binding.tvSubtitulo.setVisibility(tieneSub ? View.VISIBLE : View.GONE);
            binding.tvSubtitulo.setText(tieneSub ? etiquetaSubtitulo(item.subtitulo) : "");
            binding.tvAvatar.setText(iniciales(item.titulo));
            binding.getRoot().setOnClickListener(v -> onClick.onClick(item));
        }

        private static String etiquetaSubtitulo(String valor) {
            String v = valor.trim();
            if (v.matches("\\d{8,11}")) {
                return "RUC " + v;
            }
            return v;
        }

        private static String iniciales(String titulo) {
            if (titulo == null || titulo.trim().isEmpty()) {
                return "?";
            }
            String[] partes = titulo.trim().split("\\s+");
            StringBuilder sb = new StringBuilder();
            for (String p : partes) {
                if (p.isEmpty()) {
                    continue;
                }
                char c = Character.toUpperCase(p.charAt(0));
                if (Character.isLetterOrDigit(c)) {
                    sb.append(c);
                }
                if (sb.length() >= 2) {
                    break;
                }
            }
            return sb.length() > 0 ? sb.toString() : "?";
        }
    }
}
