package pe.com.sytco.fastsales.Activities.RRHH;

import android.app.Activity;
import android.app.DatePickerDialog;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Base64;
import android.view.View;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import androidx.appcompat.widget.Toolbar;

import java.util.Calendar;

import pe.com.sytco.fastsales.Controller.ImplEmpresa;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.util.UTIL;
import pe.com.sytco.fastsales.util.ValidInputHelper;

public final class RrhhUiHelper {

    private RrhhUiHelper() {
    }

    public static void setupScreen(Activity activity) {
        setupToolbar(activity);
        loadEmpresaBanner(activity);
        View root = activity.findViewById(android.R.id.content);
        if (root != null) {
            ValidInputHelper.bindTree(root);
        }
    }

    public static void setupToolbar(Activity activity) {
        Toolbar toolbar = activity.findViewById(R.id.toolbar);
        if (toolbar != null) {
            toolbar.setElevation(8f);
        }
    }

    /**
     * Abre calendario al tocar el campo o el botón asociado (formato dd/MM/yyyy).
     */
    public static void attachDatePicker(final Activity activity, final EditText editText, View triggerButton) {
        editText.setFocusable(false);
        editText.setClickable(true);
        editText.setCursorVisible(false);

        View.OnClickListener openPicker = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Calendar cal = Calendar.getInstance();
                String actual = editText.getText().toString().trim();
                if (actual.length() == 10 && actual.charAt(2) == '/' && actual.charAt(5) == '/') {
                    try {
                        int dia = Integer.parseInt(actual.substring(0, 2));
                        int mes = Integer.parseInt(actual.substring(3, 5)) - 1;
                        int anio = Integer.parseInt(actual.substring(6, 10));
                        cal.set(anio, mes, dia);
                    } catch (NumberFormatException ignored) {
                    }
                }

                DatePickerDialog dialog = new DatePickerDialog(activity,
                        new DatePickerDialog.OnDateSetListener() {
                            @Override
                            public void onDateSet(DatePicker view, int year, int month, int dayOfMonth) {
                                editText.setText(UTIL.DateToString(dayOfMonth, month + 1, year));
                            }
                        },
                        cal.get(Calendar.YEAR),
                        cal.get(Calendar.MONTH),
                        cal.get(Calendar.DAY_OF_MONTH));
                dialog.show();
            }
        };

        editText.setOnClickListener(openPicker);
        if (triggerButton != null) {
            triggerButton.setOnClickListener(openPicker);
        }
    }

    public static void loadEmpresaBanner(Activity activity) {
        ImageView ivLogo = activity.findViewById(R.id.ivLogoEmpresaRrhh);
        TextView tvNombre = activity.findViewById(R.id.tvNombreEmpresaRrhh);
        if (ivLogo == null || tvNombre == null) {
            return;
        }
        try {
            if (ImplEmpresa.empresaDefault == null) {
                return;
            }
            tvNombre.setText(ImplEmpresa.empresaDefault.getRazonSocial());
            String logoBase64 = ImplEmpresa.empresaDefault.getLogoBase64();
            if (logoBase64 != null && !logoBase64.isEmpty()) {
                byte[] decoded = Base64.decode(logoBase64, Base64.DEFAULT);
                Bitmap bitmap = BitmapFactory.decodeByteArray(decoded, 0, decoded.length);
                if (bitmap != null) {
                    ivLogo.setImageBitmap(bitmap);
                    return;
                }
            }
            ivLogo.setImageResource(R.drawable.icono_empresa);
        } catch (Exception ignored) {
            ivLogo.setImageResource(R.drawable.icono_empresa);
        }
    }
}
