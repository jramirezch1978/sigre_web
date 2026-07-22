package pe.com.hermes.appmobile.ui.empresa

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import kotlinx.coroutines.launch
import pe.com.hermes.appmobile.data.remote.dto.EmpresaUsuarioDto
import pe.com.hermes.appmobile.data.remote.dto.SucursalDto
import pe.com.hermes.appmobile.data.repository.AuthRepository
import pe.com.hermes.appmobile.databinding.ActivityGenericListBinding
import pe.com.hermes.appmobile.ui.common.SimpleItem
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter
import pe.com.hermes.appmobile.ui.menu.MenuActivity
import pe.com.hermes.appmobile.util.app
import pe.com.hermes.appmobile.util.toast

/** Segundo paso del login: elegir empresa y, si tiene más de una, sucursal (el backend siempre
 * requiere ambos IDs para /seleccionar-empresa — nunca se puede saltar este paso). */
class SeleccionEmpresaActivity : AppCompatActivity() {

    private lateinit var binding: ActivityGenericListBinding
    private lateinit var authRepository: AuthRepository
    private lateinit var adapter: SimpleListAdapter

    private var empresas: List<EmpresaUsuarioDto> = emptyList()
    private var empresaElegida: EmpresaUsuarioDto? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityGenericListBinding.inflate(layoutInflater)
        setContentView(binding.root)

        authRepository = AuthRepository(app.apiClient, app.session)

        binding.toolbar.title = getString(pe.com.hermes.appmobile.R.string.empresa_titulo)
        binding.recyclerView.layoutManager = LinearLayoutManager(this)
        adapter = SimpleListAdapter(emptyList()) { onItemClick(it) }
        binding.recyclerView.adapter = adapter
        binding.swipeRefresh.setOnRefreshListener { cargarEmpresas() }

        cargarEmpresas()
    }

    private fun onItemClick(item: SimpleItem) {
        if (empresaElegida == null) {
            val empresa = empresas.firstOrNull { it.empresaId == item.id } ?: return
            empresaElegida = empresa
            cargarSucursales(empresa)
        } else {
            seleccionarSucursal(item.id)
        }
    }

    private fun cargarEmpresas() {
        mostrarCargando(true)
        lifecycleScope.launch {
            val resultado = authRepository.listarEmpresas()
            mostrarCargando(false)
            binding.swipeRefresh.isRefreshing = false
            resultado.onSuccess { lista ->
                empresas = lista
                adapter.actualizar(lista.map {
                    SimpleItem(id = it.empresaId, titulo = it.razonSocial ?: it.codigo ?: "Empresa ${it.empresaId}", subtitulo = it.ruc)
                })
                mostrarVacio(lista.isEmpty(), "No tiene empresas asignadas.")
            }.onFailure { err ->
                toast(err.message ?: "No se pudieron cargar las empresas")
            }
        }
    }

    private fun cargarSucursales(empresa: EmpresaUsuarioDto) {
        binding.toolbar.title = getString(pe.com.hermes.appmobile.R.string.empresa_sucursal_titulo)
        mostrarCargando(true)
        lifecycleScope.launch {
            val resultado = authRepository.listarSucursales(empresa.empresaId)
            mostrarCargando(false)
            resultado.onSuccess { sucursales: List<SucursalDto> ->
                if (sucursales.isEmpty()) {
                    toast("La empresa no tiene sucursales asignadas.")
                    return@onSuccess
                }
                if (sucursales.size == 1) {
                    seleccionarSucursal(sucursales.first().id)
                    return@onSuccess
                }
                adapter.actualizar(sucursales.map { SimpleItem(id = it.id, titulo = it.nombre ?: it.codigo ?: "Sucursal ${it.id}") })
            }.onFailure { err ->
                toast(err.message ?: "No se pudieron cargar las sucursales")
            }
        }
    }

    private fun seleccionarSucursal(sucursalId: Long) {
        val empresa = empresaElegida ?: return
        mostrarCargando(true)
        lifecycleScope.launch {
            val resultado = authRepository.seleccionarEmpresa(empresa.empresaId, sucursalId)
            mostrarCargando(false)
            resultado.onSuccess {
                startActivity(Intent(this@SeleccionEmpresaActivity, MenuActivity::class.java))
                finish()
            }.onFailure { err ->
                toast(err.message ?: "No se pudo completar el acceso")
            }
        }
    }

    private fun mostrarCargando(cargando: Boolean) {
        binding.progressBar.visibility = if (cargando) android.view.View.VISIBLE else android.view.View.GONE
    }

    private fun mostrarVacio(vacio: Boolean, mensaje: String) {
        binding.tvVacio.text = mensaje
        binding.tvVacio.visibility = if (vacio) android.view.View.VISIBLE else android.view.View.GONE
    }
}
