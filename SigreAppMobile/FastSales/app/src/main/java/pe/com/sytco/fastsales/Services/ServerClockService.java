package pe.com.sytco.fastsales.Services;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicBoolean;

import pe.com.sytco.fastsales.Controller.Asistencia.ImplAsistencia;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;

/**
 * Servicio para MOSTRAR el reloj sincronizado con el servidor
 * 
 * LÓGICA DE SINCRONIZACIÓN:
 * - Llamada 1: Obtiene hora del servidor Oracle y calcula offset
 * - Llamadas 2-60: Usa hora local del PDA + offset calculado
 * - Llamada 61: Vuelve a sincronizar con el servidor (se repite el ciclo)
 * 
 * CONTROL POR CONTEO DE LLAMADAS (no por tiempo):
 * - Cada llamada cuenta como 1, sin importar cuánto demore
 * - El reloj se actualiza visualmente cada ~1 segundo
 */
public class ServerClockService {
    
    private static final String TAG = "ServerClockService";
    private static final long UPDATE_INTERVAL_MS = 1000; // Actualizar UI cada 1 segundo
    private static final int CALLS_BEFORE_SYNC = 60;     // Sincronizar cada 60 llamadas
    private static final long SYNC_TOLERANCE_MS = 3000;  // Tolerancia: 3 segundos máximo
    
    // ExecutorService dedicado para getServerDateTime
    private static final ExecutorService CLOCK_EXECUTOR = Executors.newSingleThreadExecutor(r -> {
        Thread t = new Thread(r, "ServerClock-Thread");
        t.setDaemon(true);
        return t;
    });
    
    private Handler handler;
    private Runnable clockRunnable;
    private ClockUpdateListener listener;
    private Context context;
    
    private boolean isRunning = false;
    private boolean isPaused = false;
    private boolean isConnectedToServer = false;
    
    // Variables para cálculo de offset
    private long serverTimeOffset = 0;           // Diferencia: horaServidor - horaLocal
    private boolean isOffsetInitialized = false;
    private int callCount = 0;                   // Contador de llamadas (1 a 60)
    private AtomicBoolean isSyncing = new AtomicBoolean(false); // Evitar sincronizaciones simultáneas
    
    public interface ClockUpdateListener {
        void onTimeUpdate(String dateTime, boolean isServerConnected);
        void onConnectionStatusChanged(boolean isConnected);
    }
    
    public ServerClockService(Context context, ClockUpdateListener listener) {
        this.context = context;
        this.listener = listener;
        this.handler = new Handler(Looper.getMainLooper());
    }
    
    /**
     * Inicia el servicio de sincronización del reloj
     */
    public void start() {
        if (isRunning) {
            Log.w(TAG, "El servicio ya está en ejecución");
            return;
        }
        
        isRunning = true;
        callCount = 0;  // Iniciar en 0, la primera llamada será sincronización
        isOffsetInitialized = false;
        
        Log.i(TAG, "Iniciando servicio de reloj (sincroniza cada " + CALLS_BEFORE_SYNC + " llamadas)");
        
        clockRunnable = new Runnable() {
            @Override
            public void run() {
                if (!isRunning) {
                    return;
                }
                
                if (!isPaused) {
                    updateClock();
                }
                
                // Programar siguiente llamada (cada ~1 segundo)
                if (isRunning) {
                    handler.postDelayed(this, UPDATE_INTERVAL_MS);
                }
            }
        };
        
        // Iniciar inmediatamente
        handler.post(clockRunnable);
    }
    
    /**
     * Detiene el servicio
     */
    public void stop() {
        Log.i(TAG, "Deteniendo servicio de reloj");
        isRunning = false;
        isPaused = false;
        if (handler != null && clockRunnable != null) {
            handler.removeCallbacks(clockRunnable);
        }
    }
    
    /**
     * Pausa temporalmente el reloj
     */
    public void pause() {
        if (!isRunning || isPaused) return;
        isPaused = true;
        Log.i(TAG, "Servicio de reloj PAUSADO");
    }
    
    /**
     * Reanuda el reloj
     */
    public void resume() {
        if (!isRunning || !isPaused) return;
        isPaused = false;
        Log.i(TAG, "Servicio de reloj REANUDADO");
    }
    
    /**
     * Actualiza el reloj (llamada cada ~1 segundo)
     * 
     * Control por CONTEO DE LLAMADAS:
     * - Llamada 1: sincronizar con servidor
     * - Llamadas 2-60: usar hora local + offset
     * - Llamada 61 → reset a 1: sincronizar con servidor
     */
    private void updateClock() {
        callCount++;
        
        // ¿Es momento de sincronizar con el servidor?
        // Llamada 1, 61, 121, 181... (cada 60 llamadas)
        boolean shouldSync = (callCount == 1) || (callCount > CALLS_BEFORE_SYNC);
        
        if (shouldSync) {
            // Reset del contador
            callCount = 1;
            
            // Sincronizar con el servidor (llamada 1 del ciclo)
            syncWithServer();
        } else {
            // Llamadas 2-60: usar hora local + offset
            displayTimeWithOffset();
        }
    }
    
