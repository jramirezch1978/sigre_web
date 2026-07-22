package pe.com.hermes.appmobile.ui.login;

import android.app.AlertDialog;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;
import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.config.ServerProfile;
import pe.com.hermes.appmobile.data.device.DeviceRegistrationFactory;
import pe.com.hermes.appmobile.data.device.DeviceRegistry;
import pe.com.hermes.appmobile.data.ping.ConnectionMonitor;
import pe.com.hermes.appmobile.data.ping.PingHistoryStore;
import pe.com.hermes.appmobile.data.ping.PingSample;
import pe.com.hermes.appmobile.data.remote.dto.DispositivoRegistradoResponse;
import pe.com.hermes.appmobile.data.remote.dto.EmpresaUsuarioDto;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;
import pe.com.hermes.appmobile.data.remote.dto.RegistrarDispositivoRequest;
import pe.com.hermes.appmobile.data.remote.dto.SucursalDto;
import pe.com.hermes.appmobile.data.repository.AuthRepository;
import pe.com.hermes.appmobile.data.repository.ResultCallback;
import pe.com.hermes.appmobile.databinding.ActivityLoginBinding;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter;
import pe.com.hermes.appmobile.ui.menu.MenuActivity;
import pe.com.hermes.appmobile.ui.ping.PingMonitorDialog;
import pe.com.hermes.appmobile.ui.servidor.ServidorListActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.appmobile.util.AppVersion;
import pe.com.hermes.common.util.AsyncRunner;

/**
 * Login completo en una sola ventana: credenciales → modal empresa → modal sucursal.
 * Si se cancela cualquiera de los dos modales, se limpian inputs, muere la sesión JWT
 * y se registra un nuevo inicio de sesión de dispositivo (nuevo nro_registro).
 */
public class LoginActivity extends AppCompatActivity implements ConnectionMonitor.Listener {

    private ActivityLoginBinding binding;
    private AuthRepository authRepository;
    private final PingHistoryStore pingHistory = new PingHistoryStore();
    private ConnectionMonitor connectionMonitor;

    private AlertDialog dialogSeleccion;
    private SimpleListAdapter adapterSeleccion;
    private ProgressBar progressSeleccion;
    private TextView tvVacioSeleccion;
    private TextView tvTituloDialog;

