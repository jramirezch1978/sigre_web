package pe.com.sigre.logistica.data.remote

import pe.com.sigre.logistica.data.remote.dto.*
import retrofit2.http.*

/** Espejo de com.sigre.seguridad.controller.AuthController (base ya incluye /api/auth vía ApiClient). */
interface AuthApi {

    @POST("auth/login")
    suspend fun login(@Body request: LoginRequest): ApiResponse<LoginResponse>

    @GET("auth/empresas")
    suspend fun listarEmpresas(): ApiResponse<List<EmpresaUsuarioDto>>

    @GET("core/empresas/{empresaId}/sucursales/mias")
    suspend fun listarSucursales(@Path("empresaId") empresaId: Long): ApiResponse<List<SucursalDto>>

    @POST("auth/seleccionar-empresa")
    suspend fun seleccionarEmpresa(@Body request: SeleccionEmpresaRequest): ApiResponse<LoginResponse>

    @POST("auth/refresh")
    suspend fun refresh(@Body request: RefreshTokenRequest): ApiResponse<RefreshTokenResponse>

    @POST("auth/logout")
    suspend fun logout(): ApiResponse<Unit>
}
