package pe.com.sytco.fastsales.Dialog;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.util.Base64;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenTomaInventarioActivity;
import pe.com.sytco.fastsales.Controller.Almacen.ImplAlmacen;
import pe.com.sytco.fastsales.Controller.Compras.ImplArticulo;
import pe.com.sytco.fastsales.Controller.ImplConfiguracion;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplInventarioConteo;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.beans.BeanUsuario;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;


public class DialogArticuloConfirm {

    //Cuadro de dialogo para Ver detalles del articulo
    private Context context;

    private AlertDialog.Builder builder;
    private View dialoglayout;
    private AlertDialog dialogMain;

    //Controles para el detalle de los articulos
    private TextView tvCodArt, tvDescArt, tvMarca, tvStock, tvUnidad1, tvUnidad2, tvRutaFoto,
                     tvCodSKU, tvCodigoCU;
    private ImageView ivImagen;
    private Button btnCerrar, btnAceptar;
    private ImageButton ibTomarFoto, ibGuardarFoto;

    //BeanSeleccionado
    private BeanArticulo articuloSelected;

    //Variables
    private Uri uriImagenPath;

    private DialogArticuloConfirm(){

    }

    public DialogArticuloConfirm(Context value){
        this.context = value;
    }
    public void ConfirmDialog(){


        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((AlmacenTomaInventarioActivity)context).getLayoutInflater();

        dialoglayout = inflater.inflate(R.layout.dialog_confirm_articulo, null);

        InitControllers();

        AsignarEventos();

        FillData();

        builder.setView(dialoglayout);


        //Creo el cuadro de dialogo
        builder.setCancelable(false);

        dialogMain = builder.create();



        //Activo la opcion de cierre
        btnCerrar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        dialogMain.dismiss();
                    }
                }
        );


        dialogMain.show();

    }


    private void InitControllers(){
        //Obtengo referencia a los controles
        tvCodArt = (TextView) dialoglayout.findViewById(R.id.tvCodArt);
        tvDescArt = (TextView) dialoglayout.findViewById(R.id.tvDescArt);
        tvMarca = (TextView) dialoglayout.findViewById(R.id.tvMarca);
        tvStock = (TextView) dialoglayout.findViewById(R.id.tvStock);
        tvUnidad1 = (TextView) dialoglayout.findViewById(R.id.tvUnidad1);
        tvUnidad2 = (TextView) dialoglayout.findViewById(R.id.tvUnidad2);
        tvRutaFoto = (TextView) dialoglayout.findViewById(R.id.tvRutaFoto);
        tvCodSKU = (TextView) dialoglayout.findViewById(R.id.tvCodSKU);
        tvCodigoCU = (TextView) dialoglayout.findViewById(R.id.tvCodigoCU);

        ivImagen = (ImageView)dialoglayout.findViewById(R.id.ivImagen);

        //Botones
        btnCerrar = (Button) dialoglayout.findViewById(R.id.btnCerrar);
        btnAceptar = (Button) dialoglayout.findViewById(R.id.btnAceptar);
        ibTomarFoto = (ImageButton) dialoglayout.findViewById(R.id.ibTomarFoto);
        ibGuardarFoto = (ImageButton) dialoglayout.findViewById(R.id.ibGuardarFoto);

        ibGuardarFoto.setVisibility(ImageButton.GONE);
    }

    private void AsignarEventos() {
        ibTomarFoto.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                TomarFoto();
            }
        });

        ibGuardarFoto.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                try {
                    GuardarFoto();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        });

        //Activo la opcion de cierre
        btnAceptar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        guardarInventarioConteo();
                        //dialog.dismiss();
                    }
                }
        );
    }

    private void FillData() {
        //Asigno la data necesaria
        if(articuloSelected.getCodSKU() != null)
            tvCodSKU.setText(articuloSelected.getCodSKU());
        else
            tvCodSKU.setText("");

        //Asigno la data necesaria
        if(articuloSelected.getCodigoCU() != null)
            tvCodigoCU.setText(articuloSelected.getCodigoCU());
        else
            tvCodigoCU.setText("");

        if(articuloSelected.getCodArt() != null)
            tvCodArt.setText(articuloSelected.getCodArt());
        else
            tvCodArt.setText("");

        if(articuloSelected.getDescArticulo() != null)
            tvDescArt.setText(articuloSelected.getDescArticulo());
        else
            tvDescArt.setText("");

        if(articuloSelected.getMarca() != null)
            tvMarca.setText(articuloSelected.getMarca().getNomMarca());
        else
            tvMarca.setText("");

        if(articuloSelected.getSaldoTotal() != null)
            tvStock.setText(UTIL.ConvetToString(articuloSelected.getSaldoTotal(), "###,##0.00"));
        else
            tvStock.setText("0.00");

        if(articuloSelected.getUnd() != null) {
            tvUnidad1.setText(articuloSelected.getUnd());
            tvUnidad2.setText(articuloSelected.getUnd());
        }else{
            tvUnidad1.setText("");
            tvUnidad2.setText("");
        }

        //Asignación de la imagen
        if (articuloSelected.getImagen() != null) {
            UTIL.setImageViewWithByteArray(ivImagen, articuloSelected.getImagen());
        }
        else {
            ivImagen.setImageResource(R.drawable.noimagen);
        }
    }

    private void guardarInventarioConteo() {
        String  ls_fechaConteo, ls_CodArt, ls_Almacen, ls_Ubicacion, ls_CodigoCU;
        Integer liNroConteo;
        AlmacenTomaInventarioActivity activity = (AlmacenTomaInventarioActivity) context;

        ls_fechaConteo = activity.getFechaConteo();
        ls_CodArt = articuloSelected.getCodArt();
        ls_CodigoCU = articuloSelected.getCodigoCU();
        ls_Almacen = activity.getAlmacen();
        ls_Ubicacion = activity.getUbicacion();
        liNroConteo = activity.getNroUbicacion();

        if (articuloSelected.getTieneFoto().equals("0")){
            UTIL.SonidoPopup(context);
            MessageBox.AlertDialog(context, "Advertencia", "El articulo indicado no " +
                        "tiene foto, debe asignarle primero una Foto antes de guardar su inventario", false);
        }else{
            new SaveInventarioConteoTask(ls_CodArt, ls_fechaConteo, ls_Almacen, liNroConteo, ls_Ubicacion, ls_CodigoCU).execute();
        }

    }

    private void TomarFoto() {
        AlmacenTomaInventarioActivity activity = (AlmacenTomaInventarioActivity) context;
                /*
                activity.setImagenView(ivImagen);

                Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
                if (takePictureIntent.resolveActivity(activity.getPackageManager()) != null) {
                    activity.startActivityForResult(takePictureIntent, UTIL.REQUEST_IMAGE_CAPTURE);
                }
                */
        try {
            String ruta_fotos = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES) + "/HermesFotos/";
            File ruta = new File(ruta_fotos);

            //Creo la ruta completa
            ruta.mkdirs();
            String filePath = ruta_fotos + UTIL.getCode() + ".jpg";

            File mi_foto = new File( filePath );

            mi_foto.createNewFile();


            uriImagenPath = Uri.fromFile( mi_foto );

            activity.setUriImagenPath(uriImagenPath);
            activity.setImagenView(ivImagen);
            activity.setRutaFoto(tvRutaFoto);
            activity.setBtnGuardarFoto(ibGuardarFoto);

            //Abre la camara para tomar la foto
            Intent cameraIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
            //Guarda imagen
            cameraIntent.putExtra(MediaStore.EXTRA_OUTPUT, uriImagenPath);

            //Si estas usando una versión mayor a 24 entonces se ejecuta este codigo
            if(Build.VERSION.SDK_INT>=24){
                try{
                    Method m = StrictMode.class.getMethod("disableDeathOnFileUriExposure");
                    m.invoke(null);
                }catch(Exception e){
                    e.printStackTrace();
                }
            }

            //Retorna a la actividad
            activity.startActivityForResult(cameraIntent, 0);
        } catch (IOException ex) {
            System.out.println(ex.getMessage());

        }
    }

    private void GuardarFoto() throws IOException {
        grabarImagen();
    }

    private void grabarImagen() throws IOException {
        Bitmap imageBitmap;

        imageBitmap = MediaStore.Images.Media.getBitmap(context.getContentResolver(), uriImagenPath);

        new SaveImagenTask(articuloSelected, imageBitmap).execute();
    }

    public void openDialog(String strSKU, BeanArticulo instanceArticulo){
        new ValidarSKUTask(strSKU, instanceArticulo).execute();
    }

    //Clase Asincrona para tareas en segundo plano
    private class ValidarSKUTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, _strSKU;
        Boolean lbExiste, lbCodigoCU = false;
        ImplAlmacen implAlmacen;
        ImplArticulo implArticulo;
        ImplInventarioConteo implInventarioConteo;
        private ProgressDialog pDialog;
        BeanArticulo _instanceArticulo;
        String  ls_fechaConteo, ls_Almacen, ls_CodigoCU, ls_NroConteo, ls_Ubicacion;

        public ValidarSKUTask(String value, BeanArticulo instanceArticulo) {
            this._strSKU = value;
            this._instanceArticulo = instanceArticulo;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            if (this._instanceArticulo != null){
                pDialog.setMessage("Buscando el CODIGO CU [" + this._strSKU + "] por favor espere...");
            }else{
                pDialog.setMessage("Buscando el CODIGO CU, SKU o CODIGO DE ARTICULO [" + this._strSKU + "] por favor espere...");
            }

            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {

            try {
                AlmacenTomaInventarioActivity activity = (AlmacenTomaInventarioActivity) context;

                if (ImplEmpresa.empresaDefault == null) {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }
                //LLenado de Lista para los articulos
                implAlmacen = new ImplAlmacen(ImplEmpresa.empresaDefault.getCodigo());
                implArticulo = new ImplArticulo(ImplEmpresa.empresaDefault.getCodigo());
                implInventarioConteo = new ImplInventarioConteo(ImplEmpresa.empresaDefault.getCodigo());

                lbExiste = true;

                if (_instanceArticulo != null){
                    lbCodigoCU = true;

                    ls_fechaConteo = activity.getFechaConteo();
                    ls_CodigoCU = _instanceArticulo.getCodigoCU();
                    ls_Almacen = activity.getAlmacen();
                    ls_NroConteo = activity.getNroConteo();

                    if (!implAlmacen.existeCU(ls_CodigoCU)){
                        mensaje = "No existe el CODIGO CU " + _instanceArticulo.getCodigoCU();
                        lbExiste = false;
                        return false;
                    }

                    if (implInventarioConteo.existeInventarioCU(ls_Almacen, ls_fechaConteo, ls_NroConteo, ls_CodigoCU)){
                        //Si existe entonces debo obtener la ubicacion del mismo
                        ls_Ubicacion = implInventarioConteo.getUbicacion(ls_Almacen, ls_fechaConteo, ls_NroConteo, ls_CodigoCU);

                        mensaje = "El CODIGO CU " + ls_CodigoCU + " ya se encuentra inventariado para los datos."
                                + "\nAlmacen: " + ls_Almacen
                                + "\nFecha Conteo: " + ls_fechaConteo
                                + "\nNro Conteo: " + ls_NroConteo
                                + "\nUbicacion: " + ls_Ubicacion;
                        lbExiste = false;
                        return false;
                    }

                    if (lbExiste){
                        articuloSelected = implArticulo.getByCodigoCU(_instanceArticulo.getCodigoCU()).get(0);
                    }else{
                        mensaje = "No existe el CODIGO CU " + _instanceArticulo.getCodigoCU();
                    }

                }else{
                    if (implArticulo.isCodigoCU(_strSKU)){
                        lbCodigoCU = true;

                        ls_fechaConteo = activity.getFechaConteo();
                        ls_CodigoCU = _strSKU;
                        ls_Almacen = activity.getAlmacen();
                        ls_NroConteo = activity.getNroConteo();

                        if (implInventarioConteo.existeInventarioCU(ls_Almacen, ls_fechaConteo, ls_NroConteo, ls_CodigoCU)){
                            //Si existe entonces debo obtener la ubicacion del mismo
                            ls_Ubicacion = implInventarioConteo.getUbicacion(ls_Almacen, ls_fechaConteo, ls_NroConteo, ls_CodigoCU);

                            mensaje = "El CODIGO CU " + ls_CodigoCU + " ya se encuentra inventariado para los datos."
                                    + "\nAlmacen: " + ls_Almacen
                                    + "\nFecha Conteo: " + ls_fechaConteo
                                    + "\nNro Conteo: " + ls_NroConteo
                                    + "\nUbicacion: " + ls_Ubicacion;
                            lbExiste = false;
                            return false;
                        }

                        articuloSelected = implArticulo.getByCodigoCU(_strSKU).get(0);

                    }else {
                        lbCodigoCU = false;

                        lbExiste = implAlmacen.existeSKU(_strSKU);

                        if (lbExiste) {
                            articuloSelected = implArticulo.getBySKU(_strSKU).get(0);
                        } else {
                            mensaje = "No existe el CODIGO o SKU " + _strSKU;
                        }
                    }
                }

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Cargar datos para el Codigo Ingresado: " + ex.getMessage();
                lbExiste = false;
                ex.printStackTrace();
                return false;
            } finally {
                implAlmacen = null;
                implArticulo = null;
                implInventarioConteo = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            MediaPlayer mp;
            try {
                ((AlmacenTomaInventarioActivity) context).setLectura("");
                if (!lbExiste || !result) {

                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog(context, "Error en consulta", mensaje, false);

                    //Toast.makeText(context, mensaje, Toast.LENGTH_LONG).show();
                    ((AlmacenTomaInventarioActivity) context).setNextFocus();

                }else{
                    if (articuloSelected != null){
                        ((AlmacenTomaInventarioActivity) context).setUltimoSKU(articuloSelected.getCodSKU());
                        if (articuloSelected.getCodigoCU() != null && !articuloSelected.getCodigoCU().trim().equals(""))
                            ((AlmacenTomaInventarioActivity) context).setUltimoCU(articuloSelected.getCodSKU());
                        else
                            ((AlmacenTomaInventarioActivity) context).setUltimoCU("");
                    }else{
                        ((AlmacenTomaInventarioActivity) context).setUltimoSKU("");
                        ((AlmacenTomaInventarioActivity) context).setUltimoCU("");
                    }

                    UTIL.SonidoCorrecto(context);
                    ConfirmDialog();
                    ((AlmacenTomaInventarioActivity) context).setNextFocus();


                }

            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                mp = null;
                try {
                    // dismiss the dialog after getting all products
                    pDialog.dismiss();
                    ((AlmacenTomaInventarioActivity) context).setNextFocus();

                } catch (Exception ex) {
                }

            }

        }
    }

    //Clase Asincrona para tareas en segundo plano
    private class SaveImagenTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        ImplArticulo implArticulo = null;
        private ProgressDialog pDialog;
        private BeanArticulo articuloSelected;
        private Bitmap bitmapImagen;

        public SaveImagenTask(BeanArticulo v1, Bitmap v2){
            this.articuloSelected = v1;
            this.bitmapImagen = v2;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Un momento, se esta almacenando la imagen...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            String base64 = "";
            byte[] byteArray = null;
            ByteArrayOutputStream stream = null;

            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }
                //LLenado de Lista para los articulos
                implArticulo = new ImplArticulo(ImplEmpresa.empresaDefault.getCodigo());

                // Pago el bitmap a base64
                stream = new ByteArrayOutputStream();
                bitmapImagen.compress(Bitmap.CompressFormat.PNG, 80, stream);
                byteArray = stream.toByteArray();
                base64 = Base64.encodeToString(byteArray, Base64.DEFAULT);

                implArticulo.saveImagen(articuloSelected.getCodArt(), base64);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Grabar imagen en Articulo. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implArticulo = null;
                base64 = null;
                byteArray = null;
                if (stream != null) {
                    try {
                        stream.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {
                if (result) {
                    UTIL.SonidoPopup(context);
                    ibGuardarFoto.setVisibility(ImageButton.GONE);
                    articuloSelected.setTieneFoto("1");
                    MessageBox.AlertDialog("Foto Guardada correctamente", "Foto", context);
                }
                else{
                    MessageBox.AlertDialog("Ha ocurrido un error al almacenar la foto. Mensaje: " + mensaje, "Foto", context);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    pDialog.dismiss();

                } catch (Exception ex) {
                }

            }

        }

    }

    //Clase Asincrona para tareas en segundo plano
    private class SaveInventarioConteoTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        ImplInventarioConteo implInventarioConteo = null;
        ImplConfiguracion implConfiguracion = null;
        private ProgressDialog pDialog;
        BeanUsuario userLogin = null;
        AlmacenTomaInventarioActivity activity = (AlmacenTomaInventarioActivity) context;

        String  ls_fechaConteo, ls_CodArt, ls_Almacen, ls_Ubicacion, ls_ShowMessage = "", ls_CodigoCU;
        Integer liNroConteo;


        public SaveInventarioConteoTask(String pCodArt,
                                        String fechaConteo,
                                        String pAlmacen,
                                        Integer pNroConteo,
                                        String pUbicacion,
                                        String pCodigoCU){

            this.ls_fechaConteo = fechaConteo;
            this.ls_CodArt = pCodArt;
            this.ls_Almacen = pAlmacen;
            this.ls_Ubicacion = pUbicacion;
            this.liNroConteo = pNroConteo;
            this.ls_CodigoCU = pCodigoCU;

        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Un momento, se esta almacenando el inventario por conteo...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {

            try {
                if(ImplEmpresa.empresaDefault == null)
                {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }

                //Guardo el usuario que se ha logueado
                final GlobalClass globalVariable = (GlobalClass) context.getApplicationContext();
                userLogin = globalVariable.getUserLogin();

                //LLenado de Lista para los articulos
                implInventarioConteo    = new ImplInventarioConteo(ImplEmpresa.empresaDefault.getCodigo());
                implConfiguracion       = new ImplConfiguracion(ImplEmpresa.empresaDefault.getCodigo());

                ls_ShowMessage = implConfiguracion.getParametro("MOVIL_SHOW_MESSAGE_AFTER_INVENTARIO_CONTEO", "1");

                if (ls_CodigoCU == null)
                    implInventarioConteo.Insertar( ls_CodArt, ls_fechaConteo, ls_Almacen, liNroConteo, ls_Ubicacion, userLogin.getUsuario());
                else
                    implInventarioConteo.InsertarWithCU(ls_CodArt, ls_fechaConteo, ls_Almacen, liNroConteo, ls_Ubicacion, ls_CodigoCU, userLogin.getUsuario());

                return true;

            } catch (Exception ex) {
                mensaje = "Error al Grabar el Inventario por conteo. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                implInventarioConteo = null;
                implConfiguracion = null;
                userLogin  = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {

            try {
                if (result) {
                    UTIL.SonidoPopup(context);
                    if (ls_ShowMessage.equals("1")) {
                        //MessageBox.AlertDialog("Datos guardados correctamente", "Inventario por conteo", context);
                        final AlertDialog alertDialog = new AlertDialog.Builder(context).create();

                        alertDialog.setTitle("Inventario por conteo");

                        alertDialog.setMessage("Datos guardados correctamente");

                        alertDialog.setIcon(R.drawable.exito);

                        alertDialog.setButton("Cerrar", new DialogInterface.OnClickListener() {
                            public void onClick(DialogInterface dialog, int which) {
                                dialogMain.dismiss();
                                activity.ActualizarInventarioConteo();
                            }
                        });

                        alertDialog.show();

                        //Espero un segundo para que cierre todo
                        final Handler handler = new Handler();
                        final Runnable runnable = new Runnable() {
                            @Override public void run() {
                                if (alertDialog.isShowing()) {
                                    alertDialog.dismiss();
                                    dialogMain.dismiss();
                                    activity.ActualizarInventarioConteo();
                                }
                            }
                        };

                        alertDialog.setOnDismissListener(new DialogInterface.OnDismissListener() {
                            @Override public void onDismiss(DialogInterface dialog) {
                                handler.removeCallbacks(runnable);
                            }
                        });

                        handler.postDelayed(runnable, 1500);

                    }else{
                        activity.ActualizarInventarioConteo();
                        //Toast.makeText(context, "Datos guardados correctamente", Toast.LENGTH_LONG);
                        activity.setMensaje("Articulo [" + articuloSelected.getCodSKU() + "] guardado satisfactoriamente");
                        dialogMain.dismiss();
                    }

                }
                else{
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog("Ha ocurrido un error al almacenar los datos. Mensaje: " + mensaje, "Foto", context);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {

                try {
                    // dismiss the dialog after getting all products
                    pDialog.dismiss();

                } catch (Exception ex) {
                }

            }

        }

    }
}
