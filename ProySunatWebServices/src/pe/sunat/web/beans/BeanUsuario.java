package pe.sunat.web.beans;

import java.io.Serializable;
import java.sql.Date;
import java.sql.SQLException;

import javax.sql.rowset.CachedRowSet;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;

import pe.sigre.lib.adapter.SqlDateToStringAdapter;
import pe.sunat.web.ancestors.BeanAncestorWS;

public class BeanUsuario extends BeanAncestorWS implements Serializable{
	/*
	 * SQL> desc usuarios
		Name          Type          Nullable Default Comments 
		------------- ------------- -------- ------- -------- 
		COD_USR       VARCHAR2(30)                            
		NOM_USUARIO   VARCHAR2(200)                           
		CLAVE         VARCHAR2(200)                           
		FLAG_ESTADO   CHAR(1)                                 
		FEC_REGISTRO  DATE                   sysdate          
		MAX_CONSULTAS NUMBER(4)              -1 
	 */
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -4062023553601299022L;

	String codUsuario, nomUsuario, clave, flagEstado;
	Integer maxConsultas;
	
	@XmlJavaTypeAdapter(SqlDateToStringAdapter.class)
	private Date fecRegistro;
	
	public String getCodUsuario() {
		return codUsuario;
	}

	public void setCodUsuario(String value) {
		this.codUsuario = value;
	}

	public String getNomUsuario() {
		return nomUsuario;
	}

	public void setNomUsuario(String value) {
		this.nomUsuario = value;
	}

	public String getClave() {
		return clave;
	}

	public void setClave(String value) {
		this.clave = value;
	}

	public String getFlagEstado() {
		return flagEstado;
	}

	public void setFlagEstado(String value) {
		this.flagEstado = value;
	}

	public Date getFecRegistro() {
		return fecRegistro;
	}

	public void setFecRegistro(Date value) {
		this.fecRegistro = value;
	}

	public Integer getMaxConsultas() {
		return maxConsultas;
	}

	public void setMaxConsultas(Integer maxConsultas) {
		this.maxConsultas = maxConsultas;
	}

	public static BeanUsuario InstanceOf(CachedRowSet rs) throws SQLException {
		/*
			  SQL> desc usuarios
				Name          Type          Nullable Default Comments 
				------------- ------------- -------- ------- -------- 
				COD_USR       VARCHAR2(30)                            
				NOM_USUARIO   VARCHAR2(200)                           
				CLAVE         VARCHAR2(200)                           
				FLAG_ESTADO   CHAR(1)                                 
				FEC_REGISTRO  DATE                   sysdate          
				MAX_CONSULTAS NUMBER(4)              -1  
		 */
		
		BeanUsuario beanUsuario = new BeanUsuario();
		
		if (beanUsuario.hasColumn(rs, "COD_USR"))
			beanUsuario.setCodUsuario(rs.getString("COD_USR"));
		
		if (beanUsuario.hasColumn(rs, "NOM_USUARIO"))
			beanUsuario.setNomUsuario(rs.getString("NOM_USUARIO"));
		
		if (beanUsuario.hasColumn(rs, "CLAVE"))
			beanUsuario.setClave(rs.getString("CLAVE"));
		
		if (beanUsuario.hasColumn(rs, "FLAG_ESTADO"))
			beanUsuario.setFlagEstado(rs.getString("FLAG_ESTADO"));
		
		if (beanUsuario.hasColumn(rs, "FEC_REGISTRO"))
			beanUsuario.setFecRegistro(rs.getDate("FEC_REGISTRO"));
		
		if (beanUsuario.hasColumn(rs, "MAX_CONSULTAS"))
			beanUsuario.setMaxConsultas(rs.getInt("MAX_CONSULTAS"));
		
		beanUsuario.setIsOk(true);
		
		return beanUsuario;
	}

	

}
