package pe.com.hermes.appmobile.ui.servidor

import android.app.AlertDialog
import android.content.Intent
import android.graphics.Color
import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.CheckBox
import android.widget.EditText
import android.widget.ProgressBar
import android.widget.Spinner
import android.widget.TextView
import androidx.activity.addCallback
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.textfield.TextInputLayout
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import pe.com.hermes.appmobile.data.config.ServerProfile
import pe.com.hermes.appmobile.databinding.ActivityServidorListBinding
import pe.com.hermes.appmobile.ui.common.SimpleItem
import pe.com.hermes.appmobile.ui.common.SimpleListAdapter
import pe.com.hermes.appmobile.util.ConnectivityChecker
import pe.com.hermes.appmobile.util.app
import pe.com.hermes.common.ui.ConfirmDialog
import pe.com.hermes.common.ui.MessageBox

/**
 * Listado de servidores remotos — equivalente a ServerRemoteActivity de FastSales:
 * la lista se edita EN MEMORIA (añadir/editar/quitar) y solo se persiste al archivo
 * de configuración cuando el usuario toca "Guardar" (mismo patrón que confirmSave()).
 */
class ServidorListActivity : AppCompatActivity() {

    private lateinit var binding: ActivityServidorListBinding
    private lateinit var adapter: SimpleListAdapter
    private var servidores: MutableList<ServerProfile> = mutableListOf()
    private var hayCambios = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityServidorListBinding.inflate(layoutInflater)
        setContentView(binding.root)

        servidores = app.config.listarServidores().toMutableList()

        binding.recyclerView.layoutManager = LinearLayoutManager(this)
        adapter = SimpleListAdapter(emptyList()) { item -> editarPorIndice(item.id.toInt()) }
        binding.recyclerView.adapter = adapter
        refrescarLista()

        binding.btnAdd.setOnClickListener { abrirDialogoServidor(null) }
        binding.btnSave.setOnClickListener { confirmarGuardado() }
        binding.btnCerrar.setOnClickListener { confirmarCierre() }

