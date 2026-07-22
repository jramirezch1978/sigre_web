package pe.com.hermes.appmobile.data.repository

import pe.com.hermes.appmobile.data.remote.ApiClient
import pe.com.hermes.appmobile.data.remote.dto.MovimientoListItemResponse
import pe.com.hermes.appmobile.data.session.SessionManager

class AlmacenRepository(private val apiClient: ApiClient, private val session: SessionManager) {

    suspend fun listarMovimientos(page: Int = 0): Result<List<MovimientoListItemResponse>> = runCatching {
        val sucursalId = session.sucursalId.takeIf { it > 0 }
        val res = apiClient.almacenApi.listarMovimientos(sucursalId = sucursalId, page = page)
        if (!res.success) throw Exception(res.message ?: "No se pudieron cargar los movimientos")
        res.data?.content ?: emptyList()
    }
}
