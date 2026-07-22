package pe.com.sytco.fastsales.Services;

import android.os.Handler;
import android.os.Looper;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import pe.com.sytco.fastsales.Controller.ImplSegLoginDevice;
import pe.com.sytco.fastsales.beans.BeanPingHistory;
import pe.com.sytco.fastsales.beans.parametro;
import pe.com.sytco.fastsales.data.PingHistoryDbHelper;

/**
 * Servicio para monitorear la conexión al servidor cada segundo
 * Mide la latencia (ping) y actualiza el estado de conexión
 * 
 * IMPORTANTE: Usa un ExecutorService dedicado para NO saturar el THREAD_POOL_EXECUTOR
 * de AsyncTask, que es compartido por otras operaciones críticas (carga de logos, etc.)
 */
public class ConnectionMonitorService {
    
    private static final long MONITOR_INTERVAL_MS = 1000; // 1 segundo
    private static final String WSDL = "SigreWebService/ImplHealth?wsdl";
    private static final String METHOD_NAME = "ping";
    
    // ExecutorService dedicado para pings - NO interfiere con AsyncTasks
    private static final ExecutorService PING_EXECUTOR = Executors.newSingleThreadExecutor(r -> {
        Thread t = new Thread(r, "ConnectionMonitor-Thread");
        t.setDaemon(true); // Thread daemon, no bloquea la salida de la app
        return t;
    });
    
    private Handler handler;
    private Runnable monitorRunnable;
    private boolean isRunning = false;
    private ConnectionStatusListener listener;
    private PingHistoryDbHelper dbHelper;
    private String deviceId;
    
    // Lista para mantener los últimos N pings en memoria (para la gráfica en tiempo real)
    private List<BeanPingHistory> recentPings;
    private static final int MAX_RECENT_PINGS = 60; // Últimos 60 segundos
    
    public interface ConnectionStatusListener {
        void onConnectionStatusChanged(boolean isConnected, Long latencyMs);
        void onPingUpdated(BeanPingHistory ping);
    }
    
    public ConnectionMonitorService(ConnectionStatusListener listener, PingHistoryDbHelper dbHelper) {
        this.listener = listener;
        this.dbHelper = dbHelper;
        this.recentPings = new ArrayList<>();
        
        // Obtener el ID del dispositivo
        if (ImplSegLoginDevice.currentDevice != null) {
            this.deviceId = ImplSegLoginDevice.currentDevice.getNroParte();
        } else {
            this.deviceId = "UNKNOWN";
        }
        
        handler = new Handler(Looper.getMainLooper());
        
        monitorRunnable = new Runnable() {
            @Override
            public void run() {
                if (isRunning) {
                    // Ejecutar ping en ExecutorService dedicado (NO en AsyncTask pool)
                    // Esto evita saturar el THREAD_POOL_EXECUTOR usado por otros AsyncTasks críticos
                    PING_EXECUTOR.execute(new Runnable() {
                        @Override
                        public void run() {
                            BeanPingHistory pingResult = executePing();
                            
                            // Notificar resultado en UI thread
                            handler.post(new Runnable() {
                                @Override
                                public void run() {
                                    onPingComplete(pingResult);
                                }
                            });
                        }
                    });
                    
                    // Programar el siguiente ping
                    handler.postDelayed(this, MONITOR_INTERVAL_MS);
                }
            }
        };
    }
    
    /**
     * Inicia el monitoreo continuo
     */
    public void start() {
        if (!isRunning) {
            isRunning = true;
            handler.post(monitorRunnable);
        }
    }
    
    /**
     * Detiene el monitoreo
     */
    public void stop() {
        isRunning = false;
        handler.removeCallbacks(monitorRunnable);
    }
    
    /**
     * Obtiene los pings recientes en memoria para la gráfica
     */
    public List<BeanPingHistory> getRecentPings() {
        return new ArrayList<>(recentPings);
    }
    
    /**
     * Obtiene el promedio de latencia de los pings recientes
     */
    public double getAverageLatency() {
        if (dbHelper == null) return 0;
        return dbHelper.getAverageLatency(30); // Promedio de los últimos 30 pings
    }
    
