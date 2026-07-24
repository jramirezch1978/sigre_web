package pe.com.hermes.appmobile.data.remote;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.lang.reflect.Type;
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
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;
import pe.com.hermes.appmobile.data.remote.dto.SeleccionEmpresaRequest;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.util.PasswordCrypto;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Cliente HTTP central.
 * - baseUrl desde AppConfig.
 * - Antes de cada API de negocio obtiene access en memoria (no se persiste):
 *   1) reutiliza JWT vía {@code /auth/seleccionar-empresa} (backend tokens_session),
 *   2) o {@code /auth/refresh} como respaldo.
 * - Headers: Bearer + X-Empresa-Id / X-Sucursal-Id.
 */
public class ApiClient {

    private static final Pattern ACCESS_TOKEN_PATTERN = Pattern.compile("\"accessToken\"\\s*:\\s*\"([^\"]+)\"");
    private static final Pattern REFRESH_TOKEN_PATTERN = Pattern.compile("\"refreshToken\"\\s*:\\s*\"([^\"]+)\"");
    private static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");
    private static final Gson GSON = new Gson();
    private static final Type LOGIN_RESPONSE_TYPE = new TypeToken<ApiResponse<LoginResponse>>() {}.getType();

    private final AppConfig config;
    private final SessionManager session;
    private final Object tokenLock = new Object();

    private String cachedBaseUrl;
    private Retrofit cachedRetrofit;

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
            String path = original.url().encodedPath();
            Request.Builder builder = original.newBuilder();

            if (esEndpointSinBearer(path)) {
                return chain.proceed(builder.build());
            }

            // seleccionar-empresa: usa Bearer temporal en memoria si existe (login);
            // si no, el body puede llevar credenciales (reuso backend) — no forzar asegurarAccessToken.
            if (path != null && path.contains("/auth/seleccionar-empresa")) {
                String mem = session.getAccessToken();
                if (mem != null && !mem.isBlank()) {
                    builder.header("Authorization", "Bearer " + mem);
                }
                return chain.proceed(builder.build());
            }

