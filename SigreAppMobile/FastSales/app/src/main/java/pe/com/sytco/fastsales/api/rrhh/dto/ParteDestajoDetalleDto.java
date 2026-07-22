package pe.com.sytco.fastsales.api.rrhh.dto;

public class ParteDestajoDetalleDto {
    private String codTrabajador;
    private String nomTrabajador;
    private Double cantProducida;
    private String fechaInicio;
    private String fechaFin;

    public String getCodTrabajador() { return codTrabajador; }
    public void setCodTrabajador(String codTrabajador) { this.codTrabajador = codTrabajador; }
    public String getNomTrabajador() { return nomTrabajador; }
    public void setNomTrabajador(String nomTrabajador) { this.nomTrabajador = nomTrabajador; }
    public Double getCantProducida() { return cantProducida; }
    public void setCantProducida(Double cantProducida) { this.cantProducida = cantProducida; }
    public String getFechaInicio() { return fechaInicio; }
    public void setFechaInicio(String fechaInicio) { this.fechaInicio = fechaInicio; }
    public String getFechaFin() { return fechaFin; }
    public void setFechaFin(String fechaFin) { this.fechaFin = fechaFin; }
}
