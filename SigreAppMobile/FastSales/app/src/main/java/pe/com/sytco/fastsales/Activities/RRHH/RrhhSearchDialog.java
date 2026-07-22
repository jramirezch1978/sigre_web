package pe.com.sytco.fastsales.Activities.RRHH;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;
import android.util.DisplayMetrics;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.inputmethod.EditorInfo;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.adapter.ListViewSearchAdapter;
import pe.com.sytco.fastsales.beans.BeanItemSearch;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class RrhhSearchDialog<T> {

    public interface DataLoader<T> {
        List<T> load(String filter) throws Exception;
    }

    public interface OnSelectedListener<T> {
        void onSelected(T item);
    }

    private final Context context;
    private final String title;
    private final DataLoader<T> loader;
    private final OnSelectedListener<T> listener;
    private final ItemMapper<T> mapper;
    private final String emptyResultMessage;
    private final EmptyMessageProvider emptyMessageProvider;

    public interface EmptyMessageProvider {
        String buildMessage(String filtroActual);
    }

    private AlertDialog dialog;
    private EditText etBusqueda;
    private ListView lvListadoItems;
    private TextView tvListadoVacio;
    private List<T> currentItems = new ArrayList<T>();

    public interface ItemMapper<T> {
        List<BeanItemSearch> toSearchItems(List<T> items);
    }

    public RrhhSearchDialog(Context context, String title, DataLoader<T> loader,
            ItemMapper<T> mapper, OnSelectedListener<T> listener) {
        this(context, title, loader, mapper, listener, null);
    }

    public RrhhSearchDialog(Context context, String title, DataLoader<T> loader,
            ItemMapper<T> mapper, OnSelectedListener<T> listener, String emptyResultMessage) {
        this(context, title, loader, mapper, listener, emptyResultMessage, null);
    }

    public RrhhSearchDialog(Context context, String title, DataLoader<T> loader,
            ItemMapper<T> mapper, OnSelectedListener<T> listener, String emptyResultMessage,
            EmptyMessageProvider emptyMessageProvider) {
        this.context = context;
        this.title = title;
        this.loader = loader;
        this.mapper = mapper;
        this.listener = listener;
        this.emptyResultMessage = emptyResultMessage;
        this.emptyMessageProvider = emptyMessageProvider;
    }

    public void show() {
        show("");
    }

    public void show(String initialFilter) {
        AlertDialog.Builder builder = new AlertDialog.Builder(context);
        LayoutInflater inflater = ((Activity) context).getLayoutInflater();
        View dialogLayout = inflater.inflate(R.layout.dialog_search, null);

        TextView tvTitle = dialogLayout.findViewById(R.id.tvTitle);
        etBusqueda = dialogLayout.findViewById(R.id.etBusqueda);
        ImageButton ibtBuscar = dialogLayout.findViewById(R.id.ibtBuscar);
        Button btnCerrar = dialogLayout.findViewById(R.id.btnCerrar);
        lvListadoItems = dialogLayout.findViewById(R.id.lvListadoItems);
        tvListadoVacio = dialogLayout.findViewById(R.id.tvListadoVacio);
        if (lvListadoItems != null && tvListadoVacio != null) {
            lvListadoItems.setEmptyView(tvListadoVacio);
        }

        tvTitle.setText(title);
        etBusqueda.setText(initialFilter != null ? initialFilter : "");

        ibtBuscar.setOnClickListener(v -> filtrar());
        etBusqueda.setOnKeyListener((v, keyCode, event) -> {
            if (keyCode == EditorInfo.IME_ACTION_SEARCH
                    || keyCode == EditorInfo.IME_ACTION_DONE
                    || (event.getAction() == KeyEvent.ACTION_DOWN && keyCode == KeyEvent.KEYCODE_ENTER)) {
                filtrar();
            }
            return false;
        });

        lvListadoItems.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if (position >= 0 && position < currentItems.size()) {
                    listener.onSelected(currentItems.get(position));
                    dialog.dismiss();
                }
            }
        });

        btnCerrar.setOnClickListener(v -> dialog.dismiss());

        builder.setView(dialogLayout);
        builder.setCancelable(false);
        dialog = builder.create();
        dialog.show();
        ajustarTamanoDialogo();

        filtrar();
    }

    private void ajustarTamanoDialogo() {
        if (dialog == null) {
            return;
        }
        Window window = dialog.getWindow();
        if (window == null) {
            return;
        }
        DisplayMetrics metrics = context.getResources().getDisplayMetrics();
        int width = (int) (metrics.widthPixels * 0.95);
        int height = (int) (metrics.heightPixels * 0.82);
        window.setLayout(width, height);
    }

    private void filtrar() {
        final String filtro = etBusqueda.getText().toString().trim();
        new AsyncTask<Void, Void, Object[]>() {
            ProgressDialog pd;

            @Override
            protected void onPreExecute() {
                pd = ProgressDialog.show(context, "Espere", "Buscando...");
            }

            @Override
            protected Object[] doInBackground(Void... voids) {
                try {
                    List<T> result = loader.load(filtro);
                    return new Object[]{result, null};
                } catch (Exception e) {
                    return new Object[]{null, e.getMessage()};
                }
            }

            @Override
            protected void onPostExecute(Object[] data) {
                try {
                    pd.dismiss();
                } catch (Exception ignored) {
                }
                if (data[1] != null) {
                    MessageBox.AlertDialog(context, "Error", String.valueOf(data[1]), false);
                    return;
                }
                @SuppressWarnings("unchecked")
                List<T> result = (List<T>) data[0];
                if (result == null || result.isEmpty()) {
                    String msg;
                    if (emptyMessageProvider != null) {
                        msg = emptyMessageProvider.buildMessage(filtro);
                    } else if (emptyResultMessage != null && !emptyResultMessage.isEmpty()) {
                        msg = emptyResultMessage;
                    } else {
                        msg = "No se encontraron registros para la búsqueda indicada.";
                    }
                    if (tvListadoVacio != null) {
                        tvListadoVacio.setText(msg);
                    }
                    MessageBox.AlertDialog(context, "Sin resultados", msg, false);
                    currentItems = new ArrayList<T>();
                    lvListadoItems.setAdapter(new ArrayAdapter<String>(context,
                            android.R.layout.simple_list_item_1, new String[0]));
                    return;
                }
                try {
                    currentItems = result;
                    ArrayAdapter adaptador = new ListViewSearchAdapter(context, mapper.toSearchItems(result));
                    lvListadoItems.setAdapter(adaptador);
                    if (tvListadoVacio != null) {
                        tvListadoVacio.setVisibility(View.GONE);
                    }
                    etBusqueda.requestFocus();
                    UTIL.OcultarTeclado(context, etBusqueda);
                } catch (Exception ex) {
                    MessageBox.AlertDialog(context, "Error", ex.getMessage(), false);
                }
            }
        }.execute();
    }
}
