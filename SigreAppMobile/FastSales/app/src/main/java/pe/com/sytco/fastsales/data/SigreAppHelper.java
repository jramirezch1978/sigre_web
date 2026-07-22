package pe.com.sytco.fastsales.data;

import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.BeanInventarioPallet;
import pe.com.sytco.fastsales.data.TgPosicionesContract.*;
import pe.com.sytco.fastsales.data.InventarioPalletsContract.*;

public class SigreAppHelper extends SQLiteOpenHelper {
    public static final int DATABASE_VERSION = 1;
    public static final String DATABASE_NAME = "/mnt/sdcard/sigreAppMovil.db";

    public SigreAppHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    @Override
    public void onCreate(SQLiteDatabase db) {
        db.execSQL("CREATE TABLE " + TgPosicionesEntry.TABLE_NAME + " ("
                + TgPosicionesEntry.ALMACEN + " TEXT NOT NULL,"
                + TgPosicionesEntry.DESC_ALMACEN + " TEXT NOT NULL,"
                + TgPosicionesEntry.ANAQUEL + " TEXT NOT NULL,"
                + TgPosicionesEntry.FILA + " TEXT NOT NULL,"
                + TgPosicionesEntry.COLUMNA + " TEXT NOT NULL, "
                + "PRIMARY KEY (" + TgPosicionesEntry.ALMACEN +", "
                                  + TgPosicionesEntry.ANAQUEL + ", "
                                  + TgPosicionesEntry.FILA + ", "
                                  + TgPosicionesEntry.COLUMNA + "))");

        db.execSQL("CREATE TABLE " + InventarioPalletsEntry.TABLE_NAME + " ("
                + InventarioPalletsEntry.FECHA + " TEXT   NOT NULL,"
                + InventarioPalletsEntry.ALMACEN + " TEXT NOT NULL,"
                + InventarioPalletsEntry.ANAQUEL + " TEXT NOT NULL,"
                + InventarioPalletsEntry.FILA + " TEXT NOT NULL,"
                + InventarioPalletsEntry.COLUMNA + " TEXT NOT NULL, "
                + InventarioPalletsEntry.NRO_PALLET + " TEXT NOT NULL, "
                + InventarioPalletsEntry.NRO_CAJAS + " REAL NOT NULL, "
                + InventarioPalletsEntry.COD_USR + " TEXT NOT NULL, "
                + InventarioPalletsEntry.LECTURA + " TEXT NOT NULL, "
                + "PRIMARY KEY ("
                + InventarioPalletsEntry.FECHA +", "
                + InventarioPalletsEntry.ALMACEN +", "
                + InventarioPalletsEntry.ANAQUEL + ", "
                + InventarioPalletsEntry.FILA + ", "
                + InventarioPalletsEntry.COLUMNA +", "
                + InventarioPalletsEntry.NRO_PALLET + "))");


        // Insertar datos iniciales
        //new LoadDataPosiciones(db).execute();

    }

