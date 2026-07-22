package pe.com.sytco.fastsales.pedido;

import android.content.Context;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.Ventas.ImplPedido;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProforma;
import pe.com.sytco.fastsales.data.pedido.PedidoCacheRepository;
import pe.com.sytco.fastsales.data.pedido.PedidoCacheRepository.CachedTab;

/**
 * Coordinador del ciclo de vida de pestañas (máx. N) + caché SQLite.
 */
public final class PedidoTabManager {

    public static final int MAX_TABS = 10;

    private final List<PedidoTabState> tabs = new ArrayList<>();
    private final PedidoCacheRepository cacheRepository;
    /** Último número de "Pedido N" asignado en esta sesión (nunca reutiliza). */
    private int tabCounter;

    public PedidoTabManager(Context context) {
        this.cacheRepository = new PedidoCacheRepository(context);
    }

    public List<PedidoTabState> getTabs() {
        return Collections.unmodifiableList(tabs);
    }

    public int size() {
        return tabs.size();
    }

    public boolean canAddTab() {
        return tabs.size() < MAX_TABS;
    }

    public PedidoTabState getById(String tabId) {
        if (tabId == null) {
            return null;
        }
        for (PedidoTabState state : tabs) {
            if (tabId.equals(state.tabId)) {
                return state;
            }
        }
        return null;
    }

    /**
     * Si el Fragment restaura un tabId que no está en memoria/caché
     * (recreate / rotación), crea el estado en lugar de fallar.
     */
    public PedidoTabState ensureById(String tabId, String title) {
        PedidoTabState existing = getById(tabId);
        if (existing != null) {
            return existing;
        }
        if (tabId == null) {
            return null;
        }
        PedidoTabState recovered = PedidoTabFactory.recover(tabId, title);
        recovered.title = ensureUniqueTitle(recovered.title, recovered.tabId);
        tabs.add(recovered);
        return recovered;
    }

    public int indexOf(String tabId) {
        if (tabId == null) {
            return -1;
        }
        for (int i = 0; i < tabs.size(); i++) {
            if (tabId.equals(tabs.get(i).tabId)) {
                return i;
            }
        }
        return -1;
    }

    public void restoreFromCache() throws Exception {
        List<CachedTab> cachedTabs = cacheRepository.loadAllTabs(ImplEmpresa.empresaDefault.getCodigo());
        for (CachedTab cached : cachedTabs) {
            tabs.add(PedidoTabFactory.fromCache(cached));
        }
        // Regla: siguiente = max("Pedido N" recuperados) + 1. Si no hay ninguna → 1.
        tabCounter = maxPedidoNumberInTitles();
    }

    /**
     * Reconstruye pestañas tras recreate en el mismo orden de la sesión
     * (mezcla caché SQLite + pestañas vacías que aún no tenían ítems).
     */
    public void restoreSession(List<String> tabIds, List<String> titles) throws Exception {
        tabs.clear();
        Map<String, CachedTab> byId = new HashMap<>();
        List<CachedTab> cachedTabs = cacheRepository.loadAllTabs(ImplEmpresa.empresaDefault.getCodigo());
        for (CachedTab cached : cachedTabs) {
            if (cached != null && cached.tabId != null) {
                byId.put(cached.tabId, cached);
            }
        }
        if (tabIds != null) {
            for (int i = 0; i < tabIds.size(); i++) {
                String tabId = tabIds.get(i);
                if (tabId == null) {
                    continue;
                }
                String title = (titles != null && i < titles.size()) ? titles.get(i) : "Pedido";
                CachedTab cached = byId.remove(tabId);
                if (cached != null) {
                    tabs.add(PedidoTabFactory.fromCache(cached));
                } else {
                    PedidoTabState recovered = PedidoTabFactory.recover(tabId, title);
                    recovered.title = ensureUniqueTitle(recovered.title, recovered.tabId);
                    tabs.add(recovered);
                }
            }
        }
        // Por si quedó algo en caché que no venía en la sesión (no debería, pero no perder datos).
        for (CachedTab leftover : byId.values()) {
            tabs.add(PedidoTabFactory.fromCache(leftover));
        }
        tabCounter = maxPedidoNumberInTitles();
    }

    public PedidoTabState addEmpty() {
        int next = nextUniquePedidoNumber();
        tabCounter = next;
        PedidoTabState state = PedidoTabFactory.empty(next);
        if (state.pedido != null && state.pedido.getCabecera() == null) {
            state.pedido.newPedido();
        }
        tabs.add(state);
        // Las vacías también van a caché: si no, al rotar desaparecen del manager.
        persist(state, tabs.size() - 1);
        return state;
    }

