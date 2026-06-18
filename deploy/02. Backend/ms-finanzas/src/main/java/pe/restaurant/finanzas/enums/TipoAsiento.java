package pe.restaurant.finanzas.enums;

public enum TipoAsiento {
    PROVISION_CXP("Provisión de Cuenta por Pagar"),
    PAGO_CXP("Pago de Cuenta por Pagar"),
    NOTA_CREDITO_CXP("Nota de Crédito de Cuenta por Pagar"),
    AJUSTE_CXP("Ajuste de Cuenta por Pagar");
    
    private final String descripcion;
    
    TipoAsiento(String descripcion) {
        this.descripcion = descripcion;
    }
    
    public String getDescripcion() {
        return descripcion;
    }
    
    public static TipoAsiento obtenerPorCodigo(String codigo) {
        if (codigo == null) {
            return null;
        }
        for (TipoAsiento tipo : TipoAsiento.values()) {
            if (tipo.name().equalsIgnoreCase(codigo)) {
                return tipo;
            }
        }
        throw new IllegalArgumentException("Tipo de asiento inválido: " + codigo);
    }
}
