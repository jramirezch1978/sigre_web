package pe.com.hermes.appmobile.ui.common;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import pe.com.hermes.appmobile.databinding.ItemSimpleTextoBinding;

/** Adapter generico reutilizable para listas de seleccion (empresas, sucursales, opciones de menu). */
public class SimpleListAdapter extends RecyclerView.Adapter<SimpleListAdapter.VH> {

    public interface OnItemClick {
        void onClick(SimpleItem item);
    }

    private List<SimpleItem> items;
    private final OnItemClick onClick;

    public SimpleListAdapter(List<SimpleItem> items, OnItemClick onClick) {
        this.items = items != null ? items : Collections.emptyList();
        this.onClick = onClick;
    }

    public SimpleListAdapter(OnItemClick onClick) {
        this(new ArrayList<>(), onClick);
    }

    public void actualizar(List<SimpleItem> nuevos) {
        items = nuevos;
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public VH onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        ItemSimpleTextoBinding binding = ItemSimpleTextoBinding.inflate(LayoutInflater.from(parent.getContext()), parent, false);
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
        private final ItemSimpleTextoBinding binding;

        VH(ItemSimpleTextoBinding binding) {
            super(binding.getRoot());
            this.binding = binding;
        }

        void bind(SimpleItem item, OnItemClick onClick) {
            binding.tvTitulo.setText(item.titulo);
            binding.tvSubtitulo.setText(item.subtitulo != null ? item.subtitulo : "");
            binding.tvSubtitulo.setVisibility(
                    item.subtitulo == null || item.subtitulo.trim().isEmpty() ? View.GONE : View.VISIBLE
            );
            binding.getRoot().setOnClickListener(v -> onClick.onClick(item));
        }
    }
}