    /**
     * Ejecuta el ping en el ExecutorService dedicado (NO bloquea AsyncTasks)
     */
    private BeanPingHistory executePing() {
        long startTime = System.currentTimeMillis();
        BeanPingHistory pingResult = new BeanPingHistory();
        
        pingResult.setDeviceId(deviceId);
        pingResult.setTimestampMs(startTime);
        pingResult.setEndpoint(WSDL);
        
        try {
            // Obtener el código de empresa actual desde ImplEmpresa.empresaDefault
            String empresaCode = null;
            if (pe.com.sytco.fastsales.Controller.ImplEmpresa.empresaDefault != null) {
                empresaCode = pe.com.sytco.fastsales.Controller.ImplEmpresa.empresaDefault.getCodigo();
            }
            
            // Crear parámetros para el método ping (con código de empresa para medir BD)
            List<parametro> listaParam = new ArrayList<>();
            listaParam.add(new parametro("empresaCode", empresaCode));
            
            // Ejecutar ping
            Object result = new SOAPClient().Connect(WSDL, METHOD_NAME, listaParam);
            
            // Calcular latencia total
            long endTime = System.currentTimeMillis();
            long latency = endTime - startTime;
            
            if (result != null && result instanceof SoapObject) {
                SoapObject soapResult = (SoapObject) result;
                
                // Extraer métricas del StrRespuesta
                boolean isOk = false;
                Long dbConnectionMs = null;
                Long dbQueryMs = null;
                
                try {
                    // Verificar si el ping fue exitoso
                    Object isOkObj = soapResult.getProperty("isOk");
                    isOk = Boolean.parseBoolean(isOkObj.toString());
                    
                    // Extraer métricas de BD de los campos:
                    // - count: tiempo total
                    // - double1: tiempo conexión BD
                    // - float1: tiempo query BD
                    Object double1Obj = soapResult.getProperty("double1");
                    Object float1Obj = soapResult.getProperty("float1");
                    
                    // Log para diagnóstico
                    android.util.Log.i("ConnectionMonitor", String.format(
                        "Respuesta SOAP - isOk:%s, double1:%s, float1:%s",
                        isOkObj, double1Obj, float1Obj));
                    
                    if (double1Obj != null) {
                        try {
                            double doubleValue = Double.parseDouble(double1Obj.toString());
                            if (doubleValue > 0) {
                                dbConnectionMs = (long) doubleValue;
                            }
                        } catch (NumberFormatException nfe) {
                            android.util.Log.w("ConnectionMonitor", "No se pudo parsear double1: " + double1Obj);
                        }
                    }
                    
                    if (float1Obj != null) {
                        try {
                            float floatValue = Float.parseFloat(float1Obj.toString());
                            if (floatValue > 0) {
                                dbQueryMs = (long) floatValue;
                            }
                        } catch (NumberFormatException nfe) {
                            android.util.Log.w("ConnectionMonitor", "No se pudo parsear float1: " + float1Obj);
                        }
                    }
                    
                } catch (Exception e) {
                    // Si falla al parsear, asumir éxito básico
                    isOk = true;
                    android.util.Log.e("ConnectionMonitor", "Error al extraer métricas: " + e.getMessage());
                }
                
                // Ping exitoso
                pingResult.setSuccess(isOk);
                pingResult.setLatencyMs(latency);
                pingResult.setDbConnectionMs(dbConnectionMs);
                pingResult.setDbQueryMs(dbQueryMs);
                
            } else {
                // Sin respuesta
                pingResult.setSuccess(false);
                pingResult.setLatencyMs(latency);
                pingResult.setErrorMessage("No response from server");
            }
            
        } catch (Exception ex) {
            // Error en el ping
            long endTime = System.currentTimeMillis();
            long latency = endTime - startTime;
            
            pingResult.setSuccess(false);
            pingResult.setLatencyMs(latency);
            pingResult.setErrorMessage(ex.getMessage());
        }
        
        return pingResult;
    }
    
    /**
     * Procesa el resultado del ping en el UI thread
     */
    private void onPingComplete(BeanPingHistory pingResult) {
        if (pingResult != null) {
            // Guardar en base de datos con todas las métricas
            if (dbHelper != null) {
                dbHelper.insertPing(
                    pingResult.getDeviceId(),
                    pingResult.getTimestampMs(),
                    pingResult.getEndpoint(),
                    pingResult.getLatencyMs(),
                    pingResult.getDbConnectionMs(),
                    pingResult.getDbQueryMs(),
                    pingResult.isSuccess(),
                    pingResult.getErrorMessage()
                );
            }
            
            // Agregar a la lista de pings recientes en memoria
            recentPings.add(pingResult);
            
            // Mantener solo los últimos N pings en memoria
            if (recentPings.size() > MAX_RECENT_PINGS) {
                recentPings.remove(0);
            }
            
            // Notificar al listener
            if (listener != null) {
                listener.onConnectionStatusChanged(pingResult.isSuccess(), pingResult.getLatencyMs());
                listener.onPingUpdated(pingResult);
            }
        }
    }
}

