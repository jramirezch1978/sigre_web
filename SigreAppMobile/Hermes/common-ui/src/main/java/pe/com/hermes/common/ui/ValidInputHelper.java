package pe.com.hermes.common.ui;

import android.content.res.ColorStateList;
import android.graphics.Color;
import android.graphics.drawable.Drawable;
import android.text.Editable;
import android.text.InputType;
import android.text.TextWatcher;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;

import androidx.core.content.ContextCompat;
import androidx.core.graphics.drawable.DrawableCompat;

import com.google.android.material.textfield.TextInputLayout;

import pe.com.hermes.common.R;
import pe.com.hermes.common.validation.InputRule;
import pe.com.hermes.common.validation.InputValidators;

/**
 * Binding visual de validación: check verde si OK, X roja si inválido, nada si vacío.
 * Las reglas reutilizables están en {@link InputValidators}.
 */
public final class ValidInputHelper {

    public static final int CHECK_COLOR = Color.parseColor("#00BFA5");
    public static final int ERROR_COLOR = Color.parseColor("#F44336");

    /** Compat: preferir {@link InputRule}. */
    public interface Rule extends InputRule {
    }

    /** Alias en español. */
    public interface Regla extends InputRule {
        @Override
        default boolean isValid(String value) {
            return esValido(value);
        }

        boolean esValido(String valor);
    }

    private ValidInputHelper() {
    }

    public static InputRule notBlank() {
        return InputValidators.notBlank();
    }

    public static InputRule minLength(int min) {
        return InputValidators.minLength(min);
    }

    public static InputRule positiveNumber() {
        return InputValidators.positiveNumber();
    }

    public static InputRule email() {
        return InputValidators.email();
    }

    public static InputRule usuarioOCorreo() {
        return InputValidators.usuarioOCorreo();
    }

    public static Regla numeroPositivo() {
        return value -> InputValidators.positiveNumber().isValid(value);
    }

    /** Atajo: campo de correo estricto. */
    public static void bindEmail(TextInputLayout til) {
        bindTextInputLayout(til, InputValidators.email(), true);
    }

    /** Atajo: login (usuario o correo). */
    public static void bindUsuarioOCorreo(TextInputLayout til) {
        bindTextInputLayout(til, InputValidators.usuarioOCorreo(), true);
    }

    /** Atajo: contraseña (respeta password toggle). */
    public static void bindPassword(TextInputLayout til, int minLen) {
        if (til == null) {
            return;
        }
        EditText edit = til.getEditText();
        if (edit != null) {
            bindEditText(edit, InputValidators.passwordMin(minLen), true);
        }
    }

    public static void bindTree(View root) {
        if (root == null) {
            return;
        }
        if (root instanceof TextInputLayout) {
            TextInputLayout til = (TextInputLayout) root;
            EditText nested = til.getEditText();
            bindTextInputLayout(til, nested != null ? inferRule(nested) : notBlank(), true);
            return;
        }
        if (root instanceof EditText) {
            EditText editText = (EditText) root;
            if (!isPasswordField(editText)) {
                bindEditText(editText, inferRule(editText), true);
            }
            return;
        }
        if (root instanceof ViewGroup) {
            ViewGroup group = (ViewGroup) root;
            for (int i = 0; i < group.getChildCount(); i++) {
                bindTree(group.getChildAt(i));
            }
        }
    }

    public static void bind(TextInputLayout campo, Regla regla, String mensajeError) {
        bindTextInputLayout(campo, regla != null ? regla : notBlank(), true);
    }

    public static void bind(TextInputLayout campo, Regla regla) {
        bind(campo, regla, "Valor inválido");
    }

    public static void bindEditText(EditText editText, InputRule rule) {
        bindEditText(editText, rule, true);
    }

