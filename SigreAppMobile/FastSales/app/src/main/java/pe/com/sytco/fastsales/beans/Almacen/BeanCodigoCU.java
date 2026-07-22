package pe.com.sytco.fastsales.beans.Almacen;

import java.io.Serializable;
import java.util.List;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanCodigoCU extends BeanAncestor implements Serializable {
    private static final long serialVersionUID = 5941106180436807625L;

    private String almacen, descAlmacen, flagTipoAlmacen, codArt, Anaquel, Fila, Columna, NroPallet, NroLote, CUS, descArt,
            und, und2, palletOrCU;
    private Double saldoUnd1, saldoUnd2, factorConvUnd;



    public String getAlmacen() {
        return almacen;
    }
    public void setAlmacen(String almacen) {
        this.almacen = almacen;
    }
    public String getDescAlmacen() {
        return descAlmacen;
    }
    public void setDescAlmacen(String descAlmacen) {
        this.descAlmacen = descAlmacen;
    }
    public String getFlagTipoAlmacen() {
        return flagTipoAlmacen;
    }
    public void setFlagTipoAlmacen(String flagTipoAlmacen) {
        this.flagTipoAlmacen = flagTipoAlmacen;
    }
    public String getCodArt() {
        return codArt;
    }
    public void setCodArt(String codArt) {
        this.codArt = codArt;
    }
    public String getAnaquel() {
        return Anaquel;
    }
    public void setAnaquel(String anaquel) {
        Anaquel = anaquel;
    }
    public String getFila() {
        return Fila;
    }
    public void setFila(String fila) {
        Fila = fila;
    }
    public String getColumna() {
        return Columna;
    }
    public void setColumna(String columna) {
        Columna = columna;
    }
    public String getNroPallet() {
        return NroPallet;
    }
    public void setNroPallet(String nroPallet) {
        NroPallet = nroPallet;
    }
    public String getNroLote() {
        return NroLote;
    }
    public void setNroLote(String nroLote) {
        NroLote = nroLote;
    }
    public String getCUS() {
        return CUS;
    }
    public void setCUS(String CUS) {
        this.CUS = CUS;
    }
    public String getDescArt() {
        return descArt;
    }
    public void setDescArt(String descArt) {
        this.descArt = descArt;
    }
    public String getUnd() {
        return und;
    }
    public void setUnd(String und) {
        this.und = und;
    }
    public String getUnd2() {
        return und2;
    }
    public void setUnd2(String und2) {
        this.und2 = und2;
    }
    public String getPalletOrCU() {
        return palletOrCU;
    }
    public void setPalletOrCU(String palletOrCU) {
        this.palletOrCU = palletOrCU;
    }
    public Double getSaldoUnd1() {
        return saldoUnd1;
    }
    public void setSaldoUnd1(Double saldoUnd1) {
        this.saldoUnd1 = saldoUnd1;
    }
    public Double getSaldoUnd2() {
        return saldoUnd2;
    }
    public void setSaldoUnd2(Double saldoUnd2) {
        this.saldoUnd2 = saldoUnd2;
    }
    public Double getFactorConvUnd() {
        return factorConvUnd;
    }
    public void setFactorConvUnd(Double factorConvUnd) {
        this.factorConvUnd = factorConvUnd;
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

        if(soapObject.getProperty("flagTipoAlmacen") != null)
            this.flagTipoAlmacen = soapObject.getProperty("flagTipoAlmacen").toString();
        else
            this.flagTipoAlmacen = "";

        if(soapObject.getProperty("codArt") != null)
            this.codArt = soapObject.getProperty("codArt").toString();
        else
            this.codArt = "";

        if(soapObject.getProperty("Anaquel") != null)
            this.Anaquel = soapObject.getProperty("Anaquel").toString();
        else
            this.Anaquel = "";

        if(soapObject.getProperty("Fila") != null)
            this.Fila = soapObject.getProperty("Fila").toString();
        else
            this.Fila = "";

        if(soapObject.getProperty("Columna") != null)
            this.Columna = soapObject.getProperty("Columna").toString();
        else
            this.Columna = "";

        if(soapObject.getProperty("NroPallet") != null)
            this.NroPallet = soapObject.getProperty("NroPallet").toString();
        else
            this.NroPallet = "";

        if(soapObject.getProperty("NroLote") != null)
            this.NroLote = soapObject.getProperty("NroLote").toString();
        else
            this.NroLote = "";

        if(soapObject.getProperty("CUS") != null)
            this.CUS = soapObject.getProperty("CUS").toString();
        else
            this.CUS = "";

        if(soapObject.getProperty("descArt") != null)
            this.descArt = soapObject.getProperty("descArt").toString();
        else
            this.descArt = "";

        if(soapObject.getProperty("und") != null)
            this.und = soapObject.getProperty("und").toString();
        else
            this.und = "";

        if(soapObject.getProperty("und2") != null)
            this.und2 = soapObject.getProperty("und2").toString();
        else
            this.und2 = "";

        if(soapObject.getProperty("palletOrCU") != null)
            this.palletOrCU = soapObject.getProperty("palletOrCU").toString();
        else
            this.palletOrCU = "";

        if (soapObject.getProperty("saldoUnd1") == null)
            this.saldoUnd1 = 0.0;
        else
            this.saldoUnd1 = Double.parseDouble(soapObject.getProperty("saldoUnd1").toString());

        if (soapObject.getProperty("saldoUnd2") == null)
            this.saldoUnd2 = 0.0;
        else
            this.saldoUnd2 = Double.parseDouble(soapObject.getProperty("saldoUnd2").toString());

        if (soapObject.getProperty("factorConvUnd") == null)
            this.factorConvUnd = 0.0;
        else
            this.factorConvUnd = Double.parseDouble(soapObject.getProperty("factorConvUnd").toString());

    }

    public static Double getSaldoUnd1(List<BeanCodigoCU> pListado) {
        Double ldbl_Return = 0.0;

        for(BeanCodigoCU bean : pListado){
            ldbl_Return += bean.getSaldoUnd1();
        }

        return ldbl_Return;
    }

    public static Double getSaldoUnd2(List<BeanCodigoCU> pListado) {
        Double ldbl_Return = 0.0;

        for(BeanCodigoCU bean : pListado){
            ldbl_Return += bean.getSaldoUnd2();
        }

        return ldbl_Return;
    }

}
