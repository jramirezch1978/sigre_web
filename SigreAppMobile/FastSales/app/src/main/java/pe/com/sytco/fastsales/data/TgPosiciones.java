package pe.com.sytco.fastsales.data;

import android.content.ContentValues;
import android.database.Cursor;

import pe.com.sytco.fastsales.beans.Almacen.BeanPosiciones;
import pe.com.sytco.fastsales.data.TgPosicionesContract.*;

public class TgPosiciones {
     /*
        SQL> desc tg_posiciones
            Name    Type         Nullable Default Comments
            ------- ------------ -------- ------- --------
            ANAQUEL VARCHAR2(20)
            COLUMNA VARCHAR2(20)
            FILA    VARCHAR2(20)
            ALMACEN CHAR(6)
     */

     private String _anaquel;
     private String _columna;
     private String _fila;
     private String _almacen;
     private String _descAlmacen;

    public TgPosiciones(String almacen,
                        String descAlmacen,
                        String anaquel,
                        String fila,
                        String columna) {

        this._almacen = almacen;
        this._descAlmacen = descAlmacen;
        this._anaquel = anaquel;
        this._fila = fila;
        this._columna = columna;
    }

    public TgPosiciones() {


    }

    public TgPosiciones(Cursor cursor) {
        _almacen = cursor.getString(cursor.getColumnIndex(TgPosicionesEntry.ALMACEN));
        _anaquel = cursor.getString(cursor.getColumnIndex(TgPosicionesEntry.ANAQUEL));
        _fila = cursor.getString(cursor.getColumnIndex(TgPosicionesEntry.FILA));
        _columna = cursor.getString(cursor.getColumnIndex(TgPosicionesEntry.COLUMNA));
        _descAlmacen = cursor.getString(cursor.getColumnIndex(TgPosicionesEntry.DESC_ALMACEN));

    }


    public ContentValues toContentValues() {
        ContentValues values = new ContentValues();
        values.put(TgPosicionesEntry.ALMACEN, this._almacen);
        values.put(TgPosicionesEntry.DESC_ALMACEN, this._descAlmacen);
        values.put(TgPosicionesEntry.ANAQUEL, this._anaquel);
        values.put(TgPosicionesEntry.FILA, this._fila);
        values.put(TgPosicionesEntry.COLUMNA, this._columna);
        return values;
    }

    public String getAnaquel() {
        return _anaquel;
    }

    public void setAnaquel(String value) {
        this._anaquel = value;
    }

    public String getColumna() {
        return _columna;
    }

    public void setColumna(String value) {
        this._columna = value;
    }

    public String getFila() {
        return _fila;
    }

    public void setFila(String value) {
        this._fila = value;
    }

    public String getAlmacen() {
        return _almacen;
    }

    public void setAlmacen(String value) {
        this._almacen = value;
    }

    public String getDescAlmacen() {
        return _descAlmacen;
    }

    public void setDescAlmacen(String value) {
        this._descAlmacen = value;
    }

    public static TgPosiciones instanceOf(BeanPosiciones bean) {
        TgPosiciones posicion = new TgPosiciones();

        posicion.setAlmacen(bean.getAlmacen());
        posicion.setDescAlmacen(bean.getDescAlmacen());
        posicion.setAnaquel(bean.getAnaquel());
        posicion.setFila(bean.getFila());
        posicion.setColumna(bean.getColumna());


        return posicion;
    }
}
