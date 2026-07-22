package pe.com.hermes.common.ui

import android.content.res.ColorStateList
import android.text.Editable
import android.text.TextWatcher
import android.widget.EditText
import com.google.android.material.textfield.TextInputLayout
import pe.com.hermes.common.R

/**
 * Validación visual en tiempo real de un TextInputLayout — equivalente moderno
 * de ValidInputHelper.java de FastSales: muestra un ícono de check al costado
 * cuando el valor cumple la regla, o el error nativo de Material cuando no.
 */
object ValidInputHelper {

    private const val COLOR_OK = 0xFF00BFA5.toInt()

    fun interface Regla {
        fun esValido(valor: String): Boolean
    }

    fun notBlank(): Regla = Regla { it.isNotBlank() }
    fun minLength(min: Int): Regla = Regla { it.trim().length >= min }
    fun numeroPositivo(): Regla = Regla { it.toDoubleOrNull()?.let { n -> n > 0 } ?: false }

    /** Engancha la validación al campo; se re-evalúa en cada cambio de texto. */
    fun bind(campo: TextInputLayout, regla: Regla, mensajeError: String = "Valor inválido") {
        val editText = campo.editText ?: return
        editText.addTextChangedListener(object : TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {}
            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {}
            override fun afterTextChanged(s: Editable?) = actualizar(campo, editText, regla, mensajeError)
        })
        actualizar(campo, editText, regla, mensajeError)
    }

    private fun actualizar(campo: TextInputLayout, editText: EditText, regla: Regla, mensajeError: String) {
        val valor = editText.text?.toString().orEmpty()
        if (valor.isEmpty()) {
            campo.error = null
            campo.endIconMode = TextInputLayout.END_ICON_NONE
            return
        }
        if (regla.esValido(valor)) {
            campo.error = null
            campo.endIconMode = TextInputLayout.END_ICON_CUSTOM
            campo.setEndIconDrawable(R.drawable.ic_input_check_ok)
            campo.setEndIconTintList(ColorStateList.valueOf(COLOR_OK))
            campo.isEndIconVisible = true
        } else {
            campo.endIconMode = TextInputLayout.END_ICON_NONE
            campo.error = mensajeError
        }
    }
}
