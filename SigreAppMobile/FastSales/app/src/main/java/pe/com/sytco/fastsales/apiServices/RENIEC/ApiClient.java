package pe.com.sytco.fastsales.apiServices.RENIEC;

import com.google.gson.Gson;

import java.security.KeyManagementException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;

import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.SSLSocketFactory;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;

import okhttp3.OkHttpClient;
import okhttp3.logging.HttpLoggingInterceptor;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;
import retrofit2.converter.gson.GsonConverterFactory;

public class ApiClient {
    public String baseURL = null;

    public ApiClient(String pBaseURL){
        this.baseURL = pBaseURL;
    }

    public Retrofit getRetrofit() throws NoSuchAlgorithmException, KeyManagementException {
        return new Retrofit.Builder()
                .baseUrl(baseURL)
                .client(getUnsafeOkHttpClient().build())
                .addConverterFactory(GsonConverterFactory.create())
                .build();
    }

    public OkHttpClient.Builder getUnsafeOkHttpClient() throws KeyManagementException, NoSuchAlgorithmException {

        try {
            // Create a trust manager that does not validate certificate chains
            final TrustManager[] trustAllCerts = new TrustManager[]{
                    new X509TrustManager() {
                        @Override
                        public void checkClientTrusted(java.security.cert.X509Certificate[] chain, String authType) throws CertificateException {
                        }

                        @Override
                        public void checkServerTrusted(java.security.cert.X509Certificate[] chain, String authType) throws CertificateException {
                        }

                        @Override
                        public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                            return new java.security.cert.X509Certificate[]{};
                        }
                    }
            };

            // Install the all-trusting trust manager
            final SSLContext sslContext = SSLContext.getInstance("SSL");
            sslContext.init(null, trustAllCerts, new java.security.SecureRandom());

            // Create an ssl socket factory with our all-trusting manager
            final SSLSocketFactory sslSocketFactory = sslContext.getSocketFactory();

            OkHttpClient.Builder builder = new OkHttpClient.Builder();
            builder.sslSocketFactory(sslSocketFactory, (X509TrustManager) trustAllCerts[0]);
            builder.hostnameVerifier(new HostnameVerifier() {
                @Override
                public boolean verify(String hostname, SSLSession session) {
                    return true;
                }
            });
            return builder;

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        }
    }

    public PersonaResponse Busqueda(String pNroDNI) throws KeyManagementException, NoSuchAlgorithmException {

        final PersonaResponse[] obj = {null};
        final boolean[] lbTrue = {true};

        HttpLoggingInterceptor logging = null;
        OkHttpClient.Builder httpClient = null;
        Retrofit retrofit = null;
        ApiReniecService reniecService = null;

        Call<PersonaResponse> call = null;

        try{
            // Creamos un interceptor y le indicamos el log level a usar
            logging = new HttpLoggingInterceptor();
            logging.setLevel(HttpLoggingInterceptor.Level.BODY);

            // Asociamos el interceptor a las peticiones
            httpClient = new OkHttpClient.Builder();
            httpClient.addInterceptor(logging);

            retrofit = getRetrofit();

            reniecService = retrofit.create(ApiReniecService.class);

            call = reniecService.getDni(pNroDNI);
            call.enqueue(new Callback<PersonaResponse>() {
                @Override
                public void onResponse(Call<PersonaResponse> call, Response<PersonaResponse> response) {

                    //for(PersonaResponse obj : response.body()) {

                    System.out.println("Response.body(): " + new Gson().toJson(response.body()));

                    obj[0] = response.body();

                    lbTrue[0] = false;

                    System.out.println("lbTrue" + lbTrue[0]);

                }
                @Override
                public void onFailure(Call<PersonaResponse> call, Throwable t) {
                    t.printStackTrace();

                    PersonaResponse objError = new PersonaResponse();
                    objError.setError(t.getMessage());

                    obj[0] = objError;

                    lbTrue[0] = false;
                    //System.out.println(t.getMessage());
                }
            });

            while(lbTrue[0]){}

            return obj[0];

        }catch(Exception ex){
            ex.printStackTrace();
            throw ex;

        }finally {
            logging = null;
            httpClient = null;
            retrofit = null;
            reniecService = null;
            call = null;

            System.gc();
        }

    }
}