    public PedidoTabState addProforma(BeanProforma proforma) {
        String clientTitle = PedidoTabTitlePolicy.abbreviate(
                proforma != null ? proforma.getNomCliente() : null);
        int fallbackNumber = 0;
        if (clientTitle == null) {
            fallbackNumber = nextUniquePedidoNumber();
            tabCounter = fallbackNumber;
        }
        PedidoTabState state = PedidoTabFactory.fromProforma(proforma, fallbackNumber);
        // Garantiza título único aunque el cliente coincida con otra pestaña.
        state.title = ensureUniqueTitle(state.title);
        tabs.add(state);
        return state;
    }

    public void ensureAtLeastOne() {
        if (tabs.isEmpty()) {
            addEmpty();
        }
    }

    public void removeAt(int index) {
        if (index < 0 || index >= tabs.size()) {
            return;
        }
        PedidoTabState state = tabs.remove(index);
        cacheRepository.deleteTab(state.tabId);
        if (tabs.isEmpty()) {
            // Todo vacío: la próxima pestaña vuelve a empezar en 1.
            tabCounter = 0;
        } else {
            tabCounter = maxPedidoNumberInTitles();
        }
    }

    public void deleteCache(String tabId) {
        cacheRepository.deleteTab(tabId);
    }

    public String refreshTitle(PedidoTabState state, ImplPedido pedido) {
        if (state == null) {
            return "Pedido";
        }
        if (pedido != null) {
            state.pedido = pedido;
        }
        state.title = ensureUniqueTitle(PedidoTabTitlePolicy.resolve(state), state.tabId);
        return state.title;
    }

    public void persist(PedidoTabState state, int order) {
        if (state == null || state.pedido == null) {
            return;
        }
        if (state.pedido.getCabecera() == null) {
            state.pedido.newPedido();
        }
        state.title = PedidoTabTitlePolicy.resolve(state);
        cacheRepository.saveTab(state.tabId, state.title, order, state.pedido);
    }

    /**
     * Regla de numeración:
     * - Sin pestañas (nada recuperado o todo vacío) → 1
     * - Con pestañas → max(números "Pedido N" actuales / sesión) + 1, sin duplicar
     */
    private int nextUniquePedidoNumber() {
        if (tabs.isEmpty()) {
            tabCounter = 0;
            return 1;
        }
        int next = Math.max(tabCounter, maxPedidoNumberInTitles()) + 1;
        if (next < 1) {
            next = 1;
        }
        while (hasPedidoNumber(next)) {
            next++;
        }
        return next;
    }

    private int maxPedidoNumberInTitles() {
        int max = 0;
        for (PedidoTabState state : tabs) {
            int n = PedidoTabTitlePolicy.parsePedidoNumber(state.title);
            if (n > max) {
                max = n;
            }
        }
        return max;
    }

    private boolean hasPedidoNumber(int number) {
        for (PedidoTabState state : tabs) {
            if (PedidoTabTitlePolicy.isSamePedidoTitle(state.title, number)) {
                return true;
            }
        }
        return false;
    }

    private String ensureUniqueTitle(String title) {
        return ensureUniqueTitle(title, null);
    }

    private String ensureUniqueTitle(String title, String excludeTabId) {
        if (title == null || title.trim().isEmpty()) {
            title = PedidoTabTitlePolicy.emptyTitle(nextUniquePedidoNumber());
        }
        if (!titleExists(title, excludeTabId)) {
            return title;
        }
        // Si choca un "Pedido N", avanza número; si es nombre de cliente, sufija (2), (3)...
        int pedidoNum = PedidoTabTitlePolicy.parsePedidoNumber(title);
        if (pedidoNum > 0) {
            int next = nextUniquePedidoNumber();
            tabCounter = next;
            return PedidoTabTitlePolicy.emptyTitle(next);
        }
        int suffix = 2;
        String candidate;
        do {
            candidate = title + " (" + suffix + ")";
            suffix++;
        } while (titleExists(candidate, excludeTabId));
        return candidate;
    }

    private boolean titleExists(String title, String excludeTabId) {
        for (PedidoTabState state : tabs) {
            if (excludeTabId != null && excludeTabId.equals(state.tabId)) {
                continue;
            }
            if (PedidoTabTitlePolicy.equalsIgnoreCaseTrim(state.title, title)) {
                return true;
            }
        }
        return false;
    }
}
