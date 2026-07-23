package pe.com.hermes.appmobile.data.almacen;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Catálogo Almacén → Activity (por path y por código de ventana AL###).
 * Solo opciones con path real (igual criterio del menú móvil).
 */
public final class AlmacenVistasCatalog {

    /** AL### aunque vaya tras "_" (p. ej. ALMACEN_OP_MOV_AL013); evita falsos positivos tipo SAL001. */
    private static final Pattern VENTANA = Pattern.compile("(?i)(?<![A-Z0-9])AL\\d{3}(?![0-9])");

    private static final List<AlmacenVista> TODAS;
    private static final Map<String, AlmacenVista> POR_CODIGO;
    private static final Map<String, AlmacenVista> POR_VENTANA;
    private static final Map<String, AlmacenVista> POR_RUTA;

    static {
        List<AlmacenVista> list = new ArrayList<>();

        list.add(v("AL013", "ALMACEN_OP_MOV_GENERAL", "Movimiento de Almacén — General",
                "/sigre/almacen/operaciones/movimiento-general", AlmacenFuenteDatos.MOVIMIENTOS, null, "Operaciones"));
        list.add(v("AL014", "ALMACEN_OP_MOV_TRANSITO", "Movimiento de Almacén — Tránsito",
                "/sigre/almacen/operaciones/movimiento-transito", AlmacenFuenteDatos.MOVIMIENTOS, null, "Operaciones"));
        list.add(v("AL015", "ALMACEN_OP_OTR_GENERACION", "Orden de Traslado — Generación",
                "/sigre/almacen/operaciones/orden-traslado-generacion", AlmacenFuenteDatos.ORDENES_TRASLADO, null, "Operaciones"));
        list.add(v("AL016", "ALMACEN_OP_OTR_APROBACION", "Orden de Traslado — Aprobación",
                "/sigre/almacen/operaciones/orden-traslado-aprobacion", AlmacenFuenteDatos.ORDENES_TRASLADO, null, "Operaciones"));
        list.add(v("AL017", "ALMACEN_OP_INV_CONTEO", "Inventarios — Ingreso por Conteo",
                "/sigre/almacen/operaciones/inventario-conteo", AlmacenFuenteDatos.TOMAS_INVENTARIO, null, "Operaciones"));
        list.add(v("AL018", "ALMACEN_OP_INV_MONITOR", "Inventarios — Monitor por Conteo",
                "/sigre/almacen/operaciones/inventario-monitor", AlmacenFuenteDatos.TOMAS_INVENTARIO, null, "Operaciones"));

        list.add(v("AL019", "ALMACEN_CONS_MOV_ARTICULO", "Movimientos x artículo",
                "/sigre/almacen/consultas/movimientos-x-articulo", AlmacenFuenteDatos.KARDEX, null, "Consultas"));
        list.add(v("AL020", "ALMACEN_CONS_MOV_ALMACEN", "Consulta de movimientos de almacén",
                "/sigre/almacen/consultas/consulta-movimientos-almacen", AlmacenFuenteDatos.MOVIMIENTOS, null, "Consultas"));
        list.add(v("AL021", "ALMACEN_CONS_DEV_PREST", "Devoluciones y Préstamos",
                "/sigre/almacen/consultas/devoluciones-y-prestamos", AlmacenFuenteDatos.MOVIMIENTOS, null, "Consultas"));
        list.add(v("AL022", "ALMACEN_CONS_DESPACHOS", "Despachos",
                "/sigre/almacen/consultas/despachos", AlmacenFuenteDatos.MOVIMIENTOS, null, "Consultas"));
        list.add(v("AL023", "ALMACEN_CONS_ESP_ARTICULOS", "Consulta Especializada de Artículos",
                "/sigre/almacen/consultas/consulta-especializada-articulos", AlmacenFuenteDatos.STOCK, null, "Consultas"));

        list.add(v("AL024", "ALMACEN_REP_STOCK_FECHA", "Stock a la fecha",
                "/sigre/almacen/reportes/stock-fecha", AlmacenFuenteDatos.STOCK_A_FECHA, null, "Reportes"));
        list.add(v("AL025", "ALMACEN_REP_HIST_MOV", "Historial de movimiento",
                "/sigre/almacen/reportes/historial-movimiento", AlmacenFuenteDatos.KARDEX, null, "Reportes"));
        list.add(v("AL026", "ALMACEN_REP_VALORIZACION", "Valorización",
                "/sigre/almacen/reportes/valorizacion", AlmacenFuenteDatos.VALORIZACION, null, "Reportes"));
        list.add(v("AL027", "ALMACEN_REP_VENDIDOS_PERIODO", "Productos vendidos por periodo",
                "/sigre/almacen/reportes/productos-vendidos-por-periodo", AlmacenFuenteDatos.MOVIMIENTOS, null, "Reportes"));
        list.add(v("AL028", "ALMACEN_REP_STOCK_MINIMO", "Stock mínimo",
                "/sigre/almacen/reportes/stock-minimo", AlmacenFuenteDatos.STOCK, null, "Reportes"));
        list.add(v("AL029", "ALMACEN_REP_DIAG", "Diagnóstico de almacenes",
                "/sigre/almacen/reportes/diagnostico-almacenes", AlmacenFuenteDatos.DIAGNOSTICO, null, "Reportes"));
        list.add(v("AL030", "ALMACEN_REP_TOMA_INV", "Reportes de tomas de inventario",
                "/sigre/almacen/reportes/reporte-tomas-inventario", AlmacenFuenteDatos.TOMAS_INVENTARIO, null, "Reportes"));

        list.add(v("AL031", "ALMACEN_PROC_RECALCULO", "Recálculo de precios promedio",
                "/sigre/almacen/procesos/recalcular", AlmacenFuenteDatos.PROCESO,
                "/procesos/recalculo-precios-promedio", "Procesos"));
        list.add(v("AL032", "ALMACEN_PROC_CUADRE_STOCK", "Cuadres de stock",
                "/sigre/almacen/procesos/cuadre-stock", AlmacenFuenteDatos.PROCESO,
                "/procesos/cuadre-stock", "Procesos"));
        list.add(v("AL033", "ALMACEN_PROC_ACT_AUTO", "Actualización automática",
                "/sigre/almacen/procesos/actualizacion", AlmacenFuenteDatos.PROCESO,
                "/procesos/actualizacion-automatica", "Procesos"));

        list.add(v("AL101", "ALMACEN_TAB_ALMACENES", "Maestro de almacenes",
                "/sigre/almacen/tablas/almacenes", AlmacenFuenteDatos.ALMACENES, null, "Tablas"));
        list.add(v("AL102", "ALMACEN_TAB_TIPOS_MOV", "Tipos de movimientos",
                "/sigre/almacen/tablas/tipos-movimiento", AlmacenFuenteDatos.TIPOS_MOVIMIENTO, null, "Tablas"));
        list.add(v("AL103", "ALMACEN_TAB_MOTIVOS", "Motivos de traslado",
                "/sigre/almacen/tablas/motivos-traslado", AlmacenFuenteDatos.MOTIVOS_TRASLADO, null, "Tablas"));
        list.add(v("AL104", "ALMACEN_TAB_LOTES", "Ingreso de lotes",
                "/sigre/almacen/tablas/lotes", AlmacenFuenteDatos.LOTES, null, "Tablas"));

        TODAS = Collections.unmodifiableList(list);
        Map<String, AlmacenVista> byCod = new LinkedHashMap<>();
        Map<String, AlmacenVista> byVen = new LinkedHashMap<>();
        Map<String, AlmacenVista> byRuta = new LinkedHashMap<>();
        for (AlmacenVista x : list) {
            byCod.put(x.codigo.toUpperCase(Locale.ROOT), x);
            if (x.codigoVentana != null) {
                byVen.put(x.codigoVentana.toUpperCase(Locale.ROOT), x);
            }
            if (x.ruta != null) {
                byRuta.put(normalizarRuta(x.ruta), x);
            }
        }
        POR_CODIGO = Collections.unmodifiableMap(byCod);
        POR_VENTANA = Collections.unmodifiableMap(byVen);
        POR_RUTA = Collections.unmodifiableMap(byRuta);
    }

    private AlmacenVistasCatalog() {}

    private static AlmacenVista v(String codigoVentana, String codigo, String nombre, String ruta,
                                  AlmacenFuenteDatos fuente, String procesoPath, String grupo) {
        return new AlmacenVista(codigo, codigoVentana, nombre, ruta, fuente, procesoPath, grupo);
    }

    public static List<AlmacenVista> todas() {
        return TODAS;
    }

    /** Solo vistas con path y Activity/listado/proceso. */
    public static List<AlmacenVista> navegables() {
        List<AlmacenVista> out = new ArrayList<>();
        for (AlmacenVista v : TODAS) {
            if (v.esNavegable()) out.add(v);
        }
        return out;
    }

    public static List<AlmacenVista> porGrupo(String grupo) {
        List<AlmacenVista> out = new ArrayList<>();
        for (AlmacenVista v : navegables()) {
            if (grupo.equals(v.grupo)) out.add(v);
        }
        return out;
    }

    public static AlmacenVista porCodigo(String codigo) {
        if (codigo == null || codigo.isBlank()) return null;
        return POR_CODIGO.get(codigo.trim().toUpperCase(Locale.ROOT));
    }

    public static AlmacenVista porCodigoVentana(String codigoVentana) {
        if (codigoVentana == null || codigoVentana.isBlank()) return null;
        return POR_VENTANA.get(codigoVentana.trim().toUpperCase(Locale.ROOT));
    }

    /**
     * Resuelve vista desde código menú / path / texto que contenga AL###.
     * Ej.: {@code ALMACEN_OP_MOV_AL013}, {@code ...AL301...}, path con segmento conocido.
     */
    public static AlmacenVista resolver(String codigoMenu, String pathUrl, String nombre) {
        AlmacenVista v = porCodigo(codigoMenu);
        if (v != null) return v;

        String ventana = extraerCodigoVentana(codigoMenu);
        if (ventana == null) ventana = extraerCodigoVentana(nombre);
        if (ventana == null) ventana = extraerCodigoVentana(pathUrl);
        v = porCodigoVentana(ventana);
        if (v != null) return v;

        if (codigoMenu != null) {
            String up = codigoMenu.toUpperCase(Locale.ROOT);
            for (AlmacenVista cand : TODAS) {
                if (cand.codigoVentana != null && up.contains(cand.codigoVentana)) {
                    return cand;
                }
                if (up.contains(cand.codigo)) {
                    return cand;
                }
            }
        }

        return porRutaOPath(pathUrl);
    }

    public static String extraerCodigoVentana(String texto) {
        if (texto == null || texto.isBlank()) return null;
        Matcher m = VENTANA.matcher(texto);
        return m.find() ? m.group().toUpperCase(Locale.ROOT) : null;
    }

    public static AlmacenVista porRutaOPath(String pathUrl) {
        if (pathUrl == null || pathUrl.isBlank()) return null;
        String n = normalizarRuta(pathUrl);
        AlmacenVista exacta = POR_RUTA.get(n);
        if (exacta != null) return exacta;
        for (Map.Entry<String, AlmacenVista> e : POR_RUTA.entrySet()) {
            if (n.endsWith(e.getKey()) || e.getKey().endsWith(n) || n.contains(stripSigre(e.getKey()))) {
                return e.getValue();
            }
        }
        if (n.contains("movimiento-general") || n.contains("movimiento-transito")) {
            return POR_CODIGO.get("ALMACEN_OP_MOV_GENERAL");
        }
        if (n.contains("orden-traslado-aprobacion")) return POR_CODIGO.get("ALMACEN_OP_OTR_APROBACION");
        if (n.contains("orden-traslado")) return POR_CODIGO.get("ALMACEN_OP_OTR_GENERACION");
        if (n.contains("inventario-monitor")) return POR_CODIGO.get("ALMACEN_OP_INV_MONITOR");
        if (n.contains("inventario-conteo")) return POR_CODIGO.get("ALMACEN_OP_INV_CONTEO");
        if (n.contains("movimientos-x-articulo") || n.contains("historial-movimiento") || n.contains("kardex")) {
            return POR_CODIGO.get("ALMACEN_CONS_MOV_ARTICULO");
        }
        if (n.contains("consulta-especializada") || n.contains("stock-minimo")) {
            return POR_CODIGO.get("ALMACEN_CONS_ESP_ARTICULOS");
        }
        if (n.contains("valorizacion")) return POR_CODIGO.get("ALMACEN_REP_VALORIZACION");
        if (n.contains("diagnostico")) return POR_CODIGO.get("ALMACEN_REP_DIAG");
        if (n.contains("stock-fecha") || n.contains("stock-a-fecha")) return POR_CODIGO.get("ALMACEN_REP_STOCK_FECHA");
        if (n.contains("tablas/almacenes")) return POR_CODIGO.get("ALMACEN_TAB_ALMACENES");
        if (n.contains("tipos-movimiento")) return POR_CODIGO.get("ALMACEN_TAB_TIPOS_MOV");
        if (n.contains("motivos-traslado")) return POR_CODIGO.get("ALMACEN_TAB_MOTIVOS");
        if (n.contains("/lotes")) return POR_CODIGO.get("ALMACEN_TAB_LOTES");
        if (n.contains("cuadre-stock")) return POR_CODIGO.get("ALMACEN_PROC_CUADRE_STOCK");
        if (n.contains("actualizacion")) return POR_CODIGO.get("ALMACEN_PROC_ACT_AUTO");
        if (n.contains("recalcular")) return POR_CODIGO.get("ALMACEN_PROC_RECALCULO");
        if (n.contains("consulta-movimientos") || n.contains("devoluciones-y-prestamos") || n.contains("despachos")) {
            return POR_CODIGO.get("ALMACEN_CONS_MOV_ALMACEN");
        }
        return null;
    }

    public static String normalizarRuta(String path) {
        String p = path.trim().toLowerCase(Locale.ROOT).replace('\\', '/');
        if (!p.startsWith("/")) p = "/" + p;
        if (p.startsWith("/sigre/")) return p;
        if (p.startsWith("/almacen/")) return "/sigre" + p;
        return p;
    }

    private static String stripSigre(String ruta) {
        return ruta.startsWith("/sigre") ? ruta.substring("/sigre".length()) : ruta;
    }
}
