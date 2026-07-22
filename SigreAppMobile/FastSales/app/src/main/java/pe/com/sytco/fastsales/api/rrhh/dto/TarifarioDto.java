package pe.com.sytco.fastsales.api.rrhh.dto;

public class TarifarioDto {
    private String codEspecie;
    private String codPresentacion;
    private String codTarea;
    private String codProceso;
    private String codLabor;
    private String und;
    private Double tarifa;

    public String getCodEspecie() { return codEspecie; }
    public String getCodPresentacion() { return codPresentacion; }
    public String getCodTarea() { return codTarea; }
    public String getCodProceso() { return codProceso; }
    public String getCodLabor() { return codLabor; }
    public String getUnd() { return und; }
    public Double getTarifa() { return tarifa; }

    public String getLabel() {
        return codEspecie + " / " + codPresentacion + " / " + codTarea
                + " | Tarifa: " + (tarifa != null ? tarifa : 0)
                + (und != null && !und.isEmpty() ? " (" + und + ")" : "");
    }
}
