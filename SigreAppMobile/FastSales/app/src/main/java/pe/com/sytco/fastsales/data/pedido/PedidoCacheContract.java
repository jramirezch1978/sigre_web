package pe.com.sytco.fastsales.data.pedido;

import android.provider.BaseColumns;

/**
 * Espejo local de PROFORMA / PROFORMA_DET (Oracle SIGRE) + metadatos de pestaña.
 * Caché temporal de pedidos no grabados en servidor.
 */
public final class PedidoCacheContract {

    private PedidoCacheContract() {
    }

    public static final String DATABASE_NAME = "pedido_cache.db";
    public static final int DATABASE_VERSION = 1;

    public static final class CacheProforma implements BaseColumns {
        public static final String TABLE_NAME = "cache_proforma";

        public static final String TAB_ID = "tab_id";
        public static final String NRO_PROFORMA = "nro_proforma";
        public static final String COD_ORIGEN = "cod_origen";
        public static final String FEC_REGISTRO = "fec_registro";
        public static final String FEC_EXPIRACION = "fec_expiracion";
        public static final String EMPRESA = "empresa";
        public static final String CLIENTE = "cliente";
        public static final String DIRECCION = "direccion";
        public static final String VENDEDOR = "vendedor";
        public static final String FLAG_ESTADO = "flag_estado";
        public static final String FLAG_FACTURA_BOLETA = "flag_factura_boleta";
        public static final String ITEM_DIRECCION = "item_direccion";
        public static final String OBSERVACION = "observacion";
        public static final String COD_USR = "cod_usr";
        public static final String COD_MONEDA = "cod_moneda";
        public static final String TASA_CAMBIO = "tasa_cambio";
        public static final String FLAG_TRANF_GRATUITA = "flag_tranf_gratuita";
        public static final String NOM_CLIENTE = "nom_cliente";
        public static final String RUC_DNI = "ruc_dni";
        public static final String UBIGEO = "ubigeo";
        public static final String TAB_TITLE = "tab_title";
        public static final String TAB_ORDER = "tab_order";
        public static final String UPDATED_AT = "updated_at";
        public static final String DIRTY = "dirty";
    }

    public static final class CacheProformaDet implements BaseColumns {
        public static final String TABLE_NAME = "cache_proforma_det";

        public static final String TAB_ID = "tab_id";
        public static final String NRO_PROFORMA = "nro_proforma";
        public static final String NRO_ITEM = "nro_item";
        public static final String COD_ART = "cod_art";
        public static final String ALMACEN = "almacen";
        public static final String CANTIDAD = "cantidad";
        public static final String PRECIO_VTA = "precio_vta";
        public static final String IGV = "igv";
        public static final String FEC_REGISTRO = "fec_registro";
        public static final String COD_USR = "cod_usr";
        public static final String PORC_IGV = "porc_igv";
        public static final String FLAG_AUTORIZADO = "flag_autorizado";
        public static final String PRECIO_VTA_ANT = "precio_vta_ant";
        public static final String CANT_FACTURADA = "cant_facturada";
        public static final String COD_SERVICIO = "cod_servicio";
        public static final String DESC_SERVICIO = "desc_servicio";
        public static final String LARGO = "largo";
        public static final String ANCHO = "ancho";
        public static final String DESCRIPCION = "descripcion";
        public static final String FLAG_BOLSA_PLASTICO = "flag_bolsa_plastico";
        public static final String ICBPER = "icbper";
        public static final String FLAG_AFECTO_IGV = "flag_afecto_igv";
        public static final String CANTIDAD_UND2 = "cantidad_und2";
        public static final String UND = "und";
        public static final String UND2 = "und2";
        public static final String FLAG_ELIMINADO = "flag_eliminado";
        public static final String FLAG_INSERTADO = "flag_insertado";
        public static final String FLAG_MODIFICADO = "flag_modificado";
    }
}
