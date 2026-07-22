package pe.com.sytco.fastsales.beans.Comercializacion;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.util.Hashtable;

import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;

/**
 * Created by jramirez on 05/05/2016.
 */
public class BeanProformaDet implements Serializable, KvmSerializable {

    private String nroProforma;
    private Integer nroItem;
    private String codArt, und, und2;
    private String almacen;
    private Double cantidad;
    private Double cantidadUnd2;
    private Double precioVta;
    private Double igv;
    private Double porcIGV;
    private String codUsuario;
    private String flagAutorizado;
    private Double precioVentaAnt;
    private String descripcion;
    private String flagBolsaPlastico;
    private Double ICBPER;

    private String flagAfectoIGV;

    //Otros flags
    private String flagEliminado, flagInsertado, flagModificado;
    private boolean selected = false;

    public BeanProformaDet(){
        //java.util.Date utilDate = new java.util.Date();
        //this.fecRegistro = new java.sql.Date(utilDate.getTime());
        flagEliminado = "0";
        flagModificado = "0";
        flagInsertado = "0";
    }

    public BeanProformaDet(Integer pNroItem,
                           BeanArticulo pArticulo,
                           String pAlmacen,
                           Double pCantidad,
                           Double pCantidadUnd2,
                           Double pPrecioVenta, Double pPorcIGV,
                           Double pImporteIGV,
                           String flagBolsaPlastico,
                           Double ICBPER,
                           String pFlagAfectoIGV,
                           BeanUsuario userLogin) {

        this.setNroItem(pNroItem);
        this.setCantidad(pCantidad);
        this.setCantidadUnd2(pCantidadUnd2);
        this.setPrecioVta(pPrecioVenta);
        this.setPorcIGV(pPorcIGV);
        this.setIgv(pImporteIGV);
        this.setPrecioVentaAnt(pPrecioVenta);
        this.setFlagAutorizado("0");
        this.setCodUsuario(userLogin.getUsuario());
        this.setDescripcion(pArticulo.getDescFullArticulo());
        this.setFlagBolsaPlastico(flagBolsaPlastico);
        this.setICBPER(ICBPER);
        this.setFlagAfectoIGV(pFlagAfectoIGV);

        this.setCodArt(pArticulo.getCodArt());
        this.setDescripcion(pArticulo.getDescFullArticulo());
        this.setUnd(pArticulo.getUnd());
        this.setUnd2(pArticulo.getUnd2() != null ? pArticulo.getUnd2().trim() : "");
        this.setAlmacen(pAlmacen);

        this.flagEliminado = "0";
        this.flagModificado = "0";
        this.flagInsertado = "0";


    }

