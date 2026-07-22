package pe.com.sytco.fastsales.api.rrhh.dto;

public class TrabajadorResumenDto {
    private String codTrabajador;
    private String nomTrabajador;
    private String dni;

    public String getCodTrabajador() { return codTrabajador; }
    public String getNomTrabajador() { return nomTrabajador; }
    public String getDni() { return dni; }

    public String getLabel() {
        return nomTrabajador + " (" + dni + ")";
    }
}
