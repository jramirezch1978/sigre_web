package pe.com.sytco.fastsales.api.rrhh.dto;

public class ParteDestajoConsultaDto {
    private String nroParte;
    private String fecParte;
    private String codCuadrilla;
    private String codEspecie;
    private String codPresentacion;
    private String codTarea;
    private String otAdm;
    private Double precioUnit;
    private Double produccionTotal;
    private String turno;

    public String getNroParte() { return nroParte; }
    public String getFecParte() { return fecParte; }
    public String getCodCuadrilla() { return codCuadrilla; }
    public String getCodEspecie() { return codEspecie; }
    public String getCodPresentacion() { return codPresentacion; }
    public String getCodTarea() { return codTarea; }
    public String getOtAdm() { return otAdm; }
    public Double getPrecioUnit() { return precioUnit; }
    public Double getProduccionTotal() { return produccionTotal; }
    public String getTurno() { return turno; }

    public String getLabel() {
        return "Parte " + nroParte + " | " + codCuadrilla + " | Prod: " + produccionTotal;
    }
}
