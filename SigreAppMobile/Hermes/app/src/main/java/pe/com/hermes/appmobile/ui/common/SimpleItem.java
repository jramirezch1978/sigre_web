package pe.com.hermes.appmobile.ui.common;

/** Item generico (id + titulo + subtitulo) para listas simples de seleccion. */
public class SimpleItem {
    public final long id;
    public final String titulo;
    public final String subtitulo;

    public SimpleItem(long id, String titulo, String subtitulo) {
        this.id = id;
        this.titulo = titulo;
        this.subtitulo = subtitulo;
    }

    public SimpleItem(long id, String titulo) {
        this(id, titulo, null);
    }
}
