package pe.com.sigre.logistica.ui.compras.solicitudes

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import kotlinx.coroutines.launch
import pe.com.sigre.logistica.R
import pe.com.sigre.logistica.data.remote.dto.SolicitudCompraResponse
import pe.com.sigre.logistica.data.repository.ComprasRepository
import pe.com.sigre.logistica.databinding.ActivityGenericListBinding
import pe.com.sigre.logistica.ui.common.SimpleItem
import pe.com.sigre.logistica.ui.common.SimpleListAdapter
import pe.com.sigre.logistica.util.app
import pe.com.sigre.logistica.util.toast

private fun etiquetaEstado(flagEstado: String?): String = when (flagEstado) {
    "1" -> "Activa"
    "0" -> "Rechazada/Anulada"
    "2" -> "Convertida"
    else -> flagEstado ?: "?"
}

/** Listado real de Solicitudes de Compra (GET /api/compras/solicitudes-compra) — solo lectura por ahora,
 * misma fuente de datos que la pantalla Angular ya construida (CM003). */
class SolicitudesListActivity : AppCompatActivity() {

    private lateinit var binding: ActivityGenericListBinding
    private lateinit var repository: ComprasRepository
    private lateinit var adapter: SimpleListAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityGenericListBinding.inflate(layoutInflater)
        setContentView(binding.root)

        repository = ComprasRepository(app.apiClient)

        binding.toolbar.title = getString(R.string.solicitudes_titulo)
        binding.toolbar.setNavigationIcon(android.R.drawable.ic_menu_revert)
        binding.toolbar.setNavigationOnClickListener { onBackPressedDispatcher.onBackPressed() }

        binding.recyclerView.layoutManager = LinearLayoutManager(this)
        adapter = SimpleListAdapter(emptyList()) { /* detalle: pendiente */ }
        binding.recyclerView.adapter = adapter
        binding.swipeRefresh.setOnRefreshListener { cargar() }

        cargar()
    }

    private fun cargar() {
        mostrarCargando(true)
        lifecycleScope.launch {
            val resultado = repository.listarSolicitudes()
            mostrarCargando(false)
            binding.swipeRefresh.isRefreshing = false
            resultado.onSuccess { lista: List<SolicitudCompraResponse> ->
                adapter.actualizar(lista.map {
                    SimpleItem(
                        id = it.id,
                        titulo = it.numero ?: "Solicitud ${it.id}",
                        subtitulo = "${it.fecha ?: "—"} · ${it.totalItems} ítem(s) · ${etiquetaEstado(it.flagEstado)}",
                    )
                })
                mostrarVacio(lista.isEmpty())
            }.onFailure { err -> toast(err.message ?: getString(R.string.lista_error)) }
        }
    }

    private fun mostrarCargando(cargando: Boolean) {
        binding.progressBar.visibility = if (cargando) android.view.View.VISIBLE else android.view.View.GONE
    }

    private fun mostrarVacio(vacio: Boolean) {
        binding.tvVacio.text = getString(R.string.lista_vacia)
        binding.tvVacio.visibility = if (vacio) android.view.View.VISIBLE else android.view.View.GONE
    }
}
