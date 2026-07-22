package pe.com.hermes.appmobile.ui.login

import android.app.AlertDialog
import android.content.Intent
import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import pe.com.hermes.appmobile.R
import pe.com.hermes.appmobile.data.repository.AuthRepository
import pe.com.hermes.appmobile.databinding.ActivityLoginBinding
import pe.com.hermes.appmobile.ui.empresa.SeleccionEmpresaActivity
import pe.com.hermes.appmobile.ui.servidor.ServidorListActivity
import pe.com.hermes.appmobile.util.app
import pe.com.hermes.appmobile.util.toast

/** Pantalla de ingreso. El login SIEMPRE devuelve un token temporal (ver AuthServiceImpl.login) —
 * la selección de empresa/sucursal ocurre siempre después, nunca se salta. */
class LoginActivity : AppCompatActivity() {

    private lateinit var binding: ActivityLoginBinding
    private lateinit var authRepository: AuthRepository

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityLoginBinding.inflate(layoutInflater)
        setContentView(binding.root)

        authRepository = AuthRepository(app.apiClient, app.session)

        binding.btnLogin.setOnClickListener { intentarLogin() }
        binding.btnServidor.setOnClickListener { mostrarServidorDefault() }
    }

    override fun onResume() {
        super.onResume()
        actualizarBotonServidor()
    }

    private fun actualizarBotonServidor() {
        val default = app.config.obtenerDefault()
        binding.btnServidor.text = if (default != null) "Servidor: ${default.nombre}" else "Servidor: (sin configurar)"
    }

    /** Equivalente a ImplServerRemote.dialogServerDefault() de FastSales: info de solo lectura
     * del servidor activo + botón para ir al listado completo. */
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
