package pe.com.hermes.appmobile

import android.app.Application
import pe.com.hermes.appmobile.data.config.AppConfig
import pe.com.hermes.appmobile.data.remote.ApiClient
import pe.com.hermes.appmobile.data.session.SessionManager
import pe.com.hermes.common.ui.EdgeToEdgeHelper

/**
 * Application singleton — expone la sesión (token, empresa, sucursal), la configuración
 * de conexión (archivo appconfig.json) y el cliente HTTP a toda la app.
 */
class SigreApplication : Application() {

    lateinit var session: SessionManager
        private set

    lateinit var config: AppConfig
        private set

    lateinit var apiClient: ApiClient
        private set

    override fun onCreate() {
        super.onCreate()
        session = SessionManager(this)
        config = AppConfig(this)
        apiClient = ApiClient(config, session)

        // Edge-to-edge obligatorio desde Android 15 (targetSdk 35) — desde la libreria
        // reutilizable common-ui, se aplica a todas las Activities automaticamente.
        EdgeToEdgeHelper.registrarGlobal(this)
    }
}
