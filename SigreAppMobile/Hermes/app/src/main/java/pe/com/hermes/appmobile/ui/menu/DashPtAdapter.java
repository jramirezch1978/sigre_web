package pe.com.hermes.appmobile.ui.menu;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.remote.dto.DashboardLogisticoResponse.ProductoTerminadoStockDto;

public class DashPtAdapter extends RecyclerView.Adapter<DashPtAdapter.VH> {

    private final List<ProductoTerminadoStockDto> items = new ArrayList<>();
    private final DecimalFormat qty = new DecimalFormat("#,##0.###");

    public void setItems(List<ProductoTerminadoStockDto> data) {
        items.clear();
        if (data != null) {
            items.addAll(data);
        }
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public VH onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new VH(LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_dash_pt_row, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull VH h, int position) {
        ProductoTerminadoStockDto d = items.get(position);
        String grupo = d.grupo != null && !d.grupo.isBlank() ? d.grupo + " · " : "";
        h.tvProducto.setText(grupo + (d.nombre != null ? d.nombre : "—"));
        h.tvCodigo.setText(d.codigo != null ? d.codigo : "—");
        BigDecimal c = d.cantidad != null ? d.cantidad : BigDecimal.ZERO;
        h.tvCantidad.setText(qty.format(c));
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    static class VH extends RecyclerView.ViewHolder {
        final TextView tvProducto;
        final TextView tvCodigo;
        final TextView tvCantidad;

        VH(@NonNull View itemView) {
            super(itemView);
            tvProducto = itemView.findViewById(R.id.tvProducto);
            tvCodigo = itemView.findViewById(R.id.tvCodigo);
            tvCantidad = itemView.findViewById(R.id.tvCantidad);
        }
    }
}
