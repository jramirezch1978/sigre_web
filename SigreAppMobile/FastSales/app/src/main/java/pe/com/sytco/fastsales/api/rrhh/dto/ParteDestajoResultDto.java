package pe.com.sytco.fastsales.api.rrhh.dto;

public class ParteDestajoResultDto {
    private String nroParte;
    private Double precioUnit;
    private Double produccionTotal;
    private int trabajadoresRegistrados;
    private String mensaje;

    public String getNroParte() { return nroParte; }
    public Double getPrecioUnit() { return precioUnit; }
    public Double getProduccionTotal() { return produccionTotal; }
    public int getTrabajadoresRegistrados() { return trabajadoresRegistrados; }
    public String getMensaje() { return mensaje; }
}
