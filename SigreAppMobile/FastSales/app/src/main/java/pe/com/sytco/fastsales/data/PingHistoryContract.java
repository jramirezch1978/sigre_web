package pe.com.sytco.fastsales.data;

import android.provider.BaseColumns;

/**
 * Contrato para la tabla de historial de pings al servidor
 */
public class PingHistoryContract {
    
    // Constructor privado para prevenir instanciación accidental
    private PingHistoryContract() {}
    
    public static class PingEntry implements BaseColumns {
        public static final String TABLE_NAME = "ping_history";
        public static final String COLUMN_DEVICE_ID = "device_id";
        public static final String COLUMN_TIMESTAMP = "timestamp_ms"; // Timestamp con milisegundos
        public static final String COLUMN_ENDPOINT = "endpoint";
        public static final String COLUMN_LATENCY_MS = "latency_ms"; // Tiempo de respuesta total en ms
        public static final String COLUMN_DB_CONNECTION_MS = "db_connection_ms"; // Tiempo conexión BD en ms
        public static final String COLUMN_DB_QUERY_MS = "db_query_ms"; // Tiempo query BD en ms
        public static final String COLUMN_SUCCESS = "success"; // 1 = éxito, 0 = fallo
        public static final String COLUMN_ERROR_MESSAGE = "error_message";
    }
    
    public static final String SQL_CREATE_ENTRIES =
            "CREATE TABLE " + PingEntry.TABLE_NAME + " (" +
            PingEntry._ID + " INTEGER PRIMARY KEY AUTOINCREMENT," +
            PingEntry.COLUMN_DEVICE_ID + " TEXT NOT NULL," +
            PingEntry.COLUMN_TIMESTAMP + " INTEGER NOT NULL," +
            PingEntry.COLUMN_ENDPOINT + " TEXT NOT NULL," +
            PingEntry.COLUMN_LATENCY_MS + " INTEGER," +
            PingEntry.COLUMN_DB_CONNECTION_MS + " INTEGER," +
            PingEntry.COLUMN_DB_QUERY_MS + " INTEGER," +
            PingEntry.COLUMN_SUCCESS + " INTEGER NOT NULL," +
            PingEntry.COLUMN_ERROR_MESSAGE + " TEXT)";
    
    public static final String SQL_DELETE_ENTRIES =
            "DROP TABLE IF EXISTS " + PingEntry.TABLE_NAME;
}

