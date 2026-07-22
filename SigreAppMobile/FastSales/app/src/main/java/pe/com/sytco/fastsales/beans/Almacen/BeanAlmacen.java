package pe.com.sytco.fastsales.beans.Almacen;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

/**
 * Created by jramirez on 05/05/2016.
 */
public class BeanAlmacen extends BeanAncestor implements Serializable {

    /*
    Name              Type         Nullable Default Comments
    ----------------- ------------ -------- ------- -----------------
    ALMACEN           CHAR(6)                       cod almacen
    CENCOS            CHAR(10)     Y                centro costo
    COD_RESPONSABLE   CHAR(6)      Y                cod responsable
    FLAG_TIPO_ALMACEN CHAR(1)      Y                flag tipo almacen
    DESC_ALMACEN      VARCHAR2(60) Y                desc almacen
    DIRECCION         VARCHAR2(80) Y                direccion
    AREA_TOTAL        NUMBER(7,2)  Y                area total
    VOL_TOTAL         NUMBER(7,2)  Y                volumen total
    COD_ORIGEN        CHAR(2)      Y                codigo origen
    FLAG_ESTADO       CHAR(1)               '1'     flag estado
    FLAG_CNTRL_LOTE   CHAR(1)      Y        '1'     flag cntrl lote
    DISTRITO          VARCHAR2(25) Y                distrito
    PROVINCIA         VARCHAR2(25) Y                provincia
    DEPARTAMENTO      VARCHAR2(25) Y                departamento
    PROV_ALMACEN      CHAR(8)      Y                cod proveedor
    COD_SUNAT         CHAR(4)               '0001'
    */

    private String almacen;
    private String cencos;
    private String codResponsable;
    private String flagTipoAlmacen;
    private String descAlmacen;
    private String direccion;
    private Float areaTotal;
    private Float volumenTotal;
    private String codOrigen;
    private String flagEstado;
    private String flagCntrlLote;
    private String distrito;
    private String provincia;
    private String departamento;
    private String codSunat;
    private String provAlmacen;
    private Integer almacenId = 1;
    private Float saldoTotal;

    public String getAlmacen() {
        return almacen;
    }
    public void setAlmacen(String almacen) {
        this.almacen = almacen;
    }
    public String getCencos() {
        return cencos;
    }
    public void setCencos(String cencos) {
        this.cencos = cencos;
    }
    public String getCodResponsable() {
        return codResponsable;
    }
    public void setCodResponsable(String codResponsable) {
        this.codResponsable = codResponsable;
    }
    public String getFlagTipoAlmacen() {
        return flagTipoAlmacen;
    }
    public void setFlagTipoAlmacen(String flagTipoAlmacen) {
        this.flagTipoAlmacen = flagTipoAlmacen;
    }
    public String getDescAlmacen() {
        return descAlmacen;
    }
    public void setDescAlmacen(String descAlmacen) {
        this.descAlmacen = descAlmacen;
    }
    public String getDireccion() {
        return direccion;
    }
    public void setDireccion(String direccion) {
        this.direccion = direccion;
    }
    public Float getAreaTotal() {
        return areaTotal;
    }
    public void setAreaTotal(Float areaTotal) {
        this.areaTotal = areaTotal;
    }
    public Float getVolumenTotal() {
        return volumenTotal;
    }
    public void setVolumenTotal(Float volumenTotal) {
        this.volumenTotal = volumenTotal;
    }
    public String getCodOrigen() {
        return codOrigen;
    }
    public void setCodOrigen(String codOrigen) {
        this.codOrigen = codOrigen;
    }
    public String getFlagEstado() {
        return flagEstado;
    }
    public void setFlagEstado(String flagEstado) {
        this.flagEstado = flagEstado;
    }
    public String getFlagCntrlLote() {
        return flagCntrlLote;
    }
    public void setFlagCntrlLote(String flagCntrlLote) {
        this.flagCntrlLote = flagCntrlLote;
    }
    public String getDistrito() {
        return distrito;
    }
    public void setDistrito(String distrito) {
        this.distrito = distrito;
    }
    public String getProvincia() {
        return provincia;
    }
    public void setProvincia(String provincia) {
        this.provincia = provincia;
    }
    public String getDepartamento() {
        return departamento;
    }
    public void setDepartamento(String departamento) {
        this.departamento = departamento;
    }
    public String getCodSunat() {
        return codSunat;
    }
    public void setCodSunat(String codSunat) {
        this.codSunat = codSunat;
    }
    public String getProvAlmacen() {
        return provAlmacen;
    }
    public void setProvAlmacen(String provAlmacen) {
        this.provAlmacen = provAlmacen;
    }
    public Integer getAlmacenId() {
        return almacenId;
    }
    public Float getSaldoTotal() {
        return saldoTotal;
    }
    public void setSaldoTotal(Float value){
        this.saldoTotal = value;
    }

    public String getDescEstado() {
        if (this.flagEstado == null && !this.flagEstado.equals("")){
            return "NO ESPECIFICADO";
        }else{
            if (this.flagEstado.equals("0")){
                return "ANULADO";
            }else{
                return "ACTIVO";
            }
        }
    }

    @Override
    public String toString() {
        if (this.almacen == null && this.descAlmacen == null) return null;

        return this.almacen.trim() + '-' + this.descAlmacen.trim();
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {

        super.populate(soapObject);

        if(soapObject.getProperty("almacen") != null)
            this.almacen = soapObject.getProperty("almacen").toString();
        else
            this.almacen = "";

        if(soapObject.getProperty("descAlmacen") != null)
            this.descAlmacen = soapObject.getProperty("descAlmacen").toString();
        else
            this.descAlmacen = "";

        if(soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado = "";

        if(soapObject.getProperty("codOrigen") != null)
            this.codOrigen = soapObject.getProperty("codOrigen").toString();
        else
            this.codOrigen = "";

        if (soapObject.getProperty("saldoTotal") == null)
            this.saldoTotal = 0.0F;
        else
            this.saldoTotal = Float.parseFloat(soapObject.getProperty("saldoTotal").toString());

    }



}