    public Integer getNroItem() {
        return nroItem;
    }
    public void setNroItem(Integer value) {
        this.nroItem = value;
    }
    public Double getCantidad() {
        return cantidad;
    }
    public void setCantidad(Double value) {
        this.cantidad = value;
    }
    public Double getPorcIGV() {
        return porcIGV;
    }
    public void setPorcIGV(Double value) {
        this.porcIGV = value;
    }
    public String getFlagAutorizado() {
        return flagAutorizado;
    }
    public void setFlagAutorizado(String value) {
        this.flagAutorizado = value;
    }
    public Double getPrecioVentaAnt() {
        return precioVentaAnt;
    }
    public void setPrecioVentaAnt(Double value) {
        this.precioVentaAnt = value;
    }
    public String getNroProforma() {
        return nroProforma;
    }
    public void setNroProforma(String value) {
        this.nroProforma = value;
    }
    public String getCodArt() {
        return codArt;
    }
    public void setCodArt(String value) {
        this.codArt = value;
    }
    public void setAlmacen(String value) {
        this.almacen = value;
    }
    public Double getPrecioVta() {
        return precioVta;
    }
    public void setPrecioVta(Double value) {
        this.precioVta = value;
    }
    public Double getIgv() {
        return igv;
    }
    public void setIgv(Double value) {
        this.igv = value;
    }
    public String getCodUsuario() {
        return codUsuario;
    }
    public void setCodUsuario(String value) {
        this.codUsuario = value;
    }
    public String getDescripcion() {
        return descripcion;
    }
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }
    public String getFlagAfectoIGV() {
        return flagAfectoIGV;
    }
    public void setFlagAfectoIGV(String flagAfectoIGV) {
        this.flagAfectoIGV = flagAfectoIGV;
    }
    public String getAlmacen() {
        return almacen;
    }
    public String getFlagBolsaPlastico() {
        return flagBolsaPlastico;
    }
    public void setFlagBolsaPlastico(String flagBolsaPlastico) {
        this.flagBolsaPlastico = flagBolsaPlastico;
    }
    public Double getICBPER() {
        return ICBPER;
    }
    public void setICBPER(Double ICBPER) {
        this.ICBPER = ICBPER;
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
    public String getFlagEliminado() {
        return flagEliminado;
    }
    public void setFlagEliminado(String flagEliminado) {
        this.flagEliminado = flagEliminado;
    }
    public String getFlagInsertado() {
        return flagInsertado;
    }
    public void setFlagInsertado(String flagInsertado) {
        this.flagInsertado = flagInsertado;
    }
    public String getFlagModificado() {
        return flagModificado;
    }

    public void setFlagModificado(String value) {
        this.flagModificado = value;
    }
    public boolean isSelected() {
        return selected;
    }
    public void setSelected(boolean selected) {
        this.selected = selected;
    }

    @Override
    public Object getProperty(int i) {
        /*
            private String nroProforma;
            private Integer nroItem;
            private String codArt;
            private String almacen;
            private Double cantidad;
            private Double precioVta;
            private Double igv;
            private Double porcIGV;
            private String codUsuario;
            private String flagAutorizado;
            private Double precioVentaAnt;
            private String descripcion;
            private String flagBolsaPlastico;
            private Double ICBPER;
            private String flagAfectoIGV
        */
        switch(i)  {

            case 0: return nroProforma;
            case 1: return nroItem;
            case 2: return codArt;
            case 3: return almacen;
            case 4: return cantidad;
            case 5: return precioVta;
            case 6: return igv;
            case 7: return porcIGV;
            case 8: return codUsuario;
            case 9: return flagAutorizado;
            case 10: return precioVentaAnt;
            case 11: return descripcion;
            case 12: return flagBolsaPlastico;
            case 13: return ICBPER;
            case 14: return flagAfectoIGV;
            case 15: return cantidadUnd2;
        }
        return null;

    }

    @Override
    public int getPropertyCount() {
        return 16;
    }

    @Override
    public void setProperty(int i, Object value) {
        /*
            private String nroProforma;
            private Integer nroItem;
            private String codArt;
            private String almacen;
            private Double cantidad;
            private Double precioVta;
            private Double igv;
            private Double porcIGV;
            private String codUsuario;
            private String flagAutorizado;
            private Double precioVentaAnt;
            private String descripcion;
            private String flagBolsaPlastico;
            private Double ICBPER;
        */
        switch(i) {
            case 0:
                nroProforma = value.toString();
                break;
            case 1:
                nroItem = Integer.parseInt(value.toString());
                break;
            case 2:
                codArt = value.toString();
                break;
            case 3:
                almacen = value.toString();
                break;
            case 4:
                cantidad = Double.parseDouble(value.toString());
                break;
            case 5:
                precioVta = Double.parseDouble(value.toString());
                break;
            case 6:
                igv = Double.parseDouble(value.toString());
                break;
            case 7:
                porcIGV = Double.parseDouble(value.toString());
                break;
            case 8:
                codUsuario = value.toString();
                break;
            case 9:
                flagAutorizado = value.toString();
                break;
            case 10:
                precioVentaAnt = Double.parseDouble(value.toString());
                break;
            case 11:
                descripcion = value.toString();
                break;
            case 12:
                flagBolsaPlastico = value.toString();;
                break;
            case 13:
                ICBPER = Double.parseDouble(value.toString());
                break;
            case 14:
                flagAfectoIGV = value.toString();;
                break;
            case 15:
                cantidadUnd2 = Double.parseDouble(value.toString());
                break;
        }

    }

    @Override
    public void getPropertyInfo(int __index, Hashtable __table, PropertyInfo __info) {
        /*
            private String nroProforma;
            private Integer nroItem;
            private String codArt;
            private String almacen;
            private Double cantidad;
            private Double precioVta;
            private Double igv;
            private Double porcIGV;
            private String codUsuario;
            private String flagAutorizado;
            private Double precioVentaAnt;
            private String descripcion;
            private String flagBolsaPlastico;
            private Double ICBPER;
            private String flagAfectoIGV;
            private Double cantidadUnd2;
        */
        switch(__index) {
            case 0:
                __info.name = "nroProforma";
                __info.type = String.class;
                break;
            case 1:
                __info.name = "nroItem";
                __info.type = Integer.class;
                break;
            case 2:
                __info.name = "codArt";
                __info.type = String.class;
                break;
            case 3:
                __info.name = "almacen";
                __info.type = String.class;
                break;
            case 4:
                __info.name = "cantidad";
                __info.type = Double.class;
                break;
            case 5:
                __info.name = "precioVta";
                __info.type = Double.class;
                break;
            case 6:
                __info.name = "igv";
                __info.type = Double.class;
                break;
            case 7:
                __info.name = "porcIGV";
                __info.type = Double.class;
                break;
            case 8:
                __info.name = "codUsuario";
                __info.type = String.class;
                break;
            case 9:
                __info.name = "flagAutorizado";
                __info.type = String.class;
                break;
            case 10:
                __info.name = "precioVentaAnt";
                __info.type = Double.class;
                break;
            case 11:
                __info.name = "descripcion";
                __info.type = String.class;
                break;
            case 12:
                __info.name = "flagBolsaPlastico";
                __info.type = String.class;
                break;
            case 13:
                __info.name = "ICBPER";
                __info.type = Double.class;
                break;
            case 14:
                __info.name = "flagAfectoIGV";
                __info.type = String.class;
                break;
            case 15:
                __info.name = "cantidadUnd2";
                __info.type = Double.class;
                break;
        }

    }

    @Override
    public String getInnerText() {
        return null;
    }

    @Override
    public void setInnerText(String s) {

    }

    public void changePrecio(Double ldblPrecio,
                             Double ldblPorcIGV,
                             String flagAfectoIGV) {

        Double ldblImporteIGV, ldblBaseImponible;

        if (!flagAfectoIGV.equals("1")){
            ldblPorcIGV = 0.0;
        }
        //El precio unitario ya incluye el IGV
        ldblBaseImponible = ldblPrecio / (1 + ldblPorcIGV / 100);
        ldblImporteIGV = ldblPrecio - ldblBaseImponible;


        this.precioVentaAnt = this.precioVta;
        this.flagAutorizado = "1";
        this.precioVta = ldblBaseImponible;
        this.porcIGV = ldblPorcIGV;
        this.igv = ldblImporteIGV;
        this.flagModificado = "1";


    }

    public Double getCantidadUnd2() {
        if (cantidadUnd2 == null){
            return 0.00;
        }else{
            return cantidadUnd2;
        }

    }

    public void setCantidadUnd2(Double value) {
        this.cantidadUnd2 = value;
    }

    public Double getSubTotal() {
        return (this.getPrecioVta() + this.getIgv()) * this.getCantidad() + this.getICBPER();
    }
}
