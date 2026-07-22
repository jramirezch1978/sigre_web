package pe.com.sytco.fastsales.Controller;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.os.AsyncTask;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

import pe.com.sytco.fastsales.Activities.LoginActivity;
import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.beans.parametro;
import pe.com.sytco.fastsales.util.MessageBox;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by jramirez on 05/04/2016.
 */
public class ImplUsuario extends ImplAncestor {

    private static Integer ACTION_CAMBIAR_CLAVE = 2;
    public static Integer ACTION_VALIDAR_CREDENCIALES = 1;
    private String WSDL = "SigreWebService/ImplUsuario?wsdl";

    private ImplUsuario()
    {

    }

    public ImplUsuario(String empresa){
        this.empresaDefault  = empresa;
    }

    public boolean validarCredenciales(String ls_usuario, String ls_clave) throws Exception {
        Boolean lbReturn;
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "validarCredenciales";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pCodUsr", ls_usuario.trim()));
        param.add(new parametro("pClave", ls_clave.trim()));

        //lbReturn = Boolean.parseBoolean(new SOAPClient().Connect(WSDL, METHOD_NAME, param).toString());

        //return lbReturn;

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getIsOk();
    }

    public boolean cambiarClave(String ls_usuario, String lsNewClave) throws Exception {

        Boolean lbReturn;
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "cambiarClave";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pCodUsr", ls_usuario.trim()));
        param.add(new parametro("pNewClave", lsNewClave.trim()));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getIsOk();
    }

    public BeanUsuario getOne(String pUsuario) throws Exception {
        BeanUsuario beanUsuario = null;

        try {
            String METHOD_NAME = "getOne";

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("pUsuario", pUsuario.trim()));

            beanUsuario = new BeanUsuario();
            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            beanUsuario.populate(soapObject);

            return beanUsuario;


        } catch (Exception ex) {
            throw ex;
        } finally {
        }

    }

    public String getClave(String pUsuario) throws Exception {
        String lsReturn = "";
        Boolean lbReturn;
        StrRespuesta strRespuesta = new StrRespuesta();

        String METHOD_NAME = "getClave";

        List<parametro> param = new ArrayList<parametro>();
        param.add(new parametro("empresaDefault", empresaDefault));
        param.add(new parametro("pCodUsr", pUsuario.trim()));

        ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

        strRespuesta.populate(soapObject);

        if(!strRespuesta.getIsOk())
            throw new Exception(strRespuesta.getMensaje());

        return strRespuesta.getCadena();
    }

    public void dialogCambiarClave(final BeanUsuario usuario, final LoginActivity activity) {

        Button btnAceptar, btnCancelar;
        final EditText etClave1, etClave2;
        this.context = activity;

        AlertDialog.Builder builderLocal = new AlertDialog.Builder(context);

        View layoutLocal;

        LayoutInflater inflater = activity.getLayoutInflater();

        layoutLocal = inflater.inflate(R.layout.dialog_cambio_clave, null);

        builderLocal.setView(layoutLocal);

        //Obtengo referencia a los Botones
        btnAceptar = (Button) layoutLocal.findViewById(R.id.btnAceptar);
        btnCancelar = (Button) layoutLocal.findViewById(R.id.btnCancelar);
        etClave1 = (EditText) layoutLocal.findViewById(R.id.etClave1);
        etClave2 = (EditText) layoutLocal.findViewById(R.id.etClave2);

        //Programo los Click de los botones
        builderLocal.setCancelable(false);

        final AlertDialog dialogLocal = builderLocal.create();

        btnCancelar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        EditText etClave;
                        Button btnLogin;

                        etClave = (EditText)((Activity) context).findViewById(R.id.etClave);
                        btnLogin= (Button)((Activity) context).findViewById(R.id.btnLogin);

                        etClave.setText("");
                        btnLogin.setEnabled(true);

                        MessageBox.AlertDialog("Debe cambiar la clave para ingresar a la APP", "Error", context);
                        dialogLocal.dismiss();
                    }
                }
        );

        btnAceptar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        String lsClave1, lsClave2;
                        try {
                            lsClave1 = etClave1.getText().toString().trim();
                            lsClave2 = etClave2.getText().toString().trim();

                            if (lsClave1.equals("")){
                                MessageBox.AlertDialog("Debe ingresar la nueva clave", "Error", context);
                                return;
                            }
                            if (lsClave2.equals("")){
                                MessageBox.AlertDialog("Debe confirmar la nueva clave", "Error", context);
                                return;
                            }

                            if (!lsClave1.equals(lsClave2)){
                                MessageBox.AlertDialog("Las contraseñas no coinciden, por favor corrija", "Error", context);
                                return;
                            }

                            new ImplUsuarioTask(usuario, lsClave1, dialogLocal).execute(ImplUsuario.ACTION_CAMBIAR_CLAVE);


                        } catch (Exception ex) {
                            MessageBox.AlertDialog("Error al cambiar clave. Mensaje: " + ex.getMessage(), "Error", context);
                        } finally {
                            //dialogLocal.dismiss();
                        }

                    }
                }

        );

        dialogLocal.show();

    }


    private class ImplUsuarioTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje;
        private ProgressDialog pDialog;
        private BeanUsuario beanUsuario = null;
        private AlertDialog dialogLocal = null;
        private String newClave;

        public ImplUsuarioTask(BeanUsuario value, String pNewClave, AlertDialog pDialogLocal){
            this.beanUsuario = value;
            this.newClave = pNewClave;
            this.dialogLocal = pDialogLocal;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Procesando. Por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {

                //Cambio la clave del usuario
                cambiarClave(beanUsuario.getUsuario(), this.newClave) ;

                return true;

            }catch (Exception ex){
                mensaje = "Error al momento de Validar Credenciales: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            }finally{

            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            EditText etClave;
            Button btnLogin;
            try {
                if(result){
                    etClave = (EditText)((Activity) context).findViewById(R.id.etClave);
                    btnLogin= (Button)((Activity) context).findViewById(R.id.btnLogin);

                    etClave.setText("");
                    btnLogin.setEnabled(true);

                    dialogLocal.dismiss();
                }


            }catch(Exception ex){
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
