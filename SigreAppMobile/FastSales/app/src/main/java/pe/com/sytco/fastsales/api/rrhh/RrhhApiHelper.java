package pe.com.sytco.fastsales.api.rrhh;

import java.util.List;

import pe.com.sytco.fastsales.api.rrhh.dto.RestResponse;
import retrofit2.Response;

public final class RrhhApiHelper {

    private RrhhApiHelper() {
    }

    public static <T> T unwrap(Response<RestResponse<T>> response) throws RrhhApiException {
        RestResponse<T> body = requireBody(response);
        if (body.getData() == null) {
            throw new RrhhApiException(
                    "El servicio respondió sin datos (data null). Revise despliegue del WAR o actualice la app.");
        }
        return body.getData();
    }

    public static <T> List<T> unwrapList(Response<RestResponse<List<T>>> response, String recurso)
            throws RrhhApiException {
        RestResponse<List<T>> body = requireBody(response);
        List<T> data = body.getData();
        if (data == null) {
            throw new RrhhApiException(
                    "No se pudo leer la lista de " + recurso + " (data null). Actualice la app o verifique el WAR.");
        }
        return data;
    }

    private static <T> RestResponse<T> requireBody(Response<RestResponse<T>> response) throws RrhhApiException {
        if (!response.isSuccessful() || response.body() == null) {
            throw new RrhhApiException("Error HTTP " + response.code());
        }
        RestResponse<T> body = response.body();
        if (!body.isOk()) {
            throw new RrhhApiException(body.getMensaje() != null ? body.getMensaje() : "Error en servicio REST");
        }
        return body;
    }
}
