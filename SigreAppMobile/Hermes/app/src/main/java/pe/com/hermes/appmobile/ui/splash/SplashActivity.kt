package pe.com.hermes.appmobile.ui.splash

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import pe.com.hermes.appmobile.databinding.ActivitySplashBinding
import pe.com.hermes.appmobile.ui.login.LoginActivity
import pe.com.hermes.appmobile.ui.menu.MenuActivity
import pe.com.hermes.appmobile.util.ConnectivityChecker
import pe.com.hermes.appmobile.util.app

/**
 * Pantalla de inicio (logo Hermes) — hace la carga real en segundo plano antes de decidir
 * a dónde navegar (a diferencia de FastSales, donde este trabajo vivía embebido al inicio
 * de LoginActivity.onCreate/continueAfterUpdateCheck):
 *   1) Asegura/lee el archivo de configuración (siembra el default de assets si es la 1ra vez).
 *   2) Si hay un servidor por defecto, hace un ping TCP corto (no bloqueante para la navegación).
 *   3) Decide destino: Menú (sesión completa) o Login.
 */
class SplashActivity : AppCompatActivity() {

    private lateinit var binding: ActivitySplashBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivitySplashBinding.inflate(layoutInflater)
        setContentView(binding.root)

        lifecycleScope.launch {
            binding.tvEstado.text = "Cargando configuración…"
            val default = withContext(Dispatchers.IO) { app.config.obtenerDefault() }

            if (default != null) {
                binding.tvEstado.text = "Verificando conexión con ${default.nombre}…"
                val resultado = withContext(Dispatchers.IO) { ConnectivityChecker.probar(default) }
                binding.tvEstado.text = if (resultado.conectado) "Conectado (${resultado.latenciaMs} ms)" else "Sin conexión — continuando…"
            } else {
                binding.tvEstado.text = "Sin servidor configurado"
            }

            val destino = if (app.session.sesionCompleta()) MenuActivity::class.java else LoginActivity::class.java
            startActivity(Intent(this@SplashActivity, destino))
            finish()
        }
    }
}