            String token = asegurarAccessToken();
            if (token != null && !token.isBlank()) {
                builder.header("Authorization", "Bearer " + token);
            }
            long empresaId = session.getEmpresaId();
            long sucursalId = session.getSucursalId();
            if (empresaId > 0) {
                builder.header("X-Empresa-Id", String.valueOf(empresaId));
            }
            if (sucursalId > 0) {
                builder.header("X-Sucursal-Id", String.valueOf(sucursalId));
            }
            return chain.proceed(builder.build());
        };
    }

    private static boolean esEndpointSinBearer(String path) {
        if (path == null) {
            return false;
        }
        return path.contains("/auth/login")
                || path.contains("/auth/refresh")
                || path.contains("/auth/dispositivo")
                || path.contains("/auth/health");
    }

    /**
     * Obtiene access en memoria. Preferente: seleccionar-empresa (reuso backend).
     * Respaldo: refresh. Nunca persiste el access.
     */
    public String asegurarAccessToken() {
        synchronized (tokenLock) {
            if (session.tieneAccessValidoEnMemoria(30)) {
                return session.getAccessToken();
            }
            String viaSeleccion = obtenerAccessPorSeleccionarEmpresa();
            if (viaSeleccion != null && !viaSeleccion.isBlank()) {
                return viaSeleccion;
            }
            return obtenerAccessPorRefresh();
        }
    }

    private String obtenerAccessPorSeleccionarEmpresa() {
        long empresaId = session.getEmpresaId();
        long sucursalId = session.getSucursalId();
        if (empresaId <= 0 || sucursalId <= 0 || !session.tieneCredencialesGuardadas()) {
            return null;
        }
        String usuario = session.getEmail();
        if (usuario == null || usuario.isBlank()) {
            usuario = session.getLoginUsuario();
        }
        String plainPassword = session.getLoginPassword();
        if (usuario == null || usuario.isBlank() || plainPassword == null || plainPassword.isEmpty()) {
            return null;
        }

        SeleccionEmpresaRequest body = new SeleccionEmpresaRequest(empresaId, sucursalId);
        body.email = usuario.trim();
        body.password = PasswordCrypto.encrypt(plainPassword);
        body.passwordHash = PasswordCrypto.sha256Hex(plainPassword);

        String base = config.getApiBaseUrl();
        String url = (base.endsWith("/") ? base.substring(0, base.length() - 1) : base)
                + "/auth/seleccionar-empresa";
        Request request = new Request.Builder()
                .url(url)
                .post(RequestBody.create(GSON.toJson(body), JSON))
                .build();

        OkHttpClient client = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)
                .build();
        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful() || response.body() == null) {
                return null;
            }
            String raw = response.body().string();
            ApiResponse<LoginResponse> parsed = GSON.fromJson(raw, LOGIN_RESPONSE_TYPE);
            if (parsed == null || !parsed.success || parsed.data == null
                    || parsed.data.accessToken == null || parsed.data.accessToken.isBlank()) {
                return null;
            }
            // Access solo memoria; refresh si viene; backend pudo reusar JWT.
            session.guardarTokens(parsed.data.accessToken, parsed.data.refreshToken, false);
            if (parsed.data.empresaNombre != null) {
                session.setEmpresaNombre(parsed.data.empresaNombre);
            }
            if (parsed.data.sucursalNombre != null) {
                session.setSucursalNombre(parsed.data.sucursalNombre);
            }
            return parsed.data.accessToken;
        } catch (Exception e) {
            return null;
        }
    }

    private String obtenerAccessPorRefresh() {
        String refreshToken = session.getRefreshToken();
        if (refreshToken == null || refreshToken.isBlank()) {
            return null;
        }
        String base = config.getApiBaseUrl();
        String refreshUrl = (base.endsWith("/") ? base.substring(0, base.length() - 1) : base) + "/auth/refresh";
        String bodyJson = "{\"refreshToken\":\"" + refreshToken + "\"}";
        OkHttpClient refreshClient = new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)
                .build();
        Request refreshRequest = new Request.Builder()
                .url(refreshUrl)
                .post(RequestBody.create(bodyJson, JSON))
                .build();
        try (Response refreshResponse = refreshClient.newCall(refreshRequest).execute()) {
            if (!refreshResponse.isSuccessful()) {
                return null;
            }
            String raw = refreshResponse.body() != null ? refreshResponse.body().string() : "";
            String nuevoToken = extraer(ACCESS_TOKEN_PATTERN, raw);
            String nuevoRefresh = extraer(REFRESH_TOKEN_PATTERN, raw);
            if (nuevoToken == null || nuevoToken.trim().isEmpty()) {
                return null;
            }
            String refresh = (nuevoRefresh != null && !nuevoRefresh.trim().isEmpty())
                    ? nuevoRefresh
                    : session.getRefreshToken();
            session.guardarTokens(nuevoToken, refresh, false);
            return nuevoToken;
        } catch (IOException e) {
            return null;
        }
    }

    private Authenticator crearRefreshAuthenticator() {
        return (route, response) -> {
            if (response.request().header("Authorization-Retry") != null) {
                return null;
            }
            synchronized (tokenLock) {
                session.limpiarAccessMemoria();
                String nuevoToken = asegurarAccessToken();
                if (nuevoToken == null || nuevoToken.isBlank()) {
                    return null;
                }
                Request.Builder retry = response.request().newBuilder()
                        .header("Authorization", "Bearer " + nuevoToken)
                        .header("Authorization-Retry", "1");
                long empresaId = session.getEmpresaId();
                long sucursalId = session.getSucursalId();
                if (empresaId > 0) {
                    retry.header("X-Empresa-Id", String.valueOf(empresaId));
                }
                if (sucursalId > 0) {
                    retry.header("X-Sucursal-Id", String.valueOf(sucursalId));
                }
                return retry.build();
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

    private synchronized Retrofit retrofit() {
        String baseUrl = config.getApiBaseUrl();
        if (cachedRetrofit != null && baseUrl.equals(cachedBaseUrl)) {
            return cachedRetrofit;
        }

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
