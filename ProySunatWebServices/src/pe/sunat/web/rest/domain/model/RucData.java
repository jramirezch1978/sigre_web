package pe.sunat.web.rest.domain.model;

import pe.sunat.web.beans.BeanPadronRuc;

/**
 * Datos del RUC para la API REST
 */
public class RucData {
    
    private String ruc;
    private String razonSocial;
    private String estado;
    private String condicion;
    private String ubigeo;
    private String tipoVia;
    private String nombreVia;
    private String codigoZona;
    private String tipoZona;
    private String numero;
    private String interior;
    private String lote;
    private String departamento;
    private String manzana;
    private String kilometro;
    private String codDepartamento;
    private String descDepartamento;
    private String codProvincia;
    private String descProvincia;
    private String descDistrito;
    
    public RucData() {}
    
    /**
     * Convierte un BeanPadronRuc a RucData
     */
    public static RucData fromBean(BeanPadronRuc bean) {
        if (bean == null) return null;
        
        RucData data = new RucData();
        data.setRuc(bean.getRuc());
        data.setRazonSocial(bean.getRazonSocial());
        data.setEstado(bean.getEstado());
        data.setCondicion(bean.getCondicion());
        data.setUbigeo(bean.getUbigeo());
        data.setTipoVia(bean.getTipoVia());
        data.setNombreVia(bean.getNombreVia());
        data.setCodigoZona(bean.getCodigoZona());
        data.setTipoZona(bean.getTipoZona());
        data.setNumero(bean.getNumero());
        data.setInterior(bean.getInterior());
        data.setLote(bean.getLote());
        data.setDepartamento(bean.getDepartamento());
        data.setManzana(bean.getManzana());
        data.setKilometro(bean.getKilometro());
        data.setCodDepartamento(bean.getCodDepartamento());
        data.setDescDepartamento(bean.getDescDepartamento());
        data.setCodProvincia(bean.getCodProvincia());
        data.setDescProvincia(bean.getDescProvincia());
        data.setDescDistrito(bean.getDescDistrito());
        return data;
    }
    
    // Getters y Setters
    public String getRuc() { return ruc; }
    public void setRuc(String ruc) { this.ruc = ruc; }
    
    public String getRazonSocial() { return razonSocial; }
    public void setRazonSocial(String razonSocial) { this.razonSocial = razonSocial; }
    
    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }
    
    public String getCondicion() { return condicion; }
    public void setCondicion(String condicion) { this.condicion = condicion; }
    
    public String getUbigeo() { return ubigeo; }
    public void setUbigeo(String ubigeo) { this.ubigeo = ubigeo; }
    
    public String getTipoVia() { return tipoVia; }
    public void setTipoVia(String tipoVia) { this.tipoVia = tipoVia; }
    
    public String getNombreVia() { return nombreVia; }
    public void setNombreVia(String nombreVia) { this.nombreVia = nombreVia; }
    
    public String getCodigoZona() { return codigoZona; }
    public void setCodigoZona(String codigoZona) { this.codigoZona = codigoZona; }
    
    public String getTipoZona() { return tipoZona; }
    public void setTipoZona(String tipoZona) { this.tipoZona = tipoZona; }
    
    public String getNumero() { return numero; }
    public void setNumero(String numero) { this.numero = numero; }
    
    public String getInterior() { return interior; }
    public void setInterior(String interior) { this.interior = interior; }
    
    public String getLote() { return lote; }
    public void setLote(String lote) { this.lote = lote; }
    
    public String getDepartamento() { return departamento; }
    public void setDepartamento(String departamento) { this.departamento = departamento; }
    
    public String getManzana() { return manzana; }
    public void setManzana(String manzana) { this.manzana = manzana; }
    
    public String getKilometro() { return kilometro; }
    public void setKilometro(String kilometro) { this.kilometro = kilometro; }
    
    public String getCodDepartamento() { return codDepartamento; }
    public void setCodDepartamento(String codDepartamento) { this.codDepartamento = codDepartamento; }
    
    public String getDescDepartamento() { return descDepartamento; }
    public void setDescDepartamento(String descDepartamento) { this.descDepartamento = descDepartamento; }
    
    public String getCodProvincia() { return codProvincia; }
    public void setCodProvincia(String codProvincia) { this.codProvincia = codProvincia; }
    
    public String getDescProvincia() { return descProvincia; }
    public void setDescProvincia(String descProvincia) { this.descProvincia = descProvincia; }
    
    public String getDescDistrito() { return descDistrito; }
    public void setDescDistrito(String descDistrito) { this.descDistrito = descDistrito; }
}
