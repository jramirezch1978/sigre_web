package pe.com.hermes.appmobile.data.repository;

import java.util.Collections;
import java.util.List;
import pe.com.hermes.appmobile.data.remote.ApiClient;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.MovimientoListItemResponse;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import pe.com.hermes.appmobile.data.session.SessionManager;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class AlmacenRepository {

    private final ApiClient apiClient;
    private final SessionManager session;

    public AlmacenRepository(ApiClient apiClient, SessionManager session) {
        this.apiClient = apiClient;
        this.session = session;
    }

    public void listarMovimientos(int page, ResultCallback<List<MovimientoListItemResponse>> callback) {
        Long sucursalId = session.getSucursalId() > 0 ? session.getSucursalId() : null;
        apiClient.getAlmacenApi().listarMovimientos(sucursalId, page, 50)
                .enqueue(new Callback<ApiResponse<PageData<MovimientoListItemResponse>>>() {
                    @Override
                    public void onResponse(Call<ApiResponse<PageData<MovimientoListItemResponse>>> call,
                                            Response<ApiResponse<PageData<MovimientoListItemResponse>>> response) {
                        ApiResponse<PageData<MovimientoListItemResponse>> body = response.body();
                        if (!response.isSuccessful() || body == null || !body.success) {
                            String mensaje = body != null && body.message != null ? body.message : "No se pudieron cargar los movimientos";
                            callback.onError(mensaje);
                            return;
                        }
                        callback.onSuccess(body.data != null ? body.data.content : Collections.emptyList());
                    }

                    @Override
                    public void onFailure(Call<ApiResponse<PageData<MovimientoListItemResponse>>> call, Throwable t) {
                        callback.onError(t.getMessage() != null ? t.getMessage() : "Error de red");
                    }
                });
    }

    public void listarMovimientos(ResultCallback<List<MovimientoListItemResponse>> callback) {
        listarMovimientos(0, callback);
    }
}
