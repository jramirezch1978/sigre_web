package pe.com.hermes.appmobile.data.repository

import pe.com.hermes.appmobile.data.remote.ApiClient
import pe.com.hermes.appmobile.data.remote.dto.SolicitudCompraResponse

class ComprasRepository(private val apiClient: ApiClient) {

    suspend fun listarSolicitudes(page: Int = 0): Result<List<SolicitudCompraResponse>> = runCatching {
        val res = apiClient.comprasApi.listarSolicitudes(page = page)
        if (!res.success) throw Exception(res.message ?: "No se pudieron cargar las solicitudes")
        res.data?.content ?: emptyList()
    }
}