        onBackPressedDispatcher.addCallback(this) { confirmarCierre() }
    }

    private fun refrescarLista() {
        adapter.actualizar(
            servidores.mapIndexed { i, s ->
                val marca = if (s.flagDefault) " ★ Por defecto" else ""
                SimpleItem(id = i.toLong(), titulo = s.nombre, subtitulo = "${s.protocolo}://${s.hostIp}:${s.port}$marca")
            }
        )
        binding.tvNroRegistros.text = "${servidores.size} servidor(es)"
    }

    private fun editarPorIndice(indice: Int) {
        if (indice !in servidores.indices) return
        abrirDialogoServidor(indice)
    }

    /** null = alta nueva; no-null = edición del índice indicado. */
    private fun abrirDialogoServidor(indiceEditar: Int?) {
        val view = layoutInflater.inflate(pe.com.hermes.appmobile.R.layout.dialog_add_server, null)

        val etNombre = view.findViewById<EditText>(pe.com.hermes.appmobile.R.id.etNombre)
        val etHostIp = view.findViewById<EditText>(pe.com.hermes.appmobile.R.id.etHostIp)
        val etPort = view.findViewById<EditText>(pe.com.hermes.appmobile.R.id.etPort)
        val spProtocolo = view.findViewById<Spinner>(pe.com.hermes.appmobile.R.id.spProtocolo)
        val chkFlagDefault = view.findViewById<CheckBox>(pe.com.hermes.appmobile.R.id.chkFlagDefault)
        val tilNombre = view.findViewById<TextInputLayout>(pe.com.hermes.appmobile.R.id.tilNombre)
        val tilHostIp = view.findViewById<TextInputLayout>(pe.com.hermes.appmobile.R.id.tilHostIp)
        val tilPort = view.findViewById<TextInputLayout>(pe.com.hermes.appmobile.R.id.tilPort)
        val btnProbarConexion = view.findViewById<android.widget.Button>(pe.com.hermes.appmobile.R.id.btnProbarConexion)
        val progressProbarConexion = view.findViewById<ProgressBar>(pe.com.hermes.appmobile.R.id.progressProbarConexion)
        val tvResultadoConexion = view.findViewById<TextView>(pe.com.hermes.appmobile.R.id.tvResultadoConexion)

        val protocolos = listOf("http", "https")
        val protocoloAdapter = ArrayAdapter(this, android.R.layout.simple_spinner_item, protocolos)
        protocoloAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item)
        spProtocolo.adapter = protocoloAdapter

        val existente = indiceEditar?.let { servidores.getOrNull(it) }
        if (existente != null) {
            etNombre.setText(existente.nombre)
            etHostIp.setText(existente.hostIp)
            etPort.setText(existente.port)
            spProtocolo.setSelection(protocolos.indexOf(existente.protocolo).coerceAtLeast(0))
            chkFlagDefault.isChecked = existente.flagDefault
        }

        val dialog = AlertDialog.Builder(this)
            .setView(view)
            .setCancelable(false)
            .create()

        btnProbarConexion.setOnClickListener {
            val hostIp = etHostIp.text?.toString()?.trim().orEmpty()
            val port = etPort.text?.toString()?.trim().orEmpty()

            if (hostIp.isEmpty() || port.isEmpty()) {
                tvResultadoConexion.setTextColor(Color.parseColor("#C62828"))
                tvResultadoConexion.text = "Ingrese host y puerto antes de probar"
                return@setOnClickListener
            }

            progressProbarConexion.visibility = android.view.View.VISIBLE
            tvResultadoConexion.text = ""
            btnProbarConexion.isEnabled = false

            lifecycleScope.launch {
                val resultado = withContext(Dispatchers.IO) { ConnectivityChecker.probar(hostIp, port) }
                progressProbarConexion.visibility = android.view.View.GONE
                btnProbarConexion.isEnabled = true
                if (resultado.conectado) {
                    tvResultadoConexion.setTextColor(Color.parseColor("#2E7D32"))
                    tvResultadoConexion.text = "✓ Conectado (${resultado.latenciaMs} ms)"
                } else {
                    tvResultadoConexion.setTextColor(Color.parseColor("#C62828"))
                    tvResultadoConexion.text = "✗ Sin conexión"
                }
            }
        }

        view.findViewById<android.widget.Button>(pe.com.hermes.appmobile.R.id.btnCancelar).setOnClickListener {
            dialog.dismiss()
        }

        view.findViewById<android.widget.Button>(pe.com.hermes.appmobile.R.id.btnAceptar).setOnClickListener {
            val nombre = etNombre.text?.toString()?.trim().orEmpty()
            val hostIp = etHostIp.text?.toString()?.trim().orEmpty()
            val port = etPort.text?.toString()?.trim().orEmpty()

            var valido = true
            if (nombre.isEmpty()) { tilNombre.error = "Nombre de servidor inválido"; valido = false } else tilNombre.error = null
            if (hostIp.isEmpty()) { tilHostIp.error = "Host o IP inválido"; valido = false } else tilHostIp.error = null
            if (port.isEmpty()) { tilPort.error = "Puerto inválido"; valido = false } else tilPort.error = null
            if (!valido) return@setOnClickListener

            val nombreDuplicado = servidores.withIndex().any { (i, s) ->
                i != indiceEditar && s.nombre.equals(nombre, ignoreCase = true)
            }
            if (nombreDuplicado) {
                tilNombre.error = "Ya existe un servidor con ese nombre"
                return@setOnClickListener
            }

            val nuevo = ServerProfile(
                nombre = nombre,
                hostIp = hostIp,
                port = port,
                protocolo = spProtocolo.selectedItem as String,
                flagDefault = chkFlagDefault.isChecked,
            )

            if (nuevo.flagDefault) {
                servidores.replaceAll { it.copy(flagDefault = false) }
            }

            if (indiceEditar != null) {
                servidores[indiceEditar] = nuevo
            } else {
                servidores.add(nuevo)
            }

            hayCambios = true
            refrescarLista()
            dialog.dismiss()
        }

        dialog.show()
    }

    private fun confirmarGuardado() {
        val mensaje = when {
            servidores.isEmpty() -> "No hay ningún servidor registrado. ¿Desea guardar de todas maneras?"
            servidores.none { it.flagDefault } -> "No ha marcado ningún servidor como predeterminado. ¿Desea guardar de todas maneras?"
            else -> "¿Desea guardar los cambios realizados?"
        }
        ConfirmDialog.mostrar(
            context = this,
            titulo = "Confirmación de grabación",
            mensaje = mensaje,
            cancelable = false,
            onSi = {
                app.config.guardarServidores(servidores)
                hayCambios = false
                MessageBox.exito(this, "Servidores guardados correctamente.")
            },
        )
    }

    private fun confirmarCierre() {
        if (!hayCambios) {
            cerrar()
            return
        }
        ConfirmDialog.mostrar(
            context = this,
            titulo = "Confirmación",
            mensaje = "Hay modificaciones pendientes de grabar, ¿desea salir sin guardar?",
            textoSi = "Salir",
            textoNo = "Cancelar",
            cancelable = false,
            onSi = { cerrar() },
        )
    }

    private fun cerrar() {
        startActivity(Intent(this, pe.com.hermes.appmobile.ui.login.LoginActivity::class.java))
        finish()
    }
}
