package pe.com.sytco.fastsales.Dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.PingChartView;
import pe.com.sytco.fastsales.beans.BeanPingHistory;
import pe.com.sytco.fastsales.data.PingHistoryDbHelper;
import pe.com.sytco.fastsales.util.LogHelper;

/**
 * Dialog que muestra estadísticas de ping y gráficas en tiempo real
 * Se actualiza automáticamente cada segundo mientras esté abierto
 */
public class PingMonitorDialog extends Dialog {
    
    private static final long UPDATE_INTERVAL_MS = 1000; // 1 segundo
    private static final int CHART_PINGS_LIMIT = 100; // Últimos 100 pings para gráficas (efecto de movimiento)
    // Para promedios: usar TODOS los registros de la sesión (no hay límite)
    
    // Referencias a vistas
    private TextView tvAvgLatency;
    private TextView tvAvgDbConnection;
    private TextView tvAvgDbQuery;
    private TextView tvSuccessRate;
    private PingChartView chartLatency;
    private PingChartView chartDatabase;
    private Button btnCerrar;
    
    // Database helper
    private PingHistoryDbHelper dbHelper;
    
    // Handler para actualización periódica
    private Handler updateHandler;
    private Runnable updateRunnable;
    private boolean isUpdating = false;
    
    public PingMonitorDialog(Context context, PingHistoryDbHelper dbHelper) {
        super(context);
        this.dbHelper = dbHelper;
        
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_ping_monitor);
        
        // Configurar el ancho del dialog al 90% de la pantalla
        if (getWindow() != null) {
            android.view.WindowManager.LayoutParams params = getWindow().getAttributes();
            android.util.DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
            int screenWidth = displayMetrics.widthPixels;
            params.width = (int) (screenWidth * 0.90); // 90% del ancho de la pantalla
            params.height = android.view.WindowManager.LayoutParams.WRAP_CONTENT;
            getWindow().setAttributes(params);
        }
        
        initializeViews();
        setupUpdateHandler();
        setupListeners();
        
