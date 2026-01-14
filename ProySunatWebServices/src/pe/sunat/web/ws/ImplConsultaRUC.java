package pe.sunat.web.ws;

import javax.jws.WebService;
import javax.xml.bind.annotation.XmlRootElement;

import com.google.gson.Gson;

import pe.sunat.web.beans.BeanPadronRuc;
import pe.sunat.web.beans.BeanUsuario;
import pe.sunat.web.controlador.CntrlConsultaRUC;
import pe.sunat.web.controlador.CntrlUsuario;

@XmlRootElement(name="ImplConsultaRUC")
@WebService(portName="ImplConsultaRUCPort", targetNamespace="http://SunatWebServices/", name="ImplConsultaRUC", endpointInterface="pe.sunat.web.ws.IFaceConsultaRUC")
public class ImplConsultaRUC implements IFaceConsultaRUC{

	@Override
	public BeanPadronRuc getOne(String pRUC, String pUsuario, String pClave) throws Exception {
		BeanPadronRuc beanPadronRUC = null;
        
        CntrlUsuario cntrlUsuario = null;
        CntrlConsultaRUC cntrlConsultaRUC = null;

        try {
        	
        	cntrlUsuario = new CntrlUsuario();
        	cntrlConsultaRUC = new CntrlConsultaRUC();
        	
        	cntrlUsuario.validarCredenciales(pUsuario, pClave);
        	
        	System.out.println("Llamando al procedimiento getOne()");
        	beanPadronRUC = cntrlConsultaRUC.consultarRUC(pRUC);
        	System.out.println("Objeto " + beanPadronRUC);
            
            return beanPadronRUC;


        }catch (Exception e) {
            e.printStackTrace();
            
            beanPadronRUC = new BeanPadronRuc();
            beanPadronRUC.setIsOk(false);
            beanPadronRUC.setMensaje(e.getMessage());
            
            return beanPadronRUC;
            		
        }finally{
            cntrlUsuario = null;
            cntrlConsultaRUC= null;
            
            //beanPadronRUC = null;

        }
	}

	@Override
	public BeanPadronRuc consultar(String pRucConsulta, 
								   String pRucOrigen, 
								   String pUsuario, 
								   String pClave,
								   String pEmpresa,
								   String pComputerName) throws Exception {
		
		BeanPadronRuc beanPadronRUC = null;
		BeanUsuario	beanUsuario = null;
        
        CntrlUsuario cntrlUsuario = null;
        CntrlConsultaRUC cntrlConsultaRUC = null;

        try {
        	
        	cntrlUsuario = new CntrlUsuario();
        	cntrlConsultaRUC = new CntrlConsultaRUC();
        	
        	beanUsuario =  cntrlUsuario.validarCredenciales(pUsuario, pClave);
        	
        	if (cntrlUsuario.validarMaxConsultas(beanUsuario)) {
        		beanPadronRUC = cntrlConsultaRUC.consultarRUC(pRucConsulta);
        		
        		cntrlConsultaRUC.registrarConsulta(pRucConsulta, pRucOrigen, pEmpresa, pComputerName, beanUsuario, beanPadronRUC);
        	}
        	
            return beanPadronRUC;


        }catch (Exception e) {
            e.printStackTrace();
            
            beanPadronRUC = new BeanPadronRuc();
            beanPadronRUC.setIsOk(false);
            beanPadronRUC.setMensaje(e.getMessage());
            
            return beanPadronRUC;
            		
        }finally{
            cntrlUsuario = null;
            cntrlConsultaRUC= null;
            
            //beanPadronRUC= null;
            beanUsuario= null;
        }
	}

	@Override
	public String test(String pRUC) throws Exception {
		// TODO Auto-generated method stub
		return "Esto es una prueba que todo OK";
	}

	@Override
	public String consultarJSON(String pRucConsulta, 
								String pRucOrigen, 
								String pUsuario, 
								String pClave, 
								String pEmpresa,
								String pComputerName) throws Exception {
		
		BeanPadronRuc beanPadronRUC = null;
		BeanUsuario	beanUsuario = null;
        
        CntrlUsuario cntrlUsuario = null;
        CntrlConsultaRUC cntrlConsultaRUC = null;
        Gson gson = null;

        try {
        	
        	gson = new Gson();
        	
        	cntrlUsuario = new CntrlUsuario();
        	cntrlConsultaRUC = new CntrlConsultaRUC();
        	
        	beanUsuario =  cntrlUsuario.validarCredenciales(pUsuario, pClave);
        	
        	if (cntrlUsuario.validarMaxConsultas(beanUsuario)) {
        		beanPadronRUC = cntrlConsultaRUC.consultarRUC(pRucConsulta);
        		
        		cntrlConsultaRUC.registrarConsulta(pRucConsulta, pRucOrigen, pEmpresa, pComputerName, beanUsuario, beanPadronRUC);
        	}
        	
            return gson.toJson(beanPadronRUC);


        }catch (Exception e) {
            e.printStackTrace();
            
            beanPadronRUC = new BeanPadronRuc();
            beanPadronRUC.setIsOk(false);
            beanPadronRUC.setMensaje(e.getMessage());
            
            return gson.toJson(beanPadronRUC);
            		
        }finally{
            cntrlUsuario = null;
            cntrlConsultaRUC= null;
            
            //beanPadronRUC= null;
            beanUsuario= null;
            
            gson = null;
        }
        
	}

	@Override
	public BeanPadronRuc consultarPB(String pRucConsulta, 
									 String pRucOrigen, 
									 String pUsuario, 
									 String pClave,
									 String pEmpresa, 
									 String pComputerName) throws Exception {
		// TODO Auto-generated method stub
		return this.consultar(pRucConsulta, pRucOrigen, pUsuario, pClave, pEmpresa, pComputerName);
	}

}
