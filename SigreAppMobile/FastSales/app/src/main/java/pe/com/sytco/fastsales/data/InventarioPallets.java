package pe.com.sytco.fastsales.data;

import android.content.ContentValues;
import android.database.Cursor;

import pe.com.sytco.fastsales.data.InventarioPalletsContract.*;

public class InventarioPallets {
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

    private String _anaquel;
    private String _columna;
    private String _fila;
    private String _almacen;
    private String _fecha;
    private String _nroPallet;
    private Double _nroCajas;
    private String _codUsr;
    private String _lectura;





    public InventarioPallets(String fecha,
                             String almacen,
                             String anaquel,
                             String fila,
                             String columna,
                             String NroPallet,
                             Double nroCajas,
                             String codUsr) {

        this._fecha = fecha;
        this._almacen = almacen;
        this._anaquel = anaquel;
        this._fila = fila;
        this._columna = columna;
        this._nroPallet = NroPallet;
        this._nroCajas = nroCajas;
        this._codUsr = codUsr;
    }

    public InventarioPallets() {


    }

    public InventarioPallets(Cursor cursor) {
        _almacen = cursor.getString(cursor.getColumnIndex(InventarioPalletsEntry.ALMACEN));
        _anaquel = cursor.getString(cursor.getColumnIndex(InventarioPalletsEntry.ANAQUEL));
        _fila = cursor.getString(cursor.getColumnIndex(InventarioPalletsEntry.FILA));
        _columna = cursor.getString(cursor.getColumnIndex(InventarioPalletsEntry.COLUMNA));
        _fecha = cursor.getString(cursor.getColumnIndex(InventarioPalletsEntry.FECHA));
        _nroPallet = cursor.getString(cursor.getColumnIndex(InventarioPalletsEntry.NRO_PALLET));
        _nroCajas = cursor.getDouble(cursor.getColumnIndex(InventarioPalletsEntry.NRO_CAJAS));
        _codUsr = cursor.getString(cursor.getColumnIndex(InventarioPalletsEntry.COD_USR));
        _lectura = cursor.getString(cursor.getColumnIndex(InventarioPalletsEntry.LECTURA));

    }


    public ContentValues toContentValues() {
        ContentValues values = new ContentValues();
        values.put(InventarioPalletsEntry.FECHA, this._fecha);
        values.put(InventarioPalletsEntry.ALMACEN, this._almacen);
        values.put(InventarioPalletsEntry.ANAQUEL, this._anaquel);
        values.put(InventarioPalletsEntry.FILA, this._fila);
        values.put(InventarioPalletsEntry.COLUMNA, this._columna);
        values.put(InventarioPalletsEntry.NRO_PALLET, this._nroPallet);
        values.put(InventarioPalletsEntry.NRO_CAJAS, this._nroCajas);
        values.put(InventarioPalletsEntry.COD_USR, this._codUsr);
        values.put(InventarioPalletsEntry.LECTURA, this._lectura);

        return values;
    }

    public String getLectura() {
        return _lectura;
    }

    public void setLectura(String value) {
        this._lectura = value;
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


    public String getFecha() {
        return _fecha;
    }

    public void setFecha(String value) {
        this._fecha = value;
    }

    public String getNroPallet() {
        return _nroPallet;
    }

    public void setNroPallet(String value) {
        this._nroPallet = value;
    }

    public Double getNroCajas() {
        return _nroCajas;
    }

    public void setNroCajas(Double value) {
        this._nroCajas = value;
    }

    public String getCodUsr() {
        return _codUsr;
    }

    public void setCodUsr(String value) {
        this._codUsr = value;
    }


}
