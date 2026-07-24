package pe.com.hermes.appmobile;

import android.app.Application;
import pe.com.hermes.appmobile.data.config.AppConfig;
import pe.com.hermes.appmobile.data.device.DeviceRegistry;
import pe.com.hermes.appmobile.data.remote.ApiClient;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.common.ui.EdgeToEdgeHelper;

/**
 * Application singleton — expone la sesion (token, empresa, sucursal), la configuracion
 * de conexion (archivo appconfig.json) y el cliente HTTP a toda la app.
 */
public class SigreApplication extends Application {

    private SessionManager session;
    private AppConfig config;
    private ApiClient apiClient;
    private DeviceRegistry deviceRegistry;

    @Override
    public void onCreate() {
        super.onCreate();
        session = new SessionManager(this);
        config = new AppConfig(this);
        deviceRegistry = new DeviceRegistry(this);
        apiClient = new ApiClient(config, session, deviceRegistry);

        // Edge-to-edge obligatorio desde Android 15 (targetSdk 35) — desde la libreria
        // reutilizable common-ui, se aplica a todas las Activities automaticamente.
        EdgeToEdgeHelper.registrarGlobal(this);
    }

    public SessionManager getSession() { return session; }
    public AppConfig getConfig() { return config; }
    public ApiClient getApiClient() { return apiClient; }
    public DeviceRegistry getDeviceRegistry() { return deviceRegistry; }
}
