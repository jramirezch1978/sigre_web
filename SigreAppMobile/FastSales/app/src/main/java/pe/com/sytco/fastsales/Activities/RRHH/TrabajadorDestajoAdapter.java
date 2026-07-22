package pe.com.sytco.fastsales.Activities.RRHH;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.api.rrhh.dto.ParteDestajoDetalleDto;
import pe.com.sytco.fastsales.beans.Asistencia.BeanTrabajador;

public class TrabajadorDestajoAdapter extends BaseAdapter {

    private final List<ParteDestajoDetalleDto> items;
    private final Map<String, Double> cantidades = new HashMap<String, Double>();
    private final Map<String, BeanTrabajador> trabajadores = new HashMap<String, BeanTrabajador>();

    public TrabajadorDestajoAdapter(List<ParteDestajoDetalleDto> detalle) {
        this.items = detalle;
    }

    public void setTrabajadores(Map<String, BeanTrabajador> map) {
        trabajadores.clear();
        if (map != null) {
            trabajadores.putAll(map);
        }
        notifyDataSetChanged();
    }

    public void putTrabajador(BeanTrabajador bean) {
        if (bean != null && bean.getCodTrabajador() != null) {
            trabajadores.put(bean.getCodTrabajador(), bean);
            notifyDataSetChanged();
        }
    }

    public BeanTrabajador getTrabajador(String codTrabajador) {
        return trabajadores.get(codTrabajador);
    }

    public Map<String, BeanTrabajador> getTrabajadoresMap() {
        return trabajadores;
    }

    public Double getCantidad(String codTrabajador) {
        return cantidades.get(codTrabajador);
    }

    public double getTotalProduccion() {
        double total = 0;
        for (Double v : cantidades.values()) {
            if (v != null) {
                total += v;
            }
        }
        return total;
    }

    public void syncAllFromListView(ListView listView) {
        for (int i = 0; i < listView.getChildCount(); i++) {
            View row = listView.getChildAt(i);
            EditText et = row.findViewById(R.id.etCantidad);
            if (et != null) {
                guardarCantidad(et);
            }
        }
    }

    public boolean contieneTrabajador(String codTrabajador) {
        for (ParteDestajoDetalleDto item : items) {
            if (codTrabajador.equals(item.getCodTrabajador())) {
                return true;
            }
        }
        return false;
    }

    public void agregarDetalle(ParteDestajoDetalleDto detalle, BeanTrabajador bean) {
        items.add(detalle);
        if (bean != null) {
            trabajadores.put(detalle.getCodTrabajador(), bean);
        }
        notifyDataSetChanged();
    }

    @Override
    public int getCount() {
        return items.size();
    }

    @Override
    public Object getItem(int position) {
        return items.get(position);
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        ViewHolder holder;
        if (convertView == null) {
            convertView = LayoutInflater.from(parent.getContext())
                    .inflate(R.layout.item_trabajador_destajo, parent, false);
            holder = new ViewHolder();
            holder.ivFoto = convertView.findViewById(R.id.ivFotoTrabajador);
            holder.tvNombre = convertView.findViewById(R.id.tvNombre);
            holder.tvDni = convertView.findViewById(R.id.tvDni);
            holder.etCantidad = convertView.findViewById(R.id.etCantidad);
            convertView.setTag(holder);
        } else {
            holder = (ViewHolder) convertView.getTag();
        }

        final ParteDestajoDetalleDto item = items.get(position);
        holder.tvNombre.setText(item.getNomTrabajador());
        holder.etCantidad.setTag(item.getCodTrabajador());

        Double prev = cantidades.get(item.getCodTrabajador());
        holder.etCantidad.setText(prev != null && prev > 0 ? String.valueOf(prev) : "");

        BeanTrabajador bean = trabajadores.get(item.getCodTrabajador());
        if (bean != null) {
            holder.tvDni.setText(bean.getDocumentoIdentidad());
            cargarFoto(holder.ivFoto, bean);
        } else {
            holder.tvDni.setText("");
            holder.ivFoto.setImageResource(R.drawable.ic_user_placeholder);
        }

        holder.etCantidad.setOnFocusChangeListener((v, hasFocus) -> {
            if (!hasFocus) {
                guardarCantidad(holder.etCantidad);
            }
        });

        return convertView;
    }

    private void cargarFoto(ImageView imageView, BeanTrabajador bean) {
        if (bean.tieneFoto()) {
            Bitmap bitmap = BitmapFactory.decodeByteArray(bean.getFotoBlob(), 0, bean.getFotoBlob().length);
            if (bitmap != null) {
                imageView.setImageBitmap(bitmap);
                return;
            }
        }
        imageView.setImageResource(R.drawable.ic_user_placeholder);
    }

    private void guardarCantidad(EditText et) {
        String cod = (String) et.getTag();
        String txt = et.getText().toString().trim();
        if (txt.length() == 0) {
            cantidades.remove(cod);
            return;
        }
        try {
            cantidades.put(cod, Double.parseDouble(txt.replace(',', '.')));
        } catch (NumberFormatException ignored) {
        }
    }

    private static class ViewHolder {
        ImageView ivFoto;
        TextView tvNombre;
        TextView tvDni;
        EditText etCantidad;
    }
}
