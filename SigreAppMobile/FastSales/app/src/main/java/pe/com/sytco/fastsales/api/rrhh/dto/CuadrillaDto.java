package pe.com.sytco.fastsales.api.rrhh.dto;

public class CuadrillaDto {
    private String codCuadrilla;
    private String descCuadrilla;
    private String turno;
    private String descTurno;
    private String otAdm;
    private String descOtAdm;

    public String getCodCuadrilla() { return codCuadrilla; }
    public String getDescCuadrilla() { return descCuadrilla; }
    public String getTurno() { return turno; }
    public String getDescTurno() { return descTurno; }
    public String getOtAdm() { return otAdm; }
    public String getDescOtAdm() { return descOtAdm; }

    public String getLabel() {
        return codCuadrilla + " - " + descCuadrilla;
    }
}
