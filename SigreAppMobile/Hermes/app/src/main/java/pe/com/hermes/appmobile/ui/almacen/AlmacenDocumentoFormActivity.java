package pe.com.hermes.appmobile.ui.almacen;

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
import pe.com.hermes.appmobile.data.almacen.AlmacenFuenteDatos;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.InventarioConteoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MovimientoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MovimientoLineaResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.OrdenTrasladoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.OrdenTrasladoLineaResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.InventarioConteoRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.MovimientoCabeceraRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.MovimientoLineaRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.OrdenTrasladoLineaRequest;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenWriteDtos.OrdenTrasladoRequest;
import pe.com.hermes.appmobile.data.repository.AlmacenRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityAlmacenFormBinding;
import pe.com.hermes.appmobile.util.AppUtils;

/** Alta/edición de movimiento, OTR o toma de inventario. */
public class AlmacenDocumentoFormActivity extends AppCompatActivity {

    public static final String EXTRA_FUENTE = "fuente";
    public static final String EXTRA_ID = "id";

    private ActivityAlmacenFormBinding binding;
    private AlmacenRepository repository;
    private AlmacenFuenteDatos fuente;
    private long id;

    private TextInputEditText etAlmacenId;
    private TextInputEditText etTipoMovId;
    private TextInputEditText etFecha;
    private TextInputEditText etObs;
    private TextInputEditText etOrigenId;
    private TextInputEditText etDestinoId;
    private TextInputEditText etArticuloId;
    private TextInputEditText etSaldoSist;
    private TextInputEditText etConteo1;
    private TextInputEditText etConteo2;
    private final List<LineaViews> lineas = new ArrayList<>();
    private LinearLayout lineasContainer;

