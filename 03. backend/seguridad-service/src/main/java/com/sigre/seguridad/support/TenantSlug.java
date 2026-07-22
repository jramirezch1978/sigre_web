package com.sigre.seguridad.support;

import com.sigre.common.exception.BusinessException;
import org.springframework.http.HttpStatus;

import java.text.Normalizer;
import java.util.Locale;

/**
 * Normaliza un nombre de empresa (sigla explicita en el alta admin, o nombre comercial/razon
 * social en el registro demo publico) al slug usado para nombrar la BD tenant: sigre_emp_&lt;slug&gt;.
 * Misma logica para ambos flujos de alta — antes el registro demo usaba un prefijo y
 * correlativo separados (sigre_demo_&lt;n&gt;) en vez de la sigla, lo que rompia la convencion.
 */
public final class TenantSlug {

    private TenantSlug() {
    }

    public static String sanitize(String raw) {
        String s = Normalizer.normalize(raw.trim(), Normalizer.Form.NFD).replaceAll("\\p{M}", "");
        s = s.toLowerCase(Locale.ROOT).replaceAll("[^a-z0-9]+", "_");
        s = s.replaceAll("_+", "_").replaceAll("^_+|_+$", "");
        if (s.isEmpty()) {
            throw new BusinessException("El nombre de la empresa no produce un identificador de BD válido tras normalizar",
                    HttpStatus.BAD_REQUEST, "TENANT_SLUG_VACIO");
        }
        if (s.length() > 44) {
            s = s.substring(0, 44).replaceAll("_+$", "");
        }
        return s;
    }
}
