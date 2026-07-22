package pe.com.sytco.fastsales.Controller;

import android.content.Context;
import android.provider.Settings;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import org.ksoap2.serialization.SoapObject;

import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.adapter.ExtendedSoapObject;
import pe.com.sytco.fastsales.beans.BeanInventarioPallet;
import pe.com.sytco.fastsales.beans.parametro;

public class ImplInventarioPallet extends ImplAncestor {
    private String WSDL = "SigreWebService/ImplInventarioPallets?wsdl";

    private static List<BeanInventarioPallet> _listadoColumnas;

    private ImplInventarioPallet()
    {

    }

    public ImplInventarioPallet(String empresa, Context pContext)
    {

        this.empresaDefault = empresa;
        this.context = pContext;
    }

    public static void setListadoColumnas(List<BeanInventarioPallet> value){
        ImplInventarioPallet._listadoColumnas = value;
    }

    public static List<BeanInventarioPallet> getListadoColumnas(){
        return ImplInventarioPallet._listadoColumnas;
    }

    public static void deleteColumna(BeanInventarioPallet item){
        BeanInventarioPallet sel = null;
        for (BeanInventarioPallet bean: ImplInventarioPallet._listadoColumnas) {
            if (bean.getColumna().toUpperCase().equals(item.getColumna().toUpperCase())){
                sel = bean;
                break;
            }
        }

        if (sel != null)
            ImplInventarioPallet._listadoColumnas.remove(sel);
    }


    public static void setFechaInventario(String fecInventario) {
        for(BeanInventarioPallet obj : ImplInventarioPallet._listadoColumnas){
            obj.setFecha(fecInventario);
        }
    }

    public static Double getTotalCajas(List<BeanInventarioPallet> inventario) {
        Double ldbl_NroCajas = 0.0;
        for(BeanInventarioPallet obj : inventario){
            ldbl_NroCajas += obj.getNroCajas();
        }
        return ldbl_NroCajas;
    }

    public boolean saveInventario(List<BeanInventarioPallet> inventario) throws Exception {
        String METHOD_NAME = "saveInventario";

        StrRespuesta strRespuesta = null;

        Gson gson = new GsonBuilder().create();
        String strInventario = "";


        try {
            strRespuesta = new StrRespuesta();

            //Grabo el ID del dispositivo
            for(BeanInventarioPallet bean : inventario){
                bean.setDeviceID(Settings.Secure.getString(context.getApplicationContext().getContentResolver(), Settings.Secure.ANDROID_ID));
            }

            strInventario = gson.toJson(inventario);
            System.out.println("Inventario: " + strInventario);

            List<parametro> param = new ArrayList<parametro>();
            param.add(new parametro("empresaDefault", empresaDefault));
            param.add(new parametro("inventario", strInventario));

            ExtendedSoapObject soapObject = new ExtendedSoapObject((SoapObject) new SOAPClient().Connect(WSDL, METHOD_NAME, param));

            strRespuesta.populate(soapObject);

            if(!strRespuesta.getIsOk()){
                throw new Exception(strRespuesta.getMensaje());
            }


            return strRespuesta.getIsOk();

        }catch (Exception e) {
            throw e;

        }finally{
            strRespuesta = null;
        }
    }
}
