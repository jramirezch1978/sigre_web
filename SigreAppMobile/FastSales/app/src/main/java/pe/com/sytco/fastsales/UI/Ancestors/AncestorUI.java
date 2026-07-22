package pe.com.sytco.fastsales.UI.Ancestors;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.Typeface;
import android.media.Image;
import android.text.InputType;
import android.util.TypedValue;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.TableRow;
import android.widget.TextView;

import androidx.core.content.ContextCompat;

import pe.com.sytco.fastsales.R;

public class AncestorUI {
    public static int heightRowDetailPx = 48;  // Reducido de 70 a 48 para filas más compactas
    public static int heightRowSummaryPx = 80;
    public static int heightImaggeButton = 48;  // Reducido de 70 a 48
    public static float widthImageFinal = 1024;

    protected Context context;

    public TextView createTextViewCenter(Integer aRow, String texto) {
        TextView tv = new TextView(this.context);
        //tv.setId(26 + aRow * 10);

        tv.setPadding(4, 2, 4, 2);  // Reducido padding vertical para filas más compactas
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.CENTER);
        tv.setHeight(AncestorUI.heightRowDetailPx);

        if (aRow % 2 == 0) {
            tv.setBackgroundResource(R.drawable.cell_shape_gray);
            tv.setTextColor(Color.WHITE);
        }else {
            tv.setBackgroundResource(R.drawable.cell_shape_yellow);
            tv.setTextColor(Color.BLACK);
        }

        tv.setText(texto);

