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
        h.tvCodigo.setText(texto(d.codigo));
        h.tvTalla.setText(texto(d.talla));
        String alm = d.almacenCodigo != null && !d.almacenCodigo.isBlank()
                ? d.almacenCodigo
                : d.almacenNombre;
        h.tvAlmacen.setText(texto(alm));
        BigDecimal c = d.cantidad != null ? d.cantidad : BigDecimal.ZERO;
        h.tvCantidad.setText(qty.format(c));
    }

    private static String texto(String v) {
        return v != null && !v.isBlank() ? v.trim() : "—";
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    static class VH extends RecyclerView.ViewHolder {
        final TextView tvCodigo;
        final TextView tvTalla;
        final TextView tvAlmacen;
        final TextView tvCantidad;

        VH(@NonNull View itemView) {
            super(itemView);
            tvCodigo = itemView.findViewById(R.id.tvCodigo);
            tvTalla = itemView.findViewById(R.id.tvTalla);
            tvAlmacen = itemView.findViewById(R.id.tvAlmacen);
            tvCantidad = itemView.findViewById(R.id.tvCantidad);
        }
    }
}
