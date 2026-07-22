package pe.com.sytco.fastsales.api.rrhh.dto;

public class OperacionDto {
    private String operSec;
    private String descOperacion;
    private String nroOrden;
    private String tituloOt;

    public String getOperSec() { return operSec; }
    public String getDescOperacion() { return descOperacion; }
    public String getNroOrden() { return nroOrden; }
    public String getTituloOt() { return tituloOt; }

    public String getLabel() {
        String ot = nroOrden != null && !nroOrden.isEmpty() ? nroOrden + " | " : "";
        return ot + operSec + " - " + descOperacion;
    }
}
