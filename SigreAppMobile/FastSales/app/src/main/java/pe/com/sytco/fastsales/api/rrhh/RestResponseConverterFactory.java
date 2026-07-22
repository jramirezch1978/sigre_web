package pe.com.sytco.fastsales.api.rrhh;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.IOException;
import java.lang.annotation.Annotation;
import java.lang.reflect.ParameterizedType;
import java.lang.reflect.Type;

import okhttp3.ResponseBody;
import pe.com.sytco.fastsales.api.rrhh.dto.RestResponse;
import retrofit2.Converter;
import retrofit2.Retrofit;

/**
 * Deserializa {@code RestResponse<T>} parseando el nodo {@code data} con el tipo genérico real
 * (p. ej. {@code List<CuadrillaDto>}). El GsonConverterFactory por defecto deja {@code data} en null.
 */
public final class RestResponseConverterFactory extends Converter.Factory {

    private final Gson gson = new GsonBuilder().setDateFormat("dd/MM/yyyy HH:mm:ss").create();

    @Override
    public Converter<ResponseBody, ?> responseBodyConverter(Type type, Annotation[] annotations, Retrofit retrofit) {
        if (!(type instanceof ParameterizedType)) {
            return null;
        }
        ParameterizedType outer = (ParameterizedType) type;
        if (!RestResponse.class.isAssignableFrom((Class<?>) outer.getRawType())) {
            return null;
        }
        final Type dataType = outer.getActualTypeArguments()[0];
        return new RestResponseBodyConverter(dataType);
    }

    private final class RestResponseBodyConverter implements Converter<ResponseBody, RestResponse<?>> {

        private final Type dataType;

        RestResponseBodyConverter(Type dataType) {
            this.dataType = dataType;
        }

        @Override
        public RestResponse<?> convert(ResponseBody value) throws IOException {
            String json = value.string();
            if (json == null || json.trim().isEmpty()) {
                return null;
            }

            JsonObject root = JsonParser.parseString(json).getAsJsonObject();
            RestResponse<Object> response = new RestResponse<Object>();

            if (root.has("ok") && !root.get("ok").isJsonNull()) {
                response.setOk(root.get("ok").getAsBoolean());
            }
            if (root.has("mensaje") && !root.get("mensaje").isJsonNull()) {
                response.setMensaje(root.get("mensaje").getAsString());
            }
            if (root.has("data") && !root.get("data").isJsonNull()) {
                JsonElement dataNode = root.get("data");
                Object data = gson.fromJson(dataNode, dataType);
                response.setData(data);
            }
            return response;
        }
    }
}
