package pe.com.hermes.appmobile.ui.almacen;

import android.content.Context;
import android.text.InputType;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import android.widget.TextView;
import androidx.appcompat.view.ContextThemeWrapper;
import com.google.android.material.switchmaterial.SwitchMaterial;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import pe.com.hermes.appmobile.R;
import pe.com.hermes.appmobile.data.almacen.AlmacenFuenteDatos;
import pe.com.hermes.common.ui.ValidInputHelper;

/** Campos dinámicos Hermes para formularios Almacén (checks verdes + FK modal). */
public final class AlmacenFormHelper {

    public static final class FkCampo {
        public final String key;
        public final String tituloDialog;
        public final String ayudaDialog;
        public final TextInputEditText valueEdit;
        public final TextInputEditText displayEdit;

        FkCampo(String key, String tituloDialog, String ayudaDialog,
                TextInputEditText valueEdit, TextInputEditText displayEdit) {
            this.key = key;
            this.tituloDialog = tituloDialog;
            this.ayudaDialog = ayudaDialog;
            this.valueEdit = valueEdit;
            this.displayEdit = displayEdit;
        }

        public void aplicarSeleccion(long id, String label) {
            valueEdit.setText(String.valueOf(id));
            displayEdit.setText(label != null ? label : String.valueOf(id));
        }
    }

    public static final class TablaForm {
        public final Map<String, TextInputEditText> edits;
        public final List<FkCampo> fks;

        TablaForm(Map<String, TextInputEditText> edits, List<FkCampo> fks) {
            this.edits = edits;
            this.fks = fks;
        }
    }

    private AlmacenFormHelper() {}

    public static boolean permiteAlta(AlmacenFuenteDatos f) {
        return switch (f) {
            case ALMACENES, TIPOS_MOVIMIENTO, TIPOS_ALMACEN, UBICACIONES, TIPOS_MOV_ALMACEN,
                    MOTIVOS_TRASLADO, LOTES, CONVERSIONES, NUMERACION_VALES, NUMERACION_OTR,
                    PARAMETROS, MOVIMIENTOS, ORDENES_TRASLADO, TOMAS_INVENTARIO -> true;
            default -> false;
        };
    }

    public static boolean esDocumento(AlmacenFuenteDatos f) {
        return f == AlmacenFuenteDatos.MOVIMIENTOS
                || f == AlmacenFuenteDatos.ORDENES_TRASLADO
                || f == AlmacenFuenteDatos.TOMAS_INVENTARIO;
    }

    public static boolean soportaCargaDetalle(AlmacenFuenteDatos f) {
        return f == AlmacenFuenteDatos.ALMACENES
                || f == AlmacenFuenteDatos.TIPOS_MOVIMIENTO
                || f == AlmacenFuenteDatos.TIPOS_ALMACEN
                || f == AlmacenFuenteDatos.MOTIVOS_TRASLADO;
    }

