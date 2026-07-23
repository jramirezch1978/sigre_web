package pe.com.hermes.appmobile.ui.almacen;

import android.content.Context;
import android.content.Intent;
import pe.com.hermes.appmobile.data.almacen.AlmacenFuenteDatos;
import pe.com.hermes.appmobile.data.almacen.AlmacenVista;
import pe.com.hermes.appmobile.data.almacen.AlmacenVistasCatalog;
import pe.com.hermes.appmobile.data.menu.MenuNodo;

/** Enruta opciones del menú Almacén a Activities Hermes. */
public final class AlmacenNavRouter {

    private AlmacenNavRouter() {}

    public static void abrirDesdeMenu(Context ctx, MenuNodo nodo) {
        if (nodo == null) return;
        AlmacenVista vista = AlmacenVistasCatalog.porCodigo(nodo.codigo);
        if (vista == null) {
            vista = AlmacenVistasCatalog.porRutaOPath(nodo.pathUrl);
        }
        if (vista == null) {
            // Módulo raíz / sección sin hoja concreta → hub
            String path = nodo.pathUrl != null ? nodo.pathUrl : "";
            String cod = nodo.codigo != null ? nodo.codigo : "";
            if (cod.equalsIgnoreCase("ALMACEN") || path.matches("(?i).*/almacen/?$") || !nodo.esHoja()) {
                ctx.startActivity(AlmacenOpcionesActivity.intent(ctx, null));
                return;
            }
            ctx.startActivity(AlmacenEnConstruccionActivity.intent(ctx, nodo.nombre, nodo.codigo, nodo.pathUrl));
            return;
        }
        abrirVista(ctx, vista);
    }

    public static void abrirVista(Context ctx, AlmacenVista vista) {
        if (vista == null) return;
        if (vista.esProceso()) {
            ctx.startActivity(AlmacenProcesoActivity.intent(ctx, vista.codigo));
            return;
        }
        if (vista.tieneListado()) {
            ctx.startActivity(AlmacenListadoActivity.intent(ctx, vista.codigo));
            return;
        }
        ctx.startActivity(AlmacenEnConstruccionActivity.intent(ctx, vista.nombre, vista.codigo, vista.ruta));
    }

    public static boolean esOpcionAlmacen(MenuNodo nodo) {
        if (nodo == null) return false;
        String c = nodo.codigo != null ? nodo.codigo.toUpperCase() : "";
        String p = nodo.pathUrl != null ? nodo.pathUrl.toLowerCase() : "";
        return c.startsWith("ALMACEN") || p.contains("/almacen");
    }
}
