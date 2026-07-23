package pe.com.hermes.common.validation;

/**
 * Contrato de validación reutilizable para campos de entrada.
 * Las reglas viven en {@link InputValidators}; el binding visual en
 * {@link pe.com.hermes.common.ui.ValidInputHelper}.
 */
public interface InputRule {

    boolean isValid(String value);

    /** Mensaje corto para mostrar cuando falla (opcional). */
    default String errorMessage() {
        return "Valor inválido";
    }
}
