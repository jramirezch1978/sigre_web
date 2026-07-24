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

/**
 * Adapter de listados Hermes (branding): filas pegadas, sin separación vertical entre registros.
 */
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
        items = nuevos != null ? nuevos : Collections.emptyList();
        notifyDataSetChanged();
    }

    @Override
    public void onAttachedToRecyclerView(@NonNull RecyclerView recyclerView) {
        super.onAttachedToRecyclerView(recyclerView);
        HermesListUi.aplicarListaContinua(recyclerView);
    }

    @NonNull
    @Override
    public VH onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        ItemSimpleTextoBinding binding = ItemSimpleTextoBinding.inflate(
                LayoutInflater.from(parent.getContext()), parent, false);
        HermesListUi.anularMargenesVerticales(binding.getRoot().getLayoutParams());
        return new VH(binding);
    }

    @Override
    public void onBindViewHolder(@NonNull VH holder, int position) {
        HermesListUi.anularMargenesVerticales(holder.itemView.getLayoutParams());
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
