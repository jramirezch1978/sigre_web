package com.sigre.common.config;

/**
 * Nombres canónicos de parámetros en {@code config.configuracion}.
 * <p>
 * Los nombres son <strong>universales</strong>: no incluir el módulo en el string del parámetro.
 * Agrupación opcional vía {@link Modulo} (columna {@code modulo}).
 * Lectura/escritura: {@link com.sigre.common.service.ConfiguracionParametroService}
 * → {@code config.fn_get_parametro_*} / {@code config.fn_set_parametro_*}.
 */
public final class ConfigParametros {

    private ConfigParametros() {}

    /**
     * Valores de la columna {@code modulo} (agrupación). No forman parte del nombre del parámetro.
     */
    public static final class Modulo {
        private Modulo() {}

        public static final String GENERAL = "GENERAL";
        public static final String CORE = "CORE";
        public static final String COMPRAS = "COMPRAS";
        public static final String SOPORTE = "SOPORTE";
    }

    // ── Parámetros universales (columna parametro) ──────────────────────────

    /** Código de {@code core.articulo_clase} = producto terminado. Módulo: {@link Modulo#GENERAL}. */
    public static final String CLASE_PRODUCTO_TERMINADO = "CLASE_PRODUCTO_TERMINADO";

    /** Años de antigüedad del numerador de documentos. Módulo: {@link Modulo#CORE}. */
    public static final String NUMERADOR_ANTIGUEDAD_ANIOS = "NUMERADOR_ANTIGUEDAD_ANIOS";

    public static final String TASA_IGV = "TASA_IGV";
    public static final String TASA_PERCEPCION = "TASA_PERCEPCION";

    public static final String COMPRA_APROBACION_OC = "COMPRA_APROBACION_OC";
    public static final String COMPRA_APROBACION_OS = "COMPRA_APROBACION_OS";
    public static final String FLAG_VALIDA_LIMITE_OS = "FLAG_VALIDA_LIMITE_OS";
    public static final String FLAG_RESTR_CENCOS_USR = "flag_restr_cencos_usr";
    public static final String FLAG_CNTRL_FONDOS = "flag_cntrl_fondos";

    /** Lista de emails de soporte (BD security). Módulo: {@link Modulo#SOPORTE}. */
    public static final String EMAILS = "EMAILS";

    /** Valores por defecto de referencia (el caller los pasa a {@code fn_get_parametro_*}). */
    public static final class Default {
        private Default() {}

        public static final String CLASE_PRODUCTO_TERMINADO = "01";
        public static final int NUMERADOR_ANTIGUEDAD_ANIOS = 5;
    }
}
