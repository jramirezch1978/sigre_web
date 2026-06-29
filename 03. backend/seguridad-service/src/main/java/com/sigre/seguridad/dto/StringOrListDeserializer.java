package com.sigre.seguridad.dto;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonDeserializer;
import com.fasterxml.jackson.databind.JsonNode;

/**
 * Deserializa un campo JSON que puede venir como string único o como arreglo de strings,
 * normalizándolo siempre a List&lt;String&gt; (sin vacíos ni espacios).
 * Ej.: "sigre_emp_x" → ["sigre_emp_x"]; ["a","b"] → ["a","b"].
 */
public class StringOrListDeserializer extends JsonDeserializer<List<String>> {

    @Override
    public List<String> deserialize(JsonParser p, DeserializationContext ctxt) throws IOException {
        JsonNode node = p.readValueAsTree();
        List<String> out = new ArrayList<>();
        if (node == null || node.isNull()) {
            return out;
        }
        if (node.isArray()) {
            for (JsonNode n : node) {
                addIfPresent(out, n);
            }
        } else {
            addIfPresent(out, node);
        }
        return out;
    }

    private void addIfPresent(List<String> out, JsonNode n) {
        if (n != null && !n.isNull()) {
            String s = n.asText().trim();
            if (!s.isEmpty()) {
                out.add(s);
            }
        }
    }
}
