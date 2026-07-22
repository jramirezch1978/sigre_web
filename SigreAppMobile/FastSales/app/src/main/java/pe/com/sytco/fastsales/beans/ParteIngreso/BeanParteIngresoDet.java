package pe.com.sytco.fastsales.beans.ParteIngreso;

import org.ksoap2.serialization.KvmSerializable;
import org.ksoap2.serialization.PropertyInfo;

import java.io.Serializable;
import java.util.Hashtable;
import java.util.List;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanParteIngresoDet extends BeanAncestor implements Serializable, KvmSerializable {
    private String nroParte;
    private Long nroItem;
    private String subCategoria;
    private String subLinea;
    private String estilo;
    private String acabado;
    private String suela;
    private String colorPrimario;
    private String colorSecundario;
    private String taco;
    private String marca;
    private String clase;
    private String flagEstado;


    private String fecRegistro;

    private String usuario;
    private String unidad;



    private byte[] fotoBlob;

    private String 	und, descSubCategoria, catArticulo, descCategoria, codLinea, descLinea, descSubLinea, descAcabado, descSuela, descColorPrimario,
            descColorSecundario, descTaco, nomMarca, descClase, fileImagen;

    //Listado de unidades por Talla
    private List<BeanParteIngresoUnd> unidades;

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
    public String getSubCategoria() {
        return subCategoria;
    }
    public void setSubCategoria(String subCategoria) {
        this.subCategoria = subCategoria;
    }
    public String getSubLinea() {
        return subLinea;
    }
    public void setSubLinea(String subLinea) {
        this.subLinea = subLinea;
    }
    public String getEstilo() {
        return estilo;
    }
    public void setEstilo(String estilo) {
        this.estilo = estilo;
    }
    public String getAcabado() {
        return acabado;
    }
    public void setAcabado(String acabado) {
        this.acabado = acabado;
    }
    public String getSuela() {
        return suela;
    }
    public void setSuela(String suela) {
        this.suela = suela;
    }
    public String getColorPrimario() {
        return colorPrimario;
    }
    public void setColorPrimario(String colorPrimario) {
        this.colorPrimario = colorPrimario;
    }
    public String getColorSecundario() {
        return colorSecundario;
    }
    public void setColorSecundario(String colorSecundario) {
        this.colorSecundario = colorSecundario;
    }
    public String getTaco() {
        return taco;
    }
    public void setTaco(String taco) {
        this.taco = taco;
    }
    public String getMarca() {
        return marca;
    }
    public void setMarca(String marca) {
        this.marca = marca;
    }
    public String getClase() {
        return clase;
    }
    public void setClase(String clase) {
        this.clase = clase;
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
    public String getUsuario() {
        return usuario;
    }
    public void setUsuario(String usuario) {
        this.usuario = usuario;
    }
    public String getUnidad() {
        return unidad;
    }
    public void setUnidad(String unidad) {
        this.unidad = unidad;
    }
    public byte[] getFotoBlob() {
        return fotoBlob;
    }
    public void setFotoBlob(byte[] fotoBlob) {
        this.fotoBlob = fotoBlob;
    }
    public String getUnd() {
        return und;
    }
    public void setUnd(String und) {
        this.und = und;
    }
    public String getDescSubCategoria() {
        return descSubCategoria;
    }
    public void setDescSubCategoria(String descSubCategoria) {
        this.descSubCategoria = descSubCategoria;
    }
    public String getCatArticulo() {
        return catArticulo;
    }
    public void setCatArticulo(String catArticulo) {
        this.catArticulo = catArticulo;
    }
    public String getDescCategoria() {
        return descCategoria;
    }
    public void setDescCategoria(String descCategoria) {
        this.descCategoria = descCategoria;
    }
    public String getCodLinea() {
        return codLinea;
    }
    public void setCodLinea(String codLinea) {
        this.codLinea = codLinea;
    }
    public String getDescLinea() {
        return descLinea;
    }
    public void setDescLinea(String descLinea) {
        this.descLinea = descLinea;
    }
    public String getDescSubLinea() {
        return descSubLinea;
    }
    public void setDescSubLinea(String descSubLinea) {
        this.descSubLinea = descSubLinea;
    }
    public String getDescAcabado() {
        return descAcabado;
    }
    public void setDescAcabado(String descAcabado) {
        this.descAcabado = descAcabado;
    }
    public String getDescSuela() {
        return descSuela;
    }
    public void setDescSuela(String descSuela) {
        this.descSuela = descSuela;
    }
    public String getDescColorPrimario() {
        return descColorPrimario;
    }
    public void setDescColorPrimario(String descColorPrimario) {
        this.descColorPrimario = descColorPrimario;
    }
    public String getDescColorSecundario() {
        return descColorSecundario;
    }
    public void setDescColorSecundario(String descColorSecundario) {
        this.descColorSecundario = descColorSecundario;
    }
    public String getDescTaco() {
        return descTaco;
    }
    public void setDescTaco(String descTaco) {
        this.descTaco = descTaco;
    }
    public String getNomMarca() {
        return nomMarca;
    }
    public void setNomMarca(String nomMarca) {
        this.nomMarca = nomMarca;
    }
    public String getDescClase() {
        return descClase;
    }
    public void setDescClase(String descClase) {
        this.descClase = descClase;
    }
    public String getFileImagen() {
        return fileImagen;
    }
    public void setFileImagen(String fileImagen) {
        this.fileImagen = fileImagen;
    }
    public List<BeanParteIngresoUnd> getUnidades() {
        return unidades;
    }
    public void setUnidades(List<BeanParteIngresoUnd> unidades) {
        this.unidades = unidades;
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

    public void populate(ExtendedSoapObject soapObject) {

    }


    public Double getCantidadUnd() {
        Double ldbl_return = 0.0;

        for(BeanParteIngresoUnd obj : unidades){
            ldbl_return += obj.getCantidad();
        }

        return ldbl_return;
    }

    public Double getImporteCompra() {
        Double ldbl_return = 0.0;

        for(BeanParteIngresoUnd obj : unidades){
            ldbl_return += obj.getPrecioCompraNew() * obj.getCantidad();
        }

        return ldbl_return;
    }

    public Double getImporteVenta() {
        Double ldbl_return = 0.0;

        for(BeanParteIngresoUnd obj : unidades){
            ldbl_return += obj.getPrecioVentaNew() * obj.getCantidad();
        }

        return ldbl_return;
    }

    //Funciones estáticas
    public static Double getTotalUnidades(List<BeanParteIngresoDet> listado) {
        Double ldbl_return = 0.0;

        for(BeanParteIngresoDet obj : listado){
            ldbl_return += obj.getCantidadUnd();
        }

        return ldbl_return;
    }

    public static Double getTotalValorCompra(List<BeanParteIngresoDet> listado) {
        Double ldbl_return = 0.0;

        for(BeanParteIngresoDet obj : listado){
            ldbl_return += obj.getImporteCompra();
        }

        return ldbl_return;
    }public static Double getTotalValorVenta(List<BeanParteIngresoDet> listado) {
        Double ldbl_return = 0.0;

        for(BeanParteIngresoDet obj : listado){
            ldbl_return += obj.getImporteVenta();
        }

        return ldbl_return;
    }
}
