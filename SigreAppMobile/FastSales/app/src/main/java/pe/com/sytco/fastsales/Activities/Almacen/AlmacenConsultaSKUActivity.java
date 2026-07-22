package pe.com.sytco.fastsales.Activities.Almacen;

import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Build;
import android.os.Environment;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.os.Bundle;
import android.util.Base64;
import android.view.KeyEvent;
import android.view.MenuItem;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.appcompat.app.AppCompatActivity;

import com.google.android.material.bottomnavigation.BottomNavigationView;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.Method;
import java.util.List;

import pe.com.sytco.fastsales.Activities.HomeActivity;
import pe.com.sytco.fastsales.Controller.Almacen.ImplAlmacen;
import pe.com.sytco.fastsales.Controller.Compras.ImplArticulo;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Compras.BeanArticulo;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class AlmacenConsultaSKUActivity extends AppCompatActivity {
    //Controles de la interfaz
    private BottomNavigationView navigation;
    private EditText etCodigoSKU;
    private Button btnLeerCodigo;

    //Controles para el detalle de los articulos
    private TextView tvCodArt, tvDescArt, tvMarca, tvStock, tvUnidad1, tvUnidad2, tvRutaFoto,
                     tvCodSKU, tvCantidadInventario;
    private ImageView ivImagen;
    private Button btnSalir;
    private ImageButton ibTomarFoto, ibGuardarFoto;

    //Variables
    private Uri uriImagenPath;
    private BeanArticulo articuloSelected;
    private boolean ibTieneFoto = false;
    
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_almacen_consulta_sku);

        //Referencia a controles
        InitControllers();

        //Cargo la data correspondiente
        LoadDataDefault();

        //Asigno los eventos
        AsignaEventos();

        etCodigoSKU.requestFocus();
    }

    private void InitControllers() {
        navigation = (BottomNavigationView) findViewById(R.id.navigation);

        btnLeerCodigo = (Button) findViewById(R.id.btnLeerCodigo);
        etCodigoSKU= (EditText) findViewById(R.id.etCodigoSKU);
        btnSalir = (Button) findViewById(R.id.btnSalir);

        //Obtengo referencia a los controles
        tvCodArt = (TextView) findViewById(R.id.tvCodArt);
        tvDescArt = (TextView) findViewById(R.id.tvDescArt);
        tvMarca = (TextView) findViewById(R.id.tvMarca);
        tvStock = (TextView) findViewById(R.id.tvStock);
        tvUnidad1 = (TextView) findViewById(R.id.tvUnidad1);
        tvUnidad2 = (TextView) findViewById(R.id.tvUnidad2);
        tvRutaFoto = (TextView) findViewById(R.id.tvRutaFoto);
        tvCodSKU = (TextView) findViewById(R.id.tvCodSKU);
        tvCantidadInventario = (TextView) findViewById(R.id.tvCantidadInventario);

        ivImagen = (ImageView)findViewById(R.id.ivImagen);

        //Botones
        ibTomarFoto = (ImageButton) findViewById(R.id.ibTomarFoto);
        ibGuardarFoto = (ImageButton) findViewById(R.id.ibGuardarFoto);

        ibGuardarFoto.setVisibility(ImageButton.GONE);

    }

    private void AsignaEventos() {
        //Asigno los eventos
        navigation.setOnNavigationItemSelectedListener(mOnNavigationItemSelectedListener);
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

        btnSalir.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                startActivity(new Intent(getApplicationContext(), AlmacenOpcionesActivity.class));
                finish();
            }
        });

        btnLeerCodigo.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                //openDialogArticuloConfirm();
                try {
                    LeerCodigo();
                } catch (Exception ex) {
                    UTIL.SonidoError(AlmacenConsultaSKUActivity.this);
                    MessageBox.AlertDialog(AlmacenConsultaSKUActivity.this, "Error en lectura", ex.getMessage(), false);
                }
            }
        });

        //Capturo el enter en el lector de codigo de barra
        etCodigoSKU.setOnKeyListener(new View.OnKeyListener() {
            public boolean onKey(View v, int keyCode, KeyEvent event) {

                // If the event is a key-down event on the "enter" button
                if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                        keyCode == EditorInfo.IME_ACTION_DONE ||
                        (event.getAction() == KeyEvent.ACTION_DOWN &&
                                event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {

                    try{
                        LeerCodigo();
                    }catch(Exception ex){
                        UTIL.SonidoError(AlmacenConsultaSKUActivity.this);
                        MessageBox.AlertDialog(AlmacenConsultaSKUActivity.this, "Error en lectura", ex.getMessage(), false);
                    }


                }
                return false;
            }
        });
    }

    private void LoadDataDefault() {
        LimpiarControles();
        ibTieneFoto = false;

    }

    private void LimpiarControles() {
        etCodigoSKU.setText("");

        //Asigno la data necesaria
        tvCodSKU.setText("");
        tvCodArt.setText("");
        tvDescArt.setText("");
        tvMarca.setText("");
        tvUnidad1.setText("");
        tvUnidad2.setText("");

        tvStock.setText("0.00");
        tvCantidadInventario.setText("0.00");

        ivImagen.setImageResource(R.drawable.noimagen);
    }

    private boolean LeerCodigo() throws Exception {
        String lsCadena;

        // Perform action on key press
        if (etCodigoSKU.getText() != null) {
            lsCadena = etCodigoSKU.getText().toString().toUpperCase();

            if (lsCadena.contains("|") || lsCadena.contains("]")){
                //La primera cadena es el codigo de
                etCodigoSKU.setText(ImplArticulo.getInstanceArticulo(lsCadena).getCodSKU());
            }else{
                etCodigoSKU.setText(lsCadena);
            }

            new ValidarSKUTask().execute();
            return true;
        }else
            return false;
    }

    private void GuardarFoto() throws IOException {
        grabarImagen();
    }

    private void TomarFoto() {

        try {
            String ruta_fotos = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES) + "/HermesFotos/";
            File ruta = new File(ruta_fotos);

            //Creo la ruta completa
            ruta.mkdirs();
            String filePath = ruta_fotos + UTIL.getCode() + ".jpg";

            File mi_foto = new File( filePath );

            mi_foto.createNewFile();


            uriImagenPath = Uri.fromFile( mi_foto );

            //activity.setUriImagenPath(uriImagenPath);
            //activity.setImagenView(ivImagen);
            //activity.setRutaFoto(tvRutaFoto);
            //activity.setBtnGuardarFoto(ibGuardarFoto);

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
            startActivityForResult(cameraIntent, 0);
        } catch (IOException ex) {
            System.out.println(ex.getMessage());

        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {

        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == 0 && resultCode == RESULT_OK) {
            Bitmap imageBitmap = null;
            try {
                imageBitmap = MediaStore.Images.Media.getBitmap(this.getContentResolver(), uriImagenPath);

                tvRutaFoto.setText(uriImagenPath.getPath());

                //ivImagen.setImageBitmap(imageBitmap.createScaledBitmap(imageBitmap, 1800, 1800, false));
                ivImagen.setImageBitmap(imageBitmap);

                ibGuardarFoto.setVisibility(ImageButton.VISIBLE);


            } catch (IOException e) {
                e.printStackTrace();
            }

        }
    }

    private void FillData() {
        //Asigno la data necesaria
        if(articuloSelected.getCodSKU() != null)
            tvCodSKU.setText(articuloSelected.getCodSKU());
        else
            tvCodSKU.setText("");

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
            ibTieneFoto = true;
        }
        else {
            ivImagen.setImageResource(R.drawable.noimagen);
            ibTieneFoto = false;
        }

        //Limpio la busqueda
        etCodigoSKU.setText("");
    }


    private void grabarImagen() throws IOException {
        Bitmap imageBitmap;

        imageBitmap = MediaStore.Images.Media.getBitmap(getContentResolver(), uriImagenPath);

        new SaveImagenTask(articuloSelected, imageBitmap).execute();
    }

    //Clase privada de los eventos del NavigationView
    private BottomNavigationView.OnNavigationItemSelectedListener mOnNavigationItemSelectedListener
            = new BottomNavigationView.OnNavigationItemSelectedListener() {

        @Override
        public boolean onNavigationItemSelected(@NonNull MenuItem item) {
            switch (item.getItemId()) {
                case R.id.navigation_home:
                    startActivity(new Intent(getApplicationContext(), HomeActivity.class));
                    finish();
                    return true;
                case R.id.navigation_dashboard:
                    startActivity(new Intent(getApplicationContext(), AlmacenOpcionesActivity.class));
                    finish();
                    return true;
                case R.id.navigation_notifications:
                    return true;
            }
            return false;
        }
    };

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
            pDialog = new ProgressDialog(AlmacenConsultaSKUActivity.this);
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
                    UTIL.SonidoPopup(AlmacenConsultaSKUActivity.this);
                    ibGuardarFoto.setVisibility(ImageButton.GONE);
                    ibTieneFoto = true;
                    MessageBox.AlertDialog("Foto Guardada correctamente", "Foto", AlmacenConsultaSKUActivity.this);
                }
                else{
                    MessageBox.AlertDialog("HA ocurrido un error al almacenar la foto. Mensaje: " + mensaje, "Foto", AlmacenConsultaSKUActivity.this);
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
    private class ValidarSKUTask extends AsyncTask<Integer, Void, Boolean> {
        String mensaje, _strSKU;
        Boolean lbExiste;
        ImplAlmacen implAlmacen;
        ImplArticulo implArticulo;
        private ProgressDialog pDialog;

        public ValidarSKUTask() {
        }

        protected void onPreExecute() {
            super.onPreExecute();

            this._strSKU = etCodigoSKU.getText().toString();

            pDialog = new ProgressDialog(AlmacenConsultaSKUActivity.this);
            pDialog.setMessage("Buscando el código ingresado [" + this._strSKU + "] por favor espere...");
            pDialog.setIndeterminate(false);
            pDialog.setCancelable(false);
            pDialog.show();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            try {
                if (ImplEmpresa.empresaDefault == null) {
                    mensaje = "No se ha especificado la empresa por defecto";
                    return false;
                }
                //LLenado de Lista para los articulos
                implAlmacen = new ImplAlmacen(ImplEmpresa.empresaDefault.getCodigo());
                lbExiste = implAlmacen.existeSKU(_strSKU);

                if (lbExiste){
                    implArticulo = new ImplArticulo(ImplEmpresa.empresaDefault.getCodigo());

                    List<BeanArticulo> listado = implArticulo.getBySKU(_strSKU);
                    if (listado == null || listado.size() == 0){
                        mensaje = "No Existen Articulos que cumplan el SKU [" + _strSKU + "]";
                        return false;
                    }

                    articuloSelected = listado.get(0);

                    if (!articuloSelected.getIsOk())
                        throw new Exception(articuloSelected.getMensaje());
                }
                return true;

            } catch (Exception ex) {
                mensaje = "Error al Filtrar articulos: " + ex.getMessage();
                lbExiste = false;
                ex.printStackTrace();
                return false;
            } finally {
                implAlmacen = null;
                implArticulo = null;
            }

        }

        @Override
        protected void onPostExecute(Boolean result) {
            MediaPlayer mp;
            try {

                if (!lbExiste || !result) {
                    UTIL.SonidoError(AlmacenConsultaSKUActivity.this);

                    MessageBox.AlertDialog(AlmacenConsultaSKUActivity.this, "Error en consulta", mensaje, false);

                    LimpiarControles();

                    //Toast.makeText(context, mensaje, Toast.LENGTH_LONG).show();
                    //Limpio la busqueda
                    etCodigoSKU.setText("");

                    etCodigoSKU.setFocusable(true);
                    etCodigoSKU.requestFocus();

                }else{
                    UTIL.SonidoCorrecto(AlmacenConsultaSKUActivity.this);
                    FillData();

                    //Limpio la busqueda
                    etCodigoSKU.setText("");

                    etCodigoSKU.setFocusable(true);
                    etCodigoSKU.requestFocus();
                }

            } catch (Exception ex) {
                ex.printStackTrace();
            } finally {
                mp = null;
                try {
                    // dismiss the dialog after getting all products
                    pDialog.dismiss();
                    etCodigoSKU.setFocusable(true);
                    etCodigoSKU.requestFocus();

                } catch (Exception ex) {
                }

            }

        }
    }

}
