package pe.com.sytco.fastsales.beans.ParteIngreso;

import android.util.Log;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ParteEmpaque.BeanParteEmpaqueUnd;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.UTIL;

public class BeanParteIngreso extends BeanAncestor implements Serializable, KvmSerializable {

    /**
     *
     */
    private static final long serialVersionUID = 8490222513227703382L;
    private String nroParte;
    private String proveedor;
    private String tipoDoc;
    private String serie;
    private String numero;
    private String nroDoc;
    private String codUsuario;
    private String codOrigen;
    private String descOrigen;
    private String flagEstado;
    private String fecRegistro;
    private String fecParte;
    private String nomProveedor;
    private String rucDni;
    private Double cantidad;
    private Double valorCompra;
    private Double valorVenta;
    private Double importe;

    private String codMoneda, observacion, formaPago, almacen, nomReceptor, descAlmacen, nroVale, direccionCliente, descFormaPago, nroOC;
    private String descMoneda;
    private Integer itemDireccion;
    private List<BeanParteIngresoDet> detalle = null;
    private List<BeanParteEmpaqueUnd> listadoCU = null;

    public String getNroParte() {
        return nroParte;
    }
    public void setNroParte(String nroParte) {
        this.nroParte = nroParte;
    }
    public String getProveedor() {
        return proveedor;
    }
    public void setProveedor(String proveedor) {
        this.proveedor = proveedor;
    }
    public String getTipoDoc() {
        return tipoDoc;
    }
    public void setTipoDoc(String tipoDoc) {
        this.tipoDoc = tipoDoc;
    }
    public String getSerie() {
        return serie;
    }
    public void setSerie(String serie) {
        this.serie = serie;
    }
    public String getNumero() {
        return numero;
    }
    public void setNumero(String numero) {
        this.numero = numero;
    }
    public String getNroDoc() {
        return nroDoc;
    }
    public void setNroDoc(String nroDoc) {
        this.nroDoc = nroDoc;
    }
    public String getCodUsuario() {
        return codUsuario;
    }
    public void setCodUsuario(String codUsuario) {
        this.codUsuario = codUsuario;
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
    public String getFecRegistro() {
        return fecRegistro;
    }
    public void setFecRegistro(String value) {
        this.fecRegistro = value;
    }
    public String getFecParte() {
        return fecParte;
    }
    public Date getDateFecParte() {
        return UTIL.parseStringToSqlDate(fecParte);
    }
    public void setFecParte(String value) {
        this.fecParte = value;
    }
    public String getNomProveedor() {
        return nomProveedor;
    }
    public void setNomProveedor(String nomProveedor) {
        this.nomProveedor = nomProveedor;
    }
    public String getRucDni() {
        return rucDni;
    }
    public void setRucDni(String rucDni) {
        this.rucDni = rucDni;
    }
    public Double getCantidad() {
        return cantidad;
    }
    public void setCantidad(Double cantidad) {
        this.cantidad = cantidad;
    }
    public Double getValorCompra() {
        return valorCompra;
    }
    public void setValorCompra(Double valorCompra) {
        this.valorCompra = valorCompra;
    }
    public Double getValorVenta() {
        return valorVenta;
    }
    public void setValorVenta(Double valorVenta) {
        this.valorVenta = valorVenta;
    }
    public String getCodMoneda() {
        return codMoneda;
    }
    public void setCodMoneda(String codMoneda) {
        this.codMoneda = codMoneda;
    }
    public String getObservacion() {
        return observacion;
    }
    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }
    public String getFormaPago() {
        return formaPago;
    }
    public void setFormaPago(String formaPago) {
        this.formaPago = formaPago;
    }
    public String getAlmacen() {
        return almacen;
    }
    public void setAlmacen(String almacen) {
        this.almacen = almacen;
    }
    public String getNomReceptor() {
        return nomReceptor;
    }
    public void setNomReceptor(String nomReceptor) {
        this.nomReceptor = nomReceptor;
    }
    public String getDescAlmacen() {
        return descAlmacen;
    }
    public void setDescAlmacen(String descAlmacen) {
        this.descAlmacen = descAlmacen;
    }
    public String getNroVale() {
        return nroVale;
    }
    public void setNroVale(String nroVale) {
        this.nroVale = nroVale;
    }
    public String getDireccionCliente() {
        return direccionCliente;
    }
    public void setDireccionCliente(String direccionCliente) {
        this.direccionCliente = direccionCliente;
    }
    public String getDescFormaPago() {
        return descFormaPago;
    }
    public void setDescFormaPago(String descFormaPago) {
        this.descFormaPago = descFormaPago;
    }
    public String getNroOC() {
        return nroOC;
    }
    public void setNroOC(String nroOC) {
        this.nroOC = nroOC;
    }
    public Integer getItemDireccion() {
        return itemDireccion;
    }
    public void setItemDireccion(Integer itemDireccion) {
        this.itemDireccion = itemDireccion;
    }
    public String getDescOrigen() {
        return descOrigen;
    }
    public void setDescOrigen(String descOrigen) {
        this.descOrigen = descOrigen;
    }
    public String getDescMoneda() {
        return descMoneda;
    }
    public void setDescMoneda(String descMoneda) {
        this.descMoneda = descMoneda;
    }
    public Double getImporte() {
        return importe;
    }
    public void setImporte(Double importe) {
        this.importe = importe;
    }

