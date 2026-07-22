package pe.com.sytco.fastsales.api.rrhh;

import java.util.concurrent.TimeUnit;

import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;
import com.google.gson.GsonBuilder;

public class RrhhApiClient {

    private static RrhhApiService service;

    public static synchronized RrhhApiService getService() throws Exception {
        return getService(null);
    }

    public static synchronized RrhhApiService getService(String empresaCodigo) throws Exception {
        if (service == null) {
            String baseUrl = new SOAPClient().getURLFromServer();
            HttpLoggingInterceptor logging = new HttpLoggingInterceptor();
            logging.setLevel(HttpLoggingInterceptor.Level.BASIC);

            OkHttpClient.Builder clientBuilder = new OkHttpClient.Builder()
                    .addInterceptor(logging);
            if (empresaCodigo != null && !empresaCodigo.trim().isEmpty()) {
                clientBuilder.addInterceptor(new RrhhEmpresaInterceptor(empresaCodigo.trim()));
            }
            OkHttpClient client = clientBuilder
                    .connectTimeout(90, TimeUnit.SECONDS)
                    .readTimeout(90, TimeUnit.SECONDS)
                    .writeTimeout(90, TimeUnit.SECONDS)
                    .build();

            Retrofit retrofit = new Retrofit.Builder()
                    .baseUrl(baseUrl)
                    .client(client)
                    .addConverterFactory(new RestResponseConverterFactory())
                    .addConverterFactory(GsonConverterFactory.create(
                            new GsonBuilder().setDateFormat("dd/MM/yyyy HH:mm:ss").create()))
                    .build();

            service = retrofit.create(RrhhApiService.class);
        }
        return service;
    }

    /** Tras cambiar servidor o converter REST. */
    public static void reset() {
        service = null;
    }
}
