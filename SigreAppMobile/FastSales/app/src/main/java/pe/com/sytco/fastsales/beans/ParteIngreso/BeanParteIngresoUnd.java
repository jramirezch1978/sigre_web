package pe.com.sytco.fastsales.beans.ParteIngreso;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.util.Hashtable;
import java.util.List;

public class BeanParteIngresoUnd implements Serializable, KvmSerializable {

    private String nroParte;
    private Long nroItem;
    private Double talla;
    private String articulo;
    private Double cantidad;
    private Double precioCompraAnt;
    private Double precioCompraNew;
    private Double precioVentaAnt;
    private Double precioVentaNew;
    private String usuario;

    private String fecRegistro;

    private String regkey, codArticulo, orgAMP, descArticulo, tipoImpuesto, und;
    private Long nroAMP;
    private Double importeImpuesto, precioBase;



    public String getNroParte() {
        return nroParte;
    }

    public void setNroParte(String nroParte) {
        this.nroParte = nroParte;
    }

    public Long getNroItem() {
        return nroItem;
    }

    public void setNroItem(Long nroItem) {
        this.nroItem = nroItem;
    }

    public Double getTalla() {
        return talla;
    }

    public void setTalla(Double talla) {
        this.talla = talla;
    }

    public String getArticulo() {
        return articulo;
    }

    public void setArticulo(String articulo) {
        this.articulo = articulo;
    }

    public Double getCantidad() {
        return cantidad;
    }

    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }

    public Double getPrecioCompraAnt() {
        return precioCompraAnt;
    }

    public void setPrecioCompraAnt(Double precioCompraAnt) {
        this.precioCompraAnt = precioCompraAnt;
    }

    public Double getPrecioCompraNew() {
        return precioCompraNew;
    }

    public void setPrecioCompraNew(Double precioCompraNew) {
        this.precioCompraNew = precioCompraNew;
    }

    public Double getPrecioVentaAnt() {
        return precioVentaAnt;
    }

    public void setPrecioVentaAnt(Double precioVentaAnt) {
        this.precioVentaAnt = precioVentaAnt;
    }

    public Double getPrecioVentaNew() {
        return precioVentaNew;
    }

    public void setPrecioVentaNew(Double precioVentaNew) {
        this.precioVentaNew = precioVentaNew;
    }

    public String getUsuario() {
        return usuario;
    }

    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }

    public String getFecRegistro() {
        return fecRegistro;
    }

    public void setFecRegistro(String value) {
        this.fecRegistro = value;
    }

    public String getRegkey() {
        return regkey;
    }

    public void setRegkey(String regkey) {
        this.regkey = regkey;
    }

    public String getCodArticulo() {
        return codArticulo;
    }

    public void setCodArticulo(String codArticulo) {
        this.codArticulo = codArticulo;
    }

    public String getOrgAMP() {
        return orgAMP;
    }

    public void setOrgAMP(String orgAMP) {
        this.orgAMP = orgAMP;
    }

    public String getDescArticulo() {
        return descArticulo;
    }

    public void setDescArticulo(String descArticulo) {
        this.descArticulo = descArticulo;
    }

    public String getTipoImpuesto() {
        return tipoImpuesto;
    }

    public void setTipoImpuesto(String tipoImpuesto) {
        this.tipoImpuesto = tipoImpuesto;
    }

    public String getUnd() {
        return und;
    }

    public void setUnd(String und) {
        this.und = und;
    }

    public Long getNroAMP() {
        return nroAMP;
    }

    public void setNroAMP(Long nroAMP) {
        this.nroAMP = nroAMP;
    }

    public Double getImporteImpuesto() {
        return importeImpuesto;
    }

    public void setImporteImpuesto(Double importeImpuesto) {
        this.importeImpuesto = importeImpuesto;
    }

    public Double getPrecioBase() {
        return precioBase;
    }

    public void setPrecioBase(Double precioBase) {
        this.precioBase = precioBase;
    }



    @Override
    public Object getProperty(int i) {
        return null;
    }

    @Override
    public int getPropertyCount() {
        return 0;
    }

    @Override
    public void setProperty(int i, Object o) {

    }

    @Override
    public void getPropertyInfo(int i, Hashtable hashtable, PropertyInfo propertyInfo) {

    }

    @Override
    public String getInnerText() {
        return null;
    }

    @Override
    public void setInnerText(String s) {

    }

    public static Double getTotalUnidades(List<BeanParteIngresoUnd> listado) {
        Double lbl_Return = 0D;

        for(BeanParteIngresoUnd obj: listado){
            lbl_Return += obj.getCantidad();
        }

        return lbl_Return;
    }

    public static Double getTotalBaseCompra(List<BeanParteIngresoUnd> listado) {
        Double lbl_Return = 0D;

        for(BeanParteIngresoUnd obj: listado){
            lbl_Return += obj.getPrecioBase() * obj.getCantidad();
        }

        return lbl_Return;
    }

    public static Double getTotalImpuestos(List<BeanParteIngresoUnd> listado) {
        Double lbl_Return = 0D;

        for(BeanParteIngresoUnd obj: listado){
            lbl_Return += obj.getImporteImpuesto();
        }

        return lbl_Return;
    }

    public static Double getTotalCompra(List<BeanParteIngresoUnd> listado) {
        Double lbl_Return = 0D;

        for(BeanParteIngresoUnd obj: listado){
            lbl_Return += obj.getPrecioBase() * obj.getCantidad() + obj.getImporteImpuesto();
        }

        return lbl_Return;
    }

    public static Double getTotalPrecioCompraAnt(List<BeanParteIngresoUnd> listado) {
        Double lbl_Return = 0D;

        for(BeanParteIngresoUnd obj: listado){
            lbl_Return += obj.getPrecioCompraAnt() * obj.getCantidad();
        }

        return lbl_Return;
    }

    public static Double getTotalPrecioCompraNew(List<BeanParteIngresoUnd> listado) {
        Double lbl_Return = 0D;

        for(BeanParteIngresoUnd obj: listado){
            lbl_Return += obj.getPrecioCompraNew() * obj.getCantidad();
        }

        return lbl_Return;
    }

    public static Double getTotalPrecioVentaAnt(List<BeanParteIngresoUnd> listado) {
        Double lbl_Return = 0D;

        for(BeanParteIngresoUnd obj: listado){
            lbl_Return += obj.getPrecioVentaAnt() * obj.getCantidad();
        }

        return lbl_Return;
    }

    public static Double getTotalPrecioVentaNew(List<BeanParteIngresoUnd> listado) {
        Double lbl_Return = 0D;

        for(BeanParteIngresoUnd obj: listado){
            lbl_Return += obj.getPrecioVentaNew() * obj.getCantidad();
        }

        return lbl_Return;
    }
}
