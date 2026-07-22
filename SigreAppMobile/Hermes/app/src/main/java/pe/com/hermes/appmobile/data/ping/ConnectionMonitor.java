package pe.com.hermes.appmobile.data.ping;

import android.os.Handler;
import android.os.Looper;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import pe.com.hermes.appmobile.data.remote.ApiClient;
import pe.com.hermes.appmobile.data.remote.dto.ApiResponse;
import pe.com.hermes.appmobile.data.remote.dto.HealthPingResponse;
import retrofit2.Response;

/**
 * Monitoreo periódico vía {@code GET /api/auth/health/ping} — equivalente REST de
 * ConnectionMonitorService + SOAP ImplHealth.ping de FastSales.
 */
public class ConnectionMonitor {

    public interface Listener {
        void onConnectionStatusChanged(boolean connected, Long latencyMs);

        void onPingUpdated(PingSample sample);
    }

    private static final long INTERVAL_MS = 1000L;

    private static final ExecutorService PING_EXECUTOR = Executors.newSingleThreadExecutor(r -> {
        Thread t = new Thread(r, "Hermes-ConnectionMonitor");
        t.setDaemon(true);
        return t;
    });

    private final ApiClient apiClient;
    private final PingHistoryStore history;
    private final Listener listener;
    private final Handler handler = new Handler(Looper.getMainLooper());

    private Runnable monitorRunnable;
    private boolean running;

    public ConnectionMonitor(ApiClient apiClient, PingHistoryStore history, Listener listener) {
        this.apiClient = apiClient;
        this.history = history;
        this.listener = listener;
    }

    public PingHistoryStore getHistory() {
        return history;
    }

    public void start() {
        if (running) return;
        running = true;
        monitorRunnable = new Runnable() {
            @Override
            public void run() {
                if (!running) return;
                PING_EXECUTOR.execute(() -> {
                    PingSample sample = executePing();
                    handler.post(() -> onPingComplete(sample));
                });
                handler.postDelayed(this, INTERVAL_MS);
            }
        };
        handler.post(monitorRunnable);
    }

    public void stop() {
        running = false;
        if (monitorRunnable != null) {
            handler.removeCallbacks(monitorRunnable);
            monitorRunnable = null;
        }
    }

    private PingSample executePing() {
        long start = System.currentTimeMillis();
        try {
            Response<ApiResponse<HealthPingResponse>> response =
                    apiClient.getAuthApi().healthPing().execute();
            long latency = System.currentTimeMillis() - start;

            ApiResponse<HealthPingResponse> body = response.body();
            if (!response.isSuccessful() || body == null || body.data == null) {
                return new PingSample(start, latency, null, null, false, "Respuesta inválida del servidor");
            }
            HealthPingResponse data = body.data;
            boolean ok = body.success && data.ok;
            return new PingSample(start, latency, data.dbConnectionMs, data.dbQueryMs, ok, data.mensaje);
        } catch (Exception ex) {
            long latency = System.currentTimeMillis() - start;
            return new PingSample(start, latency, null, null, false,
                    ex.getMessage() != null ? ex.getMessage() : "Error de red");
        }
    }

    private void onPingComplete(PingSample sample) {
        history.add(sample);
        if (listener != null) {
            listener.onConnectionStatusChanged(sample.success, sample.latencyMs);
            listener.onPingUpdated(sample);
        }
    }
}
