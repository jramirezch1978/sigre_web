package pe.com.hermes.appmobile.ui.almacen;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.LinearLayout;
import com.google.android.material.button.MaterialButton;
import androidx.appcompat.app.AppCompatActivity;
import java.math.BigDecimal;
import java.util.List;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.InventarioConteoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MovimientoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MovimientoLineaResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.OrdenTrasladoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.OrdenTrasladoLineaResponse;
import pe.com.hermes.appmobile.data.repository.AlmacenRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityAlmacenDetalleBinding;
import pe.com.hermes.common.ui.ConfirmDialog;
import pe.com.hermes.appmobile.util.AppUtils;

/** Detalle + acciones de movimiento, OTR o toma de inventario. */
public class AlmacenDetalleActivity extends AppCompatActivity {

    public static final String EXTRA_TIPO = "detalle_tipo";
    public static final String EXTRA_ID = "detalle_id";
    public static final String EXTRA_TITULO = "titulo";
    @Deprecated
    public static final String EXTRA_MOVIMIENTO_ID = "movimiento_id";

    private ActivityAlmacenDetalleBinding binding;
    private AlmacenRepository repository;
    private AlmacenRepository.DetalleTipo tipo;
    private long id;

    public static Intent intent(Context ctx, AlmacenRepository.DetalleTipo tipo, long id, String titulo) {
        return new Intent(ctx, AlmacenDetalleActivity.class)
                .putExtra(EXTRA_TIPO, tipo.name())
                .putExtra(EXTRA_ID, id)
                .putExtra(EXTRA_TITULO, titulo);
    }

    public static Intent intentMovimiento(Context ctx, long id, String titulo) {
        return intent(ctx, AlmacenRepository.DetalleTipo.MOVIMIENTO, id, titulo);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityAlmacenDetalleBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        String tipoName = getIntent().getStringExtra(EXTRA_TIPO);
        id = getIntent().getLongExtra(EXTRA_ID, 0L);
        if (id <= 0) id = getIntent().getLongExtra(EXTRA_MOVIMIENTO_ID, 0L);
        if (tipoName == null || tipoName.isBlank()) {
            tipo = AlmacenRepository.DetalleTipo.MOVIMIENTO;
        } else {
            tipo = AlmacenRepository.DetalleTipo.valueOf(tipoName);
        }

        String titulo = getIntent().getStringExtra(EXTRA_TITULO);
        binding.toolbar.setTitle(titulo != null ? titulo : getString(R.string.almacen_detalle_titulo));
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());

        if (id <= 0 || tipo == AlmacenRepository.DetalleTipo.NINGUNO) {
            AppUtils.toast(this, getString(R.string.almacen_vista_invalida));
            finish();
            return;
        }

