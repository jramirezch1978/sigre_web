package pe.com.sytco.fastsales.data.pedido;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProforma;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProformaDet;
import pe.com.sytco.fastsales.data.pedido.PedidoCacheContract.CacheProforma;
import pe.com.sytco.fastsales.data.pedido.PedidoCacheContract.CacheProformaDet;

/**
 * Persistencia temporal de pestañas de tomapedidos (espejo PROFORMA/PROFORMA_DET).
 */
public class PedidoCacheRepository {

    public static final class CachedTab {
        public String tabId;
        public String tabTitle;
        public int tabOrder;
        public ImplPedido pedido;
    }

    private final PedidoCacheDbHelper helper;

    public PedidoCacheRepository(Context context) {
        helper = new PedidoCacheDbHelper(context.getApplicationContext());
    }

    public static String newTabId() {
        return UUID.randomUUID().toString();
    }

    public synchronized void saveTab(String tabId, String tabTitle, int tabOrder, ImplPedido pedido) {
        if (tabId == null || pedido == null || pedido.getCabecera() == null) {
            return;
        }
        SQLiteDatabase db = helper.getWritableDatabase();
        db.beginTransaction();
        try {
            BeanProforma cab = pedido.getCabecera();
            ContentValues cv = new ContentValues();
            cv.put(CacheProforma.TAB_ID, tabId);
            cv.put(CacheProforma.NRO_PROFORMA, cab.getNroProforma());
            cv.put(CacheProforma.COD_ORIGEN, cab.getCodOrigen());
            cv.put(CacheProforma.FEC_REGISTRO, cab.getFecRegistro());
            cv.put(CacheProforma.EMPRESA, cab.getCodEmpresa());
            cv.put(CacheProforma.CLIENTE, cab.getCliente());
            cv.put(CacheProforma.DIRECCION, cab.getDireccion());
            cv.put(CacheProforma.VENDEDOR, cab.getVendedor());
            cv.put(CacheProforma.FLAG_ESTADO, cab.getFlagEstado());
            cv.put(CacheProforma.FLAG_FACTURA_BOLETA, cab.getFlagBoletaFactura());
            cv.put(CacheProforma.ITEM_DIRECCION, cab.getItemDireccion());
            cv.put(CacheProforma.COD_USR, cab.getCodUsuario());
            cv.put(CacheProforma.COD_MONEDA, cab.getMoneda());
            cv.put(CacheProforma.TASA_CAMBIO, cab.getTasaCambio());
            cv.put(CacheProforma.FLAG_TRANF_GRATUITA, cab.getFlagTranfGratuita());
            cv.put(CacheProforma.NOM_CLIENTE, cab.getNomCliente());
            cv.put(CacheProforma.RUC_DNI, cab.getRucDNI());
            cv.put(CacheProforma.UBIGEO, cab.getUbigeo());
            cv.put(CacheProforma.TAB_TITLE, tabTitle != null ? tabTitle : "Pedido");
            cv.put(CacheProforma.TAB_ORDER, tabOrder);
            cv.put(CacheProforma.UPDATED_AT, System.currentTimeMillis());
            cv.put(CacheProforma.DIRTY, 1);

            db.insertWithOnConflict(CacheProforma.TABLE_NAME, null, cv, SQLiteDatabase.CONFLICT_REPLACE);

            db.delete(CacheProformaDet.TABLE_NAME, CacheProformaDet.TAB_ID + "=?", new String[]{tabId});
            List<BeanProformaDet> detalle = pedido.getDetalle();
            if (detalle != null) {
                for (BeanProformaDet d : detalle) {
                    if (d == null) continue;
                    if ("1".equals(d.getFlagEliminado())) continue;
                    ContentValues dv = new ContentValues();
                    dv.put(CacheProformaDet.TAB_ID, tabId);
                    dv.put(CacheProformaDet.NRO_PROFORMA, d.getNroProforma());
                    dv.put(CacheProformaDet.NRO_ITEM, d.getNroItem());
                    dv.put(CacheProformaDet.COD_ART, d.getCodArt());
                    dv.put(CacheProformaDet.ALMACEN, d.getAlmacen());
                    dv.put(CacheProformaDet.CANTIDAD, d.getCantidad());
                    dv.put(CacheProformaDet.PRECIO_VTA, d.getPrecioVta());
                    dv.put(CacheProformaDet.IGV, d.getIgv());
                    dv.put(CacheProformaDet.COD_USR, d.getCodUsuario());
                    dv.put(CacheProformaDet.PORC_IGV, d.getPorcIGV());
                    dv.put(CacheProformaDet.FLAG_AUTORIZADO, d.getFlagAutorizado());
                    dv.put(CacheProformaDet.PRECIO_VTA_ANT, d.getPrecioVentaAnt());
                    dv.put(CacheProformaDet.DESCRIPCION, d.getDescripcion());
                    dv.put(CacheProformaDet.FLAG_BOLSA_PLASTICO, d.getFlagBolsaPlastico());
                    dv.put(CacheProformaDet.ICBPER, d.getICBPER());
                    dv.put(CacheProformaDet.FLAG_AFECTO_IGV, d.getFlagAfectoIGV());
                    dv.put(CacheProformaDet.CANTIDAD_UND2, d.getCantidadUnd2());
                    dv.put(CacheProformaDet.UND, d.getUnd());
                    dv.put(CacheProformaDet.UND2, d.getUnd2());
                    dv.put(CacheProformaDet.FLAG_ELIMINADO, d.getFlagEliminado());
                    dv.put(CacheProformaDet.FLAG_INSERTADO, d.getFlagInsertado());
                    dv.put(CacheProformaDet.FLAG_MODIFICADO, d.getFlagModificado());
                    db.insert(CacheProformaDet.TABLE_NAME, null, dv);
                }
            }
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    public synchronized void deleteTab(String tabId) {
        if (tabId == null) return;
        SQLiteDatabase db = helper.getWritableDatabase();
        db.beginTransaction();
        try {
            db.delete(CacheProformaDet.TABLE_NAME, CacheProformaDet.TAB_ID + "=?", new String[]{tabId});
            db.delete(CacheProforma.TABLE_NAME, CacheProforma.TAB_ID + "=?", new String[]{tabId});
            db.setTransactionSuccessful();
        } finally {
            db.endTransaction();
        }
    }

    public synchronized List<CachedTab> loadAllTabs(String empresaCodigo) throws Exception {
        List<CachedTab> result = new ArrayList<CachedTab>();
        SQLiteDatabase db = helper.getReadableDatabase();
        Cursor c = db.query(CacheProforma.TABLE_NAME, null,
                CacheProforma.DIRTY + "=1", null, null, null,
                CacheProforma.TAB_ORDER + " ASC, " + CacheProforma.UPDATED_AT + " ASC");
        try {
            while (c.moveToNext()) {
                String tabId = c.getString(c.getColumnIndexOrThrow(CacheProforma.TAB_ID));
                CachedTab tab = new CachedTab();
                tab.tabId = tabId;
                tab.tabTitle = c.getString(c.getColumnIndexOrThrow(CacheProforma.TAB_TITLE));
                tab.tabOrder = c.getInt(c.getColumnIndexOrThrow(CacheProforma.TAB_ORDER));
                tab.pedido = buildPedidoFromCursor(c, empresaCodigo, db, tabId);
                result.add(tab);
            }
        } finally {
            c.close();
        }
        return result;
    }

    private ImplPedido buildPedidoFromCursor(Cursor c, String empresaCodigo, SQLiteDatabase db, String tabId)
            throws Exception {
        ImplPedido pedido = new ImplPedido(empresaCodigo);
        pedido.newPedido();
        BeanProforma cab = pedido.getCabecera();
        cab.setNroProforma(c.getString(c.getColumnIndexOrThrow(CacheProforma.NRO_PROFORMA)));
        cab.setCodOrigen(c.getString(c.getColumnIndexOrThrow(CacheProforma.COD_ORIGEN)));
        cab.setFecRegistro(c.getString(c.getColumnIndexOrThrow(CacheProforma.FEC_REGISTRO)));
        cab.setCodEmpresa(c.getString(c.getColumnIndexOrThrow(CacheProforma.EMPRESA)));
        cab.setCliente(c.getString(c.getColumnIndexOrThrow(CacheProforma.CLIENTE)));
        cab.setDireccion(c.getString(c.getColumnIndexOrThrow(CacheProforma.DIRECCION)));
        cab.setVendedor(c.getString(c.getColumnIndexOrThrow(CacheProforma.VENDEDOR)));
        cab.setFlagEstado(c.getString(c.getColumnIndexOrThrow(CacheProforma.FLAG_ESTADO)));
        cab.setFlagBoletaFactura(c.getString(c.getColumnIndexOrThrow(CacheProforma.FLAG_FACTURA_BOLETA)));
        if (!c.isNull(c.getColumnIndexOrThrow(CacheProforma.ITEM_DIRECCION))) {
            cab.setItemDireccion(c.getInt(c.getColumnIndexOrThrow(CacheProforma.ITEM_DIRECCION)));
        }
        cab.setCodUsuario(c.getString(c.getColumnIndexOrThrow(CacheProforma.COD_USR)));
        cab.setMoneda(c.getString(c.getColumnIndexOrThrow(CacheProforma.COD_MONEDA)));
        if (!c.isNull(c.getColumnIndexOrThrow(CacheProforma.TASA_CAMBIO))) {
            cab.setTasaCambio(c.getDouble(c.getColumnIndexOrThrow(CacheProforma.TASA_CAMBIO)));
        }
        cab.setFlagTranfGratuita(c.getString(c.getColumnIndexOrThrow(CacheProforma.FLAG_TRANF_GRATUITA)));
        cab.setNomCliente(c.getString(c.getColumnIndexOrThrow(CacheProforma.NOM_CLIENTE)));
        cab.setRucDNI(c.getString(c.getColumnIndexOrThrow(CacheProforma.RUC_DNI)));
        cab.setUbigeo(c.getString(c.getColumnIndexOrThrow(CacheProforma.UBIGEO)));
        cab.setNuevo(true);

        pedido.ResetDetalle();
        Cursor d = db.query(CacheProformaDet.TABLE_NAME, null,
                CacheProformaDet.TAB_ID + "=?", new String[]{tabId},
                null, null, CacheProformaDet.NRO_ITEM + " ASC");
        try {
            while (d.moveToNext()) {
                BeanProformaDet det = new BeanProformaDet();
                det.setNroProforma(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.NRO_PROFORMA)));
                det.setNroItem(d.getInt(d.getColumnIndexOrThrow(CacheProformaDet.NRO_ITEM)));
                det.setCodArt(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.COD_ART)));
                det.setAlmacen(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.ALMACEN)));
                det.setCantidad(d.getDouble(d.getColumnIndexOrThrow(CacheProformaDet.CANTIDAD)));
                det.setPrecioVta(d.getDouble(d.getColumnIndexOrThrow(CacheProformaDet.PRECIO_VTA)));
                det.setIgv(d.getDouble(d.getColumnIndexOrThrow(CacheProformaDet.IGV)));
                det.setCodUsuario(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.COD_USR)));
                det.setPorcIGV(d.getDouble(d.getColumnIndexOrThrow(CacheProformaDet.PORC_IGV)));
                det.setFlagAutorizado(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.FLAG_AUTORIZADO)));
                det.setPrecioVentaAnt(d.getDouble(d.getColumnIndexOrThrow(CacheProformaDet.PRECIO_VTA_ANT)));
                det.setDescripcion(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.DESCRIPCION)));
                det.setFlagBolsaPlastico(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.FLAG_BOLSA_PLASTICO)));
                det.setICBPER(d.getDouble(d.getColumnIndexOrThrow(CacheProformaDet.ICBPER)));
                det.setFlagAfectoIGV(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.FLAG_AFECTO_IGV)));
                det.setCantidadUnd2(d.getDouble(d.getColumnIndexOrThrow(CacheProformaDet.CANTIDAD_UND2)));
                det.setUnd(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.UND)));
                det.setUnd2(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.UND2)));
                det.setFlagEliminado(nullTo(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.FLAG_ELIMINADO)), "0"));
                det.setFlagInsertado(nullTo(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.FLAG_INSERTADO)), "1"));
                det.setFlagModificado(nullTo(d.getString(d.getColumnIndexOrThrow(CacheProformaDet.FLAG_MODIFICADO)), "0"));
                pedido.getDetalle().add(det);
            }
        } finally {
            d.close();
        }
        return pedido;
    }

    private static String nullTo(String v, String def) {
        return v != null ? v : def;
    }
}