    public long insertPosicion(TgPosiciones posicion) {
        SQLiteDatabase db = getWritableDatabase();

        return db.insert(
                TgPosicionesEntry.TABLE_NAME,
                null,
                posicion.toContentValues());
    }



    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // No hay operaciones
    }

    public void deletePosiciones() {
        SQLiteDatabase db = this.getWritableDatabase();
        db.execSQL("DELETE FROM " + TgPosicionesEntry.TABLE_NAME);
    }

    public List<BeanAlmacen> getAlmacenes() {
        SQLiteDatabase db = this.getWritableDatabase();

        List<BeanAlmacen> lista = new ArrayList<BeanAlmacen>();

        Cursor c = db.rawQuery("select distinct t.almacen, t.desc_almacen from tg_posiciones t", null);
        if (c.moveToFirst()){
            do{
                BeanAlmacen almacen = new BeanAlmacen();
                almacen.setAlmacen(c.getString(0));
                almacen.setDescAlmacen(c.getString(1));

                lista.add(almacen);
            }while(c.moveToNext());
        }

        return lista;
    }

    public List<String> getAnaqueles(String almacen) {
        SQLiteDatabase db = this.getWritableDatabase();
        String[] args = new String[] {almacen};


        List<String> lista = new ArrayList<String>();

        Cursor c = db.rawQuery("select distinct t.anaquel from tg_posiciones t where almacen = ?", args);
        if (c.moveToFirst()){
            do{

                lista.add(c.getString(0));
            }while(c.moveToNext());
        }

        return lista;
    }

    public List<String> getFilas(String almacen, String anaquel) {
        SQLiteDatabase db = this.getWritableDatabase();
        String[] args = new String[] {almacen, anaquel};


        List<String> lista = new ArrayList<String>();

        Cursor c = db.rawQuery("select distinct t.fila from tg_posiciones t where almacen = ? and anaquel = ?", args);
        if (c.moveToFirst()){
            do{

                lista.add(c.getString(0));
            }while(c.moveToNext());
        }

        return lista;
    }

    public List<BeanInventarioPallet> getColumnas(String fecha, String almacen, String anaquel, String fila) {
        SQLiteDatabase db = this.getWritableDatabase();
        String[] args = new String[] {almacen, anaquel, fila};


        List<BeanInventarioPallet> lista = new ArrayList<BeanInventarioPallet>();

        Cursor c = db.rawQuery("select t.almacen, t.anaquel, t.fila, t.columna,\n" +
                                    "       (select count(distinct ip.nro_pallet)\n" +
                                    "          from inventario_pallets ip\n" +
                                    "         where ip.almacen = t.almacen\n" +
                                    "           and ip.anaquel = t.anaquel\n" +
                                    "           and ip.fila    = t.fila" +
                                    "           and ip.columna = t.columna\n" +
                                    "           and ip.fecha   = \"" + fecha + "\") as nro_pallets,\n" +
                                    "       (select ifnull(sum(ip.nro_cajas),0)\n" +
                                    "          from inventario_pallets ip\n" +
                                    "         where ip.almacen = t.almacen\n" +
                                    "           and ip.anaquel = t.anaquel\n" +
                                    "           and ip.fila    = t.fila" +
                                    "           and ip.columna = t.columna" +
                                    "           and ip.fecha   = \"" + fecha + "\") as nro_cajas\n" +
                                    "from tg_posiciones t " +
                                    "where almacen = ? " +
                                    "  and anaquel = ? " +
                                    "  and fila = ? ", args);
        if (c.moveToFirst()){
            do{
                BeanInventarioPallet col = new BeanInventarioPallet();
                col.setFecha(fecha);
                col.setAlmacen(c.getString(0));
                col.setAnaquel(c.getString(1));
                col.setFila(c.getString(2));
                col.setColumna(c.getString(3));
                col.setNroPallets(c.getInt(4));
                col.setNroCajas(c.getDouble(5));

                lista.add(col);
            }while(c.moveToNext());
        }

        return lista;
    }

    public Long insertLectura(InventarioPallets reg) {
        SQLiteDatabase db = getWritableDatabase();

        return db.insert(
                InventarioPalletsEntry.TABLE_NAME,
                null,
                reg.toContentValues());
    }

    public boolean ValidarNroPallet(String nroPallet, String fecha) {
        SQLiteDatabase db = this.getWritableDatabase();
        String[] args = new String[] {fecha, nroPallet};


        Cursor c = db.rawQuery("select count(*) as nro_cajas\n" +
                                    "from inventario_pallets t " +
                                    "where fecha = ? " +
                                    "  and nro_pallet = ? ", args);
        if (c.moveToFirst()){
            do{
                if (c.getInt(0) == 0)
                    return false;
                else
                    return true;
            }while(c.moveToNext());
        }

        return false;
    }

    public void eliminarLectura(InventarioPallets reg) {
        SQLiteDatabase db = this.getWritableDatabase();

        String[] args = new String[] {reg.getFecha(), reg.getAlmacen(), reg.getAnaquel(), reg.getFila(), reg.getColumna()};

        db.execSQL( "DELETE FROM " + InventarioPalletsEntry.TABLE_NAME + " " +
                    "where fecha = ?" +
                    "  and almacen = ?" +
                    "  and anaquel = ?" +
                    "  and fila = ?" +
                    "  and columna = ?", args);
    }

    public void deleteInventarioPallet(BeanInventarioPallet reg) {
        SQLiteDatabase db = this.getWritableDatabase();

        String[] args = new String[] {reg.getFecha(), reg.getAlmacen(), reg.getAnaquel(), reg.getFila(), reg.getColumna()};

        db.execSQL( "DELETE FROM " + InventarioPalletsEntry.TABLE_NAME + " " +
                "where fecha = ?" +
                "  and almacen = ?" +
                "  and anaquel = ?" +
                "  and fila = ?" +
                "  and columna = ?", args);
    }

    public List<BeanInventarioPallet> getPalletsLeidos(BeanInventarioPallet reg) {
        SQLiteDatabase db = this.getWritableDatabase();
        String[] args = new String[] {reg.getFecha(), reg.getAlmacen(), reg.getAnaquel(), reg.getFila(), reg.getColumna()};


        List<BeanInventarioPallet> lista = new ArrayList<BeanInventarioPallet>();

        Cursor c = db.rawQuery("select t.fecha, t.almacen, t.anaquel, t.fila, t.columna, t.nro_pallet, t.nro_cajas, t.cod_usr, t.lectura\n" +
                                    "from inventario_pallets t " +
                                    "where fecha = ? " +
                                    "  and almacen = ? " +
                                    "  and anaquel = ? " +
                                    "  and fila = ? " +
                                    "  and columna = ?", args);
        if (c.moveToFirst()){
            do{
                BeanInventarioPallet col = new BeanInventarioPallet();
                col.setFecha(c.getString(0));
                col.setAlmacen(c.getString(1));
                col.setAnaquel(c.getString(2));
                col.setFila(c.getString(3));
                col.setColumna(c.getString(4));
                col.setNroPallet(c.getString(5));
                col.setNroCajas(c.getDouble(6));
                col.setCodUsr(c.getString(7));
                col.setLectura(c.getString(8));

                lista.add(col);
            }while(c.moveToNext());
        }

        return lista;
    }

    public List<BeanInventarioPallet> getInventario(String fecInventario) {
        SQLiteDatabase db = this.getWritableDatabase();
        String[] args = new String[] {fecInventario};


        List<BeanInventarioPallet> lista = new ArrayList<BeanInventarioPallet>();

        Cursor c = db.rawQuery("select t.fecha, t.almacen, t.anaquel, t.fila, t.columna, t.nro_pallet, t.nro_cajas, t.cod_usr, t.lectura\n" +
                "from inventario_pallets t " +
                "where fecha = ? " , args);
        if (c.moveToFirst()){
            do{
                BeanInventarioPallet col = new BeanInventarioPallet();
                col.setFecha(c.getString(0));
                col.setAlmacen(c.getString(1));
                col.setAnaquel(c.getString(2));
                col.setFila(c.getString(3));
                col.setColumna(c.getString(4));
                col.setNroPallet(c.getString(5));
                col.setNroCajas(c.getDouble(6));
                col.setCodUsr(c.getString(7));
                col.setLectura(c.getString(8));

                lista.add(col);
            }while(c.moveToNext());
        }

        return lista;
    }
}
