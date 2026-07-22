package pe.com.sigre.logistica.ui.compras

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.recyclerview.widget.LinearLayoutManager
import pe.com.sigre.logistica.R
import pe.com.sigre.logistica.databinding.ActivityGenericListBinding
import pe.com.sigre.logistica.ui.common.SimpleItem
import pe.com.sigre.logistica.ui.common.SimpleListAdapter
import pe.com.sigre.logistica.ui.compras.solicitudes.SolicitudesListActivity

private const val ID_SOLICITUDES = 1L

/** Submenú de Compras. Por ahora solo Solicitudes de Compra; se irán agregando Cotización/OC/OS. */
class ComprasOpcionesActivity : AppCompatActivity() {

    private lateinit var binding: ActivityGenericListBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityGenericListBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.toolbar.title = getString(R.string.compras_opciones_titulo)
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert)
        binding.toolbar.setNavigationOnClickListener { onBackPressedDispatcher.onBackPressed() }
        binding.swipeRefresh.isEnabled = false

        binding.recyclerView.layoutManager = LinearLayoutManager(this)
        binding.recyclerView.adapter = SimpleListAdapter(
            listOf(SimpleItem(ID_SOLICITUDES, getString(R.string.compras_solicitudes)))
        ) { item ->
            if (item.id == ID_SOLICITUDES) {
                startActivity(Intent(this, SolicitudesListActivity::class.java))
            }
        }
    }
}
