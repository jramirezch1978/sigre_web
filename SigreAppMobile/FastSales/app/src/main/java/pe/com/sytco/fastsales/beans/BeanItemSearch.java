package pe.com.sytco.fastsales.beans;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.beans.Almacen.BeanAlmacen;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanOrdenVenta;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanZonaDespacho;
import pe.com.sytco.fastsales.beans.Comercializacion.BeanZonaVenta;
import pe.com.sytco.fastsales.beans.Compras.BeanArticuloClase;
import pe.com.sytco.fastsales.beans.Compras.BeanCategoria;
import pe.com.sytco.fastsales.beans.Compras.BeanColor;
import pe.com.sytco.fastsales.beans.Compras.BeanDirecciones;
import pe.com.sytco.fastsales.beans.Compras.BeanMarca;
import pe.com.sytco.fastsales.beans.Compras.BeanProveedor;
import pe.com.sytco.fastsales.beans.Compras.BeanSubCategoria;
import pe.com.sytco.fastsales.beans.Compras.BeanUnidad;
import pe.com.sytco.fastsales.beans.Finanzas.BeanDocTipo;
import pe.com.sytco.fastsales.beans.Finanzas.BeanFormaPago;
import pe.com.sytco.fastsales.beans.Finanzas.BeanMoneda;
import pe.com.sytco.fastsales.beans.ZC.BeanZCAcabado;
import pe.com.sytco.fastsales.beans.ZC.BeanZCLinea;
import pe.com.sytco.fastsales.beans.ZC.BeanZCSubLineas;
import pe.com.sytco.fastsales.beans.ZC.BeanZCSuela;
import pe.com.sytco.fastsales.beans.ZC.BeanZCTaco;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.UTIL;

public class BeanItemSearch implements Serializable {

    private String Cadena1;
    private String Cadena2;
    private String Cadena3;



    public String getCadena1() {
        return Cadena1;
    }
    public void setCadena1(String cadena1) {
        Cadena1 = cadena1;
    }
    public String getCadena2() {
        return Cadena2;
    }
    public void setCadena2(String cadena2) {
        Cadena2 = cadena2;
    }
    public String getCadena3() {
        return Cadena3;
    }
    public void setCadena3(String cadena3) {
        Cadena3 = cadena3;
    }

