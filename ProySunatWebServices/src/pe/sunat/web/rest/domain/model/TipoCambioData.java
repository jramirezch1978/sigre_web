package pe.sunat.web.rest.domain.model;

/**
 * Datos del tipo de cambio SUNAT/SBS
 */
public class TipoCambioData {
    
    private String fecha;
    private double sunat;
    private double compra;
    private double venta;
    
    public TipoCambioData() {}
    
    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }
    
    public double getSunat() { return sunat; }
    public void setSunat(double sunat) { this.sunat = sunat; }
    
    public double getCompra() { return compra; }
    public void setCompra(double compra) { this.compra = compra; }
    
    public double getVenta() { return venta; }
    public void setVenta(double venta) { this.venta = venta; }
}
