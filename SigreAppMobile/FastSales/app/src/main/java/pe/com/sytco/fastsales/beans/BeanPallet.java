package pe.com.sytco.fastsales.beans;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanPallet extends BeanAncestor implements Serializable {
    private Integer nroCus;
    private Double saldoUnd, saldoUnd2;
    private String nroPallet, CodigoCU, PalletOrCU;

    public Integer getNroCus() {
        return nroCus;
    }
    public void setNroCus(Integer nroCus) {
        this.nroCus = nroCus;
    }
    public Double getSaldoUnd() {
        return saldoUnd;
    }
    public void setSaldoUnd(Double saldoUnd) {
        this.saldoUnd = saldoUnd;
    }
    public Double getSaldoUnd2() {
        return saldoUnd2;
    }
    public void setSaldoUnd2(Double saldoUnd2) {
        this.saldoUnd2 = saldoUnd2;
    }
    public String getNroPallet() {
        return nroPallet;
    }
    public void setNroPallet(String nroPallet) {
        this.nroPallet = nroPallet;
    }
    public String getCodigoCU() {
        return CodigoCU;
    }
    public void setCodigoCU(String codigoCU) {
        CodigoCU = codigoCU;
    }
    public String getPalletOrCU() {
        return PalletOrCU;
    }
    public void setPalletOrCU(String palletOrCU) {
        PalletOrCU = palletOrCU;
    }

    @Override
    public void populate(ExtendedSoapObject soapObject) throws Exception {
        super.populate(soapObject);

        if (soapObject.getProperty("nroPallet") == null)
            this.nroPallet = "";
        else
            this.nroPallet = soapObject.getProperty("nroPallet").toString();

        if (soapObject.getProperty("CodigoCU") == null)
            this.CodigoCU = "";
        else
            this.CodigoCU = soapObject.getProperty("CodigoCU").toString();

        if (soapObject.getProperty("PalletOrCU") == null)
            this.PalletOrCU = "";
        else
            this.PalletOrCU = soapObject.getProperty("PalletOrCU").toString();

        if (soapObject.getProperty("nroCus") == null)
            this.nroCus = 0;
        else
            this.nroCus = Integer.parseInt(soapObject.getProperty("nroCus").toString());

        if (soapObject.getProperty("saldoUnd") == null)
            this.saldoUnd = 0.0;
        else
            this.saldoUnd = Double.parseDouble(soapObject.getProperty("saldoUnd").toString());

        if (soapObject.getProperty("saldoUnd2") == null)
            this.saldoUnd2 = 0.0;
        else
            this.saldoUnd2 = Double.parseDouble(soapObject.getProperty("saldoUnd2").toString());
    }



}
