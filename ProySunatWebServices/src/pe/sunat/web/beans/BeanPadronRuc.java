package pe.sunat.web.beans;

import java.io.Serializable;
import java.sql.SQLException;

import javax.sql.rowset.CachedRowSet;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlRootElement;

import pe.sunat.web.ancestors.BeanAncestorWS;


@XmlRootElement(name = "BeanPadronRuc")
@XmlAccessorType(XmlAccessType.FIELD)
public class BeanPadronRuc extends BeanAncestorWS implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = -1082493840336515561L;
	private String ruc, razonSocial, estado, condicion, ubigeo, tipoVia, nombreVia, codigoZona, tipoZona, numero, interior, lote, departamento;
	private String manzana, kilometro, codProvincia, descProvincia, codDepartamento, descDepartamento, descDistrito;
	
	public String getCodProvincia() {
		return codProvincia;
	}

	public void setCodProvincia(String codProvincia) {
		this.codProvincia = codProvincia;
	}

	public String getDescProvincia() {
		return descProvincia;
	}

	public void setDescProvincia(String descProvincia) {
		this.descProvincia = descProvincia;
	}

	public String getCodDepartamento() {
		return codDepartamento;
	}

	public void setCodDepartamento(String codDepartamento) {
		this.codDepartamento = codDepartamento;
	}

	public String getDescDepartamento() {
		return descDepartamento;
	}

	public void setDescDepartamento(String descDepartamento) {
		this.descDepartamento = descDepartamento;
	}

	public String getDescDistrito() {
		return descDistrito;
	}

	public void setDescDistrito(String descDistrito) {
		this.descDistrito = descDistrito;
	}

	public String getRuc() {
		return ruc;
	}

	public void setRuc(String value) {
		this.ruc = value;
	}

	public String getRazonSocial() {
		return razonSocial;
	}

	public void setRazonSocial(String value) {
		this.razonSocial = value;
	}

	public String getEstado() {
		return estado;
	}

	public void setEstado(String value) {
		this.estado = value;
	}

	public String getCondicion() {
		return condicion;
	}

	public void setCondicion(String value) {
		this.condicion = value;
	}

	public String getUbigeo() {
		return ubigeo;
	}

	public void setUbigeo(String value) {
		this.ubigeo = value;
	}

	public String getTipoVia() {
		return tipoVia;
	}

	public void setTipoVia(String value) {
		this.tipoVia = value;
	}

	public String getNombreVia() {
		return nombreVia;
	}

	public void setNombreVia(String value) {
		this.nombreVia = value;
	}

	public String getCodigoZona() {
		return codigoZona;
	}

	public void setCodigoZona(String value) {
		this.codigoZona = value;
	}

	public String getTipoZona() {
		return tipoZona;
	}

	public void setTipoZona(String value) {
		this.tipoZona = value;
	}

	public String getNumero() {
		return numero;
	}

	public void setNumero(String value) {
		this.numero = value;
	}

	public String getInterior() {
		return interior;
	}

	public void setInterior(String value) {
		this.interior = value;
	}

	public String getLote() {
		return lote;
	}

	public void setLote(String value) {
		this.lote = value;
	}

	public String getDepartamento() {
		return departamento;
	}

	public void setDepartamento(String value) {
		this.departamento = value;
	}

	public String getManzana() {
		return manzana;
	}

	public void setManzana(String value) {
		this.manzana = value;
	}

	public String getKilometro() {
		return kilometro;
	}

	public void setKilometro(String value) {
		this.kilometro = value;
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return String.valueOf(this.getIsOk()) + '|' +this.getMensaje() + '|' +  this.ruc + '|' + this.razonSocial + '|';
	}

	public static BeanPadronRuc InstanceOf(CachedRowSet rs) throws SQLException {
		/*
		  SQL> desc padron_ruc
			Name         Type          Nullable Default Comments 
			------------ ------------- -------- ------- -------- 
			RUC          CHAR(11)                                
			RAZON_SOCIAL VARCHAR2(255) Y                         
			ESTADO       VARCHAR2(255) Y                         
			CONDICION    VARCHAR2(255) Y                         
			UBIGEO       VARCHAR2(255) Y                         
			TIPO_VIA     VARCHAR2(255) Y                         
			NOMBRE_VIA   VARCHAR2(255) Y                         
			CODIGO_ZONA  VARCHAR2(255) Y                         
			TIPO_ZONA    VARCHAR2(255) Y                         
			NUMERO       VARCHAR2(255) Y                         
			INTERIOR     VARCHAR2(255) Y                         
			LOTE         VARCHAR2(255) Y                         
			DEPARTAMENTO VARCHAR2(255) Y                         
			MANZANA      VARCHAR2(255) Y                         
			KILOMETRO    VARCHAR2(255) Y   
			cod_dpto
       		desc_dpto 
        	cod_prov 
        	desc_provincia 
        	desc_distrito     
		*/
		
		BeanPadronRuc beanPadroRUC = new BeanPadronRuc();
		
		if (beanPadroRUC.hasColumn(rs, "RUC"))
			beanPadroRUC.setRuc(rs.getString("RUC"));
		
		if (beanPadroRUC.hasColumn(rs, "RAZON_SOCIAL"))
			beanPadroRUC.setRazonSocial(rs.getString("RAZON_SOCIAL"));
		
		if (beanPadroRUC.hasColumn(rs, "ESTADO"))
			beanPadroRUC.setEstado(rs.getString("ESTADO"));
		
		if (beanPadroRUC.hasColumn(rs, "CONDICION"))
			beanPadroRUC.setCondicion(rs.getString("CONDICION"));
		
		if (beanPadroRUC.hasColumn(rs, "UBIGEO"))
			beanPadroRUC.setUbigeo(rs.getString("UBIGEO"));
		
		if (beanPadroRUC.hasColumn(rs, "TIPO_VIA"))
			beanPadroRUC.setTipoVia(rs.getString("TIPO_VIA"));
		
		if (beanPadroRUC.hasColumn(rs, "NOMBRE_VIA"))
			beanPadroRUC.setNombreVia(rs.getString("NOMBRE_VIA"));
		
		if (beanPadroRUC.hasColumn(rs, "CODIGO_ZONA"))
			beanPadroRUC.setCodigoZona(rs.getString("CODIGO_ZONA"));
		
		if (beanPadroRUC.hasColumn(rs, "TIPO_ZONA"))
			beanPadroRUC.setTipoZona(rs.getString("TIPO_ZONA"));
		
		if (beanPadroRUC.hasColumn(rs, "NUMERO"))
			beanPadroRUC.setNumero(rs.getString("NUMERO"));
		
		if (beanPadroRUC.hasColumn(rs, "INTERIOR"))
			beanPadroRUC.setInterior(rs.getString("INTERIOR"));
		
		if (beanPadroRUC.hasColumn(rs, "LOTE"))
			beanPadroRUC.setLote(rs.getString("LOTE"));
		
		if (beanPadroRUC.hasColumn(rs, "DEPARTAMENTO"))
			beanPadroRUC.setDepartamento(rs.getString("DEPARTAMENTO"));
		
		if (beanPadroRUC.hasColumn(rs, "MANZANA"))
			beanPadroRUC.setManzana(rs.getString("MANZANA"));
		
		if (beanPadroRUC.hasColumn(rs, "KILOMETRO"))
			beanPadroRUC.setKilometro(rs.getString("KILOMETRO"));
		
		if (beanPadroRUC.hasColumn(rs, "COD_DPTO"))
			beanPadroRUC.setCodDepartamento(rs.getString("COD_DPTO"));
		
		if (beanPadroRUC.hasColumn(rs, "DESC_DPTO"))
			beanPadroRUC.setDescDepartamento(rs.getString("DESC_DPTO"));
		
		if (beanPadroRUC.hasColumn(rs, "COD_PROV"))
			beanPadroRUC.setCodProvincia(rs.getString("COD_PROV"));
		
		if (beanPadroRUC.hasColumn(rs, "DESC_PROVINCIA"))
			beanPadroRUC.setDescProvincia(rs.getString("DESC_PROVINCIA"));
		
		if (beanPadroRUC.hasColumn(rs, "DESC_DISTRITO"))
			beanPadroRUC.setDescDistrito(rs.getString("DESC_DISTRITO"));
		
		beanPadroRUC.setIsOk(true);
		
		return beanPadroRUC;
	}

	
	

}
