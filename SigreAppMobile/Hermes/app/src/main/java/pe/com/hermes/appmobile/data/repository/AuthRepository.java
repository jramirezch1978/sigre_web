package pe.com.hermes.appmobile.data.repository;

import java.util.Collections;
import java.util.List;
import pe.com.hermes.appmobile.data.remote.ApiClient;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.EmpresaUsuarioDto;
import pe.com.hermes.appmobile.data.remote.dto.LoginRequest;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;
import pe.com.hermes.appmobile.data.remote.dto.SeleccionEmpresaRequest;
import pe.com.hermes.appmobile.data.remote.dto.SucursalDto;
import pe.com.hermes.appmobile.data.session.SessionManager;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AuthRepository {

    private final ApiClient apiClient;
    private final SessionManager session;

    public AuthRepository(ApiClient apiClient, SessionManager session) {
        this.apiClient = apiClient;
        this.session = session;
    }

    public void login(String email, String password, ResultCallback<LoginResponse> callback) {
        apiClient.getAuthApi().login(new LoginRequest(email, password)).enqueue(new Callback<ApiResponse<LoginResponse>>() {
            @Override
            public void onResponse(Call<ApiResponse<LoginResponse>> call, Response<ApiResponse<LoginResponse>> response) {
                ApiResponse<LoginResponse> body = response.body();
                if (!response.isSuccessful() || body == null || !body.success || body.data == null) {
                    callback.onError(mensajeError(body, "No se pudo iniciar sesión"));
                    return;
                }
                guardarSesionParcial(body.data);
                callback.onSuccess(body.data);
            }

            @Override
            public void onFailure(Call<ApiResponse<LoginResponse>> call, Throwable t) {
                callback.onError(mensajeRed(t));
            }
        });
    }

    public void listarEmpresas(ResultCallback<List<EmpresaUsuarioDto>> callback) {
        apiClient.getAuthApi().listarEmpresas().enqueue(new Callback<ApiResponse<List<EmpresaUsuarioDto>>>() {
            @Override
            public void onResponse(Call<ApiResponse<List<EmpresaUsuarioDto>>> call, Response<ApiResponse<List<EmpresaUsuarioDto>>> response) {
                ApiResponse<List<EmpresaUsuarioDto>> body = response.body();
                if (!response.isSuccessful() || body == null || !body.success) {
                    callback.onError(mensajeError(body, "No se pudieron cargar las empresas"));
                    return;
                }
                callback.onSuccess(body.data != null ? body.data : Collections.emptyList());
            }

            @Override
            public void onFailure(Call<ApiResponse<List<EmpresaUsuarioDto>>> call, Throwable t) {
                callback.onError(mensajeRed(t));
            }
        });
    }

    public void listarSucursales(long empresaId, ResultCallback<List<SucursalDto>> callback) {
        apiClient.getAuthApi().listarSucursales(empresaId).enqueue(new Callback<ApiResponse<List<SucursalDto>>>() {
            @Override
            public void onResponse(Call<ApiResponse<List<SucursalDto>>> call, Response<ApiResponse<List<SucursalDto>>> response) {
                ApiResponse<List<SucursalDto>> body = response.body();
                if (!response.isSuccessful() || body == null || !body.success) {
                    callback.onError(mensajeError(body, "No se pudieron cargar las sucursales"));
                    return;
                }
                callback.onSuccess(body.data != null ? body.data : Collections.emptyList());
            }

            @Override
            public void onFailure(Call<ApiResponse<List<SucursalDto>>> call, Throwable t) {
                callback.onError(mensajeRed(t));
            }
        });
    }

    public void seleccionarEmpresa(long empresaId, long sucursalId, ResultCallback<LoginResponse> callback) {
        apiClient.getAuthApi().seleccionarEmpresa(new SeleccionEmpresaRequest(empresaId, sucursalId))
                .enqueue(new Callback<ApiResponse<LoginResponse>>() {
                    @Override
                    public void onResponse(Call<ApiResponse<LoginResponse>> call, Response<ApiResponse<LoginResponse>> response) {
                        ApiResponse<LoginResponse> body = response.body();
                        if (!response.isSuccessful() || body == null || !body.success || body.data == null) {
                            callback.onError(mensajeError(body, "No se pudo completar el acceso"));
                            return;
                        }
                        guardarSesionParcial(body.data);
                        callback.onSuccess(body.data);
                    }

                    @Override
                    public void onFailure(Call<ApiResponse<LoginResponse>> call, Throwable t) {
                        callback.onError(mensajeRed(t));
                    }
                });
    }

    /** Limpia la sesion SIEMPRE (exito o falla de red), avisando cuando el intento termino. */
    public void logout(Runnable onDone) {
        apiClient.getAuthApi().logout().enqueue(new Callback<ApiResponse<Void>>() {
            @Override
            public void onResponse(Call<ApiResponse<Void>> call, Response<ApiResponse<Void>> response) {
                session.limpiar();
                onDone.run();
            }

            @Override
            public void onFailure(Call<ApiResponse<Void>> call, Throwable t) {
                session.limpiar();
                onDone.run();
            }
        });
    }

    private void guardarSesionParcial(LoginResponse data) {
        session.setAccessToken(data.accessToken);
        session.setRefreshToken(data.refreshToken);
        session.setTemporal(data.temporal);
        session.setUserId(data.userId != null ? data.userId : -1);
        session.setNombreCompleto(data.nombreCompleto);
        session.setEmail(data.email);
        if (!data.temporal) {
            session.setEmpresaId(data.empresaId != null ? data.empresaId : -1);
            session.setEmpresaNombre(data.empresaNombre);
            session.setSucursalId(data.sucursalId != null ? data.sucursalId : -1);
            session.setSucursalNombre(data.sucursalNombre);
        }
    }

    private static String mensajeError(ApiResponse<?> body, String porDefecto) {
        return body != null && body.message != null ? body.message : porDefecto;
    }

    private static String mensajeRed(Throwable t) {
        return t.getMessage() != null ? t.getMessage() : "Error de red";
    }
}
