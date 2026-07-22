package pe.com.hermes.appmobile.ui.splash

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import pe.com.hermes.appmobile.databinding.ActivitySplashBinding
import pe.com.hermes.appmobile.ui.login.LoginActivity
import pe.com.hermes.appmobile.ui.menu.MenuActivity
import pe.com.hermes.appmobile.util.app

private const val DURACION_MS = 900L

/** Pantalla de inicio (logo Hermes) — decide si va a Menú (sesión completa) o Login. */
class SplashActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val binding = ActivitySplashBinding.inflate(layoutInflater)
        setContentView(binding.root)

        Handler(Looper.getMainLooper()).postDelayed({
            val destino = if (app.session.sesionCompleta()) MenuActivity::class.java else LoginActivity::class.java
            startActivity(Intent(this, destino))
            finish()
        }, DURACION_MS)
    }
}
