package pe.com.hermes.appmobile.data.almacen;

/**
 * Vista Almacén alineada a {@code almacen-vistas.config.ts} del ERP web.
 * Si {@link #fuente} es {@link AlmacenFuenteDatos#NONE}, la opción aún no tiene API/UI móvil.
 */
public final class AlmacenVista {

    public final String codigo;
    public final String nombre;
    /** Ruta FE relativa, ej. {@code /sigre/almacen/operaciones/movimiento-general}. */
    public final String ruta;
    public final AlmacenFuenteDatos fuente;
    /** Solo procesos: path relativo POST bajo /api/almacen. */
    public final String procesoPath;
    public final String grupo;

    public AlmacenVista(String codigo, String nombre, String ruta, AlmacenFuenteDatos fuente,
                        String procesoPath, String grupo) {
        this.codigo = codigo;
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
}