        // Iniciar actualización al mostrar el dialog
        startUpdating();
    }
    
    /**
     * Inicializa las referencias a las vistas
     */
    private void initializeViews() {
        tvAvgLatency = findViewById(R.id.tvAvgLatency);
        tvAvgDbConnection = findViewById(R.id.tvAvgDbConnection);
        tvAvgDbQuery = findViewById(R.id.tvAvgDbQuery);
        tvSuccessRate = findViewById(R.id.tvSuccessRate);
        
        chartLatency = findViewById(R.id.chartLatency);
        chartDatabase = findViewById(R.id.chartDatabase);
        
        btnCerrar = findViewById(R.id.btnCerrar);
        
        // Configurar modo de visualización de las gráficas
        chartLatency.setDisplayMode(PingChartView.MODE_TOTAL_LATENCY);
        chartDatabase.setDisplayMode(PingChartView.MODE_DATABASE_TIMES);
        
        LogHelper.i("PingMonitorDialog", "Vistas inicializadas correctamente");
    }
    
    /**
     * Configura el Handler para actualización periódica
     */
    private void setupUpdateHandler() {
        updateHandler = new Handler(Looper.getMainLooper());
        
        updateRunnable = new Runnable() {
            @Override
            public void run() {
                if (isUpdating) {
                    // Actualizar estadísticas y gráficas
                    updateStatistics();
                    
                    // Programar la siguiente actualización
                    updateHandler.postDelayed(this, UPDATE_INTERVAL_MS);
                }
            }
        };
    }
    
    /**
     * Configura los listeners de botones
     */
    private void setupListeners() {
        btnCerrar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
    }
    
    /**
     * Inicia la actualización periódica
     */
    private void startUpdating() {
        if (!isUpdating) {
            isUpdating = true;
            updateHandler.post(updateRunnable);
            LogHelper.i("PingMonitorDialog", "Actualización periódica iniciada (cada " + UPDATE_INTERVAL_MS + "ms)");
        }
    }
    
    /**
     * Detiene la actualización periódica
     */
    private void stopUpdating() {
        if (isUpdating) {
            isUpdating = false;
            updateHandler.removeCallbacks(updateRunnable);
            LogHelper.i("PingMonitorDialog", "Actualización periódica detenida");
        }
    }
    
    /**
     * Actualiza las estadísticas y gráficas consultando la base de datos
     * 
     * - PROMEDIOS: Calcula con TODOS los registros de la sesión actual
     * - GRÁFICAS: Muestra los últimos 100 registros (efecto de movimiento hacia la izquierda)
     */
    private void updateStatistics() {
        try {
            // Obtener los pings para las gráficas (últimos 100 para efecto de movimiento)
            List<BeanPingHistory> chartPings = dbHelper.getRecentPings(CHART_PINGS_LIMIT);
            
            if (chartPings == null || chartPings.isEmpty()) {
                // No hay datos aún
                tvAvgLatency.setText("-- ms");
                tvAvgDbConnection.setText("-- ms");
                tvAvgDbQuery.setText("-- ms");
                tvSuccessRate.setText("Sin datos");
                
                LogHelper.i("PingMonitorDialog", "No hay datos de ping disponibles aún");
                return;
            }
            
            // Calcular promedios con TODOS los registros de la sesión (sin límite)
            // Esto da un promedio más preciso de toda la sesión de login
            double avgLatency = dbHelper.getAverageLatency(Integer.MAX_VALUE);
            double avgDbConnection = dbHelper.getAverageDbConnection(Integer.MAX_VALUE);
            double avgDbQuery = dbHelper.getAverageDbQuery(Integer.MAX_VALUE);
            
            // Calcular tasa de éxito de TODOS los registros
            List<BeanPingHistory> allPings = dbHelper.getRecentPings(Integer.MAX_VALUE);
            int totalPings = allPings.size();
            int successfulPings = 0;
            for (BeanPingHistory ping : allPings) {
                if (ping.isSuccess()) {
                    successfulPings++;
                }
            }
            double successRate = totalPings > 0 ? (successfulPings * 100.0 / totalPings) : 0;
            
            // Actualizar TextViews con promedios de TODA la sesión
            tvAvgLatency.setText(String.format("%.0f ms", avgLatency));
            tvAvgDbConnection.setText(String.format("%.0f ms", avgDbConnection));
            tvAvgDbQuery.setText(String.format("%.0f ms", avgDbQuery));
            tvSuccessRate.setText(String.format("Tasa de éxito: %.1f%% (%d/%d)", successRate, successfulPings, totalPings));
            
            // Contar cuántos registros tienen datos de BD
            int countWithDbData = 0;
            for (BeanPingHistory ping : chartPings) {
                if (ping.getDbConnectionMs() != null || ping.getDbQueryMs() != null) {
                    countWithDbData++;
                }
            }
            
            // Actualizar gráficas con últimos 100 registros (efecto de movimiento)
            chartLatency.setPingData(chartPings);
            chartDatabase.setPingData(chartPings);
            
            LogHelper.i("PingMonitorDialog", String.format(
                "Actualizado - Total registros:%d | Gráfica:%d (con datos BD:%d) | Latencia:%.0fms | ConexBD:%.0fms | QueryBD:%.0fms | Éxito:%.1f%%", 
                totalPings, chartPings.size(), countWithDbData, avgLatency, avgDbConnection, avgDbQuery, successRate));
            
        } catch (Exception ex) {
            LogHelper.e("PingMonitorDialog", "Error al actualizar estadísticas", ex);
        }
    }
    
    @Override
    public void show() {
        super.show();
        // Iniciar actualización al mostrar
        startUpdating();
    }
    
    @Override
    public void dismiss() {
        // Detener actualización al cerrar
        stopUpdating();
        super.dismiss();
    }
    
    @Override
    protected void onStop() {
        // Detener actualización al detener
        stopUpdating();
        super.onStop();
    }
}

