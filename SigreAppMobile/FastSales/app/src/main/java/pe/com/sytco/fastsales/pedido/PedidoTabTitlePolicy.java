package pe.com.sytco.fastsales.pedido;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Política de títulos de pestaña (Strategy/Policy).
 */
public final class PedidoTabTitlePolicy {

    private static final int MAX_LEN = 15;
    private static final Pattern PEDIDO_NUMBER =
            Pattern.compile("(?i)^\\s*Pedido\\s+(\\d+)\\s*$");

    private PedidoTabTitlePolicy() {
    }

    public static String emptyTitle(int number) {
        return "Pedido " + number;
    }

    /**
     * Extrae el número de un título "Pedido N" (case-insensitive). -1 si no aplica.
     */
    public static int parsePedidoNumber(String title) {
        if (title == null) {
            return -1;
        }
        Matcher matcher = PEDIDO_NUMBER.matcher(title.trim());
        if (!matcher.matches()) {
            return -1;
        }
        try {
            return Integer.parseInt(matcher.group(1));
        } catch (NumberFormatException ex) {
            return -1;
        }
    }

    public static boolean isSamePedidoTitle(String title, int number) {
        return parsePedidoNumber(title) == number;
    }

    public static boolean equalsIgnoreCaseTrim(String a, String b) {
        if (a == null || b == null) {
            return false;
        }
        return a.trim().equalsIgnoreCase(b.trim());
    }

    public static String resolve(PedidoTabState state) {
        if (state == null) {
            return "Pedido";
        }
        if (state.pedido != null && state.pedido.getCabecera() != null) {
            String client = abbreviate(state.pedido.getCabecera().getNomCliente());
            if (client != null) {
                return client;
            }
            String nro = state.pedido.getCabecera().getNroProforma();
            if (nro != null && !nro.trim().isEmpty()) {
                return abbreviate(nro.trim());
            }
        }
        return state.title != null ? state.title : "Pedido";
    }

    public static String abbreviate(String value) {
        if (value == null) {
            return null;
        }
        String trimmed = value.trim();
        if (trimmed.isEmpty()) {
            return null;
        }
        if (trimmed.length() <= MAX_LEN) {
            return trimmed;
        }
        return trimmed.substring(0, MAX_LEN) + "...";
    }
}
