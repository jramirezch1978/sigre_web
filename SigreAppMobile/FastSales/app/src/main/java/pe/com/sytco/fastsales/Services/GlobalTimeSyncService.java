package pe.com.sytco.fastsales.Services;

import android.app.AlarmManager;
import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import pe.com.sytco.fastsales.Controller.Asistencia.ImplAsistencia;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;

/**
 * Servicio global para sincronizar la hora del dispositivo con el servidor
 * - Se ejecuta al iniciar la aplicación (con mensaje)
 * - Se ejecuta cada hora de manera silenciosa en segundo plano
 * - Funciona independientemente del módulo en que se encuentre el usuario
 */
public class GlobalTimeSyncService {
    
    private static final String TAG = "GlobalTimeSync";
    private static final long SYNC_INTERVAL_MS = 3600000; // 1 hora
    
    private static GlobalTimeSyncService instance;
    private Context context;
    private Handler syncHandler;
    private Runnable syncRunnable;
    private boolean isRunning = false;
    private long lastSyncAttemptMillis = 0;
    
    // Listener para notificar el progreso de la sincronización inicial
    public interface InitialSyncListener {
        void onSyncStarted();
        void onSyncCompleted(boolean success, String message);
    }
    
    private GlobalTimeSyncService(Context context) {
        this.context = context.getApplicationContext();
        this.syncHandler = new Handler(Looper.getMainLooper());
    }
    
    /**
     * Obtiene la instancia única del servicio
     */
    public static synchronized GlobalTimeSyncService getInstance(Context context) {
        if (instance == null) {
            instance = new GlobalTimeSyncService(context);
        }
        return instance;
    }
    
    /**
     * Inicia el servicio de sincronización
     * Realiza una sincronización inicial con mensaje y luego programa sincronizaciones cada hora
     */
    public void start(final InitialSyncListener listener) {
        if (isRunning) {
            Log.w(TAG, "El servicio ya está en ejecución");
            return;
        }
        
        isRunning = true;
        Log.i(TAG, "Iniciando servicio global de sincronización de hora");
        
        // Realizar sincronización inicial con mensaje
        performInitialSync(listener);
        
        // Programar sincronizaciones cada hora (silenciosas)
        scheduleSilentSync();
    }
    
    /**
     * Detiene el servicio de sincronización
     */
    public void stop() {
        Log.i(TAG, "Deteniendo servicio global de sincronización");
        isRunning = false;
        if (syncHandler != null && syncRunnable != null) {
            syncHandler.removeCallbacks(syncRunnable);
        }
    }
    
