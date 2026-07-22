package pe.com.sytco.fastsales.beans;

import android.util.Base64;

import com.google.gson.annotations.SerializedName;

import org.ksoap2.serialization.SoapObject;

import java.io.Serializable;

import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.util.UTIL;

public class BeanEmpresa implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6900265999367643920L;

    @SerializedName("nombre")
	private String codigo;
    @SerializedName("razonSocial")
    private String razonSocial;
    @SerializedName("nroDocIdentidad")
    private String nroDocIdentidad;
    @SerializedName("tipoDocIdentidad")
    private String tipoDocIdentidad;
    @SerializedName("flagEstado")
    private String flagEstado;
    @SerializedName("flagDefault")
	private String flagDefault;
	@SerializedName("codOrigen")
	private String codOrigen;
	@SerializedName("logoFile")
	private String logoFile;
	@SerializedName("logoBase64")
	private String logoBase64;
	@SerializedName("isOk")
	private Boolean isOk;
	@SerializedName("mensaje")
	private String mensaje;

	//Driver JDBC para conectarse
    @SerializedName("driverJDBC")
	private String driverJDBC;

	//Ambiente de produccion
    @SerializedName("claveProd")
	private String claveProd;
    @SerializedName("usuarioProd")
	private String usuarioProd;
    @SerializedName("serverProd")
	private String serverProd;
    @SerializedName("PortProd")
	private String PortProd;
    @SerializedName("SIDProd")
	private String SIDProd;

	//Ambiente de Pruebas
    @SerializedName("claveTest")
	private String claveTest;
    @SerializedName("usuarioTest")
	private String usuarioTest;
    @SerializedName("serverTest")
	private String serverTest;
    @SerializedName("PortTest")
	private String PortTest;
    @SerializedName("SIDTest")
	private String SIDTest;

	/**
	 * @return the codigo
	 */
	public String getCodigo() {
		return codigo;
	}
	/**
	 * @param codigo the codigo to set
	 */
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}
	/**
	 * @return the razonSocial
	 */
	public String getRazonSocial() {
		return razonSocial;
	}
	/**
	 * @param razonSocial the razonSocial to set
	 */
	public void setRazonSocial(String razonSocial) {
		this.razonSocial = razonSocial;
	}
	/**
	 * @return the nroDocIdentidad
	 */
	public String getNroDocIdentidad() {
		return nroDocIdentidad;
	}
	/**
	 * @param nroDocIdentidad the nroDocIdentidad to set
	 */
	public void setNroDocIdentidad(String nroDocIdentidad) {
		this.nroDocIdentidad = nroDocIdentidad;
	}
	/**
	 * @return the tipoDocIdentidad
	 */
	public String getTipoDocIdentidad() {
		return tipoDocIdentidad;
	}
	/**
	 * @param tipoDocIdentidad the tipoDocIdentidad to set
	 */
	public void setTipoDocIdentidad(String tipoDocIdentidad) {
		this.tipoDocIdentidad = tipoDocIdentidad;
	}

	public void setFlagEstado(String value) {
		this.flagEstado = value;
	}

	public String getFlagEstado(){
		return this.flagEstado;
	}

	public void populate(ExtendedSoapObject soapObject) {
		this.codigo = soapObject.getProperty("codigo").toString();
		this.razonSocial = soapObject.getProperty("razonSocial").toString();
		this.tipoDocIdentidad = soapObject.getProperty("tipoDocIdentidad").toString();
		this.nroDocIdentidad = soapObject.getProperty("nroDocIdentidad").toString();
		this.flagEstado = soapObject.getProperty("flagEstado").toString();
		this.flagDefault = soapObject.getProperty("flagDefault").toString();
		this.codOrigen = soapObject.getProperty("codOrigen").toString();

		//Para ambien de produccion y test
        if (soapObject.getProperty("driverJDBC") != null)
			this.driverJDBC = soapObject.getProperty("driverJDBC").toString();

		//Ambiente de produccion
		if (soapObject.getProperty("claveProd") != null)
			this.claveProd = soapObject.getProperty("claveProd").toString();

		if (soapObject.getProperty("usuarioProd") != null)
			this.usuarioProd = soapObject.getProperty("usuarioProd").toString();

		if (soapObject.getProperty("serverProd") != null)
			this.serverProd = soapObject.getProperty("serverProd").toString();

		if (soapObject.getProperty("PortProd") != null)
			this.PortProd = soapObject.getProperty("PortProd").toString();

		if (soapObject.getProperty("SIDProd") != null)
			this.SIDProd = soapObject.getProperty("SIDProd").toString();

		//Ambiente de Pruebas
		if (soapObject.getProperty("claveTest") != null)
			this.claveTest = soapObject.getProperty("claveTest").toString();

		if (soapObject.getProperty("usuarioTest") != null)
			this.usuarioTest = soapObject.getProperty("usuarioTest").toString();

		if (soapObject.getProperty("serverTest") != null)
			this.serverTest = soapObject.getProperty("serverTest").toString();

		if (soapObject.getProperty("PortTest") != null)
			this.PortTest = soapObject.getProperty("PortTest").toString();

		if (soapObject.getProperty("SIDTest") != null)
			this.SIDTest = soapObject.getProperty("SIDTest").toString();

		if (soapObject.getProperty("logoFile") != null)
			this.logoFile = soapObject.getProperty("logoFile").toString();

		if (soapObject.getProperty("logoBase64") != null)
			this.logoBase64 = soapObject.getProperty("logoBase64").toString();

	}

	public String getFlagDefault() {
		return flagDefault;
	}

	public void setFlagDefault(String flagDefault) {
		this.flagDefault = flagDefault;
	}

	public String getDriverJDBC() {
		return driverJDBC;
	}

	public void setDriverJDBC(String driverJDBC) {
		this.driverJDBC = driverJDBC;
	}

	public String getClaveProd() {
		return claveProd;
	}

	public void setClaveProd(String claveProd) {
		this.claveProd = claveProd;
	}

	public String getUsuarioProd() {
		return usuarioProd;
	}

	public void setUsuarioProd(String usuarioProd) {
		this.usuarioProd = usuarioProd;
	}

	public String getServerProd() {
		return serverProd;
	}

	public void setServerProd(String serverProd) {
		this.serverProd = serverProd;
	}

	public String getPortProd() {
		return PortProd;
	}

	public void setPortProd(String portProd) {
		PortProd = portProd;
	}

	public String getSIDProd() {
		return SIDProd;
	}

	public void setSIDProd(String SIDProd) {
		this.SIDProd = SIDProd;
	}

	public String getClaveTest() {
		return claveTest;
	}

	public void setClaveTest(String claveTest) {
		this.claveTest = claveTest;
	}

	public String getUsuarioTest() {
		return usuarioTest;
	}

	public void setUsuarioTest(String usuarioTest) {
		this.usuarioTest = usuarioTest;
	}

	public String getServerTest() {
		return serverTest;
	}

	public void setServerTest(String serverTest) {
		this.serverTest = serverTest;
	}

	public String getPortTest() {
		return PortTest;
	}

	public void setPortTest(String portTest) {
		PortTest = portTest;
	}

	public String getSIDTest() {
		return SIDTest;
	}

	public void setSIDTest(String SIDTest) {
		this.SIDTest = SIDTest;
	}

	public boolean isProdEnvironment() {
        if (this.usuarioProd == null || this.claveProd == null || this.PortProd == null || this.SIDProd == null || this.serverProd == null)
            return false;
        else
		    return true;

	}

	public boolean isTestEnvironment() {
        if (this.usuarioTest == null || this.claveTest == null || this.PortTest == null || this.SIDTest == null || this.serverTest == null)
            return false;
        else
            return true;
	}

	public String getCodOrigen() {
		return codOrigen;
	}

	public void setCodOrigen(String value) {
		this.codOrigen = value;
	}

	public String getLogoFile() {
		return logoFile;
	}

	public void setLogoFile(String logoFile) {
		this.logoFile = logoFile;
	}

	public String getLogoBase64() {
		return logoBase64;
	}

	public void setLogoBase64(String logoBase64) {
		this.logoBase64 = logoBase64;
	}

	public Boolean isOk() {
		return isOk != null ? isOk : true;
	}

	public void setIsOk(Boolean isOk) {
		this.isOk = isOk;
	}

	public String getMensaje() {
		return mensaje;
	}

	public void setMensaje(String mensaje) {
		this.mensaje = mensaje;
	}
}
