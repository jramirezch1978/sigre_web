package pe.com.hermes.appmobile.data.remote.dto

/** Espejo de com.sigre.common.dto.ApiResponse<T> (todos los microservicios). */
data class ApiResponse<T>(
    val success: Boolean,
    val message: String? = null,
    val errorCode: String? = null,
    val data: T? = null,
)

data class PageMeta(
    val number: Int = 0,
    val size: Int = 0,
    val totalElements: Long = 0,
    val totalPages: Int = 0,
)

data class PageData<T>(
    val content: List<T> = emptyList(),
    val page: PageMeta = PageMeta(),
)
