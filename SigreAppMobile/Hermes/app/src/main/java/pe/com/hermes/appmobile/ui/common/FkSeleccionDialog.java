package pe.com.hermes.appmobile.ui.common;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.View;
import android.view.Window;
import android.widget.ProgressBar;
import android.widget.TextView;
import androidx.appcompat.app.AlertDialog;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import java.util.Collections;
import java.util.List;
import java.util.function.Consumer;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.repository.ResultCallback;

/** Modal reutilizable: lista código — descripción (mismo look que empresa/sucursal). */
public final class FkSeleccionDialog {

    public interface Loader {
        void load(ResultCallback<List<SimpleItem>> callback);
    }

    private FkSeleccionDialog() {}

    public static void mostrar(Activity activity, String titulo, String ayuda,
                               Loader loader, Consumer<SimpleItem> onSelect) {
        if (activity == null || activity.isFinishing()) return;

        View view = activity.getLayoutInflater().inflate(R.layout.dialog_seleccion_lista, null);
        TextView tvTitulo = view.findViewById(R.id.tvTituloDialog);
        TextView tvSubtitulo = view.findViewById(R.id.tvSubtituloDialog);
        TextView tvPaso = view.findViewById(R.id.tvPasoDialog);
        ProgressBar progress = view.findViewById(R.id.progressSeleccion);
        View grupoVacio = view.findViewById(R.id.tvVacioSeleccion);
        TextView tvVacioMensaje = view.findViewById(R.id.tvVacioMensaje);
        RecyclerView recycler = view.findViewById(R.id.recyclerSeleccion);

        tvTitulo.setText(titulo != null ? titulo : "Seleccionar");
        tvSubtitulo.setText(ayuda != null ? ayuda : "Elija un registro de la lista");
        if (tvPaso != null) {
            tvPaso.setVisibility(View.GONE);
        }

        AlertDialog dialog = new AlertDialog.Builder(activity, R.style.Theme_Hermes_DialogSeleccion)
                .setView(view)
                .setCancelable(true)
                .create();

        SeleccionOpcionAdapter adapter = new SeleccionOpcionAdapter(item -> {
            dialog.dismiss();
            if (onSelect != null) onSelect.accept(item);
        });
        recycler.setLayoutManager(new LinearLayoutManager(activity));
        recycler.setAdapter(adapter);

        view.findViewById(R.id.btnCancelarSeleccion).setOnClickListener(v -> dialog.dismiss());
        dialog.show();

        Window window = dialog.getWindow();
        if (window != null) {
            window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            int ancho = (int) (activity.getResources().getDisplayMetrics().widthPixels * 0.92f);
            window.setLayout(ancho, android.view.ViewGroup.LayoutParams.WRAP_CONTENT);
        }

        progress.setVisibility(View.VISIBLE);
        grupoVacio.setVisibility(View.GONE);
        adapter.actualizar(Collections.emptyList());

        loader.load(new ResultCallback<>() {
            @Override
            public void onSuccess(List<SimpleItem> data) {
                if (!dialog.isShowing()) return;
                progress.setVisibility(View.GONE);
                List<SimpleItem> items = data != null ? data : Collections.emptyList();
                adapter.actualizar(items);
                boolean vacio = items.isEmpty();
                grupoVacio.setVisibility(vacio ? View.VISIBLE : View.GONE);
                if (vacio && tvVacioMensaje != null) {
                    tvVacioMensaje.setText("No hay registros para seleccionar");
                }
            }

            @Override
            public void onError(String mensaje) {
                if (!dialog.isShowing()) return;
                progress.setVisibility(View.GONE);
                adapter.actualizar(Collections.emptyList());
                grupoVacio.setVisibility(View.VISIBLE);
                if (tvVacioMensaje != null) {
                    tvVacioMensaje.setText(mensaje != null ? mensaje : "Error al cargar");
                }
            }
        });
    }
}
