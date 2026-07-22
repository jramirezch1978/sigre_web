package pe.com.sytco.fastsales.pedido;

import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProforma;

/**
 * Estado de una pestaña de tomapedidos (Information Holder).
 */
public final class PedidoTabState {

    public final String tabId;
    public String title;
    public ImplPedido pedido;
    public BeanProforma proformaToLoad;
    public boolean proformaLoaded;
    public boolean fromCache;

    public PedidoTabState(String tabId, String title, ImplPedido pedido) {
        this.tabId = tabId;
        this.title = title;
        this.pedido = pedido;
    }

    public boolean hasItems() {
        return pedido != null
                && pedido.getDetalleNoDelete() != null
                && !pedido.getDetalleNoDelete().isEmpty();
    }
}
