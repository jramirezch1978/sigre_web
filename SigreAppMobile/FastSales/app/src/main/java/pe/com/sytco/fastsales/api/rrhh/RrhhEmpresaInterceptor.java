package pe.com.sytco.fastsales.api.rrhh;

import java.io.IOException;

import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

/**
 * Replica cabecera X-Empresa en todas las peticiones REST RRHH.
 */
public class RrhhEmpresaInterceptor implements Interceptor {

    private final String empresa;

    public RrhhEmpresaInterceptor(String empresa) {
        this.empresa = empresa != null ? empresa.trim() : "";
    }

    @Override
    public Response intercept(Chain chain) throws IOException {
        Request original = chain.request();
        if (empresa.isEmpty()) {
            return chain.proceed(original);
        }
        Request request = original.newBuilder()
                .header("X-Empresa", empresa)
                .build();
        return chain.proceed(request);
    }
}
