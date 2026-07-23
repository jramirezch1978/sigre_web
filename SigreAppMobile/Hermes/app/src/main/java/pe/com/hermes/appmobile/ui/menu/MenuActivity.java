package pe.com.hermes.appmobile.ui.menu;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.PopupMenu;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import androidx.core.view.GravityCompat;
import androidx.recyclerview.widget.LinearLayoutManager;
import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.device.DeviceRegistrationFactory;
import pe.com.hermes.appmobile.data.menu.MenuNodo;
import pe.com.hermes.appmobile.data.menu.MenuTreeBuilder;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.DashboardLogisticoResponse;
import pe.com.hermes.appmobile.data.remote.dto.DispositivoRegistradoResponse;
import pe.com.hermes.appmobile.data.remote.dto.MiMenuResponse;
import pe.com.hermes.appmobile.data.remote.dto.RegistrarDispositivoRequest;
import pe.com.hermes.appmobile.data.repository.AuthRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.databinding.ActivityMenuBinding;
import pe.com.hermes.appmobile.ui.almacen.AlmacenOpcionesActivity;
import pe.com.hermes.appmobile.ui.almacen.movimientos.MovimientosListActivity;
import pe.com.hermes.appmobile.ui.compras.ComprasOpcionesActivity;
import pe.com.hermes.appmobile.ui.configuracion.ConfiguracionActivity;
import pe.com.hermes.appmobile.ui.login.LoginActivity;
import pe.com.hermes.appmobile.ui.preferencias.PreferenciasActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.common.ui.ConfirmDialog;
import pe.com.hermes.common.util.AsyncRunner;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

/**
 * Pantalla principal Hermes: drawer con el mismo menú del ERP web ({@code mi-menu})
 * y dashboard logístico (valorización, ingresos/salidas, producto terminado).
 */
public class MenuActivity extends AppCompatActivity {

