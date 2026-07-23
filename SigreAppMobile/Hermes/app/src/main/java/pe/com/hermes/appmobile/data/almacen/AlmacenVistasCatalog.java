package pe.com.hermes.appmobile.data.almacen;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

/**
 * Catálogo de opciones Almacén migrables a Hermes (espejo del config Angular).
 * Fase 1: listados/procesos con API real. Opciones seed sin path/API → {@link AlmacenFuenteDatos#NONE}.
 */
public final class AlmacenVistasCatalog {

    private static final List<AlmacenVista> TODAS;
    private static final Map<String, AlmacenVista> POR_CODIGO;
    private static final Map<String, AlmacenVista> POR_RUTA;

    static {
        List<AlmacenVista> list = new ArrayList<>();

        // ── Operaciones ──
        list.add(v("ALMACEN_OP_MOV_GENERAL", "Movimiento de Almacén — General",
                "/sigre/almacen/operaciones/movimiento-general", AlmacenFuenteDatos.MOVIMIENTOS, null, "Operaciones"));
        list.add(v("ALMACEN_OP_MOV_TRANSITO", "Movimiento de Almacén — Tránsito",
                "/sigre/almacen/operaciones/movimiento-transito", AlmacenFuenteDatos.MOVIMIENTOS, null, "Operaciones"));
        list.add(v("ALMACEN_OP_OTR_GENERACION", "Orden de Traslado — Generación",
                "/sigre/almacen/operaciones/orden-traslado-generacion", AlmacenFuenteDatos.ORDENES_TRASLADO, null, "Operaciones"));
        list.add(v("ALMACEN_OP_OTR_APROBACION", "Orden de Traslado — Aprobación",
                "/sigre/almacen/operaciones/orden-traslado-aprobacion", AlmacenFuenteDatos.ORDENES_TRASLADO, null, "Operaciones"));
        list.add(v("ALMACEN_OP_INV_CONTEO", "Inventarios — Ingreso por Conteo",
                "/sigre/almacen/operaciones/inventario-conteo", AlmacenFuenteDatos.TOMAS_INVENTARIO, null, "Operaciones"));
        list.add(v("ALMACEN_OP_INV_MONITOR", "Inventarios — Monitor por Conteo",
                "/sigre/almacen/operaciones/inventario-monitor", AlmacenFuenteDatos.TOMAS_INVENTARIO, null, "Operaciones"));

        // Seed sin path_url en web (menú visible pero no cableado) — se muestran como en construcción
        list.add(v("ALMACEN_OP_DESPACHO_SIMPL", "Despacho Simplificado",
                null, AlmacenFuenteDatos.NONE, null, "Operaciones"));
        list.add(v("ALMACEN_OP_MOD_POSICIONES", "Modificar Posiciones en saldos x Almacén",
                null, AlmacenFuenteDatos.NONE, null, "Operaciones"));
        list.add(v("ALMACEN_OP_CONSIGNACIONES", "Consignaciones",
                null, AlmacenFuenteDatos.NONE, null, "Operaciones"));
        list.add(v("ALMACEN_OP_ITEMS_NO_ATENDER", "Items a no atenderse",
                null, AlmacenFuenteDatos.NONE, null, "Operaciones"));
        list.add(v("ALMACEN_OP_DEV_PREST", "Devoluciones/Préstamos",
                null, AlmacenFuenteDatos.NONE, null, "Operaciones"));
        list.add(v("ALMACEN_OP_AJUSTE_VAL", "Ajustes de valorización",
                null, AlmacenFuenteDatos.NONE, null, "Operaciones"));
        list.add(v("ALMACEN_OP_SOL_PEDIDO", "Solicitud de Pedido",
                "/sigre/almacen/operaciones/solicitud-pedido", AlmacenFuenteDatos.SOLICITUDES_SALIDA, null, "Operaciones"));
        list.add(v("ALMACEN_OP_INGRESO_MASIVO", "Parte de Ingreso masivo",
                null, AlmacenFuenteDatos.NONE, null, "Operaciones"));
        list.add(v("ALMACEN_OP_GUIAS", "Guías de Remisión",
                "/sigre/almacen/operaciones/guias-remision", AlmacenFuenteDatos.GUIAS_REMISION, null, "Operaciones"));

        // ── Consultas ──
        list.add(v("ALMACEN_CONS_MOV_ARTICULO", "Movimientos x artículo",
                "/sigre/almacen/consultas/movimientos-x-articulo", AlmacenFuenteDatos.KARDEX, null, "Consultas"));
        list.add(v("ALMACEN_CONS_MOV_ALMACEN", "Consulta de movimientos de almacén",
                "/sigre/almacen/consultas/consulta-movimientos-almacen", AlmacenFuenteDatos.MOVIMIENTOS, null, "Consultas"));
        list.add(v("ALMACEN_CONS_DEV_PREST", "Devoluciones y Préstamos",
                "/sigre/almacen/consultas/devoluciones-y-prestamos", AlmacenFuenteDatos.MOVIMIENTOS, null, "Consultas"));
        list.add(v("ALMACEN_CONS_DESPACHOS", "Despachos",
                "/sigre/almacen/consultas/despachos", AlmacenFuenteDatos.MOVIMIENTOS, null, "Consultas"));
        list.add(v("ALMACEN_CONS_ESP_ARTICULOS", "Consulta Especializada de Artículos",
                "/sigre/almacen/consultas/consulta-especializada-articulos", AlmacenFuenteDatos.STOCK, null, "Consultas"));

        // ── Reportes ──
        list.add(v("ALMACEN_REP_STOCK_FECHA", "Stock a la fecha",
                "/sigre/almacen/reportes/stock-fecha", AlmacenFuenteDatos.STOCK_A_FECHA, null, "Reportes"));
        list.add(v("ALMACEN_REP_HIST_MOV", "Historial de movimiento",
                "/sigre/almacen/reportes/historial-movimiento", AlmacenFuenteDatos.KARDEX, null, "Reportes"));
        list.add(v("ALMACEN_REP_VALORIZACION", "Valorización",
                "/sigre/almacen/reportes/valorizacion", AlmacenFuenteDatos.VALORIZACION, null, "Reportes"));
        list.add(v("ALMACEN_REP_STOCK_MINIMO", "Stock mínimo",
                "/sigre/almacen/reportes/stock-minimo", AlmacenFuenteDatos.STOCK, null, "Reportes"));
        list.add(v("ALMACEN_REP_DIAG", "Diagnóstico de almacenes",
                "/sigre/almacen/reportes/diagnostico-almacenes", AlmacenFuenteDatos.DIAGNOSTICO, null, "Reportes"));
        list.add(v("ALMACEN_REP_TOMA_INV", "Reportes de tomas de inventario",
                "/sigre/almacen/reportes/reporte-tomas-inventario", AlmacenFuenteDatos.TOMAS_INVENTARIO, null, "Reportes"));

        // ── Procesos ──
        list.add(v("ALMACEN_PROC_RECALCULO", "Recálculo de precios promedio",
                "/sigre/almacen/procesos/recalcular", AlmacenFuenteDatos.PROCESO,
                "/procesos/recalculo-precios-promedio", "Procesos"));
        list.add(v("ALMACEN_PROC_CUADRE_STOCK", "Cuadres de stock",
                "/sigre/almacen/procesos/cuadre-stock", AlmacenFuenteDatos.PROCESO,
                "/procesos/cuadre-stock", "Procesos"));
        list.add(v("ALMACEN_PROC_ACT_AUTO", "Actualización automática",
                "/sigre/almacen/procesos/actualizacion", AlmacenFuenteDatos.PROCESO,
                "/procesos/actualizacion-automatica", "Procesos"));

        // ── Tablas ──
        list.add(v("ALMACEN_TAB_ALMACENES", "Maestro de almacenes",
                "/sigre/almacen/tablas/almacenes", AlmacenFuenteDatos.ALMACENES, null, "Tablas"));
        list.add(v("ALMACEN_TAB_TIPOS_MOV", "Tipos de movimientos",
                "/sigre/almacen/tablas/tipos-movimiento", AlmacenFuenteDatos.TIPOS_MOVIMIENTO, null, "Tablas"));
        list.add(v("ALMACEN_TAB_MOTIVOS", "Motivos de traslado",
                "/sigre/almacen/tablas/motivos-traslado", AlmacenFuenteDatos.MOTIVOS_TRASLADO, null, "Tablas"));
        list.add(v("ALMACEN_TAB_LOTES", "Ingreso de lotes",
                "/sigre/almacen/tablas/lotes", AlmacenFuenteDatos.LOTES, null, "Tablas"));

        TODAS = Collections.unmodifiableList(list);
        Map<String, AlmacenVista> byCod = new LinkedHashMap<>();
        Map<String, AlmacenVista> byRuta = new LinkedHashMap<>();
        for (AlmacenVista x : list) {
            byCod.put(x.codigo, x);
            if (x.ruta != null) {
                byRuta.put(normalizarRuta(x.ruta), x);
            }
        }
        POR_CODIGO = Collections.unmodifiableMap(byCod);
        POR_RUTA = Collections.unmodifiableMap(byRuta);
    }

