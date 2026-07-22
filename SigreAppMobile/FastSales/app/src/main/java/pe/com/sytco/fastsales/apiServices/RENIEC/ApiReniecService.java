package pe.com.sytco.fastsales.apiServices.RENIEC;

import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Path;

public interface ApiReniecService {
    @GET("dni/{nro}")
    Call<PersonaResponse> getDni(@Path("nro") String nro);
}
