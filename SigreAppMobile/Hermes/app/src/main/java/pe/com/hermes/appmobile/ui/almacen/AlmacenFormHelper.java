package pe.com.hermes.appmobile.ui.almacen;

import android.content.Context;
import android.text.InputType;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import java.util.LinkedHashMap;
import java.util.Map;
import pe.com.hermes.appmobile.data.almacen.AlmacenFuenteDatos;

/** Campos dinámicos para formularios Almacén. */
public final class AlmacenFormHelper {

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

    public static Map<String, TextInputEditText> construirCamposTabla(
            Context ctx, LinearLayout container, AlmacenFuenteDatos fuente, Map<String, String> valores) {
        container.removeAllViews();
        Map<String, TextInputEditText> edits = new LinkedHashMap<>();
        switch (fuente) {
            case ALMACENES -> {
                add(ctx, container, edits, "sucursalId", "Sucursal ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "codigo", "Código", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "nombre", "Nombre", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "almacenTipoId", "Tipo almacén ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "flagEstado", "Estado (1/0)", InputType.TYPE_CLASS_NUMBER, valores);
            }
            case TIPOS_MOVIMIENTO -> {
                add(ctx, container, edits, "tipoMov", "Código tipo mov.", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "descTipoMov", "Descripción", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "factorSldoTotal", "Factor saldo total (+1/-1)",
                        InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_SIGNED | InputType.TYPE_NUMBER_FLAG_DECIMAL, valores);
                add(ctx, container, edits, "flagEstado", "Estado (1/0)", InputType.TYPE_CLASS_NUMBER, valores);
            }
            case TIPOS_ALMACEN -> {
                add(ctx, container, edits, "codigo", "Código", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "nombre", "Nombre", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "cntblLibroId", "Libro contable ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "flagEstado", "Estado (1/0)", InputType.TYPE_CLASS_NUMBER, valores);
            }
            case UBICACIONES -> {
                add(ctx, container, edits, "almacenId", "Almacén ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "codigo", "Código ubicación", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "nombre", "Nombre", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "pasillo", "Pasillo", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "estante", "Estante", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "nivel", "Nivel", InputType.TYPE_CLASS_TEXT, valores);
            }
            case TIPOS_MOV_ALMACEN -> {
                add(ctx, container, edits, "almacenId", "Almacén ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "articuloMovTipoId", "Tipo movimiento ID", InputType.TYPE_CLASS_NUMBER, valores);
            }
            case MOTIVOS_TRASLADO -> {
                add(ctx, container, edits, "codigo", "Código", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "nombre", "Nombre", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "flagEstado", "Estado (1/0)", InputType.TYPE_CLASS_NUMBER, valores);
            }
            case LOTES -> {
                add(ctx, container, edits, "articuloId", "Artículo ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "nroLote", "N° Lote", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "fechaProduccion", "F. producción (yyyy-MM-dd)", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "fechaVencimiento", "F. vencimiento (yyyy-MM-dd)", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "observacion", "Observación", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "flagEstado", "Estado (1/0)", InputType.TYPE_CLASS_NUMBER, valores);
            }
            case CONVERSIONES -> {
                add(ctx, container, edits, "umOrigenId", "UM origen ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "umDestinoId", "UM destino ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "factorConversion", "Factor",
                        InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL, valores);
            }
            case NUMERACION_VALES, NUMERACION_OTR -> {
                add(ctx, container, edits, "sucursalId", "Sucursal ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "ano", "Año", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "ultNro", "Próximo N°", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "flagEstado", "Estado (1/0)", InputType.TYPE_CLASS_NUMBER, valores);
            }
            case PARAMETROS -> {
                add(ctx, container, edits, "clave", "Clave", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "valor", "Valor", InputType.TYPE_CLASS_TEXT, valores);
            }
            default -> { }
        }
        return edits;
    }

    public static Map<String, String> leer(Map<String, TextInputEditText> edits) {
        Map<String, String> out = new LinkedHashMap<>();
        for (Map.Entry<String, TextInputEditText> e : edits.entrySet()) {
            CharSequence t = e.getValue().getText();
            out.put(e.getKey(), t != null ? t.toString().trim() : "");
        }
        return out;
    }

    private static void add(Context ctx, LinearLayout container, Map<String, TextInputEditText> edits,
                            String key, String label, int inputType, Map<String, String> valores) {
        TextInputLayout til = new TextInputLayout(ctx, null,
                com.google.android.material.R.attr.textInputOutlinedStyle);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        lp.bottomMargin = (int) (12 * ctx.getResources().getDisplayMetrics().density);
        til.setLayoutParams(lp);
        til.setHint(label);
        TextInputEditText et = new TextInputEditText(til.getContext());
        et.setInputType(inputType);
        if (valores != null && valores.get(key) != null) {
            et.setText(valores.get(key));
        }
        til.addView(et);
        container.addView(til);
        edits.put(key, et);
    }
}
