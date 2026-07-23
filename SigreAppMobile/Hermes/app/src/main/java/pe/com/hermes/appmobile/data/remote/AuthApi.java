package pe.com.hermes.appmobile.data.remote;

import java.util.List;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.AuthMeDto;
import pe.com.hermes.appmobile.data.remote.dto.CodigoEmailResponse;
import pe.com.hermes.appmobile.data.remote.dto.DispositivoRegistradoResponse;
import pe.com.hermes.appmobile.data.remote.dto.EmpresaUsuarioDto;
import pe.com.hermes.appmobile.data.remote.dto.EnviarCodigoEmailRequest;
import pe.com.hermes.appmobile.data.remote.dto.HealthPingResponse;
import pe.com.hermes.appmobile.data.remote.dto.LoginRequest;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;
import pe.com.hermes.appmobile.data.remote.dto.MiMenuResponse;
import pe.com.hermes.appmobile.data.remote.dto.PerfilUpdateRequest;
import pe.com.hermes.appmobile.data.remote.dto.RefreshTokenRequest;
import pe.com.hermes.appmobile.data.remote.dto.RefreshTokenResponse;
import pe.com.hermes.appmobile.data.remote.dto.RegistrarDispositivoRequest;
import pe.com.hermes.appmobile.data.remote.dto.SeleccionEmpresaRequest;
import pe.com.hermes.appmobile.data.remote.dto.SucursalDto;
import retrofit2.Call;
import retrofit2.http.Body;
import retrofit2.http.GET;
import retrofit2.http.POST;
import retrofit2.http.PUT;
import retrofit2.http.Path;
import retrofit2.http.Query;

/** Espejo de com.sigre.seguridad.controller.AuthController (base ya incluye /api/auth via ApiClient). */
public interface AuthApi {

    @POST("auth/login")
    Call<ApiResponse<LoginResponse>> login(@Body LoginRequest request);

    /** Igual que /auth/login pero sin Turnstile — exige un dispositivo ya registrado y autorizado. */
    @POST("auth/login/mobile")
    Call<ApiResponse<LoginResponse>> loginMobile(@Body LoginRequest request);

    @POST("auth/dispositivo/registrar")
    Call<ApiResponse<DispositivoRegistradoResponse>> registrarDispositivo(@Body RegistrarDispositivoRequest request);

    /** Cierra la sesión abierta del dispositivo y abre otra (nuevo nro_registro). */
    @POST("auth/dispositivo/renovar-sesion")
    Call<ApiResponse<DispositivoRegistradoResponse>> renovarSesionDispositivo(
            @Body RegistrarDispositivoRequest request,
            @Query("nroRegistroActual") String nroRegistroActual);

    /** Ping público: latencia BD (conexión + SELECT 1). La latencia total la mide el cliente. */
    @GET("auth/health/ping")
    Call<ApiResponse<HealthPingResponse>> healthPing();

    @GET("auth/empresas")
    Call<ApiResponse<List<EmpresaUsuarioDto>>> listarEmpresas();

    /** Sucursales del tenant (core-service). Requiere Bearer token (temporal OK). */
    @GET("core/empresas/{empresaId}/sucursales/mias")
    Call<ApiResponse<List<SucursalDto>>> listarSucursales(@Path("empresaId") long empresaId);

    @POST("auth/seleccionar-empresa")
    Call<ApiResponse<LoginResponse>> seleccionarEmpresa(@Body SeleccionEmpresaRequest request);

    @POST("auth/refresh")
    Call<ApiResponse<RefreshTokenResponse>> refresh(@Body RefreshTokenRequest request);

    @POST("auth/logout")
    Call<ApiResponse<Void>> logout();

    @GET("auth/me")
    Call<ApiResponse<AuthMeDto>> me();

    @PUT("auth/perfil")
    Call<ApiResponse<AuthMeDto>> actualizarPerfil(@Body PerfilUpdateRequest request);

    @POST("auth/perfil/email/enviar-codigo")
    Call<ApiResponse<CodigoEmailResponse>> enviarCodigoConfirmacionEmail(@Body EnviarCodigoEmailRequest request);

    /** Menú efectivo del usuario (mismo del ERP web). */
    @GET("auth/seguridad/mi-menu")
    Call<ApiResponse<MiMenuResponse>> miMenu();
}
