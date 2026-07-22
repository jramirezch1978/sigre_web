package pe.com.sytco.fastsales.Dialog;

import android.Manifest;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.util.Base64;
import android.view.ContextThemeWrapper;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.core.content.ContextCompat;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenParteRecepcionPopupActivity;
import pe.com.sytco.fastsales.Controller.Compras.ImplArticulo;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.Ancestors.AncestorUI;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanParteIngresoDet;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogChangeFoto {
    private Context context;

    private AlertDialog.Builder builder;
    private View dialoglayout;
    private AlertDialog dialogMain;

    //Controles de la Interfaz
    private ImageView ivImagen;
    private Button btnSalir;
    private TextView tvRutaFoto, tvResolucion;
    private ImageButton ibTomarFoto, ibGuardarFoto;

    //Variables
    private Uri uriImagenPath;

    private BeanArticulo _beanArticulo = null;
    private BeanParteIngresoDet _Registro = null;

    private DialogChangeFoto(){

    }

    public DialogChangeFoto(Context value){
        this.context = value;
    }

    public void openDialog(BeanParteIngresoDet row) {
        _Registro = row;
        new LoadDataTask(_Registro).execute();
    }

    public void showDialog(){


        builder = new AlertDialog.Builder(new ContextThemeWrapper(context, R.style.MyDialogTheme));//context, R.style.DialogTheme);

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        dialoglayout = inflater.inflate(R.layout.dialog_change_foto, null);



        InitControllers();

        AsignarEventos();

        LoadDefaultData();

        builder.setView(dialoglayout);


        //Creo el cuadro de dialogo
        builder.setCancelable(false);

        dialogMain = builder.create();



        //Activo la opcion de cierre
        btnSalir.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        dialogMain.dismiss();
                    }
                }
        );


        dialogMain.show();

    }

    private void InitControllers() {
        ivImagen = (ImageView)dialoglayout.findViewById(R.id.ivImagen);
        tvRutaFoto = (TextView) dialoglayout.findViewById(R.id.tvRutaFoto);
        tvResolucion = (TextView) dialoglayout.findViewById(R.id.tvResolucion);
        ibTomarFoto = (ImageButton) dialoglayout.findViewById(R.id.ibTomarFoto);
        ibGuardarFoto = (ImageButton) dialoglayout.findViewById(R.id.ibGuardarFoto);

        //Botones
        btnSalir = (Button) dialoglayout.findViewById(R.id.btnSalir);

        ibGuardarFoto.setVisibility(View.GONE);
        tvRutaFoto.setText("");
        tvResolucion.setText("");

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

    }

    private void LoadDefaultData() {
        //Asignación de la imagen
        if (_beanArticulo.getImagen() != null) {
            UTIL.setImageViewWithByteArray(ivImagen, _beanArticulo.getImagen());
            Bitmap bitmap = UTIL.getBitmap(_beanArticulo.getImagen());

            tvResolucion.setText(String.valueOf(bitmap.getWidth()) + " x " + String.valueOf(bitmap.getHeight()));

        }
        else {
            ivImagen.setImageResource(R.drawable.noimagen);
        }

    }

    //Funciones para tomar foto
    private void TomarFoto() {
        AlmacenParteRecepcionPopupActivity activity = (AlmacenParteRecepcionPopupActivity)context;

        try {

            if (ContextCompat.checkSelfPermission(context, Manifest.permission.WRITE_EXTERNAL_STORAGE)
                    != PackageManager.PERMISSION_GRANTED) {
                // Permission is not granted
                MessageBox.AlertDialog(context, "Error de Escritura", "No tiene acceso a escribir en disco, por favor verifique!", false);
                return;
            }

            if (ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA)
                    != PackageManager.PERMISSION_GRANTED) {
                // Permission is not granted
                MessageBox.AlertDialog(context, "Error de Escritura", "No tiene acceso a la CAMARA FOTOGRAFICA, por favor verifique!", false);
                return;
            }

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
            activity.setTvResolucion(tvResolucion);

            tvRutaFoto.setText(filePath);

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
        Bitmap imagenOriginal, imagenFinal;
        float proporcion;

        imagenOriginal = MediaStore.Images.Media.getBitmap(context.getContentResolver(), uriImagenPath);

        // Dividimos el ancho final por el ancho de la imagen original
        proporcion = AncestorUI.widthImageFinal / (float) imagenOriginal.getWidth();

        // y después multiplicamos el resultado por la altura de la imagen original
        // para conseguir la altura final
        imagenFinal = Bitmap.createScaledBitmap(imagenOriginal, (int) AncestorUI.widthImageFinal, (int) (imagenOriginal.getHeight() * proporcion),false);


        new SaveImagenTask(_Registro, imagenFinal).execute();
    }


    //Clase Asincrona para tareas en segundo plano
    private class LoadDataTask extends AsyncTask<Integer, Void, Boolean> {
        private String mensaje = "";
        private ProgressDialog pDialog;
        private BeanParteIngresoDet _Row = null;
        private ImplArticulo _implArticulo = null;

        private LoadDataTask(){

        }


        public LoadDataTask(BeanParteIngresoDet value) {
            this._Row = value;

        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Buscando la imagen para los datos ingresados por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {

            try {
                Activity activity = (Activity) context;

                if (ImplEmpresa.empresaDefault == null) {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }
                //LLenado de Lista para los articulos
                _implArticulo = new ImplArticulo(ImplEmpresa.empresaDefault.getCodigo());

                _beanArticulo = _implArticulo.getImagenGrupal(_Row);

                return true;

            } catch (Exception ex) {
                mensaje = "Error al cargar el archivo de la FOTO con los datos ingresados. Mensaje: " + ex.getMessage();
                ex.printStackTrace();
                return false;
            } finally {
                _implArticulo = null;
                System.gc();
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            MediaPlayer mp;
            try {
                if (!result){
                    UTIL.SonidoError(context);
                    MessageBox.AlertDialog(context, "Ha ocurrido una exception", mensaje, false);
                }else{
                    UTIL.SonidoCorrecto(context);
                    showDialog();
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

    //Clase Asincrona para Grabar Imagenes en Segundo Plano
    private class SaveImagenTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje;
        ImplArticulo implArticulo = null;
        private ProgressDialog pDialog;
        private BeanParteIngresoDet _rowSelected;
        private Bitmap bitmapImagen;

        public SaveImagenTask(BeanParteIngresoDet v1, Bitmap v2) {
            this._rowSelected = v1;
            this.bitmapImagen = v2;
        }

        protected void onPreExecute() {
            super.onPreExecute();
            pDialog = new ProgressDialog(context);
            pDialog.setMessage("Un momento, se esta almacenando la imagen capturada...");
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

                implArticulo.saveImagenGrupal(_rowSelected, base64);

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
                    //_rowSelected.setTieneFoto("1");
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



}
