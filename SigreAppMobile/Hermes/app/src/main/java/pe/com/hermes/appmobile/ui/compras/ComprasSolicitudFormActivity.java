package pe.com.hermes.appmobile.ui.compras;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import com.google.android.material.button.MaterialButton;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.SolicitudDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.SolicitudLineaRequest;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.SolicitudLineaResponse;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.SolicitudRequest;
import pe.com.hermes.appmobile.data.repository.ComprasRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityAlmacenFormBinding;
import pe.com.hermes.appmobile.util.AppUtils;

public class ComprasSolicitudFormActivity extends AppCompatActivity {

    public static final String EXTRA_ID = "id";

    private ActivityAlmacenFormBinding binding;
    private ComprasRepository repository;
    private long id;
    private TextInputEditText etFecha;
    private TextInputEditText etPrioridad;
    private TextInputEditText etJustificacion;
    private LinearLayout lineasContainer;
    private final List<LineaViews> lineas = new ArrayList<>();

    public static Intent intent(Context ctx, long id) {
        return new Intent(ctx, ComprasSolicitudFormActivity.class).putExtra(EXTRA_ID, id);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityAlmacenFormBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());
        id = getIntent().getLongExtra(EXTRA_ID, 0L);
        binding.toolbar.setTitle(id > 0 ? "Editar solicitud" : "Nueva solicitud");
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());
        repository = new ComprasRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());

        LinearLayout c = binding.formContainer;
        etFecha = addField(c, "Fecha (yyyy-MM-dd)", InputType.TYPE_CLASS_TEXT, LocalDate.now().toString());
        etPrioridad = addField(c, "Prioridad (NORMAL/ALTA/...)", InputType.TYPE_CLASS_TEXT, "NORMAL");
        etJustificacion = addField(c, "Justificación", InputType.TYPE_CLASS_TEXT, "");

        TextView tv = new TextView(this);
        tv.setText(R.string.compras_lineas);
        tv.setTextSize(16f);
        tv.setPadding(0, 16, 0, 8);
        c.addView(tv);
        lineasContainer = new LinearLayout(this);
        lineasContainer.setOrientation(LinearLayout.VERTICAL);
        c.addView(lineasContainer);
        MaterialButton add = new MaterialButton(this, null,
                com.google.android.material.R.attr.materialButtonOutlinedStyle);
        add.setText(R.string.compras_agregar_linea);
        add.setOnClickListener(v -> addLinea(null, null, null, null));
        c.addView(add);
        addLinea(null, null, null, null);

        binding.btnGuardar.setOnClickListener(v -> guardar());
        if (id > 0) cargar();
    }

    private void cargar() {
        binding.progressBar.setVisibility(View.VISIBLE);
        repository.obtenerSolicitud(id, new ResultCallback<>() {
            @Override
            public void onSuccess(SolicitudDetalleResponse d) {
                binding.progressBar.setVisibility(View.GONE);
                etFecha.setText(d.fecha != null ? d.fecha : "");
                etPrioridad.setText(d.prioridad != null ? d.prioridad : "");
                etJustificacion.setText(d.justificacion != null ? d.justificacion : "");
                lineas.clear();
                lineasContainer.removeAllViews();
                if (d.lineas == null || d.lineas.isEmpty()) addLinea(null, null, null, null);
                else for (SolicitudLineaResponse l : d.lineas) {
                    addLinea(l.articuloId, l.almacenId, l.cantidad, l.especificaciones);
                }
            }

            @Override
            public void onError(String mensaje) {
                binding.progressBar.setVisibility(View.GONE);
                AppUtils.toast(ComprasSolicitudFormActivity.this, mensaje);
            }
        });
    }

    private void addLinea(Long articuloId, Long almacenId, BigDecimal cant, String esp) {
        LineaViews lv = new LineaViews();
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.VERTICAL);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = 12;
        row.setLayoutParams(lp);
        lv.articuloId = addField(row, "Artículo ID", InputType.TYPE_CLASS_NUMBER,
                articuloId != null ? String.valueOf(articuloId) : "");
        lv.almacenId = addField(row, "Almacén ID (opc.)", InputType.TYPE_CLASS_NUMBER,
                almacenId != null ? String.valueOf(almacenId) : "");
        lv.cantidad = addField(row, "Cantidad",
                InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL,
                cant != null ? cant.toPlainString() : "");
        lv.especificaciones = addField(row, "Especificaciones", InputType.TYPE_CLASS_TEXT,
                esp != null ? esp : "");
        lineasContainer.addView(row);
        lineas.add(lv);
    }

    private void guardar() {
        try {
            SolicitudRequest r = new SolicitudRequest();
            r.sucursalId = AppUtils.app(this).getSession().getSucursalId();
            r.fecha = text(etFecha);
            r.prioridad = text(etPrioridad);
            r.justificacion = text(etJustificacion);
            r.lineas = new ArrayList<>();
            for (LineaViews lv : lineas) {
                SolicitudLineaRequest l = new SolicitudLineaRequest();
                l.articuloId = parseLong(lv.articuloId, "Artículo");
                String alm = text(lv.almacenId);
                l.almacenId = alm.isEmpty() ? null : Long.parseLong(alm);
                l.cantidad = new BigDecimal(text(lv.cantidad));
                if (l.cantidad.compareTo(BigDecimal.ZERO) <= 0) {
                    throw new IllegalArgumentException("Cantidad inválida");
                }
                l.especificaciones = text(lv.especificaciones);
                r.lineas.add(l);
            }
            if (r.lineas.isEmpty()) throw new IllegalArgumentException("Agregue al menos una línea");
            binding.progressBar.setVisibility(View.VISIBLE);
            binding.btnGuardar.setEnabled(false);
            repository.guardarSolicitud(id, r, new ResultCallback<>() {
                @Override
                public void onSuccess(SolicitudDetalleResponse data) {
                    binding.progressBar.setVisibility(View.GONE);
                    AppUtils.toast(ComprasSolicitudFormActivity.this, getString(R.string.compras_guardado_ok));
                    setResult(RESULT_OK);
                    finish();
                }

                @Override
                public void onError(String mensaje) {
                    binding.progressBar.setVisibility(View.GONE);
                    binding.btnGuardar.setEnabled(true);
                    AppUtils.toast(ComprasSolicitudFormActivity.this, mensaje);
                }
            });
        } catch (Exception e) {
            AppUtils.toast(this, e.getMessage() != null ? e.getMessage() : "Datos inválidos");
        }
    }

    private TextInputEditText addField(LinearLayout parent, String hint, int type, String value) {
        TextInputLayout til = new TextInputLayout(this, null,
                com.google.android.material.R.attr.textInputOutlinedStyle);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = 10;
        til.setLayoutParams(lp);
        til.setHint(hint);
        TextInputEditText et = new TextInputEditText(til.getContext());
        et.setInputType(type);
        if (value != null) et.setText(value);
        til.addView(et);
        parent.addView(til);
        return et;
    }

    private static String text(TextInputEditText et) {
        return et != null && et.getText() != null ? et.getText().toString().trim() : "";
    }

    private static long parseLong(TextInputEditText et, String label) {
        try {
            long v = Long.parseLong(text(et));
            if (v <= 0) throw new IllegalArgumentException();
            return v;
        } catch (Exception e) {
            throw new IllegalArgumentException(label + " inválido");
        }
    }

    private static final class LineaViews {
        TextInputEditText articuloId;
        TextInputEditText almacenId;
        TextInputEditText cantidad;
        TextInputEditText especificaciones;
    }
}