    public static List<BeanItemSearch> createListFromClientes(List<BeanProveedor> listadoClientes) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanProveedor obj : listadoClientes){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromAlmacenes(List<BeanAlmacen> listadoAlmacenes) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanAlmacen obj : listadoAlmacenes){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromFormasPago(List<BeanFormaPago> listaFormaPago) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanFormaPago obj : listaFormaPago){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromProveedor(List<BeanProveedor> listadoProveedor) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanProveedor obj : listadoProveedor){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromDocTipos(List<BeanDocTipo> listadoDocTipo) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanDocTipo obj : listadoDocTipo){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromMonedas(List<BeanMoneda> listadoMoneda) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanMoneda obj : listadoMoneda){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromDirecciones(List<BeanDirecciones> listaDirecciones) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanDirecciones obj : listaDirecciones){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromCategorias(List<BeanCategoria> listadoCategoria) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanCategoria obj : listadoCategoria){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromSubCategorias(List<BeanSubCategoria> listadoSubCategoria) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanSubCategoria obj : listadoSubCategoria){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromMarcas(List<BeanMarca> listadoMarcas) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanMarca obj : listadoMarcas){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromLineas(List<BeanZCLinea> listadoLineas) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanZCLinea obj : listadoLineas){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromSubLineas(List<BeanZCSubLineas> listadoSubLineas) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanZCSubLineas obj : listadoSubLineas){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromSuelas(List<BeanZCSuela> listadoSuela) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanZCSuela obj : listadoSuela){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromColores(List<BeanColor> listadoColor) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanColor obj : listadoColor){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromTacos(List<BeanZCTaco> listado) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanZCTaco obj : listado){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromUnidades(List<BeanUnidad> listado) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanUnidad obj : listado){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromClases(List<BeanArticuloClase> listado) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanArticuloClase obj : listado){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromAcabados(List<BeanZCAcabado> listado) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanZCAcabado obj : listado){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromOV(List<BeanOrdenVenta> listadoOV) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanOrdenVenta obj : listadoOV){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromAMP(List<BeanArticuloMovProy> listadoAMP) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanArticuloMovProy obj : listadoAMP){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromUbigeo(List<BeanUbigeo> listadoUbigeo) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanUbigeo obj : listadoUbigeo){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromZonaVenta(List<BeanZonaVenta> listaZonaVenta) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanZonaVenta obj : listaZonaVenta){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    public static List<BeanItemSearch> createListFromZonaDespacho(List<BeanZonaDespacho> listaZonaDespacho) throws Exception {
        List<BeanItemSearch> lista = new ArrayList<BeanItemSearch>();

        for(BeanZonaDespacho obj : listaZonaDespacho){
            lista.add(BeanItemSearch.instanceOf(obj));
        }

        return lista;
    }

    private static BeanItemSearch instanceOf(BeanAncestor obj) throws Exception {
        BeanItemSearch beanItemSearch = new BeanItemSearch();

        if (obj instanceof BeanAlmacen){
            BeanAlmacen almacen = (BeanAlmacen) obj;
            beanItemSearch.setCadena1(almacen.getAlmacen().trim() + " - " + almacen.getDescAlmacen());
        }else if(obj instanceof BeanFormaPago){
            BeanFormaPago formaPago = (BeanFormaPago) obj;
            beanItemSearch.setCadena1(formaPago.getFormaPago().trim() + " - " + formaPago.getDescFormaPago());
        }else if(obj instanceof BeanProveedor){
            BeanProveedor beanProveedor = (BeanProveedor) obj;
            beanItemSearch.setCadena1(beanProveedor.getProveedor().trim() + " - " + beanProveedor.getNomProveedor());
            beanItemSearch.setCadena2("RUC/DNI: " + beanProveedor.getRucDni());
        }else if(obj instanceof BeanDocTipo){
            BeanDocTipo beanDocTipo = (BeanDocTipo) obj;
            beanItemSearch.setCadena1(beanDocTipo.getTipoDoc().trim() + " - " + beanDocTipo.getDescTipoDoc());
        }else if(obj instanceof BeanMoneda){
            BeanMoneda beanMoneda = (BeanMoneda) obj;
            beanItemSearch.setCadena1(beanMoneda.getCodMoneda().trim() + " - " + beanMoneda.getDescMoneda());
        }else if(obj instanceof BeanDirecciones){
            BeanDirecciones beanDirecciones = (BeanDirecciones) obj;
            beanItemSearch.setCadena1(beanDirecciones.getFullDireccion());
        }else if(obj instanceof BeanCategoria){
            BeanCategoria beanCategoria = (BeanCategoria) obj;
            beanItemSearch.setCadena1(beanCategoria.getCatArt().trim() + " - " + beanCategoria.getDescCategoria().trim());
        }else if(obj instanceof BeanSubCategoria){
            BeanSubCategoria bean = (BeanSubCategoria) obj;
            beanItemSearch.setCadena1(bean.getCodSubCategoria().trim() + " - " + bean.getDescSubCategoria().trim());
        }else if(obj instanceof BeanMarca){
            BeanMarca bean = (BeanMarca) obj;
            beanItemSearch.setCadena1(bean.getCodMarca().trim() + " - " + bean.getNomMarca().trim());
        }else if(obj instanceof BeanZCLinea){
            BeanZCLinea bean = (BeanZCLinea) obj;
            beanItemSearch.setCadena1(bean.getCodLinea().trim() + " - " + bean.getDescLinea().trim());
        }else if(obj instanceof BeanZCSubLineas){
            BeanZCSubLineas bean = (BeanZCSubLineas) obj;
            beanItemSearch.setCadena1(bean.getCodSubLinea().trim() + " - " + bean.getDescSubLinea().trim());
        }else if(obj instanceof BeanZCSuela){
            BeanZCSuela bean = (BeanZCSuela) obj;
            beanItemSearch.setCadena1(bean.getCodSuela().trim() + " - " + bean.getDescSuela().trim());
        }else if(obj instanceof BeanColor){
            BeanColor bean = (BeanColor) obj;
            beanItemSearch.setCadena1(bean.getCodColor().trim() + " - " + bean.getDescColor().trim());
        }else if(obj instanceof BeanZCTaco){
            BeanZCTaco bean = (BeanZCTaco) obj;
            beanItemSearch.setCadena1(bean.getCodTaco().trim() + " - " + bean.getDescTaco().trim());
        }else if(obj instanceof BeanUnidad){
            BeanUnidad bean = (BeanUnidad) obj;
            beanItemSearch.setCadena1(bean.getUnd().trim() + " - " + bean.getDescUnidad().trim());
        }else if(obj instanceof BeanArticuloClase){
            BeanArticuloClase bean = (BeanArticuloClase) obj;
            beanItemSearch.setCadena1(bean.getCodClase().trim() + " - " + bean.getDescClase().trim());
        }else if(obj instanceof BeanZCAcabado){
            BeanZCAcabado bean = (BeanZCAcabado) obj;
            beanItemSearch.setCadena1(bean.getCodAcabado().trim() + " - " + bean.getDescAcabado().trim());
        }else if(obj instanceof BeanOrdenVenta){
            BeanOrdenVenta beanOrdenVenta = (BeanOrdenVenta) obj;
            beanItemSearch.setCadena1(beanOrdenVenta.getNroOrdenVenta().trim()+ " - " + beanOrdenVenta.getNomCliente().trim());
            //beanItemSearch.setCadena2("OBS: " + beanOrdenVenta.getObs().trim() );
        }else if(obj instanceof BeanArticuloMovProy){
            BeanArticuloMovProy beanAMP = (BeanArticuloMovProy) obj;
            beanItemSearch.setCadena1(beanAMP.getCodArticulo().trim() + " - " + beanAMP.getDescArticulo().trim());
            beanItemSearch.setCadena2("Cant Pendiente: " + UTIL.ConvetToString(beanAMP.getCantProyect() - beanAMP.getCantProcesada(), "###,##0.0000")
                                      + " " + beanAMP.getUnd()  );
        }else if(obj instanceof BeanUbigeo){
            BeanUbigeo beanUbigeo = (BeanUbigeo) obj;
            beanItemSearch.setCadena1(beanUbigeo.getUbigeo().trim()+ " - " + beanUbigeo.getDescUbigeo().trim());

        }else if(obj instanceof BeanZonaVenta){
            BeanZonaVenta bean = (BeanZonaVenta) obj;
            beanItemSearch.setCadena1(bean.getZonaVenta().trim()+ " - " + bean.getDescZonaVenta().trim());

        }else if(obj instanceof BeanZonaDespacho){
            BeanZonaDespacho bean = (BeanZonaDespacho) obj;
            beanItemSearch.setCadena1(bean.getZonaDespacho().trim()+ " - " + bean.getDescZonaDespacho().trim());

        }else if(obj instanceof BeanProveedor){
            BeanProveedor bean = (BeanProveedor) obj;
            beanItemSearch.setCadena1(bean.getNomProveedor().trim()+ " - " + bean.getTipoDocIdentidad().trim() + "-" + bean.getRucDni().trim());
            beanItemSearch.setCadena2(bean.getDireccion());
        }else
            throw new Exception("Tipo de Objeto no especificado para hacer la conversion a BeanItemSearch");

        return beanItemSearch;
    }


}
