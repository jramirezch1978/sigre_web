package pe.com.hermes.appmobile.data.remote;

import java.util.List;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.DispositivoRegistradoResponse;
import pe.com.hermes.appmobile.data.remote.dto.EmpresaUsuarioDto;
import pe.com.hermes.appmobile.data.remote.dto.HealthPingResponse;
import pe.com.hermes.appmobile.data.remote.dto.LoginRequest;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;
import pe.com.hermes.appmobile.data.remote.dto.RefreshTokenRequest;
import pe.com.hermes.appmobile.data.remote.dto.RefreshTokenResponse;
import pe.com.hermes.appmobile.data.remote.dto.RegistrarDispositivoRequest;
import pe.com.hermes.appmobile.data.remote.dto.SeleccionEmpresaRequest;
import pe.com.hermes.appmobile.data.remote.dto.SucursalDto;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.Path;

/** Espejo de com.sigre.seguridad.controller.AuthController (base ya incluye /api/auth via ApiClient). */
public interface AuthApi {

    @POST("auth/login")
    Call<ApiResponse<LoginResponse>> login(@Body LoginRequest request);

    /** Igual que /auth/login pero sin Turnstile — exige un dispositivo ya registrado y autorizado. */
    @POST("auth/login/mobile")
    Call<ApiResponse<LoginResponse>> loginMobile(@Body LoginRequest request);

    @POST("auth/dispositivo/registrar")
    Call<ApiResponse<DispositivoRegistradoResponse>> registrarDispositivo(@Body RegistrarDispositivoRequest request);

    /** Ping público: latencia BD (conexión + SELECT 1). La latencia total la mide el cliente. */
    @GET("auth/health/ping")
    Call<ApiResponse<HealthPingResponse>> healthPing();

    @GET("auth/empresas")
    Call<ApiResponse<List<EmpresaUsuarioDto>>> listarEmpresas();

    @GET("core/empresas/{empresaId}/sucursales/mias")
    Call<ApiResponse<List<SucursalDto>>> listarSucursales(@Path("empresaId") long empresaId);

    @POST("auth/seleccionar-empresa")
    Call<ApiResponse<LoginResponse>> seleccionarEmpresa(@Body SeleccionEmpresaRequest request);

    @POST("auth/refresh")
    Call<ApiResponse<RefreshTokenResponse>> refresh(@Body RefreshTokenRequest request);

    @POST("auth/logout")
    Call<ApiResponse<Void>> logout();
}
