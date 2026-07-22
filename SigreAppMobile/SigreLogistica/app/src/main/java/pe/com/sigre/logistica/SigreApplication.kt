package pe.com.sigre.logistica

import android.app.Application
import pe.com.sigre.logistica.data.remote.ApiClient
import pe.com.sigre.logistica.data.session.SessionManager

/**
 * Application singleton — equivalente moderno de GlobalClass en FastSales:
 * expone la sesión (token, empresa, sucursal) y el cliente HTTP a toda la app.
 */
class SigreApplication : Application() {

    lateinit var session: SessionManager
        private set

    lateinit var apiClient: ApiClient
        private set

    override fun onCreate() {
        super.onCreate()
        session = SessionManager(this)
        apiClient = ApiClient(session)
    }
}
