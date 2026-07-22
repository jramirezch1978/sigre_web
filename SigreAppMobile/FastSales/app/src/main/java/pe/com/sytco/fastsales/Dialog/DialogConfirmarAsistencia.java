package pe.com.sytco.fastsales.Dialog;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.util.Base64;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.annotation.NonNull;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Asistencia.BeanTrabajador;

public class DialogConfirmarAsistencia extends Dialog {

    private Context context;
    private BeanTrabajador trabajador;
    private OnConfirmListener confirmListener;

    private ImageView ivFotoTrabajador, ivLogoEmpresaTrabajador;
    private TextView tvCodigoTrabajador;
    private TextView tvApellidos;
    private TextView tvNombres;
    private TextView tvIdentificacion;
    private TextView tvTipoDocumento;
    private TextView tvNumeroDocumento;
    private TextView tvNombreEmpresaTrabajador;
    private TextView tvEstadoTrabajador;
    private TextView tvFechaNacimiento;
    private TextView tvLabelFechaNacimiento;
    private TextView tvFechaCese;
    private TextView tvLabelFechaCese;
    private LinearLayout llBannerEstado;
    private android.widget.RelativeLayout llDialogContenedor;
    private Button btnConfirmar;
    private Button btnCancelar;
    private String tituloDialogo = "Confirmar Asistencia";
    private String textoBotonConfirmar = "CONFIRMAR";
    private boolean modoSoloConsulta = false;

    public interface OnConfirmListener {
        void onConfirm(BeanTrabajador trabajador);
        void onCancel();
    }

    public DialogConfirmarAsistencia(@NonNull Context context, BeanTrabajador trabajador, OnConfirmListener listener) {
        this(context, trabajador, "Confirmar Asistencia", "CONFIRMAR", false, listener);
    }

    public DialogConfirmarAsistencia(@NonNull Context context, BeanTrabajador trabajador,
            String tituloDialogo, String textoBotonConfirmar, boolean modoSoloConsulta,
            OnConfirmListener listener) {
        super(context);
        this.context = context;
        this.trabajador = trabajador;
        this.confirmListener = listener;
        if (tituloDialogo != null && tituloDialogo.trim().length() > 0) {
            this.tituloDialogo = tituloDialogo.trim();
        }
        if (textoBotonConfirmar != null && textoBotonConfirmar.trim().length() > 0) {
            this.textoBotonConfirmar = textoBotonConfirmar.trim();
        }
        this.modoSoloConsulta = modoSoloConsulta;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_confirmar_asistencia);

        // Hacer el fondo transparente y ajustar el tamaño del diálogo
        if (getWindow() != null) {
            getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
            
            // Ajustar el tamaño del diálogo para que ocupe la mayor parte de la pantalla
            android.view.WindowManager.LayoutParams layoutParams = getWindow().getAttributes();
            android.view.Display display = getWindow().getWindowManager().getDefaultDisplay();
            android.graphics.Point size = new android.graphics.Point();
            display.getSize(size);
            int screenWidth = size.x;
            int screenHeight = size.y;
            
            // Establecer el ancho al 90% y altura al 85% de la pantalla
            layoutParams.width = (int) (screenWidth * 0.90);
            layoutParams.height = (int) (screenHeight * 0.85);
            getWindow().setAttributes(layoutParams);
        }

