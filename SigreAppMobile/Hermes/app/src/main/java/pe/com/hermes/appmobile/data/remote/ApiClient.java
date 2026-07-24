package pe.com.hermes.appmobile.data.remote;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;
import java.util.concurrent.TimeUnit;
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
import pe.com.hermes.appmobile.data.device.DeviceRegistry;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.LoginRequest;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;
import pe.com.hermes.appmobile.data.remote.dto.SeleccionEmpresaRequest;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.util.PasswordCrypto;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

/**
 * Cliente HTTP central.
 * <p>
 * No usa {@code /auth/refresh}. Antes de cada API autenticada <b>pide</b> el token al backend:
 * <ul>
 *   <li>Definitivo: {@code POST /auth/seleccionar-empresa} (reutiliza JWT en tokens_session)</li>
 *   <li>Temporal: {@code POST /auth/login/mobile} (listar empresas/sucursales, etc.)</li>
 * </ul>
 * El access solo vive en memoria para esa petición; no se persiste.
 */
public class ApiClient {

    private static final MediaType JSON = MediaType.parse("application/json; charset=utf-8");
    private static final Gson GSON = new Gson();
    private static final Type LOGIN_RESPONSE_TYPE = new TypeToken<ApiResponse<LoginResponse>>() {}.getType();

    private final AppConfig config;
    private final SessionManager session;
    private final DeviceRegistry deviceRegistry;
    private final Object tokenLock = new Object();

    private String cachedBaseUrl;
    private Retrofit cachedRetrofit;

    private final Interceptor authInterceptor;
    private final Authenticator retryAuthenticator;

    public ApiClient(AppConfig config, SessionManager session, DeviceRegistry deviceRegistry) {
        this.config = config;
        this.session = session;
        this.deviceRegistry = deviceRegistry;
        this.authInterceptor = crearAuthInterceptor();
        this.retryAuthenticator = crearRetryAuthenticator();
    }

    private Interceptor crearAuthInterceptor() {
        return chain -> {
            Request original = chain.request();
            String path = original.url().encodedPath();
            Request.Builder builder = original.newBuilder();

            if (esEndpointSinPedirToken(path)) {
                return chain.proceed(builder.build());
            }

            // seleccionar-empresa: si hay Bearer temporal en memoria (flujo login) se envía;
            // si no, el body puede ir con credenciales. No pedir token aquí (evita recursión).
            if (path != null && path.contains("/auth/seleccionar-empresa")) {
                String mem = session.getAccessToken();
                if (mem != null && !mem.isBlank()) {
                    builder.header("Authorization", "Bearer " + mem);
                }
                return chain.proceed(builder.build());
            }

            boolean necesitaTemporal = requiereTokenTemporal(path);
            String token = pedirAccessToken(necesitaTemporal);
            if (token != null && !token.isBlank()) {
                builder.header("Authorization", "Bearer " + token);
            }
            if (!necesitaTemporal) {
                long empresaId = session.getEmpresaId();
                long sucursalId = session.getSucursalId();
                if (empresaId > 0) {
                    builder.header("X-Empresa-Id", String.valueOf(empresaId));
                }
                if (sucursalId > 0) {
                    builder.header("X-Sucursal-Id", String.valueOf(sucursalId));
                }
            }
            return chain.proceed(builder.build());
        };
    }

    private static boolean esEndpointSinPedirToken(String path) {
        if (path == null) {
            return false;
        }
        return path.contains("/auth/login")
                || path.contains("/auth/refresh")
                || path.contains("/auth/dispositivo")
                || path.contains("/auth/health");
    }

    /** Endpoints de auth que aún no tienen empresa/sucursal (token temporal). */
    private static boolean requiereTokenTemporal(String path) {
        if (path == null) {
            return false;
        }
        return path.contains("/auth/empresas")
                || path.contains("/auth/sucursales");
    }

    /**
     * Pide siempre el token al backend (sin refresh, sin reutilizar access en memoria entre llamadas).
     */
    public String asegurarAccessToken() {
        return pedirAccessToken(false);
    }

    private String pedirAccessToken(boolean temporal) {
        synchronized (tokenLock) {
            session.limpiarAccessMemoria();
            if (temporal) {
                return pedirTokenTemporalPorLogin();
            }
            if (session.getEmpresaId() > 0 && session.getSucursalId() > 0) {
                String definitivo = pedirTokenDefinitivoPorSeleccionarEmpresa();
                if (definitivo != null && !definitivo.isBlank()) {
                    return definitivo;
                }
            }
            // Si aún no hay empresa/sucursal, o falló selección: temporal.
            return pedirTokenTemporalPorLogin();
        }
    }

