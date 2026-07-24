package pe.com.hermes.appmobile.ui.login;

import android.app.AlertDialog;
import android.content.Intent;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
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
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.databinding.ActivityLoginBinding;
import pe.com.hermes.appmobile.ui.common.SeleccionOpcionAdapter;
import pe.com.hermes.appmobile.ui.common.SimpleItem;
import pe.com.hermes.appmobile.ui.bienvenida.BienvenidaActivity;
import pe.com.hermes.appmobile.ui.ping.PingMonitorDialog;
import pe.com.hermes.appmobile.ui.servidor.ServidorListActivity;
import pe.com.hermes.appmobile.util.AppUtils;
import pe.com.hermes.appmobile.util.AppVersion;
import pe.com.hermes.common.ui.ValidInputHelper;
import pe.com.hermes.common.util.AsyncRunner;
import pe.com.hermes.common.validation.InputValidators;

/**
 * Login completo en una sola ventana: credenciales → modal empresa → modal sucursal.
 * Si se cancela cualquiera de los dos modales, se limpian inputs, muere la sesión JWT
 * y se registra un nuevo inicio de sesión de dispositivo (nuevo nro_registro).
 * La verificación de Google Play Update ocurre en el splash.
 */
public class LoginActivity extends AppCompatActivity implements ConnectionMonitor.Listener {

    private ActivityLoginBinding binding;
    private AuthRepository authRepository;
    private final PingHistoryStore pingHistory = new PingHistoryStore();
    private ConnectionMonitor connectionMonitor;

    private AlertDialog dialogSeleccion;
    private SeleccionOpcionAdapter adapterSeleccion;
    private ProgressBar progressSeleccion;
    private View grupoVacioSeleccion;
    private TextView tvVacioMensaje;
    private TextView tvTituloDialog;
    private TextView tvSubtituloDialog;
    private TextView tvPasoDialog;

    private List<EmpresaUsuarioDto> empresas = Collections.emptyList();
    private EmpresaUsuarioDto empresaElegida;
    private boolean cancelandoSeleccion;
    private String usuarioLogin;
    private String claveLogin;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        binding = ActivityLoginBinding.inflate(getLayoutInflater());
        setContentView(binding.getRoot());

        authRepository = new AuthRepository(AppUtils.app(this).getApiClient(), AppUtils.app(this).getSession());
        connectionMonitor = new ConnectionMonitor(AppUtils.app(this).getApiClient(), pingHistory, this);

        binding.tvVersion.setText(AppVersion.etiqueta(this));

        // Validación reutilizable (common-ui): usuario/correo + password
        ValidInputHelper.bindUsuarioOCorreo(binding.tilUsuario);
        ValidInputHelper.bindPassword(binding.tilClave, 1);

        binding.btnLogin.setOnClickListener(v -> intentarLogin());
        binding.btnCambiarServidor.setOnClickListener(v -> mostrarServidorDefault());
        binding.tvServidorNombre.setOnClickListener(v -> mostrarServidorDefault());
        binding.btnRefrescarServidor.setOnClickListener(v -> refrescarServidorYSesion());
        binding.badgeConexion.setOnClickListener(v -> mostrarDiagnosticoConexion());

