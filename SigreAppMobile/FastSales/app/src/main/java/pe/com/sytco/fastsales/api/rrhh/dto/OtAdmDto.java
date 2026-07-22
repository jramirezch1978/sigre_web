package pe.com.sytco.fastsales.api.rrhh.dto;

public class OtAdmDto {
    private String otAdm;
    private String descripcion;

    public String getOtAdm() { return otAdm; }
    public String getDescripcion() { return descripcion; }

    public String getLabel() {
        return otAdm + " - " + descripcion;
    }
}
