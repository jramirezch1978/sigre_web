package pe.com.sytco.fastsales.api.rrhh.dto;

public class JornalCampoRequest {
    private String empresa;
    private String usuario;
    private String codOrigen;
    private String fecha;
    private String codTrabajador;
    private String codCuadrilla;
    private String codLabor;
    private String otAdm;
    private String operSec;
    private String horaInicio;
    private String horaFin;
    private Double hrsNormales;
    private Double hrsExtras25;
    private Double hrsExtras35;
    private Double hrsExtras100;
    private Double hrsNocNormal;
    private Double hrsNocExtras25;
    private Double hrsNocExtras35;
    private Integer nroItem;
    private boolean calcularHoras = true;
    private boolean modoEdicion = false;

    public void setEmpresa(String empresa) { this.empresa = empresa; }
    public String getEmpresa() { return empresa; }
    public void setUsuario(String usuario) { this.usuario = usuario; }
    public String getUsuario() { return usuario; }
    public void setCodOrigen(String codOrigen) { this.codOrigen = codOrigen; }
    public void setFecha(String fecha) { this.fecha = fecha; }
    public String getFecha() { return fecha; }
    public void setCodTrabajador(String codTrabajador) { this.codTrabajador = codTrabajador; }
    public String getCodTrabajador() { return codTrabajador; }
    public void setCodCuadrilla(String codCuadrilla) { this.codCuadrilla = codCuadrilla; }
    public void setCodLabor(String codLabor) { this.codLabor = codLabor; }
    public void setOtAdm(String otAdm) { this.otAdm = otAdm; }
    public void setOperSec(String operSec) { this.operSec = operSec; }
    public void setHoraInicio(String horaInicio) { this.horaInicio = horaInicio; }
    public void setHoraFin(String horaFin) { this.horaFin = horaFin; }
    public void setHrsNormales(Double hrsNormales) { this.hrsNormales = hrsNormales; }
    public void setHrsExtras25(Double hrsExtras25) { this.hrsExtras25 = hrsExtras25; }
    public void setHrsExtras35(Double hrsExtras35) { this.hrsExtras35 = hrsExtras35; }
    public void setHrsExtras100(Double hrsExtras100) { this.hrsExtras100 = hrsExtras100; }
    public void setHrsNocNormal(Double hrsNocNormal) { this.hrsNocNormal = hrsNocNormal; }
    public void setHrsNocExtras25(Double hrsNocExtras25) { this.hrsNocExtras25 = hrsNocExtras25; }
    public void setHrsNocExtras35(Double hrsNocExtras35) { this.hrsNocExtras35 = hrsNocExtras35; }
    public void setCalcularHoras(boolean calcularHoras) { this.calcularHoras = calcularHoras; }
    public boolean isCalcularHoras() { return calcularHoras; }
    public void setNroItem(Integer nroItem) { this.nroItem = nroItem; }
    public Integer getNroItem() { return nroItem; }
    public void setModoEdicion(boolean modoEdicion) { this.modoEdicion = modoEdicion; }
    public boolean isModoEdicion() { return modoEdicion; }
}
