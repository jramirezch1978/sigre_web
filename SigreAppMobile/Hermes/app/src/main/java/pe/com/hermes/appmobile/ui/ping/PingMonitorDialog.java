package pe.com.hermes.appmobile.ui.ping;

import android.app.Dialog;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.TextView;
import java.util.List;
import java.util.Locale;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.ping.PingHistoryStore;
import pe.com.hermes.appmobile.data.ping.PingSample;

/** Modal Diagnóstico de Conexión — port de FastSales PingMonitorDialog. */
public class PingMonitorDialog extends Dialog {

    private static final long UPDATE_INTERVAL_MS = 1000L;
    private static final int CHART_PINGS_LIMIT = 100;

    private final PingHistoryStore history;
    private final Handler updateHandler = new Handler(Looper.getMainLooper());
    private Runnable updateRunnable;
    private boolean updating;

    private TextView tvAvgLatency;
    private TextView tvAvgDbConnection;
    private TextView tvAvgDbQuery;
    private TextView tvSuccessRate;
    private PingChartView chartLatency;
    private PingChartView chartDatabase;

    public PingMonitorDialog(Context context, PingHistoryStore history) {
        super(context);
        this.history = history;

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_ping_monitor);

        if (getWindow() != null) {
            WindowManager.LayoutParams params = getWindow().getAttributes();
            int screenWidth = context.getResources().getDisplayMetrics().widthPixels;
            params.width = (int) (screenWidth * 0.90);
            params.height = WindowManager.LayoutParams.WRAP_CONTENT;
            getWindow().setAttributes(params);
        }

        tvAvgLatency = findViewById(R.id.tvAvgLatency);
        tvAvgDbConnection = findViewById(R.id.tvAvgDbConnection);
        tvAvgDbQuery = findViewById(R.id.tvAvgDbQuery);
        tvSuccessRate = findViewById(R.id.tvSuccessRate);
        chartLatency = findViewById(R.id.chartLatency);
        chartDatabase = findViewById(R.id.chartDatabase);
        Button btnCerrar = findViewById(R.id.btnCerrar);

        chartLatency.setDisplayMode(PingChartView.MODE_TOTAL_LATENCY);
        chartDatabase.setDisplayMode(PingChartView.MODE_DATABASE_TIMES);
        btnCerrar.setOnClickListener(v -> dismiss());

        updateRunnable = () -> {
            if (!updating) return;
            updateStatistics();
            updateHandler.postDelayed(updateRunnable, UPDATE_INTERVAL_MS);
        };
    }

    private void updateStatistics() {
        List<PingSample> chartPings = history.getRecent(CHART_PINGS_LIMIT);
        if (chartPings.isEmpty()) {
            tvAvgLatency.setText("-- ms");
            tvAvgDbConnection.setText("-- ms");
            tvAvgDbQuery.setText("-- ms");
            tvSuccessRate.setText("Sin datos");
            return;
        }

        int total = history.size();
        int ok = history.successCount();
        double rate = total > 0 ? (ok * 100.0 / total) : 0;

        tvAvgLatency.setText(String.format(Locale.getDefault(), "%.0f ms", history.averageLatency()));
        tvAvgDbConnection.setText(String.format(Locale.getDefault(), "%.0f ms", history.averageDbConnection()));
        tvAvgDbQuery.setText(String.format(Locale.getDefault(), "%.0f ms", history.averageDbQuery()));
        tvSuccessRate.setText(String.format(Locale.getDefault(), "Tasa de éxito: %.1f%% (%d/%d)", rate, ok, total));

        chartLatency.setPingData(chartPings);
        chartDatabase.setPingData(chartPings);
    }

    private void startUpdating() {
        if (updating) return;
        updating = true;
        updateHandler.post(updateRunnable);
    }

    private void stopUpdating() {
        updating = false;
        updateHandler.removeCallbacks(updateRunnable);
    }

    @Override
    public void show() {
        super.show();
        startUpdating();
    }

    @Override
    public void dismiss() {
        stopUpdating();
        super.dismiss();
    }

    @Override
    protected void onStop() {
        stopUpdating();
        super.onStop();
    }
}
