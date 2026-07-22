package pe.com.hermes.appmobile.data.repository;

/**
 * Reemplazo en Java puro de Kotlin's Result&lt;T&gt; + onSuccess/onFailure. Retrofit entrega
 * onSuccess/onError ya en el hilo principal (Callback executor por defecto de Android).
 */
public interface ResultCallback<T> {
    void onSuccess(T data);
    void onError(String mensaje);
}