    public List<BeanParteIngresoDet> getDetalle() {
        return detalle;
    }
    public void setDetalle(List<BeanParteIngresoDet> detalle) {
        this.detalle = detalle;
    }

    public List<BeanParteEmpaqueUnd> getListadoCU() {
        return listadoCU;
    }
    public void setListadoCU(List<BeanParteEmpaqueUnd> listadoCU) {
        this.listadoCU = listadoCU;
    }

    public BeanParteIngreso(){
        this.flagEstado = "1";
        this.descAlmacen = "";
        this.direccionCliente = "";

        detalle = new ArrayList<BeanParteIngresoDet>();
        listadoCU = new ArrayList<BeanParteEmpaqueUnd>();
    }

    @Override
    public Object getProperty(int i) {
        /*
            private String nroParte;
            private String proveedor;
            private String tipoDoc;
            private String serie;
            private String numero;
            private String nroDoc;
            private String codUsuario;
            private String codOrigen;
            private String flagEstado;
            private Date fecRegistro;
            private Date fecParte;
            private String nomProveedor;
            private String rucDni;
            private Double cantidad;
            private Double valorCompra;
            private Double valorVenta;
         */
        switch(i)  {

            case 0: return nroParte;
            case 1: return proveedor;
            case 2: return tipoDoc;
            case 3: return serie;
            case 4: return numero;
            case 5: return nroDoc;
            case 6: return codUsuario;
            case 7: return codOrigen;
            case 8: return flagEstado;
            case 9: return fecRegistro;
            case 10: return fecParte;
            case 11: return nomProveedor;
            case 12: return rucDni;
            case 13: return cantidad;
            case 14: return valorCompra;
            case 15: return valorVenta;

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
            private String nroParte;
            private String proveedor;
            private String tipoDoc;
            private String serie;
            private String numero;
            private String nroDoc;
            private String codUsuario;
            private String codOrigen;
            private String flagEstado;
            private Date fecRegistro;
            private Date fecParte;
            private String nomProveedor;
            private String rucDni;
            private Double cantidad;
            private Double valorCompra;
            private Double valorVenta;
         */
        switch(i) {
            case 0:
                nroParte = value.toString();
                break;
            case 1:
                proveedor = value.toString();
                break;
            case 2:
                tipoDoc = value.toString();
                break;
            case 3:
                serie = value.toString();
                break;
            case 4:
                numero = value.toString();
                break;
            case 5:
                nroDoc = value.toString();
                break;
            case 6:
                codUsuario = value.toString();
                break;
            case 7:
                codOrigen = value.toString();
                break;
            case 8:
                flagEstado = value.toString();
                break;
            case 9:
                Log.d("BeanParteIngreso ", "fecRegistro");
                fecRegistro = value.toString();
                break;
            case 10:
                Log.d("BeanParteIngreso ", "fecParte");
                fecParte = value.toString();
                break;
            case 11:
                nomProveedor = value.toString();
                break;
            case 12:
                rucDni = value.toString();
                break;
            case 13:
                Log.d("BeanParteIngreso: ", "cantidad");
                cantidad = (Double) value;
                break;
            case 14:
                Log.d("BeanParteIngreso: ", "valorCompra");
                valorCompra = (Double) value;
                break;
            case 15:
                Log.d("BeanParteIngreso: ", "valorVenta");
                valorVenta = (Double) value;
                break;
        }

    }

    @Override
    public void getPropertyInfo(int __index, Hashtable __table, PropertyInfo __info) {
        /*
            private String nroParte;
            private String proveedor;
            private String tipoDoc;
            private String serie;
            private String numero;
            private String nroDoc;
            private String codUsuario;
            private String codOrigen;
            private String flagEstado;
            private Date fecRegistro;
            private Date fecParte;
            private String nomProveedor;
            private String rucDni;
            private Double cantidad;
            private Double valorCompra;
            private Double valorVenta;
         */
        switch(__index) {
            case 0:
                __info.name = "nroParte";
                __info.type = String.class;
                break;
            case 1:
                __info.name = "proveedor";
                __info.type = String.class;
                break;
            case 2:
                __info.name = "tipoDoc";
                __info.type = String.class;
                break;
            case 3:
                __info.name = "serie";
                __info.type = String.class;
                break;
            case 4:
                __info.name = "numero";
                __info.type = String.class;
                break;
            case 5:
                __info.name = "nroDoc";
                __info.type = String.class;
                break;
            case 6:
                __info.name = "codUsuario";
                __info.type = String.class;
                break;
            case 7:
                __info.name = "codOrigen";
                __info.type = String.class;
                break;
            case 8:
                __info.name = "flagEstado";
                __info.type = String.class;
                break;
            case 9:
                Log.d("BeanParteRecepcion: ", "fecRegistro 10");
                __info.name = "fecRegistro";
                __info.type = String.class;
                break;
            case 10:
                Log.d("BeanParteRecepcion: ", "fecParte 11");
                __info.name = "fecParte";
                __info.type = String.class;
                break;
            case 11:
                __info.name = "nomProveedor";
                __info.type = String.class;
                break;
            case 12:
                __info.name = "rucDni";
                __info.type = String.class;
                break;
            case 13:
                Log.d("BeanParteRecepcion: ", "cantidad 11");
                __info.name = "cantidad";
                __info.type = Double.class;
                break;
            case 14:
                Log.d("BeanParteRecepcion: ", "valorCompra 10");
                __info.name = "valorCompra";
                __info.type = Double.class;
                break;
            case 15:
                Log.d("BeanParteRecepcion: ", "valorVenta 11");
                __info.name = "valorVenta";
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

    public void populate(ExtendedSoapObject soapObject) throws Exception {
        /*
            private String nroParte;
            private String proveedor;
            private String tipoDoc;
            private String serie;
            private String numero;
            private String nroDoc;
            private String codUsuario;
            private String codOrigen;
            private String flagEstado;
            private Date fecRegistro;
            private Date fecParte;
            private String nomProveedor;
            private String rucDni;
            private Double cantidad;
            private Double valorCompra;
            private Double valorVenta;
         */

        super.populate(soapObject);

        if (soapObject.getProperty("nroParte") != null)
            this.nroParte = soapObject.getProperty("nroParte").toString();
        else
            this.nroParte = null;

        if (soapObject.getProperty("proveedor") != null)
            this.proveedor = soapObject.getProperty("proveedor").toString();
        else
            this.proveedor = null;

        if (soapObject.getProperty("tipoDoc") != null)
            this.tipoDoc = soapObject.getProperty("tipoDoc").toString();
        else
            this.tipoDoc = null;

        if (soapObject.getProperty("serie") != null)
            this.serie = soapObject.getProperty("serie").toString();
        else
            this.serie = null;

        if (soapObject.getProperty("numero") != null)
            this.numero = soapObject.getProperty("numero").toString();
        else
            this.numero = null;

        if (soapObject.getProperty("nroDoc") != null)
            this.nroDoc = soapObject.getProperty("nroDoc").toString();
        else
            this.nroDoc = null;

        if (soapObject.getProperty("codUsuario") != null)
            this.codUsuario = soapObject.getProperty("codUsuario").toString();
        else
            this.codUsuario = null;

        if (soapObject.getProperty("codOrigen") != null)
            this.codOrigen = soapObject.getProperty("codOrigen").toString();
        else
            this.codOrigen = null;

        if (soapObject.getProperty("flagEstado") != null)
            this.flagEstado = soapObject.getProperty("flagEstado").toString();
        else
            this.flagEstado = null;

        if (soapObject.getProperty("nomProveedor") != null)
            this.nomProveedor = soapObject.getProperty("nomProveedor").toString();
        else
            this.nomProveedor = null;

        if (soapObject.getProperty("rucDni") != null)
            this.rucDni = soapObject.getProperty("rucDni").toString();
        else
            this.rucDni = null;

        if (soapObject.getProperty("fecRegistro") != null)
            this.fecRegistro = soapObject.getProperty("fecRegistro").toString();
        else
            this.fecRegistro = null;

        if (soapObject.getProperty("fecParte") != null)
            this.fecParte = soapObject.getProperty("fecParte").toString();
        else
            this.fecParte = null;

        if (soapObject.getProperty("cantidad") == null)
            this.cantidad = 0.0;
        else
            this.cantidad = Double.parseDouble(soapObject.getProperty("cantidad").toString());

        if (soapObject.getProperty("valorCompra") == null)
            this.valorCompra = 0.0;
        else
            this.valorCompra = Double.parseDouble(soapObject.getProperty("valorCompra").toString());

        if (soapObject.getProperty("valorVenta") == null)
            this.valorVenta = 0.0;
        else
            this.valorVenta = Double.parseDouble(soapObject.getProperty("valorVenta").toString());

        if (soapObject.getProperty("codMoneda") != null)
            this.codMoneda = soapObject.getProperty("codMoneda").toString();
        else
            this.codMoneda = null;

        if (soapObject.getProperty("observacion") != null)
            this.observacion = soapObject.getProperty("observacion").toString();
        else
            this.observacion = null;

        if (soapObject.getProperty("formaPago") != null)
            this.formaPago = soapObject.getProperty("formaPago").toString();
        else
            this.formaPago = null;

        if (soapObject.getProperty("almacen") != null)
            this.almacen = soapObject.getProperty("almacen").toString();
        else
            this.almacen = null;

        if (soapObject.getProperty("nomReceptor") != null)
            this.nomReceptor = soapObject.getProperty("nomReceptor").toString();
        else
            this.nomReceptor = null;

        if (soapObject.getProperty("descAlmacen") != null)
            this.descAlmacen = soapObject.getProperty("descAlmacen").toString();
        else
            this.descAlmacen = null;

        if (soapObject.getProperty("nroVale") != null)
            this.nroVale = soapObject.getProperty("nroVale").toString();
        else
            this.nroVale = null;

        if (soapObject.getProperty("direccionCliente") != null)
            this.direccionCliente = soapObject.getProperty("direccionCliente").toString();
        else
            this.direccionCliente = null;

        if (soapObject.getProperty("descFormaPago") != null)
            this.descFormaPago = soapObject.getProperty("descFormaPago").toString();
        else
            this.descFormaPago = null;

        if (soapObject.getProperty("nroOC") != null)
            this.nroOC = soapObject.getProperty("nroOC").toString();
        else
            this.nroOC = null;

        if (soapObject.getProperty("itemDireccion") == null)
            this.itemDireccion = 0;
        else
            this.itemDireccion = Integer.parseInt(soapObject.getProperty("itemDireccion").toString());

    }

    public String getDescEstado() {
        String lsReturn = "";

        if (this.flagEstado.equals("1")){
            lsReturn = "ACTIVO";
        }else if (this.flagEstado.equals("0")){
            lsReturn = "ANULADO";
        }

        return lsReturn;
    }

    public void setNew(boolean value) {
    }
}
