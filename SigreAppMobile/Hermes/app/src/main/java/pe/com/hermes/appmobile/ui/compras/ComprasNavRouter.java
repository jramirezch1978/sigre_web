package pe.com.hermes.appmobile.ui.compras;

import android.app.Activity;
import android.content.Context;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.compras.ComprasVista;
import pe.com.hermes.appmobile.data.compras.ComprasVistasCatalog;
import pe.com.hermes.appmobile.data.menu.MenuNodo;
import pe.com.hermes.appmobile.util.AppUtils;

/** Enruta menú Compras → Activity por código CM### / path. */
public final class ComprasNavRouter {

    private ComprasNavRouter() {}

    public static void abrirDesdeMenu(Context ctx, MenuNodo nodo) {
        if (nodo == null) return;
        if (!nodo.esHoja()) {
            ctx.startActivity(ComprasOpcionesActivity.intent(ctx, null));
            return;
        }
        ComprasVista vista = ComprasVistasCatalog.resolver(nodo.codigo, nodo.pathUrl, nodo.nombre);
        if (vista != null && vista.esNavegable()) {
            abrirVista(ctx, vista);
            return;
        }
        if (ctx instanceof Activity) {
            String ven = ComprasVistasCatalog.extraerCodigoVentana(nodo.codigo);
            if (ven == null) ven = ComprasVistasCatalog.extraerCodigoVentana(nodo.nombre);
            if (ven == null) ven = ComprasVistasCatalog.extraerCodigoVentana(nodo.pathUrl);
            AppUtils.toast((Activity) ctx, ctx.getString(
                    R.string.compras_sin_activity,
                    nodo.nombre,
                    nodo.codigo != null ? nodo.codigo : "—",
                    ven != null ? ven : "—"));
        }
    }

    public static void abrirVista(Context ctx, ComprasVista vista) {
        if (vista == null || !vista.esNavegable()) return;
        ctx.startActivity(ComprasListadoActivity.intent(ctx, vista.codigo));
    }

    public static boolean esOpcionCompras(MenuNodo nodo) {
        if (nodo == null) return false;
        String c = nodo.codigo != null ? nodo.codigo.toUpperCase() : "";
        String p = nodo.pathUrl != null ? nodo.pathUrl.toLowerCase() : "";
        return c.startsWith("COMPRAS")
                || ComprasVistasCatalog.extraerCodigoVentana(c) != null
                || ComprasVistasCatalog.extraerCodigoVentana(nodo.nombre) != null
                || p.contains("/compras");
    }
}