    public static TablaForm construirCamposTabla(
            Context ctx, LinearLayout container, AlmacenFuenteDatos fuente,
            Map<String, String> valores, boolean edicion) {
        container.removeAllViews();
        Map<String, TextInputEditText> edits = new LinkedHashMap<>();
        List<FkCampo> fks = new ArrayList<>();

        if (edicion) {
            addReadonly(ctx, container, edits, "id", "ID", valores);
        }

        switch (fuente) {
            case ALMACENES -> {
                addFk(ctx, container, edits, fks, "sucursalId", "Sucursal",
                        "Seleccionar sucursal", "Código y nombre de la sucursal", valores);
                addText(ctx, container, edits, "codigo", "Código", InputType.TYPE_CLASS_TEXT,
                        valores, edicion);
                addText(ctx, container, edits, "nombre", "Nombre", InputType.TYPE_CLASS_TEXT,
                        valores, false);
                addFk(ctx, container, edits, fks, "almacenTipoId", "Tipo de almacén",
                        "Seleccionar tipo", "Código y descripción del tipo", valores);
                addEstado(ctx, container, edits, valores);
            }
            case TIPOS_MOVIMIENTO -> {
                addText(ctx, container, edits, "tipoMov", "Código tipo mov.", InputType.TYPE_CLASS_TEXT,
                        valores, edicion);
                addText(ctx, container, edits, "descTipoMov", "Descripción", InputType.TYPE_CLASS_TEXT,
                        valores, false);
                addText(ctx, container, edits, "factorSldoTotal", "Factor saldo total (+1/-1)",
                        InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_SIGNED
                                | InputType.TYPE_NUMBER_FLAG_DECIMAL, valores, false);
                addEstado(ctx, container, edits, valores);
            }
            case TIPOS_ALMACEN -> {
                addText(ctx, container, edits, "codigo", "Código", InputType.TYPE_CLASS_TEXT,
                        valores, edicion);
                addText(ctx, container, edits, "nombre", "Nombre", InputType.TYPE_CLASS_TEXT,
                        valores, false);
                addText(ctx, container, edits, "cntblLibroId", "Libro contable ID",
                        InputType.TYPE_CLASS_NUMBER, valores, false);
                addEstado(ctx, container, edits, valores);
            }
            case UBICACIONES -> {
                addFk(ctx, container, edits, fks, "almacenId", "Almacén",
                        "Seleccionar almacén", "Código y nombre del almacén", valores);
                addText(ctx, container, edits, "codigo", "Código ubicación", InputType.TYPE_CLASS_TEXT,
                        valores, edicion);
                addText(ctx, container, edits, "nombre", "Nombre", InputType.TYPE_CLASS_TEXT,
                        valores, false);
                addText(ctx, container, edits, "pasillo", "Pasillo", InputType.TYPE_CLASS_TEXT,
                        valores, false);
                addText(ctx, container, edits, "estante", "Estante", InputType.TYPE_CLASS_TEXT,
                        valores, false);
                addText(ctx, container, edits, "nivel", "Nivel", InputType.TYPE_CLASS_TEXT,
                        valores, false);
            }
            case TIPOS_MOV_ALMACEN -> {
                addFk(ctx, container, edits, fks, "almacenId", "Almacén",
                        "Seleccionar almacén", "Código y nombre del almacén", valores);
                addFk(ctx, container, edits, fks, "articuloMovTipoId", "Tipo de movimiento",
                        "Seleccionar tipo", "Código y descripción del tipo", valores);
            }
            case MOTIVOS_TRASLADO -> {
                addText(ctx, container, edits, "codigo", "Código", InputType.TYPE_CLASS_TEXT,
                        valores, edicion);
                addText(ctx, container, edits, "nombre", "Nombre", InputType.TYPE_CLASS_TEXT,
                        valores, false);
                addEstado(ctx, container, edits, valores);
            }
            case LOTES -> {
                addText(ctx, container, edits, "articuloId", "Artículo ID", InputType.TYPE_CLASS_NUMBER,
                        valores, false);
                addText(ctx, container, edits, "nroLote", "N° Lote", InputType.TYPE_CLASS_TEXT,
                        valores, false);
                addText(ctx, container, edits, "fechaProduccion", "F. producción (yyyy-MM-dd)",
                        InputType.TYPE_CLASS_TEXT, valores, false);
                addText(ctx, container, edits, "fechaVencimiento", "F. vencimiento (yyyy-MM-dd)",
                        InputType.TYPE_CLASS_TEXT, valores, false);
                addText(ctx, container, edits, "observacion", "Observación", InputType.TYPE_CLASS_TEXT,
                        valores, false);
                addEstado(ctx, container, edits, valores);
            }
            case CONVERSIONES -> {
                addText(ctx, container, edits, "umOrigenId", "UM origen ID", InputType.TYPE_CLASS_NUMBER,
                        valores, false);
                addText(ctx, container, edits, "umDestinoId", "UM destino ID", InputType.TYPE_CLASS_NUMBER,
                        valores, false);
                addText(ctx, container, edits, "factorConversion", "Factor",
                        InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL, valores, false);
            }
            case NUMERACION_VALES, NUMERACION_OTR -> {
                addFk(ctx, container, edits, fks, "sucursalId", "Sucursal",
                        "Seleccionar sucursal", "Código y nombre de la sucursal", valores);
                addText(ctx, container, edits, "ano", "Año", InputType.TYPE_CLASS_NUMBER, valores, false);
                addText(ctx, container, edits, "ultNro", "Próximo N°", InputType.TYPE_CLASS_NUMBER,
                        valores, false);
                addEstado(ctx, container, edits, valores);
            }
            case PARAMETROS -> {
                addText(ctx, container, edits, "clave", "Clave", InputType.TYPE_CLASS_TEXT, valores, edicion);
                addText(ctx, container, edits, "valor", "Valor", InputType.TYPE_CLASS_TEXT, valores, false);
            }
            default -> { }
        }

        return new TablaForm(edits, fks);
    }

    public static Map<String, String> leer(Map<String, TextInputEditText> edits) {
        Map<String, String> out = new LinkedHashMap<>();
        for (Map.Entry<String, TextInputEditText> e : edits.entrySet()) {
            CharSequence t = e.getValue().getText();
            out.put(e.getKey(), t != null ? t.toString().trim() : "");
        }
        return out;
    }