    private AlmacenVistasCatalog() {}

    private static AlmacenVista v(String codigo, String nombre, String ruta,
                                  AlmacenFuenteDatos fuente, String procesoPath, String grupo) {
        return new AlmacenVista(codigo, nombre, ruta, fuente, procesoPath, grupo);
    }

    public static List<AlmacenVista> todas() {
        return TODAS;
    }

    public static List<AlmacenVista> porGrupo(String grupo) {
        List<AlmacenVista> out = new ArrayList<>();
        for (AlmacenVista v : TODAS) {
            if (grupo.equals(v.grupo)) out.add(v);
        }
        return out;
    }

    public static AlmacenVista porCodigo(String codigo) {
        if (codigo == null) return null;
        return POR_CODIGO.get(codigo.trim().toUpperCase(Locale.ROOT));
    }

    public static AlmacenVista porRutaOPath(String pathUrl) {
        if (pathUrl == null || pathUrl.isBlank()) return null;
        String n = normalizarRuta(pathUrl);
        AlmacenVista exacta = POR_RUTA.get(n);
        if (exacta != null) return exacta;
        // match por sufijo de path (seed a veces sin /sigre)
        for (Map.Entry<String, AlmacenVista> e : POR_RUTA.entrySet()) {
            if (n.endsWith(e.getKey()) || e.getKey().endsWith(n) || n.contains(stripSigre(e.getKey()))) {
                return e.getValue();
            }
        }
        // heurística por segmentos
        if (n.contains("movimiento-general") || n.contains("movimiento-transito")
                || (n.contains("movimiento") && n.contains("operaciones"))) {
            return POR_CODIGO.get("ALMACEN_OP_MOV_GENERAL");
        }
        if (n.contains("orden-traslado")) {
            return POR_CODIGO.get("ALMACEN_OP_OTR_GENERACION");
        }
        if (n.contains("inventario-conteo") || n.contains("inventario-monitor")) {
            return POR_CODIGO.get("ALMACEN_OP_INV_CONTEO");
        }
        if (n.contains("guias-remision") || n.contains("guia")) {
            return POR_CODIGO.get("ALMACEN_OP_GUIAS");
        }
        if (n.contains("/stock") || n.contains("consulta-especializada")) {
            return POR_CODIGO.get("ALMACEN_CONS_ESP_ARTICULOS");
        }
        if (n.contains("kardex") || n.contains("movimientos-x-articulo") || n.contains("historial-movimiento")) {
            return POR_CODIGO.get("ALMACEN_CONS_MOV_ARTICULO");
        }
        if (n.contains("valorizacion")) {
            return POR_CODIGO.get("ALMACEN_REP_VALORIZACION");
        }
        if (n.contains("diagnostico")) {
            return POR_CODIGO.get("ALMACEN_REP_DIAG");
        }
        if (n.contains("tablas/almacenes")) {
            return POR_CODIGO.get("ALMACEN_TAB_ALMACENES");
        }
        if (n.contains("tipos-movimiento")) {
            return POR_CODIGO.get("ALMACEN_TAB_TIPOS_MOV");
        }
        if (n.contains("motivos-traslado")) {
            return POR_CODIGO.get("ALMACEN_TAB_MOTIVOS");
        }
        if (n.contains("/lotes")) {
            return POR_CODIGO.get("ALMACEN_TAB_LOTES");
        }
        if (n.contains("recalcular") || n.contains("cuadre-stock") || n.contains("actualizacion")) {
            if (n.contains("cuadre")) return POR_CODIGO.get("ALMACEN_PROC_CUADRE_STOCK");
            if (n.contains("actualizacion")) return POR_CODIGO.get("ALMACEN_PROC_ACT_AUTO");
            return POR_CODIGO.get("ALMACEN_PROC_RECALCULO");
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
