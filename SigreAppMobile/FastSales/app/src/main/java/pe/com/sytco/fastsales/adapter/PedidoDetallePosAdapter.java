package pe.com.sytco.fastsales.adapter;

import android.content.Context;
import android.graphics.Color;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageButton;
import android.widget.LinearLayout;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.PedidoUI;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProformaDet;
import pe.com.sytco.fastsales.util.UTIL;

/**
 * Adapter POS para el detalle del pedido en portrait (ListView).
 */
public class PedidoDetallePosAdapter extends BaseAdapter {

    public interface Actions {
        void onSelect(BeanProformaDet row, int position);

        void onEdit(BeanProformaDet row);

        void onDelete(BeanProformaDet row);
    }

    private final LayoutInflater inflater;
    private final List<BeanProformaDet> items = new ArrayList<>();
    private final Actions actions;

    public PedidoDetallePosAdapter(Context context, Actions actions) {
        this.inflater = LayoutInflater.from(context);
        this.actions = actions;
    }

    public void setItems(List<BeanProformaDet> detalle) {
        items.clear();
        if (detalle != null) {
            items.addAll(detalle);
        }
        notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return items.size();
    }

    @Override
    public BeanProformaDet getItem(int position) {
        return items.get(position);
    }

    @Override
    public long getItemId(int position) {
        BeanProformaDet row = items.get(position);
        return row.getNroItem() != null ? row.getNroItem() : position;
    }

    @Override
    public View getView(final int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = inflater.inflate(R.layout.item_pedido_detalle_pos, parent, false);
            holder = new ViewHolder(convertView);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        final BeanProformaDet row = getItem(position);
        boolean selected = row.isSelected();

        holder.root.setBackgroundColor(selected ? Color.parseColor("#E3F2FD") : Color.WHITE);
        holder.accent.setBackgroundColor(selected
                ? Color.parseColor("#0D47A1")
                : Color.parseColor("#1976D2"));

        String nro = row.getNroItem() != null ? String.valueOf(row.getNroItem()) : String.valueOf(position + 1);
        holder.tvNro.setText(nro);
        holder.tvDescripcion.setText(safe(row.getDescripcion()));

        String und = safe(row.getUnd());
        String almacen = safe(row.getAlmacen());
        holder.tvMeta.setText("Almacén: " + almacen + "  ·  Und: " + und);

        String cant = UTIL.ConvetToString(row.getCantidad(), "###,##0.00");
        String precio = UTIL.ConvetToString(row.getPrecioVta(), "###,##0.00");
        holder.tvCantidad.setText(cant + " " + und + "  ×  S/ " + precio);
        holder.tvSubTotal.setText("S/ " + UTIL.ConvetToString(row.getSubTotal(), "###,##0.00"));

        holder.tvExtra.setText(buildExtraLine(row));

        if (selected) {
            holder.ibSelect.setImageResource(R.drawable.flecha_derecha_icono);
        } else {
            holder.ibSelect.setImageResource(R.drawable.rombo);
        }

        holder.ibSelect.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (actions != null) {
                    actions.onSelect(row, position);
                }
            }
        });
        holder.ibEditar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (actions != null) {
                    actions.onEdit(row);
                }
            }
        });
        holder.ibEliminar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (actions != null) {
                    actions.onDelete(row);
                }
            }
        });
        holder.root.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (actions != null) {
                    actions.onSelect(row, position);
                }
            }
        });

        return convertView;
    }

    private static String buildExtraLine(BeanProformaDet row) {
        StringBuilder sb = new StringBuilder();
        sb.append(PedidoUI.formatAfectoIgv(row.getFlagAfectoIGV()));
        sb.append("  ·  IGV ").append(UTIL.ConvetToString(row.getPorcIGV(), "###,##0.00"))
                .append("% (S/ ").append(UTIL.ConvetToString(row.getIgv(), "###,##0.00")).append(")");

        String und2 = row.getUnd2() != null ? row.getUnd2().trim() : "";
        if (und2.length() > 0) {
            sb.append("  ·  2da: ")
                    .append(UTIL.ConvetToString(row.getCantidadUnd2(), "###,##0.00"))
                    .append(" ").append(und2);
        }

        String bolsa = "1".equals(row.getFlagBolsaPlastico()) ? "SI" : "NO";
        sb.append("  ·  Bolsa: ").append(bolsa);
        sb.append("  ·  ICBPER: S/ ").append(UTIL.ConvetToString(row.getICBPER(), "###,##0.00"));
        return sb.toString();
    }

    private static String safe(String value) {
        return value != null ? value : "";
    }

    private static final class ViewHolder {
        final LinearLayout root;
        final View accent;
        final TextView tvNro;
        final TextView tvDescripcion;
        final TextView tvMeta;
        final TextView tvCantidad;
        final TextView tvSubTotal;
        final TextView tvExtra;
        final ImageButton ibSelect;
        final ImageButton ibEditar;
        final ImageButton ibEliminar;

        ViewHolder(View view) {
            root = view.findViewById(R.id.llPedidoItemRoot);
            accent = view.findViewById(R.id.vAccent);
            tvNro = view.findViewById(R.id.tvItemNro);
            tvDescripcion = view.findViewById(R.id.tvItemDescripcion);
            tvMeta = view.findViewById(R.id.tvItemMeta);
            tvCantidad = view.findViewById(R.id.tvItemCantidad);
            tvSubTotal = view.findViewById(R.id.tvItemSubTotal);
            tvExtra = view.findViewById(R.id.tvItemExtra);
            ibSelect = view.findViewById(R.id.ibItemSelect);
            ibEditar = view.findViewById(R.id.ibItemEditar);
            ibEliminar = view.findViewById(R.id.ibItemEliminar);
        }
    }
}
