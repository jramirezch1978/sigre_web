package pe.sunat.web.ws;


import javax.jws.WebMethod;
import javax.jws.WebParam;
import javax.jws.WebResult;
import javax.jws.WebService;

import pe.sunat.web.beans.BeanPadronRuc;

@WebService(targetNamespace="http://SunatWebServices/", name="IFaceConsultaRUC")
public interface IFaceConsultaRUC {
	
	@WebMethod(operationName="test")
	public String test(@WebParam(name="pRUC") String pRUC) throws Exception;
	
	@WebMethod(operationName="getOne")
	@WebResult(name="BeanPadronRuc")	
	public BeanPadronRuc getOne(@WebParam(name="pRUC") String pRUC, 
							   @WebParam(name="pUsuario") String pUsuario,
							   @WebParam(name="pClave") String pClave) throws Exception;
	
	@WebMethod(operationName="consultar")
	@WebResult(name="BeanPadronRuc")	
	public BeanPadronRuc consultar(@WebParam(name="pRucConsulta") String pRucConsulta, 
								   @WebParam(name="pRucOrigen") String pRucOrigen,
							   	   @WebParam(name="pUsuario") String pUsuario,
							   	   @WebParam(name="pClave") String pClave,
							   	   @WebParam(name="pEmpresa") String pEmpresa,
							   	   @WebParam(name="pComputerName") String pComputerName) throws Exception;
	
	@WebMethod(operationName="consultarJSON")
	public String consultarJSON(@WebParam(name="pRucConsulta") String pRucConsulta, 
								   @WebParam(name="pRucOrigen") String pRucOrigen,
							   	   @WebParam(name="pUsuario") String pUsuario,
							   	   @WebParam(name="pClave") String pClave,
							   	   @WebParam(name="pEmpresa") String pEmpresa,
							   	   @WebParam(name="pComputerName") String pComputerName) throws Exception;
	
	@WebMethod(operationName="consultarPB")
	public BeanPadronRuc consultarPB(@WebParam(name="pRucConsulta") String pRucConsulta, 
								   	 @WebParam(name="pRucOrigen") String pRucOrigen,
								   	 @WebParam(name="pUsuario") String pUsuario,
								   	 @WebParam(name="pClave") String pClave,
								   	 @WebParam(name="pEmpresa") String pEmpresa,
								   	 @WebParam(name="pComputerName") String pComputerName) throws Exception;
	
}

