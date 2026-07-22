package pe.com.sytco.fastsales.Dialog;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import org.kobjects.util.Util;

import java.util.List;

import pe.com.sytco.fastsales.Dialog.ancestor.DialogAncestor;
import pe.com.sytco.fastsales.R;
import pe.com.sytco.fastsales.UI.DialogSugerenciasUI;
import pe.com.sytco.fastsales.beans.ParteIngreso.BeanSugerencias;
import pe.com.sytco.fastsales.beans.ancestor.BeanAncestor;
import pe.com.sytco.fastsales.util.MessageBox;
import pe.com.sytco.fastsales.util.UTIL;

public class DialogSugerencias extends DialogAncestor {

    private List<BeanSugerencias> listadoSugerencias = null;
    DialogSugerenciasUI dialogSugerenciasUI = null;

    //Obtengo la fila seleccionada
    BeanSugerencias _beanSelected = null;

    private Button btnCancelar, btnAceptar;

    //Controles interfaz para llenar segun las sugerencias
    private TextView tvDesSuela, tvDescAcabado, tvDescColor1, tvDescColor2,
            tvDescTaco, tvDescUnidad, tvDescClase, tvDescLinea, tvDescSubLinea;

    private EditText etSuela, etAcabado, etColor1, etColor2, etTaco, etUnidad,
            etClase, etTallaMin, etTallaMax, etLinea, etSubLinea;

    private ImageView ivImagenRef;

    private DialogSugerencias(){

    }

    public DialogSugerencias(View pLayoutReference, List<BeanSugerencias> listado) {
        super();
        this.context = pLayoutReference.getContext();
        this.layoutReference = pLayoutReference;
        this.listadoSugerencias = listado;

    }

    public void openDialog() {

        builder = new AlertDialog.Builder(context);

        LayoutInflater inflater = ((Activity)context).getLayoutInflater();

        dialogLayout = inflater.inflate(R.layout.dialog_sugerencias, null);

        InitControllers();

        AsignarEventos();

        builder.setView(dialogLayout);

        //Creo el cuadro de dialogo
        builder.setCancelable(false);

        dialogMain = builder.create();

        //Activo la opcion de cierre
        btnCancelar.setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {

                        dialogMain.dismiss();
                    }
                }
        );

        LoadData();


    }

    protected void InitControllers() {
        //Objeto encargado de dibujar la UI
        dialogSugerenciasUI = new DialogSugerenciasUI(context, dialogLayout, listadoSugerencias);

        btnCancelar = (Button) dialogLayout.findViewById(R.id.btnCancelar);
        btnAceptar = (Button) dialogLayout.findViewById(R.id.btnAceptar);

        InitControllersReference();


    }

    private void InitControllersReference() {
        //Controles de la interfaz de referencia
        //EditText
        etLinea = (EditText) layoutReference.findViewById(R.id.etLinea);
        etSubLinea = (EditText) layoutReference.findViewById(R.id.etSubLinea);
        etSuela = (EditText) layoutReference.findViewById(R.id.etSuela);
        etAcabado = (EditText) layoutReference.findViewById(R.id.etAcabado);
        etColor1 = (EditText) layoutReference.findViewById(R.id.etColor1);
        etColor2 = (EditText) layoutReference.findViewById(R.id.etColor2);
        etTaco = (EditText) layoutReference.findViewById(R.id.etTaco);
        etUnidad = (EditText) layoutReference.findViewById(R.id.etUnidad);
        etClase = (EditText) layoutReference.findViewById(R.id.etClase);
        etTallaMin = (EditText) layoutReference.findViewById(R.id.etTallaMin);
        etTallaMax = (EditText) layoutReference.findViewById(R.id.etTallaMax);

        //TextView
        tvDescLinea = (TextView) layoutReference.findViewById(R.id.tvDescLinea);
        tvDescSubLinea = (TextView) layoutReference.findViewById(R.id.tvDescSubLinea);
        tvDesSuela = (TextView) layoutReference.findViewById(R.id.tvDescSuela);
        tvDescAcabado = (TextView) layoutReference.findViewById(R.id.tvDescAcabado);
        tvDescColor1 = (TextView) layoutReference.findViewById(R.id.tvDescColor1);
        tvDescColor2 = (TextView) layoutReference.findViewById(R.id.tvDescColor2);
        tvDescTaco = (TextView) layoutReference.findViewById(R.id.tvDescTaco);
        tvDescUnidad = (TextView) layoutReference.findViewById(R.id.tvDescUnidad);
        tvDescClase = (TextView) layoutReference.findViewById(R.id.tvDescClase);

        //ImageView
        ivImagenRef = (ImageView) layoutReference.findViewById(R.id.ivImagen);
    }

    protected void AsignarEventos() {
        btnAceptar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                
                procesarRowSelected();

            }
        });

    }

    private void procesarRowSelected() {

        for(BeanSugerencias obj : listadoSugerencias){
            if (obj.getSelected()) {
                _beanSelected = obj;
                break;
            }
        }

        if (_beanSelected == null){
            MessageBox.AlertDialog(context, "Error", "No ha seleccionado ninguna sugerencia, por favor verifique!", false);
            return;
        }

        if (_beanSelected.getCodLinea() == null){
            MessageBox.AlertDialog(context, "Error", "No hay codigo de Linea del registro seleccionado, por favor verifique!", false);
            return;
        }

        //InitControllersReference();

        //Si hay un registro seleccionado entonces procedo a llenar los datos necesarios
        etLinea.setText(_beanSelected.getCodLinea());
        tvDescLinea.setText(_beanSelected.getDescLinea());

        etSubLinea.setText(_beanSelected.getCodSubLinea());
        tvDescSubLinea.setText(_beanSelected.getDescSubLinea());

        etSuela.setText(_beanSelected.getCodSuela());
        tvDesSuela.setText(_beanSelected.getDescSuela());

        etAcabado.setText(_beanSelected.getCodAcabado());
        tvDescAcabado.setText(_beanSelected.getDescAcabado());

        etColor1.setText(_beanSelected.getCodColor1());
        tvDescColor1.setText(_beanSelected.getDescColor1());

        etColor2.setText(_beanSelected.getCodColor2());
        tvDescColor2.setText(_beanSelected.getDescColor2());

        etTaco.setText(_beanSelected.getCodTaco());
        tvDescTaco.setText(_beanSelected.getDescTaco());

        etUnidad.setText(_beanSelected.getUnd());
        tvDescUnidad.setText(_beanSelected.getDescUnidad());

        etClase.setText(_beanSelected.getCodClase());
        tvDescClase.setText(_beanSelected.getDescClase());

        etTallaMin.setText(UTIL.ConvetToString(_beanSelected.getTallaMin(), "###,##0"));
        etTallaMax.setText(UTIL.ConvetToString(_beanSelected.getTallaMax(), "###,##0"));

        if (_beanSelected.getImagenBlob() != null){
            UTIL.setImageViewWithByteArray(ivImagenRef, _beanSelected.getImagenBlob());
        }else{
            ivImagenRef.setImageResource(R.drawable.noimagen);
        }

        dialogMain.dismiss();

    }

    public void LoadData() {
        if(this.isFirstTime()){
            showDialog();

            dialogSugerenciasUI.drawTableSugerencias();
        }
    }
}
