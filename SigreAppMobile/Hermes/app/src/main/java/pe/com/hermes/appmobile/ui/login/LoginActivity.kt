package pe.com.hermes.appmobile.ui.login

import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import pe.com.hermes.appmobile.BuildConfig
import pe.com.hermes.appmobile.R
import pe.com.hermes.appmobile.data.repository.AuthRepository
import pe.com.hermes.appmobile.databinding.ActivityLoginBinding
import pe.com.hermes.appmobile.ui.empresa.SeleccionEmpresaActivity
import pe.com.hermes.appmobile.ui.servidor.ServidorListActivity
import pe.com.hermes.appmobile.util.ConnectivityChecker
import pe.com.hermes.appmobile.util.app
import pe.com.hermes.appmobile.util.toast

/** Pantalla de ingreso. El login SIEMPRE devuelve un token temporal (ver AuthServiceImpl.login) —
 * la selección de empresa/sucursal ocurre siempre después, nunca se salta (a diferencia de
 * FastSales, cuya pantalla de login muestra tambien la ultima empresa cacheada: aqui no aplica
 * porque el listado real de empresas del usuario solo se conoce autenticado). */
class LoginActivity : AppCompatActivity() {

    private lateinit var binding: ActivityLoginBinding
    private lateinit var authRepository: AuthRepository
    private var monitoreoJob: Job? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLoginBinding.inflate(layoutInflater)
        setContentView(binding.root)

        authRepository = AuthRepository(app.apiClient, app.session)

        binding.tvVersion.text = "Versión: ${BuildConfig.VERSION_NAME}"

        binding.btnLogin.setOnClickListener { intentarLogin() }
        binding.btnCambiarServidor.setOnClickListener { mostrarServidorDefault() }
        binding.tvServidorNombre.setOnClickListener { mostrarServidorDefault() }
    }

    override fun onResume() {
        super.onResume()
        actualizarServidorInfo()
        iniciarMonitoreoConexion()
    }

    override fun onPause() {
        super.onPause()
        monitoreoJob?.cancel()
    }

    private fun actualizarServidorInfo() {
        val default = app.config.obtenerDefault()
        binding.tvServidorNombre.text = default?.nombre ?: "(sin configurar)"
    }

    /** Ping periodico al servidor por defecto mientras el Login esta visible — equivalente al
     * badge "Conectado (Xms)" y a iniciarMonitoreoConexion() de FastSales. */
    private fun iniciarMonitoreoConexion() {
        monitoreoJob?.cancel()
        monitoreoJob = lifecycleScope.launch {
            while (isActive) {
                actualizarBadgeConexion()
                delay(8000L)
            }
        }
    }

    private suspend fun actualizarBadgeConexion() {
        val default = app.config.obtenerDefault()
        if (default == null) {
            binding.tvBadgeConexion.text = "Sin servidor"
            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_neutral)
            return
        }
        binding.tvBadgeConexion.text = "Verificando…"
        binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_neutral)
        val resultado = withContext(Dispatchers.IO) { ConnectivityChecker.probar(default) }
        if (resultado.conectado) {
            binding.tvBadgeConexion.text = "Conectado (${resultado.latenciaMs}ms)"
            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_success)
        } else {
            binding.tvBadgeConexion.text = "Sin conexión"
            binding.badgeConexion.setBackgroundResource(R.drawable.bg_badge_danger)
        }
    }

    /** Equivalente a ImplServerRemote.dialogServerDefault() de FastSales: info de solo lectura
     * del servidor activo + botón para ir al listado completo (donde se añaden/editan perfiles). */
    private fun mostrarServidorDefault() {
        if (app.config.listarServidores().isEmpty()) {
            irAListadoServidores()
            return
        }

        val view = layoutInflater.inflate(R.layout.dialog_server_default, null)
        val default = app.config.obtenerDefault()

        view.findViewById<TextView>(R.id.tvNombre).text = default?.nombre ?: "—"
        view.findViewById<TextView>(R.id.tvHostIp).text = default?.hostIp ?: "—"
        view.findViewById<TextView>(R.id.tvPort).text = default?.port ?: "—"
        view.findViewById<TextView>(R.id.tvProtocolo).text = default?.protocolo ?: "—"

        val dialog = AlertDialog.Builder(this)
            .setView(view)
            .setCancelable(false)
            .create()

        view.findViewById<android.widget.Button>(R.id.btnCerrar).setOnClickListener { dialog.dismiss() }
        view.findViewById<android.widget.Button>(R.id.btnListado).setOnClickListener {
            dialog.dismiss()
            irAListadoServidores()
        }

        dialog.show()
    }

    private fun irAListadoServidores() {
        startActivity(Intent(this, ServidorListActivity::class.java))
    }

    private fun intentarLogin() {
        val usuario = binding.etUsuario.text?.toString()?.trim().orEmpty()
        val clave = binding.etClave.text?.toString().orEmpty()

        if (usuario.isEmpty() || clave.isEmpty()) {
            toast(getString(R.string.login_error_campos))
            return
        }
        if (app.config.obtenerDefault() == null) {
            toast("Configure un servidor remoto antes de ingresar.")
            irAListadoServidores()
            return
        }

        mostrarCargando(true)
        lifecycleScope.launch {
            val resultado = authRepository.login(usuario, clave)
            mostrarCargando(false)
            resultado.onSuccess {
                startActivity(Intent(this@LoginActivity, SeleccionEmpresaActivity::class.java))
                finish()
            }.onFailure { err ->
                toast(err.message ?: getString(R.string.login_error_credenciales))
            }
        }
    }

    private fun mostrarCargando(cargando: Boolean) {
        binding.progressLogin.visibility = if (cargando) android.view.View.VISIBLE else android.view.View.GONE
        binding.btnLogin.isEnabled = !cargando
    }
}
