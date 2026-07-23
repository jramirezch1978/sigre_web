package pe.com.hermes.appmobile.ui.compras;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.text.InputType;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import com.google.android.material.button.MaterialButton;
import java.math.BigDecimal;
import java.util.List;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.ConvertirResponse;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.SolicitudDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.ComprasDtos.SolicitudLineaResponse;
import pe.com.hermes.appmobile.data.repository.ComprasRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityAlmacenDetalleBinding;
import pe.com.hermes.common.ui.ConfirmDialog;
import pe.com.hermes.appmobile.util.AppUtils;

/** Detalle + acciones de solicitud de compra (CM003). */
public class ComprasDetalleActivity extends AppCompatActivity {

    public static final String EXTRA_ID = "id";
    public static final String EXTRA_TITULO = "titulo";

    private ActivityAlmacenDetalleBinding binding;
    private ComprasRepository repository;
    private long id;

    public static Intent intentSolicitud(Context ctx, long id, String titulo) {
        return new Intent(ctx, ComprasDetalleActivity.class)
                .putExtra(EXTRA_ID, id)
                .putExtra(EXTRA_TITULO, titulo);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityAlmacenDetalleBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        id = getIntent().getLongExtra(EXTRA_ID, 0L);
        String titulo = getIntent().getStringExtra(EXTRA_TITULO);
        binding.toolbar.setTitle(titulo != null ? titulo : getString(R.string.compras_detalle_titulo));
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());
        binding.toolbar.inflateMenu(R.menu.menu_almacen_detalle);
        binding.toolbar.setOnMenuItemClickListener(item -> {
            if (item.getItemId() == R.id.action_editar) {
                startActivity(ComprasSolicitudFormActivity.intent(this, id));
                return true;
            }
            return false;
        });

