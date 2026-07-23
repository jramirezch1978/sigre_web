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

/**
 * Check verde dentro del control cuando el dato es válido.
 * Equivalente de {@code pe.com.sytco.fastsales.util.ValidInputHelper}.
 */
public final class ValidInputHelper {

    public static final int CHECK_COLOR = Color.parseColor("#00BFA5");

    public interface Rule {
        boolean isValid(String value);
    }

    /** Alias en español para no romper llamadas existentes. */
    public interface Regla extends Rule {
        @Override
        default boolean isValid(String value) {
            return esValido(value);
        }

        boolean esValido(String valor);
    }

    private ValidInputHelper() {
    }

    public static Rule notBlank() {
        return value -> value != null && !value.trim().isEmpty();
    }

    public static Rule minLength(final int min) {
        return value -> value != null && value.trim().length() >= min;
    }

    public static Rule positiveNumber() {
        return value -> {
            if (value == null || value.trim().isEmpty()) {
                return false;
            }
            try {
                return Double.parseDouble(value.trim().replace(',', '.')) > 0d;
            } catch (Exception ex) {
                return false;
            }
        };
    }

    /** Compatibilidad con API previa. */
    public static Regla numeroPositivo() {
        return value -> positiveNumber().isValid(value);
    }

    /** Recorre el árbol y engancha validación a EditText / TextInputLayout. */
    public static void bindTree(View root) {
        if (root == null) {
            return;
        }
        if (root instanceof TextInputLayout) {
            TextInputLayout til = (TextInputLayout) root;
            EditText nested = til.getEditText();
            bindTextInputLayout(til, nested != null ? inferRule(nested) : notBlank());
            return;
        }
        if (root instanceof EditText) {
            EditText editText = (EditText) root;
            if (!isPasswordField(editText)) {
                bindEditText(editText, inferRule(editText));
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
        bindTextInputLayout(campo, regla != null ? regla : notBlank());
    }

    public static void bind(TextInputLayout campo, Regla regla) {
        bind(campo, regla, "Valor inválido");
    }

    public static void bindEditText(final EditText editText, final Rule rule) {
        if (editText == null || rule == null) {
            return;
        }
        ensureEndPadding(editText);
        refreshEditText(editText, rule);
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                refreshEditText(editText, rule);
            }
        });
    }

    public static void bindTextInputLayout(final TextInputLayout til, final Rule rule) {
        if (til == null || rule == null) {
            return;
        }
        // No pisar el toggle de contraseña: check como drawableEnd del EditText
        if (til.getEndIconMode() == TextInputLayout.END_ICON_PASSWORD_TOGGLE) {
            EditText edit = til.getEditText();
            if (edit != null) {
                bindEditText(edit, rule);
            }
            return;
        }
        til.setEndIconMode(TextInputLayout.END_ICON_CUSTOM);
        til.setEndIconDrawable(R.drawable.ic_input_check_ok);
        til.setEndIconTintList(ColorStateList.valueOf(CHECK_COLOR));
        til.setEndIconCheckable(false);
        til.setEndIconVisible(false);

        final EditText editText = til.getEditText();
        if (editText == null) {
            return;
        }
        refreshTextInputLayout(til, editText, rule);
        editText.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
            }

            @Override
            public void afterTextChanged(Editable s) {
                refreshTextInputLayout(til, editText, rule);
            }
        });
    }

    /** Para TextView/readonly que muestran un valor seleccionado (ej. servidor). */
    public static void setDisplayValid(TextView textView, boolean valid) {
        if (textView == null) {
            return;
        }
        ensureEndPadding(textView);
        textView.setCompoundDrawablesWithIntrinsicBounds(null, null,
                valid ? checkDrawable(textView) : null, null);
    }

    public static void refreshDisplay(TextView textView, Rule rule) {
        if (textView == null || rule == null) {
            return;
        }
        CharSequence text = textView.getText();
        setDisplayValid(textView, rule.isValid(text != null ? text.toString() : ""));
    }

    private static void refreshEditText(EditText editText, Rule rule) {
        boolean ok = rule.isValid(editText.getText() != null ? editText.getText().toString() : "");
        editText.setCompoundDrawablesWithIntrinsicBounds(null, null,
                ok ? checkDrawable(editText) : null, null);
    }

    private static void refreshTextInputLayout(TextInputLayout til, EditText editText, Rule rule) {
        boolean ok = rule.isValid(editText.getText() != null ? editText.getText().toString() : "");
        til.setEndIconVisible(ok);
    }

    private static Drawable checkDrawable(View host) {
        Drawable d = ContextCompat.getDrawable(host.getContext(), R.drawable.ic_input_check_ok);
        if (d == null) {
            return null;
        }
        d = DrawableCompat.wrap(d.mutate());
        DrawableCompat.setTint(d, CHECK_COLOR);
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

    private static Rule inferRule(EditText editText) {
        return notBlank();
    }
}
