package pe.com.sytco.fastsales.beans.ParteEmpaque;

import java.io.Serializable;

import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanParteEmpaqueUnd extends BeanAncestor implements Serializable {
    /**
     *
     */
    private static final long serialVersionUID = -3388541281082302764L;

    private String codigoCU, regkey, descArticulo, codSKU, fecRegistro, codUsuario, nroParte;
    private Long nroItem;

    public String getCodigoCU() {
        return codigoCU;
    }

    public void setCodigoCU(String codigoCU) {
        this.codigoCU = codigoCU;
    }

    public String getRegkey() {
        return regkey;
    }

    public void setRegkey(String regkey) {
        this.regkey = regkey;
    }

    public String getDescArticulo() {
        return descArticulo;
    }

    public void setDescArticulo(String descArticulo) {
        this.descArticulo = descArticulo;
    }

    public String getCodSKU() {
        return codSKU;
    }

    public void setCodSKU(String codSKU) {
        this.codSKU = codSKU;
    }

    public String getFecRegistro() {
        return fecRegistro;
    }

    public void setFecRegistro(String fecRegistro) {
        this.fecRegistro = fecRegistro;
    }

    public String getCodUsuario() {
        return codUsuario;
    }

    public void setCodUsuario(String codUsuario) {
        this.codUsuario = codUsuario;
    }

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
}
