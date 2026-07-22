package pe.com.hermes.appmobile.ui.login

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.launch
import pe.com.hermes.appmobile.data.repository.AuthRepository
import pe.com.hermes.appmobile.databinding.ActivityLoginBinding
import pe.com.hermes.appmobile.ui.empresa.SeleccionEmpresaActivity
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

        binding.etServidor.setText(app.config.apiBaseUrl)

        binding.btnLogin.setOnClickListener { intentarLogin() }
    }

    private fun intentarLogin() {
        val usuario = binding.etUsuario.text?.toString()?.trim().orEmpty()
        val clave = binding.etClave.text?.toString().orEmpty()
        val servidor = binding.etServidor.text?.toString()?.trim().orEmpty()

        if (usuario.isEmpty() || clave.isEmpty()) {
            toast(getString(pe.com.hermes.appmobile.R.string.login_error_campos))
            return
        }
        if (servidor.isNotEmpty()) app.config.apiBaseUrl = servidor

        mostrarCargando(true)
        lifecycleScope.launch {
            val resultado = authRepository.login(usuario, clave)
            mostrarCargando(false)
            resultado.onSuccess {
                startActivity(Intent(this@LoginActivity, SeleccionEmpresaActivity::class.java))
                finish()
            }.onFailure { err ->
                toast(err.message ?: getString(pe.com.hermes.appmobile.R.string.login_error_credenciales))
            }
        }
    }

    private fun mostrarCargando(cargando: Boolean) {
        binding.progressLogin.visibility = if (cargando) android.view.View.VISIBLE else android.view.View.GONE
        binding.btnLogin.isEnabled = !cargando
    }
}
