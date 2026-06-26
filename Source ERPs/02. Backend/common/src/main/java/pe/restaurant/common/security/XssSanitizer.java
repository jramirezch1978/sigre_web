package pe.restaurant.common.security;

import java.util.regex.Pattern;

/**
 * Utilidad de sanitización contra XSS y SQL Injection (OWASP).
 * Elimina etiquetas HTML/script, caracteres de control y patrones peligrosos.
 */
public final class XssSanitizer {

    private static final Pattern SCRIPT_TAG = Pattern.compile(
            "<\\s*script[^>]*>.*?</\\s*script\\s*>", Pattern.CASE_INSENSITIVE | Pattern.DOTALL);

    private static final Pattern HTML_TAG = Pattern.compile("<[^>]+>", Pattern.CASE_INSENSITIVE);

    private static final Pattern EVENT_HANDLER = Pattern.compile(
            "\\bon\\w+\\s*=", Pattern.CASE_INSENSITIVE);

    private static final Pattern JAVASCRIPT_URI = Pattern.compile(
            "javascript\\s*:", Pattern.CASE_INSENSITIVE);

    private static final Pattern DATA_URI = Pattern.compile(
            "data\\s*:", Pattern.CASE_INSENSITIVE);

    private static final Pattern EVAL_EXPRESSION = Pattern.compile(
            "(eval|expression)\\s*\\(", Pattern.CASE_INSENSITIVE);

    private static final Pattern SQL_INJECTION = Pattern.compile(
            "(--|;|'\\s*(OR|AND|UNION|SELECT|INSERT|UPDATE|DELETE|DROP|ALTER|EXEC|EXECUTE)\\s)",
            Pattern.CASE_INSENSITIVE);

    private static final Pattern CONTROL_CHARS = Pattern.compile("[\\x00-\\x08\\x0B\\x0C\\x0E-\\x1F\\x7F]");

    private XssSanitizer() {
    }

    public static String sanitize(String input) {
        if (input == null || input.isEmpty()) return input;

        String clean = input;
        clean = SCRIPT_TAG.matcher(clean).replaceAll("");
        clean = EVENT_HANDLER.matcher(clean).replaceAll("");
        clean = JAVASCRIPT_URI.matcher(clean).replaceAll("");
        clean = DATA_URI.matcher(clean).replaceAll("");
        clean = EVAL_EXPRESSION.matcher(clean).replaceAll("");
        clean = HTML_TAG.matcher(clean).replaceAll("");
        clean = CONTROL_CHARS.matcher(clean).replaceAll("");

        clean = clean.replace("&", "&amp;")
                      .replace("<", "&lt;")
                      .replace(">", "&gt;")
                      .replace("\"", "&quot;")
                      .replace("'", "&#x27;");

        return clean.trim();
    }

    public static boolean containsSqlInjection(String input) {
        if (input == null || input.isEmpty()) return false;
        return SQL_INJECTION.matcher(input).find();
    }

    public static boolean containsXss(String input) {
        if (input == null || input.isEmpty()) return false;
        return SCRIPT_TAG.matcher(input).find()
                || EVENT_HANDLER.matcher(input).find()
                || JAVASCRIPT_URI.matcher(input).find();
    }
}
