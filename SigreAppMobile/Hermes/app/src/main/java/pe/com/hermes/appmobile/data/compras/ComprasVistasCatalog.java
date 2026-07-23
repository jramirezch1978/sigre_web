package pe.com.hermes.appmobile.data.compras;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/** Catálogo Compras Hermes = pantallas web implementadas (CM001–CM014). */
public final class ComprasVistasCatalog {

    private static final Pattern VENTANA = Pattern.compile("(?i)(?<![A-Z0-9])CM\\d{3}(?![0-9])");

    private static final List<ComprasVista> TODAS;
    private static final Map<String, ComprasVista> POR_CODIGO;
    private static final Map<String, ComprasVista> POR_VENTANA;
    private static final Map<String, ComprasVista> POR_RUTA;

    static {
        List<ComprasVista> list = new ArrayList<>();
        list.add(v("CM001", "COMPRAS_TABLAS_TIPOS_DE_PROVEEDORES", "Tipos de Proveedores",
                "/sigre/compras/tablas/tipos-proveedor", ComprasFuenteDatos.TIPOS_PROVEEDOR, "Tablas"));
        list.add(v("CM002", "COMPRAS_TABLAS_FICHA_DE_PROVEEDORES_CLI", "Ficha de Proveedores / Clientes",
                "/sigre/compras/tablas/proveedores", ComprasFuenteDatos.PROVEEDORES, "Tablas"));
        list.add(v("CM003", "COMPRAS_OPERACIONES_SOLICITUD_DE_COMPRA", "Solicitud de Compras",
                "/sigre/compras/operaciones/solicitud-de-compra", ComprasFuenteDatos.SOLICITUDES, "Operaciones"));
        list.add(v("CM005", "COMPRAS_TABLAS_MAESTRO_DE_ARTICULOS", "Maestro de Artículos",
                "/sigre/compras/tablas/articulos", ComprasFuenteDatos.ARTICULOS, "Tablas"));
        list.add(v("CM010", "COMPRAS_TABLAS_MAESTRO_DE_MARCAS_DE_ART", "Marcas de artículo",
                "/sigre/compras/tablas/marcas", ComprasFuenteDatos.MARCAS, "Tablas"));
        list.add(v("CM011", "COMPRAS_TABLAS_MAESTRO_DE_COLORES", "Colores",
                "/sigre/compras/tablas/colores", ComprasFuenteDatos.COLORES, "Tablas"));
        list.add(v("CM012", "COMPRAS_TABLAS_CLASES", "Clases de artículo",
                "/sigre/compras/tablas/clases-articulo", ComprasFuenteDatos.CLASES_ARTICULO, "Tablas"));
        list.add(v("CM013", "COMPRAS_TABLAS_CM009_CATEGORIAS_SUB_CAT", "Categorías",
                "/sigre/compras/tablas/categorias", ComprasFuenteDatos.CATEGORIAS, "Tablas"));
        list.add(v("CM014", "COMPRAS_TABLAS_SUB_CATEGORIAS", "Subcategorías",
                "/sigre/compras/tablas/sub-categorias", ComprasFuenteDatos.SUB_CATEGORIAS, "Tablas"));

        TODAS = Collections.unmodifiableList(list);
        Map<String, ComprasVista> byCod = new LinkedHashMap<>();
        Map<String, ComprasVista> byVen = new LinkedHashMap<>();
        Map<String, ComprasVista> byRuta = new LinkedHashMap<>();
        for (ComprasVista x : list) {
            byCod.put(x.codigo.toUpperCase(Locale.ROOT), x);
            byVen.put(x.codigoVentana.toUpperCase(Locale.ROOT), x);
            byRuta.put(normalizar(x.ruta), x);
        }
        POR_CODIGO = Collections.unmodifiableMap(byCod);
        POR_VENTANA = Collections.unmodifiableMap(byVen);
        POR_RUTA = Collections.unmodifiableMap(byRuta);
    }

    private ComprasVistasCatalog() {}

    private static ComprasVista v(String ven, String cod, String nom, String ruta,
                                 ComprasFuenteDatos f, String g) {
        return new ComprasVista(cod, ven, nom, ruta, f, g);
    }

    public static List<ComprasVista> navegables() {
        List<ComprasVista> out = new ArrayList<>();
        for (ComprasVista v : TODAS) if (v.esNavegable()) out.add(v);
        return out;
    }

    public static List<ComprasVista> porGrupo(String grupo) {
        List<ComprasVista> out = new ArrayList<>();
        for (ComprasVista v : navegables()) if (grupo.equals(v.grupo)) out.add(v);
        return out;
    }

    public static ComprasVista porCodigo(String codigo) {
        if (codigo == null || codigo.isBlank()) return null;
        return POR_CODIGO.get(codigo.trim().toUpperCase(Locale.ROOT));
    }

    public static ComprasVista porCodigoVentana(String v) {
        if (v == null || v.isBlank()) return null;
        return POR_VENTANA.get(v.trim().toUpperCase(Locale.ROOT));
    }

    public static ComprasVista resolver(String codigoMenu, String pathUrl, String nombre) {
        ComprasVista v = porCodigo(codigoMenu);
        if (v != null) return v;
        String ven = extraerCodigoVentana(codigoMenu);
        if (ven == null) ven = extraerCodigoVentana(nombre);
        if (ven == null) ven = extraerCodigoVentana(pathUrl);
        v = porCodigoVentana(ven);
        if (v != null) return v;
        if (codigoMenu != null) {
            String up = codigoMenu.toUpperCase(Locale.ROOT);
            for (ComprasVista cand : TODAS) {
                if (up.contains(cand.codigoVentana) || up.contains(cand.codigo)) return cand;
            }
        }
        return porRuta(pathUrl);
    }

    public static String extraerCodigoVentana(String texto) {
        if (texto == null || texto.isBlank()) return null;
        Matcher m = VENTANA.matcher(texto);
        return m.find() ? m.group().toUpperCase(Locale.ROOT) : null;
    }

    public static ComprasVista porRuta(String pathUrl) {
        if (pathUrl == null || pathUrl.isBlank()) return null;
        String n = normalizar(pathUrl);
        ComprasVista exacta = POR_RUTA.get(n);
        if (exacta != null) return exacta;
        for (Map.Entry<String, ComprasVista> e : POR_RUTA.entrySet()) {
            if (n.contains(strip(e.getKey())) || e.getKey().endsWith(n) || n.endsWith(e.getKey())) {
                return e.getValue();
            }
        }
        return null;
    }

    public static String normalizar(String path) {
        String p = path.trim().toLowerCase(Locale.ROOT).replace('\\', '/');
        if (!p.startsWith("/")) p = "/" + p;
        if (p.startsWith("/sigre/")) return p;
        if (p.startsWith("/compras/")) return "/sigre" + p;
        return p;
    }

    private static String strip(String ruta) {
        return ruta.startsWith("/sigre") ? ruta.substring("/sigre".length()) : ruta;
    }
}
