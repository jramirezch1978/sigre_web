package pe.com.sytco.fastsales.Controller;

import android.app.ProgressDialog;
import android.content.Context;
import android.os.AsyncTask;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.BeanAndroidDevice;
import pe.com.sytco.fastsales.beans.BeanEntorno;
import pe.com.sytco.fastsales.beans.parametro;
import pe.com.sytco.fastsales.util.MessageBox;

/**
 * Created by jramirez on 14/11/2017.
 */
public class ImplEntorno extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplEntorno?wsdl";
    public static BeanAndroidDevice device = null;

    private ImplEntorno(){}

    public ImplEntorno(Context value) {
        this.context = value;
    }

    protected BeanEntorno getEntorno() throws Exception {
        BeanEntorno entorno = null;
        try {
            String METHOD_NAME = "getEntorno";

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME));

            entorno = new BeanEntorno();
            entorno.populate(soapObject);

            return entorno;


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{

        }
    }

    protected void setEntorno(BeanEntorno value) throws Exception {
        try {
            String METHOD_NAME = "setEntorno";

            List<parametro> param = new ArrayList<parametro>();

            param.add(new parametro("value", value));


            new SOAPClient().Connect(WSDL, METHOD_NAME, param);

            return;


        }catch (Exception e) {

            e.printStackTrace();
            throw e;

        }finally{

        }
    }

    public void ApplyEntorno(BeanEntorno value) {
        new ImplEntornoTask(value).execute();
    }

    private class ImplEntornoTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje;
        private ProgressDialog pDialog;
        private BeanEntorno entorno;

        public ImplEntornoTask(BeanEntorno value){
            this.entorno = value;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Configurando entorno en el Servidor. Por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                //setEntorno(entorno);
                return true;

            }catch(Exception e){
                mensaje = "Error al actualizar entorno en el servidor " + SOAPClient.serverDefault.getNombre() + ". Mensaje: " + e.getMessage();
                e.printStackTrace();
                return false;
            }finally{

            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {

                if (!result) {
                    MessageBox.AlertDialog(mensaje, "Error de Conexión", context);

                }

            }catch(Exception ex){
                MessageBox.AlertDialog("Ha ocurrido una excepcion: " + ex.getMessage(), "Error", context);
                ex.printStackTrace();
            }finally {
                // Quito el dialogo despues de verificar la conexión con el servidor
                if ((pDialog != null) && pDialog.isShowing()) {
                    try {
                        pDialog.dismiss();
                    }catch(Exception ex){}
                }

            }
        }

    }

}