        precargarCredencialesCifradas();
        aplicarEstadoDispositivo();
    }

    /** Rellena usuario/clave desde el almacén cifrado si el usuario guardó sesión. */
    private void precargarCredencialesCifradas() {
        SessionManager session = AppUtils.app(this).getSession();
        if (!session.tieneCredencialesGuardadas()) {
            return;
        }
        binding.etUsuario.setText(session.getLoginUsuario());
        binding.etClave.setText(session.getLoginPassword());
        binding.switchGuardarSesion.setChecked(true);
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
        ValidInputHelper.setDisplayValid(binding.tvServidorNombre, def != null);
    }

    private void iniciarMonitoreoConexion() {
        detenerMonitoreoConexion();
        if (AppUtils.app(this).getConfig().obtenerDefault() == null) {
            mostrarBadgeConexion(false, "Sin servidor", null);
            return;
        }
        mostrarBadgeConexion(false, "Verificando…", null);
        connectionMonitor.start();
    }

    private void mostrarBadgeConexion(boolean conectado, String texto, Long latencyMs) {
        if (conectado) {
            binding.badgeConexion.setBackgroundResource(R.drawable.badge_connected_bg);
            binding.ivEstadoConexion.setImageResource(R.drawable.ic_wifi_connected);
            binding.tvBadgeConexion.setTextColor(Color.parseColor("#4CAF50"));
            if (latencyMs != null) {
                binding.tvBadgeConexion.setText("Conectado (" + latencyMs + "ms)");
            } else {
                binding.tvBadgeConexion.setText(texto != null ? texto : "Conectado");
            }
        } else {
            binding.badgeConexion.setBackgroundResource(R.drawable.badge_disconnected_bg);
            binding.ivEstadoConexion.setImageResource(R.drawable.ic_wifi_disconnected);
            binding.tvBadgeConexion.setTextColor(Color.parseColor("#F44336"));
            binding.tvBadgeConexion.setText(texto != null ? texto : "Sin conexión");
        }
    }

    private void detenerMonitoreoConexion() {
        if (connectionMonitor != null) {
            connectionMonitor.stop();
        }
    }

    @Override
    public void onConnectionStatusChanged(boolean connected, Long latencyMs) {
        if (connected) {
            mostrarBadgeConexion(true, "Conectado", latencyMs);
        } else {
            mostrarBadgeConexion(false, "Sin conexión", null);
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
        boolean listo = registry.isDispositivoListo() && !cancelandoSeleccion;
        binding.btnLogin.setEnabled(listo);
        binding.etUsuario.setEnabled(registry.isDispositivoListo());
        binding.etClave.setEnabled(registry.isDispositivoListo());
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
        if (!InputValidators.usuarioOCorreo().isValid(usuario)) {
            AppUtils.toast(this, "Usuario o correo inválido");
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

        usuarioLogin = usuario;
        claveLogin = clave;
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
                mostrarDialogSeleccion(
                        getString(R.string.empresa_titulo),
                        getString(R.string.seleccion_empresa_ayuda),
                        getString(R.string.seleccion_paso_empresa));
                cargarEmpresas();
            }

            @Override
            public void onError(String mensaje) {
                mostrarCargando(false);
                AppUtils.toast(LoginActivity.this, mensaje != null ? mensaje : getString(R.string.login_error_credenciales));
            }
        });
    }

    private void mostrarDialogSeleccion(String titulo, String ayuda, String paso) {
        if (dialogSeleccion != null && dialogSeleccion.isShowing()) {
            if (tvTituloDialog != null) {
                tvTituloDialog.setText(titulo);
            }
            if (tvSubtituloDialog != null) {
                tvSubtituloDialog.setText(ayuda);
            }
            if (tvPasoDialog != null) {
                tvPasoDialog.setText(paso);
            }
            if (adapterSeleccion != null) {
                adapterSeleccion.actualizar(Collections.emptyList());
            }
            setEstadoDialog(true, false, null);
            return;
        }

        View view = getLayoutInflater().inflate(R.layout.dialog_seleccion_lista, null);
        tvTituloDialog = view.findViewById(R.id.tvTituloDialog);
        tvSubtituloDialog = view.findViewById(R.id.tvSubtituloDialog);
        tvPasoDialog = view.findViewById(R.id.tvPasoDialog);
        progressSeleccion = view.findViewById(R.id.progressSeleccion);
        grupoVacioSeleccion = view.findViewById(R.id.tvVacioSeleccion);
        tvVacioMensaje = view.findViewById(R.id.tvVacioMensaje);
        RecyclerView recycler = view.findViewById(R.id.recyclerSeleccion);

        tvTituloDialog.setText(titulo);
        tvSubtituloDialog.setText(ayuda);
        tvPasoDialog.setText(paso);
        recycler.setLayoutManager(new LinearLayoutManager(this));
        adapterSeleccion = new SeleccionOpcionAdapter(this::onItemSeleccionClick);
        recycler.setAdapter(adapterSeleccion);

        dialogSeleccion = new AlertDialog.Builder(this, R.style.Theme_Hermes_DialogSeleccion)
                .setView(view)
                .setCancelable(true)
                .setOnCancelListener(d -> cancelarSeleccionYReiniciarLogin())
                .create();

        view.findViewById(R.id.btnCancelarSeleccion).setOnClickListener(v -> cancelarSeleccionYReiniciarLogin());
        dialogSeleccion.show();

        Window window = dialogSeleccion.getWindow();
        if (window != null) {
            window.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            int ancho = (int) (getResources().getDisplayMetrics().widthPixels * 0.92f);
            window.setLayout(ancho, android.view.ViewGroup.LayoutParams.WRAP_CONTENT);
        }
        setEstadoDialog(true, false, null);
    }

    private void setEstadoDialog(boolean cargando, boolean vacio, String mensajeVacio) {
        if (progressSeleccion != null) {
            progressSeleccion.setVisibility(cargando ? View.VISIBLE : View.GONE);
        }
        if (grupoVacioSeleccion != null) {
            grupoVacioSeleccion.setVisibility(!cargando && vacio ? View.VISIBLE : View.GONE);
        }
        if (tvVacioMensaje != null && mensajeVacio != null) {
            tvVacioMensaje.setText(mensajeVacio);
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
        seleccionarSucursal(item.id, item.titulo);
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
                    String sub = e.ruc != null && !e.ruc.isBlank()
                            ? e.ruc
                            : (e.codigo != null ? e.codigo : null);
                    items.add(new SimpleItem(e.empresaId, titulo, sub));
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
        mostrarDialogSeleccion(
                getString(R.string.empresa_sucursal_titulo),
                getString(R.string.seleccion_sucursal_ayuda),
                getString(R.string.seleccion_paso_sucursal));
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
                    SucursalDto unica = sucursales.get(0);
                    String nombre = unica.nombre != null
                            ? unica.nombre
                            : (unica.codigo != null ? unica.codigo : "Sucursal " + unica.id);
                    seleccionarSucursal(unica.id, nombre);
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

    private void seleccionarSucursal(long sucursalId, String sucursalNombre) {
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
                SessionManager session = AppUtils.app(LoginActivity.this).getSession();
                session.enriquecerContextoEmpresaSucursal(
                        empresaElegida.empresaId,
                        empresaElegida.codigo,
                        empresaElegida.razonSocial,
                        empresaElegida.ruc,
                        sucursalId,
                        sucursalNombre);
                session.aplicarPreferenciaGuardarSesion(
                        binding.switchGuardarSesion.isChecked(),
                        usuarioLogin,
                        claveLogin);
                cerrarDialogSeleccion();
                startActivity(new Intent(LoginActivity.this, BienvenidaActivity.class));
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
        grupoVacioSeleccion = null;
        tvVacioMensaje = null;
        tvTituloDialog = null;
        tvSubtituloDialog = null;
        tvPasoDialog = null;
    }

    private void mostrarCargando(boolean cargando) {
        binding.progressLogin.setVisibility(cargando ? View.VISIBLE : View.GONE);
        binding.btnLogin.setEnabled(!cargando
                && !cancelandoSeleccion
                && AppUtils.app(this).getDeviceRegistry().isDispositivoListo());
    }
}