        initViews();
        loadData();
        setupButtons();
    }

    private void initViews() {
        ivFotoTrabajador = findViewById(R.id.ivFotoTrabajador);
        ivLogoEmpresaTrabajador = findViewById(R.id.ivLogoEmpresaTrabajador);
        tvCodigoTrabajador = findViewById(R.id.tvCodigoTrabajador);
        tvApellidos = findViewById(R.id.tvApellidos);
        tvNombres = findViewById(R.id.tvNombres);
        tvIdentificacion = findViewById(R.id.tvIdentificacion);
        tvTipoDocumento = findViewById(R.id.tvTipoDocumento);
        tvNumeroDocumento = findViewById(R.id.tvNumeroDocumento);
        tvNombreEmpresaTrabajador = findViewById(R.id.tvNombreEmpresaTrabajador);
        tvEstadoTrabajador = findViewById(R.id.tvEstadoTrabajador);
        tvFechaNacimiento = findViewById(R.id.tvFechaNacimiento);
        tvLabelFechaNacimiento = findViewById(R.id.tvLabelFechaNacimiento);
        tvFechaCese = findViewById(R.id.tvFechaCese);
        tvLabelFechaCese = findViewById(R.id.tvLabelFechaCese);
        llBannerEstado = findViewById(R.id.llBannerEstado);
        llDialogContenedor = findViewById(R.id.llDialogContenedor);
        btnConfirmar = findViewById(R.id.btnConfirmar);
        btnCancelar = findViewById(R.id.btnCancelar);
        TextView tvTitulo = findViewById(R.id.tvTitulo);
        if (tvTitulo != null) {
            tvTitulo.setText(tituloDialogo);
        }
        btnConfirmar.setText(textoBotonConfirmar);
    }

    private void loadData() {
        // Cargar código del trabajador
        String codigoTrabajador = trabajador.getCodTrabajador();
        tvCodigoTrabajador.setText(codigoTrabajador != null && !codigoTrabajador.isEmpty() ? codigoTrabajador : "N/A");

        // Cargar apellidos
        String apellidos = trabajador.getApellidos();
        tvApellidos.setText(apellidos.isEmpty() ? "N/A" : apellidos.toUpperCase());

        // Cargar nombres
        String nombres = trabajador.getNombres();
        tvNombres.setText(nombres.isEmpty() ? "N/A" : nombres.toUpperCase());

        // Cargar identificación (tipo + número en una sola línea)
        String tipoDoc = obtenerNombreTipoDocumento(trabajador.getTipoDocIdentRtps());
        String numeroDoc = trabajador.getDocumentoIdentidad();
        tvIdentificacion.setText(tipoDoc + " " + numeroDoc);

        // Cargar fecha de nacimiento si existe
        if (trabajador.getFechaNacimiento() != null && !trabajador.getFechaNacimiento().isEmpty()) {
            tvLabelFechaNacimiento.setVisibility(View.VISIBLE);
            tvFechaNacimiento.setVisibility(View.VISIBLE);
            tvFechaNacimiento.setText(trabajador.getFechaNacimiento());
        } else {
            tvLabelFechaNacimiento.setVisibility(View.GONE);
            tvFechaNacimiento.setVisibility(View.GONE);
        }

        // Cargar foto
        cargarFoto();
        
        // Cargar información de la empresa
        cargarInformacionEmpresa();
        
        // Verificar si el trabajador está CESADO o INACTIVO
        configurarEstadoTrabajador();
    }
    
    private void cargarInformacionEmpresa() {
        try {
            if (ImplEmpresa.empresaDefault != null) {
                // Mostrar nombre de empresa
                tvNombreEmpresaTrabajador.setText(ImplEmpresa.empresaDefault.getRazonSocial());
                
                // Cargar logo desde Base64 si existe
                if (ImplEmpresa.empresaDefault.getLogoBase64() != null && 
                    !ImplEmpresa.empresaDefault.getLogoBase64().isEmpty()) {
                    try {
                        byte[] decodedString = Base64.decode(ImplEmpresa.empresaDefault.getLogoBase64(), Base64.DEFAULT);
                        Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
                        ivLogoEmpresaTrabajador.setImageBitmap(decodedByte);
                    } catch (Exception e) {
                        android.util.Log.e("DialogConfirmar", "Error al cargar logo: " + e.getMessage());
                        // Si falla, usar logo por defecto
                        ivLogoEmpresaTrabajador.setImageResource(R.drawable.icono_empresa);
                    }
                } else {
                    // Si no tiene logo, usar icono por defecto
                    ivLogoEmpresaTrabajador.setImageResource(R.drawable.icono_empresa);
                }
            }
        } catch (Exception e) {
            android.util.Log.e("DialogConfirmar", "Error en cargarInformacionEmpresa: " + e.getMessage());
        }
    }
    
    /**
     * Configura el diseño del diálogo según el estado del trabajador
     * (CESADO, INACTIVO o ACTIVO)
     */
    private void configurarEstadoTrabajador() {
        boolean estaCesado = trabajador.estaCesado();
        boolean estaInactivo = trabajador.estaInactivo();
        
        if (estaCesado || estaInactivo) {
            llBannerEstado.setVisibility(View.VISIBLE);
            
            // Cambiar fondo del diálogo a un tono rojo claro
            llDialogContenedor.setBackgroundColor(0xFFFFEBEE); // Rojo muy claro
            
            // Configurar texto del banner según el estado
            if (estaCesado) {
                tvEstadoTrabajador.setText("TRABAJADOR CESADO");
            } else {
                tvEstadoTrabajador.setText("TRABAJADOR INACTIVO");
            }
            
            // Mostrar fecha de cese si existe
            if (estaCesado && trabajador.getFechaCese() != null && !trabajador.getFechaCese().isEmpty()) {
                tvLabelFechaCese.setVisibility(View.VISIBLE);
                tvFechaCese.setVisibility(View.VISIBLE);
                tvFechaCese.setText(trabajador.getFechaCese());
            }
            
            // OCULTAR el botón CONFIRMAR
            btnConfirmar.setVisibility(View.GONE);
            
            // Cambiar el texto del botón CANCELAR a "CERRAR"
            btnCancelar.setText("CERRAR");
            
            // Hacer que el botón CERRAR ocupe todo el ancho
            android.widget.LinearLayout.LayoutParams params = 
                (android.widget.LinearLayout.LayoutParams) btnCancelar.getLayoutParams();
            params.weight = 1;
            btnCancelar.setLayoutParams(params);
            
            android.util.Log.w("DialogConfirmar", 
                "Trabajador " + trabajador.getCodTrabajador() + " está " + 
                (estaCesado ? "CESADO" : "INACTIVO"));
        } else if (modoSoloConsulta) {
            llBannerEstado.setVisibility(View.GONE);
            llDialogContenedor.setBackgroundColor(0xFFFFFFFF);
            tvLabelFechaCese.setVisibility(View.GONE);
            tvFechaCese.setVisibility(View.GONE);
            btnConfirmar.setVisibility(View.GONE);
            btnCancelar.setText("CERRAR");
            android.widget.LinearLayout.LayoutParams params =
                    (android.widget.LinearLayout.LayoutParams) btnCancelar.getLayoutParams();
            params.weight = 1;
            btnCancelar.setLayoutParams(params);
        } else {
            // Trabajador ACTIVO - diseño normal
            llBannerEstado.setVisibility(View.GONE);
            llDialogContenedor.setBackgroundColor(0xFFFFFFFF); // Blanco
            tvLabelFechaCese.setVisibility(View.GONE);
            tvFechaCese.setVisibility(View.GONE);
            btnConfirmar.setVisibility(View.VISIBLE);
            btnCancelar.setText("CANCELAR");
        }
    }

    private void cargarFoto() {
        try {
            Bitmap bitmap = null;
            
            // Si tiene foto BLOB (viene desde la base de datos)
            if (trabajador.tieneFoto()) {
                android.util.Log.i("DialogConfirmarAsistencia", 
                    "fotoBlob recibido. Tamaño: " + trabajador.getFotoBlob().length + " bytes");
                
                // Detectar formato por los primeros bytes
                String formato = detectarFormatoImagen(trabajador.getFotoBlob());
                android.util.Log.i("DialogConfirmarAsistencia", 
                    "Formato detectado: " + formato);
                
                // BitmapFactory.decodeByteArray() detecta automáticamente el formato
                // Soporta: JPEG, PNG, GIF, BMP, WebP
                bitmap = BitmapFactory.decodeByteArray(
                    trabajador.getFotoBlob(), 
                    0, 
                    trabajador.getFotoBlob().length
                );
                
                // Si bitmap es null, significa que el formato no es soportado o está corrupto
                if (bitmap == null) {
                    android.util.Log.e("DialogConfirmarAsistencia", 
                        "Error: No se pudo decodificar fotoBlob. Formato: " + formato);
                } else {
                    android.util.Log.i("DialogConfirmarAsistencia", 
                        "Bitmap decodificado exitosamente. Dimensiones: " + bitmap.getWidth() + "x" + bitmap.getHeight());
                }
            }
            
            // Si se obtuvo un bitmap válido, ajustarlo proporcionalmente
            if (bitmap != null) {
                cargarBitmapProporcional(bitmap);
            } else {
                // No tiene foto válida, usar imagen de usuario genérico
                ivFotoTrabajador.setImageResource(R.drawable.ic_user_placeholder);
                android.util.Log.i("DialogConfirmarAsistencia", 
                    "Trabajador sin foto, usando avatar genérico");
            }
        } catch (Exception e) {
            android.util.Log.e("DialogConfirmarAsistencia", 
                "Error general al cargar foto: " + e.getMessage());
            e.printStackTrace();
            // En caso de error, usar imagen de usuario genérico
            ivFotoTrabajador.setImageResource(R.drawable.ic_user_placeholder);
        }
    }
    
    /**
     * Carga el bitmap en el ImageView manteniendo el ratio de aspecto original
     * y centrándolo en el contenedor
     */
    private void cargarBitmapProporcional(Bitmap bitmap) {
        try {
            // Obtener dimensiones originales de la imagen
            int anchoOriginal = bitmap.getWidth();
            int altoOriginal = bitmap.getHeight();
            
            // Calcular el ratio de aspecto
            float ratioAspecto = (float) anchoOriginal / (float) altoOriginal;
            
            // Dimensiones máximas del contenedor (en dp, convertir a px)
            float density = context.getResources().getDisplayMetrics().density;
            int maxAnchoPx = (int) (280 * density); // Ancho del diálogo menos padding
            int maxAltoPx = (int) (250 * density);  // Alto definido en el layout
            
            // Calcular nuevas dimensiones manteniendo el ratio
            int nuevoAncho;
            int nuevoAlto;
            
            if (anchoOriginal > altoOriginal) {
                // Imagen horizontal (landscape)
                nuevoAncho = Math.min(anchoOriginal, maxAnchoPx);
                nuevoAlto = (int) (nuevoAncho / ratioAspecto);
                
                // Si el alto excede el máximo, ajustar por alto
                if (nuevoAlto > maxAltoPx) {
                    nuevoAlto = maxAltoPx;
                    nuevoAncho = (int) (nuevoAlto * ratioAspecto);
                }
            } else {
                // Imagen vertical (portrait) o cuadrada
                nuevoAlto = Math.min(altoOriginal, maxAltoPx);
                nuevoAncho = (int) (nuevoAlto * ratioAspecto);
                
                // Si el ancho excede el máximo, ajustar por ancho
                if (nuevoAncho > maxAnchoPx) {
                    nuevoAncho = maxAnchoPx;
                    nuevoAlto = (int) (nuevoAncho / ratioAspecto);
                }
            }
            
            // Escalar el bitmap si es necesario (solo si es muy grande)
            Bitmap bitmapEscalado;
            if (anchoOriginal > maxAnchoPx || altoOriginal > maxAltoPx) {
                bitmapEscalado = Bitmap.createScaledBitmap(bitmap, nuevoAncho, nuevoAlto, true);
            } else {
                bitmapEscalado = bitmap;
            }
            
            // Establecer el bitmap en el ImageView
            // El scaleType="fitCenter" y adjustViewBounds="true" del layout
            // se encargarán de centrarlo y mantener el ratio
            ivFotoTrabajador.setImageBitmap(bitmapEscalado);
            
        } catch (Exception e) {
            e.printStackTrace();
            // Si hay error, mostrar el bitmap original sin escalar
            ivFotoTrabajador.setImageBitmap(bitmap);
        }
    }

    private String detectarFormatoImagen(byte[] bytes) {
        if (bytes == null || bytes.length < 4) {
            return "DESCONOCIDO";
        }
        
        // JPEG: FF D8 FF
        if (bytes[0] == (byte) 0xFF && bytes[1] == (byte) 0xD8 && bytes[2] == (byte) 0xFF) {
            return "JPEG";
        }
        
        // PNG: 89 50 4E 47
        if (bytes[0] == (byte) 0x89 && bytes[1] == (byte) 0x50 && 
            bytes[2] == (byte) 0x4E && bytes[3] == (byte) 0x47) {
            return "PNG";
        }
        
        // GIF: 47 49 46 38
        if (bytes[0] == (byte) 0x47 && bytes[1] == (byte) 0x49 && 
            bytes[2] == (byte) 0x46 && bytes[3] == (byte) 0x38) {
            return "GIF";
        }
        
        // BMP: 42 4D
        if (bytes[0] == (byte) 0x42 && bytes[1] == (byte) 0x4D) {
            return "BMP";
        }
        
        // WebP: 52 49 46 46 ... 57 45 42 50
        if (bytes.length >= 12 && 
            bytes[0] == (byte) 0x52 && bytes[1] == (byte) 0x49 && 
            bytes[2] == (byte) 0x46 && bytes[3] == (byte) 0x46 &&
            bytes[8] == (byte) 0x57 && bytes[9] == (byte) 0x45 && 
            bytes[10] == (byte) 0x42 && bytes[11] == (byte) 0x50) {
            return "WEBP";
        }
        
        // Formato desconocido - mostrar los primeros 4 bytes en hexadecimal
        return String.format("DESCONOCIDO (0x%02X%02X%02X%02X)", 
                             bytes[0] & 0xFF, bytes[1] & 0xFF, 
                             bytes[2] & 0xFF, bytes[3] & 0xFF);
    }
    
    private String obtenerNombreTipoDocumento(String tipoDoc) {
        if (tipoDoc == null || tipoDoc.isEmpty()) {
            return "DNI";
        }
        
        switch (tipoDoc) {
            case "01":
                return "DNI";
            case "04":
                return "Carnet de Extranjería";
            case "06":
                return "RUC";
            case "07":
                return "Pasaporte";
            default:
                return "Documento";
        }
    }

    private void setupButtons() {
        btnConfirmar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (confirmListener != null) {
                    confirmListener.onConfirm(trabajador);
                }
                dismiss();
            }
        });

        btnCancelar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (confirmListener != null) {
                    confirmListener.onCancel();
                }
                dismiss();
            }
        });
    }
}

