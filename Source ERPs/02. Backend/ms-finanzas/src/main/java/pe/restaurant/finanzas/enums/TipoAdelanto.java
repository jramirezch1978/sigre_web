package pe.restaurant.finanzas.enums;

/**
 * Tipo de Adelanto de la HU-FIN-ADL-003 (Liquidación de adelantos): el beneficiario del
 * adelanto puede ser un Proveedor o un Colaborador.
 *
 * <p>Se modela SIN tocar la base de datos: el código de un solo carácter se persiste en la
 * columna existente {@code finanzas.liquidacion.tipo_liquidacion} (VARCHAR(1)), que hasta
 * ahora se usaba como texto libre sin semántica.
 *
 * <ul>
 *   <li>{@code P} = Proveedor → el beneficiario es {@code liquidacion.proveedor_id}.</li>
 *   <li>{@code C} = Colaborador → el beneficiario se deriva del {@code solicitante_id} de la
 *       {@code solicitud_giro} vinculada (no se persiste un id aparte porque no existe columna).</li>
 * </ul>
 */
public enum TipoAdelanto {

    PROVEEDOR("P", "Proveedor"),
    COLABORADOR("C", "Colaborador");

    private final String codigo;
    private final String etiqueta;

    TipoAdelanto(String codigo, String etiqueta) {
        this.codigo = codigo;
        this.etiqueta = etiqueta;
    }

    public String getCodigo() {
        return codigo;
    }

    public String getEtiqueta() {
        return etiqueta;
    }

    /** Resuelve el enum a partir del código de 1 carácter (case-insensitive); null si no es válido. */
    public static TipoAdelanto fromCodigo(String codigo) {
        if (codigo == null) {
            return null;
        }
        for (TipoAdelanto tipo : values()) {
            if (tipo.codigo.equalsIgnoreCase(codigo.trim())) {
                return tipo;
            }
        }
        return null;
    }

    /** Etiqueta legible ("Proveedor"/"Colaborador") para un código almacenado; null si no es válido. */
    public static String etiquetaDe(String codigo) {
        TipoAdelanto tipo = fromCodigo(codigo);
        return tipo != null ? tipo.etiqueta : null;
    }
}
