package pe.com.sytco.fastsales.pedido;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProforma;
import pe.com.sytco.fastsales.data.pedido.PedidoCacheRepository;
import pe.com.sytco.fastsales.data.pedido.PedidoCacheRepository.CachedTab;

/**
 * Factory de estados de pestaña (vacía, caché, proforma).
 */
public final class PedidoTabFactory {

    private PedidoTabFactory() {
    }

    public static PedidoTabState empty(int sequentialNumber) {
        return empty(PedidoCacheRepository.newTabId(), sequentialNumber);
    }

    /** Recupera una pestaña con tabId conocido (p. ej. tras recreate / FragmentManager). */
    public static PedidoTabState empty(String tabId, int sequentialNumber) {
        PedidoTabState state = new PedidoTabState(
                tabId != null ? tabId : PedidoCacheRepository.newTabId(),
                PedidoTabTitlePolicy.emptyTitle(sequentialNumber),
                new ImplPedido(ImplEmpresa.empresaDefault.getCodigo()));
        state.proformaLoaded = false;
        state.fromCache = false;
        return state;
    }

    public static PedidoTabState recover(String tabId, String title) {
        PedidoTabState state = new PedidoTabState(
                tabId != null ? tabId : PedidoCacheRepository.newTabId(),
                title != null && !title.trim().isEmpty() ? title : "Pedido",
                new ImplPedido(ImplEmpresa.empresaDefault.getCodigo()));
        state.proformaLoaded = false;
        state.fromCache = false;
        return state;
    }

    public static PedidoTabState fromCache(CachedTab cached) {
        PedidoTabState state = new PedidoTabState(
                cached.tabId,
                cached.tabTitle != null ? cached.tabTitle : "Pedido",
                cached.pedido);
        state.proformaLoaded = true;
        state.fromCache = true;
        return state;
    }

    public static PedidoTabState fromProforma(BeanProforma proforma, int fallbackNumber) {
        String title = PedidoTabTitlePolicy.abbreviate(
                proforma != null ? proforma.getNomCliente() : null);
        if (title == null) {
            title = PedidoTabTitlePolicy.emptyTitle(fallbackNumber);
        }
        PedidoTabState state = new PedidoTabState(
                PedidoCacheRepository.newTabId(),
                title,
                new ImplPedido(ImplEmpresa.empresaDefault.getCodigo()));
        state.proformaToLoad = proforma;
        state.proformaLoaded = false;
        state.fromCache = false;
        return state;
    }
}