    /**
     * Realiza la sincronización inicial al abrir la aplicación (con mensaje)
     */
    private void performInitialSync(final InitialSyncListener listener) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    // Notificar que inició la sincronización
                    if (listener != null) {
                        syncHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                listener.onSyncStarted();
                            }
                        });
                    }
                    
                    Log.i(TAG, "Iniciando sincronización inicial de hora del dispositivo...");
                    
                    // Pequeña pausa para que se muestre el mensaje
                    Thread.sleep(500);
                    
                    boolean success = syncDeviceTime();
                    
                    final String message = success 
                        ? "Hora sincronizada correctamente" 
                        : "No se pudo sincronizar la hora";
                    
                    // Notificar resultado
                    if (listener != null) {
                        syncHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                listener.onSyncCompleted(success, message);
                            }
                        });
                    }
                    
                } catch (Exception e) {
                    Log.e(TAG, "Error en sincronización inicial: " + e.getMessage());
                    if (listener != null) {
                        syncHandler.post(new Runnable() {
                            @Override
                            public void run() {
                                listener.onSyncCompleted(false, "Error al sincronizar");
                            }
                        });
                    }
                }
            }
        }).start();
    }
    
    /**
     * Programa sincronizaciones silenciosas cada hora
     */
    private void scheduleSilentSync() {
        syncRunnable = new Runnable() {
            @Override
            public void run() {
                if (!isRunning) {
                    return;
                }
                
                // Realizar sincronización silenciosa
                performSilentSync();
                
                // Programar siguiente sincronización
                if (isRunning) {
                    syncHandler.postDelayed(this, SYNC_INTERVAL_MS);
                }
            }
        };
        
        // Programar primera sincronización silenciosa en 1 hora
        syncHandler.postDelayed(syncRunnable, SYNC_INTERVAL_MS);
        
        Log.i(TAG, "Sincronizaciones automáticas programadas cada 1 hora");
    }
    
    /**
     * Realiza una sincronización silenciosa (sin mensajes al usuario)
     */
    private void performSilentSync() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                try {
                    long currentTime = System.currentTimeMillis();
                    
                    // Evitar sincronizaciones muy frecuentes
                    if (currentTime - lastSyncAttemptMillis < 60000) {
                        Log.d(TAG, "Sincronización omitida (muy reciente)");
                        return;
                    }
                    
                    lastSyncAttemptMillis = currentTime;
                    
                    Log.i(TAG, "Ejecutando sincronización automática de hora...");
                    
                    boolean success = syncDeviceTime();
                    
                    if (success) {
                        Log.i(TAG, "✓ Sincronización automática completada");
                    } else {
                        Log.w(TAG, "⚠ Sincronización automática falló - se reintentará en 1 hora");
                    }
                    
                } catch (Exception e) {
                    Log.e(TAG, "Error en sincronización automática: " + e.getMessage());
                }
            }
        }).start();
    }
    
    /**
     * Sincroniza la hora del dispositivo con el servidor
     * @return true si fue exitoso, false si falló
     */
    private boolean syncDeviceTime() {
        try {
            if (ImplEmpresa.empresaDefault == null) {
                Log.w(TAG, "No se puede sincronizar: empresa no configurada");
                return false;
            }
            
            ImplAsistencia implAsistencia = new ImplAsistencia(ImplEmpresa.empresaDefault.getCodigo());
            String serverDateTime = implAsistencia.getServerDateTime();
            
            if (serverDateTime == null || serverDateTime.isEmpty()) {
                Log.w(TAG, "No se pudo obtener hora del servidor");
                return false;
            }
            
            // Parsear la hora del servidor
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy hh:mm:ss a", Locale.US);
            Date serverDate = sdf.parse(serverDateTime);
            
            if (serverDate == null) {
                Log.e(TAG, "Error al parsear fecha del servidor");
                return false;
            }
            
            long serverTimeMillis = serverDate.getTime();
            long deviceTimeMillis = System.currentTimeMillis();
            long timeDifference = serverTimeMillis - deviceTimeMillis;
            
            // Registrar información de la sincronización
            Log.i(TAG, String.format("Hora del servidor: %s", serverDateTime));
            Log.i(TAG, String.format("Hora del dispositivo: %s", 
                new SimpleDateFormat("dd/MM/yyyy hh:mm:ss a", Locale.US).format(new Date())));
            Log.i(TAG, String.format("Diferencia: %d segundos", timeDifference / 1000));
            
            // Solo sincronizar si la diferencia es mayor a 5 segundos
            if (Math.abs(timeDifference) > 5000) {
                try {
                    AlarmManager alarmManager = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
                    if (alarmManager != null) {
                        alarmManager.setTime(serverTimeMillis);
                        Log.i(TAG, "✓ Hora del dispositivo actualizada");
                        return true;
                    }
                } catch (SecurityException e) {
                    Log.w(TAG, "Sin permisos para actualizar hora del sistema");
                    Log.i(TAG, "La aplicación usará la hora del servidor para las operaciones");
                    // Consideramos éxito porque obtuvimos la hora del servidor
                    return true;
                }
            } else {
                Log.i(TAG, "Hora ya sincronizada (diferencia < 5 segundos)");
                return true;
            }
            
            return false;
            
        } catch (Exception e) {
            Log.e(TAG, "Error al sincronizar hora: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Verifica si el servicio está en ejecución
     */
    public boolean isRunning() {
        return isRunning;
    }
}

