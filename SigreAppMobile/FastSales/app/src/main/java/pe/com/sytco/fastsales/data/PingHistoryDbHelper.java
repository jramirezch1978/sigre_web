package pe.com.sytco.fastsales.data;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.beans.BeanPingHistory;

/**
 * Helper para gestionar la base de datos de historial de pings con versionado automático.
 * 
 * PATRÓN ORM-LIKE PARA MANEJAR CAMBIOS EN LA ESTRUCTURA:
 * 
 * Cuando necesites cambiar la estructura de la tabla:
 * 1. Incrementa DATABASE_VERSION en +1
 * 2. Agrega la lógica de migración en onUpgrade() según la versión anterior
 * 3. Los datos existentes se preservarán automáticamente usando ALTER TABLE
 * 
 * Ejemplo de versionado:
 * - Versión 1 (actual): device_id, timestamp, endpoint, latency_ms, success, error_message
 * - Versión 2 (futuro): + network_type (WiFi/Mobile/Ethernet)
 * - Versión 3 (futuro): + server_name, + battery_level
 * 
 * Este patrón permite que la app se actualice sin perder datos históricos.
 */
public class PingHistoryDbHelper extends SQLiteOpenHelper {
    
    private static final String TAG = "PingHistoryDbHelper";
    
    // IMPORTANTE: Incrementar DATABASE_VERSION cada vez que cambies la estructura
    public static final int DATABASE_VERSION = 1;
    public static final String DATABASE_NAME = "PingHistory.db";
    
    // Patrón Singleton: Solo una instancia de la base de datos
    private static PingHistoryDbHelper instance;
    
    /**
     * Obtiene la instancia singleton del helper.
     * Se inicializa automáticamente al primer uso.
     */
    public static synchronized PingHistoryDbHelper getInstance(Context context) {
        if (instance == null) {
            instance = new PingHistoryDbHelper(context.getApplicationContext());
            Log.i(TAG, "PingHistoryDbHelper singleton inicializado. Versión DB: " + DATABASE_VERSION);
        }
        return instance;
    }
    
