package pe.com.hermes.common.util;

import android.os.Handler;
import android.os.Looper;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Reemplazo minimo de las coroutines (Dispatchers.IO + callback en main) en Java puro:
 * ejecuta una tarea bloqueante en un pool de hilos y entrega el resultado (o el error)
 * en el hilo principal. Mismo patron que usaban las apps Android en Java antes de
 * Kotlin/coroutines (AsyncTask, hoy deprecado, hacia esto mismo internamente).
 */
public final class AsyncRunner {

    private static final ExecutorService POOL = Executors.newCachedThreadPool();
    private static final Handler MAIN = new Handler(Looper.getMainLooper());

    public interface Tarea<T> {
        T ejecutar() throws Exception;
    }

    public interface OnResultado<T> {
        void onExito(T resultado);
        void onError(Exception error);
    }

    private AsyncRunner() {
    }

    public static <T> void ejecutar(Tarea<T> tarea, OnResultado<T> callback) {
        POOL.execute(() -> {
            try {
                T resultado = tarea.ejecutar();
                MAIN.post(() -> callback.onExito(resultado));
            } catch (Exception e) {
                MAIN.post(() -> callback.onError(e));
            }
        });
    }
}
