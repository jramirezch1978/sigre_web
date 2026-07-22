package pe.com.sytco.fastsales.Controller.Asistencia;

import com.google.gson.Gson;

import org.ksoap2.serialization.PropertyInfo;
import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Asistencia.BeanAsistenciaHT580;
import pe.com.sytco.fastsales.beans.Asistencia.BeanTrabajador;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplAsistencia extends ImplAncestor {

    private String WSDL = "SigreWebService/ImplAsistencia?wsdl";

    public ImplAsistencia(String empresa){
        this.empresaDefault = empresa;
    }

    public List<BeanAsistenciaHT580> getAsistenciaByFechaAndUser(String pFecMovimiento,
                                                                 String pFlagInOut,
                                                                 String pCodUsuario) throws Exception {
        List<BeanAsistenciaHT580> lista = new ArrayList<BeanAsistenciaHT580>();

        String METHOD_NAME = "getAsistenciaByFechaAndUser";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pFecMovimiento", pFecMovimiento));
        param.add(new parametro("pFlagInOut", pFlagInOut));
        param.add(new parametro("pCodUsuario", pCodUsuario));

        List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);
        int length = lsObjects.size();

        for(int i=0; i<length; i ++){
            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
            BeanAsistenciaHT580 bean = new BeanAsistenciaHT580();
            bean.populate(soapObject);

            if (!bean.getIsOk()){
                throw new Exception(bean.getMensaje());
            }
            lista.add(bean);
        }

        return lista;
    }
    
    public List<BeanAsistenciaHT580> getAsistenciaByFechaAndUserOrderByMarcacion(String pFecMovimiento,
                                                                 String pFlagInOut,
                                                                 String pCodUsuario) throws Exception {
        List<BeanAsistenciaHT580> lista = new ArrayList<BeanAsistenciaHT580>();

        String METHOD_NAME = "getAsistenciaByFechaAndUserOrderByMarcacion";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pFecMovimiento", pFecMovimiento));
        param.add(new parametro("pFlagInOut", pFlagInOut));
        param.add(new parametro("pCodUsuario", pCodUsuario));

        List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);
        int length = lsObjects.size();

        for(int i=0; i<length; i ++){
            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
            BeanAsistenciaHT580 bean = new BeanAsistenciaHT580();
            bean.populate(soapObject);

            if (!bean.getIsOk()){
                throw new Exception(bean.getMensaje());
            }
            lista.add(bean);
        }

        return lista;
    }

    public Boolean saveAsistencia(BeanAsistenciaHT580 beanAsistenciaHT580) throws Exception {
        /*
        	@WebMethod(operationName="saveAsistencia")
	@WebResult(name="StrRespuesta")
	public StrRespuesta saveAsistencia(@WebParam(name="empresaDefault") String empresaDefault,
									   @WebParam(name="codOrigen") 		String codOrigen,
						   			   @WebParam(name="codigo")  		String codigo,
						   			   @WebParam(name="flagInOut")  	String flagInOut,
						   			   @WebParam(name="fecMovimiento")	String fecMovimiento,
						   			   @WebParam(name="codUsr")  		String codUsr,
						   			   @WebParam(name="direccionIP")  	String direccionIp,
						   			   @WebParam(name="lecturaPDA")  	String lecturaPDA) throws Exception;

         */
        StrRespuesta strRespuesta = null;
        PropertyInfo pi = null;

        try {
            strRespuesta = new StrRespuesta();

            String METHOD_NAME = "saveAsistencia";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("codOrigen", beanAsistenciaHT580.getCodOrigen()));
            param.add(new parametro("codigo", beanAsistenciaHT580.getCodigo()));
            param.add(new parametro("flagInOut", beanAsistenciaHT580.getFlagInOut()));
            param.add(new parametro("fecMovimiento", beanAsistenciaHT580.getFecMovimiento()));
            param.add(new parametro("codUsr", beanAsistenciaHT580.getCodUsr()));
            param.add(new parametro("direccionIP", beanAsistenciaHT580.getDireccionIP()));
            param.add(new parametro("lecturaPDA", beanAsistenciaHT580.getLecturaPDA()));

            System.out.println("param =>" + new Gson().toJson(param));


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
        }
    }

    public BeanTrabajador getTrabajadorByCodigo(String codTrabajador) throws Exception {
        /*
            @WebMethod(operationName="getTrabajadorByCodigo")
            @WebResult(name="BeanTrabajador")
            public BeanTrabajador getTrabajadorByCodigo(@WebParam(name="empresaDefault") String empresaDefault,
                                                        @WebParam(name="codTrabajador") String codTrabajador) throws Exception;
         */
        BeanTrabajador beanTrabajador = null;

        try {
            String METHOD_NAME = "getTrabajadorByCodigo";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("codTrabajador", codTrabajador));

            System.out.println("getTrabajadorByCodigo param =>" + new Gson().toJson(param));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanTrabajador = new BeanTrabajador();
            beanTrabajador.populate(soapObject);

            if (!beanTrabajador.getIsOk()) {
                throw new Exception(beanTrabajador.getMensaje());
            }

            return beanTrabajador;

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            System.gc();
        }
    }

    public Boolean deleteAsistencia(String reckey) throws Exception {
        try {
            String METHOD_NAME = "deleteAsistencia";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("reckey", reckey));

            System.out.println("deleteAsistencia param =>" + new Gson().toJson(param));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            StrRespuesta strRespuesta = new StrRespuesta();
            strRespuesta.populate(soapObject);

            if (!strRespuesta.getIsOk()) {
                throw new Exception(strRespuesta.getMensaje());
            }

            return strRespuesta.getIsOk();

        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            System.gc();
        }
    }
    
    /**
     * Obtiene la fecha y hora del servidor
     * @return String con formato "dd/MM/yyyy hh:mm:ss a"
     * @throws Exception si hay error en la comunicación
     */
    public String getServerDateTime() throws Exception {
        try {
            String METHOD_NAME = "getServerDateTime";
            
            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            
            Object result = new SOAPClient().Connect(WSDL, METHOD_NAME, param);
            
            if (result == null) {
                throw new Exception("No se recibió respuesta del servidor");
            }
            
            // El resultado es un String directamente
            String serverDateTime = result.toString();
            
            if (serverDateTime == null || serverDateTime.isEmpty() || serverDateTime.equals("anyType{}")) {
                throw new Exception("Respuesta inválida del servidor");
            }
            
            return serverDateTime;
            
        } catch (Exception e) {
            e.printStackTrace();
            throw new Exception("Error al obtener hora del servidor: " + e.getMessage());
        }
    }
}