        repository = new AlmacenRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());
        cargar();
    }

    private void cargar() {
        binding.progressBar.setVisibility(View.VISIBLE);
        switch (tipo) {
            case MOVIMIENTO -> repository.obtenerMovimiento(id, new ResultCallback<>() {
                @Override
                public void onSuccess(MovimientoDetalleResponse d) {
                    binding.progressBar.setVisibility(View.GONE);
                    binding.tvDetalle.setText(formatearMov(d));
                    pintarAccionesMov(d);
                }

                @Override
                public void onError(String mensaje) {
                    error(mensaje);
                }
            });
            case ORDEN_TRASLADO -> repository.obtenerOrdenTraslado(id, new ResultCallback<>() {
                @Override
                public void onSuccess(OrdenTrasladoDetalleResponse d) {
                    binding.progressBar.setVisibility(View.GONE);
                    binding.tvDetalle.setText(formatearOtr(d));
                    pintarAccionesOtr(d);
                }

                @Override
                public void onError(String mensaje) {
                    error(mensaje);
                }
            });
            case TOMA_INVENTARIO -> repository.obtenerTomaInventario(id, new ResultCallback<>() {
                @Override
                public void onSuccess(InventarioConteoDetalleResponse d) {
                    binding.progressBar.setVisibility(View.GONE);
                    binding.tvDetalle.setText(formatearInv(d));
                    pintarAccionesInv(d);
                }

                @Override
                public void onError(String mensaje) {
                    error(mensaje);
                }
            });
            default -> {
                binding.progressBar.setVisibility(View.GONE);
                AppUtils.toast(this, getString(R.string.almacen_vista_invalida));
                finish();
            }
        }
    }

    private void error(String mensaje) {
        binding.progressBar.setVisibility(View.GONE);
        AppUtils.toast(this, mensaje != null ? mensaje : getString(R.string.lista_error));
    }

    private void pintarAccionesMov(MovimientoDetalleResponse d) {
        LinearLayout box = binding.accionesContainer;
        box.removeAllViews();
        String estado = d.flagEstado != null ? d.flagEstado : "";
        // Estados típicos: 0/P pendiente, 1 confirmado, 9 anulado (varía por tenant)
        boolean pendiente = estado.equals("0") || estado.equalsIgnoreCase("P") || estado.equalsIgnoreCase("PENDIENTE");
        if (pendiente) {
            addAccion(box, R.string.almacen_accion_confirmar, () ->
                    confirmar(getString(R.string.almacen_accion_confirmar), () ->
                            repository.confirmarMovimiento(id, reloadMov())));
            addAccion(box, R.string.almacen_accion_anular, () ->
                    confirmar(getString(R.string.almacen_accion_anular), () ->
                            repository.anularMovimiento(id, "Anulado desde Hermes", reloadMov())));
        }
        binding.accionesScroll.setVisibility(box.getChildCount() > 0 ? View.VISIBLE : View.GONE);
    }

    private void pintarAccionesOtr(OrdenTrasladoDetalleResponse d) {
        LinearLayout box = binding.accionesContainer;
        box.removeAllViews();
        String estado = d.flagEstado != null ? d.flagEstado.toUpperCase() : "";
        if (estado.contains("PEND") || estado.equals("0") || estado.equals("P") || estado.equals("G")) {
            addAccion(box, R.string.almacen_accion_aprobar, () ->
                    confirmar(getString(R.string.almacen_accion_aprobar), () ->
                            repository.aprobarOrdenTraslado(id, reloadOtr())));
            addAccion(box, R.string.almacen_accion_rechazar, () ->
                    confirmar(getString(R.string.almacen_accion_rechazar), () ->
                            repository.rechazarOrdenTraslado(id, reloadOtr())));
        }
        if (estado.contains("APROB") || estado.equals("1") || estado.equals("A")) {
            addAccion(box, R.string.almacen_accion_cerrar, () ->
                    confirmar(getString(R.string.almacen_accion_cerrar), () ->
                            repository.cerrarOrdenTraslado(id, reloadOtr())));
        }
        if (!estado.contains("ANUL") && !estado.equals("9")) {
            addAccion(box, R.string.almacen_accion_anular, () ->
                    confirmar(getString(R.string.almacen_accion_anular), () ->
                            repository.anularOrdenTraslado(id, reloadOtr())));
        }
        binding.accionesScroll.setVisibility(box.getChildCount() > 0 ? View.VISIBLE : View.GONE);
    }

    private void pintarAccionesInv(InventarioConteoDetalleResponse d) {
        LinearLayout box = binding.accionesContainer;
        box.removeAllViews();
        String estado = d.flagEstado != null ? d.flagEstado.toUpperCase() : "";
        if (!estado.contains("CERR") && !estado.contains("ANUL")) {
            addAccion(box, R.string.almacen_accion_comparar, () ->
                    confirmar(getString(R.string.almacen_accion_comparar), () ->
                            repository.compararTomaInventario(id, reloadInv())));
            addAccion(box, R.string.almacen_accion_cerrar, () ->
                    confirmar(getString(R.string.almacen_accion_cerrar), () ->
                            repository.cerrarTomaInventario(id, reloadInv())));
            addAccion(box, R.string.almacen_accion_anular, () ->
                    confirmar(getString(R.string.almacen_accion_anular), () ->
                            repository.anularTomaInventario(id, reloadInv())));
        }
        binding.accionesScroll.setVisibility(box.getChildCount() > 0 ? View.VISIBLE : View.GONE);
    }

    private ResultCallback<MovimientoDetalleResponse> reloadMov() {
        return new ResultCallback<>() {
            @Override
            public void onSuccess(MovimientoDetalleResponse data) {
                AppUtils.toast(AlmacenDetalleActivity.this, getString(R.string.almacen_accion_ok));
                cargar();
            }

            @Override
            public void onError(String mensaje) {
                error(mensaje);
            }
        };
    }

    private ResultCallback<OrdenTrasladoDetalleResponse> reloadOtr() {
        return new ResultCallback<>() {
            @Override
            public void onSuccess(OrdenTrasladoDetalleResponse data) {
                AppUtils.toast(AlmacenDetalleActivity.this, getString(R.string.almacen_accion_ok));
                cargar();
            }

            @Override
            public void onError(String mensaje) {
                error(mensaje);
            }
        };
    }

    private ResultCallback<InventarioConteoDetalleResponse> reloadInv() {
        return new ResultCallback<>() {
            @Override
            public void onSuccess(InventarioConteoDetalleResponse data) {
                AppUtils.toast(AlmacenDetalleActivity.this, getString(R.string.almacen_accion_ok));
                cargar();
            }

            @Override
            public void onError(String mensaje) {
                error(mensaje);
            }
        };
    }

    private void confirmar(String accion, Runnable ok) {
        ConfirmDialog.mostrar(
                this,
                accion,
                getString(R.string.almacen_accion_confirmar_msg, accion),
                true,
                ok::run);
    }

    private void addAccion(LinearLayout box, int labelRes, Runnable onClick) {
        MaterialButton btn = new MaterialButton(this, null, com.google.android.material.R.attr.materialButtonOutlinedStyle);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.WRAP_CONTENT, LinearLayout.LayoutParams.WRAP_CONTENT);
        lp.setMarginEnd(8);
        btn.setLayoutParams(lp);
        btn.setText(labelRes);
        btn.setOnClickListener(v -> onClick.run());
        box.addView(btn);
    }

    private static String formatearMov(MovimientoDetalleResponse d) {
        StringBuilder sb = new StringBuilder();
        sb.append("Vale: ").append(nz(d.nroVale)).append('\n');
        sb.append("Fecha: ").append(nz(d.fechaMov)).append('\n');
        sb.append("Estado: ").append(nz(d.flagEstado)).append('\n');
        sb.append("Almacén: ").append(nz(d.almacenNombre)).append(" (").append(d.almacenId).append(")\n");
        sb.append("Sucursal: ").append(nz(d.sucursalNombre)).append('\n');
        sb.append("Tipo mov.: ").append(nz(d.articuloMovTipoDescripcion)).append('\n');
        sb.append("Observaciones: ").append(nz(d.observaciones)).append("\n\n");
        sb.append("Líneas\n──────\n");
        List<MovimientoLineaResponse> lineas = d.lineas;
        if (lineas == null || lineas.isEmpty()) {
            sb.append("(sin líneas)\n");
        } else {
            for (MovimientoLineaResponse l : lineas) {
                sb.append("• ").append(nz(l.articuloCodigo)).append(" ")
                        .append(nz(l.articuloNombre))
                        .append("\n  Cant: ").append(num(l.cantidad))
                        .append("  Costo: ").append(num(l.costoUnitario))
                        .append('\n');
            }
        }
        return sb.toString();
    }

    private static String formatearOtr(OrdenTrasladoDetalleResponse d) {
        StringBuilder sb = new StringBuilder();
        sb.append("Número: ").append(nz(d.numero)).append('\n');
        sb.append("Fecha: ").append(nz(d.fecha)).append('\n');
        sb.append("Estado: ").append(nz(d.flagEstado)).append('\n');
        sb.append("Origen: ").append(d.almacenOrigenId).append('\n');
        sb.append("Destino: ").append(d.almacenDestinoId).append('\n');
        sb.append("Observación: ").append(nz(d.observacion)).append("\n\n");
        sb.append("Líneas\n──────\n");
        List<OrdenTrasladoLineaResponse> lineas = d.lineas;
        if (lineas == null || lineas.isEmpty()) {
            sb.append("(sin líneas)\n");
        } else {
            for (OrdenTrasladoLineaResponse l : lineas) {
                sb.append("• Art ").append(l.articuloId)
                        .append("  Cant: ").append(num(l.cantidad)).append('\n');
            }
        }
        return sb.toString();
    }

    private static String formatearInv(InventarioConteoDetalleResponse d) {
        StringBuilder sb = new StringBuilder();
        sb.append("Conteo #: ").append(d.nroConteo != null ? d.nroConteo : d.id).append('\n');
        sb.append("Fecha: ").append(nz(d.fechaConteo)).append('\n');
        sb.append("Estado: ").append(nz(d.flagEstado)).append('\n');
        sb.append("Almacén: ").append(d.almacenId).append('\n');
        sb.append("Artículo: ").append(d.articuloId).append('\n');
        sb.append("Saldo sistema: ").append(num(d.saldoSistema)).append('\n');
        sb.append("Conteo 1: ").append(num(d.cantidadConteo1)).append('\n');
        sb.append("Conteo 2: ").append(num(d.cantidadConteo2)).append('\n');
        sb.append("Diferencia: ").append(num(d.diferencia)).append('\n');
        return sb.toString();
    }

    private static String nz(String v) {
        return v != null && !v.isBlank() ? v : "—";
    }

    private static String num(BigDecimal v) {
        return v != null ? v.toPlainString() : "0";
    }
}
