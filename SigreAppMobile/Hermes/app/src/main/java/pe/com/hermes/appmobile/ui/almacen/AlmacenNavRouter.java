package pe.com.hermes.appmobile.ui.almacen;

import android.app.Activity;
import android.content.Context;
import pe.com.hermes.appmobile.data.almacen.AlmacenVista;
import pe.com.hermes.appmobile.data.almacen.AlmacenVistasCatalog;
import pe.com.hermes.appmobile.data.menu.MenuNodo;
import pe.com.hermes.appmobile.util.AppUtils;

/**
 * Enruta menú Almacén → Activity.
 * Resolución: código funcional → código ventana AL### (en codigo/nombre/path) → path.
 */
public final class AlmacenNavRouter {

    private AlmacenNavRouter() {}

    public static void abrirDesdeMenu(Context ctx, MenuNodo nodo) {
        if (nodo == null) return;

        // Contenedor (módulo/sección con hijos) → hub filtrado
        if (!nodo.esHoja()) {
            ctx.startActivity(AlmacenOpcionesActivity.intent(ctx, null));
            return;
        }

        AlmacenVista vista = AlmacenVistasCatalog.resolver(nodo.codigo, nodo.pathUrl, nodo.nombre);
        if (vista != null && vista.esNavegable()) {
            abrirVista(ctx, vista);
            return;
        }

        // Tiene path en menú pero aún no hay Activity Hermes registrada para ese AL###/path
        if (ctx instanceof Activity) {
            String ventana = AlmacenVistasCatalog.extraerCodigoVentana(nodo.codigo);
            if (ventana == null) {
                ventana = AlmacenVistasCatalog.extraerCodigoVentana(nodo.nombre);
            }
            if (ventana == null) {
                ventana = AlmacenVistasCatalog.extraerCodigoVentana(nodo.pathUrl);
            }
            AppUtils.toast((Activity) ctx, ctx.getString(
                    pe.com.hermes.appmobile.R.string.almacen_sin_activity,
                    nodo.nombre,
                    nodo.codigo != null ? nodo.codigo : "—",
                    ventana != null ? ventana : "—"));
        }
    }

    public static void abrirVista(Context ctx, AlmacenVista vista) {
        if (vista == null || !vista.esNavegable()) return;
        if (vista.esProceso()) {
            ctx.startActivity(AlmacenProcesoActivity.intent(ctx, vista.codigo));
            return;
        }
        ctx.startActivity(AlmacenListadoActivity.intent(ctx, vista.codigo));
    }

    public static boolean esOpcionAlmacen(MenuNodo nodo) {
        if (nodo == null) return false;
        String c = nodo.codigo != null ? nodo.codigo.toUpperCase() : "";
        String p = nodo.pathUrl != null ? nodo.pathUrl.toLowerCase() : "";
        return c.startsWith("ALMACEN")
                || AlmacenVistasCatalog.extraerCodigoVentana(c) != null
                || AlmacenVistasCatalog.extraerCodigoVentana(nodo.nombre) != null
                || p.contains("/almacen");
    }
}
