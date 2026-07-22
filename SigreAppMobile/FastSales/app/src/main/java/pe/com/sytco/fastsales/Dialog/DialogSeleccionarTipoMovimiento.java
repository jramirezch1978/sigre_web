package pe.com.sytco.fastsales.Dialog;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.view.View;
import android.view.Window;
import android.widget.Button;

import androidx.annotation.NonNull;
import androidx.cardview.widget.CardView;

import pe.com.sytco.fastsales.R;

/**
 * Diálogo profesional para seleccionar el tipo de movimiento de asistencia (01-10)
 * Diseño moderno con colores distintivos y descripciones claras
 */
public class DialogSeleccionarTipoMovimiento extends Dialog {

    private Context context;
    private OnTipoMovimientoSelectedListener listener;

    // CardViews para cada tipo de movimiento
    private CardView cvTipo01, cvTipo02, cvTipo03, cvTipo04, cvTipo05;
    private CardView cvTipo06, cvTipo07, cvTipo08, cvTipo09, cvTipo10;
    private Button btnCancelar;

    /**
     * Interface para comunicar la selección al Activity
     */
    public interface OnTipoMovimientoSelectedListener {
        void onTipoMovimientoSelected(String tipoMovimiento, String descripcion);
        void onCancel();
    }

    public DialogSeleccionarTipoMovimiento(@NonNull Context context, OnTipoMovimientoSelectedListener listener) {
        super(context);
        this.context = context;
        this.listener = listener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_seleccionar_tipo_movimiento);

        // Hacer el fondo transparente para esquinas redondeadas
        if (getWindow() != null) {
            getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        }

        initViews();
        setupClickListeners();
    }

    private void initViews() {
        cvTipo01 = findViewById(R.id.cvTipo01);
        cvTipo02 = findViewById(R.id.cvTipo02);
        cvTipo03 = findViewById(R.id.cvTipo03);
        cvTipo04 = findViewById(R.id.cvTipo04);
        cvTipo05 = findViewById(R.id.cvTipo05);
        cvTipo06 = findViewById(R.id.cvTipo06);
        cvTipo07 = findViewById(R.id.cvTipo07);
        cvTipo08 = findViewById(R.id.cvTipo08);
        cvTipo09 = findViewById(R.id.cvTipo09);
        cvTipo10 = findViewById(R.id.cvTipo10);
        btnCancelar = findViewById(R.id.btnCancelar);
    }

    private void setupClickListeners() {
        // TIPO 01: INGRESO A PLANTA
        cvTipo01.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onTipoMovimientoSelected("1", "INGRESO A PLANTA");
                }
                dismiss();
            }
        });

        // TIPO 02: SALIDA DE PLANTA
        cvTipo02.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onTipoMovimientoSelected("2", "SALIDA DE PLANTA");
                }
                dismiss();
            }
        });

        // TIPO 03: SALIDA A ALMORZAR
        cvTipo03.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onTipoMovimientoSelected("3", "SALIDA A ALMORZAR");
                }
                dismiss();
            }
        });

        // TIPO 04: REGRESO DE ALMORZAR
        cvTipo04.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onTipoMovimientoSelected("4", "REGRESO DE ALMORZAR");
                }
                dismiss();
            }
        });

        // TIPO 05: SALIDA DE COMISIÓN
        cvTipo05.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onTipoMovimientoSelected("5", "SALIDA DE COMISIÓN");
                }
                dismiss();
            }
        });

        // TIPO 06: RETORNO DE COMISIÓN
        cvTipo06.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onTipoMovimientoSelected("6", "RETORNO DE COMISIÓN");
                }
                dismiss();
            }
        });

        // TIPO 07: INGRESO A PRODUCCIÓN
        cvTipo07.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onTipoMovimientoSelected("7", "INGRESO A PRODUCCIÓN");
                }
                dismiss();
            }
        });

        // TIPO 08: SALIDA DE PRODUCCIÓN
        cvTipo08.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onTipoMovimientoSelected("8", "SALIDA DE PRODUCCIÓN");
                }
                dismiss();
            }
        });

        // TIPO 09: SALIDA A CENAR
        cvTipo09.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onTipoMovimientoSelected("9", "SALIDA A CENAR");
                }
                dismiss();
            }
        });

        // TIPO 10: REGRESO DE CENAR
        cvTipo10.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onTipoMovimientoSelected("10", "REGRESO DE CENAR");
                }
                dismiss();
            }
        });

        // Botón Cancelar
        btnCancelar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (listener != null) {
                    listener.onCancel();
                }
                dismiss();
            }
        });
    }
}

