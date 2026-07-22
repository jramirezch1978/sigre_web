package pe.com.sytco.fastsales.data;

import android.provider.BaseColumns;

public class TgPosicionesContract {
    public static abstract class TgPosicionesEntry implements BaseColumns {

        /*
        SQL> desc tg_posiciones
            Name    Type         Nullable Default Comments
            ------- ------------ -------- ------- --------
            ANAQUEL VARCHAR2(20)
            COLUMNA VARCHAR2(20)
            FILA    VARCHAR2(20)
            ALMACEN CHAR(6)
         */
        public static final String TABLE_NAME ="tg_posiciones";

        public static final String ALMACEN = "almacen";
        public static final String ANAQUEL = "anaquel";
        public static final String COLUMNA = "columna";
        public static final String FILA = "fila";
        public static final String DESC_ALMACEN = "desc_almacen";
    }
}
