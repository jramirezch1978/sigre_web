package pe.com.hermes.appmobile.ui.compras;

import android.content.Context;
import android.text.InputType;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import com.google.android.material.textfield.TextInputEditText;
import com.google.android.material.textfield.TextInputLayout;
import java.util.LinkedHashMap;
import java.util.Map;
import pe.com.hermes.appmobile.data.compras.ComprasFuenteDatos;

public final class ComprasFormHelper {

    private ComprasFormHelper() {}

    public static boolean permiteAlta(ComprasFuenteDatos f) {
        return f != null && f != ComprasFuenteDatos.NONE;
    }

    public static Map<String, TextInputEditText> construirCampos(
            Context ctx, LinearLayout container, ComprasFuenteDatos fuente, Map<String, String> valores) {
        container.removeAllViews();
        Map<String, TextInputEditText> edits = new LinkedHashMap<>();
        switch (fuente) {
            case TIPOS_PROVEEDOR -> {
                add(ctx, container, edits, "tipo", "Tipo", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "descripcion", "Descripción", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "flagEstado", "Estado (1/0)", InputType.TYPE_CLASS_NUMBER, valores);
            }
            case PROVEEDORES -> {
                add(ctx, container, edits, "razonSocial", "Razón social", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "nombreComercial", "Nombre comercial", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "tipoDocIdentidadId", "Tipo doc. ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "nroDocumento", "N° documento", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "direccion", "Dirección", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "telefono", "Teléfono", InputType.TYPE_CLASS_PHONE, valores);
                add(ctx, container, edits, "email", "Email", InputType.TYPE_TEXT_VARIATION_EMAIL_ADDRESS, valores);
                add(ctx, container, edits, "tipoEntidadContribuyenteId", "Tipo proveedor ID",
                        InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "esCliente", "También cliente (true/false)", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "flagEstado", "Estado (1/0)", InputType.TYPE_CLASS_NUMBER, valores);
            }
            case MARCAS, COLORES -> {
                add(ctx, container, edits, "codigo", "Código", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "nombre", "Nombre", InputType.TYPE_CLASS_TEXT, valores);
            }
            case CLASES_ARTICULO -> {
                add(ctx, container, edits, "codClase", "Código clase", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "descClase", "Descripción", InputType.TYPE_CLASS_TEXT, valores);
            }
            case CATEGORIAS -> {
                add(ctx, container, edits, "catArt", "Código categoría", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "descCateg", "Descripción", InputType.TYPE_CLASS_TEXT, valores);
            }
            case SUB_CATEGORIAS -> {
                add(ctx, container, edits, "codSubCat", "Código subcategoría", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "descSubcateg", "Descripción", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "articuloCategId", "Categoría ID", InputType.TYPE_CLASS_NUMBER, valores);
            }
            case ARTICULOS -> {
                add(ctx, container, edits, "codigo", "Código", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "nombre", "Nombre", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "tipo", "Tipo (B/S/...)", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "descripcion", "Descripción", InputType.TYPE_CLASS_TEXT, valores);
                add(ctx, container, edits, "unidadMedidaId", "Unidad medida ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "articuloCategId", "Categoría ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "articuloSubCategId", "Subcategoría ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "articuloClaseId", "Clase ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "marcaId", "Marca ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "colorId", "Color ID", InputType.TYPE_CLASS_NUMBER, valores);
                add(ctx, container, edits, "flagEstado", "Estado (1/0)", InputType.TYPE_CLASS_NUMBER, valores);
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
        if (valores != null && valores.get(key) != null) et.setText(valores.get(key));
        til.addView(et);
        container.addView(til);
        edits.put(key, et);
    }
}
