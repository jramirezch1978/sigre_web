package pe.com.hermes.appmobile.data.almacen;

/**
 * Vista Almacén alineada a {@code almacen-vistas.config.ts}.
 * {@link #codigoVentana} es el análogo al “id de activity” del ERP (AL013, AL014, …).
 */
public final class AlmacenVista {

    /** Código funcional (ALMACEN_OP_MOV_GENERAL, …). */
    public final String codigo;
    /** Código de ventana ERP (AL013…). Usado para resolver menú → Activity. */
    public final String codigoVentana;
    public final String nombre;
    public final String ruta;
    public final AlmacenFuenteDatos fuente;
    public final String procesoPath;
    public final String grupo;

    public AlmacenVista(String codigo, String codigoVentana, String nombre, String ruta,
                        AlmacenFuenteDatos fuente, String procesoPath, String grupo) {
        this.codigo = codigo;
        this.codigoVentana = codigoVentana;
        this.nombre = nombre;
        this.ruta = ruta;
        this.fuente = fuente;
        this.procesoPath = procesoPath;
        this.grupo = grupo;
    }

    public boolean esProceso() {
        return fuente == AlmacenFuenteDatos.PROCESO;
    }

    public boolean tieneListado() {
        return fuente != AlmacenFuenteDatos.NONE && fuente != AlmacenFuenteDatos.PROCESO;
    }

    public boolean esNavegable() {
        return (tieneListado() || esProceso()) && ruta != null && !ruta.isBlank();
    }
}
