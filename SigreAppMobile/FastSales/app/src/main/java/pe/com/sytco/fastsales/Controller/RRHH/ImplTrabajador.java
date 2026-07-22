package pe.com.sytco.fastsales.Controller.RRHH;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Controller.StrRespuesta;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.Asistencia.BeanTrabajador;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplTrabajador extends ImplAncestor {

    private String WSDL = "SigreWebService/ImplTrabajador?wsdl";

    public ImplTrabajador(String empresa) {
        this.empresaDefault = empresa;
    }

    /**
     * Obtiene un trabajador por su código
     */
    public BeanTrabajador getTrabajadorByCodigo(String codTrabajador) throws Exception {
        String METHOD_NAME = "getTrabajadorByCodigo";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("codTrabajador", codTrabajador));

        ExtendedSoapObject soapObject = new ExtendedSoapObject(
                (SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        BeanTrabajador bean = new BeanTrabajador();
        bean.populate(soapObject);

        if (!bean.getIsOk()) {
            throw new Exception(bean.getMensaje());
        }

        return bean;
    }

    /**
     * Busca trabajadores por DNI, código o nombre (búsqueda aproximada)
     */
    public List<BeanTrabajador> buscarTrabajadores(String textoBusqueda) throws Exception {
        List<BeanTrabajador> lista = new ArrayList<BeanTrabajador>();

        String METHOD_NAME = "buscarTrabajadores";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("textoBusqueda", textoBusqueda));

        List<Object> lsObjects = new SOAPClient().ConnectReturnList(WSDL, METHOD_NAME, param);
        if (lsObjects == null || lsObjects.isEmpty()) {
            return lista;
        }

        int length = lsObjects.size();
        for (int i = 0; i < length; i++) {
            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) lsObjects.get(i));
            BeanTrabajador bean = new BeanTrabajador();
            bean.populate(soapObject);

            if (!bean.getIsOk()) {
                throw new Exception(bean.getMensaje());
            }
            lista.add(bean);
        }

        return lista;
    }

    /**
     * Actualiza la foto de un trabajador
     * 
     * @param codTrabajador Código del trabajador
     * @param fotoBytes Bytes de la foto (JPEG), o null para eliminar
     * @return true si se actualizó correctamente
     */
    public boolean actualizarFotoTrabajador(String codTrabajador, byte[] fotoBytes) throws Exception {
        String METHOD_NAME = "actualizarFotoTrabajador";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("codTrabajador", codTrabajador));
        
        // Convertir foto a Base64 para enviar por SOAP
        if (fotoBytes != null && fotoBytes.length > 0) {
            String fotoBase64 = android.util.Base64.encodeToString(fotoBytes, android.util.Base64.DEFAULT);
            param.add(new parametro("fotoBase64", fotoBase64));
        } else {
            param.add(new parametro("fotoBase64", null));
        }

        ExtendedSoapObject soapObject = new ExtendedSoapObject(
                (SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        StrRespuesta respuesta = new StrRespuesta();
        respuesta.populate(soapObject);

        if (!respuesta.getIsOk()) {
            throw new Exception(respuesta.getMensaje());
        }

        return respuesta.getIsOk();
    }
}

