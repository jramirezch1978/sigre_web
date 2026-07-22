package pe.com.hermes.appmobile.ui.almacen.movimientos

import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import kotlinx.coroutines.launch
import pe.com.hermes.appmobile.R
import pe.com.hermes.appmobile.data.remote.dto.MovimientoListItemResponse
import pe.com.hermes.appmobile.data.repository.AlmacenRepository
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding
import pe.com.hermes.appmobile.ui.common.SimpleItem
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter
import pe.com.hermes.appmobile.util.app
import pe.com.hermes.appmobile.util.toast

/** Listado real de movimientos de almacén (GET /api/almacen/movimientos) — solo lectura por ahora. */
class MovimientosListActivity : AppCompatActivity() {

    private lateinit var binding: ActivityGenericListBinding
    private lateinit var repository: AlmacenRepository
    private lateinit var adapter: SimpleListAdapter

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityGenericListBinding.inflate(layoutInflater)
        setContentView(binding.root)

        repository = AlmacenRepository(app.apiClient, app.session)

        binding.toolbar.title = getString(R.string.movimientos_titulo)
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
            val resultado = repository.listarMovimientos()
            mostrarCargando(false)
            binding.swipeRefresh.isRefreshing = false
            resultado.onSuccess { lista: List<MovimientoListItemResponse> ->
                adapter.actualizar(lista.map {
                    SimpleItem(
                        id = it.id,
                        titulo = it.nroVale ?: "Movimiento ${it.id}",
                        subtitulo = "${it.fechaMov ?: "—"} · estado ${it.flagEstado ?: "?"}",
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
