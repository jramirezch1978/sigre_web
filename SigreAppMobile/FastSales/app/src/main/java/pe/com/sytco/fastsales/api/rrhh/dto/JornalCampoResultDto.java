package pe.com.sytco.fastsales.api.rrhh.dto;

public class JornalCampoResultDto {
    private String fecha;
    private String codTrabajador;
    private int nroItem;
    private String codLabor;
    private String descLabor;
    private String codCuadrilla;
    private String otAdm;
    private String operSec;
    private Double hrsNormales;
    private Double hrsExtras25;
    private Double hrsExtras35;
    private Double hrsExtras100;
    private Double hrsNocNormal;
    private Double hrsNocExtras25;
    private Double hrsNocExtras35;
    private Double jornalBasico;
    private Double asignFamiliar;
    private Double impHrsNorm;
    private Double impHrs25;
    private Double impHrs35;
    private Double impHrs100;
    private Double impHrsNocNor;
    private Double impHrsNoc25;
    private Double impHrsNoc35;
    private Double aporteOblig;
    private Double aporteEssalud;
    private String mensaje;

    public String getFecha() { return fecha; }
    public String getCodTrabajador() { return codTrabajador; }
    public int getNroItem() { return nroItem; }
    public String getCodLabor() { return codLabor; }
    public String getDescLabor() { return descLabor; }
    public String getCodCuadrilla() { return codCuadrilla; }
    public String getOtAdm() { return otAdm; }
    public String getOperSec() { return operSec; }
    public Double getHrsNormales() { return hrsNormales; }
    public Double getHrsExtras25() { return hrsExtras25; }
    public Double getHrsExtras35() { return hrsExtras35; }
    public Double getHrsExtras100() { return hrsExtras100; }
    public Double getHrsNocNormal() { return hrsNocNormal; }
    public Double getHrsNocExtras25() { return hrsNocExtras25; }
    public Double getHrsNocExtras35() { return hrsNocExtras35; }
    public Double getJornalBasico() { return jornalBasico; }
    public Double getAsignFamiliar() { return asignFamiliar; }
    public Double getImpHrsNorm() { return impHrsNorm; }
    public Double getImpHrs25() { return impHrs25; }
    public Double getImpHrs35() { return impHrs35; }
    public Double getImpHrs100() { return impHrs100; }
    public Double getImpHrsNocNor() { return impHrsNocNor; }
    public Double getImpHrsNoc25() { return impHrsNoc25; }
    public Double getImpHrsNoc35() { return impHrsNoc35; }
    public Double getAporteOblig() { return aporteOblig; }
    public Double getAporteEssalud() { return aporteEssalud; }
    public String getMensaje() { return mensaje; }

    public String getResumenImportes() {
        StringBuilder sb = new StringBuilder();
        sb.append("Item: ").append(nroItem).append("\n");
        sb.append("Jornal básico: S/ ").append(format(jornalBasico)).append("\n");
        sb.append("Imp. horas normales: S/ ").append(format(impHrsNorm)).append("\n");
        sb.append("Imp. extra 25%: S/ ").append(format(impHrs25)).append("\n");
        sb.append("Imp. extra 35%: S/ ").append(format(impHrs35)).append("\n");
        sb.append("Imp. extra 100%: S/ ").append(format(impHrs100)).append("\n");
        sb.append("Imp. noct. normal: S/ ").append(format(impHrsNocNor)).append("\n");
        sb.append("Imp. noct. 25%: S/ ").append(format(impHrsNoc25)).append("\n");
        sb.append("Imp. noct. 35%: S/ ").append(format(impHrsNoc35)).append("\n");
        sb.append("Aporte obligatorio: S/ ").append(format(aporteOblig)).append("\n");
        sb.append("Aporte Essalud: S/ ").append(format(aporteEssalud));
        return sb.toString();
    }

    private String format(Double v) {
        if (v == null) return "0.00";
        return String.format(java.util.Locale.US, "%.2f", v);
    }
}
