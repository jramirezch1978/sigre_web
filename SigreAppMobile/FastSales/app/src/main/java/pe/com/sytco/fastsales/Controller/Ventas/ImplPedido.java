package pe.com.sytco.fastsales.Controller.Ventas;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;

import org.ksoap2.serialization.PropertyInfo;
import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.UI.ParteDespachoUI;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.BeanParametros;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanOrdenVenta;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProforma;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanProformaDet;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.Compras.BeanArticuloUnd;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngreso;
import pe.com.sytco.fastsales.beans.parametro;
import pe.com.sytco.fastsales.util.Parametros;
import pe.com.sytco.fastsales.util.UTIL;

/**
 * Created by jramirez on 05/05/2016.
 */
public class ImplPedido extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplPedido?wsdl";

    BeanProforma beanPedido = null;
    private ArrayList<BeanProformaDet> detalle;

    private ImplPedido(){

    }

    public ImplPedido(String empresa){
        beanPedido = new BeanProforma();
        this.empresaDefault = empresa;
    }

    public void ResetDetalle() {
        if (detalle == null){
            detalle = new ArrayList<BeanProformaDet>();
        }else{
            detalle.clear();
        }
    }

    public void newPedido() {
        beanPedido.ResetCabecera();
        beanPedido.setNuevo(true);
        this.ResetDetalle();
    }

    public void InsertDetail(BeanArticulo articulo,
                             BeanAlmacen almacen,
                             Double pCantidad,
                             BeanArticuloUnd und,
                             Double pPrecioVenta,
                             Double pPorcIGV,
                             Double pImporteIGV,
                             String pFlagBolsaPlastico,
                             Double pICBPER,
                             String pFlagAfectoIGV,
                             BeanUsuario pUserLogin) throws Exception {
        Integer liNroItem;
        boolean lbNew = true;
        Double ldcCantidad, ldcCantidadUnd2;


        if (beanPedido.getCodOrigen() == null || beanPedido.getCodOrigen().trim().equals("")){
            beanPedido.setCodOrigen(almacen.getCodOrigen());
        }

        if (beanPedido.getVendedor() == null || beanPedido.getVendedor().trim().equals("")){
            beanPedido.setVendedor(pUserLogin.getUsuario());
        }

        if (pFlagAfectoIGV == null || pFlagAfectoIGV.trim().equals("")){
            throw  new Exception("El Item que se desea insertar a la PROFORMA tiene FlagAfectoIGV igual a NULO o VACIO, por favor corrija"
                                + ". Articulo: " + articulo.getCodArt() + " - " + articulo.getDescArticulo());
        }

        if (pFlagAfectoIGV.trim().equals("1") && pImporteIGV == 0 && !articulo.getCodClase().trim().equals(ImplEmpresa.beanParametros.getClaseBonif().trim())){
            throw  new Exception("ERROR al insertar a la PROFORMA. "
                               + "El articulo " + articulo.getCodArt() + " - " + articulo.getDescArticulo() + " esta marcado como AFECTO A IGV "
                               + "sin embargo el importe el IGV que se ha ingresado es CERO, por favor corrija");
        }

        if (pFlagAfectoIGV.trim().equals("2") && pImporteIGV > 0){
            throw  new Exception("ERROR al insertar a la PROFORMA. "
                                + "El articulo " + articulo.getCodArt() + " - " + articulo.getDescArticulo() + " esta marcado como INAFECTO "
                                + "sin embargo el importe el IGV que se ha ingresado distinto a CERO, por favor corrija");
        }

        if (pFlagAfectoIGV.trim().equals("3") && pImporteIGV > 0){
            throw  new Exception("ERROR al insertar a la PROFORMA. "
                                + "El articulo " + articulo.getCodArt() + " - " + articulo.getDescArticulo() + " esta marcado como EXONERADO "
                                + "sin embargo el importe el IGV que se ha ingresado distinto a CERO, por favor corrija");
        }

        //Obtengo la Cantidad Und1
        if (und.getUnd().equals(articulo.getUnd())){
            ldcCantidad = pCantidad;
        }else{
            if(und.getFactorConvUnd() == 0){
                throw  new Exception("ERROR al insertar a la PROFORMA. "
                        + "El articulo " + articulo.getCodArt() + " - " + articulo.getDescArticulo() + " no tiene especificado el factor de " +
                        "conversion para la UNIDAD " + und.getUnd() + " , por favor corrija");
            }
            ldcCantidad = pCantidad / und.getFactorConvUnd();
        }

        //Obtengo la Cantidad Und2
        if (articulo.getFlagUnd2().equals("1")){
            if(articulo.getFactorConvUnd() == 0){
                throw  new Exception("ERROR al insertar a la PROFORMA. "
                        + "El articulo " + articulo.getCodArt() + " - " + articulo.getDescArticulo() + " no tiene especificado el factor de Und2, por favor corrija");
            }
            ldcCantidadUnd2 = ldcCantidad * articulo.getFactorConvUnd();
        }else{
            ldcCantidadUnd2 = 0.00;
        }

        //Verifico si ya existe
        for(BeanProformaDet row : detalle){

            if (row.getAlmacen().equals(almacen.getAlmacen()) && row.getCodArt().equals(articulo.getCodArt())) {

                if (UTIL.redondearDecimales(row.getPrecioVta(),4) != UTIL.redondearDecimales(pPrecioVenta,4)){
                    throw  new Exception("El precio del item es diferente al que esta guardado en el pedido, Precio Venta Pedido: "
                            + UTIL.ConvetToString(row.getPrecioVta(), "###,##0.00") + " - Precio Venta Item: " + UTIL.ConvetToString(pPrecioVenta, "###,##0.00"));
                }

                row.setCantidad(row.getCantidad() + ldcCantidad);
                row.setCantidadUnd2(row.getCantidadUnd2() + ldcCantidadUnd2);
                if (row.getUnd2() == null || row.getUnd2().trim().isEmpty()) {
                    row.setUnd2(articulo.getUnd2() != null ? articulo.getUnd2().trim() : "");
                }
                row.setPrecioVta(pPrecioVenta);
                row.setIgv(pImporteIGV);
                row.setPorcIGV(pPorcIGV);
                row.setFlagBolsaPlastico(pFlagBolsaPlastico);
                row.setICBPER(pICBPER);
                row.setFlagAfectoIGV(pFlagAfectoIGV);
                row.setFlagModificado("1");

                lbNew = false;
                break;

            }
        }

        if (lbNew) {
            liNroItem = this.getNroItem();

            //Adiciono al detalle del pedido
            BeanProformaDet bean = new BeanProformaDet(  liNroItem,
                                                    articulo,
                                                    almacen.getAlmacen(),
                                                    ldcCantidad,
                                                    ldcCantidadUnd2,
                                                    pPrecioVenta,
                                                    pPorcIGV,
                                                    pImporteIGV,
                                                    pFlagBolsaPlastico,
                                                    pICBPER,
                                                    pFlagAfectoIGV,
                                                    pUserLogin);
            bean.setFlagInsertado("1");
            detalle.add(bean);
        }

    }

    public Integer getNroItem() {

        Integer liNroItem = 1;

        //Recorro el dealle del pedido
        for(BeanProformaDet item : detalle){
            if (liNroItem <= item.getNroItem()){
                liNroItem = item.getNroItem() + 1;
            }
        }
        return liNroItem;
    }

    public ArrayList<BeanProformaDet> getDetalle() {
        return detalle;
    }

    public List<BeanProformaDet> getDetalleNoDelete() {
        List<BeanProformaDet> listaNoDelete = new ArrayList<BeanProformaDet>();
        for(BeanProformaDet obj : detalle){
            if (obj.getFlagEliminado().equals("0")){
                listaNoDelete.add(obj);
            }
        }

        return listaNoDelete;
    }


    public BeanProforma getCabecera() {
        return beanPedido;
    }

    public Double getImporteVenta() {
        Double dblImporteVenta = 0.0;

        for(BeanProformaDet row : detalle){
            if (row.getFlagEliminado().equals("0"))
                dblImporteVenta += row.getSubTotal();
        }

        return dblImporteVenta;
    }


    public void deleteDetail(BeanProformaDet value) {
        for(BeanProformaDet row : detalle){
            if(row.getNroItem() == value.getNroItem()){
                row.setFlagEliminado("1");
                return;
            }
        }
    }

    public String getNroPedido() {
        return this.beanPedido.getNroProforma();
    }

    public Double getTotalIGV() {
        Double ldblTotalIGV = 0.0;

        for(BeanProformaDet row : detalle){
            if (row.getFlagEliminado().equals("0"))
                ldblTotalIGV += row.getIgv() * row.getCantidad();
        }

        return ldblTotalIGV;
    }

    public Double getBaseImponible() {
        Double ldblBaseImponible = 0.0;

        for(BeanProformaDet row : detalle){
            if (row.getFlagEliminado().equals("0"))
                ldblBaseImponible += row.getPrecioVta() * row.getCantidad();
        }

        return ldblBaseImponible;
    }

    public Double getTotalVenta() {
        Double lbdlTotalVenta = 0.0;

        for(BeanProformaDet row : detalle){
            if (row.getFlagEliminado().equals("0"))
                lbdlTotalVenta += row.getSubTotal();
        }

        return lbdlTotalVenta;
    }

    public Double getTotalVenta(List<BeanProforma> listaProformas) {
        Double lbdlTotalVenta = 0.0;

        for(BeanProforma row : listaProformas){
            lbdlTotalVenta += row.getTotalVenta();
        }

        return lbdlTotalVenta;
    }

    public boolean Update() throws Exception {
        PropertyInfo pi;
        StrRespuesta strRespuesta = null;
        String pCabecera, pDetalle;

        try{

            //Convierto la cabecera y el Detalle en JSON
            //Gson gson = new GsonBuilder().setPrettyPrinting().setDateFormat("dd/MM/yyyy HH:mm:ss").create();
            Gson gson = new GsonBuilder().create();

            pCabecera = gson.toJson(beanPedido);
            pDetalle = gson.toJson(detalle);

            System.out.println("Cabecera: " + pCabecera);
            System.out.println("Detalle: " + pDetalle);

            strRespuesta = new StrRespuesta();
            String METHOD_NAME = "Update";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pCabecera", pCabecera));
            param.add(new parametro("pDetalle", pDetalle));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                this.getCabecera().setNroProforma(null);
                throw new Exception(strRespuesta.getMensaje());
            }

            this.getCabecera().setNroProforma(strRespuesta.getCadena());

            return true;

        }catch(Exception ex){
            ex.printStackTrace();
            throw ex;
        }

    }

    public List<BeanProforma> getProformasByVendedor(String pVendedor) throws Exception {
        List<BeanProforma> lista = null;

        try {
            String METHOD_NAME = "getProformasByVendedor";
            lista = new ArrayList<BeanProforma>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pVendedor", pVendedor));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanProforma bean = new BeanProforma();
                    bean.populate(soapObject);

                    if (!bean.getIsOk())
                        throw new Exception(bean.getMensaje());

                    lista.add(bean);
                }

            }

            return lista;

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            lista = null;
        }

    }

    public List<BeanProforma> getProformasByVendedorAndFecha(String pVendedor, String pFechaProforma) throws Exception {
        List<BeanProforma> lista = null;

        try {
            String METHOD_NAME = "getProformasByVendedorAndFecha";
            lista = new ArrayList<BeanProforma>();

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pVendedor", pVendedor));
            param.add(new parametro("pFechaProforma", pFechaProforma));

            List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);

            if (lsObjects != null) {
                //Si hay una lista para hacer la conversion
                int length = lsObjects.size();

                for (int i = 0; i < length; i++) {
                    ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
                    BeanProforma bean = new BeanProforma();
                    bean.populate(soapObject);

                    if (!bean.getIsOk())
                        throw new Exception(bean.getMensaje());

                    lista.add(bean);
                }

            }

            return lista;

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            lista = null;
        }

    }


    public boolean anularProforma(String pNroProforma) throws Exception {

        StrRespuesta strRespuesta = null;
        List<parametro> param = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "anularProforma";

            param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroProforma", pNroProforma));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                throw new Exception(strRespuesta.getMensaje());
            }

            return strRespuesta.getIsOk();

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            strRespuesta = null;
            param = null;
        }

    }


    public boolean searchPedido(String pNroProforma) throws Exception {
        StrRespuesta strRespuesta = null;
        List<parametro> param = null;
        Gson gson = new Gson();

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "searchPedido";

            param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pNroProforma", pNroProforma));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                throw new Exception(strRespuesta.getMensaje());
            }

            //System.out.println(strRespuesta.getJSON1());
            //System.out.println(strRespuesta.getJSON2());

            //CAbecera
            beanPedido = gson.fromJson(strRespuesta.getJSON1(), BeanProforma.class);

            //Detalle
            detalle = gson.fromJson(strRespuesta.getJSON2(), new TypeToken<List<BeanProformaDet>>(){}.getType());

            return true;

        }catch (Exception e) {
            e.printStackTrace();
            throw e;
        }finally{
            strRespuesta = null;
            param = null;
            gson = null;
        }
    }


}