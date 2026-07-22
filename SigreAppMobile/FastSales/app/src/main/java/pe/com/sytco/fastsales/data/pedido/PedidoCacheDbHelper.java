package pe.com.sytco.fastsales.data.pedido;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import pe.com.sytco.fastsales.data.pedido.PedidoCacheContract.CacheProforma;
import pe.com.sytco.fastsales.data.pedido.PedidoCacheContract.CacheProformaDet;

public class PedidoCacheDbHelper extends SQLiteOpenHelper {

    public PedidoCacheDbHelper(Context context) {
        super(context, PedidoCacheContract.DATABASE_NAME, null, PedidoCacheContract.DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE " + CacheProforma.TABLE_NAME + " ("
                + CacheProforma.TAB_ID + " TEXT PRIMARY KEY NOT NULL,"
                + CacheProforma.NRO_PROFORMA + " TEXT,"
                + CacheProforma.COD_ORIGEN + " TEXT,"
                + CacheProforma.FEC_REGISTRO + " TEXT,"
                + CacheProforma.FEC_EXPIRACION + " TEXT,"
                + CacheProforma.EMPRESA + " TEXT,"
                + CacheProforma.CLIENTE + " TEXT,"
                + CacheProforma.DIRECCION + " TEXT,"
                + CacheProforma.VENDEDOR + " TEXT,"
                + CacheProforma.FLAG_ESTADO + " TEXT,"
                + CacheProforma.FLAG_FACTURA_BOLETA + " TEXT,"
                + CacheProforma.ITEM_DIRECCION + " INTEGER,"
                + CacheProforma.OBSERVACION + " TEXT,"
                + CacheProforma.COD_USR + " TEXT,"
                + CacheProforma.COD_MONEDA + " TEXT,"
                + CacheProforma.TASA_CAMBIO + " REAL,"
                + CacheProforma.FLAG_TRANF_GRATUITA + " TEXT,"
                + CacheProforma.NOM_CLIENTE + " TEXT,"
                + CacheProforma.RUC_DNI + " TEXT,"
                + CacheProforma.UBIGEO + " TEXT,"
                + CacheProforma.TAB_TITLE + " TEXT,"
                + CacheProforma.TAB_ORDER + " INTEGER NOT NULL DEFAULT 0,"
                + CacheProforma.UPDATED_AT + " INTEGER NOT NULL,"
                + CacheProforma.DIRTY + " INTEGER NOT NULL DEFAULT 1"
                + ")");

        db.execSQL("CREATE TABLE " + CacheProformaDet.TABLE_NAME + " ("
                + CacheProformaDet.TAB_ID + " TEXT NOT NULL,"
                + CacheProformaDet.NRO_PROFORMA + " TEXT,"
                + CacheProformaDet.NRO_ITEM + " INTEGER NOT NULL,"
                + CacheProformaDet.COD_ART + " TEXT,"
                + CacheProformaDet.ALMACEN + " TEXT,"
                + CacheProformaDet.CANTIDAD + " REAL,"
                + CacheProformaDet.PRECIO_VTA + " REAL,"
                + CacheProformaDet.IGV + " REAL,"
                + CacheProformaDet.FEC_REGISTRO + " TEXT,"
                + CacheProformaDet.COD_USR + " TEXT,"
                + CacheProformaDet.PORC_IGV + " REAL,"
                + CacheProformaDet.FLAG_AUTORIZADO + " TEXT,"
                + CacheProformaDet.PRECIO_VTA_ANT + " REAL,"
                + CacheProformaDet.CANT_FACTURADA + " REAL,"
                + CacheProformaDet.COD_SERVICIO + " TEXT,"
                + CacheProformaDet.DESC_SERVICIO + " TEXT,"
                + CacheProformaDet.LARGO + " REAL,"
                + CacheProformaDet.ANCHO + " REAL,"
                + CacheProformaDet.DESCRIPCION + " TEXT,"
                + CacheProformaDet.FLAG_BOLSA_PLASTICO + " TEXT,"
                + CacheProformaDet.ICBPER + " REAL,"
                + CacheProformaDet.FLAG_AFECTO_IGV + " TEXT,"
                + CacheProformaDet.CANTIDAD_UND2 + " REAL,"
                + CacheProformaDet.UND + " TEXT,"
                + CacheProformaDet.UND2 + " TEXT,"
                + CacheProformaDet.FLAG_ELIMINADO + " TEXT,"
                + CacheProformaDet.FLAG_INSERTADO + " TEXT,"
                + CacheProformaDet.FLAG_MODIFICADO + " TEXT,"
                + "PRIMARY KEY (" + CacheProformaDet.TAB_ID + ", " + CacheProformaDet.NRO_ITEM + ")"
                + ")");
    }

    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        db.execSQL("DROP TABLE IF EXISTS " + CacheProformaDet.TABLE_NAME);
        db.execSQL("DROP TABLE IF EXISTS " + CacheProforma.TABLE_NAME);
        onCreate(db);
    }
}