    private static void addText(Context ctx, LinearLayout container,
                                Map<String, TextInputEditText> edits, String key, String label,
                                int inputType, Map<String, String> valores, boolean soloLectura) {
        TextInputLayout til = newTil(ctx, label);
        TextInputEditText et = new TextInputEditText(til.getContext());
        et.setInputType(inputType);
        if (valores != null && valores.get(key) != null) {
            et.setText(valores.get(key));
        }
        if (soloLectura) {
            aplicarSoloLectura(et);
        }
        til.addView(et);
        container.addView(til);
        edits.put(key, et);
        if (!soloLectura) {
            ValidInputHelper.bindTextInputLayout(til, ValidInputHelper.notBlank(), true);
        }
    }

    private static void addReadonly(Context ctx, LinearLayout container,
                                    Map<String, TextInputEditText> edits, String key, String label,
                                    Map<String, String> valores) {
        addText(ctx, container, edits, key, label, InputType.TYPE_CLASS_NUMBER, valores, true);
    }

    private static void addFk(Context ctx, LinearLayout container,
                              Map<String, TextInputEditText> edits, List<FkCampo> fks,
                              String key, String label, String tituloDialog, String ayuda,
                              Map<String, String> valores) {
        TextInputEditText valueEt = new TextInputEditText(ctx);
        valueEt.setVisibility(View.GONE);
        if (valores != null && valores.get(key) != null) {
            valueEt.setText(valores.get(key));
        }
        container.addView(valueEt);
        edits.put(key, valueEt);

        TextInputLayout til = newTil(ctx, label);
        til.setEndIconMode(TextInputLayout.END_ICON_CUSTOM);
        til.setEndIconDrawable(R.drawable.ic_chevron_right);
        TextInputEditText display = new TextInputEditText(til.getContext());
        display.setInputType(InputType.TYPE_CLASS_TEXT);
        display.setFocusable(false);
        display.setClickable(true);
        display.setCursorVisible(false);
        display.setLongClickable(false);
        String labelVal = valores != null ? valores.get(key + "__label") : null;
        if (labelVal != null && !labelVal.isBlank()) {
            display.setText(labelVal);
        } else if (valores != null && valores.get(key) != null && !valores.get(key).isBlank()) {
            display.setText(valores.get(key));
        }
        til.addView(display);
        container.addView(til);
        fks.add(new FkCampo(key, tituloDialog, ayuda, valueEt, display));
    }

    private static void addEstado(Context ctx, LinearLayout container,
                                  Map<String, TextInputEditText> edits, Map<String, String> valores) {
        TextInputEditText hidden = new TextInputEditText(ctx);
        hidden.setVisibility(View.GONE);
        String estado = valores != null && valores.get("flagEstado") != null
                ? valores.get("flagEstado") : "1";
        hidden.setText(estado);
        container.addView(hidden);
        edits.put("flagEstado", hidden);

        LinearLayout row = new LinearLayout(ctx);
        row.setOrientation(LinearLayout.HORIZONTAL);
        row.setGravity(Gravity.CENTER_VERTICAL);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = dp(ctx, 12);
        row.setLayoutParams(lp);
        row.setPadding(dp(ctx, 4), dp(ctx, 8), dp(ctx, 4), dp(ctx, 8));

        TextView label = new TextView(ctx);
        label.setLayoutParams(new LinearLayout.LayoutParams(0, ViewGroup.LayoutParams.WRAP_CONTENT, 1f));
        label.setText("Activo");
        label.setTextSize(TypedValue.COMPLEX_UNIT_SP, 16);
        label.setTextColor(ctx.getColor(R.color.hermes_ink));

        SwitchMaterial sw = new SwitchMaterial(ctx);
        boolean activo = !"0".equals(estado) && !"false".equalsIgnoreCase(estado);
        sw.setChecked(activo);
        sw.setOnCheckedChangeListener((button, checked) -> hidden.setText(checked ? "1" : "0"));

        row.addView(label);
        row.addView(sw);
        container.addView(row);
    }

    private static TextInputLayout newTil(Context ctx, String label) {
        ContextThemeWrapper themed = new ContextThemeWrapper(ctx, R.style.Widget_Hermes_TextInput);
        TextInputLayout til = new TextInputLayout(themed, null,
                com.google.android.material.R.attr.textInputOutlinedStyle);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = dp(ctx, 12);
        til.setLayoutParams(lp);
        til.setHint(label);
        til.setBoxBackgroundMode(TextInputLayout.BOX_BACKGROUND_OUTLINE);
        return til;
    }

    private static void aplicarSoloLectura(TextInputEditText et) {
        et.setFocusable(false);
        et.setFocusableInTouchMode(false);
        et.setClickable(false);
        et.setCursorVisible(false);
        et.setLongClickable(false);
        et.setInputType(InputType.TYPE_NULL);
        et.setKeyListener(null);
    }

    private static int dp(Context ctx, int value) {
        return Math.round(value * ctx.getResources().getDisplayMetrics().density);
    }
}