        return tv;
    }

    public TextView createTextViewLeft(Integer aRow, String texto) {
        TextView tv = new TextView(this.context);
        //tv.setId(26 + aRow * 10);
        tv.setTextColor(Color.WHITE);

        tv.setPadding(4, 2, 4, 2);  // Reducido padding vertical para filas más compactas
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT);
        tv.setHeight(AncestorUI.heightRowDetailPx);

        if (aRow % 2 == 0) {
            tv.setBackgroundResource(R.drawable.cell_shape_gray);
            tv.setTextColor(Color.WHITE);
        }else {
            tv.setBackgroundResource(R.drawable.cell_shape_yellow);
            tv.setTextColor(Color.BLACK);
        }
        tv.setText(texto);

        return tv;
    }

    public TextView createTextViewRight(Integer aRow, String texto) {
        TextView tv = new TextView(this.context);
        //tv.setId(26 + aRow * 10);

        tv.setPadding(4, 2, 4, 2);  // Reducido padding vertical para filas más compactas
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.RIGHT);
        tv.setHeight(AncestorUI.heightRowDetailPx);

        if (aRow % 2 == 0) {
            tv.setBackgroundResource(R.drawable.cell_shape_gray);
            tv.setTextColor(Color.WHITE);
        }else {
            tv.setBackgroundResource(R.drawable.cell_shape_yellow);
            tv.setTextColor(Color.BLACK);
        }

        tv.setText(texto);

        return tv;
    }

    protected EditText createEditTextRight(Integer aRow, String texto, int inputType) {
        EditText editText = new EditText(this.context);
        //tv.setId(26 + aRow * 10);

        editText.setPadding(5, 5, 5, 5);
        editText.setGravity(Gravity.CENTER_VERTICAL | Gravity.RIGHT);
        editText.setHeight(AncestorUI.heightRowDetailPx);

        //if (aRow % 2 == 0) {
        //    editText.setBackgroundResource(R.drawable.cell_shape_gray);
        //    editText.setTextColor(Color.WHITE);
        //}else {
        //    editText.setBackgroundResource(R.drawable.cell_shape_yellow);
        //    editText.setTextColor(Color.BLACK);
        //}
        editText.setBackgroundResource(R.drawable.rounded_edit_text);
        editText.setTextSize(TypedValue.COMPLEX_UNIT_DIP, 16);
        editText.setInputType(inputType);
        editText.setTextColor(Color.BLACK);
        editText.setText(texto);

        return editText;
    }

    public TextView createSummaryRight(Integer aRow, String pTexto, int pIdInicial) {
        TextView tv = new TextView(this.context);
        tv.setId(pIdInicial + aRow * 10);

        tv.setTextColor(Color.BLUE);
        tv.setPadding(5, 5, 5, 5);
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.RIGHT);
        tv.setHeight(AncestorUI.heightRowSummaryPx);
        tv.setBackgroundResource(R.drawable.cell_shape_white);

        tv.setText(pTexto);
        tv.setTypeface(tv.getTypeface(), Typeface.BOLD);

        return tv;
    }

    public TextView createSummaryRight(String pTexto) {
        TextView tv = new TextView(this.context);

        tv.setTextColor(Color.BLUE);
        tv.setPadding(5, 5, 5, 5);
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.RIGHT);
        tv.setHeight(AncestorUI.heightRowSummaryPx);
        tv.setBackgroundResource(R.drawable.cell_shape_white);

        tv.setText(pTexto);
        tv.setTypeface(tv.getTypeface(), Typeface.BOLD);

        return tv;
    }

    public TextView createSummaryLeft(Integer aRow, String pTexto) {
        TextView tv = new TextView(this.context);
        //tv.setId(pIdInicial + aRow * 10);
        tv.setTextColor(Color.BLUE);
        tv.setPadding(5, 5, 5, 5);
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.LEFT);
        tv.setHeight(AncestorUI.heightRowSummaryPx);
        tv.setBackgroundResource(R.drawable.cell_shape_white);

        tv.setText(pTexto);
        tv.setTypeface(tv.getTypeface(), Typeface.BOLD);

        return tv;
    }

    public TextView createSummaryRight(Integer aRow, String pTexto) {
        TextView tv = new TextView(this.context);

        tv.setTextColor(Color.BLUE);
        tv.setPadding(5, 5, 5, 5);
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.RIGHT);
        tv.setHeight(AncestorUI.heightRowSummaryPx);
        tv.setBackgroundResource(R.drawable.cell_shape_white);

        tv.setText(pTexto);
        tv.setTypeface(tv.getTypeface(), Typeface.BOLD);

        return tv;
    }

    protected TextView createSummaryCenter(String pTexto) {
        TextView tv = new TextView(this.context);

        tv.setTextColor(Color.BLUE);
        tv.setPadding(5, 5, 5, 5);
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.CENTER_HORIZONTAL);
        tv.setHeight(AncestorUI.heightRowSummaryPx);
        tv.setBackgroundResource(R.drawable.cell_shape_white);

        tv.setText(pTexto);
        tv.setTypeface(tv.getTypeface(), Typeface.BOLD);

        return tv;
    }

    public View createHeaderTV(int pID, String pTexto) {

        TextView tv = new TextView(this.context);
        tv.setId(pID);// define id that must be unique
        tv.setText(pTexto); // set the text for the header
        tv.setTextColor(Color.WHITE); // set the color
        tv.setPadding(5, 5, 5, 5); // set the padding (if required)
        tv.setGravity(Gravity.CENTER_VERTICAL | Gravity.CENTER_HORIZONTAL);
        tv.setBackgroundResource(R.drawable.cell_shape_header);

        //tv.setLayoutParams(new ViewGroup.LayoutParams(
        //        ViewGroup.LayoutParams.MATCH_PARENT,
        //        ViewGroup.LayoutParams.MATCH_PARENT));

        return tv;
    }

    public void rowFocusChanged(TRowClass aTRowClass, TableRow atrRow, ImageButton abView, Integer aiRow) {

        if (aTRowClass != null){
            if (aTRowClass._trRowSelected != null && aTRowClass._iiRowSelected != null && aTRowClass._iiRowSelected > 0){
                for (int li_j = 0; li_j < aTRowClass._trRowSelected.getChildCount(); li_j++) {
                    if (aTRowClass._trRowSelected.getChildAt(li_j) instanceof TextView) {
                        TextView tvTemp = (TextView) aTRowClass._trRowSelected.getChildAt(li_j);

                        if (aTRowClass._iiRowSelected % 2 == 0) {
                            tvTemp.setBackgroundResource(R.drawable.cell_shape_gray);
                            tvTemp.setTextColor(Color.WHITE);
                        }else {
                            tvTemp.setBackgroundResource(R.drawable.cell_shape_yellow);
                            tvTemp.setTextColor(Color.BLACK);
                        }
                    }else if (aTRowClass._trRowSelected.getChildAt(li_j) instanceof ImageView) {
                        ImageView ivImage = (ImageView) aTRowClass._trRowSelected.getChildAt(li_j);

                        if (aTRowClass._iiRowSelected % 2 == 0) {
                            ivImage.setBackgroundResource(R.drawable.cell_shape_gray);

                        }else {
                            ivImage.setBackgroundResource(R.drawable.cell_shape_yellow);

                        }
                    }
                }


            }

            if(aTRowClass._ibButtonSelected != null){
                setImageResource(aTRowClass._ibButtonSelected, R.drawable.rombo);
            }

        }

        //rowClass = new TRowClass(atrRow, abView, aiRow);
        //ParteIngresoUI._rowSelected = rowClass;

        //Cambio el color para que este seleccionado
        selectRow(atrRow);

        //Cambio la imagen
        setImageResource(abView, R.drawable.flecha_derecha_icono);
    }

    public void selectRow(TableRow atrRow) {
        for (int li_j = 0; li_j < atrRow.getChildCount(); li_j++) {
            if (atrRow.getChildAt(li_j) instanceof TextView) {
                TextView tvTemp = (TextView) atrRow.getChildAt(li_j);
                tvTemp.setBackgroundResource(R.drawable.cell_shape);
                tvTemp.setTextColor(Color.WHITE);
            }else if (atrRow.getChildAt(li_j) instanceof ImageView) {
                ImageView ivImage = (ImageView) atrRow.getChildAt(li_j);
                ivImage.setBackgroundResource(R.drawable.cell_shape);
            }
        }
    }

    public void setImageResource(ImageButton aibValue, int valueResource) {
        Integer li_Width, li_Height;

        Bitmap bmp= BitmapFactory.decodeResource(context.getResources(), valueResource);

        li_Height=AncestorUI.heightImaggeButton - 5;

        //Obtengo el ancho segun la proporcion
        li_Width = (int) ((float)li_Height * (float)bmp.getWidth() / (float)bmp.getHeight());

        Bitmap resizedbitmap=Bitmap.createScaledBitmap(bmp, li_Width, li_Height, true);

        if (aibValue != null)
            aibValue.setImageBitmap(resizedbitmap);
    }

    public ImageButton createImmageButton(int Id, int valueResource) {
        ImageButton ibReturn = null;
        TableRow.LayoutParams ltr_layout = null;
        ViewGroup.LayoutParams lvg_layout = null;
        Integer li_Width, li_Height;

        ibReturn = new ImageButton(this.context);
        ibReturn.setId(Id);

        Bitmap bmp= BitmapFactory.decodeResource(context.getResources(), valueResource);

        li_Height=AncestorUI.heightImaggeButton - 5;
        //Obtengo el ancho segun la proporcion
        li_Width = (int) ((float)li_Height * (float)bmp.getWidth() / (float)bmp.getHeight());

        Bitmap resizedbitmap=Bitmap.createScaledBitmap(bmp, li_Width, li_Height, true);

        ibReturn.setImageBitmap(resizedbitmap);

        ltr_layout = new TableRow.LayoutParams();
        ltr_layout.setMargins(0, 0, 0, 0);
        ltr_layout.gravity=Gravity.CENTER_HORIZONTAL | Gravity.CENTER_VERTICAL;

        ibReturn.setLayoutParams(ltr_layout);
        ibReturn.setBackgroundResource(R.drawable.image_border);

        lvg_layout = ibReturn.getLayoutParams();

        lvg_layout.height = AncestorUI.heightImaggeButton;
        //Nuevo Ancho
        li_Width = (int) ((float)AncestorUI.heightImaggeButton * (float)bmp.getWidth() / (float)bmp.getHeight());
        lvg_layout.width = li_Width;

        ibReturn.setLayoutParams(lvg_layout);
        //ibFoto.setScaleType(ImageView.ScaleType.);

        ibReturn.setBackgroundColor(ContextCompat.getColor(context, R.color.transparente));

        return ibReturn;
    }

    public ImageButton createImmageButton(int valueResource) {
        ImageButton ibReturn = null;
        TableRow.LayoutParams ltr_layout = null;
        ViewGroup.LayoutParams lvg_layout = null;
        Integer li_Width, li_Height;

        ibReturn = new ImageButton(this.context);

        Bitmap bmp= BitmapFactory.decodeResource(context.getResources(), valueResource);

        li_Height=AncestorUI.heightImaggeButton - 5;
        //Obtengo el ancho segun la proporcion
        li_Width = (int) ((float)li_Height * (float)bmp.getWidth() / (float)bmp.getHeight());

        Bitmap resizedbitmap=Bitmap.createScaledBitmap(bmp, li_Width, li_Height, true);

        ibReturn.setImageBitmap(resizedbitmap);

        ltr_layout = new TableRow.LayoutParams();
        ltr_layout.setMargins(0, 0, 0, 0);
        ltr_layout.gravity=Gravity.CENTER_HORIZONTAL | Gravity.CENTER_VERTICAL;

        ibReturn.setLayoutParams(ltr_layout);
        ibReturn.setBackgroundResource(R.drawable.image_border);

        lvg_layout = ibReturn.getLayoutParams();

        lvg_layout.height = AncestorUI.heightImaggeButton;
        //Nuevo Ancho
        li_Width = (int) ((float)AncestorUI.heightImaggeButton * (float)bmp.getWidth() / (float)bmp.getHeight());
        lvg_layout.width = li_Width;

        ibReturn.setLayoutParams(lvg_layout);
        //ibFoto.setScaleType(ImageView.ScaleType.);

        ibReturn.setBackgroundColor(ContextCompat.getColor(context, R.color.transparente));

        return ibReturn;
    }

    public ImageView createImageViewCenter(Integer aRow, byte[] imagen) {
        ImageView ivImagen = null;
        TableRow.LayoutParams ltr_layout = null;
        ViewGroup.LayoutParams lvg_layout = null;
        Bitmap OldBitmap = null, resizedbitmap = null;
        Integer li_Width, li_Height;

        ivImagen = new ImageButton(this.context);

        if (imagen != null){
            OldBitmap = BitmapFactory.decodeByteArray(imagen, 0, imagen.length);

        }else{
            OldBitmap = BitmapFactory.decodeResource(context.getResources(), R.drawable.noimagen);

        }

        li_Height = AncestorUI.heightImaggeButton - 5;
        //Obtengo el ancho segun la proporcion
        li_Width = (int) ((float)li_Height * (float)OldBitmap.getWidth() / (float)OldBitmap.getHeight());

        resizedbitmap=Bitmap.createScaledBitmap(OldBitmap, li_Width, li_Height, true);

        ivImagen.setImageBitmap(resizedbitmap);

        ltr_layout = new TableRow.LayoutParams();
        ltr_layout.setMargins(0, 0, 0, 0);
        ltr_layout.gravity=Gravity.CENTER_HORIZONTAL | Gravity.CENTER_VERTICAL;

        ivImagen.setLayoutParams(ltr_layout);
        ivImagen.setBackgroundResource(R.drawable.image_border);

        lvg_layout = ivImagen.getLayoutParams();
        lvg_layout.height = AncestorUI.heightImaggeButton;

        //Nuevo Ancho
        li_Width = (int) ((float)AncestorUI.heightImaggeButton * (float)OldBitmap.getWidth() / (float)OldBitmap.getHeight());

        lvg_layout.width = li_Width;

        ivImagen.setLayoutParams(lvg_layout);
        ivImagen.setBackgroundColor(ContextCompat.getColor(context, R.color.transparente));



        return ivImagen;
    }



}