    public static Intent intent(Context ctx, AlmacenFuenteDatos fuente, long id) {
        return new Intent(ctx, AlmacenDocumentoFormActivity.class)
                .putExtra(EXTRA_FUENTE, fuente.name())
                .putExtra(EXTRA_ID, id);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityAlmacenFormBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        fuente = AlmacenFuenteDatos.valueOf(getIntent().getStringExtra(EXTRA_FUENTE));
        id = getIntent().getLongExtra(EXTRA_ID, 0L);
        String titulo = switch (fuente) {
            case MOVIMIENTOS -> id > 0 ? "Editar movimiento" : "Nuevo movimiento";
            case ORDENES_TRASLADO -> id > 0 ? "Editar OTR" : "Nueva OTR";
            case TOMAS_INVENTARIO -> id > 0 ? "Editar conteo" : "Nuevo conteo";
            default -> "Documento";
        };
        binding.toolbar.setTitle(titulo);
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());
        repository = new AlmacenRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());

        construirForm();
        binding.btnGuardar.setOnClickListener(v -> guardar());

        if (id > 0) cargarExistente();
    }

    private void construirForm() {
        LinearLayout c = binding.formContainer;
        c.removeAllViews();
        String hoy = LocalDate.now().toString();
        switch (fuente) {
            case MOVIMIENTOS -> {
                etAlmacenId = addField(c, "Almacén ID", InputType.TYPE_CLASS_NUMBER, "");
                etTipoMovId = addField(c, "Tipo movimiento ID", InputType.TYPE_CLASS_NUMBER, "");
                etFecha = addField(c, "Fecha (yyyy-MM-dd)", InputType.TYPE_CLASS_TEXT, hoy);
                etObs = addField(c, "Observaciones", InputType.TYPE_CLASS_TEXT, "");
                addLineasSection(c);
            }
            case ORDENES_TRASLADO -> {
                etOrigenId = addField(c, "Almacén origen ID", InputType.TYPE_CLASS_NUMBER, "");
                etDestinoId = addField(c, "Almacén destino ID", InputType.TYPE_CLASS_NUMBER, "");
                etFecha = addField(c, "Fecha (yyyy-MM-dd)", InputType.TYPE_CLASS_TEXT, hoy);
                etObs = addField(c, "Observación", InputType.TYPE_CLASS_TEXT, "");
                addLineasSection(c);
            }
            case TOMAS_INVENTARIO -> {
                etAlmacenId = addField(c, "Almacén ID", InputType.TYPE_CLASS_NUMBER, "");
                etArticuloId = addField(c, "Artículo ID", InputType.TYPE_CLASS_NUMBER, "");
                etFecha = addField(c, "Fecha conteo (yyyy-MM-dd)", InputType.TYPE_CLASS_TEXT, hoy);
                etSaldoSist = addField(c, "Saldo sistema",
                        InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL, "");
                etConteo1 = addField(c, "Cantidad conteo 1",
                        InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL, "");
                etConteo2 = addField(c, "Cantidad conteo 2",
                        InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL, "");
            }
            default -> { }
        }
    }

    private void addLineasSection(LinearLayout c) {
        TextView tv = new TextView(this);
        tv.setText(R.string.almacen_lineas);
        tv.setTextSize(16f);
        tv.setPadding(0, 16, 0, 8);
        c.addView(tv);
        lineasContainer = new LinearLayout(this);
        lineasContainer.setOrientation(LinearLayout.VERTICAL);
        c.addView(lineasContainer);
        MaterialButton add = new MaterialButton(this, null,
                com.google.android.material.R.attr.materialButtonOutlinedStyle);
        add.setText(R.string.almacen_agregar_linea);
        add.setOnClickListener(v -> addLinea(null, null, null));
        c.addView(add);
        if (lineas.isEmpty()) addLinea(null, null, null);
    }

    private void addLinea(Long articuloId, BigDecimal cant, BigDecimal costo) {
        LineaViews lv = new LineaViews();
        LinearLayout row = new LinearLayout(this);
        row.setOrientation(LinearLayout.VERTICAL);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = 12;
        row.setLayoutParams(lp);
        lv.articuloId = addField(row, "Artículo ID", InputType.TYPE_CLASS_NUMBER,
                articuloId != null ? String.valueOf(articuloId) : "");
        lv.cantidad = addField(row, "Cantidad",
                InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL,
                cant != null ? cant.toPlainString() : "");
        if (fuente == AlmacenFuenteDatos.MOVIMIENTOS) {
            lv.costo = addField(row, "Costo unitario",
                    InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL,
                    costo != null ? costo.toPlainString() : "");
        }
        lineasContainer.addView(row);
        lineas.add(lv);
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

    private void cargarExistente() {
        binding.progressBar.setVisibility(View.VISIBLE);
        switch (fuente) {
            case MOVIMIENTOS -> repository.obtenerMovimiento(id, new ResultCallback<>() {
                @Override
                public void onSuccess(MovimientoDetalleResponse d) {
                    binding.progressBar.setVisibility(View.GONE);
                    if (etAlmacenId != null) etAlmacenId.setText(str(d.almacenId));
                    if (etTipoMovId != null) etTipoMovId.setText(str(d.articuloMovTipoId));
                    if (etFecha != null) etFecha.setText(nz(d.fechaMov));
                    if (etObs != null) etObs.setText(nz(d.observaciones));
                    lineas.clear();
                    lineasContainer.removeAllViews();
                    List<MovimientoLineaResponse> ls = d.lineas;
                    if (ls == null || ls.isEmpty()) addLinea(null, null, null);
                    else for (MovimientoLineaResponse l : ls) {
                        addLinea(l.articuloId, l.cantidad, l.costoUnitario);
                    }
                }

                @Override
                public void onError(String mensaje) {
                    binding.progressBar.setVisibility(View.GONE);
                    AppUtils.toast(AlmacenDocumentoFormActivity.this, mensaje);
                }
            });
            case ORDENES_TRASLADO -> repository.obtenerOrdenTraslado(id, new ResultCallback<>() {
                @Override
                public void onSuccess(OrdenTrasladoDetalleResponse d) {
                    binding.progressBar.setVisibility(View.GONE);
                    if (etOrigenId != null) etOrigenId.setText(str(d.almacenOrigenId));
                    if (etDestinoId != null) etDestinoId.setText(str(d.almacenDestinoId));
                    if (etFecha != null) etFecha.setText(nz(d.fecha));
                    if (etObs != null) etObs.setText(nz(d.observacion));
                    lineas.clear();
                    lineasContainer.removeAllViews();
                    List<OrdenTrasladoLineaResponse> ls = d.lineas;
                    if (ls == null || ls.isEmpty()) addLinea(null, null, null);
                    else for (OrdenTrasladoLineaResponse l : ls) {
                        addLinea(l.articuloId, l.cantidad, null);
                    }
                }

                @Override
                public void onError(String mensaje) {
                    binding.progressBar.setVisibility(View.GONE);
                    AppUtils.toast(AlmacenDocumentoFormActivity.this, mensaje);
                }
            });
            case TOMAS_INVENTARIO -> repository.obtenerTomaInventario(id, new ResultCallback<>() {
                @Override
                public void onSuccess(InventarioConteoDetalleResponse d) {
                    binding.progressBar.setVisibility(View.GONE);
                    if (etAlmacenId != null) etAlmacenId.setText(str(d.almacenId));
                    if (etArticuloId != null) etArticuloId.setText(str(d.articuloId));
                    if (etFecha != null) etFecha.setText(nz(d.fechaConteo));
                    if (etSaldoSist != null) etSaldoSist.setText(num(d.saldoSistema));
                    if (etConteo1 != null) etConteo1.setText(num(d.cantidadConteo1));
                    if (etConteo2 != null) etConteo2.setText(num(d.cantidadConteo2));
                }

                @Override
                public void onError(String mensaje) {
                    binding.progressBar.setVisibility(View.GONE);
                    AppUtils.toast(AlmacenDocumentoFormActivity.this, mensaje);
                }
            });
            default -> binding.progressBar.setVisibility(View.GONE);
        }
    }

    private void guardar() {
        binding.progressBar.setVisibility(View.VISIBLE);
        binding.btnGuardar.setEnabled(false);
        try {
            switch (fuente) {
                case MOVIMIENTOS -> guardarMov();
                case ORDENES_TRASLADO -> guardarOtr();
                case TOMAS_INVENTARIO -> guardarInv();
                default -> throw new IllegalStateException("Fuente no soportada");
            }
        } catch (Exception e) {
            binding.progressBar.setVisibility(View.GONE);
            binding.btnGuardar.setEnabled(true);
            AppUtils.toast(this, e.getMessage() != null ? e.getMessage() : "Datos inválidos");
        }
    }

    private void guardarMov() {
        MovimientoCabeceraRequest r = new MovimientoCabeceraRequest();
        r.sucursalId = AppUtils.app(this).getSession().getSucursalId();
        r.almacenId = parseLong(etAlmacenId, "Almacén");
        r.articuloMovTipoId = parseLong(etTipoMovId, "Tipo movimiento");
        r.fechaMov = text(etFecha);
        r.observaciones = text(etObs);
        r.lineas = new ArrayList<>();
        for (LineaViews lv : lineas) {
            MovimientoLineaRequest l = new MovimientoLineaRequest();
            l.articuloId = parseLong(lv.articuloId, "Artículo");
            l.cantProcesada = parseDec(lv.cantidad, "Cantidad");
            l.costoUnitario = parseDecOpt(lv.costo);
            r.lineas.add(l);
        }
        if (r.lineas.isEmpty()) throw new IllegalArgumentException("Debe agregar al menos una línea");
        ResultCallback<MovimientoDetalleResponse> cb = done();
        if (id > 0) repository.actualizarMovimiento(id, r, cb);
        else repository.crearMovimiento(r, cb);
    }

    private void guardarOtr() {
        OrdenTrasladoRequest r = new OrdenTrasladoRequest();
        r.almacenOrigenId = parseLong(etOrigenId, "Origen");
        r.almacenDestinoId = parseLong(etDestinoId, "Destino");
        if (r.almacenOrigenId.equals(r.almacenDestinoId)) {
            throw new IllegalArgumentException("Origen y destino deben ser distintos");
        }
        r.fecha = text(etFecha);
        r.observacion = text(etObs);
        r.lineas = new ArrayList<>();
        for (LineaViews lv : lineas) {
            OrdenTrasladoLineaRequest l = new OrdenTrasladoLineaRequest();
            l.articuloId = parseLong(lv.articuloId, "Artículo");
            l.cantidad = parseDec(lv.cantidad, "Cantidad");
            r.lineas.add(l);
        }
        ResultCallback<OrdenTrasladoDetalleResponse> cb = done();
        if (id > 0) repository.actualizarOrdenTraslado(id, r, cb);
        else repository.crearOrdenTraslado(r, cb);
    }

    private void guardarInv() {
        InventarioConteoRequest r = new InventarioConteoRequest();
        r.almacenId = parseLong(etAlmacenId, "Almacén");
        r.articuloId = parseLong(etArticuloId, "Artículo");
        r.fechaConteo = text(etFecha);
        r.saldoSistema = parseDecOpt(etSaldoSist);
        r.cantidadConteo1 = parseDecOpt(etConteo1);
        r.cantidadConteo2 = parseDecOpt(etConteo2);
        ResultCallback<InventarioConteoDetalleResponse> cb = done();
        if (id > 0) repository.actualizarTomaInventario(id, r, cb);
        else repository.crearTomaInventario(r, cb);
    }

    private <T> ResultCallback<T> done() {
        return new ResultCallback<>() {
            @Override
            public void onSuccess(T data) {
                binding.progressBar.setVisibility(View.GONE);
                AppUtils.toast(AlmacenDocumentoFormActivity.this, getString(R.string.almacen_guardado_ok));
                setResult(RESULT_OK);
                finish();
            }

            @Override
            public void onError(String mensaje) {
                binding.progressBar.setVisibility(View.GONE);
                binding.btnGuardar.setEnabled(true);
                AppUtils.toast(AlmacenDocumentoFormActivity.this, mensaje);
            }
        };
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

    private static BigDecimal parseDec(TextInputEditText et, String label) {
        try {
            BigDecimal v = new BigDecimal(text(et));
            if (v.compareTo(BigDecimal.ZERO) <= 0) throw new IllegalArgumentException();
            return v;
        } catch (Exception e) {
            throw new IllegalArgumentException(label + " inválida");
        }
    }

    private static BigDecimal parseDecOpt(TextInputEditText et) {
        String t = text(et);
        if (t.isEmpty()) return null;
        try { return new BigDecimal(t); } catch (Exception e) { return null; }
    }

    private static String str(Long v) { return v != null ? String.valueOf(v) : ""; }
    private static String nz(String v) { return v != null ? v : ""; }
    private static String num(BigDecimal v) { return v != null ? v.toPlainString() : ""; }

    private static final class LineaViews {
        TextInputEditText articuloId;
        TextInputEditText cantidad;
        TextInputEditText costo;
    }
}
