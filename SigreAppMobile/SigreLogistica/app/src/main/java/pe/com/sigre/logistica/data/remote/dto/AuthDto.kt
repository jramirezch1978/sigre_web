package pe.com.sigre.logistica.data.remote.dto

/** Espejo de com.sigre.seguridad.dto.LoginRequest. */
data class LoginRequest(
    val email: String,
    val password: String,
    val ipAddress: String? = null,
    val ipPrivada: String? = null,
    val browser: String? = "SIGRE Logística Android",
    val sistemaOperativo: String? = "Android",
    val deviceName: String? = null,
)

/** Espejo de com.sigre.seguridad.dto.LoginResponse. */
data class LoginResponse(
    val accessToken: String,
    val refreshToken: String? = null,
    val tokenType: String? = null,
    val expiresInSeconds: Long = 0,
    val temporal: Boolean = false,
    val userId: Long? = null,
    val email: String? = null,
    val username: String? = null,
    val nombres: String? = null,
    val apellidos: String? = null,
    val nombreCompleto: String? = null,
    val empresaId: Long? = null,
    val empresaCodigo: String? = null,
    val empresaNombre: String? = null,
    val empresaRuc: String? = null,
    val sucursalId: Long? = null,
    val sucursalNombre: String? = null,
    val adminSistema: Boolean? = null,
    val tipoSales: String? = null,
)

/** Espejo de com.sigre.seguridad.dto.EmpresaUsuarioDto. */
data class EmpresaUsuarioDto(
    val empresaId: Long,
    val codigo: String? = null,
    val razonSocial: String? = null,
    val ruc: String? = null,
    val dbName: String? = null,
)

/** Sucursal de una empresa (según la respuesta de seleccionar-empresa/empresas por sucursal). */
data class SucursalDto(
    val id: Long,
    val codigo: String? = null,
    val nombre: String? = null,
)

/** Espejo de com.sigre.seguridad.dto.SeleccionEmpresaRequest. */
data class SeleccionEmpresaRequest(
    val empresaId: Long,
    val sucursalId: Long,
    val ipAddress: String? = null,
    val ipPrivada: String? = null,
    val browser: String? = "SIGRE Logística Android",
    val sistemaOperativo: String? = "Android",
    val email: String? = null,
    val password: String? = null,
)

/** Espejo de com.sigre.seguridad.dto.RefreshTokenRequest/Response. */
data class RefreshTokenRequest(val refreshToken: String)

data class RefreshTokenResponse(
    val accessToken: String,
    val refreshToken: String? = null,
    val tokenType: String? = null,
    val expiresInSeconds: Long = 0,
)