        if (id <= 0) {
            AppUtils.toast(this, getString(R.string.compras_vista_invalida));
            finish();
            return;
        }
        repository = new ComprasRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());
        cargar();
    }

    @Override
    protected void onResume() {
        super.onResume();
        if (repository != null && id > 0) cargar();
    }

    private void cargar() {
        binding.progressBar.setVisibility(View.VISIBLE);
        repository.obtenerSolicitud(id, new ResultCallback<>() {
            @Override
            public void onSuccess(SolicitudDetalleResponse d) {
                binding.progressBar.setVisibility(View.GONE);
                binding.tvDetalle.setText(formatear(d));
                pintarAcciones(d);
            }

            @Override
            public void onError(String mensaje) {
                binding.progressBar.setVisibility(View.GONE);
                AppUtils.toast(ComprasDetalleActivity.this, mensaje);
            }
        });
    }

    private void pintarAcciones(SolicitudDetalleResponse d) {
        LinearLayout box = binding.accionesContainer;
        box.removeAllViews();
        String est = d.flagEstado != null ? d.flagEstado : "";
        // 1=borrador/activa editable, otros según flujo
        addAccion(box, R.string.compras_accion_enviar, () ->
                confirmar(getString(R.string.compras_accion_enviar), () ->
                        repository.enviar(id, reload())));
        addAccion(box, R.string.compras_accion_aprobar, () ->
                confirmar(getString(R.string.compras_accion_aprobar), () ->
                        repository.aprobar(id, null, reload())));
        addAccion(box, R.string.compras_accion_rechazar, () ->
                pedirMotivo(getString(R.string.compras_accion_rechazar), motivo ->
                        repository.rechazar(id, motivo, reload())));
        addAccion(box, R.string.compras_accion_anular, () ->
                pedirMotivo(getString(R.string.compras_accion_anular), motivo ->
                        repository.anular(id, motivo, reload())));
        if (!"2".equals(est)) {
            addAccion(box, R.string.compras_accion_convertir, this::convertirDialog);
        }
        binding.accionesScroll.setVisibility(box.getChildCount() > 0 ? View.VISIBLE : View.GONE);
    }

    private void convertirDialog() {
        LinearLayout box = new LinearLayout(this);
        box.setOrientation(LinearLayout.VERTICAL);
        int pad = (int) (16 * getResources().getDisplayMetrics().density);
        box.setPadding(pad, pad, pad, 0);
        EditText etDestino = new EditText(this);
        etDestino.setHint("Destino (OC / COTIZACION / ...)");
        etDestino.setText("OC");
        EditText etProv = new EditText(this);
        etProv.setHint("Proveedor ID");
        etProv.setInputType(InputType.TYPE_CLASS_NUMBER);
        box.addView(etDestino);
        box.addView(etProv);
        new AlertDialog.Builder(this)
                .setTitle(R.string.compras_accion_convertir)
                .setView(box)
                .setPositiveButton(android.R.string.ok, (d, w) -> {
                    String destino = etDestino.getText() != null ? etDestino.getText().toString().trim() : "";
                    String prov = etProv.getText() != null ? etProv.getText().toString().trim() : "";
                    try {
                        long proveedorId = Long.parseLong(prov);
                        binding.progressBar.setVisibility(View.VISIBLE);
                        repository.convertir(id, destino, proveedorId, new ResultCallback<>() {
                            @Override
                            public void onSuccess(ConvertirResponse data) {
                                binding.progressBar.setVisibility(View.GONE);
                                AppUtils.toast(ComprasDetalleActivity.this, getString(R.string.compras_accion_ok));
                                cargar();
                            }

                            @Override
                            public void onError(String mensaje) {
                                binding.progressBar.setVisibility(View.GONE);
                                AppUtils.toast(ComprasDetalleActivity.this, mensaje);
                            }
                        });
                    } catch (Exception e) {
                        AppUtils.toast(this, "Proveedor ID inválido");
                    }
                })
                .setNegativeButton(android.R.string.cancel, null)
                .show();
    }

    private ResultCallback<SolicitudDetalleResponse> reload() {
        return new ResultCallback<>() {
            @Override
            public void onSuccess(SolicitudDetalleResponse data) {
                AppUtils.toast(ComprasDetalleActivity.this, getString(R.string.compras_accion_ok));
                cargar();
            }

            @Override
            public void onError(String mensaje) {
                AppUtils.toast(ComprasDetalleActivity.this, mensaje);
            }
        };
    }

    private void confirmar(String accion, Runnable ok) {
        ConfirmDialog.mostrar(this, accion, getString(R.string.compras_accion_confirmar_msg, accion), true, ok::run);
    }

    private interface MotivoCb { void onMotivo(String motivo); }

    private void pedirMotivo(String titulo, MotivoCb cb) {
        EditText et = new EditText(this);
        et.setHint("Motivo");
        int pad = (int) (16 * getResources().getDisplayMetrics().density);
        et.setPadding(pad, pad, pad, pad);
        new AlertDialog.Builder(this)
                .setTitle(titulo)
                .setView(et)
                .setPositiveButton(android.R.string.ok, (d, w) -> {
                    String m = et.getText() != null ? et.getText().toString().trim() : "";
                    if (m.isEmpty()) {
                        AppUtils.toast(this, "Motivo requerido");
                        return;
                    }
                    cb.onMotivo(m);
                })
                .setNegativeButton(android.R.string.cancel, null)
                .show();
    }

    private void addAccion(LinearLayout box, int labelRes, Runnable onClick) {
        MaterialButton btn = new MaterialButton(this, null,
                com.google.android.material.R.attr.materialButtonOutlinedStyle);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.setMarginEnd(8);
        btn.setLayoutParams(lp);
        btn.setText(labelRes);
        btn.setOnClickListener(v -> onClick.run());
        box.addView(btn);
    }

    private static String formatear(SolicitudDetalleResponse d) {
        StringBuilder sb = new StringBuilder();
        sb.append("Número: ").append(nz(d.numero)).append('\n');
        sb.append("Fecha: ").append(nz(d.fecha)).append('\n');
        sb.append("Estado: ").append(nz(d.flagEstado)).append('\n');
        sb.append("Prioridad: ").append(nz(d.prioridad)).append('\n');
        sb.append("Sucursal: ").append(d.sucursalId).append('\n');
        sb.append("Solicitante: ").append(d.solicitanteId).append('\n');
        sb.append("Justificación: ").append(nz(d.justificacion)).append("\n\n");
        sb.append("Líneas\n──────\n");
        List<SolicitudLineaResponse> lineas = d.lineas;
        if (lineas == null || lineas.isEmpty()) {
            sb.append("(sin líneas)\n");
        } else {
            for (SolicitudLineaResponse l : lineas) {
                sb.append("• ").append(nz(l.articuloCodigo)).append(" ")
                        .append(nz(l.articuloDescripcion))
                        .append("\n  ArtID ").append(l.articuloId)
                        .append("  Cant ").append(num(l.cantidad))
                        .append('\n');
            }
        }
        return sb.toString();
    }

    private static String nz(String v) { return v != null && !v.isBlank() ? v : "—"; }
    private static String num(BigDecimal v) { return v != null ? v.toPlainString() : "0"; }
}
