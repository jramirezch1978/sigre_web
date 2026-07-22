package pe.com.sytco.fastsales.Controller;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.material.textfield.TextInputLayout;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONException;

import java.lang.reflect.Type;
import java.util.ArrayList;
import java.util.List;

import pe.com.sytco.fastsales.Activities.LoginActivity;
import pe.com.sytco.fastsales.Activities.ServerRemoteActivity;
import pe.com.sytco.fastsales.Controller.Ancestor.ImplAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.Services.SOAPClient;
import pe.com.sytco.fastsales.beans.BeanServerRemote;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.SettingPreferences;
import pe.com.sytco.fastsales.util.UTIL;
import pe.com.sytco.fastsales.util.ValidInputHelper;

/**
 * Created by jramirez on 29/10/2017.
 */
public class ImplServerRemote extends ImplAncestor {

    public static final String KEY_PREFERENCE = "SERVERS_REMOTE_PREFERENCE";
    private SettingPreferences pref;
    private List<BeanServerRemote> _servers;

    //Controles
    private EditText etNameServer, etPort, etHostIp;
    private Spinner spProtocolo;
    private TextInputLayout tilNameServer, tilPort, tilHostIp;
    private CheckBox chkFlagDefault;

    private  ImplServerRemote()
    {

    }

    public ImplServerRemote(Context value) {
        this.context = value;
        pref = new SettingPreferences(value);
        _servers = new ArrayList<BeanServerRemote>();
    }

    public void AddServer(BeanServerRemote server) throws Exception {
        Boolean lbExiste  = false;

        //Valido si el nombre del servidor existe o no
        for (BeanServerRemote bean: this._servers) {
            if(bean.getNombre().toUpperCase().equals(server.getNombre().toUpperCase())){
                throw new Exception("Servidor con nombre " + server.getNombre() + " ya existe, por favor corrija!");
            }
        }

        //Si el servidor esta activo verifico que no haya otro servidor activo
        if(server.getFlagDefault().equals("1"))
            if (ExisteServerDefault())
                throw new Exception("Ya existe un servidor por defecto, por favor corrija!");

        _servers.add(server);
    }

    public void saveToPreferences() {
        //Crea un json a partir de la lista de objetos.
        String jsonObjetos = new Gson().toJson(this._servers);

        //Crea preferencia
        pref.saveToPreferences(ImplServerRemote.KEY_PREFERENCE, jsonObjetos);
    }

    public void loadFromPrefererences() throws JSONException {
        String json;
        Type listType;

        json = pref.loadFromPreferences(ImplServerRemote.KEY_PREFERENCE);

        if(json == null){
            this._servers = new ArrayList<BeanServerRemote>();
        }else {
            //Convierte JSONArray a Lista de Objetos!
            listType = new TypeToken<ArrayList<BeanServerRemote>>(){}.getType();
            this._servers = new Gson().fromJson(json, listType);
        }

    }

    public List<BeanServerRemote> getServers() {
        return this._servers;
    }

    public void setServers(List<BeanServerRemote> value) {
        this._servers = value;
    }