    public static void bindEditText(final EditText editText, final InputRule rule, final boolean showErrorIcon) {
        if (editText == null || rule == null) {
            return;
        }
        ensureEndPadding(editText);
        refreshEditText(editText, rule, showErrorIcon);
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                refreshEditText(editText, rule, showErrorIcon);
            }
        });
    }

    public static void bindTextInputLayout(TextInputLayout til, InputRule rule) {
        bindTextInputLayout(til, rule, true);
    }

    public static void bindTextInputLayout(final TextInputLayout til, final InputRule rule, final boolean showErrorIcon) {
        if (til == null || rule == null) {
            return;
        }
        if (til.getEndIconMode() == TextInputLayout.END_ICON_PASSWORD_TOGGLE) {
            EditText edit = til.getEditText();
            if (edit != null) {
                bindEditText(edit, rule, showErrorIcon);
            }
            return;
        }
        til.setEndIconMode(TextInputLayout.END_ICON_CUSTOM);
        til.setEndIconCheckable(false);
        til.setEndIconVisible(false);

        final EditText editText = til.getEditText();
        if (editText == null) {
            return;
        }
        refreshTextInputLayout(til, editText, rule, showErrorIcon);
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                refreshTextInputLayout(til, editText, rule, showErrorIcon);
            }
        });
    }

    public static void setDisplayValid(TextView textView, boolean valid) {
        if (textView == null) {
            return;
        }
        ensureEndPadding(textView);
        textView.setCompoundDrawablesWithIntrinsicBounds(null, null,
                valid ? statusDrawable(textView, true) : null, null);
    }

    public static void refreshDisplay(TextView textView, InputRule rule) {
        if (textView == null || rule == null) {
            return;
        }
        CharSequence text = textView.getText();
        String value = text != null ? text.toString() : "";
        if (value.trim().isEmpty()) {
            setDisplayValid(textView, false);
            return;
        }
        ensureEndPadding(textView);
        boolean ok = rule.isValid(value);
        textView.setCompoundDrawablesWithIntrinsicBounds(null, null,
                statusDrawable(textView, ok), null);
    }

    private static void refreshEditText(EditText editText, InputRule rule, boolean showErrorIcon) {
        String value = editText.getText() != null ? editText.getText().toString() : "";
        if (value.trim().isEmpty() && !isPasswordField(editText)) {
            editText.setCompoundDrawablesWithIntrinsicBounds(null, null, null, null);
            return;
        }
        if (value.isEmpty()) {
            editText.setCompoundDrawablesWithIntrinsicBounds(null, null, null, null);
            return;
        }
        boolean ok = rule.isValid(value);
        if (!ok && !showErrorIcon) {
            editText.setCompoundDrawablesWithIntrinsicBounds(null, null, null, null);
            return;
        }
        editText.setCompoundDrawablesWithIntrinsicBounds(null, null,
                statusDrawable(editText, ok), null);
    }

    private static void refreshTextInputLayout(TextInputLayout til, EditText editText,
                                              InputRule rule, boolean showErrorIcon) {
        String value = editText.getText() != null ? editText.getText().toString() : "";
        if (value.trim().isEmpty()) {
            til.setError(null);
            til.setEndIconVisible(false);
            return;
        }
        boolean ok = rule.isValid(value);
        if (ok) {
            til.setError(null);
            til.setEndIconDrawable(R.drawable.ic_input_check_ok);
            til.setEndIconTintList(ColorStateList.valueOf(CHECK_COLOR));
            til.setEndIconVisible(true);
        } else if (showErrorIcon) {
            til.setError(null); // icono X, sin mensaje bajo el campo (menos ruido)
            til.setEndIconDrawable(R.drawable.ic_input_error);
            til.setEndIconTintList(ColorStateList.valueOf(ERROR_COLOR));
            til.setEndIconVisible(true);
        } else {
            til.setError(rule.errorMessage());
            til.setEndIconVisible(false);
        }
    }

    private static Drawable statusDrawable(View host, boolean ok) {
        int res = ok ? R.drawable.ic_input_check_ok : R.drawable.ic_input_error;
        int color = ok ? CHECK_COLOR : ERROR_COLOR;
        Drawable d = ContextCompat.getDrawable(host.getContext(), res);
        if (d == null) {
            return null;
        }
        d = DrawableCompat.wrap(d.mutate());
        DrawableCompat.setTint(d, color);
        return d;
    }

    private static void ensureEndPadding(TextView textView) {
        int pad = dp(textView, 10);
        if (textView.getPaddingEnd() < pad) {
            textView.setPaddingRelative(
                    textView.getPaddingStart(),
                    textView.getPaddingTop(),
                    pad,
                    textView.getPaddingBottom());
        }
        textView.setCompoundDrawablePadding(dp(textView, 6));
    }

    private static int dp(View view, int value) {
        return Math.round(value * view.getResources().getDisplayMetrics().density);
    }

    private static boolean isPasswordField(EditText editText) {
        int type = editText.getInputType();
        int klass = type & InputType.TYPE_MASK_CLASS;
        int variation = type & InputType.TYPE_MASK_VARIATION;
        return klass == InputType.TYPE_CLASS_TEXT
                && (variation == InputType.TYPE_TEXT_VARIATION_PASSWORD
                || variation == InputType.TYPE_TEXT_VARIATION_WEB_PASSWORD
                || variation == InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
    }

    private static InputRule inferRule(EditText editText) {
        int type = editText.getInputType();
        int variation = type & InputType.TYPE_MASK_VARIATION;
        if (variation == InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS
                || variation == InputType.TYPE_TEXT_VARIATION_WEB_EMAIL_ADDRESS) {
            return InputValidators.email();
        }
        return InputValidators.notBlank();
    }
}