    /**
     * Constructor privado para forzar uso del singleton
     */
    private PingHistoryDbHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }
    
    @Override
    public void onCreate(SQLiteDatabase db) {
        Log.i(TAG, "Creando tabla de historial de pings (primera vez)");
        db.execSQL(PingHistoryContract.SQL_CREATE_ENTRIES);
        Log.i(TAG, "Tabla '" + PingHistoryContract.PingEntry.TABLE_NAME + "' creada exitosamente");
    }
    
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        Log.i(TAG, "=== MIGRACIÓN DE BASE DE DATOS ===");
        Log.i(TAG, "Actualizando de versión " + oldVersion + " a " + newVersion);
        
        try {
            // Migración incremental: preserva datos existentes
            // Cada IF representa una versión específica
            
            /* EJEMPLO DE MIGRACIÓN FUTURA (cuando pases de v1 a v2):
            if (oldVersion < 2 && newVersion >= 2) {
                Log.i(TAG, "Aplicando migración a v2: agregando columna 'network_type'");
                db.execSQL("ALTER TABLE " + PingHistoryContract.PingEntry.TABLE_NAME + 
                          " ADD COLUMN network_type TEXT DEFAULT 'UNKNOWN'");
            }
            */
            
            /* EJEMPLO DE MIGRACIÓN FUTURA (cuando pases de v2 a v3):
            if (oldVersion < 3 && newVersion >= 3) {
                Log.i(TAG, "Aplicando migración a v3: agregando 'server_name' y 'battery_level'");
                db.execSQL("ALTER TABLE " + PingHistoryContract.PingEntry.TABLE_NAME + 
                          " ADD COLUMN server_name TEXT");
                db.execSQL("ALTER TABLE " + PingHistoryContract.PingEntry.TABLE_NAME + 
                          " ADD COLUMN battery_level INTEGER DEFAULT 100");
            }
            */
            
            // Si la migración no está definida, advertir (pero no destruir datos)
            if (oldVersion == newVersion) {
                Log.w(TAG, "No hay cambios de versión, no se requiere migración");
            }
            
            Log.i(TAG, "Migración completada exitosamente a versión " + newVersion);
            
        } catch (Exception e) {
            Log.e(TAG, "ERROR CRÍTICO durante la migración de base de datos", e);
            Log.e(TAG, "RECREANDO LA TABLA (se perderán datos)");
            
            // Solo como último recurso: recrear desde cero
            db.execSQL(PingHistoryContract.SQL_DELETE_ENTRIES);
            onCreate(db);
        }
    }
    
    @Override
    public void onDowngrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        Log.w(TAG, "=== DOWNGRADE DE BASE DE DATOS ===");
        Log.w(TAG, "Bajando de versión " + oldVersion + " a " + newVersion);
        Log.w(TAG, "Se recreará la tabla (se perderán datos)");
        
        // Para downgrade, recrear la tabla
        db.execSQL(PingHistoryContract.SQL_DELETE_ENTRIES);
        onCreate(db);
    }
    
    /**
     * Inserta un nuevo registro de ping con métricas completas
     */
    public long insertPing(String deviceId, long timestampMs, String endpoint, 
                          Long latencyMs, Long dbConnectionMs, Long dbQueryMs, 
                          boolean success, String errorMessage) {
        SQLiteDatabase db = this.getWritableDatabase();
        
        ContentValues values = new ContentValues();
        values.put(PingHistoryContract.PingEntry.COLUMN_DEVICE_ID, deviceId);
        values.put(PingHistoryContract.PingEntry.COLUMN_TIMESTAMP, timestampMs);
        values.put(PingHistoryContract.PingEntry.COLUMN_ENDPOINT, endpoint);
        values.put(PingHistoryContract.PingEntry.COLUMN_LATENCY_MS, latencyMs);
        values.put(PingHistoryContract.PingEntry.COLUMN_DB_CONNECTION_MS, dbConnectionMs);
        values.put(PingHistoryContract.PingEntry.COLUMN_DB_QUERY_MS, dbQueryMs);
        values.put(PingHistoryContract.PingEntry.COLUMN_SUCCESS, success ? 1 : 0);
        values.put(PingHistoryContract.PingEntry.COLUMN_ERROR_MESSAGE, errorMessage);
        
        return db.insert(PingHistoryContract.PingEntry.TABLE_NAME, null, values);
    }
    
    /**
     * Obtiene el promedio de latencia de los últimos N registros exitosos
     */
    public double getAverageLatency(int lastNRecords) {
        SQLiteDatabase db = this.getReadableDatabase();
        
        String query = "SELECT AVG(" + PingHistoryContract.PingEntry.COLUMN_LATENCY_MS + ") as avg_latency " +
                      "FROM (SELECT " + PingHistoryContract.PingEntry.COLUMN_LATENCY_MS + " " +
                      "FROM " + PingHistoryContract.PingEntry.TABLE_NAME + " " +
                      "WHERE " + PingHistoryContract.PingEntry.COLUMN_SUCCESS + " = 1 " +
                      "ORDER BY " + PingHistoryContract.PingEntry.COLUMN_TIMESTAMP + " DESC " +
                      "LIMIT ?)";
        
        Cursor cursor = db.rawQuery(query, new String[]{String.valueOf(lastNRecords)});
        
        double avgLatency = 0;
        if (cursor.moveToFirst()) {
            avgLatency = cursor.getDouble(0);
        }
        cursor.close();
        
        return avgLatency;
    }
    
    /**
     * Obtiene los últimos N registros de ping para la gráfica
     */
    public List<BeanPingHistory> getRecentPings(int limit) {
        List<BeanPingHistory> pingList = new ArrayList<>();
        SQLiteDatabase db = this.getReadableDatabase();
        
        String[] projection = {
            PingHistoryContract.PingEntry._ID,
            PingHistoryContract.PingEntry.COLUMN_DEVICE_ID,
            PingHistoryContract.PingEntry.COLUMN_TIMESTAMP,
            PingHistoryContract.PingEntry.COLUMN_ENDPOINT,
            PingHistoryContract.PingEntry.COLUMN_LATENCY_MS,
            PingHistoryContract.PingEntry.COLUMN_DB_CONNECTION_MS,
            PingHistoryContract.PingEntry.COLUMN_DB_QUERY_MS,
            PingHistoryContract.PingEntry.COLUMN_SUCCESS,
            PingHistoryContract.PingEntry.COLUMN_ERROR_MESSAGE
        };
        
        String sortOrder = PingHistoryContract.PingEntry.COLUMN_TIMESTAMP + " DESC";
        
        Cursor cursor = db.query(
            PingHistoryContract.PingEntry.TABLE_NAME,
            projection,
            null,
            null,
            null,
            null,
            sortOrder,
            String.valueOf(limit)
        );
        
        while (cursor.moveToNext()) {
            BeanPingHistory ping = new BeanPingHistory();
            ping.setId(cursor.getLong(cursor.getColumnIndexOrThrow(PingHistoryContract.PingEntry._ID)));
            ping.setDeviceId(cursor.getString(cursor.getColumnIndexOrThrow(PingHistoryContract.PingEntry.COLUMN_DEVICE_ID)));
            ping.setTimestampMs(cursor.getLong(cursor.getColumnIndexOrThrow(PingHistoryContract.PingEntry.COLUMN_TIMESTAMP)));
            ping.setEndpoint(cursor.getString(cursor.getColumnIndexOrThrow(PingHistoryContract.PingEntry.COLUMN_ENDPOINT)));
            
            int latencyIndex = cursor.getColumnIndexOrThrow(PingHistoryContract.PingEntry.COLUMN_LATENCY_MS);
            if (!cursor.isNull(latencyIndex)) {
                ping.setLatencyMs(cursor.getLong(latencyIndex));
            }
            
            int dbConnectionIndex = cursor.getColumnIndexOrThrow(PingHistoryContract.PingEntry.COLUMN_DB_CONNECTION_MS);
            if (!cursor.isNull(dbConnectionIndex)) {
                ping.setDbConnectionMs(cursor.getLong(dbConnectionIndex));
            }
            
            int dbQueryIndex = cursor.getColumnIndexOrThrow(PingHistoryContract.PingEntry.COLUMN_DB_QUERY_MS);
            if (!cursor.isNull(dbQueryIndex)) {
                ping.setDbQueryMs(cursor.getLong(dbQueryIndex));
            }
            
            ping.setSuccess(cursor.getInt(cursor.getColumnIndexOrThrow(PingHistoryContract.PingEntry.COLUMN_SUCCESS)) == 1);
            ping.setErrorMessage(cursor.getString(cursor.getColumnIndexOrThrow(PingHistoryContract.PingEntry.COLUMN_ERROR_MESSAGE)));
            
            pingList.add(ping);
        }
        cursor.close();
        
        return pingList;
    }
    
    /**
     * Calcula el promedio de tiempo de conexión a BD de los últimos N pings exitosos
     */
    public double getAverageDbConnection(int lastNRecords) {
        SQLiteDatabase db = this.getReadableDatabase();
        
        String query = "SELECT AVG(" + PingHistoryContract.PingEntry.COLUMN_DB_CONNECTION_MS + ") as avg_db_connection " +
                      "FROM (SELECT " + PingHistoryContract.PingEntry.COLUMN_DB_CONNECTION_MS + " " +
                      "FROM " + PingHistoryContract.PingEntry.TABLE_NAME + " " +
                      "WHERE " + PingHistoryContract.PingEntry.COLUMN_SUCCESS + " = 1 " +
                      "AND " + PingHistoryContract.PingEntry.COLUMN_DB_CONNECTION_MS + " IS NOT NULL " +
                      "ORDER BY " + PingHistoryContract.PingEntry.COLUMN_TIMESTAMP + " DESC " +
                      "LIMIT ?)";
        
        Cursor cursor = db.rawQuery(query, new String[]{String.valueOf(lastNRecords)});
        
        double avgDbConnection = 0;
        if (cursor.moveToFirst()) {
            avgDbConnection = cursor.getDouble(0);
        }
        cursor.close();
        
        return avgDbConnection;
    }
    
    /**
     * Calcula el promedio de tiempo de query a BD de los últimos N pings exitosos
     */
    public double getAverageDbQuery(int lastNRecords) {
        SQLiteDatabase db = this.getReadableDatabase();
        
        String query = "SELECT AVG(" + PingHistoryContract.PingEntry.COLUMN_DB_QUERY_MS + ") as avg_db_query " +
                      "FROM (SELECT " + PingHistoryContract.PingEntry.COLUMN_DB_QUERY_MS + " " +
                      "FROM " + PingHistoryContract.PingEntry.TABLE_NAME + " " +
                      "WHERE " + PingHistoryContract.PingEntry.COLUMN_SUCCESS + " = 1 " +
                      "AND " + PingHistoryContract.PingEntry.COLUMN_DB_QUERY_MS + " IS NOT NULL " +
                      "ORDER BY " + PingHistoryContract.PingEntry.COLUMN_TIMESTAMP + " DESC " +
                      "LIMIT ?)";
        
        Cursor cursor = db.rawQuery(query, new String[]{String.valueOf(lastNRecords)});
        
        double avgDbQuery = 0;
        if (cursor.moveToFirst()) {
            avgDbQuery = cursor.getDouble(0);
        }
        cursor.close();
        
        return avgDbQuery;
    }
    
    /**
     * Elimina TODOS los registros de ping (útil al finalizar sesión de login)
     * @return Número de registros eliminados
     */
    public int deleteAllPings() {
        SQLiteDatabase db = this.getWritableDatabase();
        int deletedRows = db.delete(PingHistoryContract.PingEntry.TABLE_NAME, null, null);
        Log.i(TAG, "Todos los registros de ping eliminados: " + deletedRows + " registros");
        return deletedRows;
    }
    
    /**
     * Limpia registros antiguos (mantiene solo los últimos N días)
     */
    public int cleanOldRecords(int daysToKeep) {
        SQLiteDatabase db = this.getWritableDatabase();
        
        long cutoffTime = System.currentTimeMillis() - (daysToKeep * 24L * 60L * 60L * 1000L);
        
        String selection = PingHistoryContract.PingEntry.COLUMN_TIMESTAMP + " < ?";
        String[] selectionArgs = { String.valueOf(cutoffTime) };
        
        return db.delete(PingHistoryContract.PingEntry.TABLE_NAME, selection, selectionArgs);
    }
}