    private ActivityMenuBinding binding;
    private AuthRepository authRepository;
    private DrawerMenuAdapter drawerAdapter;
    private DashAlmacenAdapter almacenAdapter;
    private DashPtAdapter ptAdapter;
    private boolean cerrandoSesion;
    private final NumberFormat money = NumberFormat.getCurrencyInstance(new Locale("es", "PE"));

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityMenuBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        authRepository = new AuthRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());

        SessionManager session = AppUtils.app(this).getSession();
        String empresaNombre = session.getEmpresaNombre();
        String sucursalNombre = session.getSucursalNombre();
        String nombreUsuario = session.getNombreCompleto();

        binding.tvMenuTitulo.setText(getString(R.string.menu_titulo));
        String sub = formatearSubtitulo(empresaNombre, sucursalNombre);
        binding.tvMenuSubtitulo.setText(sub);
        binding.tvDrawerSubtitulo.setText(sub);
        binding.tvAvatarIniciales.setText(inicialesDe(nombreUsuario));

        binding.btnMenu.setOnClickListener(v -> binding.drawerLayout.openDrawer(GravityCompat.START));
        binding.btnAvatarUsuario.setOnClickListener(v -> mostrarMenuUsuario());
        binding.swipeRefresh.setOnRefreshListener(this::cargarDashboard);

        binding.recyclerDrawer.setLayoutManager(new LinearLayoutManager(this));
        binding.recyclerValorizacion.setLayoutManager(new LinearLayoutManager(this));
        binding.recyclerPt.setLayoutManager(new LinearLayoutManager(this));
        almacenAdapter = new DashAlmacenAdapter();
        ptAdapter = new DashPtAdapter();
        binding.recyclerValorizacion.setAdapter(almacenAdapter);
        binding.recyclerPt.setAdapter(ptAdapter);

        setKpi(binding.kpiValor.getRoot(), getString(R.string.dash_kpi_valor), "—");
        setKpi(binding.kpiIngresos.getRoot(), getString(R.string.dash_kpi_ingresos), "—");
        setKpi(binding.kpiSalidas.getRoot(), getString(R.string.dash_kpi_salidas), "—");

        cargarMenuDrawer();
        cargarDashboard();
    }

    @Override
    protected void onResume() {
        super.onResume();
        binding.tvAvatarIniciales.setText(inicialesDe(AppUtils.app(this).getSession().getNombreCompleto()));
    }

    @Override
    public void onBackPressed() {
        if (binding.drawerLayout.isDrawerOpen(GravityCompat.START)) {
            binding.drawerLayout.closeDrawer(GravityCompat.START);
            return;
        }
        super.onBackPressed();
    }

    private void cargarMenuDrawer() {
        binding.progressMenu.setVisibility(View.VISIBLE);
        AppUtils.app(this).getApiClient().getAuthApi().miMenu()
                .enqueue(new Callback<ApiResponse<MiMenuResponse>>() {
                    @Override
                    public void onResponse(Call<ApiResponse<MiMenuResponse>> call,
                                           Response<ApiResponse<MiMenuResponse>> response) {
                        binding.progressMenu.setVisibility(View.GONE);
                        ApiResponse<MiMenuResponse> body = response.body();
                        if (!response.isSuccessful() || body == null || !body.success || body.data == null) {
                            AppUtils.toast(MenuActivity.this, "No se pudo cargar el menú");
                            return;
                        }
                        List<MenuNodo> arbol = MenuTreeBuilder.fromMiMenu(body.data);
                        for (MenuNodo m : arbol) {
                            m.expandido = "ALMACEN".equals(m.codigo) || "COMPRAS".equals(m.codigo);
                        }
                        drawerAdapter = new DrawerMenuAdapter(arbol, MenuActivity.this::onMenuOpcion);
                        binding.recyclerDrawer.setAdapter(drawerAdapter);
                    }

                    @Override
                    public void onFailure(Call<ApiResponse<MiMenuResponse>> call, Throwable t) {
                        binding.progressMenu.setVisibility(View.GONE);
                        AppUtils.toast(MenuActivity.this, "Error de red al cargar el menú");
                    }
                });
    }

    private void cargarDashboard() {
        long sucursalId = AppUtils.app(this).getSession().getSucursalId();
        Long filtro = sucursalId > 0 ? sucursalId : null;
        binding.swipeRefresh.setRefreshing(true);
        AppUtils.app(this).getApiClient().getAlmacenApi().dashboardLogistico(filtro)
                .enqueue(new Callback<ApiResponse<DashboardLogisticoResponse>>() {
                    @Override
                    public void onResponse(Call<ApiResponse<DashboardLogisticoResponse>> call,
                                           Response<ApiResponse<DashboardLogisticoResponse>> response) {
                        binding.swipeRefresh.setRefreshing(false);
                        ApiResponse<DashboardLogisticoResponse> body = response.body();
                        if (!response.isSuccessful() || body == null || !body.success || body.data == null) {
                            AppUtils.toast(MenuActivity.this, "No se pudo cargar el dashboard");
                            return;
                        }
                        pintarDashboard(body.data);
                    }

                    @Override
                    public void onFailure(Call<ApiResponse<DashboardLogisticoResponse>> call, Throwable t) {
                        binding.swipeRefresh.setRefreshing(false);
                        AppUtils.toast(MenuActivity.this, "Error de red en dashboard");
                    }
                });
    }

    private void pintarDashboard(DashboardLogisticoResponse d) {
        BigDecimal valor = d.valorInventarioTotal != null ? d.valorInventarioTotal : BigDecimal.ZERO;
        setKpi(binding.kpiValor.getRoot(), getString(R.string.dash_kpi_valor), money.format(valor));
        setKpi(binding.kpiIngresos.getRoot(), getString(R.string.dash_kpi_ingresos),
                String.valueOf(d.totalIngresosActivos));
        setKpi(binding.kpiSalidas.getRoot(), getString(R.string.dash_kpi_salidas),
                String.valueOf(d.totalSalidasActivos));

        List<DashboardLogisticoResponse.DiagnosticoAlmacenDto> alm = d.valorizacionPorAlmacen;
        almacenAdapter.setItems(alm);
        binding.tvValorizacionVacio.setVisibility(alm == null || alm.isEmpty() ? View.VISIBLE : View.GONE);

        String clase = d.claseProductoTerminado != null ? d.claseProductoTerminado : "01";
        String desc = d.claseProductoTerminadoDesc != null ? d.claseProductoTerminadoDesc : "PRODUCTOS TERMINADOS";
        binding.tvPtClase.setText(getString(R.string.dash_pt_clase, clase, desc));

        List<DashboardLogisticoResponse.ProductoTerminadoStockDto> pt = d.productoTerminado;
        ptAdapter.setItems(pt);
        binding.tvPtVacio.setVisibility(pt == null || pt.isEmpty() ? View.VISIBLE : View.GONE);
    }

    private void onMenuOpcion(MenuNodo nodo) {
        binding.drawerLayout.closeDrawer(GravityCompat.START);
        String codigo = nodo.codigo != null ? nodo.codigo.toUpperCase(Locale.ROOT) : "";
        String path = nodo.pathUrl != null ? nodo.pathUrl.toLowerCase(Locale.ROOT) : "";

        if (codigo.contains("ALMACEN") && (codigo.contains("MOVIM") || path.contains("movimiento"))) {
            startActivity(new Intent(this, MovimientosListActivity.class));
            return;
        }
        if (codigo.startsWith("ALMACEN") || path.contains("/almacen")) {
            startActivity(new Intent(this, AlmacenOpcionesActivity.class));
            return;
        }
        if (codigo.startsWith("COMPRAS") || path.contains("/compras")) {
            startActivity(new Intent(this, ComprasOpcionesActivity.class));
            return;
        }
        AppUtils.toast(this, getString(R.string.menu_opcion_en_construccion, nodo.nombre));
    }

    private static void setKpi(View root, String label, String valor) {
        TextView tvLabel = root.findViewById(R.id.tvKpiLabel);
        TextView tvValor = root.findViewById(R.id.tvKpiValor);
        if (tvLabel != null) tvLabel.setText(label);
        if (tvValor != null) tvValor.setText(valor);
    }

    private void mostrarMenuUsuario() {
        if (cerrandoSesion) return;
        PopupMenu popup = new PopupMenu(this, binding.btnAvatarUsuario);
        popup.getMenuInflater().inflate(R.menu.menu_usuario, popup.getMenu());
        popup.setOnMenuItemClickListener(item -> {
            int id = item.getItemId();
            if (id == R.id.action_preferencias) {
                startActivity(new Intent(this, PreferenciasActivity.class));
                return true;
            }
            if (id == R.id.action_configuracion) {
                startActivity(new Intent(this, ConfiguracionActivity.class));
                return true;
            }
            if (id == R.id.action_cerrar_sesion) {
                confirmarCerrarSesion();
                return true;
            }
            return false;
        });
        popup.show();
    }

    private void confirmarCerrarSesion() {
        String nombre = AppUtils.app(this).getSession().getNombreCompleto();
        if (nombre == null || nombre.trim().isEmpty()) nombre = "usuario";
        ConfirmDialog.mostrar(
                this,
                getString(R.string.logout_confirmar_titulo),
                getString(R.string.logout_confirmar_mensaje, nombre.trim()),
                true,
                this::cerrarSesion);
    }

    private void cerrarSesion() {
        if (cerrandoSesion) return;
        cerrandoSesion = true;
        String nroActual = AppUtils.app(this).getDeviceRegistry().getNroRegistro();
        authRepository.logout(() -> renovarSesionDispositivoTrasLogout(nroActual));
    }

    private void renovarSesionDispositivoTrasLogout(String nroActual) {
        AsyncRunner.ejecutar(
                () -> DeviceRegistrationFactory.crear(this),
                new AsyncRunner.OnResultado<RegistrarDispositivoRequest>() {
                    @Override
                    public void onExito(RegistrarDispositivoRequest request) {
                        enviarRenovacionYSalir(request, nroActual);
                    }

                    @Override
                    public void onError(Exception error) {
                        enviarRenovacionYSalir(DeviceRegistrationFactory.crear(MenuActivity.this), nroActual);
                    }
                }
        );
    }

    private void enviarRenovacionYSalir(RegistrarDispositivoRequest request, String nroActual) {
        authRepository.renovarSesionDispositivo(request, nroActual, new ResultCallback<DispositivoRegistradoResponse>() {
            @Override
            public void onSuccess(DispositivoRegistradoResponse data) {
                AppUtils.app(MenuActivity.this).getDeviceRegistry().guardar(data.nroRegistro, data.autorizado);
                irALogin();
            }

            @Override
            public void onError(String mensaje) {
                irALogin();
            }
        });
    }

    private void irALogin() {
        Intent intent = new Intent(MenuActivity.this, LoginActivity.class);
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_CLEAR_TASK);
        startActivity(intent);
        finish();
    }

    private static String formatearSubtitulo(String empresa, String sucursal) {
        String emp = empresa != null ? empresa.trim() : "";
        String suc = sucursal != null ? sucursal.trim() : "";
        if (!emp.isEmpty() && !suc.isEmpty()) return emp + " · " + suc;
        if (!emp.isEmpty()) return emp;
        return suc;
    }

    static String inicialesDe(String nombreCompleto) {
        if (nombreCompleto == null || nombreCompleto.trim().isEmpty()) return "?";
        String[] partes = nombreCompleto.trim().split("\\s+");
        if (partes.length == 1) {
            String p = partes[0];
            return p.substring(0, Math.min(2, p.length())).toUpperCase(Locale.ROOT);
        }
        char a = Character.toUpperCase(partes[0].charAt(0));
        char b = Character.toUpperCase(partes[partes.length - 1].charAt(0));
        return "" + a + b;
    }
}
