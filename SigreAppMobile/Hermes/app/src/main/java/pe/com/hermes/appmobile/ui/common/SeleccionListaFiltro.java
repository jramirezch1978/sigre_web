package pe.com.hermes.appmobile.ui.common;

import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;
import java.text.Normalizer;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Locale;
import pe.com.hermes.appmobile.R;

/**
 * Buscador de modales de selección: filtra por título/subtítulo (código — descripción).
 * Reutilizado en login (empresa/sucursal) y formularios FK.
 */
public final class SeleccionListaFiltro {

    private final SeleccionOpcionAdapter adapter;
    private final EditText etBusqueda;
    private final View grupoVacio;
    private final TextView tvVacioMensaje;
    private final String mensajeSinResultados;
    private List<SimpleItem> todos = Collections.emptyList();
    private boolean cargando;
    private String mensajeVacioBase;

    private SeleccionListaFiltro(SeleccionOpcionAdapter adapter, EditText etBusqueda,
                                 View grupoVacio, TextView tvVacioMensaje, String mensajeSinResultados) {
        this.adapter = adapter;
        this.etBusqueda = etBusqueda;
        this.grupoVacio = grupoVacio;
        this.tvVacioMensaje = tvVacioMensaje;
        this.mensajeSinResultados = mensajeSinResultados != null
                ? mensajeSinResultados : "No hay coincidencias con la búsqueda";
    }

    public static SeleccionListaFiltro enlazar(View root, SeleccionOpcionAdapter adapter) {
        EditText et = root.findViewById(R.id.etBusquedaSeleccion);
        View grupoVacio = root.findViewById(R.id.tvVacioSeleccion);
        TextView tvVacio = root.findViewById(R.id.tvVacioMensaje);
        String sinResultados = root.getContext().getString(R.string.seleccion_sin_resultados);
        SeleccionListaFiltro filtro = new SeleccionListaFiltro(
                adapter, et, grupoVacio, tvVacio, sinResultados);
        if (et != null) {
            et.addTextChangedListener(new TextWatcher() {
                @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
                @Override public void onTextChanged(CharSequence s, int start, int before, int count) {}
                @Override
                public void afterTextChanged(Editable s) {
                    filtro.aplicarFiltro();
                }
            });
        }
        return filtro;
    }

    public void setCargando(boolean cargando) {
        this.cargando = cargando;
        if (etBusqueda != null) {
            etBusqueda.setEnabled(!cargando);
        }
        if (cargando) {
            adapter.actualizar(Collections.emptyList());
            if (grupoVacio != null) grupoVacio.setVisibility(View.GONE);
        }
    }

    public void setItems(List<SimpleItem> items) {
        setItems(items, null);
    }

    public void setItems(List<SimpleItem> items, String mensajeSiVacio) {
        this.todos = items != null ? new ArrayList<>(items) : new ArrayList<>();
        this.mensajeVacioBase = mensajeSiVacio;
        this.cargando = false;
        if (etBusqueda != null) {
            etBusqueda.setEnabled(true);
        }
        aplicarFiltro();
    }

    public void limpiarBusqueda() {
        if (etBusqueda != null && etBusqueda.getText() != null && etBusqueda.getText().length() > 0) {
            etBusqueda.setText("");
        } else {
            aplicarFiltro();
        }
    }

    public void mostrarError(String mensaje) {
        cargando = false;
        todos = Collections.emptyList();
        if (etBusqueda != null) {
            etBusqueda.setEnabled(true);
            etBusqueda.setText("");
        }
        adapter.actualizar(Collections.emptyList());
        if (grupoVacio != null) grupoVacio.setVisibility(View.VISIBLE);
        if (tvVacioMensaje != null) {
            tvVacioMensaje.setText(mensaje != null ? mensaje : "Error al cargar");
        }
    }

    private void aplicarFiltro() {
        if (cargando) return;
        String q = normalizar(etBusqueda != null && etBusqueda.getText() != null
                ? etBusqueda.getText().toString() : "");
        List<SimpleItem> filtrados;
        if (q.isEmpty()) {
            filtrados = todos;
        } else {
            filtrados = new ArrayList<>();
            for (SimpleItem item : todos) {
                if (coincide(item, q)) filtrados.add(item);
            }
        }
        adapter.actualizar(filtrados);
        boolean vacio = filtrados.isEmpty();
        if (grupoVacio != null) {
            grupoVacio.setVisibility(vacio ? View.VISIBLE : View.GONE);
        }
        if (vacio && tvVacioMensaje != null) {
            if (todos.isEmpty()) {
                tvVacioMensaje.setText(mensajeVacioBase != null
                        ? mensajeVacioBase : "No hay registros para seleccionar");
            } else {
                tvVacioMensaje.setText(mensajeSinResultados);
            }
        }
    }

    private static boolean coincide(SimpleItem item, String q) {
        if (item == null) return false;
        String t = normalizar(item.titulo);
        String s = normalizar(item.subtitulo);
        String id = String.valueOf(item.id);
        return t.contains(q) || s.contains(q) || id.contains(q);
    }

    private static String normalizar(String value) {
        if (value == null || value.isBlank()) return "";
        String n = Normalizer.normalize(value.trim().toLowerCase(Locale.ROOT), Normalizer.Form.NFD);
        return n.replaceAll("\\p{M}+", "");
    }
}
