package pe.com.hermes.appmobile.ui.menu

import android.content.Intent
import android.os.Bundle
import android.view.Menu
import android.view.MenuItem
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import kotlinx.coroutines.launch
import pe.com.hermes.appmobile.R
import pe.com.hermes.appmobile.data.repository.AuthRepository
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding
import pe.com.hermes.appmobile.ui.almacen.AlmacenOpcionesActivity
import pe.com.hermes.appmobile.ui.common.SimpleItem
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter
import pe.com.hermes.appmobile.ui.compras.ComprasOpcionesActivity
import pe.com.hermes.appmobile.ui.login.LoginActivity
import pe.com.hermes.appmobile.util.app

private const val ID_ALMACEN = 1L
private const val ID_COMPRAS = 2L

/** Menú principal: por ahora Almacén y Compras (logística), como pidió el usuario. */
class MenuActivity : AppCompatActivity() {

    private lateinit var binding: ActivityGenericListBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityGenericListBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.toolbar.title = "${getString(R.string.menu_titulo)} — ${app.session.empresaNombre ?: ""}"
        setSupportActionBar(binding.toolbar)

        binding.recyclerView.layoutManager = LinearLayoutManager(this)
        binding.recyclerView.adapter = SimpleListAdapter(
            listOf(
                SimpleItem(ID_ALMACEN, getString(R.string.menu_almacen), app.session.sucursalNombre),
                SimpleItem(ID_COMPRAS, getString(R.string.menu_compras), app.session.sucursalNombre),
            )
        ) { item ->
            when (item.id) {
                ID_ALMACEN -> startActivity(Intent(this, AlmacenOpcionesActivity::class.java))
                ID_COMPRAS -> startActivity(Intent(this, ComprasOpcionesActivity::class.java))
            }
        }
        binding.swipeRefresh.isEnabled = false
    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        menuInflater.inflate(R.menu.menu_toolbar_logout, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        if (item.itemId == R.id.action_logout) {
            lifecycleScope.launch {
                AuthRepository(app.apiClient, app.session).logout()
                startActivity(Intent(this@MenuActivity, LoginActivity::class.java))
                finish()
            }
            return true
        }
        return super.onOptionsItemSelected(item)
    }
}