    private List<EmpresaUsuarioDto> empresas = Collections.emptyList();
    private EmpresaUsuarioDto empresaElegida;
    private boolean cancelandoSeleccion;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityLoginBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        authRepository = new AuthRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());
        connectionMonitor = new ConnectionMonitor(AppUtils.app(this).getApiClient(), pingHistory, this);

        binding.tvVersion.setText(AppVersion.etiqueta(this));

        binding.btnLogin.setOnClickListener(v -> intentarLogin());
        binding.btnCambiarServidor.setOnClickListener(v -> mostrarServidorDefault());
        binding.tvServidorNombre.setOnClickListener(v -> mostrarServidorDefault());
        binding.btnRefrescarServidor.setOnClickListener(v -> refrescarServidorYSesion());
        binding.badgeConexion.setOnClickListener(v -> mostrarDiagnosticoConexion());

        aplicarEstadoDispositivo();
    }

    @Override
    protected void onResume() {
        super.onResume();
        actualizarServidorInfo();
        aplicarEstadoDispositivo();
        iniciarMonitoreoConexion();
    }

    @Override
    protected void onPause() {
        super.onPause();
        detenerMonitoreoConexion();
    }

    private void actualizarServidorInfo() {
        ServerProfile def = AppUtils.app(this).getConfig().obtenerDefault();
        binding.tvServidorNombre.setText(def != null ? def.getNombre() : "(sin configurar)");
    }

    private void iniciarMonitoreoConexion() {
        detenerMonitoreoConexion();
        if (AppUtils.app(this).getConfig().obtenerDefault() == null) {
            binding.tvBadgeConexion.setText("Sin servidor");
            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_neutral);
            return;
        }
        binding.tvBadgeConexion.setText("Verificando…");
        binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_neutral);
        connectionMonitor.start();
    }

    private void detenerMonitoreoConexion() {
        if (connectionMonitor != null) {
            connectionMonitor.stop();
        }
    }

    @Override
    public void onConnectionStatusChanged(boolean connected, Long latencyMs) {
        if (connected && latencyMs != null) {
            binding.tvBadgeConexion.setText("Conectado (" + latencyMs + "ms)");
            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_success);
        } else {
            binding.tvBadgeConexion.setText("Sin conexión");
            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_danger);
        }
    }

    @Override
    public void onPingUpdated(PingSample sample) {
        // El historial ya se guarda en ConnectionMonitor; el dialog lee de ahí.
    }

    private void mostrarDiagnosticoConexion() {
        if (AppUtils.app(this).getConfig().obtenerDefault() == null) {
            AppUtils.toast(this, "Configure un servidor remoto primero.");
            return;
        }
        new PingMonitorDialog(this, pingHistory).show();
    }

    private void mostrarServidorDefault() {
        if (AppUtils.app(this).getConfig().listarServidores().isEmpty()) {
            irAListadoServidores();
            return;
        }

        View view = getLayoutInflater().inflate(R.layout.dialog_server_default, null);
        ServerProfile def = AppUtils.app(this).getConfig().obtenerDefault();

        ((TextView) view.findViewById(R.id.tvNombre)).setText(def != null ? def.getNombre() : "—");
        ((TextView) view.findViewById(R.id.tvHostIp)).setText(def != null ? def.getHostIp() : "—");
        ((TextView) view.findViewById(R.id.tvPort)).setText(def != null ? def.getPort() : "—");
        ((TextView) view.findViewById(R.id.tvProtocolo)).setText(def != null ? def.getProtocolo() : "—");

        AlertDialog dialog = new AlertDialog.Builder(this)
                .setView(view)
                .setCancelable(false)
                .create();

        view.findViewById(R.id.btnCerrar).setOnClickListener(v -> dialog.dismiss());
        view.findViewById(R.id.btnListado).setOnClickListener(v -> {
            dialog.dismiss();
            irAListadoServidores();
        });

        dialog.show();
    }

    private void irAListadoServidores() {
        startActivity(new Intent(this, ServidorListActivity.class));
    }

    private void refrescarServidorYSesion() {
        actualizarServidorInfo();
        iniciarMonitoreoConexion();

        if (AppUtils.app(this).getConfig().listarServidores().isEmpty()) {
            AppUtils.toast(this, "No hay perfiles de conexión. Cree uno nuevo.");
            irAListadoServidores();
            return;
        }
        if (AppUtils.app(this).getConfig().obtenerDefault() == null) {
            AppUtils.toast(this, "Marque un servidor como predeterminado.");
            irAListadoServidores();
            return;
        }

        registrarNuevaSesionDispositivo();
    }

    private void registrarNuevaSesionDispositivo() {
        mostrarCargandoRefrescar(true);
        AsyncRunner.ejecutar(
                () -> DeviceRegistrationFactory.crear(this),
                new AsyncRunner.OnResultado<RegistrarDispositivoRequest>() {
                    @Override
                    public void onExito(RegistrarDispositivoRequest request) {
                        enviarRegistroDispositivo(request);
                    }

                    @Override
                    public void onError(Exception error) {
                        enviarRegistroDispositivo(DeviceRegistrationFactory.crear(LoginActivity.this));
                    }
                }
        );
    }

    private void enviarRegistroDispositivo(RegistrarDispositivoRequest request) {
        authRepository.registrarDispositivo(request, new ResultCallback<DispositivoRegistradoResponse>() {
            @Override
            public void onSuccess(DispositivoRegistradoResponse data) {
                mostrarCargandoRefrescar(false);
                AppUtils.app(LoginActivity.this).getDeviceRegistry().guardar(data.nroRegistro, data.autorizado);
                aplicarEstadoDispositivo();
                if (!data.autorizado) {
                    AppUtils.toast(LoginActivity.this, getString(R.string.login_dispositivo_no_autorizado));
                } else {
                    String nro = data.nroRegistro != null ? data.nroRegistro : "";
                    AppUtils.toast(LoginActivity.this,
                            getString(R.string.splash_dispositivo_ok_nro, nro));
                }
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargandoRefrescar(false);
                AppUtils.toast(LoginActivity.this, getString(R.string.splash_error_registro));
            }
        });
    }

    private void aplicarEstadoDispositivo() {
        DeviceRegistry registry = AppUtils.app(this).getDeviceRegistry();
        boolean listo = registry.isDispositivoListo();
        binding.btnLogin.setEnabled(listo && !cancelandoSeleccion);
        binding.etUsuario.setEnabled(listo);
        binding.etClave.setEnabled(listo);
        String nro = registry.getNroRegistro();
        if (nro != null && !nro.isBlank()) {
            binding.tvNroRegistro.setText(getString(R.string.login_nro_registro, nro));
        } else {
            binding.tvNroRegistro.setText(R.string.login_nro_registro_pendiente);
        }
    }

    private void intentarLogin() {
        String usuario = binding.etUsuario.getText() != null ? binding.etUsuario.getText().toString().trim() : "";
        String clave = binding.etClave.getText() != null ? binding.etClave.getText().toString() : "";

        if (usuario.isEmpty() || clave.isEmpty()) {
            AppUtils.toast(this, getString(R.string.login_error_campos));
            return;
        }
        if (AppUtils.app(this).getConfig().obtenerDefault() == null) {
            AppUtils.toast(this, "Configure un servidor remoto antes de ingresar.");
            irAListadoServidores();
            return;
        }

        DeviceRegistry registry = AppUtils.app(this).getDeviceRegistry();
        if (!registry.isDispositivoListo()) {
            AppUtils.toast(this, registry.getNroRegistro() == null
                    ? getString(R.string.login_dispositivo_no_listo)
                    : getString(R.string.login_dispositivo_no_autorizado));
            return;
        }

        mostrarCargando(true);
        ejecutarLogin(usuario, clave, registry.getNroRegistro());
    }

    private void mostrarCargandoRefrescar(boolean cargando) {
        binding.progressRefrescarServidor.setVisibility(cargando ? View.VISIBLE : View.GONE);
        binding.btnRefrescarServidor.setEnabled(!cargando);
    }

    private void ejecutarLogin(String usuario, String clave, String nroRegistro) {
        authRepository.login(usuario, clave, nroRegistro, new ResultCallback<LoginResponse>() {
            @Override
            public void onSuccess(LoginResponse data) {
                mostrarCargando(false);
                pingHistory.clear();
                empresaElegida = null;
                empresas = Collections.emptyList();
                mostrarDialogSeleccion(getString(R.string.empresa_titulo));
                cargarEmpresas();
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargando(false);
                AppUtils.toast(LoginActivity.this, mensaje != null ? mensaje : getString(R.string.login_error_credenciales));
            }
        });
    }

    private void mostrarDialogSeleccion(String titulo) {
        if (dialogSeleccion != null && dialogSeleccion.isShowing()) {
            if (tvTituloDialog != null) {
                tvTituloDialog.setText(titulo);
            }
            if (adapterSeleccion != null) {
                adapterSeleccion.actualizar(Collections.emptyList());
            }
            setEstadoDialog(true, false, null);
            return;
        }

        View view = getLayoutInflater().inflate(R.layout.dialog_seleccion_lista, null);
        tvTituloDialog = view.findViewById(R.id.tvTituloDialog);
        progressSeleccion = view.findViewById(R.id.progressSeleccion);
        tvVacioSeleccion = view.findViewById(R.id.tvVacioSeleccion);
        RecyclerView recycler = view.findViewById(R.id.recyclerSeleccion);

        tvTituloDialog.setText(titulo);
        recycler.setLayoutManager(new LinearLayoutManager(this));
        adapterSeleccion = new SimpleListAdapter(this::onItemSeleccionClick);
        recycler.setAdapter(adapterSeleccion);

        dialogSeleccion = new AlertDialog.Builder(this)
                .setView(view)
                .setCancelable(true)
                .setOnCancelListener(d -> cancelarSeleccionYReiniciarLogin())
                .create();

        view.findViewById(R.id.btnCancelarSeleccion).setOnClickListener(v -> cancelarSeleccionYReiniciarLogin());
        dialogSeleccion.show();
        setEstadoDialog(true, false, null);
    }

    private void setEstadoDialog(boolean cargando, boolean vacio, String mensajeVacio) {
        if (progressSeleccion != null) {
            progressSeleccion.setVisibility(cargando ? View.VISIBLE : View.GONE);
        }
        if (tvVacioSeleccion != null) {
            tvVacioSeleccion.setVisibility(!cargando && vacio ? View.VISIBLE : View.GONE);
            if (mensajeVacio != null) {
                tvVacioSeleccion.setText(mensajeVacio);
            }
        }
    }

    private void onItemSeleccionClick(SimpleItem item) {
        if (cancelandoSeleccion) {
            return;
        }
        if (empresaElegida == null) {
            EmpresaUsuarioDto empresa = null;
            for (EmpresaUsuarioDto e : empresas) {
                if (e.empresaId == item.id) {
                    empresa = e;
                    break;
                }
            }
            if (empresa == null) {
                return;
            }
            empresaElegida = empresa;
            cargarSucursales(empresa);
            return;
        }
        seleccionarSucursal(item.id);
    }

    private void cargarEmpresas() {
        setEstadoDialog(true, false, null);
        authRepository.listarEmpresas(new ResultCallback<List<EmpresaUsuarioDto>>() {
            @Override
            public void onSuccess(List<EmpresaUsuarioDto> lista) {
                if (cancelandoSeleccion) {
                    return;
                }
                empresas = lista != null ? lista : Collections.emptyList();
                List<SimpleItem> items = new ArrayList<>();
                for (EmpresaUsuarioDto e : empresas) {
                    String titulo = e.razonSocial != null
                            ? e.razonSocial
                            : (e.codigo != null ? e.codigo : "Empresa " + e.empresaId);
                    items.add(new SimpleItem(e.empresaId, titulo, e.ruc));
                }
                if (adapterSeleccion != null) {
                    adapterSeleccion.actualizar(items);
                }
                setEstadoDialog(false, items.isEmpty(), "No tiene empresas asignadas.");
                if (items.isEmpty()) {
                    AppUtils.toast(LoginActivity.this, "No tiene empresas asignadas.");
                }
            }

            @Override
            public void onError(String mensaje) {
                if (cancelandoSeleccion) {
                    return;
                }
                setEstadoDialog(false, true, mensaje != null ? mensaje : "No se pudieron cargar las empresas");
                AppUtils.toast(LoginActivity.this, mensaje != null ? mensaje : "No se pudieron cargar las empresas");
            }
        });
    }

    private void cargarSucursales(EmpresaUsuarioDto empresa) {
        mostrarDialogSeleccion(getString(R.string.empresa_sucursal_titulo));
        setEstadoDialog(true, false, null);
        authRepository.listarSucursales(empresa.empresaId, new ResultCallback<List<SucursalDto>>() {
            @Override
            public void onSuccess(List<SucursalDto> sucursales) {
                if (cancelandoSeleccion) {
                    return;
                }
                if (sucursales == null || sucursales.isEmpty()) {
                    setEstadoDialog(false, true, "La empresa no tiene sucursales asignadas.");
                    AppUtils.toast(LoginActivity.this, "La empresa no tiene sucursales asignadas.");
                    return;
                }
                if (sucursales.size() == 1) {
                    seleccionarSucursal(sucursales.get(0).id);
                    return;
                }
                List<SimpleItem> items = new ArrayList<>();
                for (SucursalDto s : sucursales) {
                    items.add(new SimpleItem(
                            s.id,
                            s.nombre != null ? s.nombre : (s.codigo != null ? s.codigo : "Sucursal " + s.id)));
                }
                if (adapterSeleccion != null) {
                    adapterSeleccion.actualizar(items);
                }
                setEstadoDialog(false, false, null);
            }

            @Override
            public void onError(String mensaje) {
                if (cancelandoSeleccion) {
                    return;
                }
                setEstadoDialog(false, true, mensaje != null ? mensaje : "No se pudieron cargar las sucursales");
                AppUtils.toast(LoginActivity.this, mensaje != null ? mensaje : "No se pudieron cargar las sucursales");
            }
        });
    }

    private void seleccionarSucursal(long sucursalId) {
        if (empresaElegida == null || cancelandoSeleccion) {
            return;
        }
        setEstadoDialog(true, false, null);
        authRepository.seleccionarEmpresa(empresaElegida.empresaId, sucursalId, new ResultCallback<LoginResponse>() {
            @Override
            public void onSuccess(LoginResponse data) {
                if (cancelandoSeleccion) {
                    return;
                }
                cerrarDialogSeleccion();
                startActivity(new Intent(LoginActivity.this, MenuActivity.class));
                finish();
            }

            @Override
            public void onError(String mensaje) {
                if (cancelandoSeleccion) {
                    return;
                }
                setEstadoDialog(false, false, null);
                AppUtils.toast(LoginActivity.this, mensaje != null ? mensaje : "No se pudo completar el acceso");
            }
        });
    }

    /**
     * Cancelar empresa o sucursal: limpia inputs, cierra JWT y registra una nueva sesión
     * de dispositivo (la anterior queda con fec_logout).
     */
    private void cancelarSeleccionYReiniciarLogin() {
        if (cancelandoSeleccion) {
            return;
        }
        cancelandoSeleccion = true;
        empresaElegida = null;
        empresas = Collections.emptyList();
        cerrarDialogSeleccion();
        limpiarInputsLogin();

        String nroActual = AppUtils.app(this).getDeviceRegistry().getNroRegistro();
        AppUtils.toast(this, getString(R.string.login_seleccion_cancelada));

        Runnable renovar = () -> renovarSesionTrasCancelar(nroActual);
        String token = AppUtils.app(this).getSession().getAccessToken();
        if (token != null && !token.isBlank()) {
            authRepository.logout(renovar);
        } else {
            AppUtils.app(this).getSession().limpiar();
            renovar.run();
        }
    }

    private void renovarSesionTrasCancelar(String nroActual) {
        mostrarCargando(true);
        AsyncRunner.ejecutar(
                () -> DeviceRegistrationFactory.crear(this),
                new AsyncRunner.OnResultado<RegistrarDispositivoRequest>() {
                    @Override
                    public void onExito(RegistrarDispositivoRequest request) {
                        enviarRenovacionSesion(request, nroActual);
                    }

                    @Override
                    public void onError(Exception error) {
                        enviarRenovacionSesion(DeviceRegistrationFactory.crear(LoginActivity.this), nroActual);
                    }
                }
        );
    }

    private void enviarRenovacionSesion(RegistrarDispositivoRequest request, String nroActual) {
        authRepository.renovarSesionDispositivo(request, nroActual, new ResultCallback<DispositivoRegistradoResponse>() {
            @Override
            public void onSuccess(DispositivoRegistradoResponse data) {
                AppUtils.app(LoginActivity.this).getDeviceRegistry().guardar(data.nroRegistro, data.autorizado);
                cancelandoSeleccion = false;
                mostrarCargando(false);
                aplicarEstadoDispositivo();
                String nro = data.nroRegistro != null ? data.nroRegistro : "";
                AppUtils.toast(LoginActivity.this, getString(R.string.splash_dispositivo_ok_nro, nro));
            }

            @Override
            public void onError(String mensaje) {
                // Fallback: intentar registrar normalmente (puede reutilizar si no cerró).
                authRepository.registrarDispositivo(request, new ResultCallback<DispositivoRegistradoResponse>() {
                    @Override
                    public void onSuccess(DispositivoRegistradoResponse data) {
                        AppUtils.app(LoginActivity.this).getDeviceRegistry().guardar(data.nroRegistro, data.autorizado);
                        cancelandoSeleccion = false;
                        mostrarCargando(false);
                        aplicarEstadoDispositivo();
                    }

                    @Override
                    public void onError(String msg) {
                        cancelandoSeleccion = false;
                        mostrarCargando(false);
                        aplicarEstadoDispositivo();
                        AppUtils.toast(LoginActivity.this, getString(R.string.splash_error_registro));
                    }
                });
            }
        });
    }

    private void limpiarInputsLogin() {
        binding.etUsuario.setText("");
        binding.etClave.setText("");
        binding.etUsuario.requestFocus();
    }

    private void cerrarDialogSeleccion() {
        if (dialogSeleccion != null) {
            dialogSeleccion.setOnCancelListener(null);
            if (dialogSeleccion.isShowing()) {
                dialogSeleccion.dismiss();
            }
            dialogSeleccion = null;
        }
        adapterSeleccion = null;
        progressSeleccion = null;
        tvVacioSeleccion = null;
        tvTituloDialog = null;
    }

    private void mostrarCargando(boolean cargando) {
        binding.progressLogin.setVisibility(cargando ? View.VISIBLE : View.GONE);
        binding.btnLogin.setEnabled(!cargando
                && !cancelandoSeleccion
                && AppUtils.app(this).getDeviceRegistry().isDispositivoListo());
    }
}
