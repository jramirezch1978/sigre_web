package pe.com.hermes.appmobile.ui.common;

import java.util.ArrayList;
import java.util.List;
import pe.com.hermes.appmobile.util.FlagEstadoLabels;

/**
 * Builder / Facade de presentación de filas de listado.
 * <p>
 * Los repositorios solo declaran datos; el formato (separadores, labels, estado)
 * vive aquí. Para cambiar branding de subtítulos, editar las constantes de esta clase.
 * El look visual de la fila (sin gaps, barra cobre) está en
 * {@code item_simple_texto.xml} + {@link HermesListUi}.
 */
public final class ListItemBuilder {

    /** Separador título código · nombre. */
    private static final String SEP_TITULO = " · ";
    /**
     * Separador entre campos del subtítulo.
     * Multilínea = listado legible; cambiar a {@code " · "} para compacto.
     */
    private static final String SEP_CAMPO = "\n";
    private static final String VACIO = "—";

    private final long id;
    private String titulo = "";
    private final List<String> partesSubtitulo = new ArrayList<>();

    private ListItemBuilder(long id) {
        this.id = id;
    }

    public static ListItemBuilder of(long id) {
        return new ListItemBuilder(id);
    }

    public ListItemBuilder titulo(String titulo) {
        this.titulo = titulo != null ? titulo : "";
        return this;
    }

    public ListItemBuilder tituloCodigoNombre(String codigo, String nombre) {
        return titulo(unirTitulo(codigo, nombre));
    }

    /** Campo etiquetado: {@code Etiqueta: valor}. */
    public ListItemBuilder campo(String etiqueta, Object valor) {
        String v = valorTexto(valor);
        if (etiqueta == null || etiqueta.isBlank()) {
            partesSubtitulo.add(v);
        } else {
            partesSubtitulo.add(etiqueta.trim() + ": " + v);
        }
        return this;
    }

    /** Fragmento libre en el subtítulo (sin etiqueta). */
    public ListItemBuilder texto(String fragmento) {
        if (fragmento != null && !fragmento.isBlank()) {
            partesSubtitulo.add(fragmento.trim());
        }
        return this;
    }

    /** {@code flag_estado} → Estado: Activo|Inactivo (o código crudo si no es 0/1). */
    public ListItemBuilder estado(String flagEstado) {
        partesSubtitulo.add(FlagEstadoLabels.campoListado(flagEstado));
        return this;
    }

    public SimpleItem build() {
        String sub = String.join(SEP_CAMPO, partesSubtitulo);
        return new SimpleItem(id, titulo, sub.isEmpty() ? null : sub);
    }

    /** Uso en pantallas de detalle / texto plano. */
    public static String textoEstado(String flagEstado) {
        return FlagEstadoLabels.campoListado(flagEstado);
    }

    public static String unirTitulo(String codigo, String nombre) {
        String c = valorTexto(codigo);
        String n = valorTexto(nombre);
        if (VACIO.equals(c)) {
            return n;
        }
        if (VACIO.equals(n)) {
            return c;
        }
        return c + SEP_TITULO + n;
    }

    public static String valorTexto(Object valor) {
        if (valor == null) {
            return VACIO;
        }
        String s = String.valueOf(valor).trim();
        return s.isEmpty() ? VACIO : s;
    }

    public static String codigoNombre(String codigo, String nombre) {
        String c = codigo != null ? codigo.trim() : "";
        String n = nombre != null ? nombre.trim() : "";
        if (!c.isEmpty() && !n.isEmpty()) {
            return c + " — " + n;
        }
        if (!n.isEmpty()) {
            return n;
        }
        if (!c.isEmpty()) {
            return c;
        }
        return VACIO;
    }
}
