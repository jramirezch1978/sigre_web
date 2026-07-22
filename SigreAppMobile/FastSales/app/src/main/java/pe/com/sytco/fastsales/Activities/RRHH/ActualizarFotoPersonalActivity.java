package pe.com.sytco.fastsales.Activities.RRHH;

import android.Manifest;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.os.Bundle;
import android.provider.MediaStore;
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
import android.widget.Toast;

import androidx.appcompat.app.AlertDialog;
import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.Toolbar;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import java.io.ByteArrayOutputStream;
import java.util.List;

import pe.com.sytco.fastsales.Activities.HomeActivity;
import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.Controller.RRHH.ImplTrabajador;
import pe.com.sytco.fastsales.Dialog.DialogSeleccionarTrabajador;
import pe.com.sytco.fastsales.Global.GlobalClass;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Asistencia.BeanTrabajador;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class ActualizarFotoPersonalActivity extends AppCompatActivity {

    private static final int REQUEST_CAMERA = 1001;
    private static final int REQUEST_CAMERA_PERMISSION = 1002;

    // Controles de UI
    private EditText etBusqueda;
    private Button btnBuscar, btnAceptar, btnCancelar;
    private ImageButton ibTomarFoto, ibEliminarFoto;
    private ImageView ivFotoTrabajador;
    private TextView tvCodTrabajador, tvNombreTrabajador, tvDNI, tvCargo, tvArea, tvFechaNacimiento, tvFechaIngreso, tvFechaCese, tvEstado;
    private View layoutDatosTrabajador;

    // Variables
    private BeanTrabajador trabajadorSeleccionado = null;
    private byte[] fotoActualizada = null;
    private boolean fotoEliminada = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        try {
            if (ImplEmpresa.empresaDefault == null) {
                throw new Exception("No se ha especificado la empresa");
            }

            setContentView(R.layout.activity_actualizar_foto_personal);

            initControls();
            assignEvents();
            loadDefaults();

        } catch (Exception e) {
            MessageBox.AlertDialog(this, "Error al inicializar",
                    "Mensaje: " + e.getMessage(), false);
            e.printStackTrace();
        }
    }

    private void initControls() {
        // Toolbar
        Toolbar toolbar = findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayHomeAsUpEnabled(true);
        getSupportActionBar().setTitle("Actualizar Foto Personal");

        // EditText
        etBusqueda = findViewById(R.id.etBusqueda);

        // Buttons
        btnBuscar = findViewById(R.id.btnBuscar);
        btnAceptar = findViewById(R.id.btnAceptar);
        btnCancelar = findViewById(R.id.btnCancelar);

        // ImageButtons
        ibTomarFoto = findViewById(R.id.ibTomarFoto);
        ibEliminarFoto = findViewById(R.id.ibEliminarFoto);

        // ImageView
        ivFotoTrabajador = findViewById(R.id.ivFotoTrabajador);

        // TextViews de datos del trabajador
        tvCodTrabajador = findViewById(R.id.tvCodTrabajador);
        tvNombreTrabajador = findViewById(R.id.tvNombreTrabajador);
        tvDNI = findViewById(R.id.tvDNI);
        tvCargo = findViewById(R.id.tvCargo);
        tvArea = findViewById(R.id.tvArea);
        tvFechaNacimiento = findViewById(R.id.tvFechaNacimiento);
        tvFechaIngreso = findViewById(R.id.tvFechaIngreso);
        tvFechaCese = findViewById(R.id.tvFechaCese);
        tvEstado = findViewById(R.id.tvEstado);

        // Layout contenedor de datos
        layoutDatosTrabajador = findViewById(R.id.layoutDatosTrabajador);
    }

    private void assignEvents() {
        // Botón Buscar
        btnBuscar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                String textoBusqueda = etBusqueda.getText().toString().trim();
                if (textoBusqueda.isEmpty()) {
                    MessageBox.AlertDialog(ActualizarFotoPersonalActivity.this,
                            "Búsqueda requerida",
                            "Por favor ingrese DNI, código o nombre del trabajador", false);
                    return;
                }
                buscarTrabajador(textoBusqueda);
            }
        });

        // Enter en el campo de búsqueda
        etBusqueda.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                        keyCode == EditorInfo.IME_ACTION_DONE ||
                        (event.getAction() == KeyEvent.ACTION_DOWN &&
                                event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {
                    btnBuscar.performClick();
                    return true;
                }
                return false;
            }
        });

        // Al presionar Enter en el campo de búsqueda
        // Si contiene "|" es un código QR escaneado, si no es búsqueda normal
        etBusqueda.setOnKeyListener(new View.OnKeyListener() {
            @Override
            public boolean onKey(View v, int keyCode, KeyEvent event) {
                if (keyCode == EditorInfo.IME_ACTION_SEARCH ||
                        keyCode == EditorInfo.IME_ACTION_DONE ||
                        (event.getAction() == KeyEvent.ACTION_DOWN &&
                                event.getKeyCode() == KeyEvent.KEYCODE_ENTER)) {
                    
                    String texto = etBusqueda.getText().toString().trim();
                    
                    // Limpiar campo inmediatamente
                    etBusqueda.setText("");
                    
                    // Si contiene pipe "|", es un código QR completo
                    if (texto.contains("|")) {
                        leerCodigoQR(texto);
                    } else if (!texto.isEmpty()) {
                        // Es una búsqueda normal
                        buscarTrabajador(texto);
                    }
                    return true;
                }
                return false;
            }
        });

        // Botón Tomar Foto
        ibTomarFoto.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (trabajadorSeleccionado == null) {
                    MessageBox.AlertDialog(ActualizarFotoPersonalActivity.this,
                            "Seleccione un trabajador",
                            "Debe buscar y seleccionar un trabajador primero", false);
                    return;
                }
                tomarFoto();
            }
        });

        // Botón Eliminar Foto
        ibEliminarFoto.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (trabajadorSeleccionado == null) {
                    MessageBox.AlertDialog(ActualizarFotoPersonalActivity.this,
                            "Seleccione un trabajador",
                            "Debe buscar y seleccionar un trabajador primero", false);
                    return;
                }
                eliminarFoto();
            }
        });

        // Botón Aceptar (Guardar)
        btnAceptar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                guardarCambios();
            }
        });

        // Botón Cancelar
        btnCancelar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                limpiarFormulario();
            }
        });
    }

    private void loadDefaults() {
        layoutDatosTrabajador.setVisibility(View.GONE);
        btnAceptar.setEnabled(false);
        // Los botones de foto se controlan con la visibilidad del layout, no necesitan setEnabled
    }

    private void leerCodigoQR(String lecturaQR) {
        // El formato del QR es: codigo|nombre|tipo|dni|...
        String datos[] = lecturaQR.split("\\|");

        if (datos.length >= 1 && datos[0] != null && !datos[0].trim().isEmpty()) {
            String codTrabajador = datos[0].trim();
            
            // Buscar por código exacto
            buscarTrabajadorPorCodigo(codTrabajador);
            
        } else {
            UTIL.SonidoError(this);
            MessageBox.AlertDialog(this, "Error en lectura QR",
                    "El código QR leído está vacío o no es válido. Por favor, intente nuevamente.", false);
            etBusqueda.requestFocus();
        }
    }

    private void buscarTrabajadorPorCodigo(final String codigo) {
        new AsyncTask<Void, Void, BeanTrabajador>() {
            ProgressDialog progressDialog;
            Exception exception = null;

            @Override
            protected void onPreExecute() {
                progressDialog = ProgressDialog.show(ActualizarFotoPersonalActivity.this,
                        "Buscando trabajador",
                        "Consultando código: " + codigo, true, false);
            }

            @Override
            protected BeanTrabajador doInBackground(Void... voids) {
                try {
                    ImplTrabajador implTrabajador = new ImplTrabajador(ImplEmpresa.empresaDefault.getCodigo());
                    return implTrabajador.getTrabajadorByCodigo(codigo);
                } catch (Exception e) {
                    exception = e;
                    return null;
                }
            }

            @Override
            protected void onPostExecute(BeanTrabajador trabajador) {
                progressDialog.dismiss();

                if (exception != null) {
                    MessageBox.AlertDialog(ActualizarFotoPersonalActivity.this,
                            "Error en búsqueda",
                            "Error: " + exception.getMessage(), false);
                    return;
                }

                if (trabajador == null || !trabajador.getIsOk()) {
                    MessageBox.AlertDialog(ActualizarFotoPersonalActivity.this,
                            "Trabajador no encontrado",
                            "No existe ningún trabajador registrado con el código:\n\n" + codigo,
                            false);
                    return;
                }

                mostrarDatosTrabajador(trabajador);
            }
        }.execute();
    }

    private void buscarTrabajador(final String textoBusqueda) {
        new AsyncTask<Void, Void, List<BeanTrabajador>>() {
            ProgressDialog progressDialog;
            Exception exception = null;

            @Override
            protected void onPreExecute() {
                progressDialog = ProgressDialog.show(ActualizarFotoPersonalActivity.this,
                        "Buscando trabajador",
                        "Consultando base de datos...", true, false);
            }

            @Override
            protected List<BeanTrabajador> doInBackground(Void... voids) {
                try {
                    ImplTrabajador implTrabajador = new ImplTrabajador(ImplEmpresa.empresaDefault.getCodigo());
                    return implTrabajador.buscarTrabajadores(textoBusqueda);
                } catch (Exception e) {
                    exception = e;
                    return null;
                }
            }

            @Override
            protected void onPostExecute(List<BeanTrabajador> trabajadores) {
                progressDialog.dismiss();

                if (exception != null) {
                    MessageBox.AlertDialog(ActualizarFotoPersonalActivity.this,
                            "Error en búsqueda",
                            "Error: " + exception.getMessage(), false);
                    return;
                }

                if (trabajadores == null || trabajadores.isEmpty()) {
                    MessageBox.AlertDialog(ActualizarFotoPersonalActivity.this,
                            "Trabajador no encontrado",
                            "No existe ningún trabajador registrado con el DNI, código o nombre ingresado:\n\n" + textoBusqueda,
                            false);
                    return;
                }

                if (trabajadores.size() == 1) {
                    // Un solo resultado: mostrar directamente
                    mostrarDatosTrabajador(trabajadores.get(0));
                } else {
                    // Múltiples resultados: mostrar diálogo de selección
                    mostrarDialogoSeleccion(trabajadores);
                }
            }
        }.execute();
    }

    private void mostrarDialogoSeleccion(List<BeanTrabajador> trabajadores) {
        DialogSeleccionarTrabajador dialog = new DialogSeleccionarTrabajador(
                this,
                trabajadores,
                new DialogSeleccionarTrabajador.OnTrabajadorSeleccionadoListener() {
                    @Override
                    public void onTrabajadorSeleccionado(BeanTrabajador trabajador) {
                        mostrarDatosTrabajador(trabajador);
                    }
                }
        );
        dialog.show();
    }

    private void mostrarDatosTrabajador(BeanTrabajador trabajador) {
        this.trabajadorSeleccionado = trabajador;
        this.fotoActualizada = null;
        this.fotoEliminada = false;

        // Mostrar datos
        tvCodTrabajador.setText(trabajador.getCodTrabajador());
        tvNombreTrabajador.setText(trabajador.getNomTrabajador());
        tvDNI.setText("DNI: " + (trabajador.getDni() != null && !trabajador.getDni().isEmpty() ? trabajador.getDni() : "N/A"));
        tvCargo.setText("Cargo: " + (trabajador.getCargo() != null && !trabajador.getCargo().isEmpty() ? trabajador.getCargo() : "N/A"));
        tvArea.setText("Área: " + (trabajador.getArea() != null && !trabajador.getArea().isEmpty() ? trabajador.getArea() : "N/A"));
        tvFechaNacimiento.setText("Nacimiento: " + (trabajador.getFechaNacimiento() != null && !trabajador.getFechaNacimiento().isEmpty() ? trabajador.getFechaNacimiento() : "N/A"));
        tvFechaIngreso.setText("Ingreso: " + (trabajador.getFechaIngreso() != null && !trabajador.getFechaIngreso().isEmpty() ? trabajador.getFechaIngreso() : "N/A"));
        
        // Fecha de Cese y Estado
        if (trabajador.getFechaCese() != null && !trabajador.getFechaCese().isEmpty() && !trabajador.getFechaCese().equals("anyType{}")) {
            // Tiene fecha de cese - Mostrar fecha y estado CESADO
            tvFechaCese.setText("Cese: " + trabajador.getFechaCese());
            tvFechaCese.setVisibility(View.VISIBLE);
            tvEstado.setText("Estado: CESADO");
            tvEstado.setTextColor(0xFFFF5722); // Rojo
        } else {
            // No tiene fecha de cese - Ocultar línea de cese y mostrar ACTIVO
            tvFechaCese.setVisibility(View.GONE);
            tvEstado.setText("Estado: Activo");
            tvEstado.setTextColor(0xFF4CAF50); // Verde
        }

        // Mostrar foto
        if (trabajador.getFotoBlob() != null && trabajador.getFotoBlob().length > 0) {
            Bitmap bitmap = BitmapFactory.decodeByteArray(
                    trabajador.getFotoBlob(), 0, trabajador.getFotoBlob().length);
            ivFotoTrabajador.setImageBitmap(bitmap);
        } else {
            ivFotoTrabajador.setImageResource(R.drawable.ic_user_placeholder);
        }

        // Mostrar layout (los botones de foto ya están dentro y se harán visibles automáticamente)
        layoutDatosTrabajador.setVisibility(View.VISIBLE);
        btnAceptar.setEnabled(false); // Se habilitará cuando se tome o elimine foto
    }

    private void tomarFoto() {
        // Verificar permisos de cámara
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.CAMERA)
                != PackageManager.PERMISSION_GRANTED) {
            
            // Mostrar explicación de por qué necesita el permiso
            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.CAMERA)) {
                new AlertDialog.Builder(this)
                        .setTitle("Permiso de Cámara Requerido")
                        .setMessage("Esta aplicación necesita acceso a la cámara para tomar fotos del personal.\n\n¿Desea permitir el acceso?")
                        .setPositiveButton("SÍ, PERMITIR", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                ActivityCompat.requestPermissions(ActualizarFotoPersonalActivity.this,
                                        new String[]{Manifest.permission.CAMERA},
                                        REQUEST_CAMERA_PERMISSION);
                            }
                        })
                        .setNegativeButton("NO", null)
                        .show();
            } else {
                // Primera vez o nunca explicado, pedir directamente
                ActivityCompat.requestPermissions(this,
                        new String[]{Manifest.permission.CAMERA},
                        REQUEST_CAMERA_PERMISSION);
            }
            return;
        }

        // Abrir cámara
        Intent takePictureIntent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        if (takePictureIntent.resolveActivity(getPackageManager()) != null) {
            startActivityForResult(takePictureIntent, REQUEST_CAMERA);
        } else {
            MessageBox.AlertDialog(this, "Error",
                    "No se pudo acceder a la cámara del dispositivo", false);
        }
    }

    private void eliminarFoto() {
        new AlertDialog.Builder(this)
                .setTitle("Confirmar eliminación")
                .setMessage("¿Está seguro que desea eliminar la foto de " + trabajadorSeleccionado.getNomTrabajador() + "?")
                .setPositiveButton("SÍ", new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        ivFotoTrabajador.setImageResource(R.drawable.ic_user_placeholder);
                        fotoEliminada = true;
                        fotoActualizada = null;
                        btnAceptar.setEnabled(true);
                    }
                })
                .setNegativeButton("NO", null)
                .show();
    }

    private void guardarCambios() {
        if (trabajadorSeleccionado == null) {
            MessageBox.AlertDialog(this, "Error",
                    "No hay trabajador seleccionado", false);
            return;
        }

        if (fotoActualizada == null && !fotoEliminada) {
            MessageBox.AlertDialog(this, "Sin cambios",
                    "No se ha realizado ningún cambio en la foto", false);
            return;
        }

        new AsyncTask<Void, Void, Boolean>() {
            ProgressDialog progressDialog;
            Exception exception = null;

            @Override
            protected void onPreExecute() {
                progressDialog = ProgressDialog.show(ActualizarFotoPersonalActivity.this,
                        "Guardando cambios",
                        "Actualizando foto del trabajador...", true, false);
            }

            @Override
            protected Boolean doInBackground(Void... voids) {
                try {
                    ImplTrabajador implTrabajador = new ImplTrabajador(ImplEmpresa.empresaDefault.getCodigo());
                    
                    byte[] fotoParaGuardar = fotoEliminada ? null : fotoActualizada;
                    
                    return implTrabajador.actualizarFotoTrabajador(
                            trabajadorSeleccionado.getCodTrabajador(),
                            fotoParaGuardar
                    );
                } catch (Exception e) {
                    exception = e;
                    return false;
                }
            }

            @Override
            protected void onPostExecute(Boolean resultado) {
                progressDialog.dismiss();

                if (exception != null) {
                    MessageBox.AlertDialog(ActualizarFotoPersonalActivity.this,
                            "Error al guardar",
                            "Error: " + exception.getMessage(), false);
                    return;
                }

                if (resultado) {
                    MessageBox.AlertDialog(ActualizarFotoPersonalActivity.this,
                            "Éxito",
                            "Foto actualizada correctamente para " + trabajadorSeleccionado.getNomTrabajador(),
                            false);
                    limpiarFormulario();
                } else {
                    MessageBox.AlertDialog(ActualizarFotoPersonalActivity.this,
                            "Error",
                            "No se pudo actualizar la foto", false);
                }
            }
        }.execute();
    }

    private void limpiarFormulario() {
        etBusqueda.setText("");
        trabajadorSeleccionado = null;
        fotoActualizada = null;
        fotoEliminada = false;
        layoutDatosTrabajador.setVisibility(View.GONE); // Esto oculta todo, incluyendo los botones
        btnAceptar.setEnabled(false);
        ivFotoTrabajador.setImageResource(R.drawable.ic_user_placeholder);
        
        // Poner foco en campo de búsqueda para siguiente lectura
        etBusqueda.requestFocus();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (requestCode == REQUEST_CAMERA && resultCode == Activity.RESULT_OK) {
            try {
                Bundle extras = data.getExtras();
                Bitmap imageBitmap = (Bitmap) extras.get("data");

                if (imageBitmap != null) {
                    // Redimensionar la imagen para no sobrecargar el sistema
                    Bitmap resizedBitmap = resizeBitmap(imageBitmap, 800, 800);

                    // Convertir a byte array
                    ByteArrayOutputStream stream = new ByteArrayOutputStream();
                    resizedBitmap.compress(Bitmap.CompressFormat.JPEG, 85, stream);
                    fotoActualizada = stream.toByteArray();

                    // Mostrar en ImageView
                    ivFotoTrabajador.setImageBitmap(resizedBitmap);

                    // Habilitar botón guardar
                    fotoEliminada = false;
                    btnAceptar.setEnabled(true);

                    Toast.makeText(ActualizarFotoPersonalActivity.this, 
                            "Foto capturada. Presione ACEPTAR para guardar.", 
                            Toast.LENGTH_LONG).show();
                }
            } catch (Exception e) {
                MessageBox.AlertDialog(this, "Error",
                        "Error al procesar la foto: " + e.getMessage(), false);
                e.printStackTrace();
            }
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults);

        if (requestCode == REQUEST_CAMERA_PERMISSION) {
            if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                // Permiso concedido, abrir cámara
                Toast.makeText(this, "Permiso concedido. Abriendo cámara...", Toast.LENGTH_SHORT).show();
                tomarFoto();
            } else {
                // Permiso denegado
                new AlertDialog.Builder(this)
                        .setTitle("Permiso Denegado")
                        .setMessage("Sin acceso a la cámara no se pueden tomar fotos.\n\n" +
                                "Puede activar el permiso desde:\n" +
                                "Configuración → Aplicaciones → SIGRE → Permisos → Cámara")
                        .setPositiveButton("ENTENDIDO", null)
                        .show();
            }
        }
    }

    private Bitmap resizeBitmap(Bitmap original, int maxWidth, int maxHeight) {
        int width = original.getWidth();
        int height = original.getHeight();

        float ratioBitmap = (float) width / (float) height;
        float ratioMax = (float) maxWidth / (float) maxHeight;

        int finalWidth = maxWidth;
        int finalHeight = maxHeight;

        if (ratioMax > ratioBitmap) {
            finalWidth = (int) ((float) maxHeight * ratioBitmap);
        } else {
            finalHeight = (int) ((float) maxWidth / ratioBitmap);
        }

        return Bitmap.createScaledBitmap(original, finalWidth, finalHeight, true);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == android.R.id.home) {
            finish();
            return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onBackPressed() {
        if (trabajadorSeleccionado != null && (fotoActualizada != null || fotoEliminada)) {
            new AlertDialog.Builder(this)
                    .setTitle("Cambios sin guardar")
                    .setMessage("Hay cambios sin guardar. ¿Desea salir sin guardar?")
                    .setPositiveButton("SÍ, SALIR", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            finish();
                        }
                    })
                    .setNegativeButton("NO", null)
                    .show();
        } else {
            finish();
        }
    }
}

