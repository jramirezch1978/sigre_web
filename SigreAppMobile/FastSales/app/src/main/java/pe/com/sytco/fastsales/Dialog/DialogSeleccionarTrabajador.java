package pe.com.sytco.fastsales.Dialog;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import java.util.List;

import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.beans.Asistencia.BeanTrabajador;

public class DialogSeleccionarTrabajador extends Dialog {

    private OnTrabajadorSeleccionadoListener listener;

    public interface OnTrabajadorSeleccionadoListener {
        void onTrabajadorSeleccionado(BeanTrabajador trabajador);
    }

    public DialogSeleccionarTrabajador(Context context, 
                                       List<BeanTrabajador> trabajadores,
                                       OnTrabajadorSeleccionadoListener listener) {
        super(context);
        this.listener = listener;

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        
        LinearLayout mainLayout = new LinearLayout(context);
        mainLayout.setOrientation(LinearLayout.VERTICAL);
        mainLayout.setPadding(20, 20, 20, 20);
        mainLayout.setBackgroundColor(Color.WHITE);

        // Título
        TextView tvTitulo = new TextView(context);
        tvTitulo.setText("Seleccione un trabajador");
        tvTitulo.setTextSize(18);
        tvTitulo.setTextColor(Color.parseColor("#2196F3"));
        tvTitulo.setGravity(Gravity.CENTER);
        tvTitulo.setPadding(0, 0, 0, 20);
        mainLayout.addView(tvTitulo);

        // Subtítulo con cantidad
        TextView tvSubtitulo = new TextView(context);
        tvSubtitulo.setText("Se encontraron " + trabajadores.size() + " resultados");
        tvSubtitulo.setTextSize(14);
        tvSubtitulo.setTextColor(Color.GRAY);
        tvSubtitulo.setGravity(Gravity.CENTER);
        tvSubtitulo.setPadding(0, 0, 0, 16);
        mainLayout.addView(tvSubtitulo);

        // ScrollView para la lista
        ScrollView scrollView = new ScrollView(context);
        LinearLayout.LayoutParams scrollParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                0,
                1.0f
        );
        scrollView.setLayoutParams(scrollParams);

        // Contenedor de la lista
        LinearLayout listaLayout = new LinearLayout(context);
        listaLayout.setOrientation(LinearLayout.VERTICAL);

        // Crear un item por cada trabajador
        for (final BeanTrabajador trabajador : trabajadores) {
            LinearLayout itemLayout = new LinearLayout(context);
            itemLayout.setOrientation(LinearLayout.HORIZONTAL);
            itemLayout.setPadding(12, 12, 12, 12);
            itemLayout.setBackgroundColor(Color.parseColor("#F5F5F5"));
            
            LinearLayout.LayoutParams itemParams = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.MATCH_PARENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
            );
            itemParams.setMargins(0, 0, 0, 8);
            itemLayout.setLayoutParams(itemParams);

            // Foto miniatura
            ImageView ivFoto = new ImageView(context);
            LinearLayout.LayoutParams fotoParams = new LinearLayout.LayoutParams(80, 80);
            fotoParams.setMargins(0, 0, 12, 0);
            ivFoto.setLayoutParams(fotoParams);
            ivFoto.setScaleType(ImageView.ScaleType.CENTER_CROP);
            
            if (trabajador.getFotoBlob() != null && trabajador.getFotoBlob().length > 0) {
                Bitmap bitmap = BitmapFactory.decodeByteArray(
                        trabajador.getFotoBlob(), 0, trabajador.getFotoBlob().length);
                ivFoto.setImageBitmap(bitmap);
            } else {
                ivFoto.setImageResource(R.drawable.ic_user_placeholder);
            }
            itemLayout.addView(ivFoto);

            // Datos del trabajador
            LinearLayout datosLayout = new LinearLayout(context);
            datosLayout.setOrientation(LinearLayout.VERTICAL);
            LinearLayout.LayoutParams datosParams = new LinearLayout.LayoutParams(
                    0,
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    1.0f
            );
            datosLayout.setLayoutParams(datosParams);

            TextView tvCodigo = new TextView(context);
            tvCodigo.setText("Código: " + trabajador.getCodTrabajador());
            tvCodigo.setTextSize(12);
            tvCodigo.setTextColor(Color.parseColor("#666666"));
            datosLayout.addView(tvCodigo);

            TextView tvNombre = new TextView(context);
            tvNombre.setText(trabajador.getNomTrabajador());
            tvNombre.setTextSize(14);
            tvNombre.setTextColor(Color.parseColor("#333333"));
            tvNombre.setTypeface(null, android.graphics.Typeface.BOLD);
            datosLayout.addView(tvNombre);

            TextView tvDNI = new TextView(context);
            tvDNI.setText("DNI: " + (trabajador.getDni() != null ? trabajador.getDni() : "N/A"));
            tvDNI.setTextSize(12);
            tvDNI.setTextColor(Color.parseColor("#666666"));
            datosLayout.addView(tvDNI);

            itemLayout.addView(datosLayout);

            // Click en el item
            itemLayout.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    if (listener != null) {
                        listener.onTrabajadorSeleccionado(trabajador);
                    }
                    dismiss();
                }
            });

            listaLayout.addView(itemLayout);
        }

        scrollView.addView(listaLayout);
        mainLayout.addView(scrollView);

        // Botón cerrar
        Button btnCerrar = new Button(context);
        btnCerrar.setText("CERRAR");
        btnCerrar.setTextColor(Color.WHITE);
        btnCerrar.setBackgroundColor(Color.parseColor("#757575"));
        LinearLayout.LayoutParams btnParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT
        );
        btnParams.setMargins(0, 16, 0, 0);
        btnCerrar.setLayoutParams(btnParams);
        btnCerrar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dismiss();
            }
        });
        mainLayout.addView(btnCerrar);

        setContentView(mainLayout);

        // Configurar tamaño del diálogo
        if (getWindow() != null) {
            getWindow().setLayout(
                    (int) (context.getResources().getDisplayMetrics().widthPixels * 0.9),
                    (int) (context.getResources().getDisplayMetrics().heightPixels * 0.7)
            );
        }
    }
}

