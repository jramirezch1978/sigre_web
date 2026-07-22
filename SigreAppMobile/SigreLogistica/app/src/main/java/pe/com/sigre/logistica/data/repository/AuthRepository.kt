package pe.com.sigre.logistica.data.repository

import pe.com.sigre.logistica.data.remote.ApiClient
import pe.com.sigre.logistica.data.remote.dto.EmpresaUsuarioDto
import pe.com.sigre.logistica.data.remote.dto.LoginRequest
import pe.com.sigre.logistica.data.remote.dto.LoginResponse
import pe.com.sigre.logistica.data.remote.dto.SeleccionEmpresaRequest
import pe.com.sigre.logistica.data.remote.dto.SucursalDto
import pe.com.sigre.logistica.data.session.SessionManager

class AuthRepository(private val apiClient: ApiClient, private val session: SessionManager) {

    suspend fun login(email: String, password: String): Result<LoginResponse> = runCatching {
        val res = apiClient.authApi.login(LoginRequest(email = email, password = password))
        if (!res.success || res.data == null) throw Exception(res.message ?: "No se pudo iniciar sesión")
        val data = res.data
        guardarSesionParcial(data)
        data
    }

    suspend fun listarEmpresas(): Result<List<EmpresaUsuarioDto>> = runCatching {
        val res = apiClient.authApi.listarEmpresas()
        if (!res.success) throw Exception(res.message ?: "No se pudieron cargar las empresas")
        res.data ?: emptyList()
    }

    suspend fun listarSucursales(empresaId: Long): Result<List<SucursalDto>> = runCatching {
        val res = apiClient.authApi.listarSucursales(empresaId)
        if (!res.success) throw Exception(res.message ?: "No se pudieron cargar las sucursales")
        res.data ?: emptyList()
    }

    suspend fun seleccionarEmpresa(empresaId: Long, sucursalId: Long): Result<LoginResponse> = runCatching {
        val res = apiClient.authApi.seleccionarEmpresa(
            SeleccionEmpresaRequest(empresaId = empresaId, sucursalId = sucursalId)
        )
        if (!res.success || res.data == null) throw Exception(res.message ?: "No se pudo completar el acceso")
        val data = res.data
        guardarSesionCompleta(data)
        data
    }

    suspend fun logout() {
        runCatching { apiClient.authApi.logout() }
        session.limpiar()
    }

    private fun guardarSesionParcial(data: LoginResponse) {
        session.accessToken = data.accessToken
        session.refreshToken = data.refreshToken
        session.temporal = data.temporal
        session.userId = data.userId ?: -1
        session.nombreCompleto = data.nombreCompleto
        session.email = data.email
        if (!data.temporal) {
            session.empresaId = data.empresaId ?: -1
            session.empresaNombre = data.empresaNombre
            session.sucursalId = data.sucursalId ?: -1
            session.sucursalNombre = data.sucursalNombre
        }
    }

    private fun guardarSesionCompleta(data: LoginResponse) = guardarSesionParcial(data)
}
