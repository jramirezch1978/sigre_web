package pe.com.sigre.logistica.ui.common

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import pe.com.sigre.logistica.databinding.ItemSimpleTextoBinding

/** Adapter genérico reutilizable para listas de selección (empresas, sucursales, opciones de menú). */
class SimpleListAdapter(
    private var items: List<SimpleItem> = emptyList(),
    private val onClick: (SimpleItem) -> Unit,
) : RecyclerView.Adapter<SimpleListAdapter.VH>() {

    fun actualizar(nuevos: List<SimpleItem>) {
        items = nuevos
        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): VH {
        val binding = ItemSimpleTextoBinding.inflate(LayoutInflater.from(parent.context), parent, false)
        return VH(binding)
    }

    override fun onBindViewHolder(holder: VH, position: Int) {
        holder.bind(items[position], onClick)
    }

    override fun getItemCount(): Int = items.size

    class VH(private val binding: ItemSimpleTextoBinding) : RecyclerView.ViewHolder(binding.root) {
        fun bind(item: SimpleItem, onClick: (SimpleItem) -> Unit) {
            binding.tvTitulo.text = item.titulo
            binding.tvSubtitulo.text = item.subtitulo.orEmpty()
            binding.tvSubtitulo.visibility = if (item.subtitulo.isNullOrBlank()) android.view.View.GONE else android.view.View.VISIBLE
            binding.root.setOnClickListener { onClick(item) }
        }
    }
}
