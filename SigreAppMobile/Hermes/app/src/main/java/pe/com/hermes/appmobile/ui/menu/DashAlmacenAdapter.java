package pe.com.hermes.appmobile.ui.menu;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;
import androidx.annotation.NonNull;
import androidx.recyclerview.widget.RecyclerView;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.remote.dto.DashboardLogisticoResponse.DiagnosticoAlmacenDto;

public class DashAlmacenAdapter extends RecyclerView.Adapter<DashAlmacenAdapter.VH> {

    private final List<DiagnosticoAlmacenDto> items = new ArrayList<>();
    private BigDecimal max = BigDecimal.ONE;
    private final NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("es", "PE"));

    public void setItems(List<DiagnosticoAlmacenDto> data) {
        items.clear();
        if (data != null) {
            items.addAll(data);
        }
        max = BigDecimal.ONE;
        for (DiagnosticoAlmacenDto d : items) {
            BigDecimal v = d.valorInventario != null ? d.valorInventario : BigDecimal.ZERO;
            if (v.compareTo(max) > 0) {
                max = v;
            }
        }
        notifyDataSetChanged();
    }

    @NonNull
    @Override
    public VH onCreateViewHolder(@NonNull ViewGroup parent, int viewType) {
        return new VH(LayoutInflater.from(parent.getContext())
                .inflate(R.layout.item_dash_almacen_bar, parent, false));
    }

    @Override
    public void onBindViewHolder(@NonNull VH h, int position) {
        DiagnosticoAlmacenDto d = items.get(position);
        String nombre = d.almacenNombre != null ? d.almacenNombre : d.almacenCodigo;
        h.tvNombre.setText(nombre);
        BigDecimal valor = d.valorInventario != null ? d.valorInventario : BigDecimal.ZERO;
        h.tvValor.setText(money.format(valor));
        int pct = max.signum() == 0 ? 0
                : valor.multiply(BigDecimal.valueOf(100)).divide(max, 0, java.math.RoundingMode.HALF_UP).intValue();
        h.bar.setProgress(Math.max(0, Math.min(100, pct)));
    }

    @Override
    public int getItemCount() {
        return items.size();
    }

    static class VH extends RecyclerView.ViewHolder {
        final TextView tvNombre;
        final TextView tvValor;
        final ProgressBar bar;

        VH(@NonNull View itemView) {
            super(itemView);
            tvNombre = itemView.findViewById(R.id.tvNombre);
            tvValor = itemView.findViewById(R.id.tvValor);
            bar = itemView.findViewById(R.id.barValor);
        }
    }
}