    private String pedirTokenDefinitivoPorSeleccionarEmpresa() {
        Credenciales c = credencialesCifradas();
        if (c == null) {
            return null;
        }
        long empresaId = session.getEmpresaId();
        long sucursalId = session.getSucursalId();
        if (empresaId <= 0 || sucursalId <= 0) {
            return null;
        }

        SeleccionEmpresaRequest body = new SeleccionEmpresaRequest(empresaId, sucursalId);
        body.email = c.usuario;
        body.password = c.passwordCifrado;
        body.passwordHash = c.passwordHash;

        String url = urlAuth("auth/seleccionar-empresa");
        Request request = new Request.Builder()
                .url(url)
                .post(RequestBody.create(GSON.toJson(body), JSON))
                .build();

        try (Response response = httpPlain().newCall(request).execute()) {
            LoginResponse data = parseLoginResponse(response);
            if (data == null || data.accessToken == null || data.accessToken.isBlank()) {
                return null;
            }
            // Solo memoria; no persistir access ni refresh.
            session.setAccessTokenMemoria(data.accessToken, false);
            if (data.empresaNombre != null) {
                session.setEmpresaNombre(data.empresaNombre);
            }
            if (data.sucursalNombre != null) {
                session.setSucursalNombre(data.sucursalNombre);
            }
            return data.accessToken;
        } catch (Exception e) {
            return null;
        }
    }

    private String pedirTokenTemporalPorLogin() {
        Credenciales c = credencialesCifradas();
        if (c == null) {
            return null;
        }
        String nro = deviceRegistry.getNroRegistro();
        if (nro == null || nro.isBlank() || !deviceRegistry.isAutorizado()) {
            return null;
        }

        LoginRequest body = new LoginRequest(c.usuario, c.passwordCifrado, c.passwordHash);
        body.nroRegistroDispositivo = nro;

        String url = urlAuth("auth/login/mobile");
        Request request = new Request.Builder()
                .url(url)
                .post(RequestBody.create(GSON.toJson(body), JSON))
                .build();

        try (Response response = httpPlain().newCall(request).execute()) {
            LoginResponse data = parseLoginResponse(response);
            if (data == null || data.accessToken == null || data.accessToken.isBlank()) {
                return null;
            }
            session.setAccessTokenMemoria(data.accessToken, true);
            if (data.userId != null) {
                session.setUserId(data.userId);
            }
            if (data.email != null) {
                session.setEmail(data.email);
            }
            if (data.nombreCompleto != null) {
                session.setNombreCompleto(data.nombreCompleto);
            }
            return data.accessToken;
        } catch (Exception e) {
            return null;
        }
    }

    private Credenciales credencialesCifradas() {
        if (!session.tieneCredencialesGuardadas()) {
            return null;
        }
        String usuario = session.getEmail();
        if (usuario == null || usuario.isBlank()) {
            usuario = session.getLoginUsuario();
        }
        String plain = session.getLoginPassword();
        if (usuario == null || usuario.isBlank() || plain == null || plain.isEmpty()) {
            return null;
        }
        return new Credenciales(
                usuario.trim(),
                PasswordCrypto.encrypt(plain),
                PasswordCrypto.sha256Hex(plain));
    }

    private LoginResponse parseLoginResponse(Response response) throws Exception {
        if (!response.isSuccessful() || response.body() == null) {
            return null;
        }
        String raw = response.body().string();
        ApiResponse<LoginResponse> parsed = GSON.fromJson(raw, LOGIN_RESPONSE_TYPE);
        if (parsed == null || !parsed.success || parsed.data == null) {
            return null;
        }
        return parsed.data;
    }

    private String urlAuth(String relative) {
        String base = config.getApiBaseUrl();
        if (base.endsWith("/")) {
            base = base.substring(0, base.length() - 1);
        }
        return base + "/" + relative;
    }

    private OkHttpClient httpPlain() {
        return new OkHttpClient.Builder()
                .connectTimeout(30, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)
                .build();
    }

    private Authenticator crearRetryAuthenticator() {
        return (route, response) -> {
            if (response.request().header("Authorization-Retry") != null) {
                return null;
            }
            String path = response.request().url().encodedPath();
            if (esEndpointSinPedirToken(path)
                    || (path != null && path.contains("/auth/seleccionar-empresa"))) {
                return null;
            }
            synchronized (tokenLock) {
                String nuevoToken = pedirAccessToken(requiereTokenTemporal(path));
                if (nuevoToken == null || nuevoToken.isBlank()) {
                    return null;
                }
                Request.Builder retry = response.request().newBuilder()
                        .header("Authorization", "Bearer " + nuevoToken)
                        .header("Authorization-Retry", "1");
                if (!requiereTokenTemporal(path)) {
                    long empresaId = session.getEmpresaId();
                    long sucursalId = session.getSucursalId();
                    if (empresaId > 0) {
                        retry.header("X-Empresa-Id", String.valueOf(empresaId));
                    }
                    if (sucursalId > 0) {
                        retry.header("X-Sucursal-Id", String.valueOf(sucursalId));
                    }
                }
                return retry.build();
            }
        };
    }

    private OkHttpClient buildOkHttp() {
        HttpLoggingInterceptor logging = new HttpLoggingInterceptor();
        logging.setLevel(BuildConfig.DEBUG ? HttpLoggingInterceptor.Level.BODY : HttpLoggingInterceptor.Level.NONE);
        return new OkHttpClient.Builder()
                .addInterceptor(authInterceptor)
                .addInterceptor(logging)
                .authenticator(retryAuthenticator)
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

    private static final class Credenciales {
        final String usuario;
        final String passwordCifrado;
        final String passwordHash;

        Credenciales(String usuario, String passwordCifrado, String passwordHash) {
            this.usuario = usuario;
            this.passwordCifrado = passwordCifrado;
            this.passwordHash = passwordHash;
        }
    }
}