    /**
     * LLAMADA 1 DEL CICLO: Sincroniza con el servidor Oracle
     */
    private void syncWithServer() {
        // Evitar sincronizaciones simultáneas
        if (!isSyncing.compareAndSet(false, true)) {
            // Ya hay una sincronización en curso, mostrar hora local
            displayTimeWithOffset();
            return;
        }
        
        CLOCK_EXECUTOR.execute(new Runnable() {
            @Override
            public void run() {
                try {
                    if (ImplEmpresa.empresaDefault == null) {
                        Log.w(TAG, "Empresa no configurada");
                        displayTimeWithOffset();
                        return;
                    }
                    
                    long beforeCall = System.currentTimeMillis();
                    
                    ImplAsistencia implAsistencia = new ImplAsistencia(ImplEmpresa.empresaDefault.getCodigo());
                    String serverDateTime = implAsistencia.getServerDateTime();
                    
                    long afterCall = System.currentTimeMillis();
                    long networkLatency = (afterCall - beforeCall) / 2;
                    
                    if (serverDateTime != null && !serverDateTime.isEmpty()) {
                        Date serverDate = parseServerDateTime(serverDateTime);
                        if (serverDate != null) {
                            // Calcular nuevo offset: horaServidor - horaLocal
                            long serverTimeMillis = serverDate.getTime() + networkLatency;
                            long newOffset = serverTimeMillis - System.currentTimeMillis();
                            
                            // TOLERANCIA DE 3 SEGUNDOS:
                            // Solo actualizar offset si la diferencia supera el umbral
                            long offsetDifference = Math.abs(newOffset - serverTimeOffset);
                            
                            if (!isOffsetInitialized) {
                                // Primera sincronización: siempre aplicar
                                serverTimeOffset = newOffset;
                                isOffsetInitialized = true;
                                Log.i(TAG, "✓ Primera sincronización. Offset: " + serverTimeOffset + "ms");
                            } else if (offsetDifference >= SYNC_TOLERANCE_MS) {
                                // Diferencia >= 3 segundos: actualizar offset
                                long oldOffset = serverTimeOffset;
                                serverTimeOffset = newOffset;
                                Log.i(TAG, "✓ Offset ACTUALIZADO. Diferencia: " + offsetDifference + "ms | Anterior: " + oldOffset + "ms → Nuevo: " + newOffset + "ms");
                            } else {
                                // Diferencia < 3 segundos: NO actualizar offset (mantener actual)
                                Log.d(TAG, "○ Offset sin cambios. Diferencia: " + offsetDifference + "ms (< " + SYNC_TOLERANCE_MS + "ms tolerancia)");
                            }
                            
                            if (!isConnectedToServer) {
                                isConnectedToServer = true;
                                notifyConnectionStatusChanged(true);
                            }
                            
                            // SIEMPRE mostrar la hora del servidor (ya que la tenemos)
                            notifyTimeUpdate(serverDateTime, true);
                            return;
                        }
                    }
                    
                    // Falló la sincronización
                    handleSyncFailure();
                    
                } catch (Exception e) {
                    Log.e(TAG, "Error sincronizando: " + e.getMessage());
                    handleSyncFailure();
                } finally {
                    isSyncing.set(false);
                }
            }
        });
    }
    
    /**
     * Maneja el fallo de sincronización
     */
    private void handleSyncFailure() {
        if (isConnectedToServer) {
            isConnectedToServer = false;
            notifyConnectionStatusChanged(false);
            Log.w(TAG, "Conexión perdida. Usando hora local + offset");
        }
        displayTimeWithOffset();
    }
    
    /**
     * LLAMADAS 2-60 DEL CICLO: Muestra hora usando reloj local + offset
     * NO llama al servidor
     */
    private void displayTimeWithOffset() {
        long currentTimeMillis;
        boolean showAsConnected;
        
        if (isOffsetInitialized) {
            // Hora del servidor = hora local + offset
            currentTimeMillis = System.currentTimeMillis() + serverTimeOffset;
            showAsConnected = isConnectedToServer;
        } else {
            // Offset no inicializado, usar hora local pura
            currentTimeMillis = System.currentTimeMillis();
            showAsConnected = false;
        }
        
        Date displayTime = new Date(currentTimeMillis);
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss a", Locale.US);
        String formattedTime = sdf.format(displayTime);
        
        notifyTimeUpdate(formattedTime, showAsConnected);
    }
    
    /**
     * Parsea la fecha/hora del servidor
     */
    private Date parseServerDateTime(String serverDateTime) {
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss a", Locale.US);
            return sdf.parse(serverDateTime);
        } catch (Exception e) {
            Log.e(TAG, "Error parseando fecha: " + e.getMessage());
            return null;
        }
    }
    
    private void notifyTimeUpdate(final String dateTime, final boolean isServerConnected) {
        if (listener != null) {
            handler.post(new Runnable() {
                @Override
                public void run() {
                    listener.onTimeUpdate(dateTime, isServerConnected);
                }
            });
        }
    }
    
    private void notifyConnectionStatusChanged(final boolean isConnected) {
        if (listener != null) {
            handler.post(new Runnable() {
                @Override
                public void run() {
                    listener.onConnectionStatusChanged(isConnected);
                }
            });
        }
    }
    
    /**
     * Fuerza sincronización en la próxima llamada
     */
    public void forceSync() {
        callCount = CALLS_BEFORE_SYNC; // La próxima llamada sincronizará
        Log.i(TAG, "Sincronización forzada programada");
    }
    
    public boolean isRunning() {
        return isRunning;
    }
    
    public boolean isConnectedToServer() {
        return isConnectedToServer;
    }
    
    public long getServerTimeOffset() {
        return serverTimeOffset;
    }
    
    public int getCurrentCallCount() {
        return callCount;
    }
}
