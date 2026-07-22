package pe.com.sigre.logistica.data.remote

import okhttp3.Authenticator
import okhttp3.Interceptor
import okhttp3.MediaType.Companion.toMediaType
import okhttp3.OkHttpClient
import okhttp3.Request
import okhttp3.RequestBody.Companion.toRequestBody
import okhttp3.Response
import okhttp3.Route
import okhttp3.logging.HttpLoggingInterceptor
import pe.com.sigre.logistica.BuildConfig
import pe.com.sigre.logistica.data.session.SessionManager
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import java.util.concurrent.TimeUnit

/**
 * Cliente HTTP central. Equivalente moderno de SOAPClient/RrhhApiClient de FastSales:
 * - baseUrl configurable en runtime (session.apiBaseUrl), no hardcodeada en build config.
 * - Interceptor agrega el Bearer token de la sesión a cada request.
 * - Authenticator reintenta una vez con /auth/refresh cuando el servidor responde 401.
 */
class ApiClient(private val session: SessionManager) {

    private var cachedBaseUrl: String? = null
    private var cachedRetrofit: Retrofit? = null

    private val authInterceptor = Interceptor { chain ->
        val original = chain.request()
        val token = session.accessToken
        val request = if (!token.isNullOrBlank()) {
            original.newBuilder().header("Authorization", "Bearer $token").build()
        } else {
            original
        }
        chain.proceed(request)
    }

    /** Reintenta UNA vez con /auth/refresh (bloqueante, corre en el hilo interno de OkHttp). */
    private val refreshAuthenticator = Authenticator { _: Route?, response: Response ->
        if (response.request.header("Authorization-Retry") != null) return@Authenticator null

        val refreshToken = session.refreshToken ?: return@Authenticator null
        val refreshUrl = session.apiBaseUrl.trimEnd('/') + "/auth/refresh"
        val bodyJson = """{"refreshToken":"$refreshToken"}"""
        val refreshClient = OkHttpClient.Builder()
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(30, TimeUnit.SECONDS)
            .build()
        val refreshRequest = Request.Builder()
            .url(refreshUrl)
            .post(bodyJson.toRequestBody("application/json; charset=utf-8".toMediaType()))
            .build()

        return@Authenticator try {
            refreshClient.newCall(refreshRequest).execute().use { refreshResponse ->
                if (!refreshResponse.isSuccessful) {
                    session.limpiar()
                    return@Authenticator null
                }
                val raw = refreshResponse.body?.string().orEmpty()
                val nuevoToken = Regex("\"accessToken\"\\s*:\\s*\"([^\"]+)\"").find(raw)?.groupValues?.get(1)
                val nuevoRefresh = Regex("\"refreshToken\"\\s*:\\s*\"([^\"]+)\"").find(raw)?.groupValues?.get(1)
                if (nuevoToken.isNullOrBlank()) {
                    session.limpiar()
                    return@Authenticator null
                }
                session.accessToken = nuevoToken
                if (!nuevoRefresh.isNullOrBlank()) session.refreshToken = nuevoRefresh

                response.request.newBuilder()
                    .header("Authorization", "Bearer $nuevoToken")
                    .header("Authorization-Retry", "1")
                    .build()
            }
        } catch (_: Exception) {
            null
        }
    }

    private fun buildOkHttp(): OkHttpClient {
        val logging = HttpLoggingInterceptor().apply {
            level = if (BuildConfig.DEBUG) HttpLoggingInterceptor.Level.BODY else HttpLoggingInterceptor.Level.NONE
        }
        return OkHttpClient.Builder()
            .addInterceptor(authInterceptor)
            .addInterceptor(logging)
            .authenticator(refreshAuthenticator)
            .connectTimeout(30, TimeUnit.SECONDS)
            .readTimeout(60, TimeUnit.SECONDS)
            .writeTimeout(60, TimeUnit.SECONDS)
            .build()
    }

    /** Retrofit se reconstruye solo si cambia la URL base (selector de servidor en Login). */
    private fun retrofit(): Retrofit {
        val baseUrl = session.apiBaseUrl
        val cached = cachedRetrofit
        if (cached != null && cachedBaseUrl == baseUrl) return cached

        val nuevo = Retrofit.Builder()
            .baseUrl(if (baseUrl.endsWith("/")) baseUrl else "$baseUrl/")
            .client(buildOkHttp())
            .addConverterFactory(GsonConverterFactory.create())
            .build()
        cachedBaseUrl = baseUrl
        cachedRetrofit = nuevo
        return nuevo
    }

    val authApi: AuthApi get() = retrofit().create(AuthApi::class.java)
    val almacenApi: AlmacenApi get() = retrofit().create(AlmacenApi::class.java)
    val comprasApi: ComprasApi get() = retrofit().create(ComprasApi::class.java)
}
