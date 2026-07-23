package pe.com.hermes.appmobile.data.compras;

/** Vista Compras alineada a rutas web (CM###). */
public final class ComprasVista {

    public final String codigo;
    public final String codigoVentana;
    public final String nombre;
    public final String ruta;
    public final ComprasFuenteDatos fuente;
    public final String grupo;

    public ComprasVista(String codigo, String codigoVentana, String nombre, String ruta,
                        ComprasFuenteDatos fuente, String grupo) {
        this.codigo = codigo;
        this.codigoVentana = codigoVentana;
        this.nombre = nombre;
        this.ruta = ruta;
        this.fuente = fuente;
        this.grupo = grupo;
    }

    public boolean esNavegable() {
        return fuente != ComprasFuenteDatos.NONE && ruta != null && !ruta.isBlank();
    }

    public boolean esDocumento() {
        return fuente == ComprasFuenteDatos.SOLICITUDES;
    }
}
