package pe.com.hermes.appmobile.data.repository;

import com.google.gson.Gson;
import java.util.Collections;
import java.util.List;
import pe.com.hermes.appmobile.data.remote.ApiClient;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.AuthMeDto;
import pe.com.hermes.appmobile.data.remote.dto.CodigoEmailResponse;
import pe.com.hermes.appmobile.data.remote.dto.DispositivoRegistradoResponse;
import pe.com.hermes.appmobile.data.remote.dto.EmpresaUsuarioDto;
import pe.com.hermes.appmobile.data.remote.dto.EnviarCodigoEmailRequest;
import pe.com.hermes.appmobile.data.remote.dto.LoginRequest;
import pe.com.hermes.appmobile.data.remote.dto.LoginResponse;
import pe.com.hermes.appmobile.data.remote.dto.PerfilUpdateRequest;
import pe.com.hermes.appmobile.data.remote.dto.RegistrarDispositivoRequest;
import pe.com.hermes.appmobile.data.remote.dto.SeleccionEmpresaRequest;
import pe.com.hermes.appmobile.data.remote.dto.SucursalDto;
import pe.com.hermes.appmobile.data.session.SessionManager;
import pe.com.hermes.appmobile.util.PasswordCrypto;
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

    /**
     * @param nroRegistroDispositivo nro de registro del equipo (ver DeviceRegistry) — el
     *                               backend usa /login/mobile (sin Turnstile) si viene informado,
     *                               y exige que el dispositivo este registrado Y autorizado.
     */
    public void login(String email, String password, String nroRegistroDispositivo, ResultCallback<LoginResponse> callback) {
        // El backend real (AesEncryptor.decryptAndVerify) exige la contraseña cifrada AES-256-CTR
        // + su SHA-256 de verificacion, igual que el frontend Angular (CryptoService) - nunca texto plano.
        String encryptedPassword = PasswordCrypto.encrypt(password);
        String passwordHash = PasswordCrypto.sha256Hex(password);
        LoginRequest request = new LoginRequest(email, encryptedPassword, passwordHash);
        request.nroRegistroDispositivo = nroRegistroDispositivo;
        apiClient.getAuthApi().loginMobile(request).enqueue(new Callback<ApiResponse<LoginResponse>>() {
            @Override
            public void onResponse(Call<ApiResponse<LoginResponse>> call, Response<ApiResponse<LoginResponse>> response) {
                ApiResponse<LoginResponse> body = response.body();
                if (!response.isSuccessful() || body == null || !body.success || body.data == null) {
                    callback.onError(mensajeError(response, "No se pudo iniciar sesión"));
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

    public void registrarDispositivo(RegistrarDispositivoRequest request, ResultCallback<DispositivoRegistradoResponse> callback) {
        apiClient.getAuthApi().registrarDispositivo(request).enqueue(new Callback<ApiResponse<DispositivoRegistradoResponse>>() {
            @Override
            public void onResponse(Call<ApiResponse<DispositivoRegistradoResponse>> call, Response<ApiResponse<DispositivoRegistradoResponse>> response) {
                ApiResponse<DispositivoRegistradoResponse> body = response.body();
                if (!response.isSuccessful() || body == null || !body.success || body.data == null) {
                    callback.onError(mensajeError(response, "No se pudo registrar el dispositivo"));
                    return;
                }
                callback.onSuccess(body.data);
            }

            @Override
            public void onFailure(Call<ApiResponse<DispositivoRegistradoResponse>> call, Throwable t) {
                callback.onError(mensajeRed(t));
            }
        });
    }

    /** Cierra la sesión de dispositivo actual y abre una nueva (nuevo nro_registro). */
    public void renovarSesionDispositivo(
            RegistrarDispositivoRequest request,
            String nroRegistroActual,
            ResultCallback<DispositivoRegistradoResponse> callback) {
        apiClient.getAuthApi()
                .renovarSesionDispositivo(request, nroRegistroActual)
                .enqueue(new Callback<ApiResponse<DispositivoRegistradoResponse>>() {
                    @Override
                    public void onResponse(
                            Call<ApiResponse<DispositivoRegistradoResponse>> call,
                            Response<ApiResponse<DispositivoRegistradoResponse>> response) {
                        ApiResponse<DispositivoRegistradoResponse> body = response.body();
                        if (!response.isSuccessful() || body == null || !body.success || body.data == null) {
                            callback.onError(mensajeError(response, "No se pudo renovar la sesión del dispositivo"));
                            return;
                        }
                        callback.onSuccess(body.data);
                    }

                    @Override
                    public void onFailure(Call<ApiResponse<DispositivoRegistradoResponse>> call, Throwable t) {
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
                    callback.onError(mensajeError(response, "No se pudieron cargar las empresas"));
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
                    callback.onError(mensajeError(response, "No se pudieron cargar las sucursales"));
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
                            callback.onError(mensajeError(response, "No se pudo completar el acceso"));
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

    public void obtenerPerfil(ResultCallback<AuthMeDto> callback) {
        apiClient.getAuthApi().me().enqueue(new Callback<ApiResponse<AuthMeDto>>() {
            @Override
            public void onResponse(Call<ApiResponse<AuthMeDto>> call, Response<ApiResponse<AuthMeDto>> response) {
                if (response.isSuccessful() && response.body() != null && response.body().data != null) {
                    callback.onSuccess(response.body().data);
                } else {
                    callback.onError(mensajeError(response, "No se pudo cargar el perfil"));
                }
            }

            @Override
            public void onFailure(Call<ApiResponse<AuthMeDto>> call, Throwable t) {
                callback.onError(mensajeRed(t));
            }
        });
    }

    public void enviarCodigoConfirmacionEmail(String email, ResultCallback<CodigoEmailResponse> callback) {
        apiClient.getAuthApi()
                .enviarCodigoConfirmacionEmail(new EnviarCodigoEmailRequest(email))
                .enqueue(new Callback<ApiResponse<CodigoEmailResponse>>() {
                    @Override
                    public void onResponse(Call<ApiResponse<CodigoEmailResponse>> call,
                                           Response<ApiResponse<CodigoEmailResponse>> response) {
                        if (response.isSuccessful() && response.body() != null && response.body().data != null) {
                            callback.onSuccess(response.body().data);
                        } else {
                            callback.onError(mensajeError(response, "No se pudo enviar el código"));
                        }
                    }

                    @Override
                    public void onFailure(Call<ApiResponse<CodigoEmailResponse>> call, Throwable t) {
                        callback.onError(mensajeRed(t));
                    }
                });
    }

    public void actualizarPerfil(PerfilUpdateRequest request, ResultCallback<AuthMeDto> callback) {
        apiClient.getAuthApi().actualizarPerfil(request).enqueue(new Callback<ApiResponse<AuthMeDto>>() {
            @Override
            public void onResponse(Call<ApiResponse<AuthMeDto>> call, Response<ApiResponse<AuthMeDto>> response) {
                if (response.isSuccessful() && response.body() != null && response.body().data != null) {
                    AuthMeDto data = response.body().data;
                    if (data.nombreCompleto != null) {
                        session.setNombreCompleto(data.nombreCompleto);
                    }
                    if (data.email != null) {
                        session.setEmail(data.email);
                    }
                    callback.onSuccess(data);
                } else {
                    callback.onError(mensajeError(response, "No se pudo guardar el perfil"));
                }
            }

            @Override
            public void onFailure(Call<ApiResponse<AuthMeDto>> call, Throwable t) {
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
        // Token temporal o definitivo + refresh, siempre en EncryptedSharedPreferences.
        session.guardarTokens(data.accessToken, data.refreshToken, data.temporal);
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

    /**
     * Retrofit solo llena response.body() en 2xx; el mensaje real de error de negocio
     * (ej. "Credenciales inválidas", "Complete la verificación de seguridad (Turnstile)")
     * viaja en errorBody() y antes se descartaba siempre, mostrando el mensaje generico
     * por defecto sin importar la causa real.
     */
    private static String mensajeError(Response<?> response, String porDefecto) {
        ApiResponse<?> body = (ApiResponse<?>) response.body();
        if (body != null && body.message != null && !body.message.isEmpty()) return body.message;

        if (response.errorBody() != null) {
            try {
                String raw = response.errorBody().string();
                ApiResponse<?> error = new Gson().fromJson(raw, ApiResponse.class);
                if (error != null && error.message != null && !error.message.isEmpty()) return error.message;
            } catch (Exception ignored) {
                // Cuerpo de error no es JSON parseable (ej. HTML de un proxy) - usar el mensaje por defecto.
            }
        }
        return porDefecto;
    }

    private static String mensajeRed(Throwable t) {
        return t.getMessage() != null ? t.getMessage() : "Error de red";
    }
}
