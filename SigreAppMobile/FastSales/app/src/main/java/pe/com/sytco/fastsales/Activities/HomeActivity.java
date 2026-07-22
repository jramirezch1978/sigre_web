package pe.com.sytco.fastsales.Activities;

import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;

import pe.com.sytco.fastsales.Activities.Almacen.AlmacenOpcionesActivity;
import pe.com.sytco.fastsales.Activities.Asistencia.AsistenciaOpcionesActivity;
import pe.com.sytco.fastsales.Activities.Compras.ComprasOpcionesActivity;
import pe.com.sytco.fastsales.Activities.RRHH.RRHHOpcionesActivity;
import pe.com.sytco.fastsales.Activities.Ventas.VentasOpcionesActivity;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.ImplSegLoginDevice;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.util.MessageBox;

public class HomeActivity extends AppCompatActivity {

    private ImplSegLoginDevice implSegLoginDevice = null;
    private ImageButton ibAbout;
    private TextView tvOrigen;
    private TextView tvNombreEmpresa;
    private ImageView ivLogoEmpresa;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        //Llamo a los Controles
        InitControllers();

        //Muestro el codigo de origen
        if (ImplEmpresa.empresaDefault != null)
            tvOrigen.setText("Org [" + ImplEmpresa.empresaDefault.getCodOrigen() + "]");
    }

    @Override
    public void onBackPressed() {
        // Al presionar botón atrás, pedir confirmación para salir
        confirmarSalida();
    }

    public void onClickFeature(View v) {
        Intent intent;

        // TOMAPEDIDOS / POS → PedidoHostActivity (pedido nuevo sin proforma)
        if (v.getId() == R.id.btnFastSales) {
            intent = new Intent(getApplicationContext(), PedidoHostActivity.class);
            startActivity(intent);
            return;
        }

        if (v.getId() == R.id.almacen) {
            intent = new Intent(getApplicationContext(), AlmacenOpcionesActivity.class);
            startActivity(intent);
        }

        if (v.getId() == R.id.ventas) {
            intent = new Intent(getApplicationContext(), VentasOpcionesActivity.class);
            startActivity(intent);
        }

        if (v.getId() == R.id.compras) {
            intent = new Intent(getApplicationContext(), ComprasOpcionesActivity.class);
            startActivity(intent);
        }

        if (v.getId() == R.id.asistencia) {
            intent = new Intent(getApplicationContext(), AsistenciaOpcionesActivity.class);
            startActivity(intent);
        }

        if (v.getId() == R.id.rrhh) {
            intent = new Intent(getApplicationContext(), RRHHOpcionesActivity.class);
            startActivity(intent);
        }

        if (v.getId() == R.id.btnSalir) {
            confirmarSalida();
        }

        ibAbout.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                onClickAbout(view);
            }
        });
    }
    
    /**
     * Muestra diálogo de confirmación para salir de la aplicación
     */
    private void confirmarSalida() {
        new AlertDialog.Builder(this)
                .setTitle("Salir de SIGRE")
                .setMessage("¿Está seguro que desea cerrar la aplicación?")
                .setIcon(android.R.drawable.ic_dialog_alert)
                .setPositiveButton("SÍ, SALIR", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        cerrarAplicacion();
                    }
                })
                .setNegativeButton("NO", null)
                .show();
    }
    
    /**
     * Cierra la aplicación completamente, deteniendo todos los servicios
     */
    private void cerrarAplicacion() {
        try {
            // Registrar logout en el backend
            new RegistrarLogoutTask().execute();
            
            // Cerrar todos los servicios activos
            detenerServicios();
            
            // Finalizar esta actividad
            finish();
            
            // Finalizar todas las actividades de la app
            finishAffinity();
            
            // Cerrar completamente la aplicación
            System.exit(0);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Forzar cierre aunque haya error
            finish();
            System.exit(0);
        }
    }
    
    /**
     * Detiene todos los servicios en ejecución
     */
    private void detenerServicios() {
        try {
            // Detener servicios de la aplicación si están corriendo
            // Por ejemplo: ConnectionMonitorService, etc.
            
            // Cancelar cualquier AsyncTask pendiente
            // (los AsyncTasks se cancelan automáticamente al cerrar la Activity)
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void InitControllers() {
        ibAbout = (ImageButton) findViewById(R.id.ibAbout);
        tvOrigen = (TextView) findViewById(R.id.tvOrigen);
        tvNombreEmpresa = (TextView) findViewById(R.id.tvNombreEmpresa);
        ivLogoEmpresa = (ImageView) findViewById(R.id.ivLogoEmpresa);
        
        // Cargar información de la empresa
        cargarInformacionEmpresa();
    }
    
    /**
     * Carga la información de la empresa (logo y nombre) en la barra de título
     */
    private void cargarInformacionEmpresa() {
        try {
            if (ImplEmpresa.empresaDefault != null) {
                // Mostrar nombre de empresa
                tvNombreEmpresa.setText(ImplEmpresa.empresaDefault.getRazonSocial());
                
                // Cargar logo desde Base64 si existe
                String logoBase64 = ImplEmpresa.empresaDefault.getLogoBase64();
                if (logoBase64 != null && !logoBase64.isEmpty()) {
                    try {
                        byte[] decodedBytes = android.util.Base64.decode(logoBase64, android.util.Base64.DEFAULT);
                        Bitmap bitmap = BitmapFactory.decodeByteArray(decodedBytes, 0, decodedBytes.length);
                        if (bitmap != null) {
                            ivLogoEmpresa.setImageBitmap(bitmap);
                        } else {
                            mostrarErrorLogo("Error al decodificar la imagen del logo de la empresa");
                        }
                    } catch (Exception e) {
                        android.util.Log.e("HomeActivity", "Error al cargar logo: " + e.getMessage());
                        mostrarErrorLogo("Excepción al cargar el logo: " + e.getMessage());
                    }
                } else {
                    // Verificar si hay logoFile configurado
                    String logoFile = ImplEmpresa.empresaDefault.getLogoFile();
                    if (logoFile != null && !logoFile.isEmpty()) {
                        mostrarErrorLogo("No se pudo cargar el logo (" + logoFile + ").\n\nContacte al administrador del sistema.");
                    } else {
                        // Si no tiene logo configurado, usar icono por defecto sin error
                        ivLogoEmpresa.setImageResource(R.drawable.icono_empresa);
                    }
                }
            }
        } catch (Exception e) {
            android.util.Log.e("HomeActivity", "Error en cargarInformacionEmpresa: " + e.getMessage());
        }
    }
    
    /**
     * Muestra un mensaje de error sobre el logo pero continúa con la ejecución
     */
    private void mostrarErrorLogo(String mensaje) {
        ivLogoEmpresa.setImageResource(R.drawable.icono_empresa);
        Toast.makeText(this, mensaje, Toast.LENGTH_LONG).show();
    }

    private void onClickAbout(View view) {
        startActivity (new Intent(getApplicationContext(), AboutActivity.class));
        finish();
    }

    /**
     * Handle the click of a Feature button.
     *
     * @param v The view that was clicked.
     */


    public class RegistrarLogoutTask extends AsyncTask<Integer, Void, Boolean> {

        private String mensaje;

        protected void onPreExecute() {
            super.onPreExecute();
        }

        @Override
        protected Boolean doInBackground(Integer... params) {
            String lsURL = "";
            try {
                //Registro el dispositivo directamente en el servidor
                implSegLoginDevice = new ImplSegLoginDevice(ImplEmpresa.empresaDefault.getCodigo());
                implSegLoginDevice.registerLogout(ImplSegLoginDevice.currentDevice.getNroParte());

                return true;

            }catch(Exception e){
                mensaje = "Error al registrar Logout del Dispositivo en el servidor: " + e.getMessage();
                e.printStackTrace();
                return false;
            }finally{
                implSegLoginDevice = null;
                System.gc();
            }
        }

        @Override
        protected void onPostExecute(Boolean result) {
            try {

                if (!result) {
                    MessageBox.AlertDialog(mensaje, "Error al registrar Dispositivo", HomeActivity.this);

                }else {
                    Toast.makeText(HomeActivity.this, "Registro de Logout realizado correctamente. Nro Registro: "
                            + ImplSegLoginDevice.currentDevice.getNroParte(), Toast.LENGTH_LONG).show();
                }

                finish();

            }catch(Exception ex){
                MessageBox.AlertDialog("Ha ocurrido una excepcion: " + ex.getMessage(), "Error", HomeActivity.this );
                ex.printStackTrace();
            }finally {
                // Quito el dialogo despues de verificar la conexión con el servidor
                implSegLoginDevice = null;
                System.gc();
            }
        }

    }

}