    public void editServer(final BeanServerRemote item, final ServerRemoteActivity activity) {
        AlertDialog.Builder builderLocal = new AlertDialog.Builder(context);

        View layoutLocal;
        Button btnAceptar, btnCancelar;

        LayoutInflater inflater = ((Activity) context).getLayoutInflater();

        layoutLocal = inflater.inflate(R.layout.dialog_add_server, null);

        builderLocal.setView(layoutLocal);

        //Obtengo referencia a los Botones
        etNameServer = (EditText) layoutLocal.findViewById(R.id.etNameServer);
        etPort = (EditText) layoutLocal.findViewById(R.id.etPort);
        etHostIp = (EditText) layoutLocal.findViewById(R.id.etHostIp);
        spProtocolo = (Spinner) layoutLocal.findViewById(R.id.spProtocolo);
        chkFlagDefault = (CheckBox) layoutLocal.findViewById(R.id.chkFlagDefault);

        btnAceptar = (Button) layoutLocal.findViewById(R.id.btnAceptar);
        btnCancelar = (Button) layoutLocal.findViewById(R.id.btnCancelar);

        // Referencias TILs
        tilNameServer = (TextInputLayout) layoutLocal.findViewById(R.id.tilNameServer);
        tilHostIp = (TextInputLayout) layoutLocal.findViewById(R.id.tilHostIP);
        tilPort = (TextInputLayout) layoutLocal.findViewById(R.id.tilPort);
        ValidInputHelper.bindTree(layoutLocal);

        //Creo el adaptador
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(context,
                R.array.protocolos, android.R.layout.simple_spinner_item);

        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        spProtocolo.setAdapter(adapter);

        spProtocolo.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                Toast.makeText(parent.getContext(), "Protocolo seleccionado: " +
                        parent.getItemAtPosition(position).toString(), Toast.LENGTH_LONG).show();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        //Coloco los datos del item
        etNameServer.setText(item.getNombre());
        etPort.setText(item.getPort());
        etHostIp.setText(item.getHostIP());
        if (!item.getProtocolo().equals(null)) {
            int spinnerPosition = adapter.getPosition(item.getProtocolo());
            spProtocolo.setSelection(spinnerPosition);
        }
        if(item.getFlagDefault().equals("1"))
            chkFlagDefault.setChecked(true);
        else
            chkFlagDefault.setChecked(false);


        //Programo los Click de los botones
        builderLocal.setCancelable(false);

        final AlertDialog dialogLocal = builderLocal.create();

        btnCancelar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        //MessageBox.AlertDialog("Mensaje de advertencia", "Ha cancelado la operacion", context);
                        dialogLocal.dismiss();
                    }
                }
        );

        btnAceptar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        try {
                            BeanServerRemote bean = new BeanServerRemote();
                            bean.setNombre(etNameServer.getText().toString());
                            bean.setHostIP(etHostIp.getText().toString());
                            bean.setPort(etPort.getText().toString());
                            bean.setProtocolo(spProtocolo.getSelectedItem().toString());

                            if (chkFlagDefault.isChecked())
                                bean.setFlagDefault("1");
                            else
                                bean.setFlagDefault("0");

                            //Valido los datos
                            if (!validarDatos(bean)) return;

                            //Actualizo los datos del item
                            item.setNombre(bean.getNombre());
                            item.setHostIP(bean.getHostIP());
                            item.setPort(bean.getPort());
                            item.setProtocolo(bean.getProtocolo());
                            item.setFlagDefault(bean.getFlagDefault());

                            //obtengo el server por defecto
                            loadServerDefault();

                            if (SOAPClient.serverDefault == null){
                                MessageBox.AlertDialog(context, "No hay un servidor Remoto por defecto, por favor verifique!", "Error", true);
                                return;
                            }

                            if (activity != null) {
                                activity.setUpdate(true);
                                activity.ListarServidores();
                            }

                            dialogLocal.dismiss();


                        } catch (Exception ex) {
                            MessageBox.AlertDialog("Error al añadir Servidor. Mensaje: " + ex.getMessage(), "Error", context);
                        } finally {
                            //dialogLocal.dismiss();
                        }

                    }
                }

        );

        dialogLocal.show();

    }

    public void dialogAddServer(Context context) {
        this.dialogAddServer(context, true, null);
    }

    public void dialogAddServer(final Context context,  final boolean saveToPreferences, final ServerRemoteActivity activity) {

        AlertDialog.Builder builderLocal = new AlertDialog.Builder(context);

        View layoutLocal;
        Button btnAceptar, btnCancelar;

        LayoutInflater inflater = ((Activity) context).getLayoutInflater();

        layoutLocal = inflater.inflate(R.layout.dialog_add_server, null);

        builderLocal.setView(layoutLocal);

        //Obtengo referencia a los Botones
        btnAceptar = (Button) layoutLocal.findViewById(R.id.btnAceptar);
        btnCancelar = (Button) layoutLocal.findViewById(R.id.btnCancelar);
        etNameServer = (EditText) layoutLocal.findViewById(R.id.etNameServer);
        etPort = (EditText) layoutLocal.findViewById(R.id.etPort);
        etHostIp = (EditText) layoutLocal.findViewById(R.id.etHostIp);
        spProtocolo = (Spinner) layoutLocal.findViewById(R.id.spProtocolo);
        chkFlagDefault = (CheckBox) layoutLocal.findViewById(R.id.chkFlagDefault);

        // Referencias TILs
        tilNameServer = (TextInputLayout) layoutLocal.findViewById(R.id.tilNameServer);
        tilHostIp = (TextInputLayout) layoutLocal.findViewById(R.id.tilHostIP);
        tilPort = (TextInputLayout) layoutLocal.findViewById(R.id.tilPort);
        ValidInputHelper.bindTree(layoutLocal);

        //Creo el adaptador
        ArrayAdapter<CharSequence> adapter = ArrayAdapter.createFromResource(context,
                R.array.protocolos, android.R.layout.simple_spinner_item);

        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);

        spProtocolo.setAdapter(adapter);

        spProtocolo.setOnItemSelectedListener(new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                Toast.makeText(parent.getContext(), "Protocolo seleccionado: " +
                        parent.getItemAtPosition(position).toString(), Toast.LENGTH_LONG).show();
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        });

        //Programo los Click de los botones
        builderLocal.setCancelable(false);

        final AlertDialog dialogLocal = builderLocal.create();

        btnCancelar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        //MessageBox.AlertDialog("Mensaje de advertencia", "Ha cancelado la operacion", context);
                        dialogLocal.dismiss();
                    }
                }
        );

        btnAceptar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        BeanServerRemote bean;

                        try {
                            bean = new BeanServerRemote();
                            bean.setNombre(etNameServer.getText().toString());
                            bean.setHostIP(etHostIp.getText().toString());
                            bean.setPort(etPort.getText().toString());
                            bean.setProtocolo(spProtocolo.getSelectedItem().toString());

                            if (chkFlagDefault.isChecked())
                                bean.setFlagDefault("1");
                            else
                                bean.setFlagDefault("0");

                            //Valido los datos
                            if (!validarDatos(bean)) return;

                            //Añado el server
                            AddServer(bean);

                            if (saveToPreferences) {
                                //guardo el server en la coniguracion
                                saveToPreferences();
                            }

                            //obtengo el server por defecto
                            loadServerDefault();

                            if(context instanceof LoginActivity)
                            {
                                ((LoginActivity) context).LoadServerDefault();
                            }

                            if (SOAPClient.serverDefault == null){
                                MessageBox.AlertDialog(context, "No hay un servidor Remoto por defecto, por favor verifique!", "Error", true);
                                return;
                            }

                            if (activity != null) {
                                activity.setUpdate(true);
                                activity.ListarServidores();
                            }

                            dialogLocal.dismiss();


                        } catch (Exception ex) {
                            MessageBox.AlertDialog("Error al añadir Servidor. Mensaje: " + ex.getMessage(), "Error", context);
                        } finally {
                            //dialogLocal.dismiss();
                        }

                    }
                }

        );

        dialogLocal.show();

    }

    public BeanServerRemote loadServerDefault() {
        SOAPClient.serverDefault = null;

        for (BeanServerRemote bean: this.getServers()) {
            if (bean.getFlagDefault().equals("1")){
                SOAPClient.serverDefault = bean;
                return bean;
            }
        }

        return null;
    }

    public void messageAddServer(final Context context) {

        AlertDialog.Builder builder;
        builder = new AlertDialog.Builder(context);
        builder.setTitle("Error al cargar aplicación");
        builder.setMessage("No existe ningún servidor Remoto activo");
        builder.setPositiveButton("OK", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                dialogAddServer(context);
                dialog.cancel();
            }
        });
        builder.setCancelable(false);
        builder.create();
        builder.show();
    }

    private boolean validarDatos(BeanServerRemote bean) {
        boolean lbReturn = true;

        if (!UTIL.validarTexto(bean.getNombre())) {
            tilNameServer.setError("Nombre de Servidor inválido");
            lbReturn = false;
        }else
            tilNameServer.setError(null);

        if (!UTIL.validarTexto(bean.getHostIP())) {
            tilHostIp.setError("Nombre del Host o IP Invalido");
            lbReturn = false;
        }else
            tilHostIp.setError(null);

        if (!UTIL.validarTexto(bean.getPort())) {
            tilPort.setError("Puerto invalido");
            lbReturn = false;
        }else
            tilPort.setError(null);

        if (!UTIL.validarTexto(bean.getProtocolo())) {
            MessageBox.AlertDialog(context, "Protocolo incorrecto.", "Error", false);
            return false;
        }

        return lbReturn;


    }

    public void dialogServerDefault(final Context context) throws Exception {
        View layoutLocal;

        //Controles
        Button btnListado, btnCerrar;
        TextView tvNameServer, tvHostIP, tvPort, tvProtocolo, tvServerDefault;

        //Bean Server Remote
        BeanServerRemote beanServerRemote;

        this.context = context;

        AlertDialog.Builder builderLocal = new AlertDialog.Builder(context);


        LayoutInflater inflater = ((Activity) context).getLayoutInflater();
        layoutLocal = inflater.inflate(R.layout.dialog_server_default, null);
        builderLocal.setView(layoutLocal);
        builderLocal.setCancelable(false);

        //Obtengo referencia a los Botones
        btnListado = (Button) layoutLocal.findViewById(R.id.btnListado);
        btnCerrar = (Button) layoutLocal.findViewById(R.id.btnCerrar);

        //Acceso a los TextViews
        tvNameServer = (TextView) layoutLocal.findViewById(R.id.tvNameServer);
        tvHostIP = (TextView) layoutLocal.findViewById(R.id.tvHostIP);
        tvPort = (TextView) layoutLocal.findViewById(R.id.tvPort);
        tvProtocolo = (TextView) layoutLocal.findViewById(R.id.tvProtocolo);
        tvServerDefault = (TextView) layoutLocal.findViewById(R.id.tvServerDefault);

        //Coloco los datos necesarios
        beanServerRemote = SOAPClient.serverDefault;

        if (beanServerRemote == null) {
            MessageBox.AlertDialog(context, "Error", "No se ha especificado un Server Remote por defecto", false);
        }else{
            //Lleno los textViews
            tvNameServer.setText(beanServerRemote.getNombre());
            tvHostIP.setText(beanServerRemote.getHostIP());
            tvPort.setText(beanServerRemote.getPort());
            tvProtocolo.setText(beanServerRemote.getProtocolo());

            if (beanServerRemote.getFlagDefault().equals("1"))
                tvServerDefault.setText("SI");
            else
                tvServerDefault.setText("NO");
        }

        //Programo los Click de los botones
        final AlertDialog dialogLocal = builderLocal.create();

        btnCerrar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        dialogLocal.dismiss();
                    }
                }
        );

        btnListado.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        try {
                            Intent intent = new Intent(context, ServerRemoteActivity.class);
                            context.startActivity(intent);

                            if(context instanceof LoginActivity){
                                ((LoginActivity) context).finish();
                            }

                            dialogLocal.dismiss();


                        } catch (Exception ex) {
                            MessageBox.AlertDialog("Error al abrir el listado. Mensaje: " + ex.getMessage(), "Error", context);

                        } finally {

                        }

                    }
                }

        );

        dialogLocal.show();
    }

    public void deleteServer(BeanServerRemote item) {
        BeanServerRemote beanSelected = null;
        for (BeanServerRemote bean: this._servers) {
            if (bean.getNombre().toUpperCase().equals(item.getNombre().toUpperCase())){
                beanSelected = bean;
                break;
            }
        }

        if (beanSelected != null)
            this._servers.remove(beanSelected);
    }

    public void confirmSave(final ServerRemoteActivity activity) {

        String lsMensaje = "";

        //Valido si hay algun servidor por defecto
        if (!ExisteServerDefault()){
            //MessageBox.AlertDialog(activity, "Error", "No existe ningun servidor por defecto, por favor corrija", false);
            lsMensaje = "No existe ningun servidor remoto por defecto. ¿Desea grabar de todas maneras?";
        }else if (this._servers.size() == 0){
            lsMensaje = "No existe ningun servidor remoto por defecto. ¿Desea grabar de todas maneras?";
        }else
            lsMensaje = "¿Desea guardar los cambios realizados?";

        //Procesdo a hacer el cuadro de dialogo para confirmar
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);

        builder.setMessage(lsMensaje);
        builder.setTitle("Confirmacion de grabación");
        builder.setCancelable(false);

        builder.setPositiveButton("SI", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                try {
                    saveToPreferences();

                    loadFromPrefererences();

                    activity.setUpdate(false);
                    dialog.cancel();

                }catch(Exception ex){
                    MessageBox.AlertDialog(activity, "Error al grabar", "Ha ocurrido un error: " + ex.getMessage(), false);
                }

        }
        });
        builder.setNegativeButton("NO", new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                dialog.cancel();
            }
        });
        builder.create();
        builder.show();

    }

    public boolean ExisteServerDefault() {
        Boolean lbReturn = false;
        for (BeanServerRemote bean:this._servers) {
            if (bean.getFlagDefault().equals("1")){
                lbReturn = true;
                break;
            }
        }
        return lbReturn;
    }

}

