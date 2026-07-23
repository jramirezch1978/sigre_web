package pe.com.hermes.common.validation;

import android.util.Patterns;

import java.util.regex.Pattern;

/**
 * Librería de reglas de validación reutilizables (correo, usuario, password, etc.).
 * No depende de Views: se puede usar en login, configuración, diálogos y formularios futuros.
 */
public final class InputValidators {

    private static final Pattern EMAIL = Patterns.EMAIL_ADDRESS;
    /** Usuario sin @ : letras, dígitos, punto, guion y guion bajo. */
    private static final Pattern USERNAME = Pattern.compile("^[A-Za-z0-9._\\-]{3,80}$");

    private InputValidators() {
    }

    public static InputRule notBlank() {
        return new InputRule() {
            @Override
            public boolean isValid(String value) {
                return value != null && !value.trim().isEmpty();
            }

            @Override
            public String errorMessage() {
                return "Campo obligatorio";
            }
        };
    }

    public static InputRule minLength(final int min) {
        return new InputRule() {
            @Override
            public boolean isValid(String value) {
                return value != null && value.trim().length() >= min;
            }

            @Override
            public String errorMessage() {
                return "Mínimo " + min + " caracteres";
            }
        };
    }

    public static InputRule positiveNumber() {
        return new InputRule() {
            @Override
            public boolean isValid(String value) {
                if (value == null || value.trim().isEmpty()) {
                    return false;
                }
                try {
                    return Double.parseDouble(value.trim().replace(',', '.')) > 0d;
                } catch (Exception ex) {
                    return false;
                }
            }

            @Override
            public String errorMessage() {
                return "Ingrese un número mayor a 0";
            }
        };
    }

    /** Correo electrónico estricto (RFC práctico vía {@link Patterns#EMAIL_ADDRESS}). */
    public static InputRule email() {
        return new InputRule() {
            @Override
            public boolean isValid(String value) {
                if (value == null) {
                    return false;
                }
                String v = value.trim();
                return !v.isEmpty() && EMAIL.matcher(v).matches();
            }

            @Override
            public String errorMessage() {
                return "Correo electrónico inválido";
            }
        };
    }

    /**
     * Login: acepta usuario o correo.
     * - Si contiene {@code @} → debe ser un email válido (ej. {@code jramirez@} falla).
     * - Si no → usuario de al menos 3 caracteres válidos.
     */
    public static InputRule usuarioOCorreo() {
        return new InputRule() {
            @Override
            public boolean isValid(String value) {
                if (value == null) {
                    return false;
                }
                String v = value.trim();
                if (v.isEmpty()) {
                    return false;
                }
                if (v.indexOf('@') >= 0) {
                    return EMAIL.matcher(v).matches();
                }
                return USERNAME.matcher(v).matches();
            }

            @Override
            public String errorMessage() {
                return "Usuario o correo inválido";
            }
        };
    }

    public static InputRule passwordMin(final int min) {
        return new InputRule() {
            @Override
            public boolean isValid(String value) {
                return value != null && value.length() >= min;
            }

            @Override
            public String errorMessage() {
                return "Contraseña demasiado corta";
            }
        };
    }
}
