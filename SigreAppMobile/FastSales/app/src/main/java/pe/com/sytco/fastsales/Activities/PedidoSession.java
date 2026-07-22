package pe.com.sytco.fastsales.Activities;

import android.app.Activity;
import android.view.View;

import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.UI.PedidoUI;
import pe.com.sytco.fastsales.beans.BeanUsuario;

/**
 * Contrato de una pestaña de tomapedidos (host o fragment).
 */
public interface PedidoSession {
    Activity getHostActivity();
    View getContentRoot();
    ImplPedido getImplPedido();
    BeanUsuario getUserLogin();
    PedidoUI getPedidoUI();
    String getTabId();
    /** Persistir estado actual en SQLite (caché temporal). */
    void persistCache();
    /** Notificar al host que el pedido cambió (título de pestaña, etc.). */
    void notifyPedidoChanged();
    /** Confirmar y grabar pedido (tras diálogo de cliente, etc.). */
    void SavePedido();
}
