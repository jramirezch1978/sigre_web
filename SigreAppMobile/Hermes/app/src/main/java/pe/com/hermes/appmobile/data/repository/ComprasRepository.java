package pe.com.hermes.appmobile.data.repository;

import java.util.Collections;
import java.util.List;
import pe.com.hermes.appmobile.data.remote.ApiClient;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.PageData;
import pe.com.hermes.appmobile.data.remote.dto.SolicitudCompraResponse;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;

public class ComprasRepository {

    private final ApiClient apiClient;

    public ComprasRepository(ApiClient apiClient) {
        this.apiClient = apiClient;
    }

    public void listarSolicitudes(int page, ResultCallback<List<SolicitudCompraResponse>> callback) {
        apiClient.getComprasApi().listarSolicitudes(null, page, 50)
                .enqueue(new Callback<ApiResponse<PageData<SolicitudCompraResponse>>>() {
                    @Override
                    public void onResponse(Call<ApiResponse<PageData<SolicitudCompraResponse>>> call,
                                            Response<ApiResponse<PageData<SolicitudCompraResponse>>> response) {
                        ApiResponse<PageData<SolicitudCompraResponse>> body = response.body();
                        if (!response.isSuccessful() || body == null || !body.success) {
                            String mensaje = body != null && body.message != null ? body.message : "No se pudieron cargar las solicitudes";
                            callback.onError(mensaje);
                            return;
                        }
                        callback.onSuccess(body.data != null ? body.data.content : Collections.emptyList());
                    }

                    @Override
                    public void onFailure(Call<ApiResponse<PageData<SolicitudCompraResponse>>> call, Throwable t) {
                        callback.onError(t.getMessage() != null ? t.getMessage() : "Error de red");
                    }
                });
    }

    public void listarSolicitudes(ResultCallback<List<SolicitudCompraResponse>> callback) {
        listarSolicitudes(0, callback);
    }
}
