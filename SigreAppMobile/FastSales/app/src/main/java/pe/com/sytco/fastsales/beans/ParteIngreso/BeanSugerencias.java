package pe.com.sytco.fastsales.beans.ParteIngreso;

import android.util.Base64;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;

public class BeanSugerencias extends BeanAncestor {
    private static final long serialVersionUID = -112589863962207667L;
    private String codMarca, nomMarca, codLinea, descLinea, codSubLinea, descSubLinea, estilo, codSuela,
            descSuela, codAcabado, descAcabado, codColor1, descColor1, codColor2, descColor2,
            codTaco, descTaco, und, descUnidad, codClase, descClase;
    private Integer idFoto;
    private Double tallaMin, tallaMax;
    private byte[] imagenBlob;

    public String getCodMarca() {
        return codMarca;
    }
    public void setCodMarca(String codMarca) {
        this.codMarca = codMarca;
    }
    public String getNomMarca() {
        return nomMarca;
    }
    public void setNomMarca(String nomMarca) {
        this.nomMarca = nomMarca;
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
    public String getCodSubLinea() {
        return codSubLinea;
    }
    public void setCodSubLinea(String codSubLinea) {
        this.codSubLinea = codSubLinea;
    }
    public String getDescSubLinea() {
        return descSubLinea;
    }
    public void setDescSubLinea(String descSubLinea) {
        this.descSubLinea = descSubLinea;
    }
    public String getEstilo() {
        return estilo;
    }
    public void setEstilo(String estilo) {
        this.estilo = estilo;
    }
    public String getCodSuela() {
        return codSuela;
    }
    public void setCodSuela(String codSuela) {
        this.codSuela = codSuela;
    }
    public String getDescSuela() {
        return descSuela;
    }
    public void setDescSuela(String descSuela) {
        this.descSuela = descSuela;
    }
    public String getCodAcabado() {
        return codAcabado;
    }
    public void setCodAcabado(String codAcabado) {
        this.codAcabado = codAcabado;
    }
    public String getDescAcabado() {
        return descAcabado;
    }
    public void setDescAcabado(String descAcabado) {
        this.descAcabado = descAcabado;
    }
    public String getCodColor1() {
        return codColor1;
    }
    public void setCodColor1(String codColor1) {
        this.codColor1 = codColor1;
    }
    public String getDescColor1() {
        return descColor1;
    }
    public void setDescColor1(String descColor1) {
        this.descColor1 = descColor1;
    }
    public String getCodColor2() {
        return codColor2;
    }
    public void setCodColor2(String codColor2) {
        this.codColor2 = codColor2;
    }
    public String getDescColor2() {
        return descColor2;
    }
    public void setDescColor2(String descColor2) {
        this.descColor2 = descColor2;
    }
    public String getCodTaco() {
        return codTaco;
    }
    public void setCodTaco(String codTaco) {
        this.codTaco = codTaco;
    }
    public String getDescTaco() {
        return descTaco;
    }
    public void setDescTaco(String descTaco) {
        this.descTaco = descTaco;
    }
    public String getUnd() {
        return und;
    }
    public void setUnd(String und) {
        this.und = und;
    }
    public String getDescUnidad() {
        return descUnidad;
    }
    public void setDescUnidad(String descUnidad) {
        this.descUnidad = descUnidad;
    }
    public String getCodClase() {
        return codClase;
    }
    public void setCodClase(String codClase) {
        this.codClase = codClase;
    }
    public String getDescClase() {
        return descClase;
    }
    public void setDescClase(String descClase) {
        this.descClase = descClase;
    }
    public Integer getIdFoto() {
        return idFoto;
    }
    public void setIdFoto(Integer idFoto) {
        this.idFoto = idFoto;
    }
    public Double getTallaMin() {
        return tallaMin;
    }
    public void setTallaMin(Double tallaMin) {
        this.tallaMin = tallaMin;
    }
    public Double getTallaMax() {
        return tallaMax;
    }
    public void setTallaMax(Double tallaMax) {
        this.tallaMax = tallaMax;
    }
    public byte[] getImagenBlob() {
        return imagenBlob;
    }
    public void setImagenBlob(byte[] imagenBlob) {
        this.imagenBlob = imagenBlob;
    }

    public void populate(ExtendedSoapObject obj) throws Exception {

        super.populate(obj);

        if (obj.getProperty("codMarca") == null)
            this.codMarca = null;
        else
            this.codMarca = obj.getProperty("codMarca").toString();

        if (obj.getProperty("nomMarca") == null)
            this.nomMarca = null;
        else
            this.nomMarca = obj.getProperty("nomMarca").toString();

        if (obj.getProperty("codLinea") == null)
            this.codLinea = null;
        else
            this.codLinea = obj.getProperty("codLinea").toString();

        if (obj.getProperty("descLinea") == null)
            this.descLinea = null;
        else
            this.descLinea = obj.getProperty("descLinea").toString();

        if (obj.getProperty("codSubLinea") == null)
            this.codSubLinea = null;
        else
            this.codSubLinea = obj.getProperty("codSubLinea").toString();

        if (obj.getProperty("descSubLinea") == null)
            this.descSubLinea = null;
        else
            this.descSubLinea = obj.getProperty("descSubLinea").toString();

        if (obj.getProperty("estilo") == null)
            this.estilo = null;
        else
            this.estilo = obj.getProperty("estilo").toString();

        if (obj.getProperty("codSuela") == null)
            this.codSuela = null;
        else
            this.codSuela = obj.getProperty("codSuela").toString();

        if (obj.getProperty("descSuela") == null)
            this.descSuela = null;
        else
            this.descSuela = obj.getProperty("descSuela").toString();

        if (obj.getProperty("codAcabado") == null)
            this.codAcabado = null;
        else
            this.codAcabado = obj.getProperty("codAcabado").toString();

        if (obj.getProperty("descAcabado") == null)
            this.descAcabado = null;
        else
            this.descAcabado = obj.getProperty("descAcabado").toString();

        if (obj.getProperty("codColor1") == null)
            this.codColor1 = null;
        else
            this.codColor1 = obj.getProperty("codColor1").toString();

        if (obj.getProperty("descColor1") == null)
            this.descColor1 = null;
        else
            this.descColor1 = obj.getProperty("descColor1").toString();

        if (obj.getProperty("codColor2") == null)
            this.codColor2 = null;
        else
            this.codColor2 = obj.getProperty("codColor2").toString();

        if (obj.getProperty("descColor2") == null)
            this.descColor2 = null;
        else
            this.descColor2 = obj.getProperty("descColor2").toString();

        if (obj.getProperty("codTaco") == null)
            this.codTaco = null;
        else
            this.codTaco = obj.getProperty("codTaco").toString();

        if (obj.getProperty("descTaco") == null)
            this.descTaco = null;
        else
            this.descTaco = obj.getProperty("descTaco").toString();

        if (obj.getProperty("und") == null)
            this.und = null;
        else
            this.und = obj.getProperty("und").toString();

        if (obj.getProperty("descUnidad") == null)
            this.descUnidad = null;
        else
            this.descUnidad = obj.getProperty("descUnidad").toString();

        if (obj.getProperty("codClase") == null)
            this.codClase = null;
        else
            this.codClase = obj.getProperty("codClase").toString();

        if (obj.getProperty("descClase") == null)
            this.descClase = null;
        else
            this.descClase = obj.getProperty("descClase").toString();

        if (obj.getProperty("idFoto") == null)
            this.idFoto = null;
        else
            this.idFoto = Integer.parseInt(obj.getProperty("idFoto").toString());

        if (obj.getProperty("tallaMin") == null)
            this.tallaMin = null;
        else
            this.tallaMin = Double.parseDouble(obj.getProperty("tallaMin").toString());

        if (obj.getProperty("tallaMax") == null)
            this.tallaMax = null;
        else
            this.tallaMax = Double.parseDouble(obj.getProperty("tallaMax").toString());

        if (obj.getProperty("imagenBlob") != null) {
            byte[] bloc = Base64.decode(obj.getProperty("imagenBlob").toString(), Base64.DEFAULT);
            this.imagenBlob = bloc;
        }else {
            this.imagenBlob = null;
        }

    }
}
