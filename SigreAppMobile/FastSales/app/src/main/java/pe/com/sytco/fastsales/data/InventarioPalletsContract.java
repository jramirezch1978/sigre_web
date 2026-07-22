package pe.com.sytco.fastsales.data;

import android.provider.BaseColumns;

public class InventarioPalletsContract {
    public static abstract class InventarioPalletsEntry implements BaseColumns {

        /*
            SQL> desc inventario_pallets
            Name       Type         Nullable Default Comments
            ---------- ------------ -------- ------- --------
            ALMACEN    CHAR(6)
            ANAQUEL    VARCHAR2(20)
            FILA       VARCHAR2(20)
            COLUMNA    VARCHAR2(20)
            FECHA      DATE
            NRO_PALLET CHAR(13)
            NRO_CAJAS  NUMBER(12,4)
            COD_USR    CHAR(6)
         */
        public static final String TABLE_NAME ="inventario_pallets";

        public static final String ALMACEN = "almacen";
        public static final String ANAQUEL = "anaquel";
        public static final String COLUMNA = "columna";
        public static final String FILA = "fila";
        public static final String FECHA = "fecha";
        public static final String NRO_PALLET = "nro_pallet";
        public static final String NRO_CAJAS = "nro_cajas";
        public static final String COD_USR = "cod_usr";
        public static final String LECTURA = "lectura";
    }
}
