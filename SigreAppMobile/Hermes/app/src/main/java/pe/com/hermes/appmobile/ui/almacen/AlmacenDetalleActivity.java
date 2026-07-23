package pe.com.hermes.appmobile.ui.almacen;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import androidx.appcompat.app.AppCompatActivity;
import java.math.BigDecimal;
import java.util.List;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MovimientoDetalleResponse;
import pe.com.hermes.appmobile.data.remote.dto.AlmacenListDtos.MovimientoLineaResponse;
import pe.com.hermes.appmobile.data.repository.AlmacenRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityAlmacenDetalleBinding;
import pe.com.hermes.appmobile.util.AppUtils;

/** Detalle de movimiento (vale) — lectura. */
public class AlmacenDetalleActivity extends AppCompatActivity {

    public static final String EXTRA_MOVIMIENTO_ID = "movimiento_id";
    public static final String EXTRA_TITULO = "titulo";

    private ActivityAlmacenDetalleBinding binding;
    private AlmacenRepository repository;

    public static Intent intentMovimiento(Context ctx, long id, String titulo) {
        return new Intent(ctx, AlmacenDetalleActivity.class)
                .putExtra(EXTRA_MOVIMIENTO_ID, id)
                .putExtra(EXTRA_TITULO, titulo);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityAlmacenDetalleBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        long id = getIntent().getLongExtra(EXTRA_MOVIMIENTO_ID, 0L);
        String titulo = getIntent().getStringExtra(EXTRA_TITULO);
        binding.toolbar.setTitle(titulo != null ? titulo : getString(R.string.almacen_detalle_titulo));
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert);
        binding.toolbar.setNavigationOnClickListener(v -> getOnBackPressedDispatcher().onBackPressed());

        if (id <= 0) {
            AppUtils.toast(this, getString(R.string.almacen_vista_invalida));
            finish();
            return;
        }

        repository = new AlmacenRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());
        binding.progressBar.setVisibility(View.VISIBLE);
        repository.obtenerMovimiento(id, new ResultCallback<MovimientoDetalleResponse>() {
            @Override
            public void onSuccess(MovimientoDetalleResponse d) {
                binding.progressBar.setVisibility(View.GONE);
                binding.tvDetalle.setText(formatear(d));
            }

            @Override
            public void onError(String mensaje) {
                binding.progressBar.setVisibility(View.GONE);
                AppUtils.toast(AlmacenDetalleActivity.this,
                        mensaje != null ? mensaje : getString(R.string.lista_error));
            }
        });
    }

    private static String formatear(MovimientoDetalleResponse d) {
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

    private static String nz(String v) {
        return v != null && !v.isBlank() ? v : "—";
    }

    private static String num(BigDecimal v) {
        return v != null ? v.toPlainString() : "0";
    }
}
