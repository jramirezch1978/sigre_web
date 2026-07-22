package com.sigre.common.util;

import java.util.Arrays;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/** Parsea listas de correos separadas por coma o punto y coma. */
public final class EmailListParser {

    private EmailListParser() {}

    public static List<String> parse(String raw) {
        if (raw == null || raw.isBlank()) {
            return List.of();
        }
        Set<String> out = new LinkedHashSet<>();
        for (String part : raw.split("[,;]")) {
            String email = part == null ? "" : part.trim();
            if (!email.isEmpty()) {
                out.add(email);
            }
        }
        return List.copyOf(out);
    }

    public static List<String> parseOrDefault(String raw, String defaultRaw) {
        List<String> parsed = parse(raw);
        return parsed.isEmpty() ? parse(defaultRaw) : parsed;
    }

    public static String join(List<String> emails) {
        if (emails == null || emails.isEmpty()) {
            return "";
        }
        return String.join(",", emails);
    }
}
