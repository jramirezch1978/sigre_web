package pe.com.sytco.fastsales.beans.ParteTransferencia;

import java.io.Serializable;

public class BeanParteTransferenciaUnd implements Serializable {
    private String nroParte;
    private Integer nroItem;
    private String codigoCU;
    private String codUsuario;
    private String codArt;

    public String getCodArt() {
        return codArt;
    }

    public void setCodArt(String codArt) {
        this.codArt = codArt;
    }

    public String getNroParte() {
        return nroParte;
    }

    public void setNroParte(String nroParte) {
        this.nroParte = nroParte;
    }

    public Integer getNroItem() {
        return nroItem;
    }

    public void setNroItem(Integer nroItem) {
        this.nroItem = nroItem;
    }

    public String getCodigoCU() {
        return codigoCU;
    }

    public void setCodigoCU(String codigoCU) {
        this.codigoCU = codigoCU;
    }

    public String getCodUsuario() {
        return codUsuario;
    }

    public void setCodUsuario(String codUsuario) {
        this.codUsuario = codUsuario;
    }


}
