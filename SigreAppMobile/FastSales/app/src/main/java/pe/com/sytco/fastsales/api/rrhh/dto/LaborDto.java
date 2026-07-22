package pe.com.sytco.fastsales.api.rrhh.dto;

public class LaborDto {
    private String codLabor;
    private String descLabor;

    public String getCodLabor() { return codLabor; }
    public String getDescLabor() { return descLabor; }

    public String getLabel() {
        return codLabor + " - " + descLabor;
    }
}
