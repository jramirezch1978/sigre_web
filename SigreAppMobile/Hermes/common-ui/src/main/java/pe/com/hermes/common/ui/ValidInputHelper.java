package pe.com.hermes.common.ui;

import android.content.res.ColorStateList;
import android.text.Editable;
import android.text.TextWatcher;
import android.widget.EditText;
import com.google.android.material.textfield.TextInputLayout;
import pe.com.hermes.common.R;

/**
 * Validacion visual en tiempo real de un TextInputLayout — equivalente moderno
 * de ValidInputHelper.java de FastSales.
 */
public final class ValidInputHelper {

    private static final int COLOR_OK = 0xFF00BFA5;

    public interface Regla {
        boolean esValido(String valor);
    }

    private ValidInputHelper() {
    }

    public static Regla notBlank() {
        return valor -> !valor.trim().isEmpty();
    }

    public static Regla minLength(int min) {
        return valor -> valor.trim().length() >= min;
    }

    public static Regla numeroPositivo() {
        return valor -> {
            try {
                return Double.parseDouble(valor) > 0;
            } catch (NumberFormatException e) {
                return false;
            }
        };
    }

    /** Engancha la validacion al campo; se re-evalua en cada cambio de texto. */
    public static void bind(TextInputLayout campo, Regla regla, String mensajeError) {
        EditText editText = campo.getEditText();
        if (editText == null) return;
        editText.addTextChangedListener(new TextWatcher() {
            @Override public void beforeTextChanged(CharSequence s, int start, int count, int after) {}
            @Override public void onTextChanged(CharSequence s, int start, int before, int count) {}
            @Override public void afterTextChanged(Editable s) {
                actualizar(campo, editText, regla, mensajeError);
            }
        });
        actualizar(campo, editText, regla, mensajeError);
    }

    public static void bind(TextInputLayout campo, Regla regla) {
        bind(campo, regla, "Valor inválido");
    }

    private static void actualizar(TextInputLayout campo, EditText editText, Regla regla, String mensajeError) {
        String valor = editText.getText() != null ? editText.getText().toString() : "";
        if (valor.isEmpty()) {
            campo.setError(null);
            campo.setEndIconMode(TextInputLayout.END_ICON_NONE);
            return;
        }
        if (regla.esValido(valor)) {
            campo.setError(null);
            campo.setEndIconMode(TextInputLayout.END_ICON_CUSTOM);
            campo.setEndIconDrawable(R.drawable.ic_input_check_ok);
            campo.setEndIconTintList(ColorStateList.valueOf(COLOR_OK));
            campo.setEndIconVisible(true);
        } else {
            campo.setEndIconMode(TextInputLayout.END_ICON_NONE);
            campo.setError(mensajeError);
        }
    }
}
