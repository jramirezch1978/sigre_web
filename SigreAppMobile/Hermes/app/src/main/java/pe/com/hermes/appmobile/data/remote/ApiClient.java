package pe.com.hermes.appmobile.data.remote;

import java.io.IOException;
import java.util.concurrent.TimeUnit;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import okhttp3.Authenticator;
import okhttp3.Interceptor;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;
import okhttp3.logging.HttpLoggingInterceptor;
import pe.com.hermes.appmobile.BuildConfig;
import pe.com.hermes.appmobile.data.config.AppConfig;
import pe.com.hermes.appmobile.data.session.SessionManager;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Cliente HTTP central.
 * - baseUrl viene del archivo de configuracion (AppConfig), no de build config ni de la sesion.
 * - Interceptor agrega el Bearer token de la sesion a cada request.
 * - Authenticator reintenta una vez con /auth/refresh cuando el servidor responde 401.
 */
public class ApiClient {

    private static final Pattern ACCESS_TOKEN_PATTERN = Pattern.compile("\"accessToken\"\\s*:\\s*\"([^\"]+)\"");
    private static final Pattern REFRESH_TOKEN_PATTERN = Pattern.compile("\"refreshToken\"\\s*:\\s*\"([^\"]+)\"");

    private final AppConfig config;
    private final SessionManager session;

    private String cachedBaseUrl;
    private Retrofit cachedRetrofit;

    // Se construyen en el constructor (no como inicializadores de campo) porque sus lambdas
    // capturan config/session, que Java exige "definitivamente asignados" antes de eso.
    private final Interceptor authInterceptor;
    private final Authenticator refreshAuthenticator;

    public ApiClient(AppConfig config, SessionManager session) {
        this.config = config;
        this.session = session;
        this.authInterceptor = crearAuthInterceptor();
        this.refreshAuthenticator = crearRefreshAuthenticator();
    }

    private Interceptor crearAuthInterceptor() {
        return chain -> {
            Request original = chain.request();
            String token = session.getAccessToken();
            Request request = original;
            if (token != null && !token.trim().isEmpty()) {
                request = original.newBuilder().header("Authorization", "Bearer " + token).build();
            }
            return chain.proceed(request);
        };
    }

    /** Reintenta UNA vez con /auth/refresh (bloqueante, corre en el hilo interno de OkHttp). */
    private Authenticator crearRefreshAuthenticator() {
        return (route, response) -> {
        if (response.request().header("Authorization-Retry") != null) return null;

        String refreshToken = session.getRefreshToken();
        if (refreshToken == null) return null;

        String base = config.getApiBaseUrl();
        String refreshUrl = (base.endsWith("/") ? base.substring(0, base.length() - 1) : base) + "/auth/refresh";
        String bodyJson = "{\"refreshToken\":\"" + refreshToken + "\"}";
        OkHttpClient refreshClient = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)
                .build();
        Request refreshRequest = new Request.Builder()
                .url(refreshUrl)
                .post(RequestBody.create(bodyJson, MediaType.parse("application/json; charset=utf-8")))
                .build();

        try (Response refreshResponse = refreshClient.newCall(refreshRequest).execute()) {
            if (!refreshResponse.isSuccessful()) {
                session.limpiar();
                return null;
            }
            String raw = refreshResponse.body() != null ? refreshResponse.body().string() : "";
            String nuevoToken = extraer(ACCESS_TOKEN_PATTERN, raw);
            String nuevoRefresh = extraer(REFRESH_TOKEN_PATTERN, raw);
            if (nuevoToken == null || nuevoToken.trim().isEmpty()) {
                session.limpiar();
                return null;
            }
            session.setAccessToken(nuevoToken);
            if (nuevoRefresh != null && !nuevoRefresh.trim().isEmpty()) session.setRefreshToken(nuevoRefresh);

            return response.request().newBuilder()
                    .header("Authorization", "Bearer " + nuevoToken)
                    .header("Authorization-Retry", "1")
                    .build();
        } catch (IOException e) {
            return null;
        }
        };
    }

    private static String extraer(Pattern pattern, String texto) {
        Matcher matcher = pattern.matcher(texto);
        return matcher.find() ? matcher.group(1) : null;
    }

    private OkHttpClient buildOkHttp() {
        HttpLoggingInterceptor logging = new HttpLoggingInterceptor();
        logging.setLevel(BuildConfig.DEBUG ? HttpLoggingInterceptor.Level.BODY : HttpLoggingInterceptor.Level.NONE);
        return new OkHttpClient.Builder()
                .addInterceptor(authInterceptor)
                .addInterceptor(logging)
                .authenticator(refreshAuthenticator)
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(60, TimeUnit.SECONDS)
                .writeTimeout(60, TimeUnit.SECONDS)
                .build();
    }

    /** Retrofit se reconstruye solo si cambia la URL base (selector de servidor en Login). */
    private synchronized Retrofit retrofit() {
        String baseUrl = config.getApiBaseUrl();
        if (cachedRetrofit != null && baseUrl.equals(cachedBaseUrl)) return cachedRetrofit;

        Retrofit nuevo = new Retrofit.Builder()
                .baseUrl(baseUrl.endsWith("/") ? baseUrl : baseUrl + "/")
                .client(buildOkHttp())
                .addConverterFactory(GsonConverterFactory.create())
                .build();
        cachedBaseUrl = baseUrl;
        cachedRetrofit = nuevo;
        return nuevo;
    }

    public AuthApi getAuthApi() { return retrofit().create(AuthApi.class); }
    public AlmacenApi getAlmacenApi() { return retrofit().create(AlmacenApi.class); }
    public CoreApi getCoreApi() { return retrofit().create(CoreApi.class); }
    public ComprasApi getComprasApi() { return retrofit().create(ComprasApi.class); }
}
